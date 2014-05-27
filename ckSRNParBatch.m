%set up parallelism
matlabpool

%how many experiments will be run
nexp = 6;

%how many networks to run
n = 10;

%create big structure to store experiment results
Errors = zeros(nexp,n,3,3,maxT,maxT);
ErrNorms = Errors;
ErrorPercents = zeros(nexp,n);

%set up networks
maxT = 18;
bias = -1;
epochs = 300;
eta = .01;
ecrit = .4;
nInput = 4;
nOutput = 3;
nHid = 50;

parfor i=1:n,
    %forward
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasfor);
    [pass pass pass Errors(1,i,:,:,:,:) ErrNorms(1,i,:,:,:,:) ErrorPercents(1,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datasfor,nInput,nOutput,nHid,maxT);
end;

parfor i=1:n,
    %backward
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasback);
    [pass pass pass Errors(2,i,:,:,:,:) ErrNorms(2,i,:,:,:,:) ErrorPercents(2,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datasback,nInput,nOutput,nHid,maxT);
end;
    
parfor i=1:n,
    %mixed mixed
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datacmix);
    [pass pass pass Errors(3,i,:,:,:,:) ErrNorms(3,i,:,:,:,:) ErrorPercents(3,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datacmix,nInput,nOutput,nHid,maxT);
end;
    
parfor i=1:n,
    %mixed mixed to simple mixed
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datacmix);
    [pass pass pass Errors(4,i,:,:,:,:) ErrNorms(4,i,:,:,:,:) ErrorPercents(4,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datasmix,nInput,nOutput,nHid,maxT);
end;
    
parfor i=1:n,
    %simple mixed
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasmix);
    [pass pass pass Errors(5,i,:,:,:,:) ErrNorms(5,i,:,:,:,:) ErrorPercents(5,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datasmix,nInput,nOutput,nHid,maxT);
end;
   
parfor i=1:n,
    %simple mixed to mixed mixed
    [ItoH CtoH HtoO] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasmix);
    [pass pass pass Errors(6,i,:,:,:,:) ErrNorms(6,i,:,:,:,:) ErrorPercents(6,i)] = ckSRNstatsAll(ItoH,CtoH,HtoO,bias,datacmix,nInput,nOutput,nHid,maxT);
end;
    
matlabpool close

