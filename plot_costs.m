% FUNCTION NAME:
%   plot_costs
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%   Generate cost function and L2 error plot.
%
% INPUT:
%   in1 - (vector) savecost: cost function in every iteration.
%   in2 - (vector) L2_distance: L2 error in every iteration.
%   in3 - (String) ticks_format: 'padded' or 'tickaligned'.
%   in4 - (String) img_path_name: Full path of image to be saved, including
%   name without extension.
%
% OUTPUT:
%   None. The plot is generated and saved.
function plot_costs(savecost, L2_distance, ticks_format, img_path_name)
    f = figure('visible','on');
    f.Position = [0 0 900 600];
  
    % Cost function
    semilogy(...
        1:1:size(savecost, 2), ...
        savecost(1:1:size(savecost, 2)), ...
        'b-', 'LineWidth', 2 ...
        ); 
    yticklabels(yticks);
    ytickformat('%.0e');
    ylabel('Cost function', 'FontSize', 12, 'Interpreter', 'latex');   
    
    % L2 error
    yyaxis right;
    semilogy(...
        1:1:size(L2_distance, 2), ...
        L2_distance(1:1:size(L2_distance, 2)), ...
        'Color', 'black', ...
        'LineWidth', 2 ...
        );

    yticklabels(yticks);
    ytickformat('%.0e');
    ylabel('L2 error', 'FontSize', 12, 'Interpreter', 'latex');    
    xlabel('Iteration number', 'FontSize', 12, 'Interpreter', 'latex');
    set(gca,'YColor','k');
    ylim(ticks_format); % Padded or tickaligned
    legend('Cost function', 'L2 error', 'Interpreter', 'latex');

    set(gca, 'TickLabelInterpreter', 'latex');
    set(gca, 'FontSize', 26);
    
    saveas(f, [img_path_name, '.png'])
end