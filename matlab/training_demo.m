% --------------------
% specify model parameters
% number of mixtures for 5 parts
K = [5 5 5 5 5];

% Tree structure for 5 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (FISH_data.m) and evaluation (FISH_eval_pcp)
pa = [0 1 2 3 4];

% Spatial resolution of HOG cell, interms of pixel width and hieght
sbin = 4;

% --------------------
% Define training and testing data
globals;
name = 'FISH3';
[pos test] = FISH3_data();
neg        = INRIA_data();
% [pos test] = getPositiveData('/path/to/positive/data','im_regex','label_regex',0.7);
% neg        = getNegativeData('/path/to/positive/data', 'im_regex');
pos        = pointtobox(pos,pa);

% --------------------
% training
model = trainmodel(name,pos,neg,K,pa,sbin);
save('Demo_model.mat', 'model', 'pa', 'sbin', 'name');
