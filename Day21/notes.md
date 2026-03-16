# Day 21: Binary Tree Operations - Invert & Compare

## Problem 1: Invert Binary Tree ⭐

### Problem Logic
Invert (mirror) a binary tree by swapping left and right children at every node. The tree is flipped horizontally.

### Core Insight
**Recursive Swap**: At each node, swap left and right children, then recursively invert both subtrees.

### Pseudocode
```
INVERT_TREE(root):
    if root is None:
        return None
    
    # Swap left and right children
    root.left, root.right = root.right, root.left
    
    # Recursively invert both subtrees
    INVERT_TREE(root.left)
    INVERT_TREE(root.right)
    
    return root
```

### Visual Flow
```
Original Tree:
        4
       / \
      2   7
     / \ / \
    1  3 6  9

After Invert:
        4
       / \
      7   2
     / \ / \
    9  6 3  1

Step-by-step at root (4):
1. Swap: left=7, right=2
2. Recurse on left (7): swap 9 and 6
3. Recurse on right (2): swap 3 and 1
```

### Execution Trace
```
invertTree(4)
├── swap(2, 7) → left=7, right=2
├── invertTree(7)
│   ├── swap(6, 9) → left=9, right=6
│   ├── invertTree(9) → leaf, return
│   └── invertTree(6) → leaf, return
└── invertTree(2)
    ├── swap(1, 3) → left=3, right=1
    ├── invertTree(3) → leaf, return
    └── invertTree(1) → leaf, return
```

### Approach Comparison

| Approach | Method | Time | Space | Notes |
|----------|--------|------|-------|-------|
| **Recursive DFS** ⭐ | Swap then recurse | O(n) | O(h) | Cleanest, most intuitive |
| **Iterative BFS** | Queue with level-order | O(n) | O(w) | Uses queue |
| **Iterative DFS** | Stack with pre-order | O(n) | O(h) | Uses stack |

### Alternative: Iterative BFS
```python
def invertTree(root):
    if not root:
        return None
    
    queue = [root]
    while queue:
        node = queue.pop(0)
        
        # Swap children
        node.left, node.right = node.right, node.left
        
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return root
```

### Complexity
- **Time**: O(n) - visit each node once
- **Space**: O(h) for recursion stack
  - Best case (balanced): O(log n)
  - Worst case (skewed): O(n)

---

## Problem 2: Same Tree ⭐

### Problem Logic
Check if two binary trees are structurally identical with same node values at corresponding positions.

### Core Insight
**Simultaneous Traversal**: Traverse both trees in parallel, checking:
1. Both nodes are None → same
2. One is None, other isn't → different
3. Both exist but values differ → different
4. Both exist with same value → recurse on children

### Pseudocode
```
IS_SAME_TREE(p, q):
    # Both empty
    if p is None and q is None:
        return True
    
    # One empty, one not
    if p is None or q is None:
        return False
    
    # Values differ
    if p.val != q.val:
        return False
    
    # Check both subtrees
    return IS_SAME_TREE(p.left, q.left) AND 
           IS_SAME_TREE(p.right, q.right)
```

### Visual Flow
```
Example 1: Same Trees
Tree p:     Tree q:
   1           1
  / \         / \
 2   3       2   3

Check: isSameTree(1, 1)
├── 1 == 1 ✓
├── isSameTree(2, 2)
│   ├── 2 == 2 ✓
│   ├── isSameTree(None, None) → True
│   └── isSameTree(None, None) → True
└── isSameTree(3, 3)
    ├── 3 == 3 ✓
    ├── isSameTree(None, None) → True
    └── isSameTree(None, None) → True
Result: True

Example 2: Different Structure
Tree p:     Tree q:
   1           1
  /             \
 2               2

Check: isSameTree(1, 1)
├── 1 == 1 ✓
├── isSameTree(2, None) → False (one is None)
Result: False

Example 3: Different Values
Tree p:     Tree q:
   1           1
  / \         / \
 2   1       1   2

Check: isSameTree(1, 1)
├── 1 == 1 ✓
├── isSameTree(2, 1) → False (2 != 1)
Result: False
```

### Decision Tree
```
isSameTree(p, q)
    │
    ├─ Both None? ──Yes──> True
    │       │
    │      No
    │       │
    ├─ One None? ──Yes──> False
    │       │
    │      No
    │       │
    ├─ Values differ? ──Yes──> False
    │       │
    │      No
    │       │
    └─ Recurse on left AND right subtrees
```

### Approach Comparison

| Approach | Method | Time | Space | Notes |
|----------|--------|------|-------|-------|
| **Recursive DFS** ⭐ | Parallel traversal | O(n) | O(h) | Most elegant |
| **Iterative DFS** | Two stacks | O(n) | O(h) | Explicit stack |
| **Iterative BFS** | Two queues | O(n) | O(w) | Level-order |

### Alternative: Iterative DFS with Stack
```python
def isSameTree(p, q):
    stack_p = [p]
    stack_q = [q]
    
    while stack_p and stack_q:
        node_p = stack_p.pop()
        node_q = stack_q.pop()
        
        # Both None
        if not node_p and not node_q:
            continue
        
        # One None, other not
        if not node_p or not node_q:
            return False
        
        # Values differ
        if node_p.val != node_q.val:
            return False
        
        # Push children (order matters - must match)
        stack_p.append(node_p.left)
        stack_p.append(node_p.right)
        stack_q.append(node_q.left)
        stack_q.append(node_q.right)
    
    return True
```

### Complexity
- **Time**: O(min(n, m)) - visit nodes until difference found
- **Space**: O(min(h₁, h₂)) for recursion stack

---

## Tree Operations Reference Guide

### 1. Tree Traversals

#### Inorder (Left → Root → Right)
```
INORDER(root):
    if root is None:
        return
    INORDER(root.left)
    visit(root)
    INORDER(root.right)

Use: BST sorted order, expression evaluation
```

#### Preorder (Root → Left → Right)
```
PREORDER(root):
    if root is None:
        return
    visit(root)
    PREORDER(root.left)
    PREORDER(root.right)

Use: Copy tree, prefix expression, serialize tree
```

#### Postorder (Left → Right → Root)
```
POSTORDER(root):
    if root is None:
        return
    POSTORDER(root.left)
    POSTORDER(root.right)
    visit(root)

Use: Delete tree, postfix expression, calculate height
```

#### Level Order (BFS)
```
LEVEL_ORDER(root):
    if root is None:
        return
    queue = [root]
    while queue not empty:
        node = queue.dequeue()
        visit(node)
        if node.left: queue.enqueue(node.left)
        if node.right: queue.enqueue(node.right)

Use: Level-by-level processing, shortest path
```

### 2. Common Tree Operations

| Operation | Time | Space | Method |
|-----------|------|-------|--------|
| **Search** | O(n) | O(h) | DFS/BFS |
| **Insert (BST)** | O(h) | O(h) | Compare & recurse |
| **Delete (BST)** | O(h) | O(h) | 3 cases handling |
| **Height** | O(n) | O(h) | Max of subtrees + 1 |
| **Count Nodes** | O(n) | O(h) | Sum of subtrees + 1 |
| **Invert** | O(n) | O(h) | Swap children |
| **Same Tree** | O(n) | O(h) | Parallel traversal |

### 3. BST Operations

#### Insert in BST
```
INSERT_BST(root, val):
    if root is None:
        return TreeNode(val)
    
    if val < root.val:
        root.left = INSERT_BST(root.left, val)
    else:
        root.right = INSERT_BST(root.right, val)
    
    return root
```

#### Delete in BST (3 Cases)
```
DELETE_BST(root, val):
    if root is None:
        return None
    
    if val < root.val:
        root.left = DELETE_BST(root.left, val)
    elif val > root.val:
        root.right = DELETE_BST(root.right, val)
    else:
        # Case 1: No children
        if not root.left and not root.right:
            return None
        
        # Case 2: One child
        if not root.left:
            return root.right
        if not root.right:
            return root.left
        
        # Case 3: Two children
        # Find inorder successor (min in right subtree)
        min_node = FIND_MIN(root.right)
        root.val = min_node.val
        root.right = DELETE_BST(root.right, min_node.val)
    
    return root
```

### 4. Tree Properties

#### Height/Depth
```
HEIGHT(root):
    if root is None:
        return 0
    return 1 + max(HEIGHT(root.left), HEIGHT(root.right))
```

#### Count Nodes
```
COUNT_NODES(root):
    if root is None:
        return 0
    return 1 + COUNT_NODES(root.left) + COUNT_NODES(root.right)
```

#### Count Leaves
```
COUNT_LEAVES(root):
    if root is None:
        return 0
    if root.left is None and root.right is None:
        return 1
    return COUNT_LEAVES(root.left) + COUNT_LEAVES(root.right)
```

---

## Day 21 Summary

### Key Concepts
1. **Invert Tree**: Swap children at each node recursively
2. **Same Tree**: Parallel traversal with 3 base cases
3. **Tree Traversals**: Inorder, Preorder, Postorder, Level Order
4. **BST Operations**: Insert, Delete (3 cases), Search

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Invert Tree | Tree Modification | Swap + Recurse | O(n) |
| Same Tree | Tree Comparison | Parallel DFS | O(n) |
| Tree Traversal | Tree Navigation | DFS/BFS | O(n) |
| BST Operations | Binary Search | Compare & Recurse | O(h) |

### Traversal Use Cases

| Traversal | Order | Use Case |
|-----------|-------|----------|
| **Inorder** | L-Root-R | BST sorted output, validate BST |
| **Preorder** | Root-L-R | Copy tree, serialize, prefix expression |
| **Postorder** | L-R-Root | Delete tree, calculate height, postfix |
| **Level Order** | Level-by-level | BFS, shortest path, level problems |

### Critical Insights
1. **Base Case First**: Always check for None before accessing node properties
2. **Swap Technique**: Python tuple unpacking makes swapping elegant: `a, b = b, a`
3. **Parallel Traversal**: Compare trees by traversing both simultaneously
4. **Recursion Pattern**: Most tree problems have natural recursive solutions
5. **BST Property**: Left < Root < Right enables O(h) operations

### Common Mistakes
1. ❌ Forgetting base case (None check) in recursion
2. ❌ Not handling all 3 cases in BST deletion
3. ❌ Comparing only values without checking structure in same tree
4. ❌ Confusing height (nodes) vs depth (edges)
5. ❌ Not considering both children when swapping in invert tree

### Recursion Template for Trees
```python
def tree_operation(root):
    # Base case
    if not root:
        return base_value
    
    # Process current node
    # ...
    
    # Recurse on children
    left_result = tree_operation(root.left)
    right_result = tree_operation(root.right)
    
    # Combine results
    return combine(current, left_result, right_result)
```

### Master Checklist
- [ ] Can invert binary tree recursively and iteratively
- [ ] Understand all 3 base cases for same tree comparison
- [ ] Know all 4 traversal types and their use cases
- [ ] Can implement BST insert and delete (3 cases)
- [ ] Understand when to use DFS vs BFS
- [ ] Can calculate tree height, count nodes, count leaves
- [ ] Know the recursion pattern for tree problems

### Quick Reference: Tree Problem Types

| Problem Type | Approach | Example |
|--------------|----------|---------|
| **Modification** | DFS with swap/update | Invert tree |
| **Comparison** | Parallel traversal | Same tree |
| **Search** | DFS/BFS | Find node |
| **Aggregation** | Post-order DFS | Height, count |
| **Path Problems** | DFS with backtracking | Path sum |
| **Level Problems** | BFS | Level order |
| **BST Specific** | Binary search property | Insert, delete |
