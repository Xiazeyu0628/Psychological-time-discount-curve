function timecalculation(time)
textFont = '����';
textSize = 20;
set( gcf, 'Position', [ 0, 0, 800, 600 ] )
text( 0.03, 0.6,[ '�ո�����ѡ��ʱ��Ϊ', num2str(time), 's����������׼����һ��......'], 'HorizontalAlignment', 'left', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
%text( 0.3, 0.5,  '���Ժ�����׼����һ��......' , 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
set( gca, 'Position', [0 0 1 1] )
set( gca, 'color', [0 0 0] )
set( gcf, 'InvertHardcopy', 'off' ); 
print( 1, '-dpng', 'cache1.png' )
clf


