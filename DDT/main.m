clear all
clc

reward = [ 3000 3048 3012 3036 3021 3027 ];
delayTime = char( '5', '30', '180', '365', '1095', '3650' );
delayTimeTag = char( '5天', '1月', '半年', '1年', '3年', '10年' );
repeat = 5;
crossWaitTime = 0; % s
deadline = 10; % time, s

if exist( 'id.txt', 'file' )
    id = load( 'id.txt' );
    nextID = id + 1;
    save 'id.txt' nextID -ASCII
else
    id = 1;
    nextID = id + 1;
    save 'id.txt' nextID -ASCII
end


if id <= 9
    dataFileName = [ 'Data\DDT0' num2str( id ) '.dat' ];
else
    dataFileName = [ 'Data\DDT' num2str( id ) '.dat' ];
end

if mod(id,2)==1
    flag=[1,0,1,0,1,0];
else if mod(id,2)==0
     flag=[0,1,0,1,0,1];
    end
end

N = length( reward ); 
% -- open window -- %
doublebuffer = 1;
screens = Screen( 'Screens' ); 
screenNumber = max( screens );
Screen( 'Preference', 'SkipSyncTests', 1 );
[ w, rect ] = Screen( 'OpenWindow', screenNumber, 0, [], 32, doublebuffer + 1 );
%Open an onscreen window. Specify a screen by a windowPtr or a screenNumber
% Enable alpha blending with proper blend-function. We need it for drawing of smoothed points:

Screen( 'BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
%where blendequation is a function that describes how the new [Rs Gs Bs As]
%color values and previous old values [Rd Gd Bd Ad] should be combined.
%You can choose the 'blendequation' from a set of defined blend equations via choice of 
%the 'sourceFactorNew' and 'destinationFactorNew' arguments.
%The most common alpha-blending factors are sourceFactorNew = GL_SRC_ALPHA and
%destinationFactorNew = GL_ONE_MINUS_SRC_ALPHA 
[ center(1) center(2) ] = RectCenter(rect);
%RectCenter returns the integer x,y point closest to the center of a rect.  
HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(w));
%use of Priority() is one step to ensure good timing  reduce the chance of other running
%applications and system processes interfering with the execution timing
%of your script, or reduce the severity of interference

% -- load Picture & sound -- %
welcomePic = imread( 'welcome.png' );
welcome = Screen( 'MakeTexture', w, welcomePic );
%Convert the 2D or 3D matrix 'imageMatrix' into an OpenGL texture and return an
%index which may be passed to 'DrawTexture' to specify the texture.
%In the OpenGL Psychtoolbox textures replace offscreen windows for fast drawing
%of images during animation.
goodbyePic = imread( 'goodbye.gif' );
goodbye = Screen( 'MakeTexture', w, goodbyePic );
[ y,fs ] = audioread( 'warning.wav' ); % read in sound file for warning for mATLAB R2018b


% -- welcome -- %
Screen( 'DrawTexture', w, welcome );
Screen( w, 'Flip' );
KbWait;
%When you type "KbWait" at the
 %prompt and hit the enter/return key to execute that command, then KbWait
 %will detect the enter/return key press and return immediatly.
%
while KbCheck; end
%Return keyboard status (keyIsDown),  1 if any key, including modifiers such as <shift>,
 %<control> or <caps lock> is down. 0 otherwise.
%  GetChar and CharAvail are character oriented (and slow), whereas KbCheck
% and KbWait are keypress oriented (and fast)

% --
white = WhiteIndex( w );
order = 1:N;
rand( 'twister', sum( 100 * clock ) );
stocNo = rand( N, 1 );
[ stocNo,index ] = sort( stocNo );
order = order( index ); 
range = zeros( N, 2 );
total_time=zeros(1,N);
counter=ones(1,N);
average_time=zeros(1,N);

for i = 1:N
      %----make hint picture----%    
      if flag(i)==1
        makeHintPic_get( deblank( delayTimeTag(order(i),:) ), num2str( reward(order(i)) ) );
        hintPic = imread( 'cache.png' );
        hint = Screen( 'MakeTexture', w, hintPic );
        Screen( 'DrawTexture', w, hint );
        Screen( w, 'Flip' );
      end
       if flag(i)==0
        makeHintPic_lose( deblank( delayTimeTag(order(i),:) ), num2str( reward(order(i)) ) );
        hintPic = imread( 'cache.png' );
        hint = Screen( 'MakeTexture', w, hintPic );
        Screen( 'DrawTexture', w, hint );
        Screen( w, 'Flip' );
       end
      

%     startSecs=GetSecs;
%     timeSecs=KbWait;
%     t_reaction=timeSecs-startSecs
%     KbWait;
    startSecs=GetSecs;
    timeSecs=KbWait;
    t_choice=timeSecs-startSecs;
    total_time(order(i))=t_choice; 
    while KbCheck; end
    
    upperLimit = reward(order(i));
    lowerLimit = 0;
    
    for j = 1:repeat
        interval = [ 1 2 ] * ( upperLimit - lowerLimit ) / 3 + lowerLimit;
        interval = round( interval );
        nowReward = Shuffle( interval ); 
        for k = 1:2
            if 1&&( upperLimit > nowReward(k) &&  lowerLimit < nowReward(k) ) %-确保新的reward的值在最初始的limit范围内-% 
                
      %----make crosssing picture----%                          
                timecalculation(t_choice);
                TimePic = imread( 'cache1.png' );
                time = Screen( 'MakeTexture', w, TimePic );
                Screen( 'DrawTexture', w, time );
                Screen( w, 'Flip' );
                
                WaitSecs( crossWaitTime );
     %----make choice picture----%           
                if flag(i)==1
                    nowLeft = makeChoicePic_get( deblank( delayTimeTag(order(i),:) ), num2str( reward(order(i)) ), nowReward(k) );
                    choicePic = imread( 'cache.png' );
                    choice = Screen( 'MakeTexture', w, choicePic );
                    Screen( 'DrawTexture', w, choice );
                    Screen( w, 'Flip' );
                end
                if flag(i)==0
                    nowLeft = makeChoicePic_lose( deblank( delayTimeTag(order(i),:) ), num2str( reward(order(i)) ), nowReward(k) );
                    choicePic = imread( 'cache.png' );
                    choice = Screen( 'MakeTexture', w, choicePic );
                    Screen( 'DrawTexture', w, choice );
                    Screen( w, 'Flip' );     
                end   
                
                marker = 0;
                
     %----time calculation----%                
                tic;
                while 1
                    [ KeyIsDown,KeyTime,KeyCode ] = KbCheck;
                    if KeyIsDown & ( strcmp( KbName(KeyCode), 'f' ) | strcmp( KbName(KeyCode), 'j' ) )
                        break
                    end
                end
                t_choice=toc;
                total_time(order(i))=total_time(order(i))+t_choice;
                counter(order(i))=counter(order(i))+1;
                average_time(order(i))=total_time(order(i))./counter(order(i));
                
                if strcmp( KbName(KeyCode), 'f' ) == 1
                    choiceLeft = 1;
                else if strcmp( KbName(KeyCode), 'j' ) == 1
                        choiceLeft = -1;
                    end
                end
                    choiceNow = nowLeft * choiceLeft; %1为现在拿钱 ，-1为之后拿钱
                if flag(i)==1
                    if choiceNow == 1 && upperLimit > nowReward(k)
                        upperLimit = nowReward(k);
                    end
                    if  choiceNow == -1 && lowerLimit < nowReward(k)
                        lowerLimit = nowReward(k);
                    end
                end
                  if flag(i)==0
                    if choiceNow ==-1 && upperLimit > nowReward(k)
                        upperLimit = nowReward(k);
                    end
                    if  choiceNow == 1 && lowerLimit < nowReward(k)
                        lowerLimit = nowReward(k);
                    end
                 end
        end
    end
    range(order(i),1) = lowerLimit;
    range(order(i),2) = upperLimit;
    end
end

% write data file
file = fopen( dataFileName, 'wt+' );
fprintf( file, 'block\tdelayTime\tamount\tlowerLimit\tupperLimit\ttotaltime\taverage_time\n' );
for i = 1:N
 fprintf( file, [ '%g\t' delayTime(order(i),:) '\t%g\t%g\t%g\t%g\t%g\n' ], i, reward(order(i)), range(order(i),1), range(order(i),2),total_time(order(i)), average_time(order(i)) );
end
fclose( file );
Screen( 'DrawTexture', w, goodbye );
Screen( w, 'Flip' );
WaitSecs( 0.5 );
KbWait;
while KbCheck; end

Screen('CloseAll');
close(1)