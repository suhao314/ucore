!-- gdTree.f90
!-- 19 Aug 92, Richard Maine: Version 1.1 added balancing.
!-- 11 Dec 92, Richard Maine: Version 1.2 var len keys, tree walking.

module gd_tree

  !-- Maintain a list of unique key names and corresponding data.
  !-- This version uses a balanced binary tree implementation internally.
  !-- Specific to character string keys as needed by getData/fdas;
  !-- generalization to arbitrary key structures would be tricky.
  !-- The associated data is handled internally as an array of integers;
  !-- other data types can be accomodated by using the transfer intrinsic.
  !-- 11 Dec 92, Richard Maine.

  use sysdep_io

  implicit none
  private

  type :: tree_node_type
    character*1, pointer :: key(:)
    integer, pointer :: data(:)
    type(tree_node_type), pointer :: left, right, up
    integer :: balance  !-- Right subtree height minus left subtree height.
  end type

  !-- Trees are public with private components.
  type, public :: tree_type
    private
    integer :: tree_size, tree_height
    type(tree_node_type), pointer :: top
  end type

  !-- Tree_walk_type saves the current position information for a tree walk.
  type, public :: tree_walk_type
    private
    type(tree_node_type), pointer :: node
  end type

  !-- The following global temporaries are used in adding new nodes.
  !-- These are global to all the instantiations of the recursion.
  logical :: duplicate_key, height_increased
  type(tree_node_type), pointer :: new_node

  !-- Public procedures.
  public initialize_tree, deallocate_tree, add_tree_data
  public get_tree_data, tree_size, walk_tree, step_tree

  !-- Forward reference for private procedures.
  private add_tree_node, deallocate_tree_node, search_tree_key, rotate
  private step_tree_node, key_compare

contains

  subroutine initialize_tree (tree)

    !-- Initialize an empty tree.
    !-- 19 Aug 92, Richard Maine.

    !-------------------- interface.
    type(tree_type), intent(out) :: tree
         !-- Binary tree.  Any existing contents will be lost.

    !-------------------- executable code.

    nullify(tree%top)
    tree%tree_size = 0
    tree%tree_height = 0
    return
  end subroutine initialize_tree

  subroutine deallocate_tree (tree)

    !-- Deallocate a binary tree.
    !-- 5 Mar 92, Richard Maine.

    !-------------------- interface.
    type(tree_type), intent(inout) :: tree

    !-------------------- executable code.

    call deallocate_tree_node(tree%top)
    return
  end subroutine deallocate_tree

  recursive subroutine deallocate_tree_node (node)

    !-- Recursively deallocate a binary tree node.
    !-- 5 Mar 92, Richard Maine.

    !-------------------- interface.
    type(tree_node_type), pointer :: node  !-- Intent(inout)

    !-------------------- executable code.

    if (.not.associated(node)) return
    call deallocate_tree_node(node%left)
    call deallocate_tree_node(node%right)
    deallocate(node%data)
    deallocate(node%key)
    deallocate(node)
    return
  end subroutine deallocate_tree_node

  subroutine add_tree_data (key, data, tree, duplicate, error)

    !-- Add a new node to a tree.
    !-- 19 Aug 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: key
         !-- Key for the node to be entered into the tree.
         !-- This will be truncated to 16 characters.
    integer, intent(in) :: data(:)
         !-- The data to be associated with the key.
         !-- Use the transfer intrinsic for other data types.
    type(tree_type), intent(inout) :: tree  !-- Binary tree.
    logical, intent(out) :: duplicate
         !-- Returns true if node is not added because of key duplication.
    logical, intent(out), optional :: error
         !-- Returns true on allocation errors.

    !-------------------- local.
    integer :: iostat, key_len, i

    !-------------------- executable code.

    !-- Build a new node.
    duplicate = .false.
    nullify(new_node)
    allocate(new_node, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(new_node%left, new_node%right, new_node%up)
    nullify(new_node%key, new_node%data)
    key_len = len_trim(key)
    allocate(new_node%key(key_len), stat=iostat)
    if (iostat /= 0) goto 8000
    do i = 1 , key_len
      new_node%key(i) = key(i:i)
    end do
    new_node%balance = 0
    allocate(new_node%data(size(data)), stat=iostat)
    if (iostat /= 0) goto 8000
    new_node%data = data

    !-- Add the node to the tree.
    call add_tree_node(tree%top)

    !-- Deallocate if the node wasn't added because of a duplicate key.
    if (duplicate_key) then
      deallocate(new_node%data)
      deallocate(new_node%key)
      deallocate(new_node)
      duplicate = .true.
    else
      tree%tree_size = tree%tree_size + 1
      if (height_increased) tree%tree_height = tree%tree_height + 1
    end if

    if (present(error)) error = .false.
    return

    !-- Error exit.
    8000 continue
    if (associated(new_node)) then
      if (associated(new_node%data)) deallocate(new_node%data)
      if (associated(new_node%key)) deallocate(new_node%key)
      deallocate(new_node)
    end if
    if (.not. present(error)) &
         call error_halt('Allocation failed in add_tree_data')
    error = .true.
    return
  end subroutine add_tree_data

  recursive subroutine add_tree_node (top_node)

    !-- Add a new node to a tree, rebalancing as needed.
    !-- Knuth (vol 3, pg 455) describes an algorithm that avoids recursion,
    !-- but requires redescending part of the tree for balancing.
    !-- 19 Aug 92, Richard Maine.

    !-------------------- interface.
    type(tree_node_type), pointer :: top_node
         !-- Root node of the binary tree.  Null for an empty tree.
         !-- May be allocated on return if was null on entry.
    !-- Uses duplicate_key, height_increased and new_node.
    !-- These global temporariess are shared by all instantiations.

    !-------------------- local.
    integer :: comparison

    !-------------------- executable code.

    !-- Allocate and return if the tree is empty.
    if (.not.associated(top_node)) then
      top_node => new_node
      duplicate_key = .false.
      height_increased = .true.
      return
    end if

    !-- Recursively descend left or right subtree if unequal.
    new_node%up => top_node
    comparison = key_compare(new_node%key, top_node%key)
    if (comparison < 0) then
      call add_tree_node(top_node%left)
    else if (comparison > 0) then
      call add_tree_node(top_node%right)
    !-- refuse to add duplicates.
    else
      duplicate_key = .true.
      height_increased = .false.
    end if

    !-- Adjust balance to reflect added node if needed.
    if (.not. height_increased) return
    top_node%balance = top_node%balance + comparison

    !-- If the addition balanced this node, we are done.
    if (top_node%balance == 0) then
      height_increased = .false.

    !-- If this node is unbalanced by more than 1, rebalance.
    else if (abs(top_node%balance) > 1) then

      !-- If the node one down on the highest side is unbalanced in the
      !-- opposite direction, then do the first half of a double rotation.
      if (comparison < 0) then
        if (top_node%left%balance > 0) call rotate(top_node%left, comparison)
      else
        if (top_node%right%balance < 0) call rotate(top_node%right, comparison)
      end if

      !-- Do a single rotation or the second half of a double rotation.
      call rotate(top_node, -comparison)
      height_increased = .false.
    end if
    return
  end subroutine add_tree_node

  subroutine rotate (top_node, direction)

    !-- Rotate a node to rebalance the tree.
    !-- 19 Aug 92, Richard Maine.

    !-------------------- interface.
    type(tree_node_type), pointer :: top_node
         !-- On entry, the node to be rotated.
         !-- On exit, the new top node of the subtree after rotation.
    integer, intent(in) :: direction
         !-- Direction to rotate.  1 = right, -1 = left.
         !-- For all current uses, this can be inferred from
         !-- the sign of top_node%balance on entry.
         !-- For right rotation, top_node%left must exist on entry.
         !-- For left rotation, top_node%right must exist on entry.

    !-------------------- local.
    type(tree_node_type), pointer :: old_top_node
    integer :: top_balance, sub_balance
    integer :: alpha_height, beta_height, gamma_height, sub_height

    !-------------------- executable code.

    !-- Do the rotation.
    old_top_node => top_node
    if (direction < 0) then
      top_node => top_node%right
      old_top_node%right => top_node%left
      top_node%left => old_top_node
      if (associated(old_top_node%right)) old_top_node%right%up => old_top_node
    else
      top_node => top_node%left
      old_top_node%left => top_node%right
      top_node%right => old_top_node
      if (associated(old_top_node%left)) old_top_node%left%up => old_top_node
    end if
    top_node%up => old_top_node%up
    old_top_node%up => top_node

    !-- Normalize balance factors by direction.
    top_balance = direction*old_top_node%balance
    sub_balance = direction*top_node%balance

    !-- Compute subtree heights.
    !-- All heights relative to initial top_node height.

    !-- Alpha subtree is the "outside" one off of the initial top node.
    alpha_height = -1 - max(0, -top_balance)
    !-- Sub here indicates the node that will be rotated to the top.
    sub_height = -1 - max(0, top_balance)
    !-- Gamma subtree is the "outside" one off of sub.
    gamma_height = sub_height - 1 - max(0, sub_balance)
    !-- Beta subtree is the "middle" one off of sub.
    beta_height = sub_height - 1 - max(0, -sub_balance)
    !-- Sub here is the old top node after the rotation.
    sub_height = 1 + max(alpha_height, beta_height)
    !-- If we want the top height after rotation, it will be
    !-- top_height = 1 + max(sub_height, gamma_height)

    !-- Compute revised balance factors.
    old_top_node%balance = direction*(alpha_height - beta_height)
    top_node%balance = direction*(sub_height - gamma_height)
    return
  end subroutine rotate

  subroutine get_tree_data (key, tree, data)

    !-- Get the data corresponding to a specified key in a binary tree.
    !-- 14 Dec 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: key  !-- The key to search for.
    type(tree_type), intent(in) :: tree  !-- The binary tree.
    integer, pointer :: data(:)  !-- Intent(out)
         !-- Pointer to the data for the specified key.
         !-- Returns null pointer if not found.

    !-------------------- local.
    type(tree_node_type), pointer :: node
    logical :: exact

    !-------------------- executable code.

    call search_tree_key (key, tree%top, node, exact)
    if (exact) then
      data => node%data
    else
      nullify(data)
    end if
    return
  end subroutine get_tree_data

  subroutine walk_tree (tree, walk, start_key)

    !-- Setup a tree walk.
    !-- The walk is then done by calling step_tree in a loop.
    !-- 11 Dec 92, Richard Maine.

    !-------------------- interface.
    type(tree_type), intent(in) :: tree  !-- The binary tree.
    type(tree_walk_type), intent(out) :: walk
         !-- A handle for saving the current position of the walk.
    character*(*), intent(in), optional :: start_key
         !-- The walk will start at the first node with a key
         !-- greater than or equal to this start key.

    !-------------------- executable code.

    if (present(start_key)) then
      call search_tree_key(start_key, tree%top, walk%node)
    else
      call search_tree_key('', tree%top, walk%node)
    end if
    return
  end subroutine walk_tree

  subroutine step_tree (walk, data, key, found)

    !-- Do one step of a tree walk setup by walk_tree.
    !-- 11 Dec 92, Richard Maine.

    !-------------------- interface.
    type(tree_walk_type), intent(inout) :: walk
         !-- A handle for saving the current position of the walk.
    integer, pointer, optional :: data(:)  !-- Intent(out)
         !-- Pointer to the data for the current node of the walk.
         !-- Returns null pointer if no node exists.
    character*(*), intent(out), optional :: key
         !-- Key of the current node of the walk.
         !-- Returns blank if no node exists.
    logical, intent(out), optional :: found
         !-- True if a node in the walk was found.
         !-- False if the walk is complete.

    !-------------------- local.
    integer :: i

    !-------------------- executable code.


    if (present(data)) nullify(data)
    if (present(key)) key = ''
    if (present(found)) found = associated(walk%node)

    !-- Return values for current node if it exists.
    if (associated(walk%node)) then
      if (present(data)) data => walk%node%data
      if (present(key)) then
        do i = 1 , min(size(walk%node%key),len(key))
          key(i:i) = walk%node%key(i)
        end do
      end if
    end if

    !-- Step to the next node.
    call step_tree_node(walk%node)
    return
  end subroutine step_tree

  subroutine step_tree_node (node)

    !-- Step to the next node in a tree.
    !-- 11 Dec 92, Richard Maine.

    !-------------------- interface.
    type(tree_node_type), pointer :: node
         !-- Points to a node in the tree on entry.  May be null.
         !-- Returns pointing to the next node or null if there is none.

    !-------------------- local.
    character*1, pointer :: old_key(:)

    !-------------------- executable code.

    if (.not.associated(node)) return

    !-- If there is a right subtree, the next node is RLLLL...
    if (associated(node%right)) then
      node => node%right
      do while (associated(node%left))
        node => node%left
      end do

    !-- Otherwise go up until we find a node after the current one.
    else
      old_key => node%key
      up_loop: do
        node => node%up
        if (.not.associated(node)) exit up_loop
        if (key_compare(old_key,node%key) < 0) exit up_loop
      end do up_loop
    end if
    return
  end subroutine step_tree_node

  subroutine search_tree_key (key, top_node, key_node, exact)

    !-- Search for a specified key in a binary tree.
    !-- This version uses iteration instead of recursion to descend;
    !-- this is just as easy and presumably more efficient.
    !-- 14 Dec 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: key  !-- The key to search for.
    type(tree_node_type), pointer :: top_node  !-- intent(in)
         !-- Top node of the tree to search.
    type(tree_node_type), pointer :: key_node  !-- intent(out)
         !-- The first node with the specified key or larger.
         !-- Null if no larger key exists in the tree.
    logical, intent(out), optional :: exact
         !-- True if the returned node has exactly the sought key.

    !-------------------- local.
    type(tree_node_type), pointer :: next_node
    integer :: comparison, i
    character*1 :: temp_key(len_trim(key))

    !-------------------- executable code.

    do i = 1 , size(temp_key)
      temp_key(i) = key(i:i)
    end do

    !-- Find the node with the specified key if it exists.
    !-- Otherwise find one of the 2 adjacent nodes.

    nullify(key_node)
    next_node => top_node
    comparison = -1

    loop: do while(associated(next_node))
      key_node => next_node

      !-- Descend left or right subtree if unequal.
      comparison = key_compare(temp_key, key_node%key)
      if (comparison < 0) then
        next_node => key_node%left
      else if (comparison > 0) then
        next_node => key_node%right

      !-- Return this node if found.
      else
        exit loop
      end if
    end do loop

    !-- If we are at the last node before the key, step to the one after.
    if (comparison > 0) call step_tree_node(key_node)
    if (present(exact)) exact = (comparison == 0)
    return
  end subroutine search_tree_key

  function tree_size (tree)

    !-- Return the number of nodes in a tree.
    !-- 19 Aug 92, Richard Maine

    !-------------------- interface.
    type(tree_type), intent(in) :: tree
    integer :: tree_size  !-- Number of nodes in the tree.

    !-------------------- executable code.
    tree_size = tree%tree_size
    return
  end function tree_size

  function key_compare (key1, key2)

    !-- Compare 2 keys, ignoring case. (Trailing blanks already truncated).
    !-- Modeled after string_comp in the string module.
    !-- 10 dec 92, Richard Maine.

    !-------------------- interface.
    character*1, intent(in) :: key1(:), key2(:)  !-- Keys to compare.
    integer :: key_compare
         !-- Returns 0 if keys equal,
         !-- -1 if key1 < key2, +1 if key1 > key2.

    !-------------------- local.
    integer :: i, min_len, ichar1, ichar2
    integer :: i_do
    integer, parameter :: down_map_ascii(0:127) = &
         (/ (i_do, i_do=0,64), (i_do+32, i_do=65,90), (i_do, i_do=91,127) /)

    !-------------------- executable code.

    !-- Compare the common portion.
    min_len = min(size(key1), size(key2))
    do i = 1 , min_len
      ichar1 = down_map_ascii(iachar(key1(i)))
      ichar2 = down_map_ascii(iachar(key2(i)))

      if (ichar1 == ichar2) cycle
      if (ichar1 < ichar2) then
        key_compare = -1
      else
        key_compare = 1
      end if
      return
    end do

    !-- Then check the remainders.
    if (size(key1) > min_len) then
      key_compare = 1
    else if (size(key2) > min_len) then
      key_compare = -1
    else
      key_compare = 0
    end if
    return
  end function key_compare

end module gd_tree
