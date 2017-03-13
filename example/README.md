# Fightboats Example Code

Here's my implementation of a Battleships game. It's quite messy and probably a bit ugly but might give you some ideas for Ruby programming in future.
The code for doing visuals is particularly offensive.

## Running the game

To start a new game, run:

    ruby -Ilib -rgame -e 'Game.new'

To start a prepared game, where all the ships have already been placed for both players, run:

    ruby -Ilib -rgame -e 'Game.prepared'
