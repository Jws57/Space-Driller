local composer = require("composer")
local scene = composer.newScene()

local nextLevelButton
local theTextField
function scene:create( event )
    local group = self.view
    nextLevelButton = display.newImage("new_game_btn.png",display.contentCenterX, display.contentCenterY)
    group:insert(nextLevelButton)
	
	CreatepulsatingText()
	CreateMaxScoreText()
 end
 
function scene:show( event )
    local phase = event.phase
    composer.removeScene("Level_1" )
    if ( phase == "did" ) then
      nextLevelButton:addEventListener("tap",startNewGame)
      
    end
end
 
function scene:hide(event )
    local phase = event.phase
    if ( phase == "will" ) then
        
        nextLevelButton:removeEventListener("tap",startNewGame)
		
		transition.cancel(theTextField)
    end
end

 function CreatepulsatingText()
	theTextField = display.newText("Game Over",w/2,h/3,"arial",30)
	theTextField:setFillColor(1,0,0)
    transition.to( theTextField, { xScale=4.0, yScale=4.0, time=1000, iterations = 1} )
	scene.view:insert(theTextField)
end


function CreateMaxScoreText()
 	
	ScoreText = display.newText("Your Score:"..getscorestring("MaxScore"),w/2,h/2+120,"arial",70)
	ScoreText:setFillColor(1,1,0)
	scene.view:insert(ScoreText)
 end
 
 
function getscorestring(name)
    local sql="SELECT * FROM scores WHERE name='"..name.."'";
    local value='';

    for row in db:nrows(sql) do
        value=row.value;
    end    

    return value;
end
 
function startNewGame()
    composer.gotoScene("Level_1")
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
 
return scene