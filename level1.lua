-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.pause()

	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

	randomVectorOfImage = {"img/champagne.png","img/coffee-cup.png","img/cutlery.png", "img/plastic-cup.png"}
	customVectorOfImage = {}

	--criando um vetor com as imagens (path das imagens) que vão aparecer na tela
	for i=1,100 do
		if i<7 then
			--a fase terá 6 bananas
			customVectorOfImage[i] = "img/banana.png"
			print(customVectorOfImage[i])
		elseif i >= 7 and i < 15 then
			--a fase terá 9 cervejas
			customVectorOfImage[i] = "img/beer.png"
			print(customVectorOfImage[i])
		else
			--colocando de forma aleatória
			customVectorOfImage[i] = randomVectorOfImage[math.random(1,4)]
			print(customVectorOfImage[i])
		end
	end
	
	--criando o chão
	local wall = display.newImageRect( "img/wall_botton.png", screenW, 82 )
	wall.anchorX = 0
	wall.anchorY = 1
	wall.x, wall.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	local wallShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( wall, "static", { friction=0.3, shape=wallShape } )

	--criando a lata de lixo
	local garbage_green = display.newImageRect( "img/garbage.png", 90, 90 )
	garbage_green.x, garbage_green.y = display.contentCenterX, screenH - wall.height - 90
	physics.addBody( garbage_green, "static")

	--função que permite mover a lata de lixo pela tela
	function garbage_green:touch( event )
	    if event.phase == "began" then
		
	        self.markX = self.x
	        self.markY = self.y
		
	    elseif event.phase == "moved" then
		
	        local x = (event.x - event.xStart) + self.markX
	        local y = (event.y - event.yStart) + self.markY
	        
	        self.x, self.y = x, y
	    end
	    
	    return true
	end

	garbage_green:addEventListener( "touch", garbage_green )
	
	--inserindo objetos na tela
	sceneGroup:insert( background )
	sceneGroup:insert( wall)

	local function createObjectsWithDelay( iteration )
		if iteration < 100 then
			local object = display.newImageRect( customVectorOfImage[iteration], 45, 45 )
			object.x, object.y = 0, 0
			physics.addBody( object, { density=1.0, friction=0.3, bounce=0.3 } )
			sceneGroup:insert( object )

			timer.performWithDelay(1000, createObjectsWithDelay(iteration+1))
		end
	end

	timer.performWithDelay(5000, print("teste"))

	createObjectsWithDelay(1)
	sceneGroup:insert( garbage_green )
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

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene