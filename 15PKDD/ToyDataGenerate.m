% generate toy data sets
%
% Shuchu Han (shhan@cs.stonybrook.edu)
% April 4, 2015

clear;
addpath('../');

%% generate different density dataset
% N = 50;
% %% generate N random points inside a circle which center at (0,0) and
% %% radius equals 0.2
% d1 = zeros(N,2);
% for i = 1:N
%     [d1(i,1),d1(i,2)] = cirrdnPJ(0.5,0.5,1);
% end
% %% generate 50 random points on square (0,0) -> (1,1)
% d2 = rand(50,2);
% D = [ d1 ; d2];

%figure, plot(D(:,1),D(:,2),'x');


%% generate a circle and a dense solid circle.
N = 100;
d1 = zeros(N,2);
for i = 1:N
    [x,y] = cirrdnPJ(0,0,1);
    while x^2+y^2 < 0.8 
        [x,y] = cirrdnPJ(0,0,1);
    end
    d1(i,1) = x;
    d1(i,2) = y;
end

figure, plot(d1(:,1),d1(:,2),'.');


