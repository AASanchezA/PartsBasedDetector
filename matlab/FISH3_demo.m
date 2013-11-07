% --------------------
% specify model parameters
% number of mixtures for 5 parts
K = [5 5 5 5 5 ]; 
% Tree structure for 5 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (FISH_data.m) and evaluation (FISH_eval_pcp)
pa = [0 1 2 3 4];
% Spatial resolution of HOG cell, interms of pixel width and hieght
% The FISH dataset contains low-res people, so we use low-res parts
sbin = 4;
% --------------------
% Prepare training and testing images and part bounding boxes
% You will need to write custom IMAGE_data() functions for your dataset
globals;
name = 'FISH3';
[pos test] = FISH3_data();
neg        = INRIA_data();
pos        = pointtobox(pos,pa);
% --------------------
% training
model = trainmodel(name,pos,neg,K,pa,sbin);
% --------------------
% testing
suffix = num2str(K')';
model.thresh   = min(model.thresh,-2);
[boxes points] = testmodel(name,model,test,suffix);
% --------------------
% evaluation
% You will need to write your own evaluation code for your dataset
[detRate PCP R] = FISH3_eval_pcp(name,points,test);
fprintf('detRate=%.3f, PCP=%.3f, detRate*PCP=%.3f\n',detRate,PCP,detRate*PCP);
save([cachedir name '_pcp_' suffix],'detRate','PCP','R');
% --------------------
% visualization
figure(1);
visualizemodel(model);
figure(2);
visualizeskeleton(model);
demoimid = 1;
im  = imread(test(demoimid).im);
box = boxes{demoimid}(1,:);
colorset = {'g','y','m','c','r'};
figure(3);
subplot(1,2,1); showboxes(im,box,colorset);
subplot(1,2,2); showskeleton(im,box,colorset,model.components{1});