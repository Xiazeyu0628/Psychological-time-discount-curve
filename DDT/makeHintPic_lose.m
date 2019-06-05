function makeHintPic_lose( delayTime, delayReward )

textFont = '宋体';
textSize = 20;

set( gcf, 'Position', [ 0, 0, 800, 600 ] )
text( 0.5, 0.75, '下面，请您在：', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.06, 0.6, '“现在失去**元”和“    天后失去     元”', 'HorizontalAlignment', 'left', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.06, 0.6,[ '                    ', delayTime, '         ', delayReward ], 'HorizontalAlignment', 'left', 'FontName', textFont, 'FontSize', textSize, 'Color', 'y' )
text( 0.5, 0.45, '之间做出选择', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( 0.5, 0.2, '请按任意键继续', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
set( gca, 'Position', [0 0 1 1] )
set( gca, 'color', [0 0 0] )
set( gcf, 'InvertHardcopy', 'off' ); 
print( 1, '-dpng', 'cache.png' )
clf