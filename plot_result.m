function plot_result(F, b2, W2, W3, epsilon, N, lines, img_path_name)
    f = figure('Units', 'inches', 'Position', [0, 0, 10, 7], ...
        'visible','off');

    plotting_grid = linspace(0, 1, 10000);
    plot(plotting_grid, F(plotting_grid, b2, W2, W3), 'blue', 'linewidth', 2) % RRNN
    y = @(x) (-exp(-1/epsilon)+exp((x-1)./epsilon))/(exp(-1/epsilon)-1) + x;
    hold on
    plot(plotting_grid, y(plotting_grid), 'red', 'linewidth', 2) % Teorica

    ylim('padded');
    set(gca, 'TickLabelInterpreter', 'latex');
    set(gca, 'FontSize', 30);
    yLimits = ylim;
    y_min = yLimits(1);
    y_max = yLimits(2);

    lines_grid = linspace(0, 1, N+1);
    % Plot vertical lines
    if lines == true
        ylim('tight');
        for i = 1:length(lines_grid)
            x = lines_grid(i);
            line([x, x], [y_min, y_max], 'Color', 'black', 'linewidth', 0.3);
            hold on;
        end 
    end

    legend('Neural Network', 'Theoretical', 'Interpreter', 'latex', 'Location', 'Northwest');

    saveas(f, [img_path_name, '.png'])
end