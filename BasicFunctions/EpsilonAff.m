function NSim=EpsilonAff(Sim,Epsilon)

% D=degree(Sim);
% SumD=sum(sum(D,1));
% 
% 

NSim=Sim;
NSim(NSim(:)<=Epsilon)=0;

end