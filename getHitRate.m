function hitrate=getHitRate( Y_gt, X_seg )
Y_gt = logical(Y_gt);
thresh = ( min(X_seg(:)) + max(X_seg(:)) ) / 2;
X_seg = X_seg > thresh;
X_seg = logical(X_seg);
intersection = sum(sum(and(Y_gt,X_seg)));
diff = Y_gt - X_seg;
diff(diff<0)=0;
diff=sum(diff(:));
hitrate = intersection./(intersection+diff);
if (isnan(hitrate))
  hitrate = 0;
end
end
