function NewData = doMatrixMedianPolish(Data)
[nrow,ncol] = size(Data);
NewData = zeros(nrow, ncol);
values = Data';
psIndices = 1:ncol;
valClass = class(Data);
for i = 1 : ncol
    if i < ncol
        nProbePairs = psIndices(i+1) - psIndices(i);
    else
        nProbePairs = ncol - psIndices(i) + 1;
    end
    
    ppstart = psIndices(i); % start probe pair index in a probe set 
    ppend = ppstart+nProbePairs-1; % end prope pair index in a probe set
    
    % Get a matrix of probe values for a probe set for all the chips. Here
    % the row is the rpobe values and the column is the chips
    ppvalues = values(ppstart:ppend, 1:nrow); 
    
    NewData(:, i) = doMedianPolish(ppvalues, valClass);
end

