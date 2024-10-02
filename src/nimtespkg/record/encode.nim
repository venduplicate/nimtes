import std/json
import constants,types

proc `%`*(tes:TES3Record):JsonNode = 
    result = newJObject()

    case tes.kind:
        of ACTI: discard
        of ALCH: discard
        of APPA: discard
        of ARMO: discard
        of BODY: discard
        of BOOK: discard
        of BSGN: discard
        of CELL: discard
        of CLAS: discard
        of CLOT: discard
        of CONT: discard
        of CREA: discard
        of DIAL: discard
        of DOOR: discard
        of ENCH: discard
        of FACT: discard
        of GLOB: discard
        of GMST: discard
        of INFO: discard
        of INGR: discard
        of LAND: discard
        of LEVC: discard
        of LEVI: discard
        of LIGH: discard
        of LOCK: discard
        of LTEX: discard
        of MGEF: discard
        of MISC: discard
        of NPC: discard
        of PGRD: discard
        of PROB: discard
        of RACE: discard
        of REGN: discard
        of REPA: discard
        of SCPT: discard
        of SKIL: discard
        of SNDG: discard
        of SOUN: discard
        of SPEL: discard
        of SSCR: discard
        of STAT: discard
        of TES3: discard
        of WEAP: discard