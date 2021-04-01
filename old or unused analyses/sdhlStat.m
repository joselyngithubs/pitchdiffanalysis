function sdhlStat

sourceLoc = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';
files = dir([sourceLoc '*.mat']);
files = {files.name};

nFiles = length(files);

p_sd = NaN(nFiles,1);
p_hl = NaN(nFiles,1);
sdhlStats = NaN(nFiles,1);

for f=1:nFiles
    
    load([sourceLoc files{f}]);
    data = data(data(:,1)==5,[3,6,7]); % type / response / isCorrect
    
    % grab only the trials starting after the 3rd error
    wrongTrials = find(data(:,3)==false);
    data = data(wrongTrials(3)+1:end,:);
    
    p_sd(f) = sd_treat(data);
    p_hl(f) = hl_treat(data);
    
    sdhlStats(f) = norminv(p_sd(f)) / norminv(p_hl(f));
end

load threshold

% figure;
% hist(sdhlStats)

figure;
thresholdsPC = threshold(:,1);
thresholdsPC(thresholdsPC<6.25) = 6.25;
log2Thresholds = log2(thresholdsPC);
hold on
% plot([-1 8],-log2(50)*[1 1],'k--','linewidth',2)
scatter(sdhlStats,-log2Thresholds,100,'k','linewidth',4)
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
% xTicks = -.5:.5:5;
% set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
set(gca,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
% xlim([-1 8])
axis on
box on
grid on
xlabel('stat')
ylabel('Pitch-difference threshold (cents)')
title('norminv(p_{sd}) / norminv(p_{hl})')

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);

end

function pcorr = sd_treat(data)

data(data(:,1)<2,1) = 0; % re-labeling -- if higher or lower ("different"), mark as 0
data(data(:,1)>1,1) = 1; % re-labeling -- if "same", mark as 1
data(data(:,2)<2,2) = 0; % re-labeling -- if respond higher or lower ("different"), mark as 0
data(data(:,2)>1,2) = 1; % re-labeling -- if respond "same", mark as 1

pcorr = sum(data(:,1)==data(:,2))/length(data);

if pcorr==1
    pcorr = (sum(data(:,1)==data(:,2))-0.5)/length(data);
end

end

function pcorr = hl_treat(data)

data = data(data(:,1)<2,:); % only keep higher/lower trials

pcorr = sum(data(:,3))/length(data);

if pcorr==1
    pcorr = (sum(data(:,3))-0.5)/length(data);
end

end