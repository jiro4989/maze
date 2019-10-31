## types defines `maze` types.

from strutils import join
from sequtils import mapIT

const
  road* = 0'u8
  wall* = 1'u8

type
  Maze* = object
    stage*: seq[seq[byte]]
    width*, height*: int

proc format*(maze: Maze, r, w: string): string =
  ## Returns a string rectangle that replaced `stage` with `r` and `w`.
  ## Replaces `road` to `r`. Replace `wall` to `w`.
  ##
  ## **Japanese:**
  ##
  ## `stage` のbyte値を `r` と `w` で置換して返却する。
  var rows: seq[string]
  for row in maze.stage:
    rows.add(row.mapIt(if it == road: r else: w).join())
  result = rows.join("\n")

proc `$`*(self: Maze): string =
  var rows: seq[string]
  for row in self.stage:
    rows.add(row.mapIt($it).join())
  result = rows.join("\n")

