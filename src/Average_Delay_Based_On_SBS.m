function Average_Delay_Based_On_SBS(DelayOutput1,DelayOutput2,DelayOutput3,DelayOutput4,DelayOutNoJammer)
x = [ 2 3 4 5 6 ];
Average_delay = zeros(1,5,5);
Average_delay(1,:,1) = DelayOutNoJammer;
Average_delay(1,:,2) = DelayOutput1;
Average_delay(1,:,3) = DelayOutput2;
Average_delay(1,:,4) = DelayOutput3;
Average_delay(1,:,5) = DelayOutput4;
figure
plot(x,sort(Average_delay(1,:,1),'descend'),'Color','green');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on 
plot(x,sort(Average_delay(1,:,2),'descend'),'Color','cyan');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(Average_delay(1,:,3),'descend'),'Color','blue');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(Average_delay(1,:,4),'descend'),'Color','red');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
plot(x,sort(Average_delay(1,:,5),'descend'),'Color','black');
set(gca,'XTick',[2 3 4 5 6]);
set(gca,'XTickLabel',[5,7,10,13,16]);
hold on
xlabel('SBS Numbers');
ylabel('Average Delay,s');
xlim([0 20 ]);
legend('No jammer','5 percent', '10 percent','20 percent','30 percent');
title('User Number = 20, Jammer user percentage = Different, Zipf = 0.1 ');
end