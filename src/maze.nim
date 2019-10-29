# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.
#
#
# http://www5d.biglobe.ne.jp/stssk/maze/make.html

import mazepkg/submodule

import sequtils, strutils, random

const
  width = 21
  height = 21
  road = 0'u8
  wall = 1'u8

type
  Stage = array[height, array[width, byte]]

var
  stage: Stage

proc print(self: Stage) =
  for row in self:
    echo row.mapIt(if it == wall: "x" else: " ").join()

proc setFrame(self: var Stage) =
  # top
  for x, col in self[0]:
    self[0][x] = wall
  # left
  for y, row in self:
    self[y][0] = wall
  # right
  for y, row in self:
    self[y][^1] = wall
  # bottom
  for x, col in self[^1]:
    self[^1][x] = wall

proc randPushDown(self: var Stage, x, y: int, noTop: bool) =
  while true:
    let r = rand(4)
    var x2, y2: int
    case r
    of 0:
      # top
      if noTop:
        continue
      x2 = x
      y2 = y - 1
    of 1:
      # left
      x2 = x - 1
      y2 = y
    of 2:
      # right
      x2 = x + 1
      y2 = y
    else:
      # buttom
      x2 = x
      y2 = y + 1
    let cell = self[y2][x2]
    if cell != wall:
      self[y2][x2] = wall
      return

when isMainModule:
  randomize()
  print(stage)
  echo "-------"
  setFrame(stage)
  print(stage)
  echo "-------"
  # 等間隔の内壁をセット
  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      stage[y*2][x*2] = wall
  echo "-------"
  print(stage)

  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      let noTop = y != 1 # 最初の一回の時以外は上に倒さない
      stage.randPushDown(x*2, y*2, noTop)
  echo "-------"
  print(stage)

