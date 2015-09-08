function ED=CompED(X)

if(~isa(X,'double'))
    error('Inputs must be of type double');
end;

[n,m] =size(X);
x2rs = sum(X.^2, 2); % X.^2 row sum vector (nx1)
v1n = ones(1,n);     % multiplier
X2RM = x2rs * v1n;   % X square row matrix
ED = sqrt(X2RM + X2RM' - 2 * X * X');
%nrow=size(X,1);
%ED= ED-diag(diag(ED));
%ED=min(ED,ED');
