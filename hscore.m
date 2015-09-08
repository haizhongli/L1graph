function [h] = hscore(G,labels)
%% calculate the H-score
n  = size(G,1);
if n ~= length(labels)
    disp('size of graph not equals to length of labels');
    return;
end

[~,I] = max(G);

ct = 0;
for i = 1:n
    if labels(i) == labels(I(i))
     ct = ct+1;
    end
end
 
h  = ct/n;
end
