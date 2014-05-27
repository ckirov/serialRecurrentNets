function [input target t] = ckSRNtestFeeder(dataset,maxT)

%pick length
depth = randi(maxT/2);
%depth = 3;

%pick string of that length
temp = dataset(dataset(:,end)==2*depth,:);
line = temp(randi(size(temp,1)),:);
[input t] = ckSRNextractInput(line);
target = ckSRNextractTarget(line);