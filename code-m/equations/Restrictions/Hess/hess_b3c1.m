function [ h_penalidade_valor ] = hess_b3c1( x )
%PENALIDADE Summary of this function goes here
%   Detailed explanation goes here
% % exemplo 1
%         %st.: -2 -x1 -2x2 <=0
%         %     8 - 6x1 +x1^2 -x2 <=0
%         f_penalidade_valor = 1/2*((max(0,-2-x(1)-2*x(2)))^2+(max(0,8-6*x(1)+(x(1))^2-x(2)))^2);
% % exemplo 2
%         %st.: 2x1 +x2 -2 <=0
%         %     -x2 +1 <=0
%         f_penalidade_valor = 1/2*rp*((max(0,2*x(1)+x(2)-2))^2+(max(0,-x(2)+1))^2);
% exemplo 3
        %st.: x1^2 - x2 <=0
        %f_penalidade_valor = 1/2*rp*((max(0,(x(1))^2-x(2)))^2);        
        h_penalidade_valor(1,1) = -1*(1/(x(1)^2 - x(2))^2)*(2) + 2*(1/(x(1)^2 - x(2))^3)*(4*x(1)^2);
        h_penalidade_valor(1,2) = -4*x(1)*(1/(x(1)^2 - x(2))^3);
        h_penalidade_valor(2,1) = -4*x(1)*(1/(x(1)^2 - x(2))^3);
        h_penalidade_valor(2,2) = (1/(x(1)^2 - x(2))^2);
% % exemplo 4
%         %st.: x1 +2x2 +x3 -1 =0
%         %     x3 -2x4 +x5 -6 =0
%         f_penalidade_valor = 1/2*rp*((x(1)+2*x(2)+x(3)-1)^2+(x(3)-2*x(4)+x(5)-6)^2);

end

