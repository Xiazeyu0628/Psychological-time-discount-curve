function [ K_hyperbolic, R2_hyperbolic,K_exponential,R2_exponential,residua_square_sum_hyperbolic,residua_square_sum_exponential,residual_matrix_hyperbolic,residual_matrix_exponential] = cacuKandR( x, y, K0_hyperbolic_model, K0_exponential_model,P, fileLoc )
 
residua_square_sum_hyperbolic=0;
residua_square_sum_exponential=0;
eps = 1e-10;
K_hyperbolic =  K0_hyperbolic_model;
error = 1;
marker = 0;

while error > eps && marker <= 100
    marker = marker + 1;
    summation1 = 0;
    diffCoe1 = 0;
    for i = 1:length( x )
        temp = 1 + K_hyperbolic * x(i);
        summation1 = summation1 + x(i) * y(i) * temp^(-2) - P * x(i) * temp^(-3);
        diffCoe1 = diffCoe1 - 2 * x(i)^2 * y(i) * temp^(-3) + 3 * P * x(i)^2 * temp^(-4);
    end
    oldK = K_hyperbolic;
    K_hyperbolic = K_hyperbolic - summation1 / diffCoe1;
    error = abs( K_hyperbolic - oldK );
end

marker = 0;
K_exponential = K0_exponential_model;
error = 1;

while error > eps && marker <= 100
    marker = marker + 1;
    summation2 = 0;
    diffCoe2 = 0;
    for i = 1:length( x )
        temp = exp(-K_exponential * x(i));
        summation2 = summation2 + x(i) * y(i) * temp^(-2) - P * x(i) * temp^(-3);
        diffCoe2 = diffCoe2 - 2 * x(i)^2 * y(i) * temp^(-3) + 3 * P * x(i)^2 * temp^(-4);
    end
    oldK = K_exponential;
    K_exponential = K_exponential - summation2 / diffCoe2;
    error = abs( K_exponential - oldK );
end



y1 = P ./ ( 1 + K_hyperbolic * x );
y2 = P.*exp( -K_exponential * x );
temp_hyperbolic = regstats( y, y1 );
temp_exponential = regstats( y, y2 );
R2_hyperbolic= temp_hyperbolic.rsquare;
R2_exponential = temp_exponential.rsquare;
residual_matrix_hyperbolic=temp_hyperbolic.r;
residual_matrix_exponential=temp_exponential.r;

for i=1:length(residual_matrix_hyperbolic)
    residua_square_sum_hyperbolic= residua_square_sum_hyperbolic+residual_matrix_hyperbolic(i)^2;
end
for i=1:length(residual_matrix_exponential)
    residua_square_sum_exponential= residua_square_sum_exponential+residual_matrix_exponential(i)^2;
end


%绘制预测点
x1 = linspace( 0, max( x ), 1000 );
y1 = P ./ ( K_hyperbolic * x1 + 1 );
y2 = P .*exp( -K_exponential * x1 );

hold on
plot( x, y, '.r', 'MarkerSize', 15 )
plot( x1, y1, 'LineWidth', 2,'color' ,'k')
plot( x1, y2, 'LineWidth', 2,'color' ,'b' )
temp = fileLoc( 4:length( fileLoc ) - 4 );
temp = str2num( temp );
title( [ '被试', num2str( temp ), '延时折扣曲线' ], 'FontName', '黑体', 'Fontsize', 15, 'FontWeight', 'bold' )
xlabel( '延迟时间 / 天', 'FontName', '黑体', 'Fontsize', 15, 'FontWeight', 'bold' )
ylabel( '主观价值 / 元', 'FontName', '黑体', 'Fontsize', 15, 'FontWeight', 'bold' )
%text(250,750, ['hyperbolic R^2 = ' num2str( R2_hyperbolic) ], 'FontName', 'Times New Roman', 'Fontsize', 13, 'FontWeight', 'bold' )
%text(250, 600, ['hyperbolic k = ' num2str( K_hyperbolic) ], 'FontName', 'Times New Roman', 'Fontsize', 13, 'FontWeight', 'bold' )
%text(250,450, ['exponential R^2 = ' num2str( R2_exponential) ], 'FontName', 'Times New Roman', 'Fontsize', 13, 'FontWeight', 'bold' )
%text(250, 300, ['exponential k = ' num2str( K_exponential) ], 'FontName', 'Times New Roman', 'Fontsize', 13, 'FontWeight', 'bold' )
legend( '实验数据', '双曲线模型拟合曲线','指数模型拟合曲线')
set( legend, 'fontname', '黑体', 'fontsize', 13 )
set( gcf, 'Position', [100,100,560,420] )
saveas( gcf, [ 'FIGURE\' fileLoc( 1:length(fileLoc) - 4 ) ], 'png')
pause( 1 )
close( 1 )