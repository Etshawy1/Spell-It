@echo off
If not exist main.asm echo File Does Not Exist
If not exist main.asm goto end

If exist main.obj erase main.obj
If exist main.exe erase main.exe
If exist main.lst erase main.lst

If exist MDAT.obj erase MDAT.obj
If exist MDAT.exe erase MDAT.exe
If exist MDAT.exe erase MDAT.lst

If exist sound.obj erase sound.obj
If exist sound.exe erase sound.exe
If exist sound.exe erase sound.lst



masm MDAT,MDAT,MDAT ;
If not exist MDAT.obj goto end



masm main,main,main ;
If not exist main.obj goto end

masm sound,sound,sound ;
If not exist sound.obj goto end

link  main.obj + mdat.obj + sound.obj, game;
If not exist game.exe goto end

game.exe


:end