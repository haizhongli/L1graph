function [nmi,acc] = evalNMIAC(true_labels,predict_labels)
% This code is following Dr. Deng Cai's code. 
% http://www.cad.zju.edu.cn/home/dengcai/
%
% the code need following functions:
%   bestMap()
%   hungarian()
%   MutualInfo()
% 
%
% find best match
res = bestMap(true_labels,predict_labels);
% evaluate AC: accuracy 
acc = length(find(true_labels == res))/length(true_labels);
% evaluate MIhat: nomalized mutual information 
nmi = MutualInfo(true_labels,res);
end
