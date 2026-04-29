# Day 62: Lowest Common Ancestor of a Binary Search Tree

## Problem Statement
**LeetCode 235: Lowest Common Ancestor of a Binary Search Tree**

Given a **binary search tree (BST)**, find the **lowest common ancestor (LCA)** node of two given nodes in the BST.

**Definition of LCA:**
The lowest common ancestor is defined between two nodes p and q as the **lowest node in T that has both p and q as descendants** (where we allow a node to be a descendant of itself).

**Examples:**
```
Example 1:
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Output: 6
Explanation: The LCA of nodes 2 and 8 is 6.

Example 2:
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: The LCA of nodes 2 and 4 is 2, since a node can be a descendant of itself.

Example 3:
Input: root = [2,1], p = 2, q = 1
Output: 2
```

**Constraints:**
- The number of nodes in the tree is in the range [2, 10⁵]
- -10⁹ <= Node.val <= 10⁹
- All Node.val are **unique**
- p != q
- p and q will exist in the BST

---

## Problem Logic & Reasoning

### Core Concept
Find the **split point** where p and q diverge into different subtrees.

**Key Insight:** Use BST property - left < root < right - to navigate efficiently!

### What is Lowest Common Ancestor?

```
LCA is the deepest node that is an ancestor of both p and q.

Example Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

LCA(2, 8) = 6
  - 6 is ancestor of both 2 and 8
  - No deeper node is ancestor of both

LCA(2, 4) = 2
  - 2 is ancestor of both 2 and 4
  - 2 is ancestor of itself!

LCA(3, 5) = 4
  - 4 is ancestor of both 3 and 5
  - Not 2 (too high), not 3 or 5 (not ancestor of both)
```

### BST Property

```
Binary Search Tree property:
- All nodes in left subtree < root
- All nodes in right subtree > root

Example:
        6
       / \
      2   8
     / \ / \
    0  4 7  9

At node 6:
  Left subtree: {0, 2, 3, 4, 5} - all < 6
  Right subtree: {7, 8, 9} - all > 6

This property helps us navigate!
```

### The Three Cases

```
Case 1: Both p and q are less than current node
  → LCA must be in LEFT subtree
  
  Example: p=2, q=4, current=6
  2 < 6 and 4 < 6
  → Go left to node 2

Case 2: Both p and q are greater than current node
  → LCA must be in RIGHT subtree
  
  Example: p=7, q=9, current=6
  7 > 6 and 9 > 6
  → Go right to node 8

Case 3: p and q are on different sides (or one equals current)
  → Current node IS the LCA!
  
  Example: p=2, q=8, current=6
  2 < 6 and 8 > 6
  → 6 is the split point, return 6
```

### Visual Understanding for p=2, q=8

```
Tree:
        6  ← Start here
       / \
      2   8
     / \ / \
    0  4 7  9

Step 1: At node 6
  p=2 < 6? Yes
  q=8 > 6? Yes
  → They're on different sides!
  → 6 is the LCA ✓

Why? Because:
- 2 is in left subtree of 6
- 8 is in right subtree of 6
- 6 is the split point
```

### Visual Understanding for p=2, q=4

```
Tree:
        6  ← Start here
       / \
      2   8
     / \ / \
    0  4 7  9

Step 1: At node 6
  p=2 < 6? Yes
  q=4 < 6? Yes
  → Both in left subtree, go left

Step 2: At node 2
  p=2 == 2? Yes (found p!)
  q=4 > 2? Yes
  → They're on different sides (one is current)
  → 2 is the LCA ✓

Why? Because:
- 2 is the current node
- 4 is in right subtree of 2
- 2 is ancestor of itself and 4
```

### Why BST Makes This Easy

```
In a regular binary tree:
- Must search entire tree
- Check if p and q are in left/right subtrees
- Time: O(n)

In a BST:
- Use BST property to navigate
- No need to search entire tree
- Just compare values!
- Time: O(h) where h = height

BST property gives us direction at each step!
```

---

## Approach 1: Recursive Solution ⭐⭐⭐⭐

### Logic
Use BST property to recursively navigate:
1. If both p and q are less than current, go left
2. If both p and q are greater than current, go right
3. Otherwise, current is the LCA

### Visual Flow for p=3, q=5

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Call 1: LCA(root=6, p=3, q=5)
  3 < 6? Yes
  5 < 6? Yes
  → Both in left subtree
  → Recurse left: LCA(root=2, p=3, q=5)

Call 2: LCA(root=2, p=3, q=5)
  3 < 2? No
  5 < 2? No
  3 > 2? Yes
  5 > 2? Yes
  → Both in right subtree
  → Recurse right: LCA(root=4, p=3, q=5)

Call 3: LCA(root=4, p=3, q=5)
  3 < 4? Yes
  5 < 4? No
  → On different sides!
  → Return 4 ✓

Result: 4
```

### Detailed Step-by-Step for p=2, q=8

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9

Call 1: LCA(root=6, p=2, q=8)
  Check: p.val < root.val and q.val < root.val?
    2 < 6 and 8 < 6?
    True and False = False
  
  Check: p.val > root.val and q.val > root.val?
    2 > 6 and 8 > 6?
    False and False = False
  
  Else: Return root
    → Return 6 ✓

Result: 6 (found in one step!)
```

### Pseudocode
```
function lowestCommonAncestor(root, p, q):
    // Base case (not needed if p and q guaranteed to exist)
    if root is None:
        return None
    
    // Case 1: Both in left subtree
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    
    // Case 2: Both in right subtree
    if p.val > root.val and q.val > root.val:
        return lowestCommonAncestor(root.right, p, q)
    
    // Case 3: Split point (or one equals root)
    return root
```

### Implementation
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        # Both in left subtree
        if p.val < root.val and q.val < root.val:
            return self.lowestCommonAncestor(root.left, p, q)
        
        # Both in right subtree
        elif p.val > root.val and q.val > root.val:
            return self.lowestCommonAncestor(root.right, p, q)
        
        # Split point or one equals root
        else:
            return root
```

### Complexity Analysis
- **Time:** O(h) - Height of tree
  - Best case (balanced): O(log n)
  - Worst case (skewed): O(n)
- **Space:** O(h) - Recursion stack

---

## Approach 2: Iterative Solution ⭐⭐⭐⭐⭐

### Logic
Same logic as recursive, but use a loop instead of recursion:
1. Start at root
2. While current node exists:
   - If both p and q are less, go left
   - If both p and q are greater, go right
   - Otherwise, return current

### Visual Flow for p=3, q=5

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Iteration 1: curr = 6
  3 < 6 and 5 < 6? Yes
  → curr = curr.left = 2

Iteration 2: curr = 2
  3 < 2 and 5 < 2? No
  3 > 2 and 5 > 2? Yes
  → curr = curr.right = 4

Iteration 3: curr = 4
  3 < 4 and 5 < 4? No
  3 > 4 and 5 > 4? No
  → Return 4 ✓

Result: 4
```

### Detailed Step-by-Step for p=0, q=5

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Iteration 1: curr = 6
  0 < 6? Yes
  5 < 6? Yes
  → Both less than 6
  → curr = curr.left = 2

Iteration 2: curr = 2
  0 < 2? Yes
  5 < 2? No
  → Not both less
  0 > 2? No
  5 > 2? Yes
  → Not both greater
  → Return 2 ✓

Result: 2
Path: 6 → 2 (found in 2 steps)
```

### Pseudocode
```
function lowestCommonAncestor(root, p, q):
    curr = root
    
    while curr is not None:
        // Both in left subtree
        if p.val < curr.val and q.val < curr.val:
            curr = curr.left
        
        // Both in right subtree
        else if p.val > curr.val and q.val > curr.val:
            curr = curr.right
        
        // Found LCA
        else:
            return curr
    
    return None  // Should never reach here if p and q exist
```

### Implementation
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        curr = root
        
        while curr:
            # Both in left subtree
            if p.val < curr.val and q.val < curr.val:
                curr = curr.left
            
            # Both in right subtree
            elif p.val > curr.val and q.val > curr.val:
                curr = curr.right
            
            # Found LCA
            else:
                return curr
        
        return None  # Should never reach if p and q exist
```

### Complexity Analysis
- **Time:** O(h) - Height of tree
  - Best case (balanced): O(log n)
  - Worst case (skewed): O(n)
- **Space:** O(1) - No recursion stack! ⭐

---

## Comparison: Recursive vs Iterative

```
Recursive:
✓ More intuitive
✓ Cleaner code
✗ Uses O(h) space for recursion stack
✗ Risk of stack overflow (but unlikely with h ≤ 10⁵)

Iterative:
✓ O(1) space (no recursion)
✓ No stack overflow risk
✓ Slightly faster (no function call overhead)
✗ Slightly less intuitive

For this problem: Iterative is better (O(1) space)
```

---

## Why This Works

### The Split Point Concept

```
LCA is the "split point" where p and q diverge.

Example: p=0, q=9
        6  ← Split point!
       / \
      2   8
     /     \
    0       9

At node 6:
  0 < 6 (left)
  9 > 6 (right)
  → They split here!

Before split:
  Both would be on same side

After split:
  They're in different subtrees
```

### Why We Don't Need to Search

```
In regular binary tree:
  Must check if p and q are in left/right subtrees
  Requires searching entire tree

In BST:
  Just compare values!
  BST property tells us where they are
  
Example: p=3, q=5, current=6
  3 < 6 → p is in left subtree (guaranteed!)
  5 < 6 → q is in left subtree (guaranteed!)
  No need to search!
```

### The Three Scenarios

```
Scenario 1: p and q both in left
        6
       /
      2
     / \
    0   4
   p=0, q=4

At 6: Both < 6, go left
At 2: 0 < 2, 4 > 2, split! Return 2

Scenario 2: p and q both in right
        6
         \
          8
         / \
        7   9
       p=7, q=9

At 6: Both > 6, go right
At 8: 7 < 8, 9 > 8, split! Return 8

Scenario 3: p and q on different sides
        6
       / \
      2   8
     p=2, q=8

At 6: 2 < 6, 8 > 6, split! Return 6
```

---

## Complete Example Walkthroughs

### Example 1: p=3, q=5 (Both in same subtree)

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Iterative approach:

Step 1: curr = 6
  3 < 6 and 5 < 6? Yes
  → curr = 2

Step 2: curr = 2
  3 < 2 and 5 < 2? No
  3 > 2 and 5 > 2? Yes
  → curr = 4

Step 3: curr = 4
  3 < 4 and 5 < 4? No
  3 > 4 and 5 > 4? No
  → Return 4 ✓

Path taken: 6 → 2 → 4
```

### Example 2: p=2, q=8 (On different sides)

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9

Iterative approach:

Step 1: curr = 6
  2 < 6 and 8 < 6? No (8 is not < 6)
  2 > 6 and 8 > 6? No (2 is not > 6)
  → Return 6 ✓

Path taken: 6 (found immediately!)
```

### Example 3: p=2, q=4 (One is ancestor of other)

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9

Iterative approach:

Step 1: curr = 6
  2 < 6 and 4 < 6? Yes
  → curr = 2

Step 2: curr = 2
  2 < 2 and 4 < 2? No (2 is not < 2)
  2 > 2 and 4 > 2? No (2 is not > 2)
  → Return 2 ✓

Path taken: 6 → 2

Note: 2 is ancestor of itself!
```

---

## Critical Insights

### 1. BST Property is Key

```
Without BST property:
  Must search entire tree
  Check if p and q in left/right subtrees
  Time: O(n)

With BST property:
  Just compare values
  Navigate directly to LCA
  Time: O(h)

The BST property reduces search space dramatically!
```

### 2. Why We Can Compare Values Directly

```
BST guarantees:
  All left descendants < root < All right descendants

So if p.val < root.val:
  → p MUST be in left subtree (no need to search!)

If p.val > root.val:
  → p MUST be in right subtree (no need to search!)

This is why we can navigate without searching!
```

### 3. The "Else" Case Covers Multiple Scenarios

```
The else case handles:

Scenario A: p < root < q
  Example: p=2, root=6, q=8
  → Split point

Scenario B: q < root < p
  Example: q=2, root=6, p=8
  → Split point

Scenario C: p == root
  Example: p=6, root=6, q=8
  → root is ancestor of itself

Scenario D: q == root
  Example: p=2, root=6, q=6
  → root is ancestor of itself

All these mean: current node is the LCA!
```

### 4. Why Height Matters

```
Balanced BST:
  Height = O(log n)
  Time = O(log n)
  
  Example: 1000 nodes
  Height ≈ 10
  Only 10 comparisons needed!

Skewed BST:
  Height = O(n)
  Time = O(n)
  
  Example: 1000 nodes in a line
  Height = 1000
  Might need 1000 comparisons

BST balance affects performance!
```

### 5. Node Can Be Ancestor of Itself

```
Important: A node is considered its own descendant!

Example: p=2, q=4
        6
       /
      2
       \
        4

LCA(2, 4) = 2

Why? Because:
- 2 is ancestor of 2 (itself)
- 2 is ancestor of 4
- 2 is the lowest such node

This is why we check "else" (not just split points)
```

---

## Common Mistakes

### ❌ Mistake 1: Checking Equality Separately

```python
# Wrong: Unnecessary complexity
if p.val == root.val or q.val == root.val:
    return root
elif p.val < root.val and q.val < root.val:
    return lowestCommonAncestor(root.left, p, q)
elif p.val > root.val and q.val > root.val:
    return lowestCommonAncestor(root.right, p, q)

# Correct: Else handles equality
if p.val < root.val and q.val < root.val:
    return lowestCommonAncestor(root.left, p, q)
elif p.val > root.val and q.val > root.val:
    return lowestCommonAncestor(root.right, p, q)
else:  # Handles equality and split
    return root
```

### ❌ Mistake 2: Using OR Instead of AND

```python
# Wrong: Goes left if EITHER is less
if p.val < root.val or q.val < root.val:
    return lowestCommonAncestor(root.left, p, q)

# Problem: If p=2, q=8, root=6
# 2 < 6 is True, so goes left
# But q=8 is in right subtree!

# Correct: Both must be less
if p.val < root.val and q.val < root.val:
    return lowestCommonAncestor(root.left, p, q)
```

### ❌ Mistake 3: Comparing Node Objects Instead of Values

```python
# Wrong: Compares object references
if p < root and q < root:
    return lowestCommonAncestor(root.left, p, q)

# Correct: Compare values
if p.val < root.val and q.val < root.val:
    return lowestCommonAncestor(root.left, p, q)
```

### ❌ Mistake 4: Not Handling Base Case (If Needed)

```python
# If p and q might not exist:
def lowestCommonAncestor(root, p, q):
    # Missing: if not root: return None
    
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    # ... might crash if root is None

# Correct: Check for None
def lowestCommonAncestor(root, p, q):
    if not root:
        return None
    # ... rest of code
```

### ❌ Mistake 5: Forgetting This is BST-Specific

```python
# This solution ONLY works for BST!
# For regular binary tree, need different approach

# BST: Can compare values
if p.val < root.val and q.val < root.val:
    # ...

# Regular tree: Must search both subtrees
left = lowestCommonAncestor(root.left, p, q)
right = lowestCommonAncestor(root.right, p, q)
# ... more complex logic
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `p=root, q=any` | `root` | Root is ancestor of itself |
| `p=any, q=root` | `root` | Root is ancestor of itself |
| `p and q in same subtree` | `Node in that subtree` | Navigate to subtree |
| `p and q on different sides` | `Current node` | Split point |
| `p is ancestor of q` | `p` | p is ancestor of itself and q |
| `q is ancestor of p` | `q` | q is ancestor of itself and p |

---

## Comparison: BST vs Regular Binary Tree

### BST LCA (This Problem)

```python
def lowestCommonAncestor(root, p, q):
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    elif p.val > root.val and q.val > root.val:
        return lowestCommonAncestor(root.right, p, q)
    else:
        return root

Time: O(h)
Space: O(h) recursive, O(1) iterative
```

### Regular Binary Tree LCA (LeetCode 236)

```python
def lowestCommonAncestor(root, p, q):
    if not root or root == p or root == q:
        return root
    
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    
    if left and right:
        return root
    
    return left if left else right

Time: O(n) - Must search entire tree
Space: O(h) - Recursion stack
```

**Key Difference:**
- BST: Use value comparison to navigate
- Regular: Must search both subtrees

---

## Visualization: Path to LCA

### Example: p=0, q=9

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9

Path for p=0:
6 → 2 → 0

Path for q=9:
6 → 8 → 9

Common path:
6 (only node in both paths)

LCA = 6 (last common node)
```

### Example: p=3, q=5

```
Tree:
        6
       / \
      2   8
     / \ / \
    0  4 7  9
      / \
     3   5

Path for p=3:
6 → 2 → 4 → 3

Path for q=5:
6 → 2 → 4 → 5

Common path:
6 → 2 → 4

LCA = 4 (last common node)
```

---

## Pattern Recognition

### This Pattern Applies To:

1. **LCA of Binary Tree (LeetCode 236)**
```python
# Similar but for regular binary tree
# Must search both subtrees
def lowestCommonAncestor(root, p, q):
    if not root or root == p or root == q:
        return root
    
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    
    if left and right:
        return root
    
    return left if left else right
```

2. **Search in BST (LeetCode 700)**
```python
# Similar navigation logic
def searchBST(root, val):
    if not root:
        return None
    
    if val < root.val:
        return searchBST(root.left, val)
    elif val > root.val:
        return searchBST(root.right, val)
    else:
        return root
```

3. **Insert into BST (LeetCode 701)**
```python
# Similar navigation logic
def insertIntoBST(root, val):
    if not root:
        return TreeNode(val)
    
    if val < root.val:
        root.left = insertIntoBST(root.left, val)
    else:
        root.right = insertIntoBST(root.right, val)
    
    return root
```

### Key Characteristics:
- Use BST property for navigation
- Compare values to decide direction
- O(h) time complexity
- Can be done iteratively with O(1) space

---

## Performance Analysis

### Time Complexity by Tree Shape

```
Balanced BST:
        4
       / \
      2   6
     / \ / \
    1  3 5  7

Height = log n
Time = O(log n)
For n=1000: ~10 steps

Skewed BST:
    1
     \
      2
       \
        3
         \
          4

Height = n
Time = O(n)
For n=1000: ~1000 steps

Average case: O(log n)
Worst case: O(n)
```

### Space Complexity

```
Recursive:
  Space = O(h) for call stack
  Balanced: O(log n)
  Skewed: O(n)

Iterative:
  Space = O(1)
  No call stack!
  
Iterative is better for space!
```

---

## Complete Implementations

### Implementation 1: Recursive ⭐⭐⭐⭐
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        # Both in left subtree
        if p.val < root.val and q.val < root.val:
            return self.lowestCommonAncestor(root.left, p, q)
        
        # Both in right subtree
        elif p.val > root.val and q.val > root.val:
            return self.lowestCommonAncestor(root.right, p, q)
        
        # Split point or one equals root
        else:
            return root
```

### Implementation 2: Iterative (Recommended) ⭐⭐⭐⭐⭐
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        curr = root
        
        while curr:
            # Both in left subtree
            if p.val < curr.val and q.val < curr.val:
                curr = curr.left
            
            # Both in right subtree
            elif p.val > curr.val and q.val > curr.val:
                curr = curr.right
            
            # Found LCA
            else:
                return curr
        
        return None
```

### Implementation 3: Recursive with Explicit Checks
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        # Base case
        if not root:
            return None
        
        # Ensure p.val <= q.val for simplicity
        if p.val > q.val:
            p, q = q, p
        
        # Both in left subtree
        if q.val < root.val:
            return self.lowestCommonAncestor(root.left, p, q)
        
        # Both in right subtree
        elif p.val > root.val:
            return self.lowestCommonAncestor(root.right, p, q)
        
        # p <= root <= q (split point)
        else:
            return root
```

### Implementation 4: Iterative with Min/Max
```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        # Get min and max values
        min_val = min(p.val, q.val)
        max_val = max(p.val, q.val)
        
        curr = root
        
        while curr:
            # Both in left subtree
            if max_val < curr.val:
                curr = curr.left
            
            # Both in right subtree
            elif min_val > curr.val:
                curr = curr.right
            
            # Found LCA
            else:
                return curr
        
        return None
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **LCA of Binary Tree (LC 236)** | Find LCA | Regular tree, must search both subtrees |
| **Search in BST (LC 700)** | BST navigation | Search for single value |
| **Insert into BST (LC 701)** | BST navigation | Insert new node |
| **Delete Node in BST (LC 450)** | BST navigation | Delete and restructure |
| **Validate BST (LC 98)** | BST property | Check if valid BST |

---

## Day 62 Summary

### Problems Solved: 1
1. ✅ Lowest Common Ancestor of a Binary Search Tree

### Key Patterns Learned:
1. **BST Navigation** - Use value comparison to navigate
2. **Split Point Detection** - Find where paths diverge
3. **Iterative Optimization** - O(1) space solution
4. **BST Property Usage** - Left < Root < Right

### Techniques Mastered:
- BST property for efficient navigation
- Recursive and iterative approaches
- Split point detection
- O(h) time complexity
- O(1) space optimization

### Complexity Insights:
- Time: O(h) - Height of tree
  - Balanced: O(log n)
  - Skewed: O(n)
- Space: O(h) recursive, O(1) iterative
- Iterative is better for space

### When to Use This Pattern:
- BST navigation problems
- Finding split points
- Ancestor/descendant relationships
- Path-based queries in BST

---

## Quick Reference

### Iterative Template (Recommended)
```python
def lowestCommonAncestor(root, p, q):
    curr = root
    
    while curr:
        # Both in left
        if p.val < curr.val and q.val < curr.val:
            curr = curr.left
        
        # Both in right
        elif p.val > curr.val and q.val > curr.val:
            curr = curr.right
        
        # Found LCA
        else:
            return curr
    
    return None
```

### Recursive Template
```python
def lowestCommonAncestor(root, p, q):
    # Both in left
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    
    # Both in right
    elif p.val > root.val and q.val > root.val:
        return lowestCommonAncestor(root.right, p, q)
    
    # Found LCA
    else:
        return root
```

### Key Decision Logic
```
If both < current: Go left
If both > current: Go right
Otherwise: Current is LCA
```

### BST Property
```
Left subtree < Root < Right subtree

This allows O(h) navigation without searching!
```

---

## Interview Tips

**If asked about LCA in BST:**

1. **Clarify the problem**
   - "Is this a Binary Search Tree?"
   - "Are p and q guaranteed to exist?"
   - "Can a node be ancestor of itself?"

2. **Explain BST advantage**
   - "BST property lets us navigate efficiently"
   - "Don't need to search entire tree"
   - "Just compare values to decide direction"

3. **Walk through example**
   ```
   Tree: [6,2,8,0,4,7,9]
   p=2, q=8
   
   At 6: 2 < 6, 8 > 6
   → Different sides, return 6
   ```

4. **Code it up**
   - Start with iterative (O(1) space)
   - Use while loop
   - Three cases: both left, both right, else

5. **Mention optimization**
   - "Iterative uses O(1) space"
   - "Recursive uses O(h) space"
   - "Time is O(h) for both"

6. **Test edge cases**
   - p or q is root
   - p is ancestor of q
   - Both in same subtree

**Time to explain:** 5-7 minutes

---

## Key Takeaways

1. **BST property is key** - Enables O(h) navigation
2. **Three cases** - Both left, both right, or split
3. **Iterative is better** - O(1) space vs O(h)
4. **Split point concept** - Where paths diverge
5. **Node can be ancestor of itself** - Important edge case
6. **Compare values, not nodes** - Use .val
7. **Much simpler than regular tree** - BST property helps!

---

## Bonus: Comparison Table

| Aspect | BST LCA | Regular Tree LCA |
|--------|---------|------------------|
| **Time** | O(h) | O(n) |
| **Space** | O(1) iterative | O(h) recursive only |
| **Navigation** | Value comparison | Must search both |
| **Complexity** | Simple | More complex |
| **Key Property** | BST ordering | None |

---

## Visual Summary

```
BST LCA Algorithm:

        6
       / \
      2   8
     / \ / \
    0  4 7  9

Decision at each node:
┌─────────────────────────────┐
│ Both p,q < current?         │
│   → Go LEFT                 │
├─────────────────────────────┤
│ Both p,q > current?         │
│   → Go RIGHT                │
├─────────────────────────────┤
│ Otherwise?                  │
│   → FOUND LCA!              │
└─────────────────────────────┘

Time: O(h)
Space: O(1) iterative, O(h) recursive
```

---

**End of Day 62 Notes**

*Master LCA in BST and you've mastered BST navigation!* 🎯
