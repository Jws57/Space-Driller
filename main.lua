--hides the status bar
display.setStatusBar(display.HiddenStatusBar)

--set the default anchor or registration points
display.setDefault( "anchorX", 0.5)
display.setDefault( "anchorY", 0.5)

--make numbers truly random	
math.randomseed( os.time() )

local physics = require("physics")
physics.start()
physics.setScale(80)--Sets the speed of the falling objects

 w= display.contentWidth
 h= display.contentHeight

local composer = require( "composer" )


require "sqlite3"
--The database file will be created if none is found, and we'll store it in the Documents folder so that we can read from it and write to it. 
local data_path=system.pathForFile("data.db",system.DocumentsDirectory);
db=sqlite3.open(data_path);

--create the database table
local sql= "CREATE TABLE IF NOT EXISTS scores (name,value);"
db:exec(sql);

--Load the Start Scene
composer.gotoScene( "WelcomeScreen" )