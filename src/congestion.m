function congestion(traffic)
    traffic = unique(traffic,'stable');
    traffic = nonzeros(traffic);
    traffic = traffic';
    for i = 1: 10
        traffic(1, length(traffic) + i) = traffic(1, length(traffic));
    end
    traffic = nonzeros(traffic);
    figure 
    plot(traffic,'Color','red');
    xlabel('Iteration Numbers');
    ylabel('Backhaul Link Occupation Time(s)');
    title('SBS number = 10, User Number = 20, Jammer users percentage = 5%, Zipf = 0.1');
end
