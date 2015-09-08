function LocalScale=LocalScaling(similarity,d)


LocalScaleM=sort((similarity),2);

LocalScale=LocalScaleM(:,d);
     
