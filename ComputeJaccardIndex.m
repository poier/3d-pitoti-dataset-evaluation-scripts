function ji = ComputeJaccardIndex( gt, seg, imgMask )
% Computes the Jaccard index between two binary masks
%
% Input
%   gt      ground truth image; logical
%   seg     segmantation image; logical
%   imgMask mask image; logical; defines the region of the image which is
%           considered for computation of the score
% Output
%   ji      Jaccard index

% Sanity check
if ( (~islogical(gt)) || (~islogical(seg)) || (~islogical(imgMask)) )
    error('Inputs to ComputeJaccardIndex have to be logical arrays, but at least one is not.');
end

% Apply mask
gt  = and(gt,imgMask);
seg = and(seg,imgMask);
% Compute score
ji = sum(sum(and(gt,seg))) / sum(sum(or(gt,seg)));

end     % end of function
