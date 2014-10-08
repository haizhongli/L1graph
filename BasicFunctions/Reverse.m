
function Sim  = Reverse(Data)


  [nrow, ncol]=size(Data);
  Sim = zeros(nrow,nrow);
   EuDis = CompED (Data);
   MaxDis=max(EuDis(:));
   MinDis=min(EuDis(:));

for i = 1 : nrow
    for j = i : nrow
        if MaxDis~=MinDis
            Sim(i,j)=(MaxDis-EuDis(i,j))/(MaxDis-MinDis);
        else 
            Sim(i,j)=0;
        end
    end
end

Sim=max(Sim,Sim');
Sim=Sim.*(ones(nrow,nrow)-eye(nrow));
    
end