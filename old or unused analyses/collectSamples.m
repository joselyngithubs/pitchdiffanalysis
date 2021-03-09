function collectSamples
% Save the last 10,000 of 500,000 samples per subject from
% MCMCLowSameHigh2Crits (4 params)
% Each subject is ran twice (prevSample alpha = .25 and .75)

tic;

sourceLoc = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';
files = dir('C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\*.mat');
files = {files.name};

nSamplesToRun = 500000; % number of samples from the mcmc
nSamplesToSave = 10000; % last n samples to keep

% params
alphas = NaN(length(files),nSamplesToSave);
noiseSigma = NaN(length(files),nSamplesToSave);
C1 = NaN(length(files),nSamplesToSave);
C2 = NaN(length(files),nSamplesToSave);

for f=1:length(files)
    fprintf('File %d of %d\n',f,length(files));
    load([sourceLoc files{f}]);
    
    d=prepData(data);
    samples = MCMCLowSameHigh2Crits(d, nSamplesToRun);
    
    alphas(f,:) = samples(nSamplesToRun-nSamplesToSave+1:end,1);
    noiseSigma(f,:) = samples(nSamplesToRun-nSamplesToSave+1:end,2);
    C1(f,:) = samples(nSamplesToRun-nSamplesToSave+1:end,3);
    C2(f,:) = samples(nSamplesToRun-nSamplesToSave+1:end,4);
    
    clear d
    clear samples
end

save mcmcSamples_alpha25 alphas noiseSigma C1 C2

toc;
end