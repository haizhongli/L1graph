function [C,f,g] = nbin(A,max_iter,verbose)
%NBIN General unsymmetric matrix binormalization.
%   or a general matrix A Input : * mxn matrix A
%
% * maximum number of sweeps (default = 10)
% * verbose mode flag (0=no printout, default; 1=printouts) Output : * The
% normalized matrix C = F*A*F
% * The row-scaling factors f = (f1...fm), column scaling factors g =
% (g1,...,gn).
TOL = 1e-10;
if (nargin < 2)
    max_iter = 100;
end
if (nargin < 3)
    verbose = 1;
end

[m,n] = size(A);
x = ones(m,1); % initial guess; x(i) = f(i)^2.
y = ones(n,1); % initial guess; y(i) = g(i)^2.
B = abs(A).^2;
C = B';
beta = B*y;
gamma = C*x;
sum1 = n;
sum2 = m;
std1 = full(sqrt(sum((x.*beta-sum1).^2)/m))/sum1;
std2 = full(sqrt(sum((y.*gamma-sum2).^2)/n))/sum2;
std_initial = sqrt(std1^2+std2^2);
std_n = std_initial;

if (verbose)
    fprintf('\nBINORMALIZTION - NBIN Algorithm\n\n');
    fprintf('Sweep STD RATE\n');
    fprintf('INITIAL %.3e\n',std_initial);
end

% The main loop over NBIN sweeps
for r = 1:max_iter
    x_old = x;
    y_old = y;

    % Below tolerance or convergence stalls due to round-off
    if (std_n < TOL)
        break;
    end

    x = sum1./beta;
    x(find(abs(beta) < eps)) = 1.0;
    gamma = C*x;
    y = sum2./gamma;
    y(find(abs(gamma) < eps)) = 1.0;
    beta = B*y;
    %%%%%% Compute convergence factors
    std_old = std_n;
    std_n = full(sqrt(sum((x.*beta-sum1).^2)/m))/sum1;
    conv_factor = std_n/std_old;

    if (verbose)
        fprintf('%3d %.3e %.3f\n',r,std_n,conv_factor);
    end
end

if (verbose)
    fprintf('\nAverage residual convergence rate: %.5f\n\n',(std_n/std_initial)^(1/r));
end

f = sqrt(abs (x));
g = sqrt(abs (y));
F = spdiags(f,0,m,m);
G = spdiags(g,0,n,n);
C = F*A*G;