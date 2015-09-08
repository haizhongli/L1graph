function M = ConsineSimilarity(A)


%[x,y] = size(data);
%ndata = norm(data);
%data = data ./ (ndata * ones(x ,1));
%simm = data * data';

EA = sqrt(sum(A.^2,2));


% this is 10x faster
M = (A*A')./(EA*EA');

