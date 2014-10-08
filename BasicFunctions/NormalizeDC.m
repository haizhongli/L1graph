%%  Double Centering normalization

function NewData = NormalizeDC (Data )


[nrow,ncol] = size(Data);
Data2=Data;

MeanCol=repmat(mean(Data2,1), [nrow 1]);
Data2=Data2-MeanCol;
MeanRow=repmat(mean(Data2,2), [1 ncol]);


Data2=Data2-MeanRow;







%MeanAll=mean(Data(:));
%Data2=Data2+MeanAll;

NewData=Data2;%Data-MeanRow-MeanCol+MeanAll;