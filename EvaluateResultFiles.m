function [ scores ] = EvaluateResultFiles( inPathResults, inPathGT, inFilenames, inPostfixGT, inPostfixMask )
%EVALUATERESULTFILES 
%

numFiles = numel( inFilenames );

% Preallocation
scores.hitRates    = zeros( numFiles, 1 );
scores.faRates     = ones( numFiles, 1 );
scores.dscs        = zeros( numFiles, 1 );
scores.iuFG        = zeros( numFiles, 1 );
scores.meanIU      = zeros( numFiles, 1 );
scores.pxAcc       = zeros( numFiles, 1 );
% For aggregating scores (pixelwise) over all images
numGtFG = 0;
numSegFG = 0;
numInterFG = 0;
numUnionFG = 0;
numInterBG = 0;
numUnionBG = 0;
numFaFG = 0;
numValidPixels = 0;

for i = 1 : numFiles
    disp( inFilenames{i} );
    
    % Generate full filenames
    matchingResultFile = dir(fullfile( inPathResults, ['*', inFilenames{i}, '*'] ));
    fileResult      = fullfile( inPathResults, matchingResultFile.name );
    fileGT          = fullfile( inPathGT, [inFilenames{i} inPostfixGT] );
    fileMask        = fullfile( inPathGT, [inFilenames{i} inPostfixMask] );
    
    % Check if files exist
    if ~(exist(fileResult,'file') == 2)
        error( ['file does not exist' fileResult] );
    end
    if ~(exist(fileGT,'file') == 2)
        error( ['file does not exist' fileGT] );
    end
    if ~(exist(fileMask,'file') == 2)
        error( ['file does not exist' fileMask] );
    end
    
    % Load images
    gtFG    = imread( fileGT );
    segFG   = imread( fileResult );
    imgMask = imread( fileMask );
    % Check image sizes
    if  ( size(gtFG,1) ~= size(segFG,1) ) || ( size(gtFG,1) ~= size(imgMask,1) ) || ...
        ( size(gtFG,2) ~= size(segFG,2) ) || ( size(gtFG,2) ~= size(imgMask,2) )
        error('ground truth and segmentation image sizes does not correspond')
    end
    
    % Ensure that images are logical
    gtFG = logical(gtFG);
    thresh = ( min(segFG(:)) + max(segFG(:)) ) / 2;
    segFG = logical(segFG > thresh);
    imgMask = logical( imgMask );
    
    % Compute background segmentation-, GT- masks
    gtBG    = ~gtFG;
    segBG   = ~segFG;
    
    % Apply mask
    gtFG  = and(gtFG,imgMask);
    segFG = and(segFG,imgMask);
    gtBG  = and(gtBG,imgMask);
    segBG = and(segBG,imgMask);
    
    numInterFG_i = sum(sum(and(gtFG,segFG)));
    numUnionFG_i = sum(sum(or(gtFG,segFG)));
    numInterBG_i = sum(sum(and(gtBG,segBG)));
    numUnionBG_i = sum(sum(or(gtBG,segBG)));
    numGtFG_i   = sum(gtFG(:));
    numSegFG_i  = sum(segFG(:));
        
    % Compute numbers
    scores.hitRates(i) = getHitRate( gtFG, segFG );    
    scores.faRates(i)  = getFalseAlarmRate( gtFG, segFG, imgMask );
    scores.dscs(i)     = getDSC( gtFG, segFG, imgMask );
    scores.iuFG(i)     = ComputeJaccardIndex( gtFG, segFG, imgMask );
    scores.pxAcc(i)    = ComputePixelAccuracy( gtFG, segFG, imgMask );
    iuBG               = ComputeJaccardIndex( gtBG, segBG, imgMask );
    scores.meanIU(i)   = (scores.iuFG(i) + iuBG) / 2;
    
    % Aggregate values for overall scores
    numFaFG     = numFaFG + (numSegFG_i - numInterFG_i);
    numGtFG   	= numGtFG + numGtFG_i;
    numSegFG    = numSegFG + numSegFG_i;
    numInterFG = numInterFG + numInterFG_i;
    numUnionFG = numUnionFG + numUnionFG_i;
    numInterBG = numInterBG + numInterBG_i;
    numUnionBG = numUnionBG + numUnionBG_i;
    numValidPixels = numValidPixels + sum(imgMask(:));
    
    
end

scores.hr_Overall       = numInterFG / numGtFG;
scores.far_Overall      = numFaFG / numSegFG;
scores.dsc_Overall = (2 * numInterFG) / (numGtFG + numSegFG);
scores.iuFG_Overall = numInterFG / numUnionFG;
scores.meanIU_Overall = ((numInterFG / numUnionFG) + (numInterBG / numUnionBG)) / 2;
scores.pxAcc_Overall = (numInterFG + numInterBG) / numValidPixels;

end     % end of function

