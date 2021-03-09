function [subj_keep,subj_odd] = filterSamples
% pick out the subjects whose samples look "alright"; save those subj
% numbers into subj_keep or subj_odd.

    load mcmcSamples_alpha75

    subj_keep = [];
    subj_odd = [];
    
    iter_1 = 1;
    iter_2 = 1;

    for f=1:size(alphas,1)
        figure('Renderer', 'painters', 'Position', [20 20 1000 400])
        subplot(1,2,1);
        plot(C1(f,:));
        hold on
        plot(C2(f,:));
        plot(noiseSigma(f,:));
        plot(alphas(f,:));
        legend({'C1','C2','noiseSigma','alpha'});

        subplot(1,2,2);
        plot(alphas(f,:),'Color',[0.4940, 0.1840, 0.5560]);
        ylim([0 1]);

        resp = input('Good? 1/0: ');
        if resp==1
            subj_keep(iter_1) = f;
            iter_1 = iter_1+1;
        else
            subj_odd(iter_2) = f;
            iter_2 = iter_2+1;
        end

        close;
    end
save mcmc_filtered_subj_alpha75 subj_keep subj_odd
end