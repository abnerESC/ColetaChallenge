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

	randomVectorOfImage = {"champagne","coffee-cup","cutlery", "plastic-cup"}
	customVectorOfImage = {}

	--criando o texto que representará a pontuação
	local potuacao = display.newEmbossedText( "Pontos", screenW/2, 0, 95, 95, native.systemFont, 40 )

	--criando um vetor com as imagens (path das imagens) que vão aparecer na tela
	for i=1,100 do

		if i<7 then
			--a fase terá 6 bananas
			customVectorOfImage[i] = "banana"
		elseif i >= 7 and i < 15 then
			--a fase terá 9 cervejas
			customVectorOfImage[i] = "beer"
		else
			--colocando de forma aleatória
			customVectorOfImage[i] = randomVectorOfImage[math.random(1,4)]
		end
	end
	
	--criando o chão
	local floor = display.newImageRect( "img/screenComponents/floor.png", screenW, 82 )
	floor.name = "floor"
	floor.anchorX = 0
	floor.anchorY = 1
	floor.x, floor.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	--criando a parede esquerda e direita
	local wallLeft = display.newRect( 0,screenH/2, 1, screenH )
	physics.addBody( wallLeft, "static" )
	local wallRight = display.newRect( screenW, screenH/2, 1, screenH )
	physics.addBody( wallRight, "static" )
	
	local floorShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( floor, "static", { friction=0.3, shape=floorShape } )

	--criando a lata de lixo
	local garbage_default = display.newImageRect( "img/screenComponents/recycle_yellow.png", 90, 90 )
	garbage_default.x, garbage_default.y = display.contentCenterX, screenH - floor.height - 90

	--criando formas que vão ser adicionadas a lata de lixo
	--e vão dar a sensação de que os objetos caem dentro dela
	local shapeBottonGarbage = { 45,40,45,45,-45,45,-45,40}
	local shapeRightGarbage = {45,-45,45,40,40,40,40,-45}
	local shapeLeftGarbage = {-40,-45,-40,40,-45,40,-45,-45}

	physics.addBody( garbage_default, "static", { shape = shapeBottonGarbage }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage })

	local score = 0;

	local function onLocalCollision( self, event )

		if ( event.phase == "began" ) then
			if ( event.target.name == "floor" ) then
				score = score - 10
    		else
	        	if ( event.other.name == "banana" or event.other.name == "beer" ) then
	        		score = score + 2
	    		else
	    			score = score + 1
	    		end
			end
    		potuacao:setText(score)
    		event.other:removeSelf()
		elseif ( event.phase == "ended" ) then
		end
	end

	floor.collision = onLocalCollision
	floor:addEventListener("collision")

	garbage_default.collision = onLocalCollision
	garbage_default:addEventListener("collision")

	local function onGlobalCollision( event )

	    if ( event.phase == "began" ) then
	        print( "began: " )

	    elseif ( event.phase == "ended" ) then
	        print( "ended: " )
	    end
	end

	--Runtime:addEventListener( "collision", onGlobalCollision )

	--função que permite mover a lata de lixo pela tela
	function garbage_default:touch( event )

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

	i = 0

	local function myTapListener( event )

		event.target:removeSelf()

		i = i + 1

		if ( i == 1) then
			object = display.newImageRect( "img/screenComponents/recycle_green.png", 90, 90  )
		elseif ( i == 2 ) then
			object = display.newImageRect( "img/screenComponents/recycle_red.png", 90, 90  )
		elseif ( i == 3 ) then
			object = display.newImageRect( "img/screenComponents/recycle_blue.png", 90, 90  )
		elseif ( i == 4 ) then
			object = display.newImageRect( "img/screenComponents/recycle_yellow.png", 90, 90  )
			i = 0
		end
		object.x, object.y = event.target.x, event.target.y

		function object:touch( event )

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

		object:addEventListener( "touch", object )
		object:addEventListener( "tap", myTapListener )
		object.collision = onLocalCollision
		object:addEventListener("collision")

		physics.addBody( object, "static", { shape = shapeBottonGarbage }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage })
	    sceneGroup:insert( object )
	    return true
	end

	garbage_default:addEventListener( "touch", garbage_default )
	garbage_default:addEventListener( "tap", myTapListener )
	
	--inserindo objetos na tela
	sceneGroup:insert( background )
	sceneGroup:insert( floor)

	--inserindo objetos na tela com base no tempo
	local time = 1000
	local iterations = 0;
	local currentTimer = nil;

	local function createObjectsWithDelay()
      	iterations = iterations + 1

      	image = customVectorOfImage[iterations]

      	imagePath = "img/objects/" .. image .. ".png"

      	local object = display.newImageRect( imagePath, 45, 45 )
      	object.name = image
      	--os objetos estão sendo inseridos em lugares aleatórios da tela
		object.x, object.y = math.random(object.width/2, display.actualContentWidth - object.width/2), -100
		--aumentando a gravidade gradativamente
		physics.setGravity(0,9.8 + iterations*0.2)
		physics.addBody( object, { density=9.0, friction=1.0, bounce=0.3 } )
		sceneGroup:insert( object )

      	if (iterations < 100) then
           currentTimer = timer.performWithDelay(time, createObjectsWithDelay);
      	end
	end

	currentTimer = timer.performWithDelay(time, createObjectsWithDelay);

	sceneGroup:insert( garbage_default )
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