#Walk through a document lexically.
#Todo: Instead of printing @s, print the token kind, in brackets, after every lexeme (not just every entity)
#Hint: understand.Lexeme class

import understand
import sys

def run(db,searchstring):
  file = db.lookup(searchstring,"file")[0]
  print (file)
  for lexeme in file.lexer():
    print (lexeme.text(),end="")
    if lexeme.ent():
      print ("@",end="")
  

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])

  searchstring = ".Web.";
  run(db,searchstring)     