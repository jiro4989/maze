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
  Maze* = object
    stage*: seq[seq[byte]]
    width*, height*: int
  Pos = object
    x, y: int

proc newMazeWithFilledWall(width, height: int): Maze =
  result.width = width
  result.height = height
  for y in 0..<height:
    var row: seq[byte]
    for x in 0..<width:
      row.add(wall)
    result.stage.add(row)

proc setRoadFrame(maze: var Maze) =
  ## 一番外の外壁に道をセット
  # top
  let stage = maze.stage
  for x, col in stage[0]:
    stage[0][x] = road
  # left
  for y, row in stage:
    stage[y][0] = road
  # right
  for y, row in stage:
    stage[y][^1] = road
  # bottom
  for x, col in stage[^1]:
    stage[^1][x] = road

proc randDig(maze: var Maze, x, y: int) =
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
  let stage = maze.stage
  let cell = stage[y2][x2]
  let cell2 = stage[y3][x3]
  if cell == wall and cell2 == wall:
    maze.stage[y2][x2] = road

proc isDiggable(maze: Maze, x, y: int): bool =
  let stage = maze.stage
  # top
  if stage[y-1][x] == wall and stage[y-2][x] == wall:
    return true
  # left
  if stage[y][x-1] == wall and stage[2][x-2] == wall:
    return true
  # right
  if stage[y][x+1] == wall and stage[2][x+2] == wall:
    return true
  # buttom
  if stage[y+1][x] == wall and stage[y+2][x] == wall:
    return true
  return false

proc newStartPos(maze: Maze): Pos =
  let width = maze.width
  let height = maze.height
  result.x = rand(width-4) + 2
  result.y = rand(height-4) + 2

proc isContinuableToDig(maze: Maze): bool =
  ## 配置可能な全て載せるのdiggableをチェック
  for y in 2..<maze.height-2:
    for x in 2..<maze.width-2:
      if maze.isDiggable(x, y):
        return true

proc newMazeByDigging*(width, height: int): Maze =
  ## 穴掘り法で迷路を生成する。
  result = newMazeWithFilledWall(width, height)
  result.setRoadFrame()
  # ランダムに一箇所点を選ぶ。
  # 選んだ点が壁にならないようにする。
  randomize()
  while result.isContinuableToDig():
    var pos = result.newStartPos()
    break
