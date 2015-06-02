function c = Coherence(data)
% calculate the coherence of a data matrix, 
% u = max<data(i,),data(j,)>; i != j
%

data = NMRow(data);
coh_matrix = data*data';
coh_matrix(logical(eye(size(data,1)))) = 0;
c = max(max(coh_matrix));
end