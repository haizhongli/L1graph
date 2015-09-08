
function Sim  = DensityAffinity(EuDis, CNN, GorL,sigma)
%% Gaussian Affinity
% EuDis=L2_distance(XXi',XXi',1);  %% To compute Euclidean distance

if  ((GorL==0))
    Sigma =  sigma;   
elseif ((GorL==1))
    LocalScale=LocalScaling(EuDis,sigma);
    LocalScale=(LocalScale*LocalScale').^(1/2);
    Sigma = LocalScale;
elseif ((GorL==2))
    LocalScale=LocalScaling(EuDis,sigma);
    LocalScale=mean(LocalScale(:));
    Sigma = LocalScale;
else
    error('Unsupported GorL');
end

realsigma = (CNN+1).*(2 * (Sigma.^2));


Sim = exp (   -(EuDis.^2)  ./ (realsigma)  );   

Sim=Sim-diag(diag(Sim));


%Sim=min(Sim,Sim');