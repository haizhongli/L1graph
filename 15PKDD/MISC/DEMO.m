function DEMO
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

    %% Example 1
    % Apply diffusion process to an NxN affinity matrix
    % Takes 15 seconds on my desktop PC
    ICG_ExampleDiffusionProcess
    
    %% Example 2
    % Apply diffusion process to an NxD data set
    % !!! Requires some time (~400 sec) and memory !!!
    ICG_ExampleLargeScaleDiffusionProcess;
    
    