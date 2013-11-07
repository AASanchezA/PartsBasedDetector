function [pos test] = FISH3_data
% this function is very dataset specific, you need to modify the code if
% you want to apply the pose algorithm on some other dataset

% it converts the various data format of different dataset into unique
% format for pose detection 
% the unique format for pose detection contains below data structure
%   pos:
%     pos(i).im: filename for the image containing i-th human 
%     pos(i).point: pose keypoints for the i-th human
%   test:
%     test(i).im: filename for i-th testing image
% This function also prepares flipped images for training.

globals;

load FISH/labels3.mat;
posims = 'FISH/im%.4d.jpg';

trainfrs = 1:200; % training frames
testfrs = 201:500; % testing frames

% -------------------
% grab positive annotation and image information
pos = [];
numpos = 0;
for fr = trainfrs
  numpos = numpos + 1;
  pos(numpos).im = sprintf(posims,fr);
  pos(numpos).point = ptsAll(:,:,fr);
end

% -------------------
% flip positive training images
posflipims = [cachedir 'imflip/FISH%.6d.jpg'];
for n = 1:length(pos)
  if exist(sprintf(posflipims,n),'file')
    continue;
  end
  im = imread(pos(n).im);
  im_flip = im(:,end:-1:1,:);
  imwrite(im_flip,sprintf(posflipims,n));
%   im_flip(:,:,n) = im(:,end:-1:1,:);
%   imwrite(im_flip(:,:,n),sprintf(posflipims,n));
end

% -------------------
% flip labels for the flipped positive training images
% mirror property for the keypoint, please check your annotation for your
% own dataset
mirror = [3 2 1];
for n = 1:length(pos)
  im = imread(pos(n).im);
  width = size(im,2);
  numpos = numpos + 1;
  pos(numpos).im = sprintf(posflipims,n);
  for p = 1:size(pos(n).point,1)
    pos(numpos).point(mirror(p),1) = width - pos(n).point(p,1) + 1;
    pos(numpos).point(mirror(p),2) = pos(n).point(p,2);
  end
end

% -------------------
% Create ground truth keypoints for model training
% We augment the original 3 joint positions with midpoints of joints, 
% defining a total of 5 keypoints
I = [1  2   2   3   4   4  5];
J = [1  1   2   2   2   3  3];
S = [1 1/2 1/2  1  1/2 1/2 1];
A = full(sparse(I,J,S,5,3));

for n = 1:length(pos)
  pos(n).point = A * pos(n).point; % linear combination
%   imagesc(im_flip(:,:,n)); colormap gray;
%   hold on;
%    %# plot the Line
%   plot([pos(n).point(1,1), pos(n).point(2,1)],[pos(n).point(1,2),pos(n).point(2,2)],'Color','r','LineWidth',2);
%   plot([pos(n).point(2,1), pos(n).point(3,1)],[pos(n).point(2,2),pos(n).point(3,2)],'Color','g','LineWidth',2);
%   plot([pos(n).point(3,1), pos(n).point(4,1)],[pos(n).point(3,2),pos(n).point(4,2)],'Color','b','LineWidth',2);
%   plot([pos(n).point(4,1), pos(n).point(5,1)],[pos(n).point(4,2),pos(n).point(5,2)],'Color','m','LineWidth',2);
%   hold off;
%   pause;
end

% -------------------
% grab testing image information
test = [];
numtest = 0;
for fr = testfrs
  numtest = numtest + 1;
  test(numtest).im = sprintf(posims,fr);
  test(numtest).point = ptsAll(:,:,fr);
end