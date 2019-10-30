import mazepkg/[pole_down, dig]
export poledown, dig

proc main(width = 40, height = 40, randomSeed = true, seed = 0, printProcess = false): int =
  if printProcess:
    discard
  else:
    var maze = newMazeByDigging(width, height, randomSeed, seed)
    echo maze.stage

when isMainModule:
  import cligen
  clCfg.version = "v0.1.0"
  dispatch(main)

