function genPlot3TaskVsPitchCompare
% plot the 3 conditions. y-axis ends at <= 3.125

load threshold
load dprimes

% load dannydata

% % individual plots
% makePlot(dprime,threshold(:,1));
% makePlot(dprime,threshold(:,2));
% makePlot(dprime,threshold(:,3));

% % subplots (1x3 plots of the Fixed,gap05,gap1 thresholds vs dp)
makeSubplot(dprime,threshold);

%% DANNY DATA

% % plot hist of dp along with what the dp distribution would look like if
% % remove thresholds above 50 cents
% 
% figure
% whichOnes = thresholdsPC < inf;
% myhist=histogram(TonalityD(whichOnes),10,'linewidth',2,'facecolor',[.7 .7 .7],'facealpha',1);
% get(myhist)
% whichOnes = thresholdsPC < 50;
% hold on
% histogram(TonalityD(whichOnes),'binedges',myhist.BinEdges+.04,'facecolor',[1 1 1],'facealpha',.7,'linewidth',2)
% xtick=-1:1:5;
% set(gca,'linewidth',2,'fontsize',18,'ytick',0:5:40)
% grid on
% box on
% xlim([-0.75,5])
% ylim([0,40])
% xticks(xtick)
% legend({'All listeners',sprintf('Listeners with\nthreshold <50cents')});
% ylabel('Number of listeners')
% xlabel('3-task-d^\prime')


%% JOSELYN DATA
% plot hist of dp along with what the dp distribution would look like if
% remove thresholds above 50 cents
% TonalityD = dprime;
% thresholdsPC = threshold(:,1);
figure
whichOnes = thresholdsPC < inf;
myhist=histogram(TonalityD(whichOnes),10,'linewidth',2,'facecolor',[.7 .7 .7],'facealpha',1);
get(myhist)
whichOnes = thresholdsPC < 50;
hold on
histogram(TonalityD(whichOnes),'binedges',myhist.BinEdges+.04,'facecolor',[1 1 1],'facealpha',.7,'linewidth',2)
xtick=-1:1:4;
set(gca,'linewidth',2,'fontsize',18,'ytick',0:5:40)
grid on
box on
xlim([-1,4.5])
ylim([0,35])
xticks(xtick)
legend({'All listeners',sprintf('Listeners with\nthreshold <50cents')});
ylabel('Number of listeners')
xlabel('3-task-d^\prime')

% histogram of thresholds per task
threshold(threshold<3.125) = 3.125;

low_threshold = threshold(:,1)<50;

threshold = log2(threshold);

binEdges = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 3.125/2]);
xTicks = (-log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]));
xTickVals = 2.^(-xTicks);
% figure
% hold
% histogram(-threshold(:,3),10,'BinEdges',binEdges,'linewidth',2);
% histogram(-threshold(:,2),10,'BinEdges',binEdges,'facecolor','y','linewidth',2)
% histogram(-threshold(:,1),10,'BinEdges',binEdges,'facecolor','g','linewidth',2)
% set(gca,'linewidth',2,'fontsize',15,'xtick',xTicks,'xticklabel',xTickVals)
% grid on
% box on
% legend({'Fixed','Gap-1','Gap-.5'})

% % bar grouped
% figure;
% counts = [1,4,7;1,9,7;1,13,12;5,10,13;11,13,11;16,25,25;20,21,19;27,3,3;13,1,0;4,0,2];
% bar(counts,'Grouped')
% set(gca,'linewidth',2,'fontsize',15,'xticklabel',xTickVals)
% legend({'Fixed','Gap-1','Gap-.5'})
% title('Histogram of thresholds. xticks refers to upper edge of threshold bin')

% % scatterplot gap-.5 vs fixed
% figure;
% scatter(-threshold(:,1),-threshold(:,3),100,'k','linewidth',4)
% hold on
% plot([-log2(1600) -log2(2.3)],[-log2(1600) -log2(2.3)],'k--','linewidth',2);
% xlabel('Gap-0.5 task threshold (cents)')
% ylabel('Fixed task threshold (cents)')
% set(gca,'xtick',xTicks,'ytick',xTicks,'xticklabel',xTickVals,'yticklabel',xTickVals,'fontsize',16,'linewidth',2)
% xlim([-log2(1600) -log2(2.3)]) 
% ylim([-log2(1600) -log2(2.3)])
% axis on 
% box on
% grid on
% % edit y-axis label to show <=3.125
% labels = strsplit(num2str(xTickVals));
% labels{10}='\leq3.125';
% xticklabels(labels);yticklabels(labels);

% ratios of the Fixed threshold to the Gap-0.5 threshold
ratios1 = threshold(:,3)./threshold(:,1);
ratios2 = threshold(:,3)./threshold(:,2);

% histogram of the LOG2 ratios of the Fixed threshold to the roved
% thresholds
logratios1 = log2(threshold(:,3)./threshold(:,1));
logratios2 = log2(threshold(:,3)./threshold(:,2));
figure;
hObj=histogram(logratios1,10,'linewidth',2,'facecolor',[.7 .7 .7],'facealpha',1);
hold on
get(hObj)
histogram(logratios2,'binedges',hObj.BinEdges+.04,'facecolor',[1 1 1],'linewidth',2,'facealpha',.7);
xlabel('Ratio of thresholds')
ylabel('Number of listeners');
legend({'"Fixed" to "Gap-0.5"','"Fixed" to "Gap-1"'});
set(gca,'fontsize',16,'linewidth',2)
axis on 
box on
grid on
xl=xticklabels;
new_xticklabels=cellfun(@str2num,xl);
new_xticklabels = 2.^(new_xticklabels);
xticklabels(new_xticklabels);
xlim([-2 1.2])
ylim([0 31])

disp('Log ratios 1, mean:');
mean(logratios1)
disp('Log ratios 1, std error:');
std(logratios1)./sqrt(length(logratios1))
disp('Log ratios 2, mean:');
mean(logratios2)
disp('Log ratios 2, std error:');
std(logratios2)./sqrt(length(logratios2))


%% same as above but separating participants based on roved threshold above/below 50 cents

% histogram of the LOG2 ratios of the Fixed threshold to the roved
% thresholds

logratios1_low = log2(threshold(low_threshold,3)./threshold(low_threshold,1));
logratios2_low = log2(threshold(low_threshold,3)./threshold(low_threshold,2));

logratios1_high = log2(threshold(~low_threshold,3)./threshold(~low_threshold,1));
logratios2_high = log2(threshold(~low_threshold,3)./threshold(~low_threshold,2));

disp('LOW thresholds...Log ratios 1, mean:');
mean(logratios1_low)
disp('Log ratios 1, std error:');
std(logratios1_low)./sqrt(length(logratios1_low))
disp('Log ratios 2, mean:');
mean(logratios2_low)
disp('Log ratios 2, std error:');
std(logratios2_low)./sqrt(length(logratios2_low))

disp('HIGH thresholds...Log ratios 1, mean:');
mean(logratios1_high)
disp('Log ratios 1, std error:');
std(logratios1_high)./sqrt(length(logratios1_high))
disp('Log ratios 2, mean:');
mean(logratios2_high)
disp('Log ratios 2, std error:');
std(logratios2_high)./sqrt(length(logratios2_high))

% unequal variance ttest
disp('Log ratio 1');
[H,P,CI,STATS] = ttest2(logratios1_low,logratios1_high,'vartype','unequal');
% t = 2.3418, df = 93.2029, p = 0.0213
disp('Log ratio 2');
[H,P,CI,STATS] = ttest2(logratios2_low,logratios2_high,'vartype','unequal');
% t = .2068, df = 96.72, p = 0.8366

figure;
hObj=histogram(logratios1_low,10,'linewidth',2,'facecolor',[.7 .7 .7],'facealpha',1);
hold on
get(hObj)
histogram(logratios2_low,'binedges',hObj.BinEdges+.04,'facecolor',[1 1 1],'linewidth',2,'facealpha',.7);
xlabel('Ratio of thresholds')
ylabel('Number of listeners');
title('Low thresholds');
legend({'"Fixed" to "Gap-0.5"','"Fixed" to "Gap-1"'});
set(gca,'fontsize',16,'linewidth',2)
axis on 
box on
grid on
xl=xticklabels;
new_xticklabels=cellfun(@str2num,xl);
new_xticklabels = 2.^(new_xticklabels);
xticklabels(new_xticklabels);
xlim([-2 1.2])
ylim([0 31])

figure;
hObj=histogram(logratios1_high,10,'linewidth',2,'facecolor',[.7 .7 .7],'facealpha',1);
hold on
get(hObj)
histogram(logratios2_high,'binedges',hObj.BinEdges+.04,'facecolor',[1 1 1],'linewidth',2,'facealpha',.7);
xlabel('Ratio of thresholds')
ylabel('Number of listeners');
title('High thresholds');
legend({'"Fixed" to "Gap-0.5"','"Fixed" to "Gap-1"'});
set(gca,'fontsize',16,'linewidth',2)
axis on 
box on
grid on
xl=xticklabels;
new_xticklabels=cellfun(@str2num,xl);
new_xticklabels = 2.^(new_xticklabels);
xticklabels(new_xticklabels);
xlim([-2 1.2])
ylim([0 31])

end

function makePlot(TonalityD,thresholdsPC)
% individual plots

thresholdsPC(thresholdsPC<3.125) = 3.125;

figure

log2Thresholds = log2(thresholdsPC);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds,100,'k','linewidth',4)
whichOnes = thresholdsPC > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(2.3)]) % I extended the upper limit a little to allow some space
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')
ylabel('Pitch-difference threshold (cents)')

% edit y-axis label to show <=3.125
labels = strsplit(num2str(yTickVals));
labels{10}='\leq3.125';
yticklabels(labels);

end

function makeSubplot(TonalityD,thresholdsPC)
% 3-in-1 plot

fontSize = 14;
y = .2;
wd = .28;
ht = .75;

thresholdsPC(thresholdsPC<3.125) = 3.125;

figure('Renderer', 'painters', 'units','normalized','Position', [0 .3 1 .6])

log2Thresholds = log2(thresholdsPC);

% subplot 1
subplot('Position',[.1 y wd ht]);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds(:,1),100,'k','linewidth',4)
whichOnes = thresholdsPC(:,1) > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes,1),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',fontSize,'linewidth',2)
ylim([-log2(1600) -log2(2.3)]) % I extended the upper limit a little to allow some space
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')
ylabel('Pitch-difference threshold (cents)')

% edit y-axis label to show <=3.125
labels = strsplit(num2str(yTickVals));
labels{10}='\leq3.125';
yticklabels(labels);

text(4.5,-10.1,'A','fontsize',20)

% subplot 2
subplot('Position',[.12+wd y wd ht]);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds(:,2),100,'k','linewidth',4)
whichOnes = thresholdsPC(:,2) > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes,2),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',{},'fontsize',fontSize,'linewidth',2)
ylim([-log2(1600) -log2(2.3)]) % I extended the upper limit a little to allow some space
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')

text(4.5,-10.1,'B','fontsize',20)

% subplot 3
subplot('Position',[.14+wd+wd y wd ht]);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds(:,3),100,'k','linewidth',4)
whichOnes = thresholdsPC(:,3) > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes,3),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',{},'fontsize',fontSize,'linewidth',2)
ylim([-log2(1600) -log2(2.3)]) % I extended the upper limit a little to allow some space
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')

text(4.5,-10.1,'C','fontsize',20)

end

