# Day 52: Symmetric Tree

## Problem Statement
**LeetCode 101: Symmetric Tree**

Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).

**Examples:**
```
Example 1:
Input: root = [1,2,2,3,4,4,3]
Output: true

Tree:
        1
       / \
      2   2
     / \ / \
    3  4 4  3
    
Symmetric: Yes ✓

Example 2:
Input: root = [1,2,2,null,3,null,3]
Output: false

Tree:
        1
       / \
      2   2
       \   \
        3   3
        
Symmetric: No ✗ (both 3s on right side)
```

**Constraints:**
- The number of nodes in the tree is in the range [1, 1000]
- -100 <= Node.val <= 100

**Follow-up:** Could you solve it both recursively and iteratively?

---

## Problem Logic & Reasoning

### Core Concept
A tree is symmetric if its left subtree is a **mirror reflection** of its right subtree.

**Key Insight:** Two trees are mirrors if:
1. Their root values are equal
2. Left subtree of one is mirror of right subtree of other
3. Right subtree of one is mirror of left subtree of other

### Visual Understanding

```
Symmetric Tree:
        1
       / \
      2   2
     / \ / \
    3  4 4  3

Mirror check:
Left subtree:    Right subtree:
    2                2
   / \              / \
  3   4            4   3
  
Left.left (3) = Right.right (3) ✓
Left.right (4) = Right.left (4) ✓
```

### Not Symmetric Example

```
Not Symmetric:
        1
       / \
      2   2
       \   \
        3   3

Left subtree:    Right subtree:
    2                2
     \                \
      3                3
      
Left.right (3) ≠ Right.left (null) ✗
```

### The Mirror Property

```
For symmetric tree:
- Compare left.left with right.right
- Compare left.right with right.left

Pattern:
    root
   /    \
  L      R
 / \    / \
LL LR  RL RR

Check: LL=RR and LR=RL
```

---

## Approach 1: Recursive Solution ⭐

### Logic
Use a helper function to check if two trees are mirrors:
1. Base case: Both null → true
2. One null, other not → false
3. Values different → false
4. Recursively check: left.left with right.right AND left.right with right.left

### Visual Flow for [1,2,2,3,4,4,3]

```
Tree:
        1
       / \
      2   2
     / \ / \
    3  4 4  3

isMirror(left=2, right=2):
    Both not null ✓
    2 == 2 ✓
    
    Check: isMirror(left.left=3, right.right=3)
        Both not null ✓
        3 == 3 ✓
        isMirror(null, null) → true
        isMirror(null, null) → true
        Return: true
    
    Check: isMirror(left.right=4, right.left=4)
        Both not null ✓
        4 == 4 ✓
        isMirror(null, null) → true
        isMirror(null, null) → true
        Return: true
    
    Return: true AND true = true

Result: true ✓
```

### Step-by-Step Execution

```
Tree: [1,2,2,null,3,null,3]
        1
       / \
      2   2
       \   \
        3   3

isMirror(left=2, right=2):
    Both not null ✓
    2 == 2 ✓
    
    Check: isMirror(left.left=null, right.right=3)
        left is null, right is not null
        Return: false ✗

Result: false
```

### Pseudocode
```
function isSymmetric(root):
    if root is null:
        return true
    
    function isMirror(left, right):
        // Both null
        if left is null and right is null:
            return true
        
        // One null or values different
        if left is null or right is null or left.val != right.val:
            return false
        
        // Check mirror property
        return isMirror(left.left, right.right) and 
               isMirror(left.right, right.left)
    
    return isMirror(root.left, root.right)
```

### Complexity Analysis
- **Time:** O(n) - Visit each node once
- **Space:** O(h) - Recursion stack, where h = height

---

## Approach 2: Iterative with Queue ⭐

### Logic
Use a queue to store pairs of nodes to compare:
1. Start with (root.left, root.right)
2. For each pair:
   - If both null, continue
   - If one null or values different, return false
   - Add (left.left, right.right) and (left.right, right.left) to queue
3. If queue empties without false, return true

### Visual Flow for [1,2,2,3,4,4,3]

```
Tree:
        1
       / \
      2   2
     / \ / \
    3  4 4  3

Initial: queue = [(2, 2)]

Iteration 1:
    Dequeue: (2, 2)
    Both not null, 2 == 2 ✓
    Enqueue: (3, 3), (4, 4)
    queue = [(3, 3), (4, 4)]

Iteration 2:
    Dequeue: (3, 3)
    Both not null, 3 == 3 ✓
    Enqueue: (null, null), (null, null)
    queue = [(4, 4), (null, null), (null, null)]

Iteration 3:
    Dequeue: (4, 4)
    Both not null, 4 == 4 ✓
    Enqueue: (null, null), (null, null)
    queue = [(null, null), (null, null), (null, null), (null, null)]

Iteration 4-7:
    Dequeue: (null, null)
    Both null, continue
    queue = []

Queue empty → Return: true ✓
```

### Step-by-Step for [1,2,2,null,3,null,3]

```
Tree:
        1
       / \
      2   2
       \   \
        3   3

Initial: queue = [(2, 2)]

Iteration 1:
    Dequeue: (2, 2)
    Both not null, 2 == 2 ✓
    Enqueue: (null, 3), (3, null)
    queue = [(null, 3), (3, null)]

Iteration 2:
    Dequeue: (null, 3)
    left is null, right is not null
    Return: false ✗
```

### Pseudocode
```
function isSymmetric(root):
    if root is null:
        return true
    
    queue = new Queue()
    queue.enqueue((root.left, root.right))
    
    while queue is not empty:
        (left, right) = queue.dequeue()
        
        // Both null, continue
        if left is null and right is null:
            continue
        
        // One null or values different
        if left is null or right is null or left.val != right.val:
            return false
        
        // Add pairs to check
        queue.enqueue((left.left, right.right))
        queue.enqueue((left.right, right.left))
    
    return true
```

### Complexity Analysis
- **Time:** O(n) - Visit each node once
- **Space:** O(w) - Queue size, where w = max width of tree

---

## Approach Comparison

| Aspect | Recursive | Iterative |
|--------|-----------|-----------|
| **Time Complexity** | O(n) | O(n) |
| **Space Complexity** | O(h) stack | O(w) queue |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Implementation** | Simpler | More code |
| **Best For** | Understanding | Avoiding stack overflow |

---

## Critical Insights

### 1. Why Compare Left.Left with Right.Right?
```
For mirror symmetry:
    root
   /    \
  L      R

L's left child should match R's right child
L's right child should match R's left child

This creates the mirror effect!
```

### 2. Three Base Cases
```
Case 1: Both null
    return true (symmetric)

Case 2: One null, other not
    return false (not symmetric)

Case 3: Both not null but different values
    return false (not symmetric)
```

### 3. Order of Comparisons Matters
```
Correct:
    isMirror(left.left, right.right)
    isMirror(left.right, right.left)

Wrong:
    isMirror(left.left, right.left)  // Not mirror!
    isMirror(left.right, right.right)
```

### 4. Edge Case: Single Node
```
Tree: [1]
    1

No left or right subtree
isMirror(null, null) → true ✓
```

### 5. Why Use Queue (Not Stack)?
```
Queue (BFS): Level-by-level comparison
Stack (DFS): Would work but less intuitive

Both work, but queue is more natural for
comparing corresponding positions
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Comparison Order
```python
# Wrong: Comparing same sides
return isMirror(left.left, right.left) and \
       isMirror(left.right, right.right)

# Correct: Comparing opposite sides
return isMirror(left.left, right.right) and \
       isMirror(left.right, right.left)
```

### ❌ Mistake 2: Not Handling Null Cases
```python
# Wrong: Missing null checks
if left.val != right.val:
    return False  # NullPointerException if either is null!
```

### ❌ Mistake 3: Forgetting to Check Root
```python
# Wrong: Directly comparing children
return isMirror(root.left, root.right)
# Missing: if root is None: return True
```

### ❌ Mistake 4: Using OR Instead of AND
```python
# Wrong: Should be AND
return isMirror(left.left, right.right) or \
       isMirror(left.right, right.left)
```

### ❌ Mistake 5: Not Continuing on Both Null
```python
# Iterative approach
if left is None and right is None:
    return True  # Wrong! Should continue, not return
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `[1]` | `true` | Single node (symmetric) |
| `[1,2,2]` | `true` | Perfect mirror |
| `[1,2,2,3,null,null,3]` | `true` | Symmetric with nulls |
| `[1,2,2,null,3,3]` | `false` | Not mirror |
| `[1,2,2,2,null,2]` | `false` | Different structure |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Same Tree** - Check if two trees are identical
2. **Invert Binary Tree** - Create mirror of tree
3. **Subtree of Another Tree** - Compare tree structures
4. **Maximum Depth** - Tree traversal

### Key Characteristics:
- Tree comparison
- Recursive helper function
- Mirror/symmetry checking
- Simultaneous traversal of two trees

---

## Complete Implementations

### Implementation 1: Recursive ⭐
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def isSymmetric(root: Optional[TreeNode]) -> bool:
    if root is None:
        return True
    
    def isMirror(left, right):
        # Both null
        if left is None and right is None:
            return True
        
        # One null or values different
        if left is None or right is None or left.val != right.val:
            return False
        
        # Check mirror property
        return isMirror(left.left, right.right) and \
               isMirror(left.right, right.left)
    
    return isMirror(root.left, root.right)
```

### Implementation 2: Iterative with Queue ⭐
```python
from collections import deque

def isSymmetric(root: Optional[TreeNode]) -> bool:
    if root is None:
        return True
    
    queue = deque()
    queue.append((root.left, root.right))
    
    while queue:
        left, right = queue.popleft()
        
        # Both null
        if left is None and right is None:
            continue
        
        # One null or values different
        if left is None or right is None or left.val != right.val:
            return False
        
        # Add pairs to check
        queue.append((left.left, right.right))
        queue.append((left.right, right.left))
    
    return True
```

### Implementation 3: Iterative with Stack
```python
def isSymmetric(root: Optional[TreeNode]) -> bool:
    if root is None:
        return True
    
    stack = [(root.left, root.right)]
    
    while stack:
        left, right = stack.pop()
        
        if left is None and right is None:
            continue
        
        if left is None or right is None or left.val != right.val:
            return False
        
        stack.append((left.left, right.right))
        stack.append((left.right, right.left))
    
    return True
```

### Implementation 4: Recursive (Inline)
```python
def isSymmetric(root: Optional[TreeNode]) -> bool:
    def isMirror(t1, t2):
        if not t1 and not t2:
            return True
        if not t1 or not t2:
            return False
        return (t1.val == t2.val and 
                isMirror(t1.left, t2.right) and 
                isMirror(t1.right, t2.left))
    
    return isMirror(root, root) if root else True
```

---

## Visualization: Mirror Comparison

### Symmetric Tree
```
        1
       / \
      2   2
     / \ / \
    3  4 4  3

Comparisons:
1. (2, 2) ✓
2. (3, 3) ✓ (left.left vs right.right)
3. (4, 4) ✓ (left.right vs right.left)

All match → Symmetric ✓
```

### Not Symmetric Tree
```
        1
       / \
      2   2
       \   \
        3   3

Comparisons:
1. (2, 2) ✓
2. (null, 3) ✗ (left.left vs right.right)

Mismatch → Not Symmetric ✗
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Same Tree** | Tree comparison | Check if identical |
| **Invert Binary Tree** | Mirror concept | Create mirror |
| **Subtree of Another Tree** | Tree comparison | Check subtree |
| **Maximum Depth** | Tree traversal | Find depth |

---

## Day 52 Summary

### Problems Solved: 1
1. ✅ Symmetric Tree

### Key Patterns Learned:
1. **Mirror Comparison** - Comparing opposite sides of tree
2. **Recursive Helper Function** - Comparing two trees simultaneously
3. **Iterative with Queue** - BFS-style comparison

### Techniques Mastered:
- Recursive tree comparison
- Helper function pattern
- Queue-based iterative traversal
- Mirror property checking

### Complexity Insights:
- Both approaches: O(n) time
- Recursive: O(h) space (stack)
- Iterative: O(w) space (queue width)
- Trade-off: stack depth vs queue width

### When to Use This Pattern:
- Tree symmetry/mirror problems
- Comparing two trees simultaneously
- Structural tree comparison
- Tree validation problems

---

## Quick Reference

### Recursive Template
```python
def isSymmetric(root):
    def isMirror(left, right):
        if not left and not right:
            return True
        if not left or not right:
            return False
        return (left.val == right.val and
                isMirror(left.left, right.right) and
                isMirror(left.right, right.left))
    
    return isMirror(root.left, root.right) if root else True
```

### Iterative Template
```python
def isSymmetric(root):
    if not root:
        return True
    
    queue = deque([(root.left, root.right)])
    
    while queue:
        left, right = queue.popleft()
        
        if not left and not right:
            continue
        if not left or not right or left.val != right.val:
            return False
        
        queue.append((left.left, right.right))
        queue.append((left.right, right.left))
    
    return True
```

### Mirror Property
```
For symmetric tree:
- Compare left.left with right.right
- Compare left.right with right.left

Pattern:
    root
   /    \
  L      R
 / \    / \
LL LR  RL RR

Check: LL=RR and LR=RL
```

### Three Base Cases
```
1. Both null → true
2. One null → false
3. Values different → false
```
