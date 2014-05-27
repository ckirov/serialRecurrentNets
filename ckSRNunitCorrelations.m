%we want to correlate item with item (only 2 by 2)
%we want to correlate position with position
function [itemCor posCor] = ckSRNunitCorrelations(dataset,HidRec,depth,alphabet)

%item with item encoding/encoding,output/output
itemCor = zeros(3,alphabet,alphabet);
itemCorN = itemCor+.000000001;


%pos correlation encoding/encoding,output/output
posCor = zeros(3,depth,depth);
posCorN  = posCor+.000000001;

%loop over examples
for j = 1:size(dataset,1),
    %get info about the example
    [TestInput t] = ckSRNextractInput(dataset(j,:));
    TestTarget = ckSRNextractTarget(dataset(j,:));
    
    %position in string vars
    fposa = 1;
    bposa = t/2;
    for k = 1:t,
        fposb = 1;
        bposb = t/2;
        for l = 1:t,
            %encoding encoding
            if k < t/2 && l < t/2,
                syma = TestInput(k);
                symb = TestInput(l);
                posa = k;
                posb = l;
                type = 1;
            %encoding decoding
            elseif k < t/2 && l > t/2,
                syma = TestInput(k);
                symb = TestTarget(l);
                posa = k;
                posb = fposb;
                if TestInput(l) == 3, posb = bposb; end;
                type = 2;
            elseif k > t/2 && l < t/2,
                syma = TestTarget(k);
                symb = TestInput(l);
                posa = fposa;
                if TestInput(k) == 3, posa = bposa; end;
                posb = l;
                type = 2;      
            %decoding decoding
            else
                syma = TestTarget(k);
                symb = TestTarget(l);
                posa = fposa;
                if TestInput(k) == 3, posa = bposa; end;
                posb = fposb;
                if TestInput(l) == 3, posb = bposb; end;
                type = 3;
            end;
            if TestInput(l) == 3,
                bposb = bposb-1;
            elseif TestInput(l) == 4,
                fposb = fposb+1;
            end;
            r = corrcoef(HidRec(j,k,:),HidRec(j,l,:));
            r = r(1,2);
            itemCor(type,syma,symb) = itemCor(type,syma,symb) + r;
            itemCorN(type,syma.symb) = itemCorN(type,syma,symb)+1;
            posCor(type,posa,posb) = posCor(type,posa,posb) + r;
            posCorN(type,posa,posb) = posCorN(type,posa,posb)+1;
        end;
        if TestInput(k) == 3,
            bposa = bposa-1;
        elseif TestInput(k) == 4,
            fposa = fposa+1;
        end;
    end;
end;
    
itemCor = itemCor./itemCorN;
posCor = posCor./posCorN;