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

--------------------------------------------

-- forward declarations and other locals
local playBtn
local total = 300

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )
	total = 0
	
	return true	-- indicates successful touch
end

local function onAboutBtnRelease()
	composer.gotoScene( "about", "fade", 500 )
	total = 0
	
	return true	-- indicates successful touch
end

local function onLevelBtnRelease()
	composer.gotoScene( "levels", "fade", 500 )
	total = 0
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setDrawMode( "normal" )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "img/menuComponents/background.png", screenW, screenH )
	background.x, background.y = display.screenOriginX, display.screenOriginY
	background.anchorX = 0 
	background.anchorY = 0
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )

	local logo = display.newImageRect( "img/menuComponents/logo.png", 200, 70 )
	logo.x, logo.y = display.contentCenterX, 50

	builder2 = display.newImageRect( "img/menuComponents/builders2.png", screenW, 200 )
	builder2.x, builder2.y = display.contentCenterX, screenH

	builder1 = display.newImageRect( "img/menuComponents/builders1.png", screenW, 200 )
	builder1.x, builder1.y = display.contentCenterX, screenH

	cloud1 = display.newImageRect( "img/menuComponents/cloud1.png", 150, 75 )
	cloud1.x, cloud1.y = logo.x - logo.width / 2, logo.y

	cloud3 = display.newImageRect( "img/menuComponents/cloud3.png", 150, 75 )
	cloud3.x, cloud3.y = logo.x + logo.width / 2, logo.y - 25

	local iteradorBuilder = 0

	local function builderAnimation()

		iteradorBuilder = iteradorBuilder + 1

	 	builder1.y = builder1.y - 1
		print("iteradorBuilder="..iteradorBuilder..", img.y="..builder1.y)
		if (iteradorBuilder < 100) then
			timer.performWithDelay(40, builderAnimation);
		end
	end

	local iteradorBuilder2 = 0

	local function builder2Animation()

		iteradorBuilder2 = iteradorBuilder2 + 1

	 	builder2.y = builder2.y - 1
		print("iteradorBuilder2="..iteradorBuilder2..", img.y="..builder2.y)
		if (iteradorBuilder2 < 100) then
			timer.performWithDelay(0, builder2Animation);
		end
	end

	local iteradorCloud = 0

	local function cloudAnimation()

		iteradorCloud = iteradorCloud + 1

	 	cloud1.x = cloud1.x - 1
	 	cloud3.x = cloud3.x + 1
		if (iteradorCloud < 200) then
			timer.performWithDelay(0, cloudAnimation);
		end
	end

	builderAnimation()
	builder2Animation()
	cloudAnimation()
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "nomejogo.png", 264, 42 )
	--titleLogo.x = display.contentCenterX
	--titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	local play = widget.newButton({
		defaultFile="img/menuComponents/play.png",
		width=100, height=100,
		onEvent = onPlayBtnRelease
	})
	play.x = display.contentCenterX
	play.y = display.contentCenterY

	local fases = widget.newButton({
		defaultFile="img/menuComponents/list.png",
		width=50, height=50,
		onEvent = nil
	})
	fases.x = display.contentCenterX + 100
	fases.y = display.contentCenterY

	local sobre = widget.newButton({
		defaultFile="img/menuComponents/about.png",
		width=50, height=50,
		onEvent = nil
	})
	sobre.x = display.contentCenterX - 100
	sobre.y = display.contentCenterY
	
	sceneGroup:insert( logo )
	sceneGroup:insert( cloud1 )
	sceneGroup:insert( cloud3 )
	sceneGroup:insert( builder2 )
	sceneGroup:insert( builder1 )

	------------------------------------------------------------

	local customVectorOfImage = {"champagne","copo de café","talheres", "copo de plástico"}
	local time = 2000
	local iterations = 0;
	local currentTimer = nil;

	timer.performWithDelay(0, createObjectsWithDelay);

	local function createObjectsWithDelay()
      	iterations = iterations + 1

      	image = customVectorOfImage[math.random(1,#customVectorOfImage)]

      	imagePath = "img/objects/" .. image .. ".png"

      	local object = display.newImageRect( imagePath, 15, 15 )

      	--os objetos estão sendo inseridos em lugares aleatórios da tela
		object.x, object.y = math.random(object.width/2, display.actualContentWidth - object.width/2), -45
		--aumentando a gravidade gradativamente
		physics.setGravity(0, 2 + iterations*0,2)
		physics.addBody( object, { density=9.0, friction=1.0, bounce=0.3 } )
		sceneGroup:insert( object )
		if (iterations < total) then
			timer.performWithDelay(time, createObjectsWithDelay);
		end
	end
	createObjectsWithDelay()
	--sceneGroup:insert( titleLogo )
	sceneGroup:insert( play )
	sceneGroup:insert( fases )
	sceneGroup:insert( sobre )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene