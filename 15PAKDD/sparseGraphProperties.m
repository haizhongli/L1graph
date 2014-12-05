function [avg_deg_cos,avg_deg_gau] = sparseGraphProperties(name,A_cos,A_gau)

%% check graph properties

%%  A is a weighted directed graph 
%% A(i,j) = 1  --> an edge from i to j;
%A_cos = [];
%A_gau = [];

n = size(A_cos,1);
A_cos(logical(eye(n))) = 0;
A_gau(logical(eye(n))) = 0;

% indegree distribution
A_cos_deg = logical(A_cos);
A_gau_deg = logical(A_gau);
in_deg_cos = sum(A_cos_deg,1);
in_deg_gau = sum(A_gau_deg,1);
in_deg = [in_deg_cos',in_deg_gau'];
figure, hist(in_deg);
sname = sprintf('%s,In-degree',name);
title(sname);
legend('Cosine','Gaussian');
export_fig 'indeg' -pdf -transparent;

% outdegree distribution
out_deg_cos = sum(A_cos_deg,2);
out_deg_gau = sum(A_gau_deg,2);
out_deg = [out_deg_cos,out_deg_gau];
figure, hist(out_deg);
sname = sprintf('%s,Out-degree',name);
title(sname);
legend('Cosine','Gaussian');
export_fig 'outdeg' -pdf -transparent;

% inWeight distribution
in_wt_cos = sum(A_cos,1);
in_wt_gau = sum(A_gau,1);
in_wt = [in_wt_cos',in_wt_gau'];
figure, hist(in_wt);
sname = sprintf('%s,In-weight',name);
title(sname);
legend('Cosine','Gaussian');
export_fig 'inWt' -pdf -transparent;

% outWeight distribution
out_wt_cos = sum(A_cos,2);
out_wt_gau = sum(A_gau,2);
out_wt = [out_wt_cos,out_wt_gau];
figure, hist(out_wt);
sname = sprintf('%s,Out-weight',name);
title(sname);
legend('Cosine','Gaussian');
export_fig 'outWt' -pdf -transparent;

% indegree Vs outdegree, scatter plot
%cos
figure, scatter(in_deg_cos',out_deg_cos, 'filled');
xlabel('In-degree');
ylabel('Out-degree');
sname = sprintf('%s,In-degree Vs Out-degree, Cosine Similarity',name);
title(sname);
export_fig 'in_out_deg_cos' -pdf -transparent;

%gau
figure, scatter(in_deg_gau',out_deg_gau, 'filled');
xlabel('In-degree');
ylabel('Out-degree');
sname = sprintf('%s,In-degree Vs Out-degree, Gaussian Similarity',name);
title(sname);
export_fig 'in_out_deg_gau' -pdf -transparent;

% inWeight Vs outWeight, scatter plot
%cos
figure, scatter(in_wt_cos',out_wt_cos,'filled');
xlabel('In-weight');
ylabel('Out-weight');
sname = sprintf('%s,In-weight Vs Out-weight, Cosine Similarity',name);
title(sname);
export_fig 'in_out_wt_cos' -pdf -transparent;

%gau
figure, scatter(in_wt_gau',out_wt_gau,'filled');
xlabel('In-weight');
ylabel('Out-weight');
sname = sprintf('%s,In-weight Vs Out-weight, Gaussian Similarity',name);
title(sname);
export_fig 'in_out_wt_gau' -pdf -transparent;

% averge degree
avg_deg_cos = sum(sum(A_cos))/n;
avg_deg_gau = sum(sum(A_gau))/n;

%set(gca,'FontSize',26,'fontWeight','bold')
%set(findall(gcf,'type','text'),'FontSize',30,'fontWeight','bold');

end

