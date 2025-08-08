++time;
if (time == 1 and spawnWall and !spawnGhostWall) { with (instance_create_depth(x,y,0,oWall)) { image_alpha=0; image_xscale=other.image_xscale; image_yscale=other.image_yscale; forceHide=true; if (false) { sticky=true; } } }
if (time == 1 and spawnGhostWall) { with (instance_create_depth(x,y,0,oGhostWall)) { image_alpha=0; image_xscale=other.image_xscale; image_yscale=other.image_yscale; } }



if (op.mode == "overworld" and check) { check=false; }

if (step != -1)
{
	step();
}



//char connection
if (charData != -1)
{
	charGone=true;
	
	with (oChar)
	{
		if (ranUne == other.charData)
		{
			other.charGone=false;
			other.x=x;
			other.y=y;
			other.sprite_index=sprite_index;
			other.image_index=image_index;
		}
	}
	
	if (charGone) { instance_destroy(); }
}