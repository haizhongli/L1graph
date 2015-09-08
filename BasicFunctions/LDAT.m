function NSim=LDAT(Sim, k)

%Sim=Sim-diag(diag(Sim));
%Sim(Sim(:)<0)=0;

if k>0
    Sim=kNN(Sim, k); % only keep distance in kNN and all the other pair-similarity as 0 
end

NSim=Sim;
clear Sim;

%   NSim=NormPositiveRW(NSim); % probabilized the Sim matrix
%   NSim=min(NSim,NSim');  % only keep the minimal value among symmetric position
%    NSim=NormPositiveRW(NSim);
%      NSim=min(NSim,NSim');  % only keep the minimal value among symmetric position
%    NSim=NormPositiveRW(NSim);
%      NSim=min(NSim,NSim');  % only keep the minimal value among symmetric position
%    NSim=NormPositiveRW(NSim);
%     Wmax=max(W,W');  % 
%     ind= find(Wmax(:)>=Wmin(:));
%     Wnew=max(Wmax-alpha*(Wmax-Wmin), 0);
%     W(ind)=Wnew(ind);
%     %W=max(Wmax-alpha*(Wmax-Wmin), 0);
%      W=NormPositiveRW(W);  % probabilized the Sim matrix again
    
    NSim=NormPositiveRW(NSim); % probabilized the Sim matrix
    NSim=min(NSim,NSim');  % only keep the minimal value among symmetric position
%     NSim=NSim-1/k;%
%     NSim(NSim(:)<0)=0;
    NSim=NormPositiveRW(NSim);  % probabilized the Sim matrix again
    




%NSim=NormPositiveRW(Sim);
%NSim=min(NSim,NSim');

