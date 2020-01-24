@echo off
If not exist main.asm echo main File Does Not Exist
If not exist main.asm goto end

If not exist succ.asm echo succ File Does Not Exist
If not exist succ.asm goto end

If not exist intro.asm echo intro File Does Not Exist
If not exist intro.asm goto end

If not exist cheers.asm echo cheers File Does Not Exist
If not exist cheers.asm goto end

If not exist sad.asm echo sad File Does Not Exist
If not exist sad.asm goto end

If exist game.exe erase game.exe

If exist main.obj erase main.obj
If exist main.exe erase main.exe
If exist main.lst erase main.lst

If exist succ.obj erase succ.obj
If exist succ.exe erase succ.exe
If exist succ.lst erase succ.lst

If exist intro.obj erase intro.obj
If exist intro.exe erase intro.exe
If exist intro.lst erase intro.lst

If exist cheers.obj erase cheers.obj
If exist cheers.exe erase cheers.exe
If exist cheers.exe erase cheers.lst

If exist sad.obj erase sad.obj
If exist sad.exe erase sad.exe
If exist sad.exe erase sad.lst



masm cheers,cheers,cheers ;
If not exist cheers.obj goto end

masm intro, intro, intro;
If not exist cheers.obj goto end

masm sad, sad, sad;
If not exist sad.obj goto end

masm succ, succ, succ;
If not exist succ.obj goto end


masm main,main,main ;
If not exist main.obj goto end


link  main.obj + cheers.obj + intro.obj + sad.obj + succ.obj, game;
If not exist game.exe goto end

game.exe


:end