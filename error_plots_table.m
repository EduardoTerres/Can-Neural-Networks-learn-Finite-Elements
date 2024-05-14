% SCRIPT:
%       error_plots_table.m
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%       Matlab script for training a FEM based neuronal network
%       where b2 and W2 are fixed and W3 is free.
%% Evaluation grid
N_ref = 20000;
h_ref = 1 / N_ref;
grid_ref = linspace(0, 1, N_ref + 1);
grid_ref = grid_ref(2:end-1);

ITER_N = [20, 40, 100];
data = cell(size(ITER_N));
data_upwind = cell(size(ITER_N));


%% Table 1. Diffusion dominated regime
% Equation parameter
epsilon = 0.1;

% Theoretical solution
y = @(x) (-exp(-1/epsilon)+exp((x-1)./epsilon))/(exp(-1/epsilon)-1) + x;

for id = 1:3
    N = ITER_N(id);
    h = 1/N;
    grid = linspace(0, 1, N + 1);
        
    % Theoretical
    I_h_u = y(grid_ref);

    % FEM
    K_N = 2*eye(N-1) - diag(ones(N-2,1), 1) - diag(ones(N-2,1), -1);
    C_N = diag(ones(N-2,1), 1) - diag(ones(N-2,1), -1);
    H = h * ones(N-1, 1);    
    D = epsilon * 1/h * K_N + 1/2 * C_N;
    SOL_FEM = [0; D\H; 0];
    
    u_h = interp1(grid, SOL_FEM, grid_ref, "linear");

    % NN
    load(['table_data/weights_biases_', num2str(N), '.mat']) 
    u_NN = W3 * relu(W2 * grid_ref + b2);

    % Compute errors
    M = (...
        2 / 3 * diag(ones(1,N_ref - 1)) ...
        + 1 / 6 * diag(ones(1,N_ref - 2), 1) ...
        + 1 / 6 * diag(ones(1,N_ref - 2), -1) ...
    ) * h_ref;

    K = (...
        2 * diag(ones(1,N_ref - 1)) ...
        - diag(ones(1,N_ref - 2), 1) ...
        - diag(ones(1,N_ref - 2), -1) ...
    ) / h_ref;

    e_1 = I_h_u - u_h;
    e_2 = I_h_u - u_NN;
    
    data{id} = [(e_1 * M * e_1') ^ (1/2);
        (e_1 * K * e_1') ^ (1/2);
        (e_2 * M * e_2') ^ (1/2);
        (e_2 * K * e_2') ^ (1/2)];

    % Plots. FEM - NN
    f = figure;
    plot(grid_ref, abs(u_h - u_NN), 'LineWidth', 2.5, 'Color', 'b');
    title(['N = ', num2str(N)], 'Interpreter', 'latex');
    set(gca, 'TickLabelInterpreter', 'latex');
    set(gca, 'FontSize', 20);
    set(gca, 'YAxisLocation', 'right');
    ylim('padded');

    % Save plots
    saveas(f, ['gen/error_', num2str(ITER_N(id)),'.png'])
end

%% Table 2. Convection dominated regime

% Parámetros
epsilon = 0.001;

% Theoretical solution
y = @(x) (-exp(-1/epsilon)+exp((x-1)./epsilon))/(exp(-1/epsilon)-1) + x;

for id = 1:3
    N = ITER_N(id);
    h = 1/N;
    grid = linspace(0, 1, N + 1);
        
    % Theoretical
    I_h_u = y(grid_ref);

    % FEM
    K_N = 2*eye(N-1) - diag(ones(N-2,1), 1) - diag(ones(N-2,1), -1);
    C_N = eye(N-1) - diag(ones(N-2,1), -1);
    H = h * ones(N-1, 1);    
    D = epsilon * 1/h * K_N + C_N;
    SOL_FEM = [0; D\H; 0];
    
    u_h = interp1(grid, SOL_FEM, grid_ref, "linear");

    % NN
    load(['table_data/weights_biases_upwind_', num2str(N), '.mat']) 
    u_NN = W3 * relu(W2 * grid_ref + b2);

    % Compute errors
    M = (...
        2 / 3 * diag(ones(1,N_ref - 1)) ...
        + 1 / 6 * diag(ones(1,N_ref - 2), 1) ...
        + 1 / 6 * diag(ones(1,N_ref - 2), -1) ...
    ) * h_ref;

    K = (...
        2 * diag(ones(1,N_ref - 1)) ...
        - diag(ones(1,N_ref - 2), 1) ...
        - diag(ones(1,N_ref - 2), -1) ...
    ) / h_ref;

    e_1 = I_h_u - u_h;
    e_2 = I_h_u - u_NN;
    
    data_upwind{id} = [(e_1 * M * e_1') ^ (1/2);
        (e_1 * K * e_1') ^ (1/2);
        (e_2 * M * e_2') ^ (1/2);
        (e_2 * K * e_2') ^ (1/2)];
end

disp('Table 1: Diffusion dominated regime (epsilon = 0.1)')
t1 = array2table( ...
    cell2mat(data)', ...
    'RowNames', {'N = 20', 'N = 40', 'N = 100'}, ...
    'VariableNames', {'      L2 FEM      ', '      H1 FEM      ', ...
    '      L2 NN      ', '      H1 NN      '});
disp(t1)

disp('Table 2: Convection dominated regime (epsilon = 0.001)')
t2 = array2table( ...
    cell2mat(data_upwind)', ...
    'RowNames', {'N = 20', 'N = 40', 'N = 100'}, ...
    'VariableNames', {'      L2 FEM      ', '      H1 FEM      ', ...
    '      L2 NN      ', '      H1 NN      '});
disp(t2)
