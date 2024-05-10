function plot_costes(savecost, L2_distance, img_path_name)
    f = figure('visible','off');
    f.Position = [0 0 900 600];
  
    semilogy(...
        1:1:size(savecost, 2), ...
        savecost(1:1:size(savecost, 2)), ...
        'b-', 'LineWidth', 2 ...
        ); 
    yticklabels(yticks);
    ytickformat('%.0e');
    ylabel('Cost function', 'FontSize', 12, 'Interpreter', 'latex');   
    
    if L2_distance ~= 0
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
        legend('Cost function', 'L2 error', 'Interpreter', 'latex');
    end
    
    xlabel('Iteration number', 'FontSize', 12, 'Interpreter', 'latex');
    set(gca,'YColor','k');

    ylim('padded');

    set(gca, 'TickLabelInterpreter', 'latex');
    set(gca, 'FontSize', 26);
    
    saveas(f, [img_path_name, '.png'])
end