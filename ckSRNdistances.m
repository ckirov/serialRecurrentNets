function [dcurves] = ckSRNdistances(HidRec,dataset)

%length of strings
depth = (size(dataset,2)-1)/4;
dcurves = zeros(depth,depth);
dcurvesN = dcurves+.000000001;

%handle length 1
subset = find(dataset(:,end)==1*2);
dcurves(1,1) = distance(HidRec(subset(1),1,:),HidRec(subset(2),1,:));
dcurvesN(1,1) = 1;

%for each length
for i = 2:depth,
    %for each depth
    for j = 1:i-1,
        %loop through prefixes using binlist
        prefixes = binlist(i)+1;
        dcurvesN(i,j) = dcurvesN(i,j) + size(prefixes,1);
        for k = 1:size(prefixes,1),
            %find all strings with a particular prefix
            prefix = prefixes(k);
            withprefix = zeros(2,1);
            for l = 1:size(dataset,1),
                %if string matches prefix
                idx = strfind(dataset(l,:),[prefix 1]);
                if ~isempty(idx) && idx(1) == 1,
                    withprefix(1) = l;
                    break;
                end;  
            end;
            for l = 1:size(dataset,1),
                %if string matches prefix
                idx = strfind(dataset(l,:),[prefix 2]);
                if ~isempty(idx) && idx(1) == 1,
                    withprefix(2) = l;
                    break;
                end;  
            end;
            %get pairwise distances between them and add to curve
            dcurves(i,j) = dcurves(i,j) + distance(HidRec(withprefix(1),j+1,:),HidRec(withprefix(2),j+1,:));
        end;
        
    end;
end;

dcurves = dcurves./dcurvesN;

