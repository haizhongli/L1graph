% calcualte the Graph Diffusion 
%
%
%

%% cosine similarity matrix
%% variable: G_cos
matrix = {'G_cos', 'G_fixed'};
T = 10;

for i = 1:length(matrix)

adj_sim = eval(matrix{i});
    
D = diag ( 1 ./ sum(adj_sim,1));

%% random walk matrix 
P = adj_sim*D;

%% graph diffusion
%% the following code need to be improved.
for step =1:T
    alpha = 1/(step+1);
    F = alpha*P^0;
    for j = 1:step
      F = F + alpha*P^j;
    end
    fname = sprintf('%s_F%d.mat',matrix{i},step);
    save(fname,'F');
end

end