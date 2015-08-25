%% Using symmetrically normalised matrix

% Dependency to Zelnik-Manor's self-tuning code

%% Load data

load 2moons;
data.X = x;
data.Y = y;

n = size(data.X,1);

alpha = 0.99;
sigma = 0.35;

[data.L, ~] = vsComputeLaplacian(data.X,[],15);

% Specify the labelled flag. In this demo I set a few queries. The method should
% work with just one query in practice.
%probe = [14 18 20 56 178];
probe = find(x(:,1)<-0.75);
r = zeros(n,1);
r(probe) = 1; 


%% Use a close form solution
f_star = (eye(n) - alpha*data.L)\r;

figure;
hold on;
scatter(x(:,1),x(:,2),20,f_star,'filled');
plot(x(r==1,1),x(r==1,2),'bo','markersize',10);
title('Closed form');
box on;
hold off;

% Save figure in pdf, you would need ghostscript on your path to run this
savefig('closed_form','pdf','-r600');

%% Use iterative optimisation
nIter = 1000;

% Specify the initial score
if 0
    f_init = zeros(n,1)+0.1; % random starting point won't work well
else
    %%W = dist2(data.X, data.X);
    W = squareform(pdist(data.X));
    Atemp = exp(-W.^2/(2*sigma^2));
    f_init = Atemp(probe(1),:)'; % select the affinity vector of a random positive as starting point
end

f_star = vsLabelPropagate(f_init,alpha,data.L,r,nIter);

figure;
hold on;
scatter(x(:,1),x(:,2),20,f_star,'filled');
plot(x(r==1,1),x(r==1,2),'bo','markersize',10);
title('Iterative');
box on;
hold off;

% Save figure in pdf, you would need ghostscript on your path to run this
savefig('iterative','pdf','-r600');