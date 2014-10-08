function NSim=kNN(Sim,k)

% D=degree(Sim);
% SumD=sum(sum(D,1));
% 
% 

[sA,index] = sort(Sim,2,'descend'); 
nrow=size(Sim,1);
NSim=zeros(nrow,nrow);
parfor i = 1: nrow
    %k=min(10*nrow.*D(i,i)./SumD,nrow-1);
%     if Sig(i)>=5
%         k=5;
%     elseif Sig(i)>=2
%         k=15;
%     else
%         k=30;
%     end
    for j = 1 : nrow
        if any(index(i,1:k+1)==j)
            NSim(i,j)=Sim(i,j);
        else
            NSim(i,j)=0;
        end
    end
end

%NSim=max(NSim,NSim');

end