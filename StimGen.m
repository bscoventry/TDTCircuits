
SpkrCal = [1 2.27
.95 2.14   
.9 2.02
.85 1.91
.8 1.81
.75 1.72
.7 1.57
.65 1.5
.6 1.38
.55 1.28
.5 1.17
.45 1.07
.4 .950
.35 .850
.3 .740
.25 .640
.2 .49
.15 .45
.1 .336
.05 .232
.025 .120
.02 .081
.015 .049
.01 .040
.005 .036
.0025 .033
.001 .018
.0005 .022
.0001 .017];

% gives the approximate equation

TDT_Volts = 0.00002*10^(desired_dB/20)/2.2;




%% FRA (dB levels 30:20:70) 4 repetitions

clear all;
clc

Levels = [0.000287479787287999,0.00287479787288029,0.0287479787288035];
Freqs = [1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 ...
    2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 ...
    4000 4400 4800 5200 5600 6000 6400 6800 7200 7600 ...
    8000 8800 9600 10400 11200 12000 12800 13600 14400 15200 ...
    16000 17600 19200 20800 22400 24000 25600 27200 28800 30400 32000];

count=0;
for i = 1:length(Levels)
    for j = 1:length(Freqs)
        count = count+1;
        StimVec(count,:) = [Levels(i) Freqs(j)];
    end
end

taskrands1 = randperm(length(StimVec));
taskrands2 = randperm(length(StimVec));
taskrands3 = randperm(length(StimVec));
taskrands4 = randperm(length(StimVec));

for i=1:length(StimVec)
    Final(i,:) = StimVec(taskrands1(i),:);
    Final(i+length(StimVec),:) = StimVec(taskrands2(i),:);
    Final(i+2*length(StimVec),:) = StimVec(taskrands3(i),:);
    Final(i+3*length(StimVec),:) = StimVec(taskrands4(i),:);
end


%% Rate/Level (dB levels 20:5:80) 4 repetitions

clear all;
clc

Levels = [9.09090909090998e-05,0.000161661764548994,0.000287479787287999,0.000511219386536699,0.000909090909090894,0.00161661764548990,0.00287479787288029,0.00511219386536680,0.00909090909090910,0.0161661764548993,0.0287479787288035,0.0511219386536680,0.0909090909090910];

count=0;
for i = 1:length(Levels)
        count = count+1;
        StimVec(count,1) = [Levels(i)];
end

taskrands1 = randperm(length(StimVec));
taskrands2 = randperm(length(StimVec));
taskrands3 = randperm(length(StimVec));
taskrands4 = randperm(length(StimVec));

for i=1:length(StimVec)
    Final(i,:) = StimVec(taskrands1(i),:);
    Final(i+length(StimVec),:) = StimVec(taskrands2(i),:);
    Final(i+2*length(StimVec),:) = StimVec(taskrands3(i),:);
    Final(i+3*length(StimVec),:) = StimVec(taskrands4(i),:);
end


%% AM  (dB level 80) 4 repetitions

clear all;
clc

Freqs = [4 8 16 32 64 128 256 512 1024];

count=0;
for i = 1:length(Freqs)
        count = count+1;
        StimVec(count,1) = [Freqs(i)];
end

taskrands1 = randperm(length(StimVec));
taskrands2 = randperm(length(StimVec));
taskrands3 = randperm(length(StimVec));
taskrands4 = randperm(length(StimVec));

for i=1:length(StimVec)
    Final(i,:) = StimVec(taskrands1(i),:);
    Final(i+length(StimVec),:) = StimVec(taskrands2(i),:);
    Final(i+2*length(StimVec),:) = StimVec(taskrands3(i),:);
    Final(i+3*length(StimVec),:) = StimVec(taskrands4(i),:);
end


%% Two-Tone  (dB level 80) 4 repetitions of 0.1 8va steps around BF

clear all;
clc

Freqs = [.5 .55 .6 .65 .7 .75 .8 .85 .9 .95 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2];

count=0;
for i = 1:length(Freqs)
        count = count+1;
        StimVec(count,1) = [Freqs(i)];
end

taskrands1 = randperm(length(StimVec));
taskrands2 = randperm(length(StimVec));
taskrands3 = randperm(length(StimVec));
taskrands4 = randperm(length(StimVec));

for i=1:length(StimVec)
    Final(i,:) = StimVec(taskrands1(i),:);
    Final(i+length(StimVec),:) = StimVec(taskrands2(i),:);
    Final(i+2*length(StimVec),:) = StimVec(taskrands3(i),:);
    Final(i+3*length(StimVec),:) = StimVec(taskrands4(i),:);
end


%% Trains  (dB level 80) 4 repetitions of various freqs

clear all;
clc

% Freqs are in logic low time for rpvds - 2,4,8,16,32,64,128,200 HZ
Freqs = [497 247 122 60 30 15 7];

count=0;
for i = 1:length(Freqs)
        count = count+1;
        StimVec(count,1) = [Freqs(i)];
end

taskrands1 = randperm(length(StimVec));
taskrands2 = randperm(length(StimVec));
taskrands3 = randperm(length(StimVec));
taskrands4 = randperm(length(StimVec));

for i=1:length(StimVec)
    Final(i,:) = StimVec(taskrands1(i),:);
    Final(i+length(StimVec),:) = StimVec(taskrands2(i),:);
    Final(i+2*length(StimVec),:) = StimVec(taskrands3(i),:);
    Final(i+3*length(StimVec),:) = StimVec(taskrands4(i),:);
end
