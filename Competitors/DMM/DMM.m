function [D V]=DMM(Aff1,k,t,Wstep,NormType1,AHK)


nrow=size(Aff1,1);
Aff1(Aff1(:)<0)=0;
%Aff1=Aff1.*(ones(nrow,nrow)-eye(nrow));
Aff1=NormalizationFamily(Aff1,NormType1); % Random walk normalization
Aff1 = HeatKernel(Aff1, AHK,t); 
%Aff1=Aff1.*(ones(nrow,nrow)-eye(nrow));
        
%Aff1(Aff1(:)<0)=0;
Aff1=kNN(Aff1,k);
% Aff1=DJSTRA_multiply(Aff1,Wstep);
% Aff2=NormalizationFamily(Aff1,NormType2);
% [V, D]=eig(full(Aff2));
[V, D]=DiffusionMaps2(Aff1,Wstep);