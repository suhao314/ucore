""" Provides some classes and functions for use with understand dependencies """
import understand


class depTreeNode:
  """ A subunit for depTree
  
  A node stores an understand.Ent item (item), the nodes that are it's
  children (children), and all the children beneath it (allchildren)
  it's parent (parent), all the references that go through it (ref)
  and it's level (level -- used for printing indents) It has the 
  following methods:
    __init__(self,item,parent=None,ref=None)
    __eq__(A,B)
    printSelf(self)
    addChild(self,child) """
  item = None        # The item in the node
  children = None    # The immediate children
  allchildren = None # All children beneath this node
  ref = None         # The reference(s) that caused this entity to be in the tree
                     # This may be nothing if it is a file used as a key.
  level =0           # The depth in the tree (used for printing)
  parent = None      # It's parent in the tree
  def __init__(self,item,parent=None,ref=None):
    self.item = item
    self.children = list()
    self.allchildren = list()
    self.ref = list()
    if ref:
      self.ref.append(ref)
    if parent:
      self.level = parent.level + 1
      self.parent = parent
  def printSelf(self):
    """ Print this node and all it's children """
    if type(self.item) == understand.Ent:
      print (self.level * "  "+self.item.kindname() +">",str(self.item),end="",)
    if len(self.ref):
      print("(" + str(len(self.ref)) +")")
    else:
      print()
    for ref in self.ref:
      if ref.ent() == self.item:
        kind = ref.kindname() + "s"
        print ((self.level +1) * "  "+str(ref.scope()),kind, ref.ent(), "at", ref.file(), ":", ref.line())
    for child in self.children:
      child.printSelf()
  def __eq__(A,B):
    """ Equality is determined by item, so A.item == B.item"""
    if type(A) == depTreeNode and type(B) == depTreeNode:
      return A.item == B.item 
    elif type(A) == depTreeNode:
      return A.item == B
    elif type(B) == depTreeNode:
      return B.item == A
    else:
      return False
  def addChild(self,child):
    """ Add a child to this node, appropriately updating all allchildren lists """
    self.children.append(child)
    newchildren = [child] + child.allchildren
    self.allchildren.extend(newchildren)
    parent = self.parent
    while not parent == None:
      parent.allchildren.extend(newchildren)
      parent = parent.parent
    
  
      
class depTree:
  """ Class that mimics the dependency browser in the Understand gui
  
  This class takes in a single ent (as the root node's ent) and adds
  children to it. To get a display like the dependency browser, use
  the printTree() function. Two other convenience functions are
  available:
    isDependency(self,ent)
    entsBetween(self,entA,entB)
  The __init__ function should be called when initializing the tree
  with a new ent. That builds the entire tree using the build functions
    buildTree(self,map)
    buildBranch(self,ref)
  The printTree function prints the entire tree like the dependency
  browser in Understand. """
  root = depTreeNode(None,0)
  forward = True
  ent = None
  def __init__(self, ent=None, forward = True):
    """ Build the tree from the ent. 
  
    If forward is true, the tree is built using understand.Ent.depends(). If
    false, the tree is built using understand.Ent.dependsby()."""
    if ent:
      self.root = depTreeNode(ent,0)
      if forward:
        self.buildTree(ent.depends())
      else:
        self.forward = False
        self.buildTree(ent.dependsby())
  def printTree(self):
    """ Print the entire tree
    
    This appears similar to the dependency browser in the gui """
    self.root.printSelf()
  def buildBranch(self,ref,addHere = None, ignoreTopParent = False): 
    """ Given a reference, add it to the tree
    
    This adds all intermediate entitites not already in the tree. The
    parameter addHere tells the tree where to start looking for entities
    that match the references parent entities. If no matches are found, 
    the references parents are appended directly under the node. If this
    parameter is not provided, it is assumed to be the root. 
    
    The parameter ignoreTopParent ignores the top parent of the reference
    (the file) when placing the reference in the tree. This should generally
    be true if an addHere parameter is given, since the addHere is likely
    the correct parent file. An entities parent file is not always the
    same as the file it appears under in the dependency dictionary. For
    example, c++ entities will give header files as their file
    rather than the source file."""    
    # Add all parents to stack so first off will be top parent
    stack = []
    ent = ref.ent()
    while ent:
      stack.append(ent)
      ent = ent.parent()
      
    # Get parent, ignoring top if needed
    parent = stack.pop()
    if ignoreTopParent and stack:
      parent = stack.pop() 
    elif ignoreTopParent:
      addHere.ref.append(ref)
      return
      
    # Find place to add parent
    if not addHere:
      addHere = tree.root
    else:
      addHere.ref.append(ref)
    while depTreeNode(parent) in addHere.allchildren and stack:
      addHere = addHere.allchildren[addHere.allchildren.index(parent)]
      addHere.ref.append(ref)
      parent = stack.pop()
      
    # Add all remaining parents
    addHere.addChild(depTreeNode(parent,addHere,ref))
    addHere = addHere.children[-1]
    while stack:
      addHere.addChild(depTreeNode(stack.pop(),addHere,ref))
      addHere = addHere.children[-1]
      
  def buildTree(self,map):
    """ Build the tree from a map.
    
    The root node is assumed to already be initialized to the ent the
    map was created from. """
    for key,value in map.items():
      keyNode = depTreeNode(key,self.root)
      self.root.addChild(keyNode)
      for ref in value:
        self.buildBranch(ref,addHere = keyNode, ignoreTopParent = True)
  def isDependency(self,ent):
    """ A convenience function for determining if a ent is in the tree
    
    This is the similar to asking ent in root.allchildren. It returns an
    false if the entity was not in the tree. Otherwise, it returns the
    entities list of references (reasons why it's in the tree. If the
    entity occurs more than once in the tree (for example, if it appears
    under both a source and a header file of c++) all it's references
    will be added to the returned list. """
    if depTreeNode(ent) in self.root.allchildren:
      refs = []
      for node in self.root.allchildren:
        if node == depTreeNode(ent):
          refs.extend(node.ref)
      return refs
    else:
      return False
  def entsBetween(self, entA,entB):
    """ Return a list of entities between entA and entB in the tree
    
    If either ent is not in the tree, or there is no connection between
    the two ents, None will be returned. Otherwise, a list will be 
    returned with entA as the first item, and entB as the last item.
    The middle items will be in the order they appear between the two
    ents. entB should appear below entA in the tree. """
    
    if not depTreeNode(entB) in self.root.allchildren:   
      return
    if entA == entB:
      return [entA]
    node= self.root.allchildren[self.root.allchildren.index(depTreeNode(entB))]
    list = [entB]
    node = node.parent
    while node and not (node == depTreeNode(entA)):
      list.append(node.item)
      node = node.parent
    if node:
      list.append(entA)
      list.reverse()
      return list
     

    
def printDependencies(map):
  """ Print the dependencies in a tree format
  
  This displays all the dependencies and their parents, but it doesn't
  group together parents like building a depTree does. """  
  for key,value in map.items(): 
    indent = "  "
    level = 0
    print (indent * level, key, "("+key.kindname()+")")
    for ref in value:
      level = 1
      ent = ref.ent()
      stack = []
      entstack = []
      while ent:
        s =  str(ent) + "(" + str(ent.kindname()) + ")"
        stack.append(s)
        ent = ent.parent()
      while stack:
        level += 1   
        print (indent * level,stack.pop())
      level += 1
      print (indent * level, ref.scope(), ref.kindname() + "s", ref.ent(), "at", ref.file(), ":", ref.line())    




        

