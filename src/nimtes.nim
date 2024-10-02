# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import nimtespkg/record/[record,enums]
import std/macros


when isMainModule:
   echo ""
   dumpAstGen:
      if hasFlag(flag, flags) == true:
        result.add(flag)
   # 87055
   # var file = readPlugin("Morrowind.esm")

   # echo file.activators.len

  

