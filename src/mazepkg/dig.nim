## dig is the algorithm to generate a maze.
##
## dig は穴掘り法に基づいて迷路を生成するモジュールです。
##
## See also
## ----
##
## * `迷路自動生成アルゴリズム <http://www5d.biglobe.ne.jp/stssk/maze/make.html>`_

import sequtils, strutils, random
import os

const
  road = 0'u8
  wall = 1'u8

type
  Maze* = object
    stage*: seq[seq[byte]]
    width*, height*: int
  Pos = object
    x, y: int

proc `$`*(self: Maze): string =
  var rows: seq[string]
  for row in self.stage:
    rows.add(row.mapIt($it).join())
  result = rows.join("\n")

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
    maze.stage[0][x] = road
  # left
  for y, row in stage:
    maze.stage[y][0] = road
  # right
  for y, row in stage:
    maze.stage[y][^1] = road
  # bottom
  for x, col in stage[^1]:
    maze.stage[^1][x] = road

proc randDig(maze: var Maze, pos: Pos): Pos =
  let x = pos.x
  let y = pos.y
  let r = rand(4)
  var x2, y2: int
  var x3, y3: int
  case r
  of 0:
    # top
    x2 = x
    x3 = x
    y2 = y - 1
    y3 = y - 2
  of 1:
    # left
    x2 = x - 1
    x3 = x - 2
    y2 = y
    y3 = y
  of 2:
    # right
    x2 = x + 1
    x3 = x + 2
    y2 = y
    y3 = y
  else:
    # buttom
    x2 = x
    x3 = x
    y2 = y + 1
    y3 = y + 2
  let stage = maze.stage
  let cell = stage[y2][x2]
  let cell2 = stage[y3][x3]
  if cell == wall and cell2 == wall:
    maze.stage[y2][x2] = road
    result.x = x2
    result.y = y2

proc isDiggable(maze: Maze, pos: Pos): bool =
  let x = pos.x
  let y = pos.y
  let stage = maze.stage
  # top
  if stage[y-1][x] == wall and stage[y-2][x] == wall:
    return true
  # left
  if stage[y][x-1] == wall and stage[y][x-2] == wall:
    return true
  # right
  if stage[y][x+1] == wall and stage[y][x+2] == wall:
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
      if maze.isDiggable(Pos(x: x, y: y)):
        return true

proc digging(maze: var Maze, pos: Pos) =
  var p = pos
  while maze.isDiggable(p):
    # FIXME: ここ実装勘違いしてた
    p = maze.randDig(p)
    var zero: Pos
    if p == zero:
      return
    echo maze
    echo $p.x & "-" & $p.y
    sleep 300

proc newMazeByDigging*(width, height: int): Maze =
  ## 穴掘り法で迷路を生成する。
  result = newMazeWithFilledWall(width, height)
  result.setRoadFrame()
  # ランダムに一箇所点を選ぶ。
  # 選んだ点が壁にならないようにする。
  randomize()
  while result.isContinuableToDig():
    var pos = result.newStartPos()
    if pos.x mod 2 == 1 or pos.y mod 2 == 1:
      continue
    result.digging(pos)

