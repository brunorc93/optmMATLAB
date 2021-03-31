function [ hessiana_f_x ] = h2( x )
%HESSIANA Summary of this function goes here
%   Detailed explanation goes here
% % exemplo 1
%     hessiana_f_x = [ 0, 0;
%                      0, 0];
% exemplo 2
    hessiana_f_x = [ 2, 0;
                     0, 2];
% % exemplo 3
%     hessiana_f_x = [ 12*power(x(1)-2,2)+2 , -4;
%                     -4                    ,  8];
% % exemplo 4
%     hessiana_f_x = [ 2, 0, 0, 0, 0;
%                      0, 2, 0, 0, 0;
%                      0, 0, 2, 0, 0;
%                      0, 0, 0, 2, 0;
%                      0, 0, 0, 0, 2];
end

