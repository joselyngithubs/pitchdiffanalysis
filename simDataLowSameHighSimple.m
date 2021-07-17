function [Data,allAbsDs] = simDataLowSameHighSimple(nTrialsLowHigh,pCorrectGivenSame,threshDetect,threshDiscrim)


nTrials = 4*nTrialsLowHigh;
weibullB = 2.5;
absD = 700;
sched = [-1*ones(nTrialsLowHigh,1);ones(nTrialsLowHigh,1);zeros(2*nTrialsLowHigh,1)];
sched = sched(randperm(length(sched)));
resp = NaN(size(sched));
allAbsDs = NaN(size(sched));
allDs = NaN(size(sched));
for k=1:nTrials
    allAbsDs(k) = absD;
    D = sched(k)*absD;
    allDs(k)= D;
    pSThinksDiffNonZero = weibull(absD, pCorrectGivenSame, 1.0, threshDetect, weibullB);
     if rand < pSThinksDiffNonZero   % subject thinks the difference is nonzero
         pSHearsDirectionCorrectly = weibull(absD, 0.5, 1.0, threshDiscrim, weibullB);
         if rand < pSHearsDirectionCorrectly
             resp(k) = sched(k);
         else
             resp(k) = -sched(k);
         end
     else
         resp(k) = 0;
     end
   
     if k > 2 && resp(k) == sched(k) && resp(k-1) == sched(k-1) && resp(k-2) == sched(k-2)
         absD = absD*0.9;
     else
         absD = absD/0.9;
     end
     if absD > 1200
         absD = 1200;
     end
end
Data = [allDs(:),allAbsDs(:),resp(:)];
end

