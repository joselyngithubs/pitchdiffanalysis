function y = Weibull(x,A,B,minProb,maxProb)

y = minProb + (maxProb-minProb)*(1-exp(-(x/A).^B));

end