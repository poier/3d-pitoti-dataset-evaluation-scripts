function dsc = getDSC( Y_gt, X_seg, imgMask )
Y_gt = logical(Y_gt);
imgMask = logical( imgMask );
thresh = ( min(X_seg(:)) + max(X_seg(:)) ) / 2;
X_seg = X_seg > thresh;
X_seg = logical(X_seg);
X_seg_valid = and(imgMask,X_seg);
dsc = 2*sum(sum(and(Y_gt,X_seg_valid)))./(sum(Y_gt(:))+sum(X_seg_valid(:)));

end
