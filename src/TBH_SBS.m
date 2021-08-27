function TBH_SBS(TBH_No_jammer,temp1,temp2,temp3,temp4)
x = [ 2 3 4 5 6 ];
TBH = zeros(1,5,5);
TBH(1,:,1) = TBH_No_jammer;
TBH(1,:,2) = temp1;
TBH(1,:,3) = temp2;
TBH(1,:,4) = temp3;
TBH(1,:,5) = temp4;
figure
plot(x,sort(TBH(1,:,1),'descend'),'Color','green');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(TBH(1,:,2),'descend'),'Color','cyan');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(TBH(1,:,3),'descend'),'Color','blue');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(TBH(1,:,4),'descend'),'Color','red');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(TBH(1,:,5),'descend'),'Color','black');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
xlabel('SBS Numbers');
ylabel('Backhaul Link Occupation Time,s');
xlim([0 20]);
legend('No jammer','5 percent', '10 percent','20 percent','30 percent');
title('User Number = 20, Jammer user percentage = Different, Zipf = 0.1');
end