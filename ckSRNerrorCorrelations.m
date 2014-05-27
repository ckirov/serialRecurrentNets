%we want to correlate error with error (back vs for)?
function [eCorr] = ckSRNerrorCorrelations(Errors,ErrNorms)

%number of networks
n = size(Errors,2);
%number of conditions to correlate
corDim = size(Errors,1)*size(Errors,3);
%normalize
Errors = Errors./ErrNorms;

%set up data structure
eCorr = zeros(size(Errors,5),corDim,corDim);


%loop over lengths
for l = 6:2:size(Errors,5),
    count = 1;
    curves = zeros(corDim,l/2);
    %loop over experiments
    for i = 1:size(Errors,1),
        %loop over for, back, gen
        for j = 1:3,
            %get pos
            k = 2;
            %pick out the data
            data = squeeze(Errors(i,:,j,k,l,1:l/2));
            %get the mean
            mdata = sum(data)/n;
            curves(count,:) = mdata;
            count = count+1;
        end;
    end;
    %fill in relevant parts of data structure
    for x = 1:corDim,
        for y = 1:corDim,
            r = corrcoef(curves(x,:),curves(y,:));
            r = r(1,2);
            eCorr(l,x,y) = r;
        end;
    end;
 end;