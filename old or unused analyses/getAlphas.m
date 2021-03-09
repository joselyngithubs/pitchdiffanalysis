function alphas = getAlphas
tic;
sourceLoc = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';
files = dir('C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\*.mat');
files = {files.name};

alphas = NaN(length(files),2);
% col 1 = mean alpha
% col 2 = std alpha

nSamples = 1000000; % number of samples from the mcmc

for f=1:length(files)
    fprintf('\nFile %d of %d',f,length(files));
    load([sourceLoc files{f}]);
    
    d=prepData(data);
    samples = MCMCLowSameHigh2Crits(d, nSamples);
    
    alpha = samples(999000:end,1);
    alphas(f,1) = mean(alpha);
    alphas(f,2) = std(alpha);
end

save alphas alphas

toc;
end