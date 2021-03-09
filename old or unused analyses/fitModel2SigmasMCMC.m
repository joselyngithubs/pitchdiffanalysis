function      [samples,LLH,Sigmas,outSigmaScalar] = fitModel2SigmasMCMC(NumSamples,Prev,Sigmas,tmpSigmaScalar)

global Ds Rs nTrials SigmaScalar Sigmas

% fname = dir('data\mcmc\*.csv');
% fname = fname.name;
% [allDs,resp] = getDataTest(['data\mcmc\' fname]);

load simData2 D Resp
allDs = D;
resp = Resp;

Ds = allDs;
Rs = resp;
nTrials = length(resp);
nParams = 4;

BlockSz = 5000;
if nargin < 4 || isempty(tmpSigmaScalar)
    SigmaScalar = 1;
else
    SigmaScalar = tmpSigmaScalar;
end

if nargin < 2 || isempty(Prev)
    mPos = mean(allDs(allDs>0));
    mNeg = mean(allDs(allDs<0));
    Prev = [-mNeg/3, mPos/3, (mPos-mNeg)/2 (mPos-mNeg)/2];
end

Mins = [-10000 -10000 -10000 0];
Maxes = [10000 10000 10000 2000];

if nargin < 3
    Sigmas = 0.1*ones(1,nParams);
end

samples = NaN(NumSamples,nParams);

samples(1,:) = Prev;
LLH(1) = GetLogLhood(Prev);
Ctr = 0;
LRats = zeros(BlockSz,1);
for j = 2:NumSamples
    Ctr = Ctr+1;
    Candidate = GetCandidate(Prev,Sigmas,Mins,Maxes);
    LogLhoodCand = GetLogLhood(Candidate);
    LRats(Ctr) = exp(LogLhoodCand - LLH(j-1));
    if rand < LRats(Ctr)
        samples(j,:) = Candidate;
        Prev = Candidate;
        LLH(j) = LogLhoodCand;
    else
        samples(j,:) = Prev;
        LLH(j) = LLH(j-1);
    end
    if Ctr == BlockSz
        disp(['Iteration ' num2str(j)])
        Sigmas = UpdateSigmas(samples(j-BlockSz:j,:),LRats);
        Ctr = 0;
    end
end
outSigmaScalar = SigmaScalar;

figure;
plot(samples(:,1));
hold on
plot(samples(:,2));
plot(samples(:,3));
plot(samples(:,4));
legend({'c1','c2','noiseSigmaZero','noiseSigmaOuter'});
title(fname);

end

function     LogLhood = GetLogLhood(params)

global  Ds Rs nTrials

C1 = params(1);
C2 = params(2);
noiseSigma0 = params(3);
noiseSigmaOuter = params(4);

P = NaN(nTrials,1);
whichOnes = Rs == -1 & Ds~=0;
P(whichOnes) = cumgauss((C1-Ds(whichOnes))/noiseSigmaOuter);
whichOnes = Rs == 0 & Ds~=0;
P(whichOnes) = cumgauss((C2-Ds(whichOnes))/noiseSigmaOuter)-cumgauss((C1-Ds(whichOnes))/noiseSigmaOuter);
whichOnes = Rs == 1 & Ds~=0;
P(whichOnes) = cumgauss((Ds(whichOnes)-C2)/noiseSigmaOuter);
whichOnes = Rs == -1 & Ds==0;
P(whichOnes) = cumgauss((C1-Ds(whichOnes))/noiseSigma0);
whichOnes = Rs == 0 & Ds==0;
P(whichOnes) = cumgauss((C2-Ds(whichOnes))/noiseSigma0)-cumgauss((C1-Ds(whichOnes))/noiseSigma0);
whichOnes = Rs == 1 & Ds==0;
P(whichOnes) = cumgauss((Ds(whichOnes)-C2)/noiseSigma0);

% P(Rs == -1) = cumgauss((C1-Ds(Rs == -1))/noiseSigma);
% P(Rs == 0) = cumgauss((C2-Ds(Rs == 0))/noiseSigma)-cumgauss((C1-Ds(Rs == 0))/noiseSigma);
% P(Rs == 1) = cumgauss((Ds(Rs == 1)-C2)/noiseSigma);
P(P < 0.01) = 0.01;
P(P > 0.99) = 0.99;

% Psis(Psis > MaxProb) = MaxProb;
% Psis(Psis < 1-MaxProb) = 1-MaxProb;

LogLhood = sum(log(P));
end

function  Candidate = GetCandidate(Prev,Sigmas,Mins,Maxes)

Candidate = Prev + randn(size(Sigmas)).*Sigmas;
Candidate(Candidate < Mins) = Prev(Candidate < Mins);
Candidate(Candidate > Maxes) = Prev(Candidate > Maxes);
end

function  Sigmas = UpdateSigmas(crntSamples,LRats)
global SigmaScalar Sigmas

Med = median(LRats);
if Med < 0.35    % decrease scalar for sigma
    SigmaScalar = 0.9*SigmaScalar;
else
    SigmaScalar = 1.1*SigmaScalar;
end
Sigmas = .5*Sigmas + .5*SigmaScalar*std(crntSamples);
end
