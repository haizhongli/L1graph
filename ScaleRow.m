function sA = ScaleRow(A)
%% scale the row to [0,1]
r_min = min(A,[],2); %% min value of each row
r_max = max(A,[],2); %% max value of each row
m_min = repmat(r_min,1,size(A,2));
m_max = repmat(r_max,1,size(A,2));
b = m_max - m_min;
b(~logical(b)) = 1.0;
sA = (A-m_min) ./ b;
end
