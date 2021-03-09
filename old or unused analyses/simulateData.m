function [D,Resp] = simulateData

nTrials = 100;

D = zeros(1,nTrials);
D(nTrials/2+1:end) = randn(nTrials/2,1);

c1 = -1;
c2 = 1;

Resp = NaN(1,nTrials);

noiseSigma = 2;
% larger = worse. 1/sigma corresponds to dprime or sensitivity in the task

for n=1:nTrials
    internalStat = D(n)+noiseSigma*randn;
    if internalStat < c1
        Resp(n) = 1;
    elseif internalStat > c2
        Resp(n) = 0;
    elseif internalStat >= c1 && internalStat <= c2
        Resp(n) = 2;
    end
            
end


end