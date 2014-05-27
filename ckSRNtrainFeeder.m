function [input target t] = ckSRNtrainFeeder(dataset,maxT)

%pick length
weights = exppdf(1:maxT/2,maxT/2/2);
depth = randsample(maxT/2,1,true,weights);
%depth = randi(7);

%get string of that length
temp = dataset(dataset(:,end)==2*depth,:);
line = temp(randi(size(temp,1)),:);
%line = dataset(1,:); %FOR TESTING
[input t] = ckSRNextractInput(line);
target = ckSRNextractTarget(line);