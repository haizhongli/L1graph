function avgRet = doMedianPolish(ppvalues, valclass)
[rows, cols] = size(ppvalues);

% log2 transform
z = log2(ppvalues);

% Define maximum number of iteration if the median polish procedure does not
% converge
maxIteration = 10; % This is the number RMAExpress uses
tol = 0.01;
allEffect = 0.0;
rowEffects = zeros(rows,1, valclass); % For row (chip) effects 
colEffects = zeros(1,cols, valclass); % For col (probe) effects

iloop = 1;
row_median = median(z, 2);
while iloop <= maxIteration
    % subtract the matrix by the row median
    z = bsxfun(@minus, z, row_median);
    % Add to row effect
    rowEffects = rowEffects + row_median;
    % Get column median
    col_median = median(z, 1);
    
    % Subtract the matrix by the column median
    z = bsxfun(@minus, z, col_median);
    %Add to column effect
    colEffects = colEffects + col_median;
    % Get row median
    row_median = median(z, 2);
    
    % check for convergence
    if all(abs(row_median) < tol ) && all(abs(median(z, 1)) < tol )
        break;
    end
     
    iloop = iloop+1;
end

% The commented out code below is the formal way of summing up the effects,
% since the row effect will not be added to the final results, so we can cut a
% few steps.
% Add median of the row effect to the all effect
me = median(rowEffects);

allEffect = allEffect + me;
% % Subtract it from row effect
% rowEffects = rowEffects - me;
% 
% % Add median of the col effect to the all effect
% me = median(colEffects);
% allEffect = allEffect + me;
% % Subtract it from col effect
% colEffects = colEffects - me;

% The total probe (row effect) should be zero
avgRet = colEffects + allEffect;
end % doMedianPolish