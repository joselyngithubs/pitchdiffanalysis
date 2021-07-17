function simDataAllSubjs1

nSubjs = 100;
lowThresholds = 5+ 45*rand(50,1);
nextBunch = 50+50*rand(10,1);
highThresholds = nextBunch;
nextBunch = 100+100*rand(10,1);
highThresholds = [highThresholds;nextBunch];
nextBunch = 200+200*rand(10,1);
highThresholds = [highThresholds;nextBunch];
nextBunch = 400+400*rand(10,1);
highThresholds = [highThresholds;nextBunch];
nextBunch = 800+800*rand(10,1);
highThresholds = [highThresholds;nextBunch];
allThresholds = [lowThresholds;highThresholds];
dirConf = NaN(nSubjs,1);
for k=1:nSubjs
    [Data,allAbsDs] = simDataLowSameHighSimple(25,.7,allThresholds(k),2*allThresholds(k));
    resp = Data(:,3);
    lowerTrials = Data(:,1)<0;
    higherTrials = Data(:,1)>0;
    sameTrials = Data(:,1)==0;
    correct = (resp==1 & higherTrials) | (resp==-1 & lowerTrials) | (resp==0 & sameTrials);
    A = sum(~correct & lowerTrials & (resp==1));
    B = sum(~correct & higherTrials & (resp==-1));
    C = sum((lowerTrials|higherTrials) & (resp==0));
    dirConf(k)=(A+B)/(C+0.5);
end

figure
plot(dirConf,allThresholds,'o')
end

