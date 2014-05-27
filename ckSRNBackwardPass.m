function [dItoH dCtoH dHtoO] = ckSRNBackwardPass(input,target,t,ItoH,dItoH,CtoH,dCtoH,HtoO,dHtoO,bias,Hid,Output,inTemp,outTemp,nHid,Iota1,Iota2,Iota3)

%set up message to send back in time
dCdH = zeros(nHid,1);

%reset deltas
dItoH = dItoH*0;
dCtoH = dCtoH*0;
dHtoO = dHtoO*0;
for k = t:-1:1,
    inTemp = inTemp*0;
    outTemp = outTemp*0;
    inTemp(input(k)) = 1;
    outTemp(target(k)) = 1;
    dEdsoftmax = Output(:,k+1)-outTemp; %(3x1)
    %ignore first half of string since those outputs don't matter
    if k <= t/2, dEdsoftmax = dEdsoftmax*0;end;
    %dsoftmaxdtansig = softmax('dn',Iota3(:,k+1));
    dsoftmaxdtansig = dEdsoftmax;
    %dsoftmaxdtansig = dsoftmaxdtansig{1,1}*dEdsoftmax; %(3x1)
    %dtansigdIota2 = tansig('dn',Iota2(:,k+1)).*dsoftmaxdtansig; %(3x1)
    dtansigdIota2 = dsoftmaxdtansig;
    dIota2dW2 = dtansigdIota2*Hid(:,k+1)';%(3xnHid)
    dHtoO = dHtoO + dIota2dW2;
    
    dIota2dtansig = HtoO'*dtansigdIota2; %(nHidx4)(4x1)=(nHidx1) 
    
    dtansigdIota1 = tansig('dn',Iota1(:,k+1)).*dIota2dtansig+tansig('dn',Iota1(:,k+1)).*dCdH; %(nHidx1)
    
    dIota1dW1 = dtansigdIota1*inTemp'; %(nHidx4)
    
    dItoH = dItoH + dIota1dW1;
    
    dIota1dW3 =  dtansigdIota1*Hid(:,k)';
    
    dCtoH = dCtoH + dIota1dW3;
    
    dCdH = CtoH'*dtansigdIota1;
    
end;