clear
clc

! del /Q FIGURE
! mkdir FIGURE
loc = ls( '..\DDT\Data' );
%ls returns an m-by-n character array of filenames, where m is the number of filenames  and n is the number of characters in the longest filename found. 
% Filenames shorter than n characters are padded with space characters.
P = 3025;
format long g
dataLong = 6;
warning off
% --
Kmin = 0.00;
Kmax = 0.01;
testN = 100;
% --
start=3;
loc = loc(start:size(loc,1) , : ); %从第三行开始
% --
K_0 = linspace( Kmin, Kmax, testN ); 
R2_0_hyperbolic_model = zeros( testN, 1 );%R^2 initial value matrix

R2_0_exponential_model = zeros( testN, 1 );

K_hyperbolic_model = zeros( length( loc ), 1 );
R2_hyperbolic_model = zeros( length( loc ), 1 );
K_exponential_model  = zeros( length( loc ), 1 );
R2_exponential_model  = zeros( length( loc ), 1 );

for i = 1:size(loc,1)
    fileLoc = loc(i,:);
    fileLoc = deblank( fileLoc );%filelocation eg:DDT01.dat
    fid = fopen( [ '..\DDT\Data\' fileLoc], 'r' );
    nextline = fgetl( fid );
    time = zeros( dataLong, 1 );
    value = zeros( dataLong, 1 );
    index = 0;
    while index < dataLong
        index = index + 1;
        nextline = fgetl( fid );%读取文件下一行
        line_content = textscan( nextline, '%f%s%f%f%f' );
        value(index) = line_content{4};
        time(index) = str2num(line_content{2}{1,1});
    end
    fclose( fid );
    disp( [ fileLoc, '......' ] );
    [ time, ii ] = sort( time );
    value = value(ii);
    for k = 1:testN
        R2_0_hyperbolic_model(k) = test_hyperbolic_model( time, value, K_0(k), P );
        R2_0_exponential_model(k) = test_exponential_model( time, value, K_0(k), P );      
    end
    [ temp_hyperbolic_model, num_hyperbolic_model ] = max( R2_0_hyperbolic_model ); 
    [ temp_exponential_model , num_exponential_model  ] = max( R2_0_exponential_model ); 
    
    [ tempK_hyperbolic_model, tempR2_hyperbolic_model, tempK_exponential_model,tempR2_exponential_model,residua_square_sum_hyperbolic,residua_square_sum_exponential,residual_matrix_hyperbolic,residual_matrix_exponential] = cacuKandR( time, value, K_0(num_hyperbolic_model), K_0(num_exponential_model),P, fileLoc ); 

    
    K_hyperbolic_model(i) = tempK_hyperbolic_model;
    R2_hyperbolic_model(i) = tempR2_hyperbolic_model;
     K_exponential_model(i) = tempK_exponential_model ;
    R2_exponential_model(i) = tempR2_exponential_model ;
    residual_matrix_hyperbolic;
    residual_matrix_exponential;
    variable=1;
    AIC_hyperbolic_model(i)=dataLong*log(residua_square_sum_hyperbolic)+2*(variable+1)-dataLong*log(dataLong);
    BIC_hyperbolic_model(i)=dataLong*log(residua_square_sum_hyperbolic)+log(dataLong)*(variable+1)-dataLong*log(dataLong);
    AIC_exponential_model(i)=dataLong*log(residua_square_sum_exponential)+2*(variable+1)-dataLong*log(dataLong);
    BIC_exponential_model(i)=dataLong*log(residua_square_sum_exponential)+log(dataLong)*(variable+1)-dataLong*log(dataLong);
end
disp( '......datas have already been read......' );
% --
fid = fopen( 'KandR2.txt', 'wt+' );
fprintf( fid, 'ID\tK_hyperbolic\tR^2_hyperbolic\tK_exponential\tR^2_exponential\tAIC_hyperbolic\tBIC_hyperbolic\tAIC_exponential\tBIC_exponential\n' );
for i = 1:size(loc,1)
fprintf( fid,'%g\t%g\t%g\t\t%g\t%g\t\t%g\t\t%g\t\t%g\t\t%g\n',i,K_hyperbolic_model(i), R2_hyperbolic_model(i),K_exponential_model(i), R2_exponential_model(i), AIC_hyperbolic_model(i),BIC_hyperbolic_model(i),AIC_exponential_model(i),BIC_exponential_model(i));
 if R2_hyperbolic_model(i) < 0.5
        fprintf( 'Warning! Check the data of subject %i!!!\n', i );
end
end
% for i = 1:length( loc )
%     fileLoc = loc(i,:);
%     fileLoc = deblank( fileLoc );
%     temp = fileLoc( 4:length( fileLoc ) - 4 );
%     temp = str2num( temp );
%     fprintf( fid, '%i\t%.10f\t%.10f\n', temp, K(i), R2(i) );
%     if R2(i) < 0.5
%         fprintf( 'Warning! Check the data of subject %i!!!\n', temp );
%     end
% end
fclose( fid );