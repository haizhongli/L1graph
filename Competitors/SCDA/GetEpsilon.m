function epsilon=GetEpsilon(sA)

%NsA=sA(:,2:end);
mind=min(sA(:));
meand=mean(sA(:));
maxd=max(sA(:));
%minn=min(NsA(:,1));
meann=mean(sA(:,2));
maxn=max(sA(:,2));

epsilon=20*meand+54*mind+13*maxn-6*maxd-65*meann;

end