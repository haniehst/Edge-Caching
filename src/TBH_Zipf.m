function TBH_Zipf(TBH_No_jammer,TBHoutput1)
TBHoutput = zeros(1,10,5);
TBHoutput(1,:,1)= TBH_No_jammer;
TBHoutput(1,:,2) = TBHoutput1(1,:,1);
TBHoutput(1,:,3) = TBHoutput1(1,:,2);
TBHoutput(1,:,4) = TBHoutput1(1,:,3);
TBHoutput(1,:,5) = TBHoutput1(1,:,4);
figure
plo = plot(sort(TBHoutput(1,:,1),'descend'),'Color','green');
xlabel('Zipf parameter');
ylabel('TBH');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(sort(TBHoutput(1,:,2),'descend'),'Color','cyan');
xlabel('Zipf parameter');
ylabel('TBH');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(sort(TBHoutput(1,:,3),'descend'),'Color','blue');
xlabel('Zipf parameter');
ylabel('TBH');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(sort(TBHoutput(1,:,4),'descend'),'Color','red');
xlabel('Zipf parameter');
ylabel('TBH');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(sort(TBHoutput(1,:,5),'descend'),'Color','black');
xlabel('Zipf parameter');
ylabel('Backhaul Link Occupation Time,s');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
title('SBS number = 10, User Number = 20, Jammer user percentage = Different');
legend('No jammer','5 percent', '10 percent','20 percent','30 percent');
end