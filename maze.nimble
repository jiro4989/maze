# Package

version       = "1.0.1"
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
  rmDir "docs"
  exec "nimble doc --project --index:on -o:docs src/maze.nim"

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
