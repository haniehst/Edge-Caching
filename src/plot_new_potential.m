function plot_new_potential(best_response_plot2)
best_response_plot2 = unique(best_response_plot2,'stable');
best_response_plot2 = nonzeros(best_response_plot2);
best_response_plot2 = best_response_plot2';
for i = 1: 10
    best_response_plot2(1, length(best_response_plot2) + i) = best_response_plot2(1, length(best_response_plot2));
end
best_response_plot2 = nonzeros(best_response_plot2);
best_response_plot2 = best_response_plot2';
figure 
plo = plot(best_response_plot2/10);
plo.Marker = '*';
legend('PGC');
xlabel('Iteration Numbers');
ylabel('Potential function');
title('SBS number = 10, User Number = 20, Jammer users percentage = 5%, Zipf = 0.1');
end