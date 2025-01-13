# wordle-resolver

## Overview
wordle game is a fun way to not only practice vocabulary in English but also to work with
text streams in terminal and practice some important gnu utilities like awk sed grep etc...
So I thought it may be fun to write a script in bash to do so and here it is!!
By the way if you're interested in wordle game itself you can visit https://www.nytimes.com/games/wordle/index.html as I did!

## How it works 
Since wordle is a game based on guess/feedback we can do the same in this script you can run the script via bash.
The scrpt uses the file /usr/share/dict/words as its source dictionary which is available in most linux distros!
The scipts gives you a 5-letter word as a suggestion and you provide the 5-letter feedback to it using stdin:
character '*' to indicate that is right letter in the right place
character '+' to indicate that the letter exist in the word but not where it already placed
character '-' to indicate that the provided character does exist at all

Based on what you feddbacked to the script, it will extract some rules and restrict the search zone to get 
close to the final answer

![Screenshot from 2025-01-13 12-08-23](https://github.com/user-attachments/assets/68067718-80bb-403a-a48f-0dd0d6f6244c)

for exmaple in this situation the real word to guess was "cloak" and the first suggestion of script was "seize"
so I provided the feedback "-----" which means non of the letters were true so script assume this as a rule and 
exclude letters with s,e,i,z letters to restrict the the search zone and on that new search zone select a random 
word and provide it and recieves feddback again to restrict the zone again and so on ... to finally get to the 
right answer in the above example it needed 4 tries to extract the rtules and apply them so finally it rreaches the 
right answer in the 5th try. The code base was written by ChatGPT with some modifications to bring it in my way!
Feel free to play and report any issues and also have fun!
