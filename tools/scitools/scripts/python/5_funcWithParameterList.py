#Lists all functions, methods and procedures with their parameters
#Todo: Currently the parameters are strings, get the parameter entities (understand::ent) instead
#Hint: Instead of using the .parameters function, look for the references where the function Declares a parameter
#      func.refs("define, declare body","parameter",1) will return an array of references (understand.Ref) where each
#      Parameter is defined

import understand
import sys

def sortKeyFunc(ent):
  return str.lower(ent.longname())

def funcWithParameter(db):
  ents = db.ents("function,method,procedure")
  for func in sorted(ents,key = sortKeyFunc):
    #If the file is from the Ada Standard library, skip to the next
    if func.library() != "Standard":
      print (func.longname()," - ",func.parameters(),sep="",end="\n")
  

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])
  funcWithParameter(db)      