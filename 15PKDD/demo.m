data = d2;
id = 2;

WW = zeros(size(W));
WW(id,:) = WK(id,:);
WW(:,id) = WK(id,:)';

%WW(WW < 0.01) = 0;

figure, plot(data(:,1),data(:,2),'b+');
hold on;
gplot(WW,data,'g-');
plot(data(id,1),data(id,2),'r+');
hold off;

% 
% dist = squareform(pdist(data));
% [~,I] = sort(dist,2);
% 
% kid = I(id,1:20);
% kid = kid(2:end);
% figure, plot(data(:,1),data(:,2),'b+');
% hold on
% plot(data(id,1),data(id,2),'r+');
% plot(data(kid,1),data(kid,2),'ro');
% hold off