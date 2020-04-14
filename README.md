# Zariel-Engine

![l](https://github.com/SuperHostile/Zariel-Engine/blob/master/logo.png "")

This project uses:
	1. **Windfield**: https://github.com/adnzzzzZ/windfield (Modifications were made: see below)
	2. **Flux**: https://github.com/rxi/flux/ (Modifications were made: see below)

_Copyright 2019 SuperHostile / 128_NyKi
Licensed under the MIT license https://opensource.org/licenses/MIT_

A game engine created in Lua for the Löve2d framework.

The Zariel Engine is a WIP game engine created on top of the Löve2d framework. 
It was originally made to power a simple rogue-lite game, but i decided to make it more general.
A simple example can be found in main.lua, i will provide more examples when the game engine goes to an alpha or beta state.

## Modifications to already existing libraries
**Windfield**: I modified the UUID generator because it didn't work for some reason.
**Flux**: I modified the "makefunc" function because str:gsub wasnt working for some reason.
