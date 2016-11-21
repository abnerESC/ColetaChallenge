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
	margemDireita = 50
	margemDireitaEntreObjetos = 100
	dimensoesCores = 30
	dimensoesObjects = 20

	local papel = widget.newButton({
		defaultFile="img/buttons/oval-b.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	papel.x = margemDireita
	papel.y = 70
	papel:setLabel("Papel")

	roloDePapel = display.newImageRect( "img/objects/rolos de papel.png", dimensoesObjects, dimensoesObjects )
	roloDePapel.x, roloDePapel.y = papel.x + margemDireitaEntreObjetos, papel.y

	blocoDeNotas = display.newImageRect( "img/objects/blocos de notas.png", dimensoesObjects, dimensoesObjects )
	blocoDeNotas.x, blocoDeNotas.y = roloDePapel.x + margemDireitaEntreObjetos, papel.y

	local plastico = widget.newButton({
		defaultFile="img/buttons/oval-r.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	plastico.x = margemDireita
	plastico.y = papel.y + proporcaoDistancia
	plastico:setLabel("Plástico")

	copoDeCafe = display.newImageRect( "img/objects/copos de café.png", dimensoesObjects, dimensoesObjects )
	copoDeCafe.x, copoDeCafe.y = plastico.x + margemDireitaEntreObjetos, plastico.y

	coposDePlastico = display.newImageRect( "img/objects/copos de plástico.png", dimensoesObjects, dimensoesObjects )
	coposDePlastico.x, coposDePlastico.y = copoDeCafe.x + margemDireitaEntreObjetos, plastico.y

	local vidro = widget.newButton({
		defaultFile="img/buttons/oval-g.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	vidro.x = margemDireita
	vidro.y = plastico.y + proporcaoDistancia
	vidro:setLabel("Vidro")

	cerveja = display.newImageRect( "img/objects/cervejas.png", dimensoesObjects, dimensoesObjects )
	cerveja.x, cerveja.y = vidro.x + margemDireitaEntreObjetos, vidro.y

	champagne = display.newImageRect( "img/objects/champagnes.png", dimensoesObjects, dimensoesObjects )
	champagne.x, champagne.y = cerveja.x + margemDireitaEntreObjetos, vidro.y

	local metal = widget.newButton({
		defaultFile="img/buttons/oval-y.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	metal.x = margemDireita
	metal.y = vidro.y + proporcaoDistancia
	metal:setLabel("Metal")

	talher = display.newImageRect( "img/objects/talheres.png", dimensoesObjects, dimensoesObjects )
	talher.x, talher.y = metal.x + margemDireitaEntreObjetos, metal.y

	local organico = widget.newButton({
		defaultFile="img/buttons/oval-br.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	organico.x = margemDireita
	organico.y = metal.y + proporcaoDistancia
	organico:setLabel("Orgânico")

	pizza = display.newImageRect( "img/objects/pizzas.png", dimensoesObjects, dimensoesObjects )
	pizza.x, pizza.y = organico.x + margemDireitaEntreObjetos, organico.y

	cascaDeBanana = display.newImageRect( "img/objects/cascas de banana.png", dimensoesObjects, dimensoesObjects )
	cascaDeBanana.x, cascaDeBanana.y = pizza.x + margemDireitaEntreObjetos, organico.y

	local madeira = widget.newButton({
		defaultFile="img/buttons/oval-bl.png",
		width=dimensoesCores, height=dimensoesCores,
		onEvent = nil,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	madeira.x = margemDireita
	madeira.y = organico.y + proporcaoDistancia
	madeira:setLabel("Madeira")

	lapis = display.newImageRect( "img/objects/lápis.png", dimensoesObjects, dimensoesObjects )
	lapis.x, lapis.y = madeira.x + margemDireitaEntreObjetos, madeira.y

	local function onKeyEvent( event )
	    -- Print which key was pressed down/up
	    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
	    print( message )

	    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
	    if ( event.keyName == "back" ) then
	        local platformName = system.getInfo( "platformName" )
	        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
	            return true
	        end
	    end

	    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
	    -- This lets the operating system execute its default handling of the key
	    return false
	end

	-- Add the key event listener
	Runtime:addEventListener( "key", onKeyEvent )
	sceneGroup:insert( papel )
	sceneGroup:insert( madeira )
	sceneGroup:insert( metal )
	sceneGroup:insert( plastico )
	sceneGroup:insert( vidro )
	sceneGroup:insert( organico )
	sceneGroup:insert( pizza )
	sceneGroup:insert( cascaDeBanana )
	sceneGroup:insert( champagne )
	sceneGroup:insert( lapis )
	sceneGroup:insert( roloDePapel )
	sceneGroup:insert( blocoDeNotas )
	sceneGroup:insert( talher )
	sceneGroup:insert( cerveja )
	sceneGroup:insert( copoDeCafe )
	sceneGroup:insert( coposDePlastico )
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

	papel:removeSelf()
	papel = nil
	madeira:removeSelf()
	madeira = nil
	plastico:removeSelf()
	plastico = nil
	vidro:removeSelf()
	vidro = nil
	metal:removeSelf()
	metal = nil
	organico:removeSelf()
	organico = nil

	roloDePapel:removeSelf()
	roloDePapel = nil

	blocoDeNotas:removeSelf()
	blocoDeNotas = nil

	cerveja:removeSelf()
	cerveja = nil

	champagne:removeSelf()
	champagne = nil

	pizza:removeSelf()
	pizza = nil

	cascaDeBanana:removeSelf()
	cascaDeBanana = nil

	lapis:removeSelf()
	lapis = nil

	talher:removeSelf()
	talher = nil

	copoDeCafe:removeSelf()
	copoDeCafe = nil

	coposDePlastico:removeSelf()
	coposDePlastico = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene