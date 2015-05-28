function Output = DominantNeighbors(A,Thresh, stop_th, select_th,KNN)

if nargin>4
    NN_Flag = 1;
else
    NN_Flag = 0;
end
Output = zeros(size(A));
SIZE = length(A);

for k = 1:SIZE
    Incre = 10;
    if ~NN_Flag
        Initial = find(A(k,:)>Thresh);
    else
        [v,idx] = sort(A(k,:),'descend');
        Initial = idx(1:KNN);
    end
    x = zeros(SIZE,1);
    x(Initial) = 1;
    x = x/sum(x);
    while Incre>stop_th
        Old_Tar = x'*A*x;
        x = x.*((A*x)/(x'*A*x));
        Incre = x'*A*x - Old_Tar;
    end
    Output(k,:) = x>select_th;
end
