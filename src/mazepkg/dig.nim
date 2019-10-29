## dig is the algorithm to generate a maze.
##
## dig は穴掘り法に基づいて迷路を生成するモジュールです。
##
## See also
## ----
##
## * `迷路自動生成アルゴリズム <http://www5d.biglobe.ne.jp/stssk/maze/make.html>`_

import sequtils, strutils, random

const
  road = 0'u8
  wall = 1'u8

type
  Maze* = seq[seq[byte]]

proc newMazeWithFilledWall(width, height: int): Maze =
  for y in 0..<height:
    var row: seq[byte]
    for x in 0..<width:
      row.add(wall)
    result.add(row)

proc setRoadFrame(self: var Maze) =
  ## 一番外の外壁に道をセット
  # top
  for x, col in self[0]:
    self[0][x] = road
  # left
  for y, row in self:
    self[y][0] = road
  # right
  for y, row in self:
    self[y][^1] = road
  # bottom
  for x, col in self[^1]:
    self[^1][x] = road

proc randDig(self: var Maze, x, y: int) =
  let r = rand(4)
  var x2, y2: int
  var x3, y3: int
  case r
  of 0:
    # top
    x2 = x
    x3 = x
    y2 = y - 1
    y3 = y - 1
  of 1:
    # left
    x2 = x - 1
    x3 = x - 1
    y2 = y
    y3 = y
  of 2:
    # right
    x2 = x + 1
    x3 = x + 1
    y2 = y
    y3 = y
  else:
    # buttom
    x2 = x
    x3 = x
    y2 = y + 1
    y3 = y + 1
  let cell = self[y2][x2]
  let cell2 = self[y3][x3]
  if cell == wall and cell2 == wall:
    self[y2][x2] = road

proc isDiggable(self: Maze, x, y: int): bool =
  # top
  if self[y-1][x] == wall and self[y-2][x] == wall:
    return true
  # left
  if self[y][x-1] == wall and self[2][x-2] == wall:
    return true
  # right
  if self[y][x+1] == wall and self[2][x+2] == wall:
    return true
  # buttom
  if self[y+1][x] == wall and self[y+2][x] == wall:
    return true
  return false

proc newMazeByDigging*(width, height: int): Maze =
  ## 穴掘り法で迷路を生成する。
  result = newMazeWithFilledWall(width, height)
  result.setRoadFrame()
  # ランダムに一箇所点を選ぶ。
  # 選んだ点が壁にならないようにする。
  randomize()
  let startX = rand(width-4) + 2
  let startY = rand(height-4) + 2
