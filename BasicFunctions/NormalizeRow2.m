%% normalize row, the 2 norm summation equals to 1;

function M = NormalizeRow2 (M)


[N,K] = size(M);
for i=1:N
  mk = M(i,:);        
  mk=mk.^2;
  summk = sum(mk);
  summk=sqrt(summk);
  M(i,:) = M(i,:) ./ summk;
end

end