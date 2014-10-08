function W = NormPositiveRW(Sim)
% nrow=max(size(Sim));
% Sim=Sim.*(ones(nrow,nrow)-diag(nrow));
nrow = size(Sim,1);
D = degree (Sim);
Dinv=zeros(nrow,nrow);
for i=1:nrow
    if D(i,i)<=0
        Dinv(i,i)=0;
    else
        Dinv(i,i)=D(i,i).^(-1);
    end
end
W= Dinv*(Sim);
% W= W+diag(nrow);
