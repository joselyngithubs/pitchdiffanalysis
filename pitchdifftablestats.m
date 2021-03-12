function stat = pitchdifftablestats
% stat = ratio of (A+B)/(C+D+0.5); plot stat against threshold on PD 0.5 Task
% A = respond H on L trials
% B = respond L on H trials
% C = respond S on L trials
% D = respond S on H trials

sourceLoc = 'C:\Users\Joselyn\Documents\pitchdiffrove data\DataMatFiles\';
files = dir([sourceLoc '*.mat']);
files = {files.name};

nFiles = length(files);

stat = NaN(nFiles,1);

for f=1:nFiles
    
    load([sourceLoc files{f}]);
    data = data(data(:,1)==5,[3,6,7]); % type / response / isCorrect
    
    % grab only the trials starting after the 3rd error
    wrongTrials = find(data(:,3)==false);
    data = data(wrongTrials(3)+1:end,:);
    
    TrialType = data(:,1);
    Resp = data(:,2);
    % higher (0), lower (1), same (2)
    
    subject_table = NaN(3,3);
    
    %% stim L
    curr_set = TrialType==1;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(1,1) = sum(curr_resp==1);
    % resp S
    subject_table(1,2) = sum(curr_resp==2);
    % resp H
    subject_table(1,3) = sum(curr_resp==0);
    
    %% stim S
    curr_set = TrialType==2;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(2,1) = sum(curr_resp==1);
    % resp S
    subject_table(2,2) = sum(curr_resp==2);
    % resp H
    subject_table(2,3) = sum(curr_resp==0);
    
    %% stim H
    curr_set = TrialType==0;
    curr_type = TrialType(curr_set);
    curr_resp = Resp(curr_set);
    
    % resp L
    subject_table(3,1) = sum(curr_resp==1);
    % resp S
    subject_table(3,2) = sum(curr_resp==2);
    % resp H
    subject_table(3,3) = sum(curr_resp==0);
    
    %% compute stat
    A = subject_table(1,3);
    B = subject_table(3,1);
    C = subject_table(1,2);
    D = subject_table(3,2);
    stat(f) = (A + B)/(C + D + 0.5); % add 0.5 to denominator in case ==0
    
end

load threshold

figure;
thresholdsPC = threshold(:,1);
thresholdsPC(thresholdsPC<6.25) = 6.25;
log2Thresholds = log2(thresholdsPC);
hold on
% plot([-.1 6],-log2(50)*[1 1],'k--','linewidth',2)
scatter(stat,-log2Thresholds,100,'k','linewidth',4)
yTicks = -log2([1600 800 400 200 100 50 25 12.5 6.25]);
yTickVals = 2.^(-yTicks);
% xTicks = -.5:.5:5;
% set(gca,'xtick',xTicks,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
set(gca,'ytick',yTicks,'yticklabel',yTickVals,'fontsize',16,'linewidth',2)
ylim([-log2(1600) -log2(12.5/2.5)])
xlim([-.5 9])
axis on
box on
grid on
xlabel('table stat')
ylabel('Pitch-difference threshold (cents)')

% edit y-axis label to show <=6.25
labels = strsplit(num2str(yTickVals));
labels{9}='\leq6.25';
yticklabels(labels);


end
