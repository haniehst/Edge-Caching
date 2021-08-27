function plot_potential(best_response_plot)
    best_response_plot = unique(best_response_plot,'stable');
    best_response_plot = nonzeros(best_response_plot);
    best_response_plot = best_response_plot';
    for i = 1: 10
        best_response_plot(1, length(best_response_plot) + i) = best_response_plot(1, length(best_response_plot));
    end
    best_response_plot = nonzeros(best_response_plot);
    best_response_plot = best_response_plot';
    figure 
    plo = plot(best_response_plot/10);
    plo.Marker = '*';
    legend('PGC');
    xlabel('Iterations');
    ylabel('Potential function');
    title('SBS number = 10, User Number = 20, Jammer users percentage = 0%, Zipf = 0.1');
end
