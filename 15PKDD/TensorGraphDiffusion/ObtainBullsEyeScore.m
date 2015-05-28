function Score = ObtainBullsEyeScore(newW)


maxW=max(newW,[],2);
[YW,IW] = sort(repmat(maxW,1,1400)-newW,2); 

Retrieval=IW(:,1:40);


N=1400;
StepNumber=5;

NoShapes=20;
NoClasses=70;

for cind=1:NoClasses
    correct=0;
    for item=1:NoShapes
        query=(cind-1)*20+item; 
        for t=1:40
            if ceil(query/20)==ceil(Retrieval(query,t)/20)
                correct=correct+1;
            end
        end
    end
    ClassAccuracy(cind)=correct/(20*NoShapes);
end
Score = mean(ClassAccuracy);