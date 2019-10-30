#import mazepkg/pulling_pole_down
import mazepkg/dig

when isMainModule:
  let
    width = 43
    height = 41
  var maze = newMazeByDigging(width, height)
  #echo maze.format(" ", "#")

