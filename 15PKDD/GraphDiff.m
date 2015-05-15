function [F] = GraphDiff(W,T)
%% calculate the graph diffusion of W with T steps;
%% W -- adjacent matrix
%% T -- steps
%%
adj_sim = myGaussianMedian(W);
D = diag ( 1 ./ sum(adj_sim,1));

%% random walk matrix 
P = adj_sim*D;

%% graph diffusion
F = zeros(size(adj_sim));
for i = 1:T
   F = F + (1/T)*P;
   P = P*P;
end
end