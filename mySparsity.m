
function [d] = mySparsity(A)

E  = sum(sum(logical(A)));
V = size(A,1);
d = E / (V*(V-1));
end
