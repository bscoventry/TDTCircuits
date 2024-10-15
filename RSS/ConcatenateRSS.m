
RSS_Current = [];

for i = 1:length(rss(:,1))
    RSS_Current = [RSS_Current zeros(1,floor(97656.25*.1)) rss(i,:) zeros(1,floor(97656.25*.2))];
end

% SF = .0287479787288035;   % 70dB
% SF = 0.00909090909090910;   % 60dB
SF = 0.00287479787288029;   % 50dB

RSS_Current = (RSS_Current/max(RSS_Current)).*SF;