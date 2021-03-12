function thresholdhist

load threshold

figure;
hObj=histogram(threshold(:,3),10,'linewidth',2);
get(hObj)
hold on
histogram(threshold(:,1),'binedges',hObj.BinEdges,'facecolor','y','linewidth',2)
histogram(threshold(:,2),'binedges',hObj.BinEdges,'facecolor','r','linewidth',2)
set(gca,'linewidth',2,'fontsize',20)
grid on
box on
ylim([0 100])

end