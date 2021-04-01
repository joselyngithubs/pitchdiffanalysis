function [params,startAlpha] = pickStartingPoint

load MaxLhood_alpha25

NLL25 = NLL;
params25 = params;

load MaxLhood_alpha75

NLL75 = NLL;
params75 = params;

clear NLL params

nSubj = length(NLL75);

params = NaN(nSubj,4);
startAlpha = NaN(nSubj,1);

for s=1:nSubj
    if NLL25(s) < NLL75(s)
        params(s,:) = params25(s,:);
        startAlpha(s) = 25;
    else
        params(s,:) = params75(s,:);
        startAlpha(s) = 75;
    end
end

load dprimes
load threshold

%%%%

figure;
h1 = axes;
scatter(params(:,1),dprime,100,'k','linewidth',4);
hold on
% plot([-1,5],[0.5,0.5],'k--','linewidth',2);
ylim([-1 5])
xlim([-0.05 1])
set(h1, 'Ydir', 'reverse');
ylabel('d^\prime')
xlabel('\alpha')
set(gca,'fontsize',16,'linewidth',2)
% set(h,'rotation',0,'Position',[-1.75 0.5 -1.0000])
axis on
box on
grid on
xticks(0:0.25:1)

%%%%

% figure;
% h1 = axes;
% scatter(dprime,params(:,1),100,'k','linewidth',4);
% hold on
% plot([-1,5],[0.5,0.5],'k--','linewidth',2);
% xlim([-1 5])
% ylim([-0.05 1])
% set(h1, 'Ydir', 'reverse');
% xlabel('d^\prime')
% h = ylabel('\alpha')
% set(gca,'fontsize',16,'linewidth',2)
% set(h,'rotation',0,'Position',[-1.75 0.5 -1.0000])
% axis on
% box on

%%%%

thresholdsPC = threshold(:,1);
thresholdsPC(thresholdsPC<6.25) = 6.25;

figure

log2Thresholds = log2(thresholdsPC);
hold on
plot([-0.05 1],-log2(50)*[1 1],'k--','linewidth',2)
scatter(params(:,1),-log2Thresholds,100,'k','linewidth',4)
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
xlim([-0.05 1])
axis on
box on
grid on
xlabel('\alpha')
ylabel('Pitch-difference threshold (cents)')
xticks(0:0.25:1)

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);


end