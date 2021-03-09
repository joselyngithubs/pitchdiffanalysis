function autocovs = myAutocov(M,lags,showLags)

% autocovs = myAutocov(M,lags)
%
% Compute the autocovariance function (normalized relative to the lag = 0
% autocovariance) of each column of M for the offsets in lags.

if nargin < 3
    showLags = false;
end
[MRows,MCols] = size(M);
if nargin < 2
    lags = 1:(MRows/1000);
end
nLags = length(lags);
autocovs = NaN(nLags,MCols);
means = mean(M);
v1s = M-means;
autocorr0s = sum(v1s.*v1s)/length(v1s);

for k=1:nLags
    if showLags
        fprintf('lag = %d\n',lags(k));
    end
    v1s = M(1:end-lags(k),:);
    v2s = M(1+lags(k):end,:);
    mean1s = mean(v1s);
    mean2s = mean(v2s);
    v1s = v1s-mean1s;
    v2s = v2s-mean2s;
    len = length(v1s);
    autocovs(k,:) = sum(v1s.*v2s)./(len*autocorr0s);
end

end

