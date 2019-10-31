import mazepkg/[pole_down, dig]
export poledown, dig

when isMainModule:
  import parseopt, os, strutils

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
    version = "v0.1.0"
    doc = """maze generates a random maze.

Usage:
    maze -h | --help
    maze -v | --version
    maze [options]

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
          result.width = int(result.width / 2) * 2
        of "height", "H":
          result.height = val.parseInt()
          result.height = int(result.height / 2) * 2
        of "road", "r":
          result.road = val
        of "wall", "w":
          result.wall = val
        of "seed", "s":
          result.useRandomSeed = false
          result.seed = val.parseInt()
          if result.seed == 0:
            echo doc
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
      if opts.printProcess:
        for maze in generatesMazeProcessByPoleDown(opts.width, opts.height, opts.useRandomSeed, opts.seed):
          echo maze.format(opts.road, opts.wall)
          printSeparator()
      else:
        let maze = newMazeByPoleDown(opts.width, opts.height, opts.useRandomSeed, opts.seed)
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
      echo "不正なアルゴリズム指定"
      return 1

  quit main()
