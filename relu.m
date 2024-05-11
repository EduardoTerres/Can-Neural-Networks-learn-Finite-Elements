% FUNCTION NAME:
%   relu
%
% AUTHORS:
%       Eduardo Terrés and Julia Novo
%
% DESCRIPTION:
%   Given x, compute ReLU(x).
%
% INPUT:
%   in1 - (double) x
%
% OUTPUT:
%   y - (double) Evaluation of ReLU in x.
function y = relu(x)
    y = max(0, x);
end