function [S] = RandomWalk(A,type)
% calculate following matrix from adjacent matrix A
% 1. Diffusion with given steps, (markov chain)
% 2. PageRank with alpah
% 3. HeatKernelPage Rank
%
% input:
%   A  --  adjacent matrix, weighted, undirected.
%   type -- options:  'diffusion', 'pagerank', 'heatkernelrank'.
%
% output:
%   S  -- weighted matrix
%
%

 if type == 'diffusion'
    S = NMRow(A); 
 elseif type == 'pagerank'
 
 elseif type == 'heatkernelrank'

 end


end