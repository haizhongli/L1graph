function [best_results best_iteration_nr baseline] = ICG_ExperimentCVPR2013_Section_4_1(dataset_id)
% [best_results best_iteration_nr baseline] = ICG_ExperimentCVPR2013_Section_4_1(dataset_id)
%   ICG_ExperimentCVPR2013_Section_4_1 reproduces results of Section 4.1 of 
%   the paper listed below. It densely evaluates the diffusion variants on
%   all three data sets MPEG7, ORL and YALE.
%
%   Parameter
%   ---------
%   dataset_id ... 1 => MPEG 7
%                  2 => ORL
%                  3 => YALE
%
%   Returns
%   -------
%   best_results ... Bullseye scores for all diffusion variants
%   best_iteration_nr ...  The number of iterations 
%   baseline ... The baseline bullsyeye score
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

    addpath('HelpFunctions');
    Diff = [];labels = [];sigma_range = [];
    BULLSEYE_RANGE = 0;NR_OF_KNN = 0;dataset_name='';
    
    switch dataset_id
        case 1
            load('./Data/MPEG7');
        case 2
            load('./Data/ORL');
        case 3
            load('./Data/YALE');
        otherwise
            disp('dataset_id has to be 1->MPEG-7 or 2->ORL or 3->YALE');
            return;
    end
    
    % Define diffusion variants to evaluate
    % Adapt here if evaluating specific variants
    init_poss = 1 : 4; 
    trans_poss = 1 : 6;
    diff_poss = 1 : 3;
    
    % Get baseline bullseye score on data set
    baseline = ICG_RetrievalBullsEyeScore(Diff,labels,BULLSEYE_RANGE);
    
    % We do have 4 different inits, 6 different transitions and 3 different
    % diffusion variants, thus we get a nr_sigma x 4 x 6 x 3 tensor
    bullseye_scores = zeros(length(sigma_range),length(init_poss),length(trans_poss), length(diff_poss));
    iterations = zeros(length(sigma_range),length(init_poss),length(trans_poss), length(diff_poss));
    
    % Simply replace parfor with for, if no multi-core is 
    % available, or with the desired number of cores to use
    matlabpool open 2;
    parfor sigma = 1 : length(sigma_range) 
        help_var_bullseye_scores = zeros(length(init_poss),length(trans_poss), length(diff_poss));
        help_var_iterations = zeros(size(help_var_bullseye_scores));
        
        % Normalize distance matrix
        aff_matrix = exp((-(Diff.^2)) * (2*sigma_range(sigma)^2));
        
        % Test all possible diffusion variants
        for init_id = 1 : numel(init_poss)
            for transition_id = 1 : numel(trans_poss)
                for diffusion_id = 1 : numel(diff_poss)
                    diffusion_process = [init_poss(init_id), trans_poss(transition_id),...
                        diff_poss(diffusion_id)];
                    [diffused_bullseyes nr_iterations] = ICG_CVPR2013ApplyDiffusionProcess(dataset_name, aff_matrix, ...
                            labels, diffusion_process , BULLSEYE_RANGE, NR_OF_KNN);
                    disp(['- Bullseye score changed from ' num2str(baseline) ' to ' num2str(diffused_bullseyes(end)) ...
                        '% in ' num2str(nr_iterations) ' iterations']);
         
                    help_var_bullseye_scores(init_id,transition_id,diffusion_id) = diffused_bullseyes(end);
                    help_var_iterations(init_id,transition_id,diffusion_id) = nr_iterations;
                end
            end
        end
        bullseye_scores(sigma,:,:,:) = help_var_bullseye_scores;
        iterations(sigma,:,:,:) = help_var_iterations;
    end
    matlabpool close;
    
    % For listing the table as in the paper, we have to correct the IDs, 
    % if we only apply some of the diffusion variants
    paper_bullseye_scores = zeros(length(sigma_range),4,6,3);
    paper_iterations = zeros(length(sigma_range),4,6,3);
    for init_id = 1 : numel(init_poss)
        for transition_id = 1 : numel(trans_poss)
            for diffusion_id = 1 : numel(diff_poss)
                diffusion_process = [init_poss(init_id), trans_poss(transition_id),...
                        diff_poss(diffusion_id)];
                paper_bullseye_scores(:,diffusion_process(1),diffusion_process(2),...
                    diffusion_process(3)) = bullseye_scores(:,init_id,transition_id, ...
                        diffusion_id);
                paper_iterations(:,diffusion_process(1),diffusion_process(2),...
                    diffusion_process(3)) = iterations(:,init_id,transition_id, ...
                        diffusion_id);    
            end
        end
    end
    
    % select results for optimal sigma
    best_results = squeeze(max(paper_bullseye_scores,[],1));
    best_iteration_nr = squeeze(max(paper_iterations,[],1));
        
    % Build Latex table as in paper, prefer faster init
    disp('***Latex Table in Section 4.1***')
    disp('\emph{ ORL } & \emph{C1} & \emph{C2} & \emph{C3}\\\\');
    [our_opt_init our_opt_init_poses]  = max(best_results(end:-1:1,:,:),[],1);
    our_opt_init = squeeze(our_opt_init);
    our_opt_init_poses = squeeze(our_opt_init_poses);
    our_opt_init_poses = 5 - our_opt_init_poses;
    for i = 1 : size(our_opt_init,1)
        the_term = [ 1 0]' * our_opt_init(i,:);
        the_term = the_term(:);
        the_term(2:2:end) =  our_opt_init_poses(i,:);
        str = sprintf('\\emph{B%d} & %.2f (A%d) & %.2f (A%d) & %.2f (A%d) \\\\', ...
            i,the_term);
        disp(str);
    end
            
    

