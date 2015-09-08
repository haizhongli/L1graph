
id= 3;
figure;
hold on;
scatter(x(:,1),x(:,2),20,RN1(:,id),'filled');
plot(x(id,1),x(id,2),'bo','markersize',10);
title('Closed form');
box on;
hold off;