function [ grad_f_x ] = g2( x )
%GRADIENTE Summary of this function goes here
%   Detailed explanation goes here
% % exemplo 1
%     grad_f_x(1) = 1;
%     grad_f_x(2) = 1;
% exemplo 2
     grad_f_x(1) = 2*x(1);
     grad_f_x(2) = 2*x(2);
% % exemplo 3
%     grad_f_x(1) = 4*power((x(1)-2),3) + 2*(x(1)-2*x(2));
%     grad_f_x(2) = -4*(x(1)-2*x(2));
% % exemplo 4
%     grad_f_x(1) = 2*x(1);
%     grad_f_x(2) = 2*x(2);
%     grad_f_x(3) = 2*x(3);
%     grad_f_x(4) = 2*x(4);
%     grad_f_x(5) = 2*x(5);
end

