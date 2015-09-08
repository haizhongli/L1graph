%% Compute Cosine Affinitity Matrix
function [Aff] = CompCosSim(XXi)
%% XXi: Original data (n*m matrix, n:number of instant; m: number of attributes/dimensions)

[n m] = size(XXi);

XN = sqrt(sum(XXi.*XXi, 2));
XXN = XXi ./ (XN * ones(1,m));
Aff = XXN * XXN';

end
