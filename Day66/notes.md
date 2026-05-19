# Day 66: Construct Binary Tree from Preorder and Inorder Traversal (LeetCode #105)

## Part 1: Problem Statement & Core Logic

### Problem Statement
Given two integer arrays **preorder** and **inorder** where:
- **preorder** is the preorder traversal of a binary tree
- **inorder** is the inorder traversal of the same tree

Construct and return the binary tree.

**Key Constraints:**
- 1 <= preorder.length <= 3000
- inorder.length == preorder.length
- -3000 <= preorder[i], inorder[i] <= 3000
- preorder and inorder consist of **unique values**
- Each value of inorder also appears in preorder
- Both arrays represent valid traversals of the same tree

### Examples

**Example 1:**
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]

Tree:
      3
     / \
    9   20
       /  \
      15   7
```

**Example 2:**
```
Input: preorder = [-1], inorder = [-1]
Output: [-1]

Tree: -1
```

---

## Core Logic: Understanding Traversals

### 🔑 The Key Insight

**Preorder:** Root → Left → Right
**Inorder:** Left → Root → Right

**Magic Combination:**
1. **Preorder's first element** = Root of tree/subtree
2. **Find root in inorder** → splits into left and right subtrees
3. **Recursively build** left and right subtrees

```
preorder = [3, 9, 20, 15, 7]
           ↑
         ROOT

inorder = [9, 3, 15, 20, 7]
          ↑   ↑   ↑
        LEFT ROOT RIGHT

Left subtree: [9]
Right subtree: [15, 20, 7]
```

---

## Visual Understanding

### Example: [3,9,20,15,7] and [9,3,15,20,7]

```
Step 1: Find root
preorder[0] = 3 → ROOT

Step 2: Find root in inorder
inorder = [9, | 3 | 15, 20, 7]
          LEFT  ROOT  RIGHT

Step 3: Split into subtrees
Left inorder: [9]
Right inorder: [15, 20, 7]

Step 4: Build tree
      3
     / \
    ?   ?

Step 5: Recursively build left subtree
preorder for left: [9]
inorder for left: [9]
→ Single node: 9

Step 6: Recursively build right subtree
preorder for right: [20, 15, 7]
inorder for right: [15, 20, 7]

Root = 20
inorder = [15, | 20 | 7]
         LEFT  ROOT  RIGHT

Final tree:
      3
     / \
    9   20
       /  \
      15   7
```

---

## The Algorithm Pattern

### Three Key Components:

#### 1. **Preorder Index Tracking**
```python
preorder_index = 0  # Tracks current root in preorder

# Each time we create a node:
root_val = preorder[preorder_index]
preorder_index += 1
```

#### 2. **Inorder Map for O(1) Lookup**
```python
inorder_map = {value: index for index, value in enumerate(inorder)}

# Find root position in O(1):
mid = inorder_map[root_val]
```

#### 3. **Recursive Range Building**
```python
def build(left, right):
    if left > right:
        return None
    
    # Create root from preorder
    root = TreeNode(preorder[preorder_index])
    preorder_index += 1
    
    # Find split point in inorder
    mid = inorder_map[root.val]
    
    # Build subtrees
    root.left = build(left, mid - 1)
    root.right = build(mid + 1, right)
    
    return root
```

---

## Detailed Walkthrough

### Example: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]

```
inorder_map = {9:0, 3:1, 15:2, 20:3, 7:4}
preorder_index = 0

Call: build(0, 4)
├─ left=0, right=4 (valid)
├─ root_val = preorder[0] = 3
├─ preorder_index = 1
├─ mid = inorder_map[3] = 1
├─ Create node(3)
│
├─ Build left: build(0, 0)
│  ├─ left=0, right=0 (valid)
│  ├─ root_val = preorder[1] = 9
│  ├─ preorder_index = 2
│  ├─ mid = inorder_map[9] = 0
│  ├─ Create node(9)
│  │
│  ├─ Build left: build(0, -1)
│  │  └─ left > right → return None
│  │
│  └─ Build right: build(1, 0)
│     └─ left > right → return None
│  
│  Return node(9)
│
└─ Build right: build(2, 4)
   ├─ left=2, right=4 (valid)
   ├─ root_val = preorder[2] = 20
   ├─ preorder_index = 3
   ├─ mid = inorder_map[20] = 3
   ├─ Create node(20)
   │
   ├─ Build left: build(2, 2)
   │  ├─ root_val = preorder[3] = 15
   │  ├─ preorder_index = 4
   │  ├─ Create node(15)
   │  └─ Return node(15)
   │
   └─ Build right: build(4, 4)
      ├─ root_val = preorder[4] = 7
      ├─ preorder_index = 5
      ├─ Create node(7)
      └─ Return node(7)
   
   Return node(20) with children

Final tree:
      3
     / \
    9   20
       /  \
      15   7
```

---

## Why This Works: The Math

### Preorder Sequence
```
[Root] [Left Subtree] [Right Subtree]
```

### Inorder Sequence
```
[Left Subtree] [Root] [Right Subtree]
```

### The Key Relationships:

1. **Root identification:**
   - Preorder[0] = Root

2. **Subtree sizes:**
   - Find root in inorder at index `mid`
   - Left subtree size = `mid - left`
   - Right subtree size = `right - mid`

3. **Preorder consumption:**
   - Process preorder left-to-right
   - Each recursive call consumes next element
   - Order: Root → All Left → All Right

```
Example visualization:

preorder = [3, 9, 20, 15, 7]
           ↑  ↑  ↑   ↑   ↑
           1  2  3   4   5  (order of processing)

inorder = [9, 3, 15, 20, 7]
          L  R  L   R   R
          
Processing order matches preorder!
```

---

## Two Approaches

### Approach 1: Recursive with HashMap (Optimal - Your Solution)
**Idea:** Use preorder index + inorder map + recursive range building

**Pros:**
- ✅ O(n) time with O(1) lookups
- ✅ Clean and intuitive
- ✅ O(n) space for map + O(h) for recursion

**Cons:**
- Requires understanding of recursion

---

### Approach 2: Iterative with Stack
**Idea:** Use stack to simulate recursion

**Pros:**
- ✅ No recursion
- ✅ Explicit control

**Cons:**
- ❌ More complex logic
- ❌ Harder to understand

---

## The Inorder Map Optimization

### Without Map: O(n²) Time
```python
def build(left, right):
    # Find root in inorder - O(n) search
    mid = inorder.index(root_val, left, right + 1)
    # ... rest of code
```
- Each node: O(n) search
- Total: O(n²)

### With Map: O(n) Time
```python
inorder_map = {value: index for index, value in enumerate(inorder)}

def build(left, right):
    # Find root in inorder - O(1) lookup
    mid = inorder_map[root_val]
    # ... rest of code
```
- Preprocessing: O(n)
- Each node: O(1) lookup
- Total: O(n)

**This optimization is CRITICAL!**


## Part 2: Optimal Solution - Recursive with HashMap

### The Algorithm (Your Solution)

```python
from typing import Optional, List

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        """
        Construct binary tree from preorder and inorder traversals.
        
        Time: O(n) where n is number of nodes
        Space: O(n) for hashmap + O(h) for recursion
        """
        # Build hashmap for O(1) inorder lookups
        inorder_map = {value: index for index, value in enumerate(inorder)}
        preorder_index = 0
        
        def build(left, right):
            nonlocal preorder_index
            
            # Base case: invalid range
            if left > right:
                return None
            
            # Get root value from preorder
            root_val = preorder[preorder_index]
            root = TreeNode(root_val)
            preorder_index += 1
            
            # Find root position in inorder
            mid = inorder_map[root_val]
            
            # Build left and right subtrees
            root.left = build(left, mid - 1)
            root.right = build(mid + 1, right)
            
            return root
        
        return build(0, len(inorder) - 1)
```

---

### Why This Works: Line-by-Line Breakdown

#### 1. **Inorder Map Creation**
```python
inorder_map = {value: index for index, value in enumerate(inorder)}
```
- Creates {value → index} mapping
- Example: [9,3,15,20,7] → {9:0, 3:1, 15:2, 20:3, 7:4}
- Enables O(1) lookup instead of O(n) search
- **Critical optimization!**

#### 2. **Preorder Index Tracking**
```python
preorder_index = 0
```
- Tracks current position in preorder array
- Increments as we create nodes
- Ensures we process preorder left-to-right

#### 3. **nonlocal Declaration**
```python
nonlocal preorder_index
```
- Allows inner function to modify outer variable
- Maintains single counter across all recursive calls
- Alternative: use class variable or return tuple

#### 4. **Base Case**
```python
if left > right:
    return None
```
- Invalid range means no nodes to process
- Returns None for leaf children
- Prevents infinite recursion

#### 5. **Root Creation**
```python
root_val = preorder[preorder_index]
root = TreeNode(root_val)
preorder_index += 1
```
- Get next root from preorder
- Create node immediately
- Increment index for next call

#### 6. **Find Split Point**
```python
mid = inorder_map[root_val]
```
- O(1) lookup of root position in inorder
- Splits inorder into left and right subtrees
- Left: [left, mid-1], Right: [mid+1, right]

#### 7. **Recursive Building**
```python
root.left = build(left, mid - 1)
root.right = build(mid + 1, right)
```
- Build left subtree first (matches preorder!)
- Then build right subtree
- Order matters: preorder is Root → Left → Right

---

## Detailed Execution: [3,9,20,15,7] and [9,3,15,20,7]

### Setup
```python
preorder = [3, 9, 20, 15, 7]
inorder = [9, 3, 15, 20, 7]
inorder_map = {9:0, 3:1, 15:2, 20:3, 7:4}
preorder_index = 0
```

### Execution Trace

```
═══════════════════════════════════════════════════════
Call 1: build(0, 4)
───────────────────────────────────────────────────────
left=0, right=4 → valid
preorder_index=0 → root_val=3
Create TreeNode(3)
preorder_index=1
mid = inorder_map[3] = 1

Tree so far:
    3
   / \
  ?   ?

Recurse left: build(0, 0)
Recurse right: build(2, 4)

═══════════════════════════════════════════════════════
Call 2: build(0, 0) [Left subtree of 3]
───────────────────────────────────────────────────────
left=0, right=0 → valid
preorder_index=1 → root_val=9
Create TreeNode(9)
preorder_index=2
mid = inorder_map[9] = 0

Tree so far:
    3
   / \
  9   ?

Recurse left: build(0, -1) → None
Recurse right: build(1, 0) → None

Return TreeNode(9)

═══════════════════════════════════════════════════════
Call 3: build(2, 4) [Right subtree of 3]
───────────────────────────────────────────────────────
left=2, right=4 → valid
preorder_index=2 → root_val=20
Create TreeNode(20)
preorder_index=3
mid = inorder_map[20] = 3

Tree so far:
    3
   / \
  9   20
     /  \
    ?    ?

Recurse left: build(2, 2)
Recurse right: build(4, 4)

═══════════════════════════════════════════════════════
Call 4: build(2, 2) [Left subtree of 20]
───────────────────────────────────────────────────────
left=2, right=2 → valid
preorder_index=3 → root_val=15
Create TreeNode(15)
preorder_index=4
mid = inorder_map[15] = 2

Tree so far:
    3
   / \
  9   20
     /  \
   15    ?

Recurse left: build(2, 1) → None
Recurse right: build(3, 2) → None

Return TreeNode(15)

═══════════════════════════════════════════════════════
Call 5: build(4, 4) [Right subtree of 20]
───────────────────────────────────────────────────────
left=4, right=4 → valid
preorder_index=4 → root_val=7
Create TreeNode(7)
preorder_index=5
mid = inorder_map[7] = 4

Final tree:
    3
   / \
  9   20
     /  \
   15    7

Recurse left: build(4, 3) → None
Recurse right: build(5, 4) → None

Return TreeNode(7)

═══════════════════════════════════════════════════════
Final Result:
      3
     / \
    9   20
       /  \
      15   7
```

---

## Complexity Analysis

### Time Complexity: O(n)

**Operations:**
1. Build inorder_map: O(n)
2. Each node visited once: O(n)
3. Each lookup in map: O(1)
4. Total: O(n) + n × O(1) = O(n)

**Without map:** O(n²) due to O(n) search per node

### Space Complexity: O(n)

**Components:**
1. inorder_map: O(n)
2. Recursion stack: O(h) where h is height
   - Balanced tree: O(log n)
   - Skewed tree: O(n)
3. Total: O(n) + O(h) = O(n)

---

## Edge Cases

### 1. Single Node
```python
preorder = [1]
inorder = [1]

Result: TreeNode(1)
```

### 2. Left-Skewed Tree
```python
preorder = [3, 2, 1]
inorder = [1, 2, 3]

Tree:   3
       /
      2
     /
    1
```

### 3. Right-Skewed Tree
```python
preorder = [1, 2, 3]
inorder = [1, 2, 3]

Tree: 1
       \
        2
         \
          3
```

### 4. Complete Binary Tree
```python
preorder = [1, 2, 4, 5, 3, 6, 7]
inorder = [4, 2, 5, 1, 6, 3, 7]

Tree:       1
          /   \
         2     3
        / \   / \
       4   5 6   7
```

### 5. Empty Tree
```python
preorder = []
inorder = []

Result: None (handled by left > right check)
```

---

## Visualization: Preorder Index Movement

```
preorder = [3, 9, 20, 15, 7]
           ↑
         index=0, create 3

preorder = [3, 9, 20, 15, 7]
              ↑
            index=1, create 9

preorder = [3, 9, 20, 15, 7]
                 ↑
               index=2, create 20

preorder = [3, 9, 20, 15, 7]
                    ↑
                  index=3, create 15

preorder = [3, 9, 20, 15, 7]
                        ↑
                      index=4, create 7

Order of node creation: 3 → 9 → 20 → 15 → 7
This is exactly the preorder traversal!
```

---

## Comparison: With vs Without HashMap

### Without HashMap (Naive)
```python
def build(left, right):
    if left > right:
        return None
    
    root_val = preorder[preorder_index]
    root = TreeNode(root_val)
    preorder_index += 1
    
    # O(n) search!
    mid = inorder.index(root_val, left, right + 1)
    
    root.left = build(left, mid - 1)
    root.right = build(mid + 1, right)
    return root
```

| Aspect | Without HashMap | With HashMap |
|--------|----------------|--------------|
| **Time** | O(n²) | O(n) |
| **Space** | O(h) | O(n) + O(h) |
| **Lookup** | O(n) per node | O(1) per node |
| **Preprocessing** | None | O(n) |
| **Interview** | ❌ Too slow | ✅ Expected |


## Part 3: Critical Insights & Common Mistakes

### 🔑 Critical Insights

#### 1. **Traversal Order Matters**
```
Preorder: Root → Left → Right
Inorder: Left → Root → Right

Why this combination works:
- Preorder tells us WHAT the root is
- Inorder tells us WHERE to split left/right
- Together they uniquely define the tree
```

**Important:** You need TWO traversals to reconstruct a tree!
- Preorder + Inorder ✅
- Postorder + Inorder ✅
- Preorder + Postorder ❌ (not unique without inorder)

#### 2. **The HashMap is Essential**
```python
# ❌ O(n²) - Too slow
mid = inorder.index(root_val)

# ✅ O(n) - Optimal
inorder_map = {val: idx for idx, val in enumerate(inorder)}
mid = inorder_map[root_val]
```

**Why it matters:**
- Without map: n nodes × O(n) search = O(n²)
- With map: n nodes × O(1) lookup = O(n)
- For n=3000, this is 3000× vs 3000 operations!

#### 3. **Preorder Index Must Be Shared**
```python
# ✅ CORRECT: nonlocal
preorder_index = 0
def build(left, right):
    nonlocal preorder_index
    # All calls share same index

# ❌ WRONG: parameter
def build(left, right, index):
    # Each call has its own copy!
```

The index must increment globally across all recursive calls.

#### 4. **Build Order: Left Before Right**
```python
# ✅ CORRECT: Matches preorder
root.left = build(left, mid - 1)
root.right = build(mid + 1, right)

# ❌ WRONG: Violates preorder
root.right = build(mid + 1, right)
root.left = build(left, mid - 1)
```

Preorder is Root → **Left** → Right, so we must build left first!

#### 5. **Range Boundaries Are Inclusive**
```python
# Initial call
build(0, len(inorder) - 1)

# Left subtree
build(left, mid - 1)  # Excludes mid

# Right subtree
build(mid + 1, right)  # Excludes mid

# Base case
if left > right:  # Empty range
    return None
```

---

### ❌ Common Mistakes

#### Mistake 1: Not Using HashMap
```python
# ❌ WRONG: O(n²) time
def build(left, right):
    root_val = preorder[preorder_index]
    mid = inorder.index(root_val)  # O(n) search every time!
```

**Problem:** TLE (Time Limit Exceeded) for large inputs

**Fix:** Precompute inorder_map

---

#### Mistake 2: Passing Index as Parameter
```python
# ❌ WRONG
def build(left, right, preorder_index):
    root_val = preorder[preorder_index]
    root = TreeNode(root_val)
    preorder_index += 1  # Only modifies local copy!
    
    root.left = build(left, mid - 1, preorder_index)
    root.right = build(mid + 1, right, preorder_index)
```

**Problem:** Each recursive call gets its own copy of index

**Fix:** Use nonlocal or class variable

---

#### Mistake 3: Building Right Before Left
```python
# ❌ WRONG: Violates preorder
root.right = build(mid + 1, right)
root.left = build(left, mid - 1)
```

**Problem:** Consumes preorder elements in wrong order

**Example:**
```
preorder = [3, 9, 20, 15, 7]
If we build right first:
- Create 3 (index 0)
- Try to build right with 9 (index 1) ← WRONG!
- 9 should be in left subtree
```

**Fix:** Always build left before right

---

#### Mistake 4: Off-by-One in Range
```python
# ❌ WRONG
root.left = build(left, mid)      # Includes mid!
root.right = build(mid, right)    # Includes mid!

# ❌ WRONG
if left >= right:  # Should be left > right
    return None
```

**Problem:** Includes root in subtrees or wrong base case

**Fix:** Use mid-1 and mid+1, check left > right

---

#### Mistake 5: Not Handling Empty Input
```python
# ❌ WRONG: Crashes on empty input
def buildTree(preorder, inorder):
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    preorder_index = 0
    
    def build(left, right):
        # ... no check for empty arrays
```

**Problem:** Crashes when preorder/inorder are empty

**Fix:** Base case `if left > right` handles this naturally

---

### 🎯 Pattern Recognition

This problem teaches the **"Tree Reconstruction from Traversals"** pattern:

#### Similar Problems:

1. **Construct Binary Tree from Inorder and Postorder** (LeetCode #106)
   - Postorder: Left → Right → Root
   - Root is at END of postorder
   - Build right subtree first!

2. **Construct Binary Search Tree from Preorder** (LeetCode #1008)
   - Only need preorder (BST property gives inorder)
   - Use BST property to split

3. **Serialize and Deserialize Binary Tree** (LeetCode #297)
   - Convert tree to string and back
   - Similar reconstruction logic

4. **Verify Preorder Serialization** (LeetCode #331)
   - Check if preorder string is valid
   - Understanding traversal order

---

### 🔍 Why Two Traversals Are Needed

#### Can We Use Just One Traversal?

**Preorder alone:** ❌ Not unique
```
preorder = [1, 2, 3]

Could be:
    1           1
     \         /
      2       2
       \       \
        3       3

Or many other trees!
```

**Inorder alone:** ❌ Not unique
```
inorder = [1, 2, 3]

Could be:
    1           3
     \         /
      2       2
       \     /
        3   1

Or many other trees!
```

**Preorder + Inorder:** ✅ Unique!
```
preorder = [1, 2, 3]
inorder = [1, 2, 3]

Only one tree:
    1
     \
      2
       \
        3
```

---

### 📊 Visual: How Ranges Work

```
Example: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]

Initial: build(0, 4)
inorder: [9, 3, 15, 20, 7]
          0  1  2   3   4
          
Root = 3 at index 1

Left subtree: build(0, 0)
inorder: [9]
          0
          
Right subtree: build(2, 4)
inorder: [15, 20, 7]
          2   3   4

For right subtree, root = 20 at index 3:

Left: build(2, 2)
inorder: [15]
          2

Right: build(4, 4)
inorder: [7]
          4
```

---

### 🧠 Mental Model

Think of this as **"Divide and Conquer with Two Views"**:

```
Preorder view: "I'll tell you the roots in order"
[3, 9, 20, 15, 7]
 ↑  ↑  ↑   ↑   ↑
 1st 2nd 3rd 4th 5th root to create

Inorder view: "I'll tell you where to split"
[9, | 3 | 15, 20, 7]
 L    R    L   R   R

Combined: Build tree by:
1. Get next root from preorder
2. Find it in inorder to split
3. Recursively build left and right
```

---

### 🔍 Debugging Tips

**If your solution doesn't work:**

1. **Print preorder_index**
```python
print(f"Creating node {root_val}, index={preorder_index}")
```
Should increment: 0, 1, 2, 3, ...

2. **Print ranges**
```python
print(f"build({left}, {right}), mid={mid}")
```
Check if ranges make sense

3. **Verify inorder_map**
```python
print(inorder_map)
```
Should map each value to its index

4. **Check build order**
```python
print(f"Building left of {root_val}")
root.left = build(left, mid - 1)
print(f"Building right of {root_val}")
root.right = build(mid + 1, right)
```
Left should always be built before right

---

### 💡 Alternative: Postorder + Inorder

For comparison, here's how it differs:

```python
# Postorder: Left → Right → Root
# Root is at END of postorder

def buildTree(inorder, postorder):
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    postorder_index = len(postorder) - 1  # Start from end!
    
    def build(left, right):
        nonlocal postorder_index
        
        if left > right:
            return None
        
        # Get root from END of postorder
        root_val = postorder[postorder_index]
        root = TreeNode(root_val)
        postorder_index -= 1  # Decrement!
        
        mid = inorder_map[root_val]
        
        # Build RIGHT first! (postorder is L→R→Root)
        root.right = build(mid + 1, right)
        root.left = build(left, mid - 1)
        
        return root
    
    return build(0, len(inorder) - 1)
```

**Key differences:**
- Start from end of postorder
- Decrement index
- Build right before left


## Part 4: Complete Implementations & Interview Guide

### Implementation 1: Recursive with HashMap (Your Solution - Optimal)

```python
from typing import Optional, List

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        """
        Construct binary tree from preorder and inorder traversals.
        
        Time: O(n) - each node visited once with O(1) lookup
        Space: O(n) for hashmap + O(h) for recursion
        """
        # Build hashmap for O(1) inorder lookups
        inorder_map = {value: index for index, value in enumerate(inorder)}
        preorder_index = 0
        
        def build(left, right):
            nonlocal preorder_index
            
            # Base case: invalid range
            if left > right:
                return None
            
            # Get root from preorder
            root_val = preorder[preorder_index]
            root = TreeNode(root_val)
            preorder_index += 1
            
            # Find split point in inorder
            mid = inorder_map[root_val]
            
            # Build subtrees (left first!)
            root.left = build(left, mid - 1)
            root.right = build(mid + 1, right)
            
            return root
        
        return build(0, len(inorder) - 1)
```

---

### Implementation 2: Using Class Variable

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        """
        Using class variable instead of nonlocal.
        
        Time: O(n)
        Space: O(n)
        """
        self.preorder_index = 0
        inorder_map = {value: index for index, value in enumerate(inorder)}
        
        def build(left, right):
            if left > right:
                return None
            
            root_val = preorder[self.preorder_index]
            root = TreeNode(root_val)
            self.preorder_index += 1
            
            mid = inorder_map[root_val]
            
            root.left = build(left, mid - 1)
            root.right = build(mid + 1, right)
            
            return root
        
        return build(0, len(inorder) - 1)
```

---

### Implementation 3: Iterative with Stack

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        """
        Iterative approach using stack.
        
        Time: O(n)
        Space: O(n) for stack
        """
        if not preorder:
            return None
        
        root = TreeNode(preorder[0])
        stack = [root]
        inorder_index = 0
        
        for i in range(1, len(preorder)):
            node = TreeNode(preorder[i])
            parent = None
            
            # Find the parent for current node
            while stack and stack[-1].val == inorder[inorder_index]:
                parent = stack.pop()
                inorder_index += 1
            
            if parent:
                # Current node is right child
                parent.right = node
            else:
                # Current node is left child
                stack[-1].left = node
            
            stack.append(node)
        
        return root
```

---

### Implementation 4: Postorder + Inorder (Variant)

```python
class Solution:
    def buildTree(self, inorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        """
        Construct from inorder and postorder traversals.
        
        Key differences:
        - Root is at END of postorder
        - Build RIGHT subtree first
        - Decrement index
        
        Time: O(n)
        Space: O(n)
        """
        inorder_map = {value: index for index, value in enumerate(inorder)}
        postorder_index = len(postorder) - 1  # Start from end
        
        def build(left, right):
            nonlocal postorder_index
            
            if left > right:
                return None
            
            # Get root from end of postorder
            root_val = postorder[postorder_index]
            root = TreeNode(root_val)
            postorder_index -= 1  # Decrement
            
            mid = inorder_map[root_val]
            
            # Build RIGHT first (postorder: L→R→Root)
            root.right = build(mid + 1, right)
            root.left = build(left, mid - 1)
            
            return root
        
        return build(0, len(inorder) - 1)
```

---

### Implementation 5: Without HashMap (For Comparison)

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        """
        Without hashmap optimization.
        
        Time: O(n²) - O(n) search per node
        Space: O(h) for recursion only
        
        NOT RECOMMENDED - Too slow for large inputs
        """
        preorder_index = 0
        
        def build(left, right):
            nonlocal preorder_index
            
            if left > right:
                return None
            
            root_val = preorder[preorder_index]
            root = TreeNode(root_val)
            preorder_index += 1
            
            # O(n) search - this is the bottleneck!
            mid = inorder.index(root_val, left, right + 1)
            
            root.left = build(left, mid - 1)
            root.right = build(mid + 1, right)
            
            return root
        
        return build(0, len(inorder) - 1)
```

---

### Helper Functions for Testing

```python
def print_tree_levelorder(root):
    """Print tree in level order for verification."""
    if not root:
        return []
    
    result = []
    queue = [root]
    
    while queue:
        node = queue.pop(0)
        if node:
            result.append(node.val)
            queue.append(node.left)
            queue.append(node.right)
        else:
            result.append(None)
    
    # Remove trailing None values
    while result and result[-1] is None:
        result.pop()
    
    return result

def print_preorder(root):
    """Verify preorder traversal."""
    result = []
    def traverse(node):
        if not node:
            return
        result.append(node.val)
        traverse(node.left)
        traverse(node.right)
    traverse(root)
    return result

def print_inorder(root):
    """Verify inorder traversal."""
    result = []
    def traverse(node):
        if not node:
            return
        traverse(node.left)
        result.append(node.val)
        traverse(node.right)
    traverse(root)
    return result

# Test cases
sol = Solution()

# Test 1: Example from problem
preorder = [3, 9, 20, 15, 7]
inorder = [9, 3, 15, 20, 7]
root = sol.buildTree(preorder, inorder)
print(f"Level order: {print_tree_levelorder(root)}")
print(f"Preorder: {print_preorder(root)}")
print(f"Inorder: {print_inorder(root)}")

# Test 2: Single node
preorder = [1]
inorder = [1]
root = sol.buildTree(preorder, inorder)
print(f"Single node: {print_tree_levelorder(root)}")

# Test 3: Left-skewed
preorder = [3, 2, 1]
inorder = [1, 2, 3]
root = sol.buildTree(preorder, inorder)
print(f"Left-skewed: {print_tree_levelorder(root)}")

# Test 4: Right-skewed
preorder = [1, 2, 3]
inorder = [1, 2, 3]
root = sol.buildTree(preorder, inorder)
print(f"Right-skewed: {print_tree_levelorder(root)}")

# Test 5: Complete binary tree
preorder = [1, 2, 4, 5, 3, 6, 7]
inorder = [4, 2, 5, 1, 6, 3, 7]
root = sol.buildTree(preorder, inorder)
print(f"Complete: {print_tree_levelorder(root)}")
```

---

### 🎯 Related Problems

| Problem | Difficulty | Key Difference | Approach |
|---------|-----------|----------------|----------|
| **Construct from Inorder and Postorder** (LeetCode #106) | Medium | Root at end, build right first | Same pattern, reversed |
| **Construct BST from Preorder** (LeetCode #1008) | Medium | Only preorder (BST property) | Use BST property to split |
| **Serialize/Deserialize Binary Tree** (LeetCode #297) | Hard | Convert to/from string | Similar reconstruction |
| **Verify Preorder Serialization** (LeetCode #331) | Medium | Check if valid preorder | Understanding traversal |
| **Maximum Binary Tree** (LeetCode #654) | Medium | Build from array (max as root) | Similar divide & conquer |
| **Recover Binary Search Tree** (LeetCode #99) | Medium | Fix swapped nodes | Inorder traversal |

---

### 📝 Day 66 Summary

**Problem:** Construct Binary Tree from Preorder and Inorder Traversal (LeetCode #105)

**Key Concepts:**
1. Preorder gives root order (Root → Left → Right)
2. Inorder gives split point (Left → Root → Right)
3. HashMap for O(1) lookups (critical optimization)
4. Recursive range building with shared index

**Optimal Solution:**
- **Approach:** Recursive with HashMap
- **Time:** O(n) with O(1) lookups
- **Space:** O(n) for map + O(h) for recursion

**Critical Pattern:** Tree reconstruction from two traversals

---

### 🎓 Interview Tips

#### What Interviewers Look For:
1. ✅ **Understand traversal orders**
2. ✅ **Recognize need for HashMap**
3. ✅ **Handle preorder_index correctly (nonlocal)**
4. ✅ **Build left before right**
5. ✅ **Explain why two traversals are needed**

#### How to Approach:
```
1. Clarify: "Values are unique, correct?"
2. Explain: "Preorder gives roots, inorder gives splits"
3. Optimize: "I'll use HashMap for O(1) lookups"
4. Code: Implement with clear variable names
5. Test: Walk through small example
6. Discuss: Time/space complexity
```

#### Common Follow-ups:
- **Q:** What if we have postorder instead of preorder?
  - **A:** Root at end, build right first, decrement index

- **Q:** Can we do it without the HashMap?
  - **A:** Yes, but O(n²) time - not optimal

- **Q:** What if values are not unique?
  - **A:** Cannot uniquely reconstruct - need additional info

- **Q:** Can we use just one traversal?
  - **A:** No, not unique (except BST with preorder only)

---

### 🔑 Key Takeaways

1. **Two traversals needed** - One alone is not unique
2. **HashMap is critical** - O(n) vs O(n²) time
3. **Preorder index must be shared** - Use nonlocal or class variable
4. **Build order matters** - Left before right for preorder
5. **Range boundaries** - Inclusive, check left > right

---

### 📌 Quick Reference Template

```python
# Preorder + Inorder
def buildTree(preorder, inorder):
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    preorder_index = 0
    
    def build(left, right):
        nonlocal preorder_index
        if left > right:
            return None
        
        root_val = preorder[preorder_index]
        root = TreeNode(root_val)
        preorder_index += 1
        
        mid = inorder_map[root_val]
        
        root.left = build(left, mid - 1)
        root.right = build(mid + 1, right)
        
        return root
    
    return build(0, len(inorder) - 1)

# Postorder + Inorder
def buildTree(inorder, postorder):
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    postorder_index = len(postorder) - 1
    
    def build(left, right):
        nonlocal postorder_index
        if left > right:
            return None
        
        root_val = postorder[postorder_index]
        root = TreeNode(root_val)
        postorder_index -= 1
        
        mid = inorder_map[root_val]
        
        root.right = build(mid + 1, right)  # Right first!
        root.left = build(left, mid - 1)
        
        return root
    
    return build(0, len(inorder) - 1)
```

---

### 🎨 Visual Summary

```
Problem: Construct tree from preorder and inorder

Preorder: [3, 9, 20, 15, 7]
          ↑
        ROOT (first element)

Inorder: [9, | 3 | 15, 20, 7]
         LEFT ROOT RIGHT

Algorithm:
1. Get root from preorder[index]
2. Find root in inorder → split
3. Build left subtree (left, mid-1)
4. Build right subtree (mid+1, right)

Result:
      3
     / \
    9   20
       /  \
      15   7

Key Optimization: HashMap for O(1) lookup
Time: O(n) | Space: O(n)
```

---

### 🔄 Comparison: Preorder vs Postorder

```
Preorder + Inorder:
- Root at START of preorder
- Increment index
- Build LEFT first
- Order: Root → Left → Right

Postorder + Inorder:
- Root at END of postorder
- Decrement index
- Build RIGHT first
- Order: Left → Right → Root
```

---

**Day 66 Complete! 🎉**

**Next Steps:**
- Practice: Construct Binary Tree from Inorder and Postorder (LeetCode #106)
- Review: Tree traversal orders (preorder, inorder, postorder)
- Master: Divide and conquer on trees
