function [HidRec OutRec OutStrings ErrCurve ErrNorm ErrTotal] = ckSRNstatsAll(ItoH, CtoH, HtoO, bias, dataset,nInput,nOutput,nHid,maxT)

%want error by position, error by string position, error by distance from
%encoding separate ones for for and back and in general and total error too

%init units
Hid = zeros(nHid,maxT+1);
Iota1 = Hid;
Output = zeros(nOutput,maxT+1);
Iota2 = Output;
Iota3 = Output;
inTemp = zeros(nInput,1);

%record of hidden activations and errors
HidRec = zeros(size(dataset,1),maxT,nHid);
OutRec = zeros(size(dataset,1),maxT,nOutput);
OutStrings = dataset*0;

%(for,back,gen)X(spos,pos,dfe)X(glengths)X(indlengths)
ErrCurve = zeros(3,3,maxT,maxT);
ErrNorm = ErrCurve+.000000001;

%measure error/test
%for each example
for j = 1:size(dataset,1),
%for j = 1:5,
    %get info about the example
    [TestInput t] = ckSRNextractInput(dataset(j,:));
    TestTarget = ckSRNextractTarget(dataset(j,:));
    
    %position in string vars
    fdfe = t/2;
    bdfe = 1-t/2;
    fpos = 1;
    bpos = t/2;

    %forward pass
    [Output Hid Iota1 Iota2 Iota3] = ckSRNForwardPass(TestInput,t,ItoH,CtoH,HtoO,bias,Hid,Output,inTemp,Iota1,Iota2, Iota3);
    HidRec(j,:,:) = Hid(:,2:end)';
    OutRec(j,:,:) = Output(:,2:end)';
    
    for k = 1:t,
        out = find(Output(:,k+1) == max(Output(:,k+1)),1,'first');
        in = TestInput(k);
        OutStrings(j,k) = out;
        targ = TestTarget(k);

        %fill out errnorm         
         %b
         if in == 3,
             ErrNorm([2 3],1,t,k) = ErrNorm([2 3],1,t,k) +1; 
             ErrNorm([2 3],2,t,bpos) = ErrNorm([2 3],2,t,bpos) +1; 
             ErrNorm([2 3],3,t,bdfe) = ErrNorm([2 3],3,t,bdfe) +1;
         %f
         elseif in == 4,
             ErrNorm([1 3],1,t,k) = ErrNorm([1 3],1,t,k) +1; 
             ErrNorm([1 3],2,t,fpos) = ErrNorm([1 3],2,t,fpos) +1; 
             ErrNorm([1 3],3,t,fdfe) = ErrNorm([1 3],3,t,fdfe) +1; 
         %beginning of string
         else
             ErrNorm(:,1,t,k) = ErrNorm(:,1,t,k)+1; 
         end;   
        
        %fill out errcurve
        if targ ~= out && k>t/2,
            OutStrings(j,end) = 1; %indicate error
            %b
            if in == 3,
                ErrCurve([2 3],1,t,k) = ErrCurve([2 3],1,t,k) +1; 
                ErrCurve([2 3],2,t,bpos) = ErrCurve([2 3],2,t,bpos) +1; 
                ErrCurve([2 3],3,t,bdfe) = ErrCurve([2 3],3,t,bdfe) +1; 
            %f
            elseif in == 4,
                ErrCurve([1 3],1,t,k) = ErrCurve([1 3],1,t,k) +1; 
                ErrCurve([1 3],2,t,fpos) = ErrCurve([1 3],2,t,fpos) +1; 
                ErrCurve([1 3],3,t,fdfe) = ErrCurve([1 3],3,t,fdfe) +1; 
            %beginning of string
            else
             ErrCurve(:,1,t,k) = ErrNorm(:,1,t,k)+1; 
            end;   
        end;
        if in == 3,
            bpos = bpos-1;
        elseif in == 4,
            fpos = fpos+1;
        end;
        bdfe = bdfe+1;
    end;
end;
%normalize
%ErrCurve = ErrCurve./ErrNorm;
ErrTotal = sum(OutStrings(:,end))/size(dataset,1);

  

    
    
   
    