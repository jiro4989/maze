# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["maze"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.0.2"

task docs, "Generate documents":
  exec "nimble doc src/mazepkg/types.nim -o:docs/types.html"
  exec "nimble doc src/mazepkg/dig.nim -o:docs/dig.html"
  exec "nimble doc src/mazepkg/pole_down.nim -o:docs/pole_down.html"
  exec "nimble doc src/maze.nim -o:docs/maze.html"
