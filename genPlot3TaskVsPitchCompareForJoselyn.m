function genPlot3TaskVsPitchCompare

Red = [1, 0, 0];
Blue = [0 .3 1];
cmap = cos((0:200)'*pi/400)*Red + sin((0:200)'*pi/400)*Blue;

% First plot threshPC against 3-task-D'--reverse direction of vertical axis
[Tonality, TonalityD, Amusia, AmusiaD, PitchCompare, PitchMatch, CatchTrials] = GetAllData;
[~,thresholdsPC,~] = PitchCompareWeibull;
'sum(thresholdsPC>50)'
sum(thresholdsPC>50)
'sum(thresholdsPC>100)'
sum(thresholdsPC>100)
figure
colormap(cmap)
colors = AmusiaD;
colors = colors-min(colors);
colors = colors/max(colors);
log2Thresholds = log2(thresholdsPC);
hold on
plot([-.8 5],-log2(50)*[1 1],'k--','linewidth',2)
scatter(TonalityD,-log2Thresholds,100,'k','linewidth',4)
whichOnes = thresholdsPC > 100 & TonalityD > 1;
plot(TonalityD(whichOnes),-log2Thresholds(whichOnes),'ko','linewidth',4,'markerfacecolor','k')
% yVals = round(2.^(1:.25:3.5));
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25])
yTickVals = 2.^(-yTicks);
xTicks = -.5:.5:5;
set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-12 -3])
xlim([-.8 5])
axis on
box on
grid on
xlabel('3-task-d^\prime')
ylabel('Pitch-difference threshold (cents)')
hold off

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

% figure
% hold
% plot(2*norminv(2/3)*[1 1],[-3.7 -.8],'--','color',[0,.7,0],'linewidth',3)
% colormap(cmap)
% colors = TonalityD;
% colors = colors-min(colors);
% colors = colors/max(colors);
% % log10Thresholds = log10(thresholdsPC);
% scatter(AmusiaD,-log2Thresholds,100,colors,'linewidth',4)
% yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25])
% yTickVals = 2.^(-yTicks);
% % yTicks = -3.5:.25:-1;
% % yTickVals = round(10.^(-yTicks));
% % yTicks = log2([12.5 25 50 100 200 400 800 1600 3200]);
% % yTickVals = [12.5 25 50 100 200 400 800 1600 3200];
% set(gca,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
% ylim([-12 -3])
% xlim([-.8 4])
% axis on
% box on
% grid on
% xlabel('Amusia d^\prime')
% ylabel('Pitch-difference threshold (cents)')
% 
% 
% figure
% hold
% plot([-.8 5],2*norminv(2/3)*[1 1],'--','color',[0,.7,0],'linewidth',3)
% colormap(cmap)
% colors = log10(thresholdsPC);
% colors = colors-min(colors);
% colors = 1-colors/max(colors);
% scatter(TonalityD,AmusiaD,100,colors,'linewidth',4)
% yVals = 0:4;
% xVals = 0:5;
% set(gca,'ytick',yVals,'yticklabel',yVals,'xtick',xVals,'xticklabel',xVals,'fontsize',16,'linewidth',2)
% ylim([-.8 4])
% xlim([-.8 5])
% axis on
% box on
% grid on
% xlabel('3-task-d^\prime')
% ylabel('Amusia d^\prime')
% 
% 
% figure
% colormap(cmap);
% colors = log10(thresholdsPC);
% colors = colors-min(colors);
% colors = 1-colors/max(colors);
% colormap(cmap)
% A = AmusiaD; A(A<0)=0; A=A/max(A);
% % B = 1./thresholdsPC;B = B./max(B);
% B = 1./thresholdsPC;B = B./max(B);
% AB = A.*B;
% scatter(TonalityD,AB,100,'linewidth',4)
% set(gca,'fontsize',16,'linewidth',2)
% ylim([-0.05 .75])
% xlim([-.8 5])
% axis on
% box on
% grid on
% xlabel('3-task-d^\prime')
% ylabel('PC-sensitivity \times Amusia-sensitivity')
% 
% 
% nSubjs = length(AmusiaD);
% M = [ones(nSubjs,1) AB(:) AmusiaD(:) -log2Thresholds];
% [W,intW] = regress(TonalityD,M)
% figure
% scatter(TonalityD,M*W)
% 
% figure
% scatter3(-log2Thresholds,AmusiaD,TonalityD)
% xlabel('-log2Thresholds')
% ylabel('AmusiaD')
% zlabel('TonalityD')
% 
% % max(TonalityD)
% sum(TonalityD<0.75)
% sum(TonalityD<0.75 & thresholdsPC > 50)
end

