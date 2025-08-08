une=op.une; ++op.une;
ranUne=irandom_range(0,999999999);



func=-1;
returnToNormal=false;
defaultWalkSprite=-1;

type=0;
numb=-1;
number=0;
numbClamp=0;
followerNumb=-1;

walkOffset=0;
walkOffsetMode=0;

direction_=-1;
sprite=-1;
_subimg=-1;
xscale=1;

time=0;
seed=[];



//cutscene Variables
walkSprites=[sKris_Up,sKris_Down,sKris_Left,sKris_Right];

animateCheck=true;
animate=[];

cutsceneStarted=false; cutsceneHappened=false;

findAngle=-1;

extraX=0; extraY=0;
shakeX=0; shakeY=0; shakeInfo=[-1,0,0,0];
dodgeAlpha2=1;

subnumber=false;

followerFollow = true;



//visual Variables
bright=0; brightMode=0; colorFlash=[0,0,0];
image_blend=c_white;



//enemy Variables
str=-1;
strString=-1;

startX=x; startY=y;
pastXY=[x,y];
path=-1; pathSpeed=2;
reaction=[false,30,0,true,false,0]; dWalkXY=[0,0];
draw=-1;
drawON=true; front=false;
effect=-1;

red=[];

deadAlpha=0;
