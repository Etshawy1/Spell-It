# Spell-It

assembly x86 game to teach the spelling of some basic words for kids in a fun way.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

you just need to download the **dosbox** version suitable for your machine from here. 

[![alt text](https://upload.wikimedia.org/wikipedia/commons/d/dd/DOSBox_icon.png "dosbox")](https://www.dosbox.com/download.php?main=1 "dosbox")



### Installing

to open the game, open the dosbox and type those commands:

```
mount C "full path of the code between those quotation marks"
C:
game.exe
```

in case you wanted to build the game from the code type in the dosbox thos commands
```
mount C "full path of the code between those quotation marks"
C:
build
```
*build is a batch written to masm and link the necessary files and run the game altogether*

## Playing the game

```
left click with the mouse to choose the desired difficulty.
```
![homepage](./Screenshots/home.PNG)

```
left click with the mouse to choose the desired level.
```
![levels](./Screenshots/levels.PNG)

```
use left and right arrows to move the basket and catch, before time ends, the right falling 
letters in the correct order that forms the word representing the photo. 
when you collect the whole word letters, you win the level and get redirected to choose
another level.
```
![levels](./Screenshots/gameplay.PNG)


*note that completed levels can't be repeated unless you reopen the game*

*the game has sound so to have the full experience you should increase the volume*



## Built With

* [MASM](https://docs.microsoft.com/en-us/cpp/assembler/masm/) 


## Author

* **Muhammad Ahmad Hesham** - *Initial work* - [Etshawy1](https://github.com/Etshawy1)

## License

Licensed under the [MIT License](./License).

## Acknowledgments

* this repo helped me a lot to integrate sound into the game https://github.com/leonardo-ono/Assembly8086SBHardwareLevelDspProgrammingTest

