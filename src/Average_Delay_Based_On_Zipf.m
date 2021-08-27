function Average_Delay_Based_On_Zipf(PotentialOutput1,zipf1)
PotentialOutput = zeros(1,10,5);
PotentialOutput(1,:,1) = zipf1;
PotentialOutput(1,:,2) = PotentialOutput1(1,:,1);
PotentialOutput(1,:,3) = PotentialOutput1(1,:,2);
PotentialOutput(1,:,4) = PotentialOutput1(1,:,3);
PotentialOutput(1,:,5) = PotentialOutput1(1,:,4);
figure
plo = plot(PotentialOutput(1,:,1),'Color','green');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(PotentialOutput(1,:,2),'Color','cyan');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(PotentialOutput(1,:,3),'Color','blue');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(PotentialOutput(1,:,4),'Color','red');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
plo = plot(PotentialOutput(1,:,5),'Color','black');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
hold on
xlabel('Zipf parameter');
ylabel('Average Delay,s');
title('SBS number = 10, User Number = 20, Jammer user percentage = Different');
legend('No jammer','5 percent', '10 percent','20 percent','30 percent');
end