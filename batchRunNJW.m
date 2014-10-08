addpath('/home/shuchu/data/data/Hao/Clustering/');
if 0
clear;
load glass.mat
runAllL1Only;
save('glass_result.mat','result')
disp('glass done')

clear;
load soybean1.mat
runAllL1Only;
save('soybean1_result.mat','result')
disp('soybean done')
end

if 0
clear;
load wine.mat
runAllL1Only;
save('wine_result.mat','result')
disp('wine done')

clear;
load vehicle.mat
runAllL1Only;
save('vehicle_result.mat','result')
disp('vehicle done')


clear;
load BreastTissue.mat
runAllL1Only;
save('bt_result.mat','result')
disp('bt done')
end

clear;
load Image.mat
runAllL1Only;
save('Image_result.mat','result')
disp('Image done')

clear;
load iris.mat
runAllL1Only;
save('iris_result.mat','result')
disp('iris done')

