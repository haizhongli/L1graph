function ICG_ExperimentCVPR2013_Section_4_2
% ICG_ExperimentCVPR2013_Section_4_1 reproduces results of Section 4.2 of 
%   the paper listed below. It evaluates the dependence on the nearest
%   neighborhood parameter K on all three data sets (MPEG7, ORL and YALE)
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
 

    % Data Set MPEG-7
    [bullseye_for_k_mpeg7,~,~,baseline_mpeg7] = ...
        ICG_FindOptimalKNN(1, false);
    
    % Data Set ORL
    [bullseye_for_k_orl,~,~,baseline_orl] = ...
        ICG_FindOptimalKNN(2, false);
    
    % Data Set YaLe
    [bullseye_for_k_yale ,~,~,baseline_yale] = ...
        ICG_FindOptimalKNN(3, false);
    
    save ALL_DATA_K;
    
    %Draw the same figure as shown in Section 4.2
    close all;
    figure1 = figure;
    axes1 = axes('Parent',figure1,'FontSize',48);
    box(axes1,'on');
    hold(axes1,'all');
    xlabel('Number of kNN','FontSize',48);
    ylabel('Bullseye Rating [%]','FontSize',48);
    units=get(figure1,'units');
    set(figure1,'units','normalized','outerposition',[0 0 1 1]);
    set(figure1,'units',units);
    hold on;
    axis([0 15 55 100]);
    
    plot(bullseye_for_k_mpeg7(:,1), bullseye_for_k_mpeg7(:,2),'Parent',axes1,'LineWidth',8,'Color',[1 0 0],'DisplayName','MPEG-7');
    line([bullseye_for_k_mpeg7(end,1); 0], [baseline_mpeg7 ; baseline_mpeg7],'LineStyle','--','Parent',axes1,'DisplayName','Baseline MPEG-7','LineWidth',3,'Color',[1 0 0]);
    
    plot(bullseye_for_k_orl(:,1), bullseye_for_k_orl(:,2),'Parent',axes1,'LineWidth',8,'DisplayName','ORL','Color',[0 1 0]);
    line([bullseye_for_k_orl(end,1); 0], [baseline_orl ; baseline_orl],'LineStyle','--','Parent',axes1,'DisplayName','Baseline ORL','LineWidth',3,'Color',[0 1 0]);
    
    plot(bullseye_for_k_yale(:,1), bullseye_for_k_yale(:,2),'Parent',axes1,'LineWidth',8,'DisplayName','YALE','Color',[0 0 1]);
    line([bullseye_for_k_yale(end,1); 0], [baseline_yale ; baseline_yale],'LineStyle','--','Parent',axes1,'DisplayName','Baseline YALE','LineWidth',3,'Color',[0 0 1]);
    h = legend(axes1,'show');
    set(h,'FontSize',30);