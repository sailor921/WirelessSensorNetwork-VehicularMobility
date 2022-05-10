function plot_data(rounds, sim_params)
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here

figure(1)

i = 0;
for param = ["dead nodes", "operating nodes", "total energy", "packets", "contact time", "interconnect time"]
    i = i + 1;
    subplot(2, 3, i)
    
    plot(1:rounds,sim_params(param),'-r','Linewidth',2);
    hold on
    
    xlim([0 rounds]);
    axis tight
    title( [capitalize(param), 'Per Round'] );
    xlabel 'Rounds';
    
    ylabel ( capitalize(param) );
    legend('Mobile Sink');
end
hold off

end

