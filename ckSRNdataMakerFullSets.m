function dataset = ckSRNdataMakerFullSets(depth,task)

%3 is back cue
%4 is front cue
%3 is null output

%create full strings based on task
switch task
    %pure repetition
    case 1
        total = sum(2.^(1:depth));
        dataset = zeros(total,depth*4+1);
        s = 1;
        for i = 1:depth,
            %how many strings at this depth?
            n = 2^i;
            %get base
            base = binlist(i)+1;
            %set strings
            dataset(s:s+n-1,1:i) = base;
            %set output cues
            dataset(s:s+n-1,(depth+1):(depth+i)) = 3;
            %set null outputs
            dataset(s:s+n-1,(2*depth+1):(2*depth+i)) = 3;
            %set reverse
            dataset(s:s+n-1,(3*depth+1):(3*depth+i)) = base(:,end:-1:1);
            %set length
            dataset(s:s+n-1,end) = i*2;
            s = s+n;
        end;
    %pure forward
    case 2
        total = sum(2.^(1:depth));
        dataset = zeros(total,depth*4+1);
        s = 1;
        for i = 1:depth,
            %how many strings at this depth?
            n = 2^i;
            %get base
            base = binlist(i)+1;
            %set strings
            dataset(s:s+n-1,1:i) = base;
            %set output cues
            dataset(s:s+n-1,(depth+1):(depth+i)) = 4;
            %set null outputs
            dataset(s:s+n-1,(2*depth+1):(2*depth+i)) = 3;
            %set reverse
            dataset(s:s+n-1,(3*depth+1):(3*depth+i)) = base;
            %set length
            dataset(s:s+n-1,end) = i*2;
            s = s+n;
        end;
    %mixed forward and backward
    case 3
        total = sum((2.^(1:depth)).^2);
        dataset = zeros(total,depth*4+1);
        s = 1;
        for i = 1:depth,
            %how many strings at this depth?
            n = (2^i)^2;
            %get base
            base = binlist(i)+1;
            %get cue set
            cues = repmat(binlist(i)+3,sqrt(n),1);
            %set strings
            for j = 1:sqrt(n),
                dataset(s+(j-1)*sqrt(n):s+j*sqrt(n)-1,1:i) = repmat(base(j,:),sqrt(n),1);
            end;
            %set output cues
            dataset(s:s+n-1,(depth+1):(depth+i)) = cues;
            %set null outputs
            dataset(s:s+n-1,(2*depth+1):(2*depth+i)) = 3;
            %set length
            dataset(s:s+n-1,end) = i*2;
            s = s+n;
        end;
        %set actual outputs
        for i = 1:total,
            slen = dataset(i,end)/2;
            b = slen;
            f = 1;
            for j=1:slen,
                if dataset(i,2*depth+j) == 4,
                    dataset(i,3*depth+j) = dataset(i,f);
                    f = f+1;
                else
                    dataset(i,3*depth+j) = dataset(i,b);
                    b = b-1;
                end;
            end;
        end;
    %sometimes full forward, sometimes full backward
    case 4
        dataset = [ckSRNdataMakerFullSets(depth,1); ckSRNdataMakerFullSets(depth,2)];
end;




