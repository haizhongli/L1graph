% Function: [labs,labscore] = dbscan_revised(a,Eps,MinPts)
%
% Aim: data clustering using revised DBSCAN algorithm
%
% Input:
% a, matrix, data set with m objects in rows and n parameters in columns
% Eps, scalar, value of neighborhood radius
% MinPts, scalar, the number of points in neighborhood
%
% Output:
% labs, vector, contains information regarding assignment of each object to
% a certain cluster unless object is a noise object (-1)
% labscore, vector, classification of objects (core, border (-2) or noise (-1))
%
% Reference:
% T.N. Tran, K. Drab, M. Daszykowski, Revised DBSCAN algorithm to cluster
% data with dense adjacent clusters, Chemom. Intell. Lab. Syst. 120 (2013) 92-96


function [labs,labscore] = dbscan_revised(a,MinPts,Eps)

UNCLASSIFIED = 0;
BORDER = -2;

% Square Eps in order not to square all distances of points
% eps = eps^2, but then see line 54, 70, 87 and 119

m = size(a,1);
labs = zeros(m,1);
ClusterId = 1;

for i = 1:m
    if labs(i) == UNCLASSIFIED

        % Expand cluster ClusterId
        % Get a set of points with distance < eps
        
        [ExpandClusterReturn,labs] = ExpandCluster(a,labs,i,ClusterId,Eps,MinPts);
        
        if ExpandClusterReturn
            ClusterId = ClusterId +1;
        end
        
    end
end

% Step 3:
labscore = labs;
core_index = find(labscore > 0);
border_points = find(labs==BORDER);

for i = 1:length(border_points)
    currentB = border_points(i);
    d = distance(+a(currentB,:),+a(core_index,:),1);
    [tmp,nearest_core] = min(d);
    nearest_core_index = core_index(nearest_core);
    labs(currentB) = labs(nearest_core_index);
end


% Function ExpandCluster

function [ExpandClusterReturn,labs] = ExpandCluster(a,labs,i,ClusterId,Eps,MinPts)

% Define types of objects
UNCLASSIFIED = 0;
NOISE = -1;
BORDER = -2;

% Calculate distances
d = distance(+a(i,:),+a(:,:),1);
seeds = find(d < Eps);

if size(seeds,2) < MinPts,
    labs(i) = NOISE;             % NOISE
    ExpandClusterReturn = 0;     % False
else
    % Change cluster id of all seeds to ClusterId
    labs(i) = ClusterId;
    
    % Seeds delete point
    seeds = setdiff(seeds, i);

    while ~isempty(seeds) % Not empty seeds list
        
        % Current point is the first point in seeds list
        currentP = seeds(1);
        d = distance(+a(currentP,:),+a(:,:),1);
        result = find(d <= Eps);

        if length(result) >= MinPts  % CORE point
            labs(currentP) = ClusterId;

            result_unclassified = result(find(labs(result)==UNCLASSIFIED | labs(result)==NOISE));
            labs(result_unclassified) = BORDER;
            
            % First assign to a border-point then later will be reassigned to e.g. CORE
            seeds = union(seeds,result_unclassified);

            %{
                        for j = 1:length(result)
                            resultP = result(j);
                            if ismember(labs(resultP),[UNCLASSIFIED NOISE])
                                if labs(resultP) == UNCLASSIFIED
                                    seeds = union(seeds, resultP);
                                end
                            end
                        end
            %}
        end

        % Delete current point in seeds list
        seeds = seeds(2:size(seeds,2));

    end % end while
    ExpandClusterReturn = 1;    % return true
end


function d = distance(X,Y,dosqrt)

% function d = distance(X,Y,dosqrt);
% dosqrt: default 0: No square root to reduce computation time
% (only for comparation purpose)
% Euclidean distance matrix between row vectors in X and Y

if nargin < 3, dosqrt = 0; end

U =~ isnan(Y);
Y(~U) = 0;
V =~ isnan(X);
X(~V) = 0;

if ~dosqrt 
    d = abs(X.^2*U'+V*Y'.^2-2*X*Y');
else
    d = sqrt(X.^2*U'+V*Y'.^2-2*X*Y');
end
