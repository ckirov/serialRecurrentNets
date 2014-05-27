function [Output Hid Iota1 Iota2 Iota3] = ckSRNForwardPass(input,t,ItoH,CtoH,HtoO,bias,Hid,Output,inTemp,Iota1,Iota2,Iota3)

%forward pass
for k = 1:t,
    inTemp = inTemp*0;
    inTemp(input(k)) = 1;
    %get hiddens
    Iota1(:,k+1) = ItoH*inTemp + CtoH*Hid(:,k) + bias;
    Hid(:,k+1) = tansig(Iota1(:,k+1));
    %get outputs
    Iota2(:,k+1) = HtoO*Hid(:,k+1);
    %Iota3(:,k+1) = tansig(Iota2(:,k+1));
    %Output(:,k+1) = softmax(Iota3(:,k+1));
    Output(:,k+1) = Iota2(:,k+1);
end;
        