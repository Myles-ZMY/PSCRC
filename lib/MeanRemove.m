function X_mr=MeanRemove(X,meanX)
if ~exist('meanX','var')
    meanX = mean(X,2); % mean vector
end
X_mr = X - repmat(meanX, 1, size(X,2));
end