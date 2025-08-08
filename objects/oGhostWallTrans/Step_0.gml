if (op.showHitboxes) { image_alpha=1; }else{ image_alpha=0; }

//step on
if place_meeting(x,y,oPlayerCol)
{
	if (oPlayerCol.y < y + image_yscale * 16)
	{
		op.ghostWall = true;
	}
	else
	{
		op.ghostWall = false;
	}
}