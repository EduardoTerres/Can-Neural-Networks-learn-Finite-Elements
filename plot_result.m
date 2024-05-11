% SCRIPT:
%       fem_nn_1.m
%
% FUNCTION NAME:
%   plot_results
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%   Generate theoretical and NN solution plot.
%
% INPUT:
%   in1 - (function) F: neural network
%   in2 - (vector) b2: biases
%   in3 - (vector) W2: weights
%   in4 - (vector) W3: weights
%   in5 - (double) epsilon
%   in6 - (integer) N: where N+1 is the number of grid points.
%   in7 - (boolean) lines: If true plots vertical lines; if false doesnt.
%   in8 - (String) img_path_name: Full path of image to be saved, including
%   name without extension.
%
% OUTPUT:
%   None. The plot is generated and saved.
function plot_result(F, b2, W2, W3, epsilon, N, lines, img_path_name)
    f = figure('Units', 'inches', 'Position', [0, 0, 10, 7], ...
        'visible','on');

    plotting_grid = linspace(0, 1, 10000);
    
    % NN
    plot(plotting_grid, F(plotting_grid, b2, W2, W3), 'blue', 'linewidth', 2)
    hold on
 
    % Theoretical
    y = @(x) (-exp(-1/epsilon)+exp((x-1)./epsilon))/(exp(-1/epsilon)-1) + x;
    plot(plotting_grid, y(plotting_grid), 'red', 'linewidth', 2)

    ylim('padded');
    set(gca, 'TickLabelInterpreter', 'latex');
    set(gca, 'FontSize', 30);
    yLimits = ylim;
    y_min = yLimits(1);
    y_max = yLimits(2);

    % Plot vertical lines
    lines_grid = linspace(0, 1, N+1);
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