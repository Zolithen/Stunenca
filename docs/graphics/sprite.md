# The sprite classes
An sprite is something drawn onto the user's screen. Zariel provides some class to draw this onto the screen, with some modifications which allow for animations and using spritesheets instead of different photos. 

Please notice that this classes arent obligatory for drawing things onto screen, as you can still use love.graphics functions.

## sprite
Represents a simple image.

local sprite = new_sprite(parent: node, image: string (direction) or Image)
component -> sprite



## animation

## spritesheet


# The sprite_sheet
Zariel provides special nodes from drawing things on screen. Of course, you can still use the "draw" event and love's functions to draw things, but there are specific things that are made easier with Zariel's "sprite.lua" file. 