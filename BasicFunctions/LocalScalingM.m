function [LocalScaleM, index]=LocalScalingM(dist,N, method)


nrow = max(size(N)); 
LocalScaleM=zeros(nrow,1);

[AllNeighbors, index]=sort((dist),2, 'descend');

for i = 1:nrow
    if N(i)>0;
        if strcmp(method,'mean') 
            LocalScaleM(i)=mean(AllNeighbors(i,1:N(i)));
        elseif strcmp(method,'median') 
            LocalScaleM(i)=median(AllNeighbors(i,1:N(i)));
        end
    end
end
     
