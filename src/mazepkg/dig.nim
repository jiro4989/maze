## dig is the algorithm to generate a maze.
##
## dig は穴掘り法に基づいて迷路を生成するモジュールです。
##
## See also
## ----
##
## * `迷路自動生成アルゴリズム <http://www5d.biglobe.ne.jp/stssk/maze/make.html>`_

import sequtils, strutils, random, strformat
import os

const
  road = 0'u8
  wall = 1'u8

type
  Maze* = object
    stage*: seq[seq[byte]]
    width*, height*: int

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

proc isDiggable(maze: Maze, x, y: int): bool =
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

proc digUp(maze: var Maze, x, y: int): tuple[x, y: int] =
  var y2 = y
  var cell = maze.stage[y2-1][x]
  var cell2 = maze.stage[y2-2][x]
  while cell == wall and cell2 == wall:
    maze.stage[y2-1][x] = road
    dec(y2)
    cell = maze.stage[y2-1][x]
    cell2 = maze.stage[y2-2][x]
  return (x: x, y: y2)

proc digLeft(maze: var Maze, x, y: int): tuple[x, y: int] =
  var x2 = x
  var cell = maze.stage[y][x-1]
  var cell2 = maze.stage[y][x-2]
  while cell == wall and cell2 == wall:
    maze.stage[y][x2-1] = road
    dec(x2)
    cell = maze.stage[y][x2-1]
    cell2 = maze.stage[y][x2-2]
  return (x: x2, y: y)

proc digRight(maze: var Maze, x, y: int): tuple[x, y: int] =
  var x2 = x
  var cell = maze.stage[y][x+1]
  var cell2 = maze.stage[y][x+2]
  while cell == wall and cell2 == wall:
    maze.stage[y][x2+1] = road
    inc(x2)
    cell = maze.stage[y][x2+1]
    cell2 = maze.stage[y][x2+2]
  return (x: x2, y: y)

proc digDown(maze: var Maze, x, y: int): tuple[x, y: int] =
  var y2 = y
  var cell = maze.stage[y2+1][x]
  var cell2 = maze.stage[y2+2][x]
  while cell == wall and cell2 == wall:
    maze.stage[y2+1][x] = road
    inc(y2)
    cell = maze.stage[y2+1][x]
    cell2 = maze.stage[y2+2][x]
  return (x: x, y: y2)

proc randDig(maze: var Maze, x, y: int): tuple[x, y: int] =
  let r = rand(4)
  case r
  of 0:
    # up
    maze.digUp(x, y)
  of 1:
    # left
    maze.digLeft(x, y)
  of 2:
    # right
    maze.digRight(x, y)
  else:
    # down
    maze.digDown(x, y)

proc newStartPos(maze: Maze): tuple[x, y: int] =
  let width = maze.width
  let height = maze.height
  (x: ((width-4)/2).int.rand*2+2, y: ((height-4)/2).int.rand*2+2)

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
  var (x, y) = result.newStartPos()
  while result.isContinuableToDig():
    while result.isDiggable(x, y):
      (x, y) = result.randDig(x, y)
      echo result
      echo &"x:{x}, y:{y}"
      sleep 300
    (x, y) = result.newStartPos()
    let stg = result.stage
    while stg[y][x] != road:
      (x, y) = result.newStartPos()

