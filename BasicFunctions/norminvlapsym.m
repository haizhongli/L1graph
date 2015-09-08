% Creates a "symmetric" normalized Laplacian matrix N from W such as the one
% described in Spectral Graph Theory by Fan Chung and in Ng-Jordan-Weiss's
% spectral clustering paper. If W is sparse N will be sparse.
%
% Author: Frank Lin (frank@cs.cmu.edu)

function N=norminvlapsym(W)

Dinv=degree(W);
n=size(Dinv,1);

for i=1:n
  Dinv(i,i)=1/(sqrt(Dinv(i,i)));
  %Dinv(i,i)=1/(Dinv(i,i));
end

N=Dinv*W*Dinv;
%N=real(N);
%N=min(N,N');


end