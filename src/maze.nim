import mazepkg/[pole_down, dig]
export poledown, dig

when isMainModule:
  import parseopt, os, strutils

  type
    Options = object
      width, height: int
      useRandomSeed: bool
      seed: int
      printProcess: bool
      args: seq[string]

  const
    version = "v0.1.0"
    doc = """maze generates a random maze.

Usage:
    maze -h | --help
    maze -v | --version
    maze [options]

Options:
    -h, --help               print help and exit
    -v, --version            print version and exit
    -W, --width:<WIDTH>      set maze width [default: 40]
    -H, --height:<HEIGHT>    set maze height [default: 40]
    -s, --seed:<SEED>        set random seed. seed must NOT be 0
    -p, --print-process      print generating process
    """

  proc getCmdOpts(params: seq[string]): Options =
    ## コマンドライン引数を解析して返す。
    ## helpとversionが見つかったらテキストを標準出力して早期リターンする。
    var optParser = initOptParser(params)
    result.width = 40
    result.height = 40
    result.useRandomSeed = true

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
        of "seed", "s":
          result.useRandomSeed = false
          result.seed = val.parseInt()
          if result.seed == 0:
            echo doc
            quit 1
        of "print-process", "p":
          result.printProcess = true
      of cmdEnd:
        assert false # cannot happen

  proc main(): int =
    let opts = getCmdOpts(commandLineParams())
    if opts.printProcess:
      discard
    else:
      var maze = newMazeByDigging(opts.width, opts.height, opts.useRandomSeed, opts.seed)
      echo maze.format(" ", "#")

  quit main()

