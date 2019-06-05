function R2 = test_hyperbolic_model( x, y, K0, P )% R2_0(k) = test( time, value, K_0(k), P );

eps = 1e-5;

K = K0;
error = 1;
marker = 0;
while error > eps && marker <= 100
    marker = marker + 1;
    summation = 0;
    diffCoe = 0;
    for i = 1:length( x )%6
        temp = 1 + K * x(i);
        summation = summation + x(i) * y(i) * temp^(-2) - P * x(i) * temp^(-3);
        diffCoe = diffCoe - 2 * x(i)^2 * y(i) * temp^(-3) + 3 * P * x(i)^2 * temp^(-4);
    end
    oldK = K;
    K = K - summation / diffCoe;
    error = abs( K - oldK );
end
y2 = P ./ ( 1 + K * x );
temp = regstats( y, y2 );
R2 = temp.rsquare;