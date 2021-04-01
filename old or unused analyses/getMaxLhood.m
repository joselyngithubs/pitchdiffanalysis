function [params,NLL] = getMaxLhood

sourceLoc = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';
files = dir([sourceLoc '*.mat']);
files = {files.name};

nFiles = length(files);

params = NaN(nFiles,4);
NLL = NaN(nFiles,1);

for f=1:nFiles
    
    load([sourceLoc files{f}]);
    d=prepData(data);
    
    [params(f,:),NLL(f)] = FitGaussAlpha(d);
    
end

end