function [Sim sA index]= AffConstruction(Data, EuDis, GorL, Sigma, Afftype)

nrow=size(Data,1);

if strcmp(Afftype,'Ani') 
    Sim = AniDiffuSim(Data, GorL, Sigma);
elseif strcmp(Afftype,'Gau')
    Sim = Gaussian(EuDis, GorL,Sigma);
elseif strcmp(Afftype,'Vol')
    Sim = Volcano(EuDis, Sigma);
elseif strcmp(Afftype,'Rev')
    Sim = Reverse(EuDis);
elseif strcmp(Afftype,'Cos')
    Sim = ConsineSimilarity(Data);
end

%Sim=Sim.*(ones(nrow,nrow)-eye(nrow));
%Sim=Sim.*(ones(nrow,nrow)-eye(nrow))+eye(nrow);
%Sim(Sim(:)<0)=0;
Sim=Sim-diag(diag(Sim));
[sA,index] = sort(Sim,2,'descend'); 


end