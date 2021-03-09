function stat = pitchdifftablestats
% stat = ratio of (A+B)/(C+D+0.5); plot stat against threshold on PD 0.5 Task
% A = respond H on L trials
% B = respond L on H trials
% C = respond S on L trials
% D = respond S on H trials

% load subject data
files = dir('data\*.csv');
files = {files.name};
nSubj = length(files);

stat = NaN(nSubj,1); 
threshold = NaN(nSubj,1);

for f=1:length(files)
    [~,~,d] = xlsread(['data\' files{f}],'G1:G1');
    if strcmp(d,'headphoneCheck') % contains a col for headphone check
        d = xlsread(['data\' files{f}],'H2:S551');
        headphoneCheck(f) = xlsread(['data\' files{f}],'G2:G2');
    else
        d = xlsread(['data\' files{f}],'G2:R551');
    end
    
    howManyTrials = 100;
    
    %% 0.5 task threshold
    % PD Gap 0.5
    pd = d(d(:,1)==2,:);
    pd = [pd(:,4:5), pd(:,3), pd(:,6), pd(:,12)]; % rearrange
    pd = pd(30:end,:); % last 70 trials
    [a, b, WeibullData] = PitchCompareWeibull(pd);
    threshold(f) = getThreshold(WeibullData,a,b);
    
    %% Same/Different task
    d = d(d(:,1)==5,:); % grab just the s/d trials
    d = d(length(d)-howManyTrials+1:end,:);
    TrialType = d(:,3);
    Resp = d(:,6);
    % higher (0), lower (1), same (2)
    
    subject_table = NaN(3,3);
    
    %% stim L
    curr_set = TrialType==1;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(1,1) = sum(curr_resp==1);
    % resp S
    subject_table(1,2) = sum(curr_resp==2);
    % resp H
    subject_table(1,3) = sum(curr_resp==0);
    
    %% stim S
    curr_set = TrialType==2;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(2,1) = sum(curr_resp==1);
    % resp S
    subject_table(2,2) = sum(curr_resp==2);
    % resp H
    subject_table(2,3) = sum(curr_resp==0);
    
    %% stim H
    curr_set = TrialType==0;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(3,1) = sum(curr_resp==1);
    % resp S
    subject_table(3,2) = sum(curr_resp==2);
    % resp H
    subject_table(3,3) = sum(curr_resp==0);
    
    %% compute stat
    A = subject_table(1,3);
    B = subject_table(3,1);
    C = subject_table(1,2);
    D = subject_table(3,2);
    stat(f) = (A + B)/(C + D + 0.5); % add 0.5 to denominator in case ==0
    
end

figure;
plot(stat,threshold,'o');
xlabel('stat');
ylabel('threshold on 0.5 task');

end

function [A, B, WeibullData] = PitchCompareWeibull(Data)

DataDim = size(Data);
MinProb = .5;
MaxProb = .98;
Incorrect = Data(:,3)~=Data(:,4);
Correct = Data(:,3)==Data(:,4);
AbsCents = abs(log2(Data(:,2)./Data(:,1)))*1200;
WeibullData = [AbsCents Correct Incorrect];
[A, B] = FitWeibull(WeibullData,MinProb,MaxProb);

end

function threshold = getThreshold(WeibullData,A,B)

[~,index] = sort(WeibullData(:,1));
sorteddata = WeibullData(index,:);

nBins = 7;
means = NaN(nBins,1);
propCorrect = NaN(nBins,1);

for i=1:nBins % if 7 bins, 10 trials per bin
    group = sorteddata((i-1)*10+1:i*10,:);
    means(i) = mean(group(:,1));
    propCorrect(i) = sum(group(:,2))/(sum(group(:,2))+sum(group(:,3)));
end

domain = 0:0.01:max(means);
f = Weibull(domain,A,B,0.5,0.98);

I = find(f<.8,1,'last'); % find index of 80% threshold
if isempty(I)
    threshold = NaN;
else
    threshold = domain(I);
end

end