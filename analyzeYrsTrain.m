load yrsTrain
load dprimes
load threshold

% set the max of yrsTrain to 14
yrsTrain(yrsTrain>14) = 14;

%% dp vs yrs training
figure('Renderer', 'painters', 'units','normalized','Position', [0 0 .55 1])
% subplot(2,1,1);
subplot('Position',[.2 .565 .75 .425]);
scatter(yrsTrain,dprime,100,'k','linewidth',4)
axis on
box on
grid on
% xlabel('Years of music training');
y1=ylabel('3-task-d^\prime');
set(y1,'position',[-2.9,2])
xlim([min(yrsTrain)-1 max(yrsTrain)+1])
ylim([-1 4.5])
xTicks = [0,5,10,14];
set(gca,'xtick',xTicks,'fontsize',14,'linewidth',2)
[r1,p1] = corrcoef(yrsTrain,dprime);
plotRegLine(yrsTrain,dprime,[min(yrsTrain)-1 max(yrsTrain)+1]);
text(11,-.35,sprintf('r = %.2f\np < .01',r1(2)),'fontsize',12);
text(-4.9,4.5,'A','fontsize',20)
% title(sprintf('r = %.2f, p < .01',r1(2)));

% % edit x-axis label to show >=14
% labels = {'0','5','10','\geq14'};
% xticklabels(labels);
xticklabels({});

%% threshold in cents

thresholdsPC = threshold(:,1);
thresholdsPC(thresholdsPC<3.125) = 3.125;

% subplot(2,1,2)
subplot('Position',[.2 .1 .75 .425]);

log2Thresholds = log2(thresholdsPC);
hold on
scatter(yrsTrain,-log2Thresholds,100,'k','linewidth',4)
% yVals = round(2.^(1:.25:3.5));
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125 1.5625])
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25 3.125]);
yTickVals = 2.^(-yTicks);
xTicks = [0,5,10,14];
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',14,'linewidth',2)
ylim([-log2(1600) -log2(2.3)])
axis on
box on
grid on
xlabel('Years of music training');
ylabel('Pitch-difference-threshold (cents)')
[r1,p1] = corrcoef(yrsTrain,-log2Thresholds);
plotRegLine(yrsTrain,-log2Thresholds,[min(yrsTrain)-1 max(yrsTrain)+1]);
% title(sprintf('r = %.2f, p < 0.01',r1(2)));
text(11,-9.7,sprintf('r = %.2f\np < .01',r1(2)),'fontsize',12);
text(-4.9,-2,'B','fontsize',20)

% edit y-axis label to show <=3.125
labels = strsplit(num2str(yTickVals));
labels{10}='\leq3.125';
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