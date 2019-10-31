import unittest

include mazepkg/dig

proc genMaze(w, h: int): Maze =
  result.width = w
  result.height = h
  result.stage = newSeqWith(h, newSeqWith(w, wall))

suite "setRoadFrame":
  setup:
    let width = 7
    let height = 5
    var maze = genMaze(width, height)
  test "setRoadFrame":
    maze.setRoadFrame()
    check maze.stage == @[
      @[road, road, road, road, road, road, road, ],
      @[road, wall, wall, wall, wall, wall, road, ],
      @[road, wall, wall, wall, wall, wall, road, ],
      @[road, wall, wall, wall, wall, wall, road, ],
      @[road, road, road, road, road, road, road, ],
      ]

suite "digUp, digLeft, digRight, digDown":
  setup:
    let width = 11
    let height = 11
    var maze = genMaze(width, height)
    maze.setRoadFrame()

  test "digUp":
    check maze.digUp(3, 5) == (x: 3, y: 2)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digUp same pos":
    check maze.digUp(2, 2) == (x: 2, y: 2)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, road, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digLeft":
    check maze.digLeft(3, 5) == (x: 2, y: 5)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, road, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digLeft same pos":
    check maze.digLeft(2, 2) == (x: 2, y: 2)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, road, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digRight":
    check maze.digRight(3, 5) == (x: 8, y: 5)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, road, road, road, road, road, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digRight same pos":
    check maze.digRight(8, 8) == (x: 8, y: 8)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, road, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digDown":
    check maze.digDown(3, 5) == (x: 3, y: 8)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, road, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]
  test "digDown same pos":
    check maze.digDown(8, 8) == (x: 8, y: 8)
    check maze.stage ==
      @[
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, road, wall, road, ],
        @[road, wall, wall, wall, wall, wall, wall, wall, wall, wall, road, ],
        @[road, road, road, road, road, road, road, road, road, road, road, ],
        ]

suite "newStartPos":
  setup:
    let width = 11
    let height = 21
    var maze = genMaze(width, height)
    maze.setRoadFrame()
  test "奇数の位置以外を返却しないことの検証":
    for i in 1..10000:
      let (x, y) = maze.newStartPos()
      check x mod 2 == 0
      check y mod 2 == 0
      check 2 <= x and x < width - 2
      check 2 <= y and y < height - 2
