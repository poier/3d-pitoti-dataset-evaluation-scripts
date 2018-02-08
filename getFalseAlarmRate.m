function errorval=getFalseAlarmRate( Y_gt, X_seg, imgMask )
Y_gt = logical(Y_gt);
imgMask = logical( imgMask );
thresh = ( min(X_seg(:)) + max(X_seg(:)) ) / 2;
X_seg = X_seg > thresh;
X_seg = logical(X_seg);
X_seg_valid = and(imgMask,X_seg);
diff = X_seg_valid - Y_gt;
diff(diff<0)=0;
diff = and(diff,imgMask);   % only consider valid area
diff=sum(diff(:));
errorval = diff ./ ( sum(X_seg_valid(:)) );
end
