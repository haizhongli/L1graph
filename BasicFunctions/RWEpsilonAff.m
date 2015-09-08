function NSim=RWEpsilonAff(Sim,Epsilon)

% D=degree(Sim);
% SumD=sum(sum(D,1));
% 
% 
W=NormPositiveRW(Sim); % probabilized the Sim matrix
W(W(:)<=Epsilon)=0;
NSim=Sim;
NSim(W(:)==0)=0;

end