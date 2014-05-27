%set up networks
maxT = 18;
bias = -1;
epochs =500;
eta = .01;
ecrit = .1;
nInput = 4;
nOutput = 3;
nHid = 50;

%[ItoH1 CtoH1 HtoO1] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasfor);
[HidRec1 OutRec1 pass Errors1 ErrNorms1 ErrorPercents1] = ckSRNstatsAll(ItoH1,CtoH1,HtoO1,bias,datasfor,nInput,nOutput,nHid,maxT);
[itemCor1 posCor1] = ckSRNunitCorrelations(datasfor,HidRec1,maxT/2,2);
[dcurves1] = ckSRNdistances(HidRec1,datasfor);

%[ItoH2 CtoH2 HtoO2] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasback);
[HidRec2 OutRec2 pass Errors2 ErrNorms2 ErrorPercents2] = ckSRNstatsAll(ItoH2,CtoH2,HtoO2,bias,datasback,nInput,nOutput,nHid,maxT);
[itemCor2 posCor2] = ckSRNunitCorrelations(datasback,HidRec2,maxT/2,2);
[dcurves2] = ckSRNdistances(HidRec2,datasback);

%[ItoH3 CtoH3 HtoO3] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datacmix);
[HidRec3 OutRec3 pass Errors3 ErrNorms3 ErrorPercents3] = ckSRNstatsAll(ItoH3,CtoH3,HtoO3,bias,datacmix,nInput,nOutput,nHid,maxT);
[itemCor3 posCor3] = ckSRNunitCorrelations(datacmix,HidRec3,maxT/2,2);
[dcurves3] = ckSRNdistances(HidRec3,datacmix);

%[ItoH4 CtoH4 HtoO4] = ckSRNTrainer(100,500,@ckSRNtrainFeeder,@ckSRNtrainFeeder,nInput,nOutput,nHid,maxT,eta,epochs,bias,ecrit,datasmix);
[HidRec4 OutRec4 pass Errors4 ErrNorms4 ErrorPercents4] = ckSRNstatsAll(ItoH4,CtoH4,HtoO4,bias,datasmix,nInput,nOutput,nHid,maxT);
[itemCor4 posCor4] = ckSRNunitCorrelations(datasmix,HidRec4,maxT/2,2);
[dcurves4] = ckSRNdistances(HidRec4,datasmix);


    
    
    

