% GABRIEL: Finds the Gabriel connectivity graph among points in P dimensions.
%
%     Usage: [connect,dist] = BetaSkeleton(crds,{noplot},{tol})
%
%           crds =    [n x p] matrix of point coordinates.
%           beta =    coeffecient to control empty region
%           
%           -------------------------------------------------------------------------
%           connect = [n x n] boolean adjacency matrix.
%           dist =    corresponding edge lengths (Euclidean distances);
%                       non-connected edge distances are given as zero.
%

function [connect,dist] = BetaSkeleton(crds,beta, EuDis)

tol=1e-6;
[n,p] = size(crds);

if (n<3)
    error('  GABRIEL: requires at least two points ');
end;

connect = zeros(n,n);
  
d = EuDis;
dist = EuDis;

for i = 1:(n-1)                       % Cycle thru all possible pairs of points
    for j = (i+1):n
        bd = beta*d(i,j)/2;
        new1 = (1-beta/2)*crds(i,:)+(beta/2)*crds(j,:);
        new2 = (1-beta/2)*crds(j,:)+(beta/2)*crds(i,:);
        c = 1;
        for k = 1:n
            if (k~=i & k~=j)
                TempMatrix = [crds(k,:);new1;new2];
                TempEuDis = CompED (TempMatrix);
                if (((TempEuDis(1,2)-bd)< tol) & ((TempEuDis(1,3)-bd)< tol))
                    c = 0; break;
                end
            end;
        end;
        if (c)
            connect(i,j) = 1;
            connect(j,i) = 1;
        else
            dist(i,j) = 0;
            dist(j,i) = 0;
        end;
    end;
end


  if (p==2)
    figure;
    plot(crds(:,1),crds(:,2),'ko');
    putbnds(crds(:,1),crds(:,2));
    axis('equal');
    hold on;
    for i = 1:(n-1)
      for j = 2:n
        if (connect(i,j))
          plot(crds([i j],1),crds([i j],2),'k');
        end;
      end;
    end;
    hold off;
  end;

  return;
