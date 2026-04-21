# Day 56: Binary Tree Right Side View - Detailed Notes

## Problem Statement

**LeetCode #199 - Binary Tree Right Side View (Medium)**

Given the root of a binary tree, imagine yourself standing on the **right side** of it, return the values of the nodes you can see ordered from top to bottom.

**Examples:**

```
Example 1:
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]

Tree Structure:
       1         <- Level 0: See 1
      / \
     2   3       <- Level 1: See 3 (rightmost)
      \   \
       5   4     <- Level 2: See 4 (rightmost)

Explanation: Standing on the right, you see 1, 3, 4

Example 2:
Input: root = [1,2,3,4,null,null,null,5]
Output: [1,3,4,5]

Tree Structure:
       1         <- Level 0: See 1
      / \
     2   3       <- Level 1: See 3 (rightmost)
    /
   4             <- Level 2: See 4 (only node)
  /
 5               <- Level 3: See 5 (only node)

Explanation: Even though 4 and 5 are on the left, they're the rightmost at their levels

Example 3:
Input: root = [1,null,3]
Output: [1,3]

Tree Structure:
   1             <- Level 0: See 1
    \
     3           <- Level 1: See 3

Example 4:
Input: root = []
Output: []
```

**Constraints:**
- The number of nodes in the tree is in the range [0, 100]
- -100 ≤ Node.val ≤ 100

---

## Problem Logic & Reasoning

### Understanding "Right Side View"

**What Does "Right Side View" Mean?**

Imagine standing to the right of the tree and looking at it from the side. You can only see the **rightmost node at each level**.

```
Visual Representation:

       1                    You
      / \                    |
     2   3      ------>     👁️ (standing here)
    / \   \
   4   5   6

From right side, you see:
Level 0: 1
Level 1: 3 (blocks 2)
Level 2: 6 (blocks 5 and 4)

Result: [1, 3, 6]
```

**Key Insight:**
- At each level, we want the **rightmost node**
- If a level has only left children, we still take them (they're the rightmost at that level)
- We process levels from top to bottom

### Core Challenge

**The Problem:**
1. Need to identify all levels in the tree
2. For each level, find the rightmost node
3. Return nodes in top-to-bottom order

**Two Main Approaches:**
1. **DFS (Depth-First Search)**: Visit right subtree first, track depth
2. **BFS (Breadth-First Search)**: Level-order traversal, take last node per level

### Why This is Interesting

**Not Just "Go Right":**
```
Example showing why we can't just follow right pointers:

       1
      / \
     2   3
    /
   4
  /
 5

If we only go right: [1, 3]
Correct answer: [1, 3, 4, 5]

Why? Levels 2 and 3 have no right nodes, so we see left nodes
```

**The Depth Matters:**
```
We need to track which level we're at:
- First time we see a level → Add that node
- Already seen this level → Skip (we want rightmost)
```

---

## Approach 1: Depth-First Search (DFS) - Right First ⭐⭐⭐

### Strategy

Use DFS traversal with a twist:
1. **Visit right subtree BEFORE left subtree**
2. Track the current depth/level
3. First node we see at each depth is the rightmost
4. Use a result list where `len(result) == depth` means we haven't seen this level yet

### Visual Flow

**Example: root = [1,2,3,null,5,null,4]**

```
Tree Structure:
       1
      / \
     2   3
      \   \
       5   4

DFS Traversal Order (Right First):
1 → 3 → 4 → 2 → 5

Step-by-Step Execution:

Step 1: Visit node 1 (depth=0)
  res = []
  len(res) == 0 == depth ✓
  res.append(1)
  res = [1]
  
  Go right first → node 3

Step 2: Visit node 3 (depth=1)
  res = [1]
  len(res) == 1 == depth ✓
  res.append(3)
  res = [1, 3]
  
  Go right first → node 4

Step 3: Visit node 4 (depth=2)
  res = [1, 3]
  len(res) == 2 == depth ✓
  res.append(4)
  res = [1, 3, 4]
  
  No children, backtrack

Step 4: Back to node 3, go left → None
  Backtrack to node 1

Step 5: Visit node 2 (depth=1)
  res = [1, 3, 4]
  len(res) == 3 != 1 ✗
  Don't add (already have level 1)
  
  Go right first → node 5

Step 6: Visit node 5 (depth=2)
  res = [1, 3, 4]
  len(res) == 3 != 2 ✗
  Don't add (already have level 2)

Final Result: [1, 3, 4] ✓
```

### Algorithm Logic

**Key Idea:**
```python
if len(result) == depth:
    result.append(node.val)
```

**Why This Works:**
- We visit right nodes first
- First time we reach a depth, it's the rightmost node
- `len(result)` tells us how many levels we've seen
- If `len(result) == depth`, this is a new level

**Traversal Order:**
```python
dfs(root.right, depth + 1)  # Visit right first
dfs(root.left, depth + 1)   # Then left
```

### Detailed Walkthrough

**Example: Tree with left-heavy structure**

```
Input:
       1
      / \
     2   3
    /
   4
  /
 5

DFS Execution Trace:

Call 1: dfs(1, depth=0)
  res = []
  len(res) == 0 == depth ✓ → res = [1]
  Call dfs(3, depth=1)  (right child)
  Call dfs(2, depth=1)  (left child)

Call 2: dfs(3, depth=1)
  res = [1]
  len(res) == 1 == depth ✓ → res = [1, 3]
  Call dfs(None, depth=2)  (right child)
  Call dfs(None, depth=2)  (left child)
  Return

Call 3: dfs(2, depth=1)
  res = [1, 3]
  len(res) == 2 != 1 ✗ → Don't add
  Call dfs(None, depth=2)  (right child)
  Call dfs(4, depth=2)     (left child)

Call 4: dfs(4, depth=2)
  res = [1, 3]
  len(res) == 2 == depth ✓ → res = [1, 3, 4]
  Call dfs(None, depth=3)  (right child)
  Call dfs(5, depth=3)     (left child)

Call 5: dfs(5, depth=3)
  res = [1, 3, 4]
  len(res) == 3 == depth ✓ → res = [1, 3, 4, 5]
  Call dfs(None, depth=4)  (right child)
  Call dfs(None, depth=4)  (left child)
  Return

Final Result: [1, 3, 4, 5] ✓
```

### Complete Implementation

```python
from typing import Optional, List

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        result = []
        
        def dfs(node, depth):
            """
            DFS helper function
            Args:
                node: Current tree node
                depth: Current depth/level (0-indexed)
            """
            # Base case: null node
            if not node:
                return
            
            # If this is the first node we see at this depth
            # (len(result) == depth means we haven't added this level yet)
            if len(result) == depth:
                result.append(node.val)
            
            # IMPORTANT: Visit right subtree FIRST
            # This ensures we see rightmost nodes before left nodes
            dfs(node.right, depth + 1)
            dfs(node.left, depth + 1)
        
        # Start DFS from root at depth 0
        dfs(root, 0)
        return result
```

### Why This Works

**1. Right-First Traversal:**
```
By visiting right before left:
- Rightmost nodes are encountered first at each level
- When we reach a new depth, it's guaranteed to be the rightmost

Example:
       1
      / \
     2   3
    
Visit order: 1 → 3 → 2
At depth 1: See 3 first (rightmost) ✓
```

**2. The Length Check:**
```python
if len(result) == depth:
    result.append(node.val)
```

**Why this works:**
- result[0] = node at depth 0
- result[1] = node at depth 1
- result[i] = node at depth i

So `len(result)` equals the next depth we need to add:
- len=0 → need depth 0
- len=1 → need depth 1
- len=2 → need depth 2

**3. Depth Tracking:**
```
Each recursive call increments depth:
- Root: depth = 0
- Children: depth = 1
- Grandchildren: depth = 2

This naturally tracks levels
```

### Complexity Analysis

**Time Complexity: O(n)**
- n = number of nodes in the tree
- Visit each node exactly once
- Each visit: O(1) operations (check length, append)
- Total: O(n)

**Space Complexity: O(h)**
- h = height of the tree
- Recursion call stack: O(h) depth
- Result array: O(h) in worst case (one node per level)
- Best case (balanced tree): O(log n)
- Worst case (skewed tree): O(n)

**Space Breakdown:**
```
Balanced Tree:
       1
      / \
     2   3
    / \
   4   5
   
Height = 3
Call stack max depth = 3
Result size = 3
Space = O(log n)

Skewed Tree:
   1
    \
     2
      \
       3
        \
         4

Height = 4
Call stack max depth = 4
Result size = 4
Space = O(n)
```

### Critical Insights

**1. Why Visit Right First:**
```python
# Correct order
dfs(node.right, depth + 1)
dfs(node.left, depth + 1)

# Wrong order
dfs(node.left, depth + 1)
dfs(node.right, depth + 1)

Example showing difference:
       1
      / \
     2   3

Correct (right first):
  Visit: 1 → 3 → 2
  At depth 1: Add 3 (rightmost) ✓

Wrong (left first):
  Visit: 1 → 2 → 3
  At depth 1: Add 2 (leftmost) ✗
```

**2. The Length Check is Elegant:**
```python
# Instead of tracking visited levels with a set
visited = set()
if depth not in visited:
    result.append(node.val)
    visited.add(depth)

# We use array length
if len(result) == depth:
    result.append(node.val)

# This works because:
# - We process levels in order (0, 1, 2, ...)
# - len(result) always equals next expected depth
# - No need for extra data structure
```

**3. Depth Parameter is Crucial:**
```python
# Without depth parameter, we can't track levels
def dfs(node):  # Missing depth!
    if not node:
        return
    # How do we know which level we're at? ✗

# With depth parameter
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:  # Can check level ✓
        result.append(node.val)
```

**4. Base Case Simplicity:**
```python
if not node:
    return

# Simple and clean
# No need to check node.left or node.right before calling
# Just call dfs on children, let base case handle None
```

### Common Mistakes

❌ **Mistake 1: Visiting left before right**
```python
# Wrong
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:
        result.append(node.val)
    dfs(node.left, depth + 1)   # Left first
    dfs(node.right, depth + 1)  # Right second
```

✓ **Correct:**
```python
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:
        result.append(node.val)
    dfs(node.right, depth + 1)  # Right first!
    dfs(node.left, depth + 1)   # Left second
```

❌ **Mistake 2: Forgetting to increment depth**
```python
# Wrong
dfs(node.right, depth)  # Should be depth + 1
dfs(node.left, depth)   # Should be depth + 1
```

✓ **Correct:**
```python
dfs(node.right, depth + 1)
dfs(node.left, depth + 1)
```

❌ **Mistake 3: Wrong condition check**
```python
# Wrong: checking if depth exists in result
if depth < len(result):
    result.append(node.val)

# This would add multiple nodes per level!
```

✓ **Correct:**
```python
if len(result) == depth:  # Equality check
    result.append(node.val)
```

❌ **Mistake 4: Not handling empty tree**
```python
def rightSideView(self, root):
    result = []
    dfs(root, 0)  # Crashes if root is None
    return result
```

✓ **Correct:**
```python
def rightSideView(self, root):
    result = []
    
    def dfs(node, depth):
        if not node:  # Handles None
            return
        # ...
    
    dfs(root, 0)  # Safe even if root is None
    return result
```

### Edge Cases

**1. Empty Tree:**
```python
root = None
Output: []

Execution:
  dfs(None, 0)
    if not node: return  # Immediate return
  result = []
```

**2. Single Node:**
```python
root = TreeNode(1)
Output: [1]

Execution:
  dfs(1, 0)
    len(result) == 0 == depth ✓
    result = [1]
    dfs(None, 1)  # right child
    dfs(None, 1)  # left child
```

**3. Only Left Children:**
```python
       1
      /
     2
    /
   3

Output: [1, 2, 3]

Why? Each level has only one node (leftmost = rightmost)
```

**4. Only Right Children:**
```python
   1
    \
     2
      \
       3

Output: [1, 2, 3]

Straightforward right path
```

**5. Complete Binary Tree:**
```python
       1
      / \
     2   3
    / \ / \
   4  5 6  7

Output: [1, 3, 7]

Level 0: 1
Level 1: 3 (rightmost)
Level 2: 7 (rightmost)
```

---

## Approach 2: Breadth-First Search (BFS) - Level Order ⭐⭐⭐

### Strategy

Use level-order traversal (BFS) with a queue:
1. Process tree level by level
2. For each level, track all nodes
3. Take the **last node** in each level (rightmost)
4. Add to result

### Visual Flow

**Example: root = [1,2,3,null,5,null,4]**

```
Tree Structure:
       1
      / \
     2   3
      \   \
       5   4

BFS Level-by-Level Processing:

Initial:
  queue = [1]
  result = []

Level 0:
  queue = [1]
  level_size = 1
  
  Process node 1 (i=0, last in level):
    Add 1 to result
    Add children: 2, 3
  
  queue = [2, 3]
  result = [1]

Level 1:
  queue = [2, 3]
  level_size = 2
  
  Process node 2 (i=0, not last):
    Don't add to result
    Add children: 5
  
  Process node 3 (i=1, last in level):
    Add 3 to result
    Add children: 4
  
  queue = [5, 4]
  result = [1, 3]

Level 2:
  queue = [5, 4]
  level_size = 2
  
  Process node 5 (i=0, not last):
    Don't add to result
    No children
  
  Process node 4 (i=1, last in level):
    Add 4 to result
    No children
  
  queue = []
  result = [1, 3, 4]

Final Result: [1, 3, 4] ✓
```

### Algorithm Logic

**Key Steps:**
```python
1. Initialize queue with root
2. While queue not empty:
   a. Get current level size
   b. Process all nodes in current level
   c. If node is last in level (i == level_size - 1):
      - Add to result
   d. Add children to queue for next level
```

**The Critical Check:**
```python
if i == level_size - 1:
    result.append(node.val)
```

This identifies the last (rightmost) node in each level.

### Detailed Walkthrough

**Example: Tree with mixed structure**

```
Input:
       1
      / \
     2   3
    / \
   4   5

BFS Execution:

Iteration 1 (Level 0):
  queue = [1]
  level_size = 1
  
  i=0: node=1
    i == 0 == level_size-1 ✓
    result.append(1)
    queue.append(2)  # left child
    queue.append(3)  # right child
  
  queue = [2, 3]
  result = [1]

Iteration 2 (Level 1):
  queue = [2, 3]
  level_size = 2
  
  i=0: node=2
    i == 0 != 1 ✗
    Don't add to result
    queue.append(4)  # left child
    queue.append(5)  # right child
  
  i=1: node=3
    i == 1 == level_size-1 ✓
    result.append(3)
    No children
  
  queue = [4, 5]
  result = [1, 3]

Iteration 3 (Level 2):
  queue = [4, 5]
  level_size = 2
  
  i=0: node=4
    i == 0 != 1 ✗
    Don't add to result
    No children
  
  i=1: node=5
    i == 1 == level_size-1 ✓
    result.append(5)
    No children
  
  queue = []
  result = [1, 3, 5]

Queue empty, return [1, 3, 5] ✓
```

### Complete Implementation

```python
from typing import Optional, List
from collections import deque

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        # Handle empty tree
        if not root:
            return []
        
        result = []
        queue = deque([root])
        
        while queue:
            # Get number of nodes at current level
            level_size = len(queue)
            
            # Process all nodes at current level
            for i in range(level_size):
                node = queue.popleft()
                
                # If this is the last node in the level (rightmost)
                if i == level_size - 1:
                    result.append(node.val)
                
                # Add children for next level
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
        
        return result
```

### Why This Works

**1. Level-Order Guarantees:**
```
BFS naturally processes nodes level by level:
- All nodes at depth 0, then
- All nodes at depth 1, then
- All nodes at depth 2, etc.

This matches our requirement (top to bottom)
```

**2. Queue Snapshot:**
```python
level_size = len(queue)

# This captures the current level size
# Even as we add children, we only process level_size nodes
# New children go to the back of queue (next level)

Example:
  queue = [2, 3]
  level_size = 2  # Snapshot
  
  Process 2: queue = [3, 4, 5]  # Added children
  Process 3: queue = [4, 5, 6]  # Added children
  
  But we only process 2 nodes (level_size = 2)
  Nodes 4, 5, 6 are for next level
```

**3. Last Node Detection:**
```python
for i in range(level_size):
    node = queue.popleft()
    if i == level_size - 1:  # Last iteration
        result.append(node.val)
```

**Why this works:**
- i goes from 0 to level_size-1
- Last iteration: i == level_size-1
- This is the rightmost node in the level

---

*Continue to next 500 lines...*

### Complexity Analysis

**Time Complexity: O(n)**
- n = number of nodes in the tree
- Visit each node exactly once
- Each node: O(1) operations (popleft, append, check)
- Total: O(n)

**Space Complexity: O(w)**
- w = maximum width of the tree
- Queue stores nodes at current level
- Maximum nodes in queue = widest level
- Best case (skewed tree): O(1)
- Worst case (complete tree): O(n/2) = O(n)

**Space Comparison with DFS:**
```
DFS Space: O(h) - height of tree
BFS Space: O(w) - width of tree

Skewed Tree (all right):
   1
    \
     2
      \
       3

DFS: O(3) = O(n)
BFS: O(1)
BFS wins!

Complete Binary Tree:
       1
      / \
     2   3
    / \ / \
   4  5 6  7

DFS: O(3) = O(log n)
BFS: O(4) = O(n)
DFS wins!
```

### Critical Insights

**1. Why Capture level_size:**
```python
# Correct
level_size = len(queue)
for i in range(level_size):
    node = queue.popleft()
    # Add children...

# Wrong: Don't use len(queue) directly in loop
for i in range(len(queue)):  # len(queue) changes!
    node = queue.popleft()
    # This will process children too!
```

**2. The i == level_size - 1 Check:**
```python
# Alternative: Track last node differently
for i in range(level_size):
    node = queue.popleft()
    if i == level_size - 1:
        result.append(node.val)

# Or: Just check on last iteration
for i in range(level_size):
    node = queue.popleft()
    if i == level_size - 1:
        last_node = node
result.append(last_node.val)

# First approach is cleaner
```

**3. Why Check node.left and node.right:**
```python
# Correct
if node.left:
    queue.append(node.left)
if node.right:
    queue.append(node.right)

# Wrong: Don't add None to queue
queue.append(node.left)   # Might be None
queue.append(node.right)  # Might be None

# This would require checking in next iteration
```

**4. Early Return for Empty Tree:**
```python
if not root:
    return []

# Without this, queue = deque([None])
# Would need to handle None in loop
```

### Common Mistakes

❌ **Mistake 1: Not capturing level_size**
```python
# Wrong
while queue:
    for i in range(len(queue)):  # len(queue) changes!
        node = queue.popleft()
        queue.append(node.left)
        queue.append(node.right)
```

✓ **Correct:**
```python
while queue:
    level_size = len(queue)  # Snapshot
    for i in range(level_size):
        node = queue.popleft()
        # ...
```

❌ **Mistake 2: Adding None to queue**
```python
# Wrong
queue.append(node.left)   # Might be None
queue.append(node.right)  # Might be None
```

✓ **Correct:**
```python
if node.left:
    queue.append(node.left)
if node.right:
    queue.append(node.right)
```

❌ **Mistake 3: Wrong index check**
```python
# Wrong: checking first node
if i == 0:
    result.append(node.val)

# This gives leftmost, not rightmost!
```

✓ **Correct:**
```python
if i == level_size - 1:  # Last node
    result.append(node.val)
```

❌ **Mistake 4: Not handling empty tree**
```python
# Wrong
result = []
queue = deque([root])  # root might be None

while queue:
    # ...
```

✓ **Correct:**
```python
if not root:
    return []

result = []
queue = deque([root])
# ...
```

### Edge Cases

**1. Empty Tree:**
```python
root = None
Output: []

Execution:
  if not root: return []  # Early return
```

**2. Single Node:**
```python
root = TreeNode(1)
Output: [1]

Execution:
  queue = [1]
  level_size = 1
  i=0: i == 0 == level_size-1 ✓
  result = [1]
```

**3. Only Left Children:**
```python
       1
      /
     2
    /
   3

Output: [1, 2, 3]

Level 0: queue=[1], last=1
Level 1: queue=[2], last=2
Level 2: queue=[3], last=3
```

**4. Only Right Children:**
```python
   1
    \
     2
      \
       3

Output: [1, 2, 3]

Level 0: queue=[1], last=1
Level 1: queue=[2], last=2
Level 2: queue=[3], last=3
```

**5. Wide Tree:**
```python
       1
      / \
     2   3
    / \ / \
   4  5 6  7

Output: [1, 3, 7]

Level 0: queue=[1], last=1
Level 1: queue=[2,3], last=3
Level 2: queue=[4,5,6,7], last=7
```

---

## Approach Comparison

### DFS vs BFS

| Aspect | DFS (Right First) | BFS (Level Order) |
|--------|-------------------|-------------------|
| **Time** | O(n) | O(n) |
| **Space** | O(h) | O(w) |
| **Code** | Shorter | Slightly longer |
| **Intuition** | Less intuitive | More intuitive |
| **Best For** | Tall trees | Wide trees |
| **Implementation** | Recursive | Iterative |

### Detailed Comparison

**DFS Approach:**
```python
Pros:
+ Simpler code (fewer lines)
+ Better space for wide trees
+ Elegant depth tracking
+ Natural recursion

Cons:
- Less intuitive (why right first?)
- Recursion overhead
- Stack overflow risk (very deep trees)

Best for:
- Complete binary trees
- Trees wider than tall
- When recursion is preferred
```

**BFS Approach:**
```python
Pros:
+ More intuitive (level by level)
+ No recursion (no stack overflow)
+ Clear level boundaries
+ Easy to understand

Cons:
- More code (queue management)
- Worse space for tall trees
- Need to import deque

Best for:
- Skewed trees
- Trees taller than wide
- When iteration is preferred
```

### Space Complexity Deep Dive

**Example 1: Skewed Right Tree**
```
   1
    \
     2
      \
       3
        \
         4

DFS Space:
  Call stack: [dfs(1), dfs(2), dfs(3), dfs(4)]
  Max depth: 4
  Space: O(4) = O(n)

BFS Space:
  Level 0: queue = [1]
  Level 1: queue = [2]
  Level 2: queue = [3]
  Level 3: queue = [4]
  Max width: 1
  Space: O(1)

Winner: BFS
```

**Example 2: Complete Binary Tree**
```
       1
      / \
     2   3
    / \ / \
   4  5 6  7

DFS Space:
  Call stack max: [dfs(1), dfs(3), dfs(7)]
  Max depth: 3
  Space: O(3) = O(log n)

BFS Space:
  Level 0: queue = [1]
  Level 1: queue = [2, 3]
  Level 2: queue = [4, 5, 6, 7]
  Max width: 4
  Space: O(4) = O(n)

Winner: DFS
```

**Example 3: Balanced Tree**
```
       1
      / \
     2   3
    / \
   4   5

DFS Space:
  Call stack max: [dfs(1), dfs(2), dfs(4)]
  Max depth: 3
  Space: O(3) = O(log n)

BFS Space:
  Level 0: queue = [1]
  Level 1: queue = [2, 3]
  Level 2: queue = [4, 5]
  Max width: 2
  Space: O(2) = O(n)

Winner: DFS (but close)
```

### When to Use Each Approach

**Use DFS When:**
- ✓ Tree is wide (many nodes per level)
- ✓ Tree is balanced or complete
- ✓ Prefer recursive solutions
- ✓ Space is a concern (for wide trees)
- ✓ Code simplicity is important

**Use BFS When:**
- ✓ Tree is tall and narrow
- ✓ Tree is skewed
- ✓ Prefer iterative solutions
- ✓ Need to avoid recursion
- ✓ Want more intuitive code
- ✓ Need to process level by level

**Interview Recommendation:**
```
1. Start with BFS (more intuitive)
   - Explain level-order traversal
   - Show queue-based solution
   
2. Mention DFS optimization
   - "Can also solve with DFS"
   - "Visit right subtree first"
   - "Better space for wide trees"
   
3. Discuss trade-offs
   - Space complexity differences
   - When each is better
```

---

## Alternative Approaches

### Approach 3: BFS with Rightmost Tracking

**Idea:** Instead of checking index, just keep updating the rightmost value.

```python
def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        rightmost = None  # Track rightmost at this level
        
        for _ in range(level_size):
            node = queue.popleft()
            rightmost = node.val  # Keep updating
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(rightmost)  # Add after processing level
    
    return result
```

**Pros:**
- Don't need to track index i
- Slightly cleaner loop

**Cons:**
- Extra variable
- Updates rightmost every iteration (not just last)

### Approach 4: DFS with Dictionary

**Idea:** Use dictionary to store first node seen at each depth.

```python
def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
    depth_map = {}
    
    def dfs(node, depth):
        if not node:
            return
        
        # Only add if depth not seen yet
        if depth not in depth_map:
            depth_map[depth] = node.val
        
        # Visit right first
        dfs(node.right, depth + 1)
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    
    # Convert dictionary to list
    return [depth_map[i] for i in range(len(depth_map))]
```

**Pros:**
- Explicit depth tracking
- Easy to understand

**Cons:**
- Extra space for dictionary
- Need to convert to list at end
- More complex than array length check

### Approach 5: BFS from Right to Left

**Idea:** Add right children before left, take first node per level.

```python
def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # Take first node in level (rightmost due to order)
            if i == 0:
                result.append(node.val)
            
            # Add right child first, then left
            if node.right:
                queue.append(node.right)
            if node.left:
                queue.append(node.left)
    
    return result
```

**Pros:**
- Take first instead of last
- Mirrors DFS logic

**Cons:**
- Less intuitive (why right first in BFS?)
- Standard BFS adds left first

---

## Pattern Recognition

### When to Recognize This Pattern

**Problem Characteristics:**
```
✓ Binary tree traversal
✓ Need specific view (right, left, top, bottom)
✓ Level-based processing
✓ Return nodes in specific order
✓ "What can you see from X side?"
```

**Key Indicators:**
- "Right side view"
- "Left side view"
- "Top view"
- "Bottom view"
- "Boundary of tree"
- "Visible nodes from angle"

### Similar Problems

**1. Binary Tree Left Side View**
```
Problem: Return nodes visible from left side

Solution: Same as right side view, but:
  DFS: Visit LEFT subtree first
  BFS: Take FIRST node in each level

Example:
       1
      / \
     2   3
      \   \
       5   4

Left side view: [1, 2, 5]
```

**2. Binary Tree Top View (LeetCode #987)**
```
Problem: Return nodes visible from top

Solution: Track horizontal distance
  - Use BFS with (node, horizontal_distance)
  - First node at each horizontal distance is visible
  - Use dictionary to track

Example:
       1
      / \
     2   3
    / \
   4   5

Top view: [4, 2, 1, 3]
```

**3. Binary Tree Bottom View**
```
Problem: Return nodes visible from bottom

Solution: Track horizontal distance
  - Use BFS with (node, horizontal_distance)
  - LAST node at each horizontal distance is visible
  - Keep updating dictionary

Example:
       1
      / \
     2   3
    / \
   4   5

Bottom view: [4, 2, 5, 3]
```

**4. Binary Tree Boundary (LeetCode #545)**
```
Problem: Return boundary nodes (anti-clockwise)

Solution: Three parts
  1. Left boundary (top to bottom)
  2. Leaf nodes (left to right)
  3. Right boundary (bottom to top)

Example:
       1
      / \
     2   3
    / \
   4   5

Boundary: [1, 2, 4, 5, 3]
```

**5. Binary Tree Vertical Order Traversal (LeetCode #314)**
```
Problem: Return nodes column by column

Solution: Track horizontal distance
  - Use BFS with (node, column)
  - Group nodes by column
  - Return columns left to right

Example:
       1
      / \
     2   3
    / \
   4   5

Vertical order: [[4], [2], [1, 5], [3]]
```

### Pattern Template

**Generic Tree View Template:**

```python
def treeView(root):
    """
    Generic template for tree view problems
    Customize based on specific requirements
    """
    if not root:
        return []
    
    # Choose traversal method
    # Option 1: DFS
    result = []
    def dfs(node, depth):
        if not node:
            return
        
        # Add logic based on view type
        if len(result) == depth:  # First at this depth
            result.append(node.val)
        
        # Choose order based on view
        dfs(node.right, depth + 1)  # Right first for right view
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    return result
    
    # Option 2: BFS
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # Add logic based on view type
            if i == level_size - 1:  # Last for right view
                result.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result
```

**DFS Template for Views:**

```python
def rightSideView(root):
    result = []
    
    def dfs(node, depth):
        if not node:
            return
        
        if len(result) == depth:
            result.append(node.val)
        
        dfs(node.right, depth + 1)  # Right first
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    return result

def leftSideView(root):
    result = []
    
    def dfs(node, depth):
        if not node:
            return
        
        if len(result) == depth:
            result.append(node.val)
        
        dfs(node.left, depth + 1)   # Left first
        dfs(node.right, depth + 1)
    
    dfs(root, 0)
    return result
```

**BFS Template for Views:**

```python
def rightSideView(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            if i == level_size - 1:  # Last (rightmost)
                result.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result

def leftSideView(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            if i == 0:  # First (leftmost)
                result.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result
```

---

## Related Concepts

### 1. Tree Traversal Methods

**Depth-First Search (DFS):**
```
Three main types:
1. Preorder: Root → Left → Right
2. Inorder: Left → Root → Right
3. Postorder: Left → Right → Root

For right side view:
  Modified Preorder: Root → Right → Left
```

**Breadth-First Search (BFS):**
```
Level-order traversal:
- Process all nodes at depth 0
- Then all nodes at depth 1
- Then all nodes at depth 2
- etc.

Natural fit for level-based problems
```

### 2. Queue vs Stack

**Queue (FIFO):**
```python
from collections import deque

queue = deque()
queue.append(item)      # Add to back
item = queue.popleft()  # Remove from front

Use for: BFS, level-order traversal
```

**Stack (LIFO):**
```python
stack = []
stack.append(item)  # Push
item = stack.pop()  # Pop

Use for: DFS (iterative), backtracking
```

**Recursion (Implicit Stack):**
```python
def dfs(node):
    if not node:
        return
    dfs(node.left)
    dfs(node.right)

Use for: DFS (recursive), tree problems
```

### 3. Level-Order Traversal Pattern

**Standard Level-Order:**
```python
def levelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level = []
        level_size = len(queue)
        
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

**Variations:**
- Right side view: Take last node per level
- Left side view: Take first node per level
- Zigzag: Alternate direction per level
- Average per level: Calculate average
- Max per level: Find maximum

### 4. Depth Tracking Techniques

**Method 1: Parameter Passing**
```python
def dfs(node, depth):
    if not node:
        return
    # Use depth here
    dfs(node.left, depth + 1)
    dfs(node.right, depth + 1)
```

**Method 2: Queue with Depth**
```python
queue = deque([(root, 0)])
while queue:
    node, depth = queue.popleft()
    # Use depth here
    if node.left:
        queue.append((node.left, depth + 1))
    if node.right:
        queue.append((node.right, depth + 1))
```

**Method 3: Level Markers**
```python
queue = deque([root, None])  # None marks level end
depth = 0
while queue:
    node = queue.popleft()
    if node is None:
        depth += 1
        if queue:
            queue.append(None)
    else:
        # Process node at current depth
```

---

*Continue to next section...*

## Common Mistakes & How to Avoid

### Mistake 1: Wrong Traversal Order in DFS

**Wrong Understanding:**
```python
# Thinking left-first is correct
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:
        result.append(node.val)
    dfs(node.left, depth + 1)   # Wrong order!
    dfs(node.right, depth + 1)
```

**Why It's Wrong:**
```
Example:
       1
      / \
     2   3

Execution:
  Visit 1 → Add 1
  Visit 2 → Add 2 (first at depth 1)
  Visit 3 → Skip (already have depth 1)

Result: [1, 2] ✗
Expected: [1, 3] ✓
```

**Correct:**
```python
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:
        result.append(node.val)
    dfs(node.right, depth + 1)  # Right first!
    dfs(node.left, depth + 1)
```

**How to Avoid:**
- Remember: "Right side view" = visit right first
- Think: "What do I see from the right?"
- Test with simple example

### Mistake 2: Not Capturing Level Size in BFS

**Wrong:**
```python
while queue:
    for i in range(len(queue)):  # len(queue) changes!
        node = queue.popleft()
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
```

**Why It's Wrong:**
```
Initial: queue = [1]
Iteration 1:
  i=0, len(queue)=1
  Pop 1, add 2 and 3
  queue = [2, 3]
  
Iteration 2:
  i=1, len(queue)=2  # Still in same for loop!
  Pop 2, add children
  
This processes multiple levels in one iteration!
```

**Correct:**
```python
while queue:
    level_size = len(queue)  # Snapshot!
    for i in range(level_size):
        node = queue.popleft()
        # ...
```

**How to Avoid:**
- Always capture level_size before loop
- Think: "How many nodes at THIS level?"
- Remember: Queue grows during iteration

### Mistake 3: Wrong Index Check

**Wrong:**
```python
# Checking first node instead of last
if i == 0:
    result.append(node.val)
```

**Why It's Wrong:**
```
This gives LEFT side view, not right!

Example:
       1
      / \
     2   3

Level 1: Process 2 (i=0), then 3 (i=1)
Add 2 (i==0) ✗
Expected: Add 3 (i==1) ✓
```

**Correct:**
```python
if i == level_size - 1:  # Last node
    result.append(node.val)
```

**How to Avoid:**
- Remember: Rightmost = last in level
- Think: "Last node I process at this level"
- Test with two-node level

### Mistake 4: Forgetting Empty Tree Check

**Wrong:**
```python
def rightSideView(self, root):
    result = []
    queue = deque([root])  # root might be None!
    
    while queue:
        # ...
```

**Why It's Wrong:**
```
If root is None:
  queue = [None]
  Loop executes
  node = queue.popleft() → node = None
  node.left crashes! ✗
```

**Correct:**
```python
def rightSideView(self, root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    # ...
```

**How to Avoid:**
- Always check for empty tree first
- Think: "What if root is None?"
- Add early return

### Mistake 5: Adding None to Queue

**Wrong:**
```python
queue.append(node.left)   # Might be None
queue.append(node.right)  # Might be None
```

**Why It's Wrong:**
```
If node.left is None:
  queue has None
  Next iteration: node = None
  node.left crashes! ✗
```

**Correct:**
```python
if node.left:
    queue.append(node.left)
if node.right:
    queue.append(node.right)
```

**How to Avoid:**
- Always check before adding to queue
- Think: "Is this child valid?"
- Use if statements

### Mistake 6: Not Incrementing Depth

**Wrong:**
```python
def dfs(node, depth):
    if not node:
        return
    if len(result) == depth:
        result.append(node.val)
    dfs(node.right, depth)  # Should be depth + 1
    dfs(node.left, depth)   # Should be depth + 1
```

**Why It's Wrong:**
```
All nodes have same depth!
Every node gets added to result ✗
```

**Correct:**
```python
dfs(node.right, depth + 1)
dfs(node.left, depth + 1)
```

**How to Avoid:**
- Remember: Children are one level deeper
- Think: "Depth increases going down"
- Always increment depth

---

## Optimization Techniques

### 1. Early Termination

**Not Applicable for This Problem:**
```
We need to visit all levels
Can't terminate early
Must process entire tree
```

### 2. Space Optimization for BFS

**Using List Instead of Deque:**
```python
# Deque is better (O(1) popleft)
queue = deque([root])
node = queue.popleft()  # O(1)

# List is worse (O(n) pop from front)
queue = [root]
node = queue.pop(0)  # O(n)

# Always use deque for BFS!
```

### 3. Iterative DFS (Avoid Recursion)

**Using Stack:**
```python
def rightSideView(self, root):
    if not root:
        return []
    
    result = []
    stack = [(root, 0)]  # (node, depth)
    
    while stack:
        node, depth = stack.pop()
        
        if len(result) == depth:
            result.append(node.val)
        
        # Push left first (so right is processed first)
        if node.left:
            stack.append((node.left, depth + 1))
        if node.right:
            stack.append((node.right, depth + 1))
    
    return result
```

**Pros:**
- No recursion (no stack overflow)
- Explicit stack control

**Cons:**
- More complex
- Need to track depth manually
- Order matters (push left first)

### 4. Combining Results

**If Need Both Left and Right Views:**
```python
def bothSideViews(self, root):
    if not root:
        return [], []
    
    left_view = []
    right_view = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            if i == 0:  # First (left)
                left_view.append(node.val)
            if i == level_size - 1:  # Last (right)
                right_view.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return left_view, right_view
```

---

## Test Cases & Edge Cases

### Comprehensive Test Suite

```python
def test_rightSideView():
    sol = Solution()
    
    # Test 1: Empty tree
    root = None
    assert sol.rightSideView(root) == []
    print("✓ Test 1: Empty tree")
    
    # Test 2: Single node
    root = TreeNode(1)
    assert sol.rightSideView(root) == [1]
    print("✓ Test 2: Single node")
    
    # Test 3: Only left children
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.left.left = TreeNode(3)
    assert sol.rightSideView(root) == [1, 2, 3]
    print("✓ Test 3: Only left children")
    
    # Test 4: Only right children
    root = TreeNode(1)
    root.right = TreeNode(2)
    root.right.right = TreeNode(3)
    assert sol.rightSideView(root) == [1, 2, 3]
    print("✓ Test 4: Only right children")
    
    # Test 5: Complete binary tree
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.left = TreeNode(6)
    root.right.right = TreeNode(7)
    assert sol.rightSideView(root) == [1, 3, 7]
    print("✓ Test 5: Complete binary tree")
    
    # Test 6: Left-heavy tree
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.left.left = TreeNode(5)
    assert sol.rightSideView(root) == [1, 3, 4, 5]
    print("✓ Test 6: Left-heavy tree")
    
    # Test 7: Mixed structure
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(4)
    assert sol.rightSideView(root) == [1, 3, 4]
    print("✓ Test 7: Mixed structure")
    
    # Test 8: Zigzag structure
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.left.right = TreeNode(3)
    root.left.right.left = TreeNode(4)
    assert sol.rightSideView(root) == [1, 2, 3, 4]
    print("✓ Test 8: Zigzag structure")
    
    # Test 9: Two nodes
    root = TreeNode(1)
    root.left = TreeNode(2)
    assert sol.rightSideView(root) == [1, 2]
    print("✓ Test 9: Two nodes (left)")
    
    root = TreeNode(1)
    root.right = TreeNode(2)
    assert sol.rightSideView(root) == [1, 2]
    print("✓ Test 10: Two nodes (right)")
    
    print("\nAll tests passed! ✓")

# Run tests
test_rightSideView()
```

### Edge Case Categories

**1. Empty/Minimal Trees:**
```python
# Empty
root = None
Output: []

# Single node
root = TreeNode(1)
Output: [1]

# Two nodes
root = TreeNode(1)
root.left = TreeNode(2)
Output: [1, 2]
```

**2. Skewed Trees:**
```python
# All left
   1
  /
 2
/
3
Output: [1, 2, 3]

# All right
1
 \
  2
   \
    3
Output: [1, 2, 3]
```

**3. Balanced Trees:**
```python
# Complete
       1
      / \
     2   3
    / \ / \
   4  5 6  7
Output: [1, 3, 7]

# Perfect
       1
      / \
     2   3
Output: [1, 3]
```

**4. Unbalanced Trees:**
```python
# Left-heavy
       1
      / \
     2   3
    /
   4
  /
 5
Output: [1, 3, 4, 5]

# Right-heavy
   1
  / \
 2   3
      \
       4
        \
         5
Output: [1, 3, 4, 5]
```

**5. Special Structures:**
```python
# Zigzag
   1
  /
 2
  \
   3
  /
 4
Output: [1, 2, 3, 4]

# Mixed
       1
      / \
     2   3
    / \   \
   4   5   6
Output: [1, 3, 6]
```

---

## Day 56 Summary

### Problem: Binary Tree Right Side View

**Difficulty:** Medium 🟡

**Core Concept:** Tree traversal with level-based selection

**Key Insights:**
1. Right side view = **rightmost node at each level**
2. Two main approaches: **DFS (right-first)** and **BFS (level-order)**
3. DFS: Visit right before left, track depth
4. BFS: Process level by level, take last node
5. Space complexity differs: DFS O(h), BFS O(w)

**Two Main Approaches:**

| Approach | Time | Space | Difficulty | Best For |
|----------|------|-------|------------|----------|
| DFS (Right First) | O(n) | O(h) | ⭐⭐⭐ | Wide trees, recursion |
| BFS (Level Order) | O(n) | O(w) | ⭐⭐⭐ | Tall trees, iteration |

**Pattern Recognition:**
- Tree view problems (left, right, top, bottom)
- Level-based processing
- Boundary traversal
- Vertical/horizontal order traversal

**Related Problems:**
- Binary Tree Left Side View
- Binary Tree Top View (LeetCode #987)
- Binary Tree Bottom View
- Binary Tree Boundary (LeetCode #545)
- Vertical Order Traversal (LeetCode #314)

**Common Mistakes:**
1. Wrong traversal order (left before right in DFS)
2. Not capturing level_size in BFS
3. Wrong index check (first instead of last)
4. Forgetting empty tree check
5. Adding None to queue
6. Not incrementing depth

**Key Takeaways:**
- ⭐ DFS: Visit right subtree BEFORE left
- ⭐ BFS: Capture level_size before processing
- ⭐ DFS uses `len(result) == depth` check elegantly
- ⭐ BFS uses `i == level_size - 1` for rightmost
- ⭐ Choose approach based on tree shape

**Interview Tips:**
1. Start with BFS (more intuitive)
2. Explain level-order traversal clearly
3. Show how to identify rightmost node
4. Mention DFS alternative
5. Discuss space complexity trade-offs
6. Test with edge cases (empty, single, skewed)

**Time Spent:** Understanding problem (10 min) + DFS solution (15 min) + BFS solution (15 min) + Testing (10 min) = ~50 min

**Difficulty Rating:** 5/10
- Straightforward once you understand the pattern
- Two clear approaches
- Main challenge: choosing right traversal order
- Good practice for tree traversal concepts

---

## Quick Reference

### DFS Template (Right First)

```python
def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
    result = []
    
    def dfs(node, depth):
        if not node:
            return
        
        # First time seeing this depth
        if len(result) == depth:
            result.append(node.val)
        
        # Visit right first, then left
        dfs(node.right, depth + 1)
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    return result
```

### BFS Template (Level Order)

```python
def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # Last node in level (rightmost)
            if i == level_size - 1:
                result.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result
```

### Key Patterns

**DFS Pattern:**
```python
# Right side view: right first
dfs(node.right, depth + 1)
dfs(node.left, depth + 1)

# Left side view: left first
dfs(node.left, depth + 1)
dfs(node.right, depth + 1)

# Check for new level
if len(result) == depth:
    result.append(node.val)
```

**BFS Pattern:**
```python
# Capture level size
level_size = len(queue)

# Process level
for i in range(level_size):
    node = queue.popleft()
    
    # Right side: last node
    if i == level_size - 1:
        result.append(node.val)
    
    # Left side: first node
    if i == 0:
        result.append(node.val)
```

### Complexity Cheat Sheet

```
DFS:
  Time: O(n) - visit each node once
  Space: O(h) - recursion stack height
  
BFS:
  Time: O(n) - visit each node once
  Space: O(w) - queue width

Where:
  n = number of nodes
  h = height of tree
  w = maximum width of tree

Best case DFS: O(log n) space (balanced tree)
Worst case DFS: O(n) space (skewed tree)

Best case BFS: O(1) space (skewed tree)
Worst case BFS: O(n) space (complete tree)
```

### Decision Tree

```
Choose DFS when:
  ✓ Tree is wide (many nodes per level)
  ✓ Tree is balanced/complete
  ✓ Prefer recursive solutions
  ✓ Space is concern for wide trees

Choose BFS when:
  ✓ Tree is tall and narrow
  ✓ Tree is skewed
  ✓ Prefer iterative solutions
  ✓ Need to avoid recursion
  ✓ Want more intuitive code
```

### Common Variations

```python
# Right side view
dfs(node.right, depth + 1)
dfs(node.left, depth + 1)
if i == level_size - 1: result.append(node.val)

# Left side view
dfs(node.left, depth + 1)
dfs(node.right, depth + 1)
if i == 0: result.append(node.val)

# All nodes at each level
level = []
for i in range(level_size):
    level.append(node.val)
result.append(level)

# Max at each level
max_val = float('-inf')
for i in range(level_size):
    max_val = max(max_val, node.val)
result.append(max_val)
```

---

**End of Day 56 Notes**

*Master this problem and you'll understand:*
- *Tree traversal strategies (DFS vs BFS)*
- *Level-based processing*
- *Depth tracking techniques*
- *Space complexity trade-offs*
- *View-based tree problems*
