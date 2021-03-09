function plotExamples(subj)
load('mcmcSamples_alpha25.mat')
load subjects
load threshold
load dprimes

for s=1:length(subj)
    figure('Renderer', 'painters', 'Position', [20 20 1000 400]);
    subplot(1,2,1);
    plot(C1(subj(s),:));
    hold on
    plot(C2(subj(s),:));
    plot(noiseSigma(subj(s),:));
    plot(alphas(subj(s),:));
    legend({'C1','C2','noiseSigma','alpha'});
    title(sprintf('Subj %s, dp=%.2f, thresh=%.2f, starting alpha=.25',subjects{subj(s)}(1:3),dprimes(subj(s)),threshold(subj(s),1)));

    subplot(1,2,2);
    plot(alphas(subj(s),:),'Color',[0.4940, 0.1840, 0.5560]);
    ylim([0 1]);
    title('Alphas');
end

end