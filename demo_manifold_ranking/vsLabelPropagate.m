function f_star = vsLabelPropagate(f_init,alpha,L,r,niter)
% Iterative optimisation for manifold ranking

% f_init = initial rank score
% alpha = specify the relative contributions to the ranking scores from
% neighbours and the initial ranking scores
% L = graph Laplacian
% r = labelled flag 1 if labelled 0 otherwise
% niter = number of iterations


f_star = f_init;
for i = 1:niter
    f_star = alpha*L*f_star + (1-alpha)*r;
end