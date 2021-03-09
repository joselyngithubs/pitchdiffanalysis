function data = prepData(d)

% first load in a mat file that is 550x12.
% then, extract the same-diff task data.
d = d(d(:,1)==5,:);

% Col 3: trial type
% Col 4-5: frequencies of the tones
% Col 6: response
% 
% Trial types:
% 0 == "higher"
% 1 == "lower"
% 2 == "same"

n = -1*(d(:,6)==1);
z = 0*(d(:,6)==2);
p = d(:,6)==0;
resp = n+z+p;
n = -1*(d(:,3)==1);
z = 0*(d(:,3)==2);
p = d(:,3)==0;
correct = n+z+p;
f1 = d(:,4);
f2 = d(:,5);
D = 1200*log2(f2./f1);
data = [D correct resp];
end

