function subject_table = pitchdifftable

% load subject data
% fname = 'C:\Users\Joselyn\Documents\pitchdiffrove data\data\DOB_1607490182015.csv'; % high performer
% fname = 'C:\Users\Joselyn\Documents\pitchdiffrove data\data\EJM_1607484116053.csv'; % low performer
% fname = 'C:\Users\Joselyn\Documents\pitchdiffrove data\data\AB_1607572555046.csv'; % low performer
fname = 'C:\Users\Joselyn\Documents\pitchdiffrove data\data\A2181995j!_1607482240027.csv'; % low performer
% fname = 'C:\Users\Joselyn\Documents\pitchdiffrove data\data\EG_1607047188895.csv';

[~,~,d] = xlsread(fname,'G1:G1');
if strcmp(d,'headphoneCheck') % contains a col for headphone check
    d = xlsread(fname,'H2:S551');
else
    d = xlsread(fname,'G2:R551');
end

howManyTrials = 100;

d = d(d(:,1)==5,:); % grab just the s/d trials
d = d(length(d)-howManyTrials+1:end,:);
TrialType = d(:,3);
Resp = d(:,6);
% higher (0), lower (1), same (2)

subject_table = NaN(3,3);
t = [25;50;25]; % subject_table reflects proportions; raw counts = t.*subject_table 

%% stim L
curr_set = TrialType==1;
curr_type = TrialType(curr_set);
curr_resp = Resp(curr_set);

% resp L
subject_table(1,1) = sum(curr_resp==1)/length(curr_type);
% resp S
subject_table(1,2) = sum(curr_resp==2)/length(curr_type);
% resp H
subject_table(1,3) = sum(curr_resp==0)/length(curr_type);

%% stim S
curr_set = TrialType==2;
curr_type = TrialType(curr_set);
curr_resp = Resp(curr_set);

% resp L
subject_table(2,1) = sum(curr_resp==1)/length(curr_type);
% resp S
subject_table(2,2) = sum(curr_resp==2)/length(curr_type);
% resp H
subject_table(2,3) = sum(curr_resp==0)/length(curr_type);

%% stim H
curr_set = TrialType==0;
curr_type = TrialType(curr_set);
curr_resp = Resp(curr_set);

% resp L
subject_table(3,1) = sum(curr_resp==1)/length(curr_type);
% resp S
subject_table(3,2) = sum(curr_resp==2)/length(curr_type);
% resp H
subject_table(3,3) = sum(curr_resp==0)/length(curr_type);

%% Make Table

raw = t.*subject_table;

figure;

subplot(3,3,1);
ylabel('Stim L');
title('Resp L');
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(1,1)) '/' num2str(t(1)) '=' num2str(subject_table(1,1))];
text(0.25,0.5,txt);

subplot(3,3,2);
title('Resp S');
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(1,2)) '/' num2str(t(1)) '=' num2str(subject_table(1,2))];
text(0.25,0.5,txt);

subplot(3,3,3);
title('Resp H');
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(1,3)) '/' num2str(t(1)) '=' num2str(subject_table(1,3))];
text(0.25,0.5,txt);

subplot(3,3,4);
ylabel('Stim S');
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(2,1)) '/' num2str(t(2)) '=' num2str(subject_table(2,1))];
text(0.25,0.5,txt);

subplot(3,3,5);
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(2,2)) '/' num2str(t(2)) '=' num2str(subject_table(2,2))];
text(0.25,0.5,txt);

subplot(3,3,6);
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(2,3)) '/' num2str(t(2)) '=' num2str(subject_table(2,3))];
text(0.25,0.5,txt);

subplot(3,3,7);
ylabel('Stim H');
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(3,1)) '/' num2str(t(3)) '=' num2str(subject_table(3,1))];
text(0.25,0.5,txt);

subplot(3,3,8);
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(3,2)) '/' num2str(t(3)) '=' num2str(subject_table(3,2))];
text(0.25,0.5,txt);

subplot(3,3,9);
xticklabels({''});
yticklabels({''});
box on
txt = [num2str(raw(3,3)) '/' num2str(t(3)) '=' num2str(subject_table(3,3))];
text(0.25,0.5,txt);

end