#import mazepkg/pulling_pole_down
import mazepkg/dig

when isMainModule:
  let
    width = 21
    height = 21
  var maze = newMazeByDigging(width, height)
  #echo maze.format(" ", "#")

