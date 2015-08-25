%% Using unnormalised Laplacian matrix

% Read http://personal.ie.cuhk.edu.hk/~ccloy/files/icip_2013.pdf
% to understand the pros and cons of using normalised and unnormalised
% laplacian matrix

% Dependency to Zelnik-Manor's self-tuning code

%% Load data

load 2moons;
data.X = x;
data.Y = y;

n = size(data.X,1);

mparam = 2; 
alpha = 0.99;
sigma = 0.35;

[~,~,data.L] = vsComputeLaplacian(data.X,[],15);

% Specify the labelled flag. In this demo I set a few queries. The method should
% work with just one query in practice.
%probe = [14 18 20 56 178];
probe = find(x(:,1)<-0.75);
r = zeros(n,1);
r(probe) = 1; 


%% Use a close form solution

% c.f. Eqn 5 in http://personal.ie.cuhk.edu.hk/~ccloy/files/icip_2013.pdf
beta = (1 - alpha)/alpha;
f_star = (inv(beta*eye(n) + data.L).^mparam) * r;

figure;
hold on;
scatter(x(:,1),x(:,2),20,f_star,'filled');
plot(x(r==1,1),x(r==1,2),'bo','markersize',10);
title('Closed form');
box on;
hold off;



