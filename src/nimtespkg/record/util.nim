import std/[unicode]
from strutils import strip

const NULLRUNE* = toRunes("\u0000")

type
     TagError* = object of AssertionDefect

proc stripEverything*(s: string): string =
     result = strutils.strip(unicode.strip(unicode.strip(s, true, true, NULLRUNE)))


