function [samples, LogL, Sigmas, sigmaScalar] = MCMCLowSameHigh2Crits(Data, NumSamples, Prevs, Sigmas, sigmaScalar, fixSampling)

% note - some of these comments may refer to a previous model

% [samples, LogL, Sigmas, sigmaScalar] = MCMCLowSameHigh(Data, NumSamples, Prevs, Sigmas, sigmaScalar, fixSampling)
%
% model says
%
% internal stat = alpha*|D| + (1-alpha)*D + Noise*sigma;
%
% and on each trial, subject sets
%
% If alpha < 0.5, 
%     C1 = (alpha*|D|-(1-alpha)*|D|)/2 = (2*alpha-1)*|D|/2 (i.e., half way between 0 and mean if 
%     D < 0)   
%         and   
%     C2 = D/2 (i.e., half way between 0 and mean if D > 0)
% If alpha > 0.5 (both criteria need to be positive because stat is
% dominated by absolute value of D:
%     If D < 0, then the mean of the statistic is (2*alpha-1)*|D|; hence
%     optimal C1 is (2*alpha-1)*|D|/2.
%     If D > 0, then the mean of the statistic is D; hence
%     optimal C1 is (C1+|D|)/2 = alpha*D.

global NumParams D Response SigmaScalar posMean negMean

UpdateBlockSz = 5000;
NumParams = 4;  % alpha and sigma plus C1 and C2

if nargin < 6 || isempty(fixSampling)
    fixSampling = false;
end

if nargin < 5 || isempty(sigmaScalar)
    SigmaScalar = 0.01;
end

if nargin < 4 || isempty(Sigmas)
    Sigmas = [0.01 1 1 1];
end

if nargin < 3 || isempty(Prevs)
    Prevs = [0.25 300 200 600];
end

if nargin < 2 || isempty(NumSamples)
    NumSamples = 100000;
end

Mins = [0 0 -1200 -1200];
Maxes = [1 1200 1200 1200];

D = Data(:,1);
CorrectResp = Data(:,2);
Response = Data(:,3);
firstError = find(CorrectResp ~= Response,1);
tmp = Data(firstError:end,:);

whichOnes = tmp(:,1) > 0;
posMean = mean(tmp(whichOnes));
whichOnes = tmp(:,1) < 0;
negMean = mean(tmp(whichOnes));

samples = NaN(NumSamples,NumParams);
samples(1,:) = Prevs;
LogL(1,:) = GetLogLikelihood(Prevs);

UpdateBlockCtr = 0;
LRats = NaN(UpdateBlockSz,1);
for k = 2:NumSamples
    UpdateBlockCtr = UpdateBlockCtr+1;
    Candidate = GetCandidate(samples(k-1,:),Mins,Maxes,Sigmas);
    LogLhoodCand = GetLogLikelihood(Candidate);
    LRats(UpdateBlockCtr) = exp(LogLhoodCand - LogL(k-1));
    if rand < LRats(UpdateBlockCtr)   % keep the candidate sample
        samples(k,:) = Candidate;
        % LogLhoodCand
        LogL(k) = LogLhoodCand;
    else
        samples(k,:) = samples(k-1,:);
        LogL(k) = LogL(k-1);
    end
    if UpdateBlockCtr == UpdateBlockSz
        fprintf('iter = %d, median likelihood ratio = %0.2f\n',k,median(LRats));
        if ~fixSampling
            Sigmas = UpdateSigmas(Sigmas,samples(k-UpdateBlockSz+1:k,:),LRats);
        end
        UpdateBlockCtr = 0;
    end
end
sigmaScalar = SigmaScalar;
end

function LogL = GetLogLikelihood(Params)

global D Response

alpha = Params(1);
noiseSigma = Params(2);
C1 = Params(3);
C2 = Params(4);
% if alpha > 0.5
%     'hi'
% end
statMean = alpha*abs(D) + (1-alpha)*D;
if alpha >= 0.5
%     C1 = (2*alpha - 1) * abs(negMean)/2;  
%     C2 = (C1 + posMean)/2;
    whichOnes = Response == 0;
    PZeroResps = cumgauss((C1 - statMean(whichOnes))/noiseSigma);  % if alpha > 0.5, then expected stat for D==0 is lower than for D < 0
    whichOnes = Response == -1;
    PMinusOneResps = cumgauss((C2 - statMean(whichOnes))/noiseSigma)-cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 1;
    POneResps = 1-cumgauss((C2 - statMean(whichOnes))/noiseSigma);
else   % alpha < 0.5
%     C1 = (2*alpha-1)*negMean/2;
%     C2 = posMean/2;
    whichOnes = Response == -1;
    PMinusOneResps = cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 0;
    PZeroResps = cumgauss((C2 - statMean(whichOnes))/noiseSigma)-cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 1;
    POneResps = 1-cumgauss((C2 - statMean(whichOnes))/noiseSigma);
end
prob = [PMinusOneResps(:);PZeroResps(:);POneResps(:)];
prob(prob > 0.99) = 0.99;
prob(prob < 0.01) = 0.01;
LogL = sum(log(prob));
% fprintf('alpha = %0.2f sigma = %0.2f  LogL = %0.2f\n',alpha,noiseSigma,LogL);
end

function    NextCandidate = GetCandidate(tmpC,Mins,Maxes,sigmas)

tmp = tmpC + randn(size(sigmas)).*sigmas;
cnt = 1;
while cnt < 100 && any(tmp < Mins) || any(tmp > Maxes)
    tmp = tmpC + randn(size(sigmas)).*sigmas;
    cnt=cnt+1;
end
if cnt >= 100
    error('cnt == 100');
end
NextCandidate=tmp;
end


function   Sigmas = UpdateSigmas(Sigmas,crntSamples,LRats)

global SigmaScalar

Med = median(LRats);
if Med < 0.35    % decrease scalar for sigma
    SigmaScalar = 0.9*SigmaScalar;
else
    SigmaScalar = SigmaScalar/0.9;
end
Sigmas = 0.5*Sigmas + 0.5*SigmaScalar*std(crntSamples);
end
