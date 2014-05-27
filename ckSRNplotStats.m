function ckSRNplotStats(Errors,ErrNorms)

%number of networks
n = size(Errors,2);
%normalize
Errors = Errors./ErrNorms;
%loop over experiments
for i = 1:size(Errors,1),
    %loop over for, back, gen
    for j = 1:3,
        %loop over spos, pos, dfe
        for k = 1:3,
            %loop over positions
            for l = 6:2:size(Errors,5),
                f = figure('Visible','off');
                %pick out the data
                data = squeeze(Errors(i,:,j,k,l,1:l/2));
                if k == 1,
                    data = squeeze(Errors(i,:,j,k,l,1+l/2:l/2+l/2));
                end;
                %get the mean
                mdata = sum(data)/n;
                %get the error bars
                sdata = (1.959964.*std(data))/sqrt(n);
                %plot and save
                errorbar(mdata,sdata,'k');
                name = ['SRN_' num2str(i) '_' num2str(j) '_' num2str(k) '_' num2str(l/2) '.jpg'];
                saveas(f,name);
                close(f);
            end;
        end;
    end;
end;
