function acc = ComputePixelAccuracy( gt, seg, imgMask )
% Computes the "Pixel Accuracy" measure for binary segmentation
%
% Input
%   gt      ground truth image; logical
%   seg     segmantation image; logical
%   imgMask mask image; logical; defines the region of the image which is
%           considered for computation of the score
% Output
%   acc     pixel accuracy (see e.g. [1])
%
% [1] https://arxiv.org/pdf/1605.06211v1.pdf

% Sanity check
if ( (~islogical(gt)) || (~islogical(seg)) || (~islogical(imgMask)) )
    error('Inputs to ComputePixelAccuracy have to be logical arrays, but at least one is not.');
end

% Apply mask
gt  = and(gt,imgMask);
seg = and(seg,imgMask);
gtBg = and(~gt,imgMask);
segBg = and(~seg,imgMask);

% Compute score
acc = ( sum(sum(and(gt,seg))) + sum(sum(and(gtBg,segBg))) ) ./ sum(imgMask(:));

end     % end of function
