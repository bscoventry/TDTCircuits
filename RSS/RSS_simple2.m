function [rss,ampvec,ampscale,phaselist,ampdev2,range]=RSS_simple2(cf,numstim,tpo,bw,duration,levelSD);
% function [rss,ampvec,ampscale,phaselist,avhold,ampdev,ampdev2]=RSS_simple2(cf,numstim,tpo,bw,duration,levelSD);
% this function will create an RSS stimulus set with user defined
% parameters
% cf is center frequency in Hz
% numstim is number of RSS stimuli. 80 is a good starting point 
% tpo is tones per octave. unlike Barbour and Wang, bins per octave were
% not used. 40 tpo is a good starting point
% bw is bandwidth in octaves. Note that the total bandwidth is double the
% bw. 1.5 or 2 for bw is a good starting point, giving a 3 or 4 octave
% range.
% duration is the stimulus duration in milliseconds
% level SD is the mean standard deviation of sound level for each frequency
% bin, in dB
% rss is the matrix containing the RSS stimuli
% ampvec is the matrix of amplitude deviations from the mean for each RSS
% stimulus and each frequency bin, in dB
% ampscale is the same as ampvec but a linear scale for scaling stimuli
% phaselist is the list of starting phases for each frequency bin, same for
% each RSS stimulus, but random across different runs
% ampdev2 is the mean deviation in amplitude for each frequency bin. It's
% set up to be close to zero (but not exactly zero).
% range is the range of deviations in level from max to min in dB.



% cf=6000; %cf in Hz
% numstim=80; %number of different spectral profiles
% numstim=80;
rise_fall_time=5;
% probe_duration=200; %in milliseconds
probe_duration=duration; %in milliseconds
fs=97656.25; %sampling rate in Hz
% tpo=40; %tones per octave
binvec=-bw:1/tpo:bw; %location of frequency bins +/- 1.5 octaves
logbins=2.^binvec;
freqvec=cf*logbins; %vector of frequencies in Hz
numfreq=length(freqvec);
toohind=find(freqvec>44000); %limit of TDT frequencies for 100k sampling
tooloind=find(freqvec<750);
% zind=find(binvec==min(abs(binvec))); %find index where freqvec at or nearest
zind=0; % center of frequency range, but no BF
% to cf
% ampstep=.25; %amplitude step log10 step (e.g 1=10^1)
ampstep=1;
% cfampvec=-.5:ampstep:2; %this will be sound level at cf
cfampvec=1; %Not varying level as a first pass, May 2014
logamp=10.^cfampvec; %amplitude scaling
dblist=20*log10(logamp)
NP_probe  =  ceil(probe_duration/1000*fs); %number of points in tone
tvec=1/fs:1/fs:NP_probe/fs; %time vector
% NP_masker =  ceil(masker_duration/1000*SR);
phaselist=2*pi*rand(numfreq,1); %set of random phases for each tone
NPR = rise_fall_time / 1000*fs;  % number of points for rising envelope
NPR=round(NPR);
W1 = (0:NPR)/NPR; %linear rise of tone
W2 = fliplr(W1); %linear fall
% tonetemp(1,1:NP_probe)=sin(2*pi*cf*tvec+phaselist(61));
tonevec=zeros(1,NP_probe);
% levelSD=12; %12 dB standard deviation of level, comparable to Yu and Young 2013
for i=1:numstim
    if i<numstim
        avtemp=[]; avtemp=levelSD*randn(length(freqvec),1);
        
%         avtemp2=[]; avtemp2=avtemp/20; avtemp2=10.^avtemp2;
    elseif i==numstim
        avtemp(1:length(freqvec))=0; %flat stimulus
%         avtemp2(1:length(freqvec))=1; %flat stimulus
    end
    avhold(i,1:length(freqvec))=avtemp; %vector of db amplitudes in each frequency bin
    ampvec(i,1:length(freqvec))=avtemp; %this is in dB
%     ampscale(i,1:length(freqvec))=avtemp2; %this is the linear scaling factor
end

ampdev=mean(ampvec,1); %this is the mean deviation for each frequency bin over all stimuli

for i=1:numstim
    if i<numstim
        avtemp3=[]; avtemp3=avhold(i,:)-ampdev;
        %add mean deviation ampdev to frequency vector such that overall
        %deviation = 0 for each frequency bin, averaged across stimuli. 
        avtemp2=[]; avtemp2=avtemp3/20; avtemp2=10.^avtemp2;
    elseif i==numstim
        avtemp3(1:length(freqvec))=0; %flat stimulus
        avtemp2(1:length(freqvec))=1; %flat stimulus
    end
    ampvec(i,1:length(freqvec))=avtemp3; %this is in dB
    ampscale(i,1:length(freqvec))=avtemp2; %this is the linear scaling factor
end
ampdev2=mean(ampvec,1);
for i=1:length(ampdev2); 
    range(i)=max(ampvec(:,i))-min(ampvec(:,i)); 
end
% centcfvec=zind-5:zind+5; %set 3 center bins in this case to be changed in amplitude
centcfvec=zind; %sets number of center bins near cf to modulate for contrast
%from 1 single tone to higher
for j=1:numstim
    for i=1:length(freqvec)
        %     if i<min(centcfvec) | i>max(centcfvec) %leave out 3 cf frequencies for now
        %         if i~=zind %leave out cf frequency for now
        tonetemp=[];
        tonetemp=sin(2*pi*freqvec(i)*tvec+phaselist(i)); %create frequency vector
        tonetemp=tonetemp*ampscale(j,i);
        tonevec=tonevec+tonetemp; %add it to overall total
        %     end
    end
    lopeak=find(tonevec<(mean(tonevec)-3.1*std(tonevec))); %id large neg points
    hipeak=find(tonevec>(mean(tonevec)+3.1*std(tonevec))); %id large pos points
    %3.1 SD corresponds to p<.001
    if ~isempty(lopeak)
        tonevec(lopeak)=mean(tonevec)-3.1*std(tonevec); %set outliers at mean-3.1*SD
    end
    if ~isempty(hipeak)
        tonevec(hipeak)=mean(tonevec)+3.1*std(tonevec); %set outliers at mean+3.1*SD
    end
    tonevec=tonevec/rms(tonevec); %normalize by rms, which should maintain overall scaling
    %but should allow for larger peaks in some stimuli
    tonevec(1:NPR+1) = tonevec(1:NPR+1).*W1;   % put in onset
    tonevec(NP_probe-NPR:NP_probe) = tonevec(NP_probe-NPR:NP_probe).*W2;  %put in offset
    rss(j,1:length(tonevec))=tonevec;
end





subplot(2,3,1)
spectrogram(rss(numstim,:),4000,2000,[],fs)
xlim([min(freqvec)-250 max(freqvec)+250])
% xlim([cf-250 cf+250])
subplot(2,3,2)
plot(tvec,rss(numstim,:),'b-')
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2,3,3)
bar(freqvec,ampvec(numstim,:))
xlabel('Frequency (Hz)');
ylabel('Deviation from mean level (dB)');
subplot(2,3,4)
spectrogram(rss(round(numstim/2),:),6000,3000,[],fs)
xlim([min(freqvec)-250 max(freqvec)+250])
% xlim([cf-250 cf+250])
subplot(2,3,5)
plot(tvec,rss(round(numstim/2),:),'b-')
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2,3,6)
bar(freqvec,ampvec(round(numstim/2),:))
xlabel('Frequency (Hz)');
ylabel('Deviation from mean level (dB)');
% %
% for i=1:numstim
%     filename=[];
%     if i<10
%         filename=strcat('rss.','00',num2str(i));
%     elseif i>=10 & i<=99
%         filename=strcat('rss.','0',num2str(i));
%     elseif i>=100
%         filename=strcat('rss.',num2str(i));
%     end
%     wavwrite(rss(i,:),fs,filename)
% end




% for i=1:length(ampvec)
%
%     tonevec(zind,:)=ampvec(i)*tonevec(zind,:); %scales CF tone relative to others in log scale
%     tonestim(i,1:NP_probe)=sum(tonevec,1); %sum each column
%     tonestim(i,1:NP_probe)=tonestim(i,1:NP_probe)/max(abs(tonestim(i,1:NP_probe))); %normalize to 1
%     tonevec(zind,:)=1/ampvec(i)*tonevec(zind,:); %restore amplitude of tonevec(zind) to 1
% end

% tonevec(zind,:)=1/ampvec(i)*tonevec(zind,:); %restore amplitude of tonevec(zind) to 1



% %--------------------------------------------------------
% % Generate probe
% %--------------------------------------------------------
% % f = ones(1,NP_probe)*probe_CF*1000;
% % f = f/NQ*2 - 1;
% % max(f)
% % min(f)
% % f=f./max(abs(f));
% phi=0;
% % FMmoddepth1=200; FMmodfreq1=20;
% tvec=1/SR:1/SR:NP_probe/SR;
% % phi=FMmoddepth1*probe_CF/FMmodfreq1+FMmoddepth1*probe_CF/FMmodfreq1*cos(2*pi*FMmodfreq1*tvec);
% % % phi=FMmoddepth1+FMmoddepth1*cos(2*pi*FMmodfreq1*tvec);
% % y=sin(2*pi*probe_CF*tvec+phi);
% y(1:length(tvec))=randn(length(tvec),1); %noise carrier
% y(find(abs(y)>=3.5))=mean(abs(y)); %removes large transient >3.5 from mean, or p<1/4000
%
% % figure
% % plot(tvec,y)
% % AMmod1=.5*(1-AMmoddepth1*cos(2*pi*AMmodfq1*tvec/1000+.01));
% AMmod1=.5*(1-AMmoddepth1*cos(2*pi*AMmodfq1*tvec+.01));
% AMmod1=AMmod1/max(AMmod1); %normalization
% y=AMmod1.*y;
% %y=y/max(y); %normalization
% y(1:NPR+1) = y(1:NPR+1).*W1;   % put in onset
% y(NP_probe-NPR:NP_probe) = y(NP_probe-NPR:NP_probe).*W2;  %put in offset
% y1=y;
% wave1=y;
% y=[]; f=[];
