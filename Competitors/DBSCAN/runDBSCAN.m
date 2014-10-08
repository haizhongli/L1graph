clear all;close all;%clc
addpath('../data/Synthetic', '../data/Clustering', '../Basic');

load RCV1_4Class_4clus.mat;
[nrow,ncol] = size(Data);
[AffSim,~,~]= AffConstruction(Data, [], 2, 2, 'Cos'); % construct Affinity Matrix

%AffSim = cora;
%ClusterLabels = cora_label;
%NumC = 10;
%[nrow] = size(AffSim,1);
%NumC =gni;

% EDMatrix = CompED(Data);
% LocalScaleM=sort(EDMatrix,2);
% LocalScale=mean(LocalScaleM);

LocalScaleM=sort(AffSim,2, 'descend');
LocalScale=mean(LocalScaleM);


max_nmi=0;

upLm = min (300, round(nrow/NumC));


real_min_size = round(nrow/NumC);
for Min_Size = 1: 1: upLm
for i = 2:50    
    %[ClusterResults,~]=dbscan_revised(Data,Min_Size,LocalScale(i));
    [ ClusterResults ] = dbscanSim( AffSim, Min_Size, LocalScale(i));
    
    if size(ClusterResults,1)<size(ClusterResults,2)
        ClusterResults = double(ClusterResults');
    end
    ClusterResults = (ClusterResults-min(ClusterResults(:)))+1;
    temp_nmi=eval_nmi(ClusterLabels, ClusterResults);
    NMIResult(Min_Size, i) =  temp_nmi;
    if max_nmi<temp_nmi
        max_nmi = temp_nmi;
    end
end
end

max_nmi

% colors =  [1,0,0; 0,1,0; 0,0,1; 0,1,1; 1,0,1; 1,1,0; 0,0,0; 1,0,0; 0,1,0; 0,0,1];
% Markers = [ 'O',   '+',   'X',   '*',   'O',   '+',   'X',   '*',   'O',   '+'];
% ColorLabels=ClusterResults;
% % ColorLabels(ColorLabels(:)==2)=4;
% % ColorLabels(ColorLabels(:)==3)=2;
% % ColorLabels(ColorLabels(:)==4)=3;
% figure, hold on
% %view(-40,10);
% for i=1:nrow
%     if ncol>=3
%         %scatter3(Data(i,1),Data(i,2),Data(i,3),30,ClusterLabels(i),'filled');
%         plot3(Data(i,1),Data(i,2),Data(i,3),'Marker', Markers(2),'Color',colors(ColorLabels(i),:),'MarkerSize',5,'LineWidth',5);
%     elseif ncol==2
%         %scatter(Data(i,1),Data(i,2),32,ClusterLabels(i),'filled');
%         plot(Data(i,1),Data(i,2),'Marker', Markers(2),'Color',colors(ColorLabels(i),:),'MarkerSize',5,'LineWidth',5);
%     end
% end