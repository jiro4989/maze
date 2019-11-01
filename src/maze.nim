## maze is a module to generate maze.
## You can select algorithm to generate maze.
##
## pole down algorithm
## -------------------
##

runnableExamples:
  import maze
  ## width and height must be odd.
  var m = newMazeByPoleDown(19, 19)
  echo m.format(" ", "#")

## digging algorithm
## -----------------
##

runnableExamples:
  import maze
  var m = newMazeByDigging(20, 20)
  echo m.format(" ", "#")

import mazepkg/[pole_down, dig]
export poledown, dig

when isMainModule:
  import parseopt, logging
  from os import commandLineParams
  from strutils import parseInt
  from strformat import `&`

  type
    Options = object
      width, height: int
      road, wall: string
      useRandomSeed: bool
      seed: int
      printProcess: bool
      algorithm: string
      noSeparator: bool
      args: seq[string]

  const
    appName = "maze"
    version = &"""{appName} version 1.0.1
Copyright (c) 2019 jiro4989
Released under the MIT License.
https://github.com/jiro4989/maze"""

    doc = &"""{appName} generates a random maze.

Usage:
    {appName} -h | --help
    {appName} -v | --version
    {appName} [options]

Examples:
    {appName}
    {appName} -W:65 -H:43
    {appName} -r:- -w:0
    {appName} -a:poledown
    {appName} -p

Options:
    -h, --help                     print help and exit
    -v, --version                  print version and exit
    -W, --width:<WIDTH>            set maze width [default: 41]
    -H, --height:<HEIGHT>          set maze height [default: 41]
    -r, --road:<ROAD>              set road character [default: " "]
    -w, --wall:<WALL>              set all character [default: "#"]
    -s, --seed:<SEED>              set random seed. seed must NOT be 0
    -p, --print-process            print generating process
    -a, --algorithm:<ALGORITHM>    set algorithm to generate maze [default: dig]
                                   selectable algorithm is [poledown | dig]
    -n, --no-separator             NOT print separators when '--print-process'
                                   option was on
    """

  var logger = newConsoleLogger(fmtStr = verboseFmtStr, useStderr = true)
  addHandler(logger)

  proc getCmdOpts(params: seq[string]): Options =
    ## コマンドライン引数を解析して返す。
    ## helpとversionが見つかったらテキストを標準出力して早期リターンする。
    var optParser = initOptParser(params)
    result.width = 41
    result.height = 41
    result.road = " "
    result.wall = "#"
    result.useRandomSeed = true
    result.algorithm = "dig"

    for kind, key, val in optParser.getopt():
      case kind
      of cmdArgument:
        result.args.add(key)
      of cmdLongOption, cmdShortOption:
        case key
        of "help", "h":
          echo doc
          quit 0
        of "version", "v":
          echo version
          quit 0
        of "width", "W":
          result.width = val.parseInt()
        of "height", "H":
          result.height = val.parseInt()
        of "road", "r":
          result.road = val
        of "wall", "w":
          result.wall = val
        of "seed", "s":
          result.useRandomSeed = false
          result.seed = val.parseInt()
          if result.seed == 0:
            error "seed must NOT be 0. see help (--help)"
            quit 1
        of "print-process", "p":
          result.printProcess = true
        of "algorithm", "a":
          result.algorithm = val
        of "no-separator", "n":
          result.noSeparator = true
      of cmdEnd:
        assert false # cannot happen

  proc main(): int =
    let opts = getCmdOpts(commandLineParams())

    template printSeparator =
      if not opts.noSeparator:
        echo "-----"

    template printPoleDownMaze =
      # 棒倒し方は奇数幅でないといけない
      let width = int(opts.width / 2) * 2 + 1
      let height = int(opts.height / 2) * 2 + 1
      if opts.printProcess:
        for maze in generatesMazeProcessByPoleDown(width, height, opts.useRandomSeed, opts.seed):
          echo maze.format(opts.road, opts.wall)
          printSeparator()
      else:
        let maze = newMazeByPoleDown(width, height, opts.useRandomSeed, opts.seed)
        echo maze.format(opts.road, opts.wall)

    template printDigMaze =
      if opts.printProcess:
        for maze in generatesMazeProcessByDigging(opts.width, opts.height, opts.useRandomSeed, opts.seed):
          echo maze.format(opts.road, opts.wall)
          printSeparator()
      else:
        let maze = newMazeByDigging(opts.width, opts.height, opts.useRandomSeed, opts.seed)
        echo maze.format(opts.road, opts.wall)

    case opts.algorithm
    of "poledown":
      printPoleDownMaze()
    of "dig":
      printDigMaze()
    else:
      error &"illegal algorithm. (algorithm = {opts.algorithm})"
      return 1

  quit main()
