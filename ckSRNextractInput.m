function [input t] = ckSRNextractInput(line)

depth = (length(line)-1)/4;
t = line(end);
input = [line(1:t/2) line(depth+1:depth+t/2)];