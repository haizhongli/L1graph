%% normalize the affinity matrix (2 norm summation is 1)

function L=NormalizationFamily(W,alpha)

nrow=size(W,1);
D1=degree(W);
D1inv=zeros(nrow,nrow);
D2inv=zeros(nrow,nrow);

E=eye(nrow);

if alpha>=0
    for i=1:nrow
        if D1(i,i)~=0
            D1inv(i,i)=D1(i,i).^(-1*alpha);
        end
    end
    W1=D1inv*W*D1inv;
    D2=degree(W1);
    for i=1:nrow
        if D2(i,i)~=0
            D2inv(i,i)=D2(i,i).^(-1);
        end
    end
    L=E-D2inv*W1;
elseif alpha==-0.5
    for i=1:nrow
        if D1(i,i)~=0
            D1inv(i,i)=1/(sqrt(D1(i,i)));
        end
    end
    L=D1inv*W*D1inv;
	L=E-L;
elseif alpha==-1
    L=D1-W;
elseif alpha==-2
    L=W;
end
    

end


