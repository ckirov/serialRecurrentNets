function [ItoH CtoH HtoO] = ckSRNTrainer(nTestPerEpoch,nTrainPerEpoch,trainFeeder,testFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,dataset)

%init units
Hid = zeros(nHid,maxT+1);
Iota1 = Hid;
Output = zeros(nOutput,maxT+1);
Iota2 = Output;
Iota3 = Output;
inTemp = zeros(nInput,1);
outTemp = zeros(nOutput,1);

%init weights and deltas
ItoH = rand(nHid,nInput)-.5;
dItoH = ItoH;
CtoH = .05*(rand(nHid,nHid)-.5);
dCtoH = CtoH;
HtoO = rand(nOutput,nHid)-.5;
dHtoO = HtoO;

%for each epoch
for i = 1:epochs,
    %train
    %for each example
    for j = 1:nTrainPerEpoch,
        %get sample
        [TrainInput TrainTarget t] = trainFeeder(dataset,maxT);
        
        %forward pass
        [Output Hid Iota1 Iota2 Iota3] = ckSRNForwardPass(TrainInput,t,ItoH,CtoH,HtoO,bias,Hid,Output,inTemp, Iota1,Iota2,Iota3);
        
        %backward pass
        [dItoH dCtoH dHtoO] = ckSRNBackwardPass(TrainInput,TrainTarget,t,ItoH,dItoH,CtoH,dCtoH,HtoO,dHtoO,bias,Hid,Output,inTemp,outTemp,nHid,Iota1,Iota2,Iota3);
        %update weights
        ItoH = ItoH - eta*dItoH;
        CtoH = CtoH - eta*dCtoH;
        HtoO = HtoO - eta*dHtoO;
    end;
    %measure error/test
    %for each example
    nwrong = 0;
    for j = 1:nTestPerEpoch,
        %get info about the example
        [TestInput TestTarget t] = testFeeder(dataset,maxT);
        %forward pass
        [Output Hid Iota1 Iota2 Iota3] = ckSRNForwardPass(TestInput,t,ItoH,CtoH,HtoO,bias,Hid,Output,inTemp,Iota1,Iota2, Iota3);
        for k = (t/2+1):t,
            %Output(:,k+1)
            out = find(Output(:,k+1) == max(Output(:,k+1)),1,'first');
            targ = TestTarget(k);
            if targ ~= out,
                nwrong = nwrong+1;
                break;
            end;
        end;
    end;
    %print temporary results
    fprintf('Epoch %d, Error %f\n',i,nwrong/nTestPerEpoch);
    %if results are good enough stop
    if nwrong/nTestPerEpoch < ecrit,
        return;
    end;     
end;
    
    
   
    