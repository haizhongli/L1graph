
function Sim  = Gaussian(EuDis, GorL,Sigma)
%% Gaussian Affinity
% EuDis=L2_distance(XXi',XXi',1);  %% To compute Euclidean distance
f=1;
d=2;
if  ((GorL==0))
    Sim = exp (   -((EuDis).^d)  ./ (f*(Sigma.^1))  );   
elseif ((GorL==1))
    LocalScale=LocalScaling(EuDis,Sigma);
    LocalScale=(LocalScale*LocalScale').^(1/2);
    Sim=exp   (   -((EuDis).^d)  ./ (f*(LocalScale.^d)) );
elseif ((GorL==2))
    LocalScale=LocalScaling(EuDis,Sigma);
    LocalScale=mean(LocalScale(:));
    Sim=exp   (   -((EuDis).^d)  ./ ((f*(LocalScale.^d))) );
else
    error('Unsupported GorL');
end
%Sim=min(Sim,Sim');

Sim=Sim-diag(diag(Sim));