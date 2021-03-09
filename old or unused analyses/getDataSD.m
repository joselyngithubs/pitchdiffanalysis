function [TrialType,PitchDiff,Resp] = getDataSD
% get data (last 70 trials) of all participants for the same/different pitch diff task.
% TrialType: nTrials x nSubjs
% PitchDiff: nTrials x nSubjs
% Resp: which response type the participant gave on each trial (nTrials x nSubjs)

% % read in all data from the mcmc data folder
files = dir('data\mcmc\*.csv');
files = {files.name};

howManyTrials = 100; % last 70

TrialType = NaN(howManyTrials,length(files));
PitchDiff = NaN(howManyTrials,length(files));
Resp = NaN(howManyTrials,length(files));

acc  = NaN(1,length(files));

for f=1:length(files)
    
    [~,~,d] = xlsread(['data\' files{f}],'G1:G1');
    if strcmp(d,'headphoneCheck') % contains a col for headphone check
        d = xlsread(['data\' files{f}],'H2:S551');
%         headphoneCheck(f) = xlsread(['data\' files{f}],'G2:G2'); %
%         uncomment this if want to exclude data based on headphoneCheck
%         criteria
    else
        d = xlsread(['data\' files{f}],'G2:R551');
    end
    
    d = d(d(:,1)==5,:); % grab just the s/d trials
    d = d(length(d)-howManyTrials+1:end,:); % last 70 trials
    TrialType(:,f) = d(:,3);
    Resp(:,f) = d(:,6);
    PitchDiff(:,f) = log2(d(:,5)./d(:,4))*1200;

    acc(f) = sum(d(:,3)==d(:,6))/size(d,1);
end

% acc
% mean(acc)

end