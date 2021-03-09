function nLogL = nLogLhoodAlpha(Params)

global D Response

alpha = Params(1);
if alpha<0 || alpha>1
    nLogL = Inf;
    return;
end

noiseSigma = Params(2);
C1 = Params(3);
C2 = Params(4);
% if alpha > 0.5
%     'hi'
% end
statMean = alpha*abs(D) + (1-alpha)*D;
if alpha >= 0.5
%     C1 = (2*alpha - 1) * abs(negMean)/2;  
%     C2 = (C1 + posMean)/2;
    whichOnes = Response == 0;
    PZeroResps = cumgauss((C1 - statMean(whichOnes))/noiseSigma);  % if alpha > 0.5, then expected stat for D==0 is lower than for D < 0
    whichOnes = Response == -1;
    PMinusOneResps = cumgauss((C2 - statMean(whichOnes))/noiseSigma)-cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 1;
    POneResps = 1-cumgauss((C2 - statMean(whichOnes))/noiseSigma);
else   % alpha < 0.5
%     C1 = (2*alpha-1)*negMean/2;
%     C2 = posMean/2;
    whichOnes = Response == -1;
    PMinusOneResps = cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 0;
    PZeroResps = cumgauss((C2 - statMean(whichOnes))/noiseSigma)-cumgauss((C1 - statMean(whichOnes))/noiseSigma); 
    whichOnes = Response == 1;
    POneResps = 1-cumgauss((C2 - statMean(whichOnes))/noiseSigma);
end
prob = [PMinusOneResps(:);PZeroResps(:);POneResps(:)];
prob(prob > 0.99) = 0.99;
prob(prob < 0.01) = 0.01;
nLogL = -sum(log(prob));
% fprintf('alpha = %0.2f sigma = %0.2f  LogL = %0.2f\n',alpha,noiseSigma,LogL);
end