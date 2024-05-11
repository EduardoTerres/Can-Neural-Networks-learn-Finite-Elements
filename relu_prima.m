% FUNCTION NAME:
%   relu_prime
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%   Given x, compute ReLU'(x).
%
% INPUT:
%   in1 - (double) x
%
% OUTPUT:
%   y - (double) Evaluation of ReLU' in x.
function y = relu_prima(x)
    y = floor(heaviside(x));
end
