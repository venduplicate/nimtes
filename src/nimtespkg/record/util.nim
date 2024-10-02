import std/[unicode]
from strutils import strip
import enums

const NULLRUNE* = toRunes("\u0000")

type
     TagError* = object of AssertionDefect


proc stripEverything*(s: string): string =
     result = strutils.strip(unicode.strip(unicode.strip(s, true, true, NULLRUNE)))

proc toRecordFlags*(v:uint32): RecordFlags =
     case v:
          of 0x0020: result = Deleted
          of 0x0400: result = Persistent
          of 0x0800: result = InitiallyDisabled
          of 0x2000: result = Blocked
          else: result = None

