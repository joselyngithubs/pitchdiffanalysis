load yrsTrain
load dprimes
load threshold

% set the max of yrsTrain to 14
yrsTrain(yrsTrain>14) = 14;

%% dp vs yrs training
figure;
scatter(yrsTrain,dprime,100,'k','linewidth',4)
axis on
box on
grid on
xlabel('Years of music training');
ylabel('3-task-d^\prime');
xlim([min(yrsTrain)-1 max(yrsTrain)+1])
ylim([-1 5])
xTicks = [0,5,10,14];
set(gca,'xtick',xTicks,'fontsize',16,'linewidth',2)
[r1,p1] = corrcoef(yrsTrain,dprime);
plotRegLine(yrsTrain,dprime,[min(yrsTrain)-1 max(yrsTrain)+1]);
% title(sprintf('r = %.2f, p < .01',r1(2)));

% edit x-axis label to show >=14
labels = {'0','5','10','\geq14'};
xticklabels(labels);

%% threshold in cents

thresholdsPC = threshold(:,3);
thresholdsPC(thresholdsPC<6.25) = 6.25;

figure

log2Thresholds = log2(thresholdsPC);
hold on
scatter(yrsTrain,-log2Thresholds,100,'k','linewidth',4)
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
xTicks = [0,5,10,14];
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
axis on
box on
grid on
xlabel('Years of music training');
ylabel('Pitch-difference threshold (cents)')
[r1,p1] = corrcoef(yrsTrain,-log2Thresholds);
plotRegLine(yrsTrain,-log2Thresholds,[min(yrsTrain)-1 max(yrsTrain)+1]);
% title(sprintf('r = %.2f, p < 0.01',r1(2)));

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);

% edit x-axis label to show >=14
labels = {'0','5','10','\geq14'};
xticklabels(labels);

function plotRegLine(x,y,xlims,color)
if nargin<4
    color = 'k';
end

M = [ones(length(y),1) x(:)];
weights = pinv(M)*y(:);
hold on
plot(xlims,weights(1)+weights(2)*xlims,color,'linewidth',2)
xlim(xlims);
end 