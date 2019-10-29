import mazepkg/pulling_pole_down

when isMainModule:
  let
    width = 21
    height = 21
  var maze = newMazeByPollingPoleDown(width, height)
  echo maze.format(" ", "#")

