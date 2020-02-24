#Display all project-level metrics
#Todo: Instead of all metrics, return the Lines of Code and Total lines, and the comment to code ratio
#Hint: ("CountLineCode","CountLine","RatioCommentToCode");

import understand
import sys

def projectMetrics(db):
  metrics = db.metric(db.metrics())
  for k,v in sorted(metrics.items()):
    print (k,"=",v)
  print ("For metric details see: http://www.scitools.com/documents/metrics.php")
  

if __name__ == '__main__':
  # Open Database
  args = sys.argv
  db = understand.open(args[1])
  projectMetrics(db)      