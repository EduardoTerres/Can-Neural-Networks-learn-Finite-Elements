function y = relu_prime(x)
    y = floor(heaviside(x));
end
% function y = relu_prime(x)
%     y = relu(x) .* (1 - relu(x));
% end