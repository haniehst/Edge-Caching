function Average_Delay(moving_ave_potential_plot)
    figure
    plot(moving_ave_potential_plot,'Color','green','DisplayName','PGC');
    xlabel('Iterations');
    ylabel('average downloading delay for Eligible Users,s');
    title('SBS number = 10, User Number = 20, Jammer users percentage = 0%, Zipf = 0.1');
end