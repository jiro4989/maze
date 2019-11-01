# Package

version       = "1.0.0"
author        = "jiro4989"
description   = "A command and library to generate mazes"
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

task ci, "Run CI":
  exec "nim -v"
  exec "nimble -v"
  exec "nimble check"
  exec "nimble install -Y"
  exec "nimble test -Y"
  exec "nimble docs -Y"
  exec "nimble build -d:release -Y"
  exec "./bin/maze -h"
  exec "./bin/maze -v"

import strformat

task archive, "Create archived assets":
  let app = "maze"
  let assets = &"{app}_{buildOS}"
  let dir = &"dist/{assets}"
  mkDir &"{dir}/bin"
  cpFile &"bin/{app}", &"{dir}/bin/{app}"
  cpFile "LICENSE", &"{dir}/LICENSE"
  cpFile "README.adoc", &"{dir}/README.adoc"
  withDir "dist":
    exec &"tar czf {assets}.tar.gz {assets}"
