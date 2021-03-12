function genPlot3TaskVsPitchCompare
% plot the roved (0.5 and 1 sec gap) conditions (different axes than the fixed condition)

load threshold
load dprimes

% makePlotRoved(dprime,threshold(:,1));
% makePlotRoved(dprime,threshold(:,2));
% makePlotFixed(dprime,threshold(:,3));

% plot hist of dp along with what the dp distribution would look like if
% remove thresholds above 50 cents
TonalityD = dprime;
thresholdsPC = threshold(:,1);
figure
hold
whichOnes = thresholdsPC < inf;
hObj=histogram(TonalityD(whichOnes),10,'linewidth',2);
get(hObj)
whichOnes = thresholdsPC < 50;
histogram(TonalityD(whichOnes),'binedges',hObj.BinEdges,'facecolor','y','linewidth',2)
set(gca,'linewidth',2,'fontsize',20,'ytick',0:5:40)
grid on
box on
xlim([-0.8,5])
ylim([0,40])

end

function makePlotRoved(TonalityD,thresholdsPC)

thresholdsPC(thresholdsPC<6.25) = 6.25;

figure

log2Thresholds = log2(thresholdsPC);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds,100,'k','linewidth',4)
whichOnes = thresholdsPC > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')
ylabel('Pitch-difference threshold (cents)')

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);

end

function makePlotFixed(TonalityD,thresholdsPC)

figure

log2Thresholds = log2(thresholdsPC);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds,100,'k','linewidth',4)
whichOnes = thresholdsPC > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(1.5625)])
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')
ylabel('Pitch-difference threshold (cents)')

end