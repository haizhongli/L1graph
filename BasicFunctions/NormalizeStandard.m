%%  columnwise standard normalization

function NewData = NormalizeStandard (Data, flag)


[nrow,ncol] = size(Data);

NewData=zeros(nrow,ncol);

for i=1:ncol
    ColMean = mean(Data(:,i));
    ColStd = std(Data(:,i), flag);
    NewData(:,i) = (Data(:,i)-ColMean)./ColStd;  
end

end