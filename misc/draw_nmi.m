function [h] = draw_nmi(str)

mat_fname = sprintf('%s_nmall.mat',str);
load(mat_fname);
 
myfig = figure, plot(nmi_all,'-d');
hold on;
ylim([0,1]);
[~,id] = max(nmi_all);
plot(id,nmi_all(id),'ro');
xlabel('t');
ylabel('NMI');
title(str);
set(findall(myfig,'type','text'),'FontSize',30,'fontWeight','bold');
sfname = sprintf('%s_nmi.fig',str);
sfnameps = sprintf('%s_nmi.eps',str);
saveas(myfig,sfname,'fig');
saveas(myfig,sfnameps,'psc2');
end

