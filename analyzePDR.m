function analyzePDR(plotAllData)
global plotSubjectData

% plot individual subject data if plotSubjectData == 1

if (nargin<1)
    plotSubjectData = 0;
else
    plotSubjectData = plotAllData;
end

files = dir('data\*.csv');
files = {files.name};

AllData = NaN(length(files),9);
% col 1 = dprime on tone-scrambles
% col 2-3 = A & B for PD Gap 0.5
% col 4-5 = A & B for PD Gap 1
% col 6-7 = A & B for PD Fixed
% col 8-9 = A & B for PD Same/Different

threshold = NaN(length(files),3);
% each row is a participant
% col 1 = PD Gap 0.5
% col 2 = PD Gap 1
% col 3 = PD Fixed
% will add 4th col later for s/d task

headphoneCheck = NaN(length(files),1);
% score out of 6
% the first 13 participants did not take this test

yrsTrain = NaN(length(files),1);

sd_acc = NaN(1,length(files));

figure;
m = 4;
n = 4;
nSubplot = 1;

for f=1:length(files)
    
    [~,~,d] = xlsread(['data\' files{f}],'G1:G1');
    if strcmp(d,'headphoneCheck') % contains a col for headphone check
        d = xlsread(['data\' files{f}],'H2:S551');
%         headphoneCheck(f) = xlsread(['data\' files{f}],'G2:G2');
        yrsTrain(f) = xlsread(['data\' files{f}],'E2:E2');
    else
        d = xlsread(['data\' files{f}],'G2:R551');
    end
    
    % we are assuming each participant did all trials of all tasks -- so
    % far, this is true
    
    fprintf('Subject %d\n',f);
    
    % analyze tone-scrambles
    ts = d(d(:,1)==1,:);
    ts = [ts(:,3), ts(:,6)];
    ts = ts(101:150,:); % last 50 trials
    % col 1 = trial type
    % col 2 = response
    dprime = analyzeDprime(ts);
    AllData(f,1) = dprime;
    
    % PD Gap 0.5
    pd = d(d(:,1)==2,:);
    pd = [pd(:,4:5), pd(:,3), pd(:,6), pd(:,12)]; % rearrange
    pd = pd(30:end,:); % last 70 trials
    [AllData(f,2), AllData(f,3), WeibullData] = PitchCompareWeibull(pd);
    subplot(m,n,(nSubplot-1)*4+1)
    threshold(f,1) = plotWeibullFunction(WeibullData,AllData(f,2),AllData(f,3),'PD Gap 0.5');
    
    % PD Gap 1
    pd = d(d(:,1)==3,:);
    pd = [pd(:,4:5), pd(:,3), pd(:,6), pd(:,12)]; % rearrange
    pd = pd(30:end,:); % last 70 trials
    [AllData(f,4), AllData(f,5), WeibullData] = PitchCompareWeibull(pd);
    subplot(m,n,(nSubplot-1)*4+2)
    threshold(f,2) = plotWeibullFunction(WeibullData,AllData(f,4),AllData(f,5),'PD Gap 1');
    
    % PD Fixed
    pd = d(d(:,1)==4,:);
    pd = [pd(:,4:5), pd(:,3), pd(:,6), pd(:,12)]; % rearrange
    pd = pd(31:end,:); % last 70 trials
    [AllData(f,6), AllData(f,7), WeibullData] = PitchCompareWeibull(pd);
    subplot(m,n,(nSubplot-1)*4+3)
    threshold(f,3) = plotWeibullFunction(WeibullData,AllData(f,6),AllData(f,7),'PD Fixed');
    
    % PD Same/Different
    pd = d(d(:,1)==5,:);
    pd(pd(:,3)<2,3) = 0; % re-labeling -- if higher or lower ("different"), mark as 0
    pd(pd(:,3)>1,3) = 1; % re-labeling -- if "same", mark as 1
    pd(pd(:,6)<2,6) = 0; % re-labeling -- if respond higher or lower ("different"), mark as 0
    pd(pd(:,6)>1,6) = 1; % re-labeling -- if respond "same", mark as 1
    sd_acc(f) = sum(pd(:,3)==pd(:,6))/length(pd);
    
    if(plotSubjectData==1)    
        subplot(m,n,(nSubplot-1)*4+4);
        text(0.1,0.5,sprintf('Tone-scramble dp= %.3f',dprime))
        text(0.1,0.25,sprintf('SD acc= %.3f',sd_acc(f)))
        if ~isnan(headphoneCheck(f))
            text(0.1,0,sprintf('Headphone check score out of 6 = %d',headphoneCheck(f)))
        end
        
        if (nSubplot-1)*4+4 == m*n
            figure;
            nSubplot = 1;
        else
            nSubplot = nSubplot+1;
        end
    end
end

% figure;hist(sd_acc);
% title(sprintf('mean s/d acc=%.3f, n=%d, not regarding direction',mean(sd_acc),length(sd_acc)));

% % headphoneCheck score vs tone-scramble dprime
% dp_all = AllData(:,1);
% dp_hc = dp_all(~isnan(headphoneCheck));
% hc = headphoneCheck(~isnan(headphoneCheck));
% figure
% plot(dp_hc,hc,'o');
% title(sprintf('N = %d',length(hc)));
% xlabel('tone-scramble dprime')
% ylabel('headphone check score out of 6')

% % remove subjects with headphoneCheck<5 % this has been taken care of
% AllData = AllData(~ismember(headphoneCheck,[1,2,3,4]),:);
% threshold = threshold(~ismember(headphoneCheck,[1,2,3,4]),:);

save yrsTrain yrsTrain

figure;
plot(yrsTrain,AllData(:,1),'o');
xlabel('DPrime');
ylabel('Yrs of music training');
xlim([min(yrsTrain)-1 max(yrsTrain)+1])
ylim([-.75 5])
grid on
[r1,p1] = corrcoef(yrsTrain,AllData(:,1));
plotRegLine(yrsTrain,AllData(:,1),[min(yrsTrain)-1 max(yrsTrain)+1]);

figure;
h1 = axes;
plot(AllData(:,1),threshold,'o');
set(h1, 'Ydir', 'reverse')
xlabel('DPrime');
ylabel('Pitch difference threshold (cents)');
legend({'Gap 0.5','Gap 1','Fixed'});
title(sprintf('N = %d',size(AllData,1)));
hold on
plot([-.75 5],[50 50],'k--')
xlim([-.75 5])
grid on

figure;
h1 = axes;
plot(AllData(:,1),threshold(:,1),'o');
set(h1, 'Ydir', 'reverse')
xlabel('DPrime');
ylabel('Pitch difference threshold (cents)');
legend({'Gap 0.5'});
title(sprintf('N = %d',size(AllData,1)));
hold on
plot([-.75 5],[50 50],'k--')
xlim([-.75 5])
grid on

figure;
h1 = axes;
plot(AllData(:,1),threshold(:,2),'o');
set(h1, 'Ydir', 'reverse')
xlabel('DPrime');
ylabel('Pitch difference threshold (cents)');
legend({'Gap 1'});
title(sprintf('N = %d',size(AllData,1)));
hold on
plot([-.75 5],[50 50],'k--')
xlim([-.75 5])
grid on

figure;
h1 = axes;
plot(AllData(:,1),threshold(:,3),'o');
set(h1, 'Ydir', 'reverse')
xlabel('DPrime');
ylabel('Pitch difference threshold (cents)');
legend({'Fixed'});
title(sprintf('N = %d',size(AllData,1)));
hold on
plot([-.75 5],[50 50],'k--')
xlim([-.75 5])
grid on

figure
hist(AllData(:,1));
title(sprintf('Tone-scramble DPrimes, N = %d',size(AllData,1)));
grid on

% compare thresholds between the 3 tasks
[~,P,~,STATS] = ttest(threshold(:,1),threshold(:,2));
fprintf('\n\nGap 0.5 vs Gap 1: t= %f, p= %f',STATS.tstat,P);
[~,P,~,STATS] = ttest(threshold(:,1),threshold(:,3));
fprintf('\n\nGap 0.5 vs Fixed: t= %f, p= %f',STATS.tstat,P);
[~,P,~,STATS] = ttest(threshold(:,2),threshold(:,3));
fprintf('\n\nGap 1 vs Fixed: t= %f, p= %f',STATS.tstat,P);


end

function dprime = analyzeDprime(data)

types = data(:,1);
resps = data(:,2);

nSignalTrials = sum(types==2); % major
nNoiseTrials = sum(types==1); % minor

nHits = sum(types==2 & resps==2);
nMisses = sum(types == 2 & resps == 1);
nCRs = sum(types==1 & resps==1);
nFAs = sum(types==1 & resps==2);

pHit = nHits/nSignalTrials;
pMiss = nMisses/nSignalTrials;
pCR = nCRs/nNoiseTrials;
pFA = nFAs/nNoiseTrials;

if pHit == 1
    pHit = (nSignalTrials - 0.5) / nSignalTrials;
end
if pFA == 1
    pFA = (nNoiseTrials - 0.5) / nNoiseTrials;
end
if pHit == 0
    pHit = 0.5 / nSignalTrials;
end
if pFA == 0
    pFA = 0.5 / nNoiseTrials;
end

dprime = norminv(pHit)-norminv(pFA);

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

function threshold = plotWeibullFunction(WeibullData,A,B,plotName)
global plotSubjectData

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

if(plotSubjectData==1)
    plot(domain,f);
    hold
    plot(means,propCorrect,'o');
    grid on
    ylim([0.4 1])
    title(sprintf([plotName ', 80%% thresh = %.3f'],threshold))
end


end

function plotRegLine(x,y,xlims,color)
if nargin<4
    color = 'k';
end

M = [ones(length(y),1) x(:)];
weights = pinv(M)*y(:);
hold on
plot(xlims,weights(1)+weights(2)*xlims,color,'linewidth',1)
xlim(xlims);
end 