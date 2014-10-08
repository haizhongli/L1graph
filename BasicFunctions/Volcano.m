
function Sim  = Volcano(EuDis, Sigma)


  [nrow]=size(EuDis,1);
  Sim = zeros(nrow,nrow);


for i = 1 : nrow
    for j = i : nrow
        if EuDis(i,j)<=1
            Sim(i,j)=Sigma;
        else
            Sim(i,j)=Sigma*exp(-EuDis(i,j)+1);
        end
    end
end

Sim=max(Sim,Sim');
    
end