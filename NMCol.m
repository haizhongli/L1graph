function nA = NMCol(A)
%% normalize the column of matrix A
nA = bsxfun(@rdivide,A,sqrt(sum(A.^2,1)));
nA(~isfinite(nA)) = 0;
end