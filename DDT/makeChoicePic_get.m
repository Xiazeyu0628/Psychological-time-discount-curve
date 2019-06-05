function nowLeft = makeChoicePic_get( delayTime, delayReward, nowReward )

textFont = '����';
textSize = 20;

set( gcf, 'Position', [ 0, 0, 800, 600 ] )
loc = Shuffle( [ 0.3 0.7 ] );
text( loc(1), 0.65, 'ϣ�����ڵõ���', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( loc(1), 0.55, num2str( nowReward ), 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'y' )
text( loc(2), 0.65, [ 'ϣ��' delayTime '��õ���' ], 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( loc(2), 0.55, num2str( delayReward ), 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'y' )
text( min(loc), 0.35, '�밴��F��', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
text( max(loc), 0.35, '�밴��J��', 'HorizontalAlignment', 'center', 'FontName', textFont, 'FontSize', textSize, 'Color', 'w' )
set( gca, 'Position', [0 0 1 1] )
set( gca, 'color', [0 0 0] )
set( gcf, 'InvertHardcopy', 'off' ); 
print( 1, '-dpng', 'cache.png' )
clf
if loc(1) < loc(2)
    nowLeft = 1;
else
    nowLeft = -1;
end