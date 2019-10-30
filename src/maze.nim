import mazepkg/[pole_down, dig]
export poledown, dig

when isMainModule:
  let
    width = 43
    height = 41
  var maze = newMazeByDigging(width, height)
  #echo maze.format(" ", "#")

