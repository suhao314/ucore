# Lists all ada packages
# Todo: Print the number of lines in each package
# Hint: Use the CountLine metric
import understand
import sys

def adaPackages(db):
  print ("Standard Packages:")    
  for package in db.ents("Package"):
    if package.library() == "Standard":
      print ("  ",package.longname())

  print ("\nUser Packages:")
  for package in db.ents("Package"):
    if package.library() != "Standard":
      print("  ",package.longname())

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])
  adaPackages(db)    