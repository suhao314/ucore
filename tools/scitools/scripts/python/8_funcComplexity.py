#List all functions and their Cyclomatic Complexity
#Todo: Include the file where each function is defined
#Hint: The function definition is a "definein, declarein body" reference kind. Get the reference, and 
#      then find the file that reference occurs in.

import understand
import sys
import re

def file(ent):
  defRef = ent.ref("definein, declarin body")
  if defRef:
    return defRef.file

def funcComplexity():
  for func in db.ents("function,method,procedure"):
    if func.library != "Standard":
      metric = func.metric(("Cyclomatic",))
      if metric["Cyclomatic"] is not None:
        print (func.name()," = ",metric["Cyclomatic"],sep="")

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])
  funcComplexity()      