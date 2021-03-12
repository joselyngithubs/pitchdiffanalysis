load yrsTrain
load dprimes
load threshold

% dp vs yrs training
figure;
plot(yrsTrain,dprime,'ko','markersize',12,'linewidth',2,'markerfacecolor',0.7*[1 1 1]);
xlabel('Yrs of music training');
ylabel('DPrime');
xlim([min(yrsTrain)-1 max(yrsTrain)+1])
ylim([-1 5])
grid on
[r1,p1] = corrcoef(yrsTrain,dprime);
plotRegLine(yrsTrain,dprime,[min(yrsTrain)-1 max(yrsTrain)+1]);
title(sprintf('r = %.2f, p < .01',r1(2)));
set(gca,'fontsize',18);

% remove people with 0 years
keep= yrsTrain>0;
figure;
plot(yrsTrain(keep),dprime(keep),'ko','markersize',12,'linewidth',2,'markerfacecolor',0.7*[1 1 1]);
xlabel('Yrs of music training');
ylabel('DPrime');
xlim([min(yrsTrain(keep))-1 max(yrsTrain(keep))+1])
ylim([-1 5])
grid on
[r1,p1] = corrcoef(yrsTrain(keep),dprime(keep));
plotRegLine(yrsTrain(keep),dprime(keep),[min(yrsTrain(keep))-1 max(yrsTrain(keep))+1]);
title(sprintf('r = %.2f, p = %.2f',r1(2),p1(2)));
set(gca,'fontsize',18);

% figure;
% h1 = axes;
% scatter(yrsTrain,dprime,100,'k','linewidth',4);
% hold on
% % plot([-1,5],[0.5,0.5],'k--','linewidth',2);
% ylim([min(yrsTrain)-1 max(yrsTrain)+1])
% xlim([-0.05 1])
% set(h1, 'Ydir', 'reverse');
% ylabel('d^\prime')
% xlabel('Years of music training')
% set(gca,'fontsize',16,'linewidth',2)
% % set(h,'rotation',0,'Position',[-1.75 0.5 -1.0000])
% axis on
% box on
% grid on

%%%%

thresholdsPC = threshold(:,1);
thresholdsPC(thresholdsPC<6.25) = 6.25;

figure

% cents

% include 0's
log2Thresholds = log2(thresholdsPC);
hold on
% plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(yrsTrain,-log2Thresholds,100,'k','linewidth',4)
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
% xTicks = -.5:.5:5;
set(gca,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
% xlim([-.8 5])
axis on
box on
grid on
xlabel('yrs music')
ylabel('Pitch-difference threshold (cents)')
[r1,p1] = corrcoef(yrsTrain,-log2Thresholds);
plotRegLine(yrsTrain,-log2Thresholds,[min(yrsTrain)-1 max(yrsTrain)+1]);
title(sprintf('r = %.2f, p = %.2f',r1(2),p1(2)));

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);

% remove 0's
thresholdsPC = thresholdsPC(keep);
figure;
log2Thresholds = log2(thresholdsPC);
hold on
% plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(yrsTrain(keep),-log2Thresholds,100,'k','linewidth',4)
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
% xTicks = -.5:.5:5;
set(gca,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
% xlim([-.8 5])
axis on
box on
grid on
xlabel('yrs music')
ylabel('Pitch-difference threshold (cents)')
[r1,p1] = corrcoef(yrsTrain(keep),-log2Thresholds);
plotRegLine(yrsTrain(keep),-log2Thresholds,[min(yrsTrain(keep))-1 max(yrsTrain(keep))+1]);
title(sprintf('r = %.2f, p = %.2f',r1(2),p1(2)));

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);

% threshold vs yrs training, not cents

thresh = threshold(:,1);
figure;
plot(yrsTrain,thresh,'ko','markersize',12,'linewidth',2,'markerfacecolor',0.7*[1 1 1]);
xlabel('Yrs of music training');
ylabel('Threshold');
xlim([min(yrsTrain)-1 max(yrsTrain)+1])
% ylim([-1 5])
grid on
[r1,p1] = corrcoef(yrsTrain,thresh);
plotRegLine(yrsTrain,thresh,[min(yrsTrain)-1 max(yrsTrain)+1]);
title(sprintf('r = %.2f, p = %.2f',r1(2),p1(2)));
set(gca,'fontsize',18);

% remove people with 0 years
figure;
plot(yrsTrain(keep),thresh(keep),'ko','markersize',12,'linewidth',2,'markerfacecolor',0.7*[1 1 1]);
xlabel('Yrs of music training');
ylabel('Threshold');
xlim([min(yrsTrain(keep))-1 max(yrsTrain(keep))+1])
% ylim([-1 5])
grid on
[r1,p1] = corrcoef(yrsTrain(keep),thresh(keep));
plotRegLine(yrsTrain(keep),thresh(keep),[min(yrsTrain(keep))-1 max(yrsTrain(keep))+1]);
title(sprintf('r = %.2f, p = %.2f',r1(2),p1(2)));
set(gca,'fontsize',18);

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