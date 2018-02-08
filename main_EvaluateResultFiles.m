% Computes evaluation results for a folder of segmentation result files
%
% Note, ground truth files need to be prepared as masks 
% (i.e., foreground: 255, everything else: 0).

clear variables
close all


%% Configuration
% Result
inPathResults = '/path/to/results/';
inPatternResults = '*.png';
% Ground truth
inPathGT = '/path/to/ground_truth_masks/';
inPostfixGT     = '_gt.tif';
inPostfixMask   = '.d_mask.png';


%% Process
% Extract list of filenames
inFilesGT       = dir( fullfile(inPathGT,['*', inPostfixGT]) );
inFilenames     = cell( numel(inFilesGT), 1 );
for i = 1 : numel(inFilesGT)
    inFilenames{i} = inFilesGT(i).name(1:(end-length(inPostfixGT)));    % Cut off postfixes
end

%inFilenamesSeradina = inFilenames([1,9:23]);
%inFilenamesFoppeDiNadro = inFilenames([2:4]);
%inFilenamesNaquane = inFilenames([5:8,24:26]);

scores = EvaluateResultFiles( inPathResults, inPathGT, inFilenames, inPostfixGT, inPostfixMask );
                                        

%% Output
disp( 'Per Image:' );
disp( '  ------------------------------------------------------------' );
disp( '      DSC        HR       FAR      IU-FG      mIU      pxAcc' );
disp( '  ------------------------------------------------------------' );
disp( [scores.dscs, scores.hitRates, scores.faRates, scores.iuFG, scores.meanIU, scores.pxAcc] );

disp( 'Mean (over image scores):' );
disp( '  ------------------------------------------------------------' );
disp( '      DSC        HR       FAR      IU-FG      mIU      pxAcc' );
disp( '  ------------------------------------------------------------' );
disp( [mean(scores.dscs), mean(scores.hitRates), mean(scores.faRates), mean(scores.iuFG), mean(scores.meanIU), mean(scores.pxAcc)] );

disp( 'Overall:' );
disp( '  ----------------------------------------------------------' );
disp( '      HR       FAR      DSC      IU-FG      mIU      pxAcc' );
disp( '  ----------------------------------------------------------' );
disp( [scores.hr_Overall, scores.far_Overall, scores.dsc_Overall, scores.iuFG_Overall, scores.meanIU_Overall, scores.pxAcc_Overall] );
