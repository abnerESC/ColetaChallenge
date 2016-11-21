-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- include Corona's "widget" library
local widget = require "widget"

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local menuSound = audio.loadSound( "audio/menu.mp3")
--audio.play(menuSound, { loops = -1 })
local function onBackPressed()
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function goToLevel1()
	audio.stop()
	total = 0
	possibleCreate = false
	-- go to level1.lua scene
	composer.removeScene( "levels" )
	composer.gotoScene( "level1" )
	
	return true	-- indicates successful touch
end

local function goToLevel2()
	audio.stop()
	total = 0
	possibleCreate = false
	-- go to level1.lua scene
	composer.removeScene( "levels" )
	composer.gotoScene( "level2" )
	
	return true	-- indicates successful touch
end

local function goToLevel3()
	audio.stop()
	total = 0
	possibleCreate = false
	-- go to level1.lua scene
	composer.removeScene( "levels" )
	composer.gotoScene( "level3" )
	
	return true	-- indicates successful touch
end

local function goToLevel4()
	audio.stop()
	total = 0
	possibleCreate = false
	-- go to level1.lua scene
	composer.removeScene( "levels" )
	composer.gotoScene( "level4" )
	
	return true	-- indicates successful touch
end


function scene:create( event )
	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setDrawMode( "normal" )

	local back = widget.newButton({
		defaultFile="img/buttons/back.png",
		width=30, height=30,
		onEvent = onBackPressed,
		labelColor = {default={ 1, 1, 1 }},
		labelXOffset = -35
	})
	back.x = screenW - 35
	back.y = 35

	local background = display.newImageRect( "img/menuComponents/superbackground.png", screenW, screenH * 2 )
	background.x, background.y = 0,0
	background.anchorX = 0
	
	sceneGroup:insert( background )

	iteradorsuperbackground = 0

	local function superbackgroundAnimation()

		iteradorsuperbackground = iteradorsuperbackground + 5

	 	background.y = background.y + 5
		--print("iteradorsuperbackground="..iteradorsuperbackground..", img.y="..background.y)
		if (iteradorsuperbackground < screenH) then
			timer.performWithDelay(1, superbackgroundAnimation);
		end
	end

	superbackgroundAnimation()

	proporcaoDistancia = ( screenH - 100 )/6
	margemDireita = screenW * 0.25
	margemDireitaEntreObjetos = 100
	dimensoesCores = 30
	dimensoesObjects = 20

	buttonWidth = screenW * 0.4

	local buttonLevel1 = widget.newButton({
		defaultFile="img/levels/frança.png",
		width = buttonWidth, height= buttonWidth,
		onEvent = goToLevel1,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = buttonWidth/2 + 10
	})
	buttonLevel1.x = margemDireita
	buttonLevel1.y = 140
	buttonLevel1:setLabel("França")

	local buttonLevel2 = widget.newButton({
		defaultFile="img/levels/brasil.png",
		width = buttonWidth, height= buttonWidth,
		onEvent = goToLevel2,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = buttonWidth/2 + 10
	})
	buttonLevel2.x = buttonLevel1.x + screenW * 0.5
	buttonLevel2.y = 140
	buttonLevel2:setLabel("Brasil")

	local buttonLevel3 = widget.newButton({
		defaultFile="img/levels/china.png",
		width = buttonWidth, height= buttonWidth,
		onEvent = goToLevel3,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = buttonWidth/2 + 10
	})
	buttonLevel3.x = margemDireita
	buttonLevel3.y = buttonLevel1.y + buttonLevel1.width + 25
	buttonLevel3:setLabel("China")

	local buttonLevel4 = widget.newButton({
		defaultFile="img/levels/eua.png",
		width = buttonWidth, height= buttonWidth,
		onEvent = goToLevel4,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = buttonWidth/2 + 10
	})
	buttonLevel4.x = buttonLevel1.x + screenW * 0.5
	buttonLevel4.y = buttonLevel1.y + buttonLevel1.width + 25
	buttonLevel4:setLabel("EUA")

	sceneGroup:insert( buttonLevel1 )
	sceneGroup:insert( buttonLevel2 )
	sceneGroup:insert( buttonLevel3 )
	sceneGroup:insert( buttonLevel4 )
	sceneGroup:insert( back )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

	end	
end

function scene:hide( event )
	print("about:hide()")
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then 

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	print("about:destroy()")
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene