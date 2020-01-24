@echo off
If not exist main.asm echo File Does Not Exist
If not exist main.asm goto end

If exist main.obj erase main.obj
If exist main.exe erase main.exe
If exist main.lst erase main.lst


If exist sprog.obj erase sprog.obj
If exist sprog.exe erase sprog.exe
If exist sprog.exe erase sprog.lst



masm sprog,sprog,sprog ;
If not exist sprog.obj goto end



masm main,main,main ;
If not exist main.obj goto end


link  main.obj + sprog.obj, game;
If not exist game.exe goto end

game.exe


:end