#Display the Info Browser for a search string
#Todo: Instead of using the search string, show the info browser for the most complex function
#Hint: The"cyclomatic" complexity metric is the most common way to measure complexity, and the sorted
#      function can take a function argument to call for each comparison, like key = func 

import understand
import sys

def sortKeyFunc(ent):
  return str.lower(ent.longname())

def run(db,searchstring):
  list = []
  ents = db.lookup(searchstring,"function,method,procedure")
  for func in sorted(ents,key = sortKeyFunc):
    #If the file is from the Ada Standard library, skip to the next
    if func.library() != "Standard":
      list.append(func)
  for line in list[-1].ib():
    print (line,end="")
  print ("\n",end="")
  

if __name__ == '__main__':
  # Open Database
  searchstring = ".*Test.*"
  args = sys.argv
  db = understand.open(args[1])
  run(db,searchstring)     