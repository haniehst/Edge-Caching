function Plot_TBH(traffic)
plo = plot(traffic(1,:,1),'Color','blue','DisplayName','PGC');
xlabel('Zipf parameter');
ylabel('TBH');
plo.Marker = 'O';
xticklabels({'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1'});
end