# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import nimtespkg/record/[record,enums]
import std/json


when isMainModule:
   
   let plugin = readPlugin("Morrowind.esm")

   let file = open("Morrowind.json",fmWrite)

   file.write(%*plugin)
   #file.write(%*plugin.dialogue)
   #file.write(%*plugin.doors)
   #file.write(%*plugin.enchantments)
   #file.write(%*plugin.factions)
   #file.write(%*plugin.globals)

  

