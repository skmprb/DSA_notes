# Day 49: Binary Tree Inorder Traversal

## Problem Statement
**LeetCode 94: Binary Tree Inorder Traversal**

Given the root of a binary tree, return the inorder traversal of its nodes' values.

**Examples:**
```
Input: root = [1,null,2,3]
Output: [1,3,2]

Tree structure:
    1
     \
      2
     /
    3

Input: root = [1,2,3,4,5,null,8,null,null,6,7,9]
Output: [4,2,6,5,7,1,3,9,8]

Input: root = []
Output: []

Input: root = [1]
Output: [1]
```

**Constraints:**
- The number of nodes in the tree is in the range [0, 100]
- -100 <= Node.val <= 100

**Follow-up:** Recursive solution is trivial, could you do it iteratively?

---

## Problem Logic & Reasoning

### Core Concept
**Inorder Traversal** visits nodes in the order: **Left → Root → Right**

This produces a **sorted sequence** for Binary Search Trees (BST).

**Key Insight:** Use a stack to simulate the recursive call stack for iterative solution.

### Visual Understanding

```
Tree:
        4
       / \
      2   6
     / \ / \
    1  3 5  7

Inorder: Left → Root → Right
Process: 1, 2, 3, 4, 5, 6, 7

Traversal path:
1. Go left to 1 (leftmost)
2. Visit 1
3. Back to 2, visit 2
4. Go right to 3, visit 3
5. Back to 4, visit 4
6. Go left to 5, visit 5
7. Back to 6, visit 6
8. Go right to 7, visit 7
```

### Three Tree Traversals Comparison

```
Tree:
    1
   / \
  2   3

Inorder (Left-Root-Right):    [2, 1, 3]
Preorder (Root-Left-Right):   [1, 2, 3]
Postorder (Left-Right-Root):  [2, 3, 1]
```

---

## Approach 1: Recursive Solution (Trivial)

### Logic
1. Base case: If node is null, return
2. Recursively traverse left subtree
3. Visit current node (append to result)
4. Recursively traverse right subtree

### Visual Flow for Tree [4,2,6,1,3,5,7]

```
inorder(4)
    ↓
    inorder(2)
        ↓
        inorder(1)
            ↓
            inorder(null) → return
            visit 1 → [1]
            inorder(null) → return
        ↓
        visit 2 → [1, 2]
        ↓
        inorder(3)
            ↓
            inorder(null) → return
            visit 3 → [1, 2, 3]
            inorder(null) → return
    ↓
    visit 4 → [1, 2, 3, 4]
    ↓
    inorder(6)
        ↓
        inorder(5)
            ↓
            inorder(null) → return
            visit 5 → [1, 2, 3, 4, 5]
            inorder(null) → return
        ↓
        visit 6 → [1, 2, 3, 4, 5, 6]
        ↓
        inorder(7)
            ↓
            inorder(null) → return
            visit 7 → [1, 2, 3, 4, 5, 6, 7]
            inorder(null) → return

Result: [1, 2, 3, 4, 5, 6, 7]
```

### Pseudocode
```
function inorderTraversal(root):
    result = []
    
    function inorder(node):
        if node is null:
            return
        
        inorder(node.left)      // Left
        result.append(node.val) // Root
        inorder(node.right)     // Right
    
    inorder(root)
    return result
```

### Complexity Analysis
- **Time:** O(n) - Visit each node once
- **Space:** O(h) - Recursion stack, where h = height (O(log n) balanced, O(n) skewed)

---

## Approach 2: Iterative with Stack ⭐

### Logic
1. Use stack to simulate recursion
2. Go to leftmost node, pushing all nodes to stack
3. Pop node, visit it, move to right subtree
4. Repeat until stack is empty and no more nodes

### Visual Flow for Tree [4,2,6,1,3,5,7]

```
Tree:
        4
       / \
      2   6
     / \ / \
    1  3 5  7

Initial: stack=[], current=4, result=[]

Phase 1: Go left to leftmost
    Push 4: stack=[4], current=2
    Push 2: stack=[4,2], current=1
    Push 1: stack=[4,2,1], current=null

Phase 2: Process leftmost
    Pop 1: stack=[4,2], result=[1]
    current=null (no right child)

Phase 3: Backtrack to 2
    Pop 2: stack=[4], result=[1,2]
    current=3 (right child)

Phase 4: Process 3
    Push 3: stack=[4,3], current=null
    Pop 3: stack=[4], result=[1,2,3]
    current=null

Phase 5: Backtrack to 4
    Pop 4: stack=[], result=[1,2,3,4]
    current=6 (right child)

Phase 6: Process right subtree
    Push 6: stack=[6], current=5
    Push 5: stack=[6,5], current=null
    Pop 5: stack=[6], result=[1,2,3,4,5]
    current=null
    Pop 6: stack=[], result=[1,2,3,4,5,6]
    current=7
    Push 7: stack=[7], current=null
    Pop 7: stack=[], result=[1,2,3,4,5,6,7]

Result: [1, 2, 3, 4, 5, 6, 7]
```

### Step-by-Step Stack States

```
Tree:     2
         / \
        1   3

Step 1: current=2, stack=[]
    Push 2: stack=[2]
    current=1

Step 2: current=1, stack=[2]
    Push 1: stack=[2,1]
    current=null

Step 3: current=null, stack=[2,1]
    Pop 1: stack=[2]
    Visit 1: result=[1]
    current=null (1.right)

Step 4: current=null, stack=[2]
    Pop 2: stack=[]
    Visit 2: result=[1,2]
    current=3 (2.right)

Step 5: current=3, stack=[]
    Push 3: stack=[3]
    current=null

Step 6: current=null, stack=[3]
    Pop 3: stack=[]
    Visit 3: result=[1,2,3]
    current=null

Step 7: current=null, stack=[]
    Exit loop

Result: [1, 2, 3]
```

### Pseudocode
```
function inorderTraversal(root):
    result = []
    stack = []
    current = root
    
    while current or stack:
        // Go to leftmost node
        while current:
            stack.push(current)
            current = current.left
        
        // Process node
        current = stack.pop()
        result.append(current.val)
        
        // Move to right subtree
        current = current.right
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Visit each node once
- **Space:** O(h) - Stack size, where h = height

---

## Approach 3: Morris Traversal (O(1) Space) ⭐⭐⭐

### Logic
Use **threaded binary tree** concept:
1. If no left child, visit current, go right
2. If left child exists:
   - Find inorder predecessor (rightmost in left subtree)
   - If predecessor.right is null, create thread, go left
   - If predecessor.right points to current, remove thread, visit current, go right

### Why Morris Traversal?
```
Achieves O(1) space by:
- No recursion stack
- No explicit stack
- Uses tree structure itself for backtracking
```

### Visual Flow for Tree [2,1,3]

```
Tree:
    2
   / \
  1   3

Step 1: current=2
    Has left child (1)
    Find predecessor: 1
    1.right = null → Create thread: 1.right = 2
    current = 1

Step 2: current=1
    No left child
    Visit 1: result=[1]
    current = 1.right = 2 (follow thread)

Step 3: current=2
    Has left child (1)
    Find predecessor: 1
    1.right = 2 (thread exists) → Remove thread: 1.right = null
    Visit 2: result=[1,2]
    current = 3

Step 4: current=3
    No left child
    Visit 3: result=[1,2,3]
    current = null

Result: [1, 2, 3]
```

### Pseudocode
```
function inorderTraversal(root):
    result = []
    current = root
    
    while current:
        if not current.left:
            // No left child, visit and go right
            result.append(current.val)
            current = current.right
        else:
            // Find inorder predecessor
            predecessor = current.left
            while predecessor.right and predecessor.right != current:
                predecessor = predecessor.right
            
            if not predecessor.right:
                // Create thread
                predecessor.right = current
                current = current.left
            else:
                // Remove thread
                predecessor.right = null
                result.append(current.val)
                current = current.right
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Each edge traversed at most twice
- **Space:** O(1) - No stack or recursion! ⭐

---

## Approach Comparison

| Aspect | Recursive | Iterative Stack | Morris Traversal |
|--------|-----------|-----------------|------------------|
| **Time Complexity** | O(n) | O(n) | O(n) |
| **Space Complexity** | O(h) | O(h) | O(1) ⭐ |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Implementation** | Easiest | Moderate | Complex |
| **Best For** | Understanding | Interviews | Space optimization |

---

## Critical Insights

### 1. Why Inorder for BST?
```
BST property: left < root < right

Inorder traversal visits in sorted order:
        4
       / \
      2   6
     / \ / \
    1  3 5  7

Inorder: [1, 2, 3, 4, 5, 6, 7] ← Sorted!
```

### 2. Stack Simulates Recursion
```
Recursive call stack:
    inorder(4) → inorder(2) → inorder(1)

Iterative stack:
    stack = [4, 2, 1]

Both achieve same traversal order!
```

### 3. Loop Condition: current OR stack
```
while current or stack:
      ↑            ↑
      Processing   Backtracking
      new nodes    to parents

Need both:
- current: Continue going left
- stack: Backtrack when current is null
```

### 4. Morris Traversal Thread
```
Before:
    2
   /
  1

After creating thread:
    2
   / ↖
  1 ─┘

Thread allows backtracking without stack!
```

### 5. When to Visit Node?
```
Recursive: After left, before right
Iterative: After popping from stack
Morris: When no left child OR after removing thread
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Traversal Order
```python
# Wrong: Preorder (Root-Left-Right)
result.append(node.val)
inorder(node.left)
inorder(node.right)
```

### ❌ Mistake 2: Wrong Loop Condition
```python
while stack:  # Missing current check
    # Fails when current is not null but stack is empty
```

### ❌ Mistake 3: Not Moving to Right
```python
current = stack.pop()
result.append(current.val)
# Missing: current = current.right
```

### ❌ Mistake 4: Infinite Loop in Morris
```python
# Not removing thread
if predecessor.right == current:
    # Missing: predecessor.right = None
    result.append(current.val)
```

### ❌ Mistake 5: Modifying Tree in Recursive
```python
# Don't modify tree structure in recursive approach
def inorder(node):
    if node:
        node.left = None  # Wrong!
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `null` | `[]` | Empty tree |
| `[1]` | `[1]` | Single node |
| `[1,null,2]` | `[1,2]` | Right skewed |
| `[3,2,null,1]` | `[1,2,3]` | Left skewed |
| `[2,1,3]` | `[1,2,3]` | Balanced |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Binary Tree Preorder Traversal** - Root-Left-Right
2. **Binary Tree Postorder Traversal** - Left-Right-Root
3. **Validate BST** - Use inorder to check sorted
4. **Kth Smallest in BST** - Inorder gives sorted order

### Key Characteristics:
- Tree traversal
- DFS (Depth-First Search)
- Stack-based iteration
- Recursive to iterative conversion

---

## Complete Implementations

### Implementation 1: Recursive ⭐
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def inorderTraversal(root: TreeNode) -> List[int]:
    result = []
    
    def inorder(node):
        if node:
            inorder(node.left)
            result.append(node.val)
            inorder(node.right)
    
    inorder(root)
    return result
```

### Implementation 2: Iterative with Stack ⭐
```python
def inorderTraversal(root: TreeNode) -> List[int]:
    result = []
    stack = []
    current = root
    
    while current or stack:
        # Go to leftmost node
        while current:
            stack.append(current)
            current = current.left
        
        # Process node
        current = stack.pop()
        result.append(current.val)
        
        # Move to right subtree
        current = current.right
    
    return result
```

### Implementation 3: Morris Traversal
```python
def inorderTraversal(root: TreeNode) -> List[int]:
    result = []
    current = root
    
    while current:
        if not current.left:
            result.append(current.val)
            current = current.right
        else:
            # Find predecessor
            predecessor = current.left
            while predecessor.right and predecessor.right != current:
                predecessor = predecessor.right
            
            if not predecessor.right:
                # Create thread
                predecessor.right = current
                current = current.left
            else:
                # Remove thread
                predecessor.right = None
                result.append(current.val)
                current = current.right
    
    return result
```

### Implementation 4: Iterative (Alternative Style)
```python
def inorderTraversal(root: TreeNode) -> List[int]:
    result = []
    stack = []
    node = root
    
    while node or stack:
        if node:
            stack.append(node)
            node = node.left
        else:
            node = stack.pop()
            result.append(node.val)
            node = node.right
    
    return result
```

---

## Traversal Templates

### Inorder (Left-Root-Right)
```python
def inorder(node):
    if node:
        inorder(node.left)
        visit(node)
        inorder(node.right)
```

### Preorder (Root-Left-Right)
```python
def preorder(node):
    if node:
        visit(node)
        preorder(node.left)
        preorder(node.right)
```

### Postorder (Left-Right-Root)
```python
def postorder(node):
    if node:
        postorder(node.left)
        postorder(node.right)
        visit(node)
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Binary Tree Preorder Traversal** | Same structure | Root-Left-Right order |
| **Binary Tree Postorder Traversal** | Same structure | Left-Right-Root order |
| **Validate BST** | Uses inorder | Check if sorted |
| **Kth Smallest in BST** | Uses inorder | Stop at kth element |
| **Binary Tree Level Order** | Tree traversal | BFS instead of DFS |

---

## Day 49 Summary

### Problems Solved: 1
1. ✅ Binary Tree Inorder Traversal

### Key Patterns Learned:
1. **Inorder Traversal** - Left-Root-Right order
2. **Stack-Based Iteration** - Simulating recursion
3. **Morris Traversal** - O(1) space using threading

### Techniques Mastered:
- Recursive tree traversal
- Converting recursion to iteration with stack
- Threaded binary tree concept
- DFS traversal patterns

### Complexity Insights:
- All approaches: O(n) time
- Recursive/Iterative: O(h) space
- Morris: O(1) space (optimal!)
- Inorder gives sorted sequence for BST

### When to Use This Pattern:
- Tree traversal problems
- BST validation
- Finding kth element in BST
- Converting recursion to iteration

---

## Quick Reference

### Iterative Stack Template
```python
def inorderTraversal(root):
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

### Traversal Order Comparison
```
Tree:
    1
   / \
  2   3

Inorder:   [2, 1, 3] (Left-Root-Right)
Preorder:  [1, 2, 3] (Root-Left-Right)
Postorder: [2, 3, 1] (Left-Right-Root)
```

### Space Complexity Summary
```
Recursive:  O(h) - Call stack
Iterative:  O(h) - Explicit stack
Morris:     O(1) - No extra space!

where h = tree height
- Balanced: h = O(log n)
- Skewed:   h = O(n)
```
