#Save Call Graphs of Function in Working Directory
#Todo: Print exactly 5 levels of the call tree and change the spacing to compact
#Hint: Get the exact name for the "options" by right clicking on the graph in the GUI.

import understand
import sys

def drawCallGraphs(db):
  func = db.ents("function,method,procedure")[0]
  file = "callsPY_" + func.name() + ".png"
  print (func.longname(),"->",file)
  try:
    func.draw("Calls",file)
  except understand.UnderstandError as err:
    print("Error: {0}".format(err))
  

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])
  drawCallGraphs(db)     