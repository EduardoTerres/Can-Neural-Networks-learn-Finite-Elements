% SCRIPT:
%       fem_nn_2.m
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%       Matlab script for training a FEM based neuronal network
%       where b2 and W2 are fixed and W3 is free.
%% Configuration and initialization of parameters
% Equation parameters
epsilon = 0.1;
upwind = false;

% Grid
N = 20;
h = 1/N;
grid = linspace(0, 1, N+1);

% Training parameters
Niter = 2 * 1e5; % Number of iterations
eta = 1e-6; % Learning rate
beta = 0; % Regularization parameter

% Theoretical solution (for plotting and calculating error)
y = @(x) 1 / (1 - exp(1 / epsilon)) * (exp(x / epsilon) - 1) + x;
% Use this for correct plot in the upwind version
y = @(x) (-exp(-1/epsilon)+exp((x-1)./epsilon))/(exp(-1/epsilon)-1) + x;

if upwind == false
    beta_1 = -epsilon/h^2 - 1/(2*h);
    beta0 = 2*epsilon/h^2;
    beta1 = -epsilon/h^2 + 1/(2*h);
else
    beta_1 = -epsilon/h^2 - 1/h;
    beta0 = 2*epsilon/h^2 + 1/h;
    beta1 = -epsilon/h^2;
end

rng('default');

F_iter = cell(1, N+1);
Dj = cell(1, N+1);
sigma_z = cell(1, N+1);
sigma_prima_z = cell(1, N+1);
b2 = rand(3*(N-1), 1);
W2 = rand(3*(N-1), 1);
% Note that W3 is intialized to small random values to get a smaller value
% of cost function in the first iteration. Has little effect.
W3 = 1e-12 * rand(1, 3*(N-1));
savecost = zeros(1,1);
L2_distance = zeros(1,1);

% Initialize b2 and W2
for j = 0:N-2
    W2(3*j+1:3*j+3) = [1/h, 2/h, 1/h];
    b2(3*j+1:3*j+3) = [...
        -grid(j+1)/h, ...
        -grid(j+2)*(2/h), ...
        -grid(j+3)/h];
end

% Grid for calculating errors
N_ref = 300;
grid_ref = linspace(0, 1, N_ref+1);
grid_ref = grid_ref(2:end-1);    
M_L2 = (...
    2 / 3 * diag(ones(1,N_ref-1)) ...
    + 1 / 6 * diag(ones(1,N_ref-2),1) ...
    + 1 / 6 * diag(ones(1,N_ref-2),-1) ...
) / N_ref;

%% Training process main loop
for counter = 1:Niter
    % Compute F on the grid points
    for j = 1:N+1
        F_iter{j} = F(grid(j), b2, W2, W3);
    end

    % Compute Dj
    for j = 2:N
        Dj{j} = beta_1 * F_iter{j-1} + ...
        beta0 * F_iter{j} + ...
        beta1 * F_iter{j+1} - 1;
    end

    % Compute sigma(z), sigma'(z)
    for j = 1:N+1
        z_aux = W2 * grid(j) + b2;
        sigma_z{j} = relu(z_aux);
        sigma_prima_z{j} = relu_prima(z_aux);
    end

    % Compute derivative wrt W3
    dw3 = (F_iter{1} * sigma_z{1} + ...
        F_iter{N+1} * sigma_z{N+1})';

    for j = 2:N
        dw3 = dw3 + (Dj{j} * (...
            beta_1 * sigma_z{j-1} + ...
            beta0 * sigma_z{j} + ...
            beta1 * sigma_z{j+1}))';
    end

    % Regularization
    dw3 = dw3 + beta * W3;

    % Update weights and biases
    W3 = W3 - eta * dw3;

    % Compute and save cost
    newcost = cost(F_iter, Dj, N, b2, W2, W3, beta);
    savecost(counter) = newcost;

    % Compute and save L2 error
    e = F(grid_ref, b2, W2, W3) - y(grid_ref);
    L2_distance(counter) = (e * M_L2 * e') ^ (1/2);
end

%% Plot and save results
% NOTE: folder gen must exist

save('gen/data.mat', 'b2', 'W2', 'W3', 'savecost', 'L2_distance');
save('gen/config.mat', 'epsilon', 'N', 'Niter', 'eta');

% Plot cost and L2 error
plot_costs(savecost, L2_distance, 'tickaligned', 'gen/costs');

% Plot NN and theoretical solution
plot_result(@F, b2, W2, W3, epsilon, N, false, 'gen/nn_output')
plot_result(@F, b2, W2, W3, epsilon, N, true, 'gen/nn_output_gridlines')

%% Neural network
function F = F(x, b2, W2, W3)
   F = W3 * relu(W2 * x + b2);
end

%% Cost function
function costval = cost(F_iter, Dj, N, b2, W2, W3, beta)
    % F_iter y Dj must have been calculated for the same weights and
    % biases.
    costval = F_iter{1}^2 + F_iter{N+1}^2 + ...
        beta * (sum(b2 .^ 2) + sum(W2 .^ 2) + sum(W3 .^ 2));
    for j = 2:N
        costval = costval + Dj{j}^2;
    end
end