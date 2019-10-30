## pole_down is the algorithm to generate a maze.
##
## pole_down は棒倒し法に基づいて迷路を生成するモジュールです。
##
## See also
## ----
##
## * `迷路自動生成アルゴリズム <http://www5d.biglobe.ne.jp/stssk/maze/make.html>`_

import sequtils, strutils, random
import types

proc setFrame(maze: var Maze) =
  ## 一番外の外壁に壁をセット
  # top
  for x, col in maze.stage[0]:
    maze.stage[0][x] = wall
  # left
  for y, row in maze.stage:
    maze.stage[y][0] = wall
  # right
  for y, row in maze.stage:
    maze.stage[y][^1] = wall
  # bottom
  for x, col in maze.stage[^1]:
    maze.stage[^1][x] = wall

proc randPushDown(maze: var Maze, x, y: int, noTop: bool) =
  ## 指定の座標に隣接する上下左右のいずれかのセルに壁をセットする。
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
    let cell = maze.stage[y2][x2]
    if cell != wall:
      maze.stage[y2][x2] = wall
      return

proc newMazeByPoleDown*(width, height: int, randomSeed = true, seed = 0): Maze =
  ## 棒倒し法で迷路を生成する。
  result.width = width
  result.height = height
  result.stage = newSeqWith(height, newSeqWith(width, road))
  result.setFrame()

  # 等間隔の内壁をセット
  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      result.stage[y*2][x*2] = wall

  if randomSeed:
    randomize()
  else:
    randomize(seed)

  # 棒倒しを実施
  for y in 1..<int(height/2):
    for x in 1..<int(width/2):
      let noTop = y != 1 # 最初の一回目だけ上にも倒す
      result.randPushDown(x*2, y*2, noTop)

