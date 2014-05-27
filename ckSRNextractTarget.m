function [target t] = ckSRNextractTarget(line)

depth = (length(line)-1)/4;
t = line(end);
target = [line(2*depth+1:2*depth+t/2) line(3*depth+1:3*depth+t/2)];

