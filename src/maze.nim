#import mazepkg/pulling_pole_down
import mazepkg/dig

when isMainModule:
  let
    width = 83
    height = 61
  var maze = newMazeByDigging(width, height)
  #echo maze.format(" ", "#")

