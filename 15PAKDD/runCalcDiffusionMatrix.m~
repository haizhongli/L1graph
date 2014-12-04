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
%% creat a array of matrix
AP = zeros(size(P,1),size(P,2),T+1);
AP(:,:,1) = P^0;
for step = 2:T+1
    AP(:,:,step) = P*AP(:,:,step-1);
end

F = zeros(size(P,1),size(P,2),T);
for step =1:T
    alpha = 1/(step+1);
    F(:,:,step) = alpha*AP(:,:,1);
    for j = 1:step
      F(:,:,step) = F(:,:,step) + alpha*AP(:,:,step+1);
    end
end

fname = sprintf('%s_F.mat',matrix{i});
save(fname,'F');

end