love.graphics.setDefaultFilter("nearest", "nearest")

blocks = {

	--Index 1, air
	{
		name = "air", 
		type = "air"
	},

	--Index 2, grass
	{
		name = "grass", 
		type = "block", 
		image = {
			{love.graphics.newImage("blocks/grass/0.png")},
			{love.graphics.newImage("blocks/grass/1.png")},
			{love.graphics.newImage("blocks/grass/2.png")},
			{love.graphics.newImage("blocks/grass/3.png")},
			{love.graphics.newImage("blocks/grass/4.png")},
			{love.graphics.newImage("blocks/grass/5.png")},
			{love.graphics.newImage("blocks/grass/6.png")},
			{love.graphics.newImage("blocks/grass/7.png")},
			{love.graphics.newImage("blocks/grass/8.png")},
			{love.graphics.newImage("blocks/grass/9.png")},
			{love.graphics.newImage("blocks/grass/10.png")},
			{love.graphics.newImage("blocks/grass/11.png")},
			{love.graphics.newImage("blocks/grass/12.png")},
			{love.graphics.newImage("blocks/grass/13.png")},
			{love.graphics.newImage("blocks/grass/14.png"), love.graphics.newImage("blocks/grass/14_alt1.png"), love.graphics.newImage("blocks/grass/14_alt2.png")},
			{love.graphics.newImage("blocks/grass/15.png"), love.graphics.newImage("blocks/grass/15_alt1.png"), love.graphics.newImage("blocks/grass/15_alt2.png")}
		}
	},

	--Index 3, stone
	{
		name = "stone", 
		type = "block", 
		image = {
			{love.graphics.newImage("blocks/stone/0.png")},
			{love.graphics.newImage("blocks/stone/1.png")},
			{love.graphics.newImage("blocks/stone/2.png")},
			{love.graphics.newImage("blocks/stone/3.png")},
			{love.graphics.newImage("blocks/stone/4.png")},
			{love.graphics.newImage("blocks/stone/5.png")},
			{love.graphics.newImage("blocks/stone/6.png")},
			{love.graphics.newImage("blocks/stone/7.png")},
			{love.graphics.newImage("blocks/stone/8.png")},
			{love.graphics.newImage("blocks/stone/9.png")},
			{love.graphics.newImage("blocks/stone/10.png")},
			{love.graphics.newImage("blocks/stone/11.png")},
			{love.graphics.newImage("blocks/stone/12.png")},
			{love.graphics.newImage("blocks/stone/13.png")},
			{love.graphics.newImage("blocks/stone/14.png"), love.graphics.newImage("blocks/stone/14_alt1.png"), love.graphics.newImage("blocks/stone/14_alt2.png")},
			{love.graphics.newImage("blocks/stone/15.png"), love.graphics.newImage("blocks/stone/15_alt1.png"), love.graphics.newImage("blocks/stone/15_alt2.png")}
		}
	}
}