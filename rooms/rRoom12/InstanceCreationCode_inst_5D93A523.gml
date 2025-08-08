op.showHitboxes = false;
op.debug = true;

music(mus_glowingSnow);


party_guarantee(function()
{
	op.partyFollow=[0];
	
	char_animate(1,1,1,,,120-15,170,,,["faceDown"]);
	char_animate(2,1,1,,,120+15,170,,,["faceDown"]);
	
	char_animate("followerN",1,1,,,120,170+15,function(){ followerFollow = false; },,["faceDown"]);
});