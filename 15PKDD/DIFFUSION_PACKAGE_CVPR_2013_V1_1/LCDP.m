function [diffused_matrix,aff_matrix] = ICG_ApplyDiffusionProcess(diff_matrix,sigma,NR_OF_KNN,visualize)
% diffused_matrix = ICG_ApplyDiffusionProcess(diff_matrix,sigma,NR_OF_KNN,visualize)
%   ICG_ApplyDiffusionProcess applies the best performing diffusion process 
%   as analyzed in ICG_ExperimentCVPR2013_Section_4_1 to the distance matrix
%   See also ICG_ExperimentCVPR2013_Section_4_1
%
%   Parameter
%   ---------
%   diff_matrix ... NxN distance matrix (lower is more similar)
%   sigma ... Sigma value to use for normalization 
%           !!! Set to 0 if diff_matrix is affinity matrix
%           !!! Set to NaN or [] for automatic identification
%   NR_OF_KNN ... Number of KNN to consider
%   
%   For more details see:
%   "Diffusion Processes for Retrieval Revisited"
%   Michael Donoser and Horst Bischof
%   Proceedings of Conference on Computer Vision 
%   and Pattern Recognition (CVPR), 2013
%
%   ****************************************************************
%	Copyright by Michael Donoser 
%	Institute for Computer Graphics and Vision
%	Graz University of Technology
%   Please email to michael.donoser@tugraz.at 
%   if you find bugs, or have suggestions or questions!
%   Licensed under the Lesser GPL [see License/lgpl.txt]
%   ****************************************************************
    
    
    addpath('./HelpFunctions');
    addpath('./MinMaxSelection');
    if ~exist('maxk','file')
        % We require the efficient Min/Max selection tool by Bruno Luong
         unzip('http://www.mathworks.com/matlabcentral/fileexchange/23576-minmax-selection?download=true');
         addpath('./MinMaxSelection');
		 pause(1);
         minmax_install
    end
    
    if ~exist('NR_OF_KNN','var'),
        NR_OF_KNN = 10;
    end
    if ~exist('visualize','var'),
        visualize = false;
    end
    
    if ~exist('sigma','var') || isnan(sigma)
        aff_matrix = ICG_MatrixNormalization(diff_matrix);
    elseif (sigma == 0)
        % If sigma == 0 then it is an affinity matrix
        aff_matrix = diff_matrix;
    elseif (sigma ~= 0)
        aff_matrix = exp((-(diff_matrix.^2)) * (2*(sigma^2)));
    end
    
    if (visualize)
        imshow(aff_matrix,[]);colormap('hot');
        export_fig(gcf,'Prop_01.png');
    end

    [res,loc] = maxk(aff_matrix, NR_OF_KNN, 2 );
    inds = repmat((1:size(loc,1))',[1 size(loc,2)]);
    
    PNN_matrix = sparse(inds(:),loc(:),res(:),size(aff_matrix,1), ...
            size(aff_matrix,2),numel(res));
    PNN_matrix = ICG_MatNormalizeRow(PNN_matrix);
    
    %% Diffusion Process starts here
    curr_mat = PNN_matrix;
    transposed_PNN_matrix = PNN_matrix';
    
    % Maximum number of iterations (Not important, never reached)
    NR_ITERATIONS = 15;
    
    % Save ranking to define the stopping criterion
    [~, old_ranks] = maxk(aff_matrix, NR_OF_KNN*2, 2 );
    
    average_nr_of_changed_ranks = zeros(1,NR_ITERATIONS);
    similar = zeros(size(aff_matrix,1),1);
    for iter_nr = 1 : NR_ITERATIONS
        % Tensor
        curr_mat = PNN_matrix * curr_mat * transposed_PNN_matrix;
        
        if (visualize)
            imshow(full(curr_mat),[]);colormap('hot');
            export_fig(gcf,['Prop_' sprintf('%.2d',iter_nr+1)]);
        end
        
        %  Check how much is changed in the ranking
        [~, ranks] = maxk(curr_mat, NR_OF_KNN*2, 2 );
        for s = 1 : size(ranks,1)
            similar(s) = length(intersect(ranks(s,1:NR_OF_KNN*2),old_ranks(s,1:NR_OF_KNN*2)));
        end
        old_ranks = ranks;
        average_nr_of_changed_ranks(iter_nr) = mean(similar);
        
        % Stopping criterion, checks change in rankings
        STOPPING_CRITERION = 0.3;
        if (iter_nr > 1) && (average_nr_of_changed_ranks(iter_nr) - average_nr_of_changed_ranks(iter_nr-1) < STOPPING_CRITERION)
            break;
        end
    end
    diffused_matrix = curr_mat;
    
    