# Trees - Complete DSA Notes

## Table of Contents
1. [What is a Tree?](#what-is-a-tree)
2. [Why Trees Were Introduced](#why-trees-were-introduced)
3. [Basic Logic Behind Trees](#basic-logic-behind-trees)
4. [Tree Terminology](#tree-terminology)
5. [Types of Trees](#types-of-trees)
6. [Tree Patterns](#tree-patterns)
7. [Prerequisites](#prerequisites)
8. [Tree Traversals](#tree-traversals)
9. [Problem Categories](#problem-categories)
10. [Common Algorithms](#common-algorithms)
11. [Time & Space Complexity](#time--space-complexity)
12. [Practice Roadmap](#practice-roadmap)

---

## What is a Tree?

A **Tree** is a hierarchical, non-linear data structure consisting of nodes connected by edges.

### Visual Representation
```
       1          <- Root
      / \
     2   3        <- Internal Nodes
    / \   \
   4   5   6      <- Leaf Nodes
```

### Basic Structure (Node Definition)
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int val) { this.val = val; }
}
```

---

## Why Trees Were Introduced

| Use Case | Reason |
|----------|--------|
| **File Systems** | Hierarchical folder structure |
| **Databases** | B-trees for efficient indexing |
| **HTML DOM** | Nested element structure |
| **Compilers** | Abstract Syntax Trees (AST) |
| **AI/ML** | Decision trees |
| **Networks** | Routing tables |
| **Efficient Search** | O(log n) in balanced BST vs O(n) in arrays |

---

## Basic Logic Behind Trees

### Core Principles

1. **Recursive Nature**: Every node is a root of its own subtree
2. **No Cycles**: Trees are acyclic graphs
3. **Single Path**: Only one path between any two nodes
4. **N nodes = N-1 edges**

### Fundamental Pattern
```
solve(node):
    if node is null:
        return base_case
    
    left_result = solve(node.left)
    right_result = solve(node.right)
    
    return combine(node.val, left_result, right_result)
```

---

## Tree Terminology

| Term | Definition | Example |
|------|------------|---------|
| **Root** | Topmost node with no parent | Node 1 |
| **Parent** | Node with children | Node 2 is parent of 4, 5 |
| **Child** | Node connected below parent | 4, 5 are children of 2 |
| **Leaf** | Node with no children | Nodes 4, 5, 6 |
| **Internal Node** | Node with at least one child | Nodes 1, 2, 3 |
| **Sibling** | Nodes with same parent | 2 and 3 are siblings |
| **Ancestor** | All nodes on path from root to node | 1, 2 are ancestors of 4 |
| **Descendant** | All nodes in subtree of a node | 4, 5 are descendants of 2 |
| **Depth** | Distance from root to node | Depth of 4 is 2 |
| **Height** | Distance from node to deepest leaf | Height of tree is 2 |
| **Level** | Depth + 1 | Root is at level 1 |
| **Subtree** | Tree formed by node and descendants | Node 2 with 4, 5 |
| **Degree** | Number of children of a node | Degree of 2 is 2 |

### Height vs Depth
```
       1          Height: 2, Depth: 0
      / \
     2   3        Height: 1, Depth: 1
    / \   \
   4   5   6      Height: 0, Depth: 2
```

---

## Types of Trees

### 1. Binary Tree
- Each node has at most 2 children (left and right)

### 2. Binary Search Tree (BST)
- Left subtree < Root < Right subtree
- Enables O(log n) search in balanced trees

```
       5
      / \
     3   7
    / \   \
   2   4   8
```

### 3. Complete Binary Tree
- All levels filled except possibly last
- Last level filled from left to right
- Used in Heaps

```
       1
      / \
     2   3
    / \  /
   4  5 6
```

### 4. Full Binary Tree
- Every node has 0 or 2 children

```
       1
      / \
     2   3
        / \
       4   5
```

### 5. Perfect Binary Tree
- All internal nodes have 2 children
- All leaves at same level

```
       1
      / \
     2   3
    / \ / \
   4  5 6  7
```

### 6. Balanced Binary Tree
- Height difference between left and right subtree ≤ 1 for all nodes
- Examples: AVL Tree, Red-Black Tree

### 7. Degenerate/Skewed Tree
- Each node has only one child
- Essentially a linked list

```
   1
    \
     2
      \
       3
```

### 8. N-ary Tree
- Each node can have at most N children

---

## Tree Patterns

### Pattern 1: DFS (Depth First Search)

#### Inorder (Left → Root → Right)
```python
def inorder(root):
    if not root:
        return
    inorder(root.left)
    print(root.val)
    inorder(root.right)
```
**Output for BST**: Sorted order  
**Use**: BST validation, sorted retrieval

#### Preorder (Root → Left → Right)
```python
def preorder(root):
    if not root:
        return
    print(root.val)
    preorder(root.left)
    preorder(root.right)
```
**Use**: Tree copying, prefix expression

#### Postorder (Left → Right → Root)
```python
def postorder(root):
    if not root:
        return
    postorder(root.left)
    postorder(root.right)
    print(root.val)
```
**Use**: Tree deletion, postfix expression

### Pattern 2: BFS (Breadth First Search)

#### Level Order Traversal
```python
from collections import deque

def levelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result
```
**Use**: Level-wise operations, shortest path

### Pattern 3: Recursive Pattern (Bottom-Up)

```python
def height(root):
    if not root:
        return 0
    
    left_height = height(root.left)
    right_height = height(root.right)
    
    return 1 + max(left_height, right_height)
```

### Pattern 4: Recursive Pattern (Top-Down)

```python
def hasPathSum(root, targetSum, currentSum=0):
    if not root:
        return False
    
    currentSum += root.val
    
    if not root.left and not root.right:
        return currentSum == targetSum
    
    return (hasPathSum(root.left, targetSum, currentSum) or 
            hasPathSum(root.right, targetSum, currentSum))
```

### Pattern 5: Two Pointers

```python
def isSameTree(p, q):
    if not p and not q:
        return True
    if not p or not q:
        return False
    
    return (p.val == q.val and 
            isSameTree(p.left, q.left) and 
            isSameTree(p.right, q.right))
```

---

## Prerequisites

### Must Know ⭐⭐⭐

1. **Recursion**
   - Base case and recursive case
   - Call stack understanding
   - Backtracking basics
   
2. **Linked Lists**
   - Node structure
   - Pointer manipulation

3. **Stack & Queue**
   - Stack for iterative DFS
   - Queue for BFS

4. **Basic Data Structures**
   - Arrays
   - HashMaps

### Good to Know

- Time/Space complexity analysis
- Basic graph concepts
- Dynamic Programming basics

---

## Tree Traversals

### 1. Inorder Traversal

**Recursive**:
```python
def inorder(root):
    result = []
    def traverse(node):
        if not node:
            return
        traverse(node.left)
        result.append(node.val)
        traverse(node.right)
    traverse(root)
    return result
```

**Iterative**:
```python
def inorder(root):
    result = []
    stack = []
    current = root
    
    while current or stack:
        while current:
            stack.append(current)
            current = current.left
        
        current = stack.pop()
        result.append(current.val)
        current = current.right
    
    return result
```

### 2. Preorder Traversal

**Recursive**:
```python
def preorder(root):
    result = []
    def traverse(node):
        if not node:
            return
        result.append(node.val)
        traverse(node.left)
        traverse(node.right)
    traverse(root)
    return result
```

**Iterative**:
```python
def preorder(root):
    if not root:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result
```

### 3. Postorder Traversal

**Recursive**:
```python
def postorder(root):
    result = []
    def traverse(node):
        if not node:
            return
        traverse(node.left)
        traverse(node.right)
        result.append(node.val)
    traverse(root)
    return result
```

**Iterative**:
```python
def postorder(root):
    if not root:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        if node.left:
            stack.append(node.left)
        if node.right:
            stack.append(node.right)
    
    return result[::-1]  # Reverse
```

### 4. Level Order Traversal

```python
from collections import deque

def levelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result
```

### 5. Zigzag Level Order

```python
def zigzagLevelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    left_to_right = True
    
    while queue:
        level_size = len(queue)
        level = deque()
        
        for _ in range(level_size):
            node = queue.popleft()
            
            if left_to_right:
                level.append(node.val)
            else:
                level.appendleft(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(list(level))
        left_to_right = not left_to_right
    
    return result
```

---

## Problem Categories

### 1. Traversal Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Binary Tree Inorder Traversal | DFS | Easy |
| Binary Tree Preorder Traversal | DFS | Easy |
| Binary Tree Postorder Traversal | DFS | Easy |
| Binary Tree Level Order Traversal | BFS | Medium |
| Zigzag Level Order Traversal | BFS | Medium |
| Vertical Order Traversal | BFS + HashMap | Hard |

### 2. Property Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Maximum Depth of Binary Tree | Recursion | Easy |
| Minimum Depth of Binary Tree | BFS/DFS | Easy |
| Balanced Binary Tree | Bottom-Up | Easy |
| Symmetric Tree | Two Pointers | Easy |
| Diameter of Binary Tree | Bottom-Up | Easy |
| Same Tree | Two Pointers | Easy |

**Height of Tree**:
```python
def maxDepth(root):
    if not root:
        return 0
    return 1 + max(maxDepth(root.left), maxDepth(root.right))
```

**Balanced Tree**:
```python
def isBalanced(root):
    def height(node):
        if not node:
            return 0
        
        left = height(node.left)
        if left == -1:
            return -1
        
        right = height(node.right)
        if right == -1:
            return -1
        
        if abs(left - right) > 1:
            return -1
        
        return 1 + max(left, right)
    
    return height(root) != -1
```

**Diameter**:
```python
def diameterOfBinaryTree(root):
    diameter = 0
    
    def height(node):
        nonlocal diameter
        if not node:
            return 0
        
        left = height(node.left)
        right = height(node.right)
        
        diameter = max(diameter, left + right)
        
        return 1 + max(left, right)
    
    height(root)
    return diameter
```

### 3. Path Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Path Sum | Top-Down | Easy |
| Path Sum II | Backtracking | Medium |
| Binary Tree Maximum Path Sum | Bottom-Up | Hard |
| Sum Root to Leaf Numbers | Top-Down | Medium |

**Path Sum**:
```python
def hasPathSum(root, targetSum):
    if not root:
        return False
    
    if not root.left and not root.right:
        return root.val == targetSum
    
    targetSum -= root.val
    return hasPathSum(root.left, targetSum) or hasPathSum(root.right, targetSum)
```

**All Root to Leaf Paths**:
```python
def binaryTreePaths(root):
    if not root:
        return []
    
    paths = []
    
    def dfs(node, path):
        if not node.left and not node.right:
            paths.append(path + str(node.val))
            return
        
        if node.left:
            dfs(node.left, path + str(node.val) + "->")
        if node.right:
            dfs(node.right, path + str(node.val) + "->")
    
    dfs(root, "")
    return paths
```

### 4. Construction Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Construct Binary Tree from Preorder and Inorder | Recursion | Medium |
| Construct Binary Tree from Inorder and Postorder | Recursion | Medium |
| Convert Sorted Array to BST | Recursion | Easy |

**From Preorder and Inorder**:
```python
def buildTree(preorder, inorder):
    if not preorder or not inorder:
        return None
    
    root = TreeNode(preorder[0])
    mid = inorder.index(preorder[0])
    
    root.left = buildTree(preorder[1:mid+1], inorder[:mid])
    root.right = buildTree(preorder[mid+1:], inorder[mid+1:])
    
    return root
```

### 5. Modification Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Invert Binary Tree | Recursion | Easy |
| Flatten Binary Tree to Linked List | Recursion | Medium |
| Trim a Binary Search Tree | Recursion | Medium |

**Invert Tree**:
```python
def invertTree(root):
    if not root:
        return None
    
    root.left, root.right = root.right, root.left
    invertTree(root.left)
    invertTree(root.right)
    
    return root
```

### 6. Search Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Lowest Common Ancestor | Recursion | Medium |
| Kth Smallest Element in BST | Inorder | Medium |
| Find Mode in BST | Inorder | Easy |

**Lowest Common Ancestor**:
```python
def lowestCommonAncestor(root, p, q):
    if not root or root == p or root == q:
        return root
    
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    
    if left and right:
        return root
    
    return left if left else right
```

### 7. BST Specific Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Validate Binary Search Tree | Inorder/Recursion | Medium |
| Search in BST | Recursion | Easy |
| Insert into BST | Recursion | Medium |
| Delete Node in BST | Recursion | Medium |

**Validate BST**:
```python
def isValidBST(root):
    def validate(node, min_val, max_val):
        if not node:
            return True
        
        if node.val <= min_val or node.val >= max_val:
            return False
        
        return (validate(node.left, min_val, node.val) and 
                validate(node.right, node.val, max_val))
    
    return validate(root, float('-inf'), float('inf'))
```

**Insert into BST**:
```python
def insertIntoBST(root, val):
    if not root:
        return TreeNode(val)
    
    if val < root.val:
        root.left = insertIntoBST(root.left, val)
    else:
        root.right = insertIntoBST(root.right, val)
    
    return root
```

**Delete from BST**:
```python
def deleteNode(root, key):
    if not root:
        return None
    
    if key < root.val:
        root.left = deleteNode(root.left, key)
    elif key > root.val:
        root.right = deleteNode(root.right, key)
    else:
        # Node to delete found
        if not root.left:
            return root.right
        if not root.right:
            return root.left
        
        # Node has two children
        # Find min in right subtree
        min_node = root.right
        while min_node.left:
            min_node = min_node.left
        
        root.val = min_node.val
        root.right = deleteNode(root.right, min_node.val)
    
    return root
```

### 8. Advanced Problems

| Problem | Pattern | Difficulty |
|---------|---------|------------|
| Serialize and Deserialize Binary Tree | BFS/DFS | Hard |
| Binary Tree Maximum Path Sum | Bottom-Up | Hard |
| Count Complete Tree Nodes | Binary Search | Medium |

**Serialize and Deserialize**:
```python
class Codec:
    def serialize(self, root):
        if not root:
            return "null"
        return str(root.val) + "," + self.serialize(root.left) + "," + self.serialize(root.right)
    
    def deserialize(self, data):
        def build(nodes):
            val = next(nodes)
            if val == "null":
                return None
            node = TreeNode(int(val))
            node.left = build(nodes)
            node.right = build(nodes)
            return node
        
        return build(iter(data.split(",")))
```

---

## Common Algorithms

### 1. Finding Height
```python
def height(root):
    if not root:
        return 0
    return 1 + max(height(root.left), height(root.right))
```

### 2. Counting Nodes
```python
def countNodes(root):
    if not root:
        return 0
    return 1 + countNodes(root.left) + countNodes(root.right)
```

### 3. Finding Maximum Value
```python
def findMax(root):
    if not root:
        return float('-inf')
    return max(root.val, findMax(root.left), findMax(root.right))
```

### 4. Checking if Value Exists
```python
def search(root, target):
    if not root:
        return False
    if root.val == target:
        return True
    return search(root.left, target) or search(root.right, target)
```

### 5. Level of a Node
```python
def getLevel(root, target, level=1):
    if not root:
        return 0
    if root.val == target:
        return level
    
    left = getLevel(root.left, target, level + 1)
    if left != 0:
        return left
    
    return getLevel(root.right, target, level + 1)
```

### 6. Print Ancestors
```python
def printAncestors(root, target):
    if not root:
        return False
    
    if root.val == target:
        return True
    
    if printAncestors(root.left, target) or printAncestors(root.right, target):
        print(root.val)
        return True
    
    return False
```

### 7. Mirror/Invert Tree
```python
def mirror(root):
    if not root:
        return None
    
    root.left, root.right = root.right, root.left
    mirror(root.left)
    mirror(root.right)
    
    return root
```

### 8. Check if Subtree
```python
def isSubtree(root, subRoot):
    if not root:
        return False
    
    if isSameTree(root, subRoot):
        return True
    
    return isSubtree(root.left, subRoot) or isSubtree(root.right, subRoot)

def isSameTree(p, q):
    if not p and not q:
        return True
    if not p or not q:
        return False
    return p.val == q.val and isSameTree(p.left, q.left) and isSameTree(p.right, q.right)
```

---

## Time & Space Complexity

### Traversal Complexities

| Operation | Time | Space |
|-----------|------|-------|
| DFS (Inorder/Preorder/Postorder) | O(n) | O(h) - recursion stack |
| BFS (Level Order) | O(n) | O(w) - queue width |
| Search in Binary Tree | O(n) | O(h) |
| Search in BST (balanced) | O(log n) | O(h) |
| Search in BST (skewed) | O(n) | O(n) |
| Insert in BST (balanced) | O(log n) | O(h) |
| Delete in BST (balanced) | O(log n) | O(h) |

Where:
- n = number of nodes
- h = height of tree
- w = maximum width of tree

### Space Complexity Notes

- **Balanced Tree**: h = log n
- **Skewed Tree**: h = n
- **Complete Tree**: h = log n, w = n/2

---

## Practice Roadmap

### Week 1: Basics
- [ ] Implement TreeNode class
- [ ] All 4 traversals (recursive + iterative)
- [ ] Height of tree
- [ ] Count nodes
- [ ] Maximum value in tree
- [ ] Search in tree

### Week 2: Easy Problems
- [ ] Same Tree
- [ ] Symmetric Tree
- [ ] Invert Binary Tree
- [ ] Maximum Depth
- [ ] Minimum Depth
- [ ] Path Sum
- [ ] Balanced Binary Tree

### Week 3: BST Basics
- [ ] Search in BST
- [ ] Insert into BST
- [ ] Validate BST
- [ ] Kth Smallest in BST
- [ ] Convert Sorted Array to BST
- [ ] Range Sum of BST

### Week 4: Medium Problems
- [ ] Level Order Traversal
- [ ] Zigzag Level Order
- [ ] Binary Tree Right Side View
- [ ] Path Sum II
- [ ] Lowest Common Ancestor
- [ ] Construct Tree from Traversals
- [ ] Flatten Binary Tree

### Week 5: Advanced
- [ ] Diameter of Binary Tree
- [ ] Binary Tree Maximum Path Sum
- [ ] Serialize and Deserialize
- [ ] Count Complete Tree Nodes
- [ ] Delete Node in BST
- [ ] Vertical Order Traversal

---

## Key Takeaways

1. **Master Recursion**: 90% of tree problems use recursion
2. **Understand Base Cases**: null checks are crucial
3. **Think in Subtrees**: Break problem into left and right subtrees
4. **Choose Right Traversal**: 
   - Inorder for BST
   - Level order for level-wise operations
   - Postorder for deletion
5. **Practice Patterns**: Most problems follow 5-6 core patterns
6. **Draw Trees**: Visualize before coding
7. **Test Edge Cases**: Empty tree, single node, skewed tree

---

## Common Mistakes to Avoid

1. Forgetting null checks
2. Not returning values in recursion
3. Modifying tree structure unintentionally
4. Confusing height and depth
5. Not handling single-node trees
6. Incorrect BST property checks
7. Stack overflow in deep recursion

---

## Resources for Practice

- LeetCode: Tree tag (150+ problems)
- GeeksforGeeks: Tree section
- HackerRank: Tree challenges
- Visualize: visualgo.net/en/bst

---

**Remember**: Trees are all about recursion. Master the recursive thinking, and trees become easy!
