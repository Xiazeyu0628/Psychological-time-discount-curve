function makeHintPic_lose( delayTime, delayReward )

textFont = '����';
textSize = 20;

set( gcf, 'Position', [ 0, 0, 800, 600 ] )
text( 0.5, 0.75, '���棬�����ڣ�', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.06, 0.6, '������ʧȥ**Ԫ���͡�    ���ʧȥ     Ԫ��', 'HorizontalAlignment', 'left', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.06, 0.6,[ '                    ', delayTime, '         ', delayReward ], 'HorizontalAlignment', 'left', 'FontName', textFont, 'FontSize', textSize, 'Color', 'y' )
text( 0.5, 0.45, '֮������ѡ��', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.5, 0.2, '�밴���������', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
set( gca, 'Position', [0 0 1 1] )
set( gca, 'color', [0 0 0] )
set( gcf, 'InvertHardcopy', 'off' ); 
print( 1, '-dpng', 'cache.png' )
clf