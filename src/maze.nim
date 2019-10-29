# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.
#
#
# http://www5d.biglobe.ne.jp/stssk/maze/make.html

import mazepkg/submodule

import sequtils, strutils, random

const
  road = 0'u8
  wall = 1'u8

type
  Maze* = seq[seq[byte]]

proc newEmptyMaze(width, height: int): Maze =
  for y in 0..<height:
    var row: seq[byte]
    for x in 0..<width:
      row.add(road)
    result.add(row)

proc print(self: Maze) =
  for row in self:
    echo row.mapIt(if it == wall: "x" else: " ").join()

proc setFrame(self: var Maze) =
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

proc randPushDown(self: var Maze, x, y: int, noTop: bool) =
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

proc newMazeByPollingPoleDown*(width, height: int): Maze =
  ## 棒倒し法で迷路を生成する。
  result = newEmptyMaze(width, height)
  result.setFrame()

  # 等間隔の内壁をセット
  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      result[y*2][x*2] = wall

  # 棒倒しを実施
  randomize()
  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      let noTop = y != 1 # 最初の一回目だけ上にも倒す
      result.randPushDown(x*2, y*2, noTop)

when isMainModule:
  let
    width = 21
    height = 21
  var maze = newMazeByPollingPoleDown(width, height)
  print(maze)

