function [newctrs, ctrssize, real_wcss] = WCSSKmeans(data, k, InnerMaxIters, OuterMaxIters, callback)
%% WCSS K Means
% data: n*d dataser, n is #instances and d is #dimensions
% k is # clusters
% InnerMaxIters= number of iteration for one initialization center points
% OuterMaxIters= number of intialization center points resetting

if nargin < 5 callback = 0; end;

[n,d] = size(data);
quality = [];
real_wcss=100000000000000;
new_wcss=0;
newctrs=data(ceil(rand(k,1)*n),:);
ctrssize=0;;
    



% pre-compute the square of each data point
x2 = sum(data .* data, 2);
x2 = repmat(x2, [1 k]); % size(x2) == [n k]
lastCS = 1; cs = 1; % initial conditions

for i=1:OuterMaxIters
    
     if ~isscalar(k)
         ctrs=k;
         k=size(ctrs,1);
     else
        ctrs=data(ceil(rand(k,1)*n),:);
        
     end
     
     new_wcss=0;

    for iter = 1:InnerMaxIters % do it *at most* maxiters times
        
        if (callback ~= 0)
            eval([callback, '(ctrs, data, iter);']);
        end;

        xc = data * ctrs'; % data times centers; size(xc) == [n k]

        % square each center
        c2 = sum(ctrs .* ctrs, 2);
        c2 = repmat(c2, [1 n]); % size(c2) == [k n]

        % distance^2 between each center & data point
        d2 = x2 - 2*xc + c2'; % size(d2) == [n k]

        lastCS = cs;
        if (min(size(d2)) == 1)
            md = d2;
            cs = ones(size(d2));
        else
            [md, cs] = min(d2'); % find the center for each datapt
            md = md';
            cs = cs';
        end;
        % md holds distance^2 from each datapt to its closest center
        % cs holds the index of the center closest to each datapt

        quality(iter) = sum(md);

        if (iter > 1)
            if (lastCS == cs) % check if the algorithm has converged
                break;
            end;
        end;

        % now we know the closest center for each datapt (in cs), so
        % we need to use each datapt to update the cluster centers
        
        for center = 1:k
            assigned = find(cs == center);
            asize = size(assigned, 1);
            if asize == 1
                ctrs(center,:) = data(assigned, :);
            elseif asize ~= 0
                ctrs(center,:) = sum(data(assigned, :)) / asize;
            end;
        end;
        
    end;% inner loop end!!!!!!!!
    
            for center = 1:k
                assigned = find(cs == center);
                asize = size(assigned, 1);
                ctrcsmatrix=repmat(ctrs(center,:),asize,1);
                disMatrix=(data(assigned,:)-ctrcsmatrix).^2;
                new_wcss=new_wcss+sum(sum(disMatrix,2));
                %center = center + 1;
            end;
            
            if (callback ~= 0)
                eval([callback, '(ctrs, data, ''finish'')']);
            end;
            
            if (new_wcss<real_wcss)
                real_wcss=new_wcss;
                newctrs = ctrs;
                    for i = 1:k
                        ctrssize(i) = sum(cs == i);
                    end;
                    %printout='change here'
            end
            
            %new_wcss
             %   real_wcss
end

end


