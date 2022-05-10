function plot_simulation(SN, rounds, dims)
%PLOT_SIMULATION Summary of this function goes here
%   Detailed explanation goes here

figure(2);
hold on;

xlabel('X (meters)');
ylabel('Y (meters)');
title('Radom Waypoint mobility');

plot( dims('x_min'),dims('y_min'),dims('x_max'),dims('y_max') );

for i = 1:length(SN.n)
    node_plot(i) = scatter(SN.n(i).Xs(1), SN.n(i).Ys(1), SN.n(i).size );
    node_plot(i).MarkerFaceColor = SN.n(i).COLs(1);
    node_plot(i).MarkerFaceAlpha = SN.n(i).ALPHAs(1);
    node_plot(i).MarkerEdgeAlpha = 0;
end

round_val_text = text(dims('x_min'), dims('y_max'), cat(2,'Round = 0'));

hold off

for round = 1:rounds
    set(round_val_text, 'String', cat(2,'Round = ', num2str(round)));
    for i = 1:length(SN.n)
        set(node_plot(i), {'XData', 'YData', 'MarkerFaceColor', 'MarkerFaceAlpha' }, {SN.n(i).Xs(round), SN.n(i).Ys(round), SN.n(i).COLs(round), SN.n(i).ALPHAs(round)});
    end
    drawnow;
end

end

