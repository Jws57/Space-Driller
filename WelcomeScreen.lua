

local composer = require( "composer" )
local scene = composer.newScene()

-- used to start the game 
local startButton
local theTextField



function scene:create( event )
    local group = self.view
	--Creates new game button
    startButton = display.newImage("new_game_btn.png",display.contentCenterX,display.contentCenterY+100)
    group:insert(startButton)
	CreatepulsatingText()
    
end


function scene:show( event )
	
    local phase = event.phase-- to check which phase the show method is in.
    local previousScene = composer.getSceneName( "previous" )
    if(previousScene~=nil) then--we checks to see if there is a previous scene and, if so, removes it
        composer.removeScene(previousScene)
    end
   if ( phase == "did" ) then
       startButton:addEventListener("tap",startGame)--adds a tap listener to the startButton that calls the startGame function
   end
   
end


--remove listeners 
function scene:hide( event )
    local phase = event.phase
    if ( phase == "will" ) then
        startButton:removeEventListener("tap",startGame)
		Runtime:removeEventListener("enterFrame", starGenerator)
		transition.cancel(theTextField)
		
    end
	
	
	
end

function scene:destroy( event )
	local sceneGroup = self.view
-- any code placed here will run as the scene is being removed. Remove display objects, set variables to nil, etc.


end

--Displays Pulsating Text
function CreatepulsatingText()
	theTextField = display.newText("Space Driller",w/2,h/3,"arial",30)
    transition.to( theTextField, { xScale=4.0, yScale=4.0, time=1500, iterations = -1} )
	scene.view:insert(theTextField)
end

-- take us to the gamelevel scene.
function startGame()
    composer.gotoScene("Level_1")
end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 

return scene