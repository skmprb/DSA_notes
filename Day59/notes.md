# Day 59: Diameter of Binary Tree

## Problem Statement
**LeetCode 543: Diameter of Binary Tree**

Given the root of a binary tree, return the length of the **diameter** of the tree.

The diameter of a binary tree is the **length of the longest path** between any two nodes in a tree. This path **may or may not pass through the root**.

The length of a path between two nodes is represented by the **number of edges** between them.

**Examples:**
```
Example 1:
Input: root = [1,2,3,4,5]
        1
       / \
      2   3
     / \
    4   5

Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3]

Example 2:
Input: root = [1,2]
    1
   /
  2

Output: 1
```

**Constraints:**
- The number of nodes in the tree is in the range [1, 10⁴]
- -100 <= Node.val <= 100

---

## Problem Logic & Reasoning

### Core Concept
The diameter is the **longest path** between any two nodes, measured in **edges** (not nodes).

**Key Insight:** At each node, the diameter passing through that node = left_height + right_height

### Visual Understanding

```
Example Tree:
        1
       / \
      2   3
     / \
    4   5

Possible paths:
1. 4 → 2 → 1 → 3  (3 edges) ✓ Longest
2. 5 → 2 → 1 → 3  (3 edges) ✓ Longest
3. 4 → 2 → 5      (2 edges)
4. 4 → 2 → 1      (2 edges)
5. 2 → 1 → 3      (2 edges)

Diameter = 3 (maximum path length)
```

### Breaking Down the Diameter Concept

```
At each node, we can calculate:
- Height of left subtree
- Height of right subtree
- Diameter through this node = left_height + right_height

Example at Node 2:
        2
       / \
      4   5

left_height = 1 (from 4)
right_height = 1 (from 5)
diameter_through_2 = 1 + 1 = 2

Example at Node 1:
        1
       / \
      2   3
     / \
    4   5

left_height = 2 (from subtree with 2,4,5)
right_height = 1 (from subtree with 3)
diameter_through_1 = 2 + 1 = 3 ✓
```

### Why Diameter ≠ Height

```
Height: Distance from node to deepest leaf
Diameter: Longest path between ANY two nodes

Example:
        1
       /
      2
     /
    3

Height of tree: 2 (edges from 1 to 3)
Diameter: 2 (path from 3 to 1, or 1 to 3)

They happen to be equal here, but not always!

Another example:
        1
       / \
      2   3
     /
    4

Height: 2 (1 → 2 → 4)
Diameter: 3 (4 → 2 → 1 → 3)

Diameter > Height!
```

### The Key Observation

```
For each node:
1. Calculate height of left subtree
2. Calculate height of right subtree
3. Diameter through this node = left + right
4. Track maximum diameter seen so far
5. Return height to parent = max(left, right) + 1

Why return height?
- Parent needs to know how deep this subtree is
- To calculate its own diameter
```

---

## Approach 1: DFS with Global Variable ⭐⭐⭐⭐⭐

### Logic
Use DFS to calculate height of each subtree while tracking maximum diameter:
1. For each node, recursively get left and right subtree heights
2. Calculate diameter through current node = left_height + right_height
3. Update global maximum diameter
4. Return height to parent = max(left_height, right_height) + 1

### Visual Flow for [1,2,3,4,5]

```
Tree:
        1
       / \
      2   3
     / \
    4   5

Step-by-step execution (Post-order DFS):

Step 1: Visit Node 4 (leaf)
  left_height = 0 (no left child)
  right_height = 0 (no right child)
  diameter_through_4 = 0 + 0 = 0
  max_diameter = max(0, 0) = 0
  return 1 to parent (height)

Step 2: Visit Node 5 (leaf)
  left_height = 0
  right_height = 0
  diameter_through_5 = 0 + 0 = 0
  max_diameter = max(0, 0) = 0
  return 1 to parent

Step 3: Visit Node 2
  left_height = 1 (from node 4)
  right_height = 1 (from node 5)
  diameter_through_2 = 1 + 1 = 2
  max_diameter = max(0, 2) = 2 ✓
  return max(1, 1) + 1 = 2 to parent

Step 4: Visit Node 3 (leaf)
  left_height = 0
  right_height = 0
  diameter_through_3 = 0 + 0 = 0
  max_diameter = max(2, 0) = 2
  return 1 to parent

Step 5: Visit Node 1 (root)
  left_height = 2 (from node 2's subtree)
  right_height = 1 (from node 3)
  diameter_through_1 = 2 + 1 = 3
  max_diameter = max(2, 3) = 3 ✓
  return max(2, 1) + 1 = 3

Final Answer: max_diameter = 3
```

### Detailed Execution Trace

```
Call Stack Visualization:

diameterOfBinaryTree(1)
  ├─ depthof(1)
  │   ├─ depthof(2)
  │   │   ├─ depthof(4)
  │   │   │   ├─ depthof(None) → 0
  │   │   │   ├─ depthof(None) → 0
  │   │   │   ├─ diameter = 0 + 0 = 0
  │   │   │   └─ return 1
  │   │   ├─ depthof(5)
  │   │   │   ├─ depthof(None) → 0
  │   │   │   ├─ depthof(None) → 0
  │   │   │   ├─ diameter = 0 + 0 = 0
  │   │   │   └─ return 1
  │   │   ├─ diameter = 1 + 1 = 2 (update max_d = 2)
  │   │   └─ return max(1,1) + 1 = 2
  │   ├─ depthof(3)
  │   │   ├─ depthof(None) → 0
  │   │   ├─ depthof(None) → 0
  │   │   ├─ diameter = 0 + 0 = 0
  │   │   └─ return 1
  │   ├─ diameter = 2 + 1 = 3 (update max_d = 3)
  │   └─ return max(2,1) + 1 = 3
  └─ return max_d = 3
```

### Why Post-Order Traversal?

```
Post-order: Left → Right → Root

We need to:
1. Process children first (get their heights)
2. Then process parent (calculate diameter)

Example:
        1
       / \
      2   3

Can't calculate diameter at 1 until we know:
- Height of left subtree (from 2)
- Height of right subtree (from 3)

So we must visit 2 and 3 first!

This is naturally post-order traversal.
```

### The Two Values We Track

```
At each node, we track TWO different things:

1. Diameter (global max):
   - Longest path seen so far
   - Updated at each node
   - Stored in self.max_d

2. Height (return value):
   - Depth of current subtree
   - Returned to parent
   - Used by parent to calculate its diameter

Example at Node 2:
        2
       / \
      4   5

Diameter through 2: 1 + 1 = 2 (stored in max_d)
Height of subtree at 2: max(1, 1) + 1 = 2 (returned to parent)

These are different values!
```

### Pseudocode
```
function diameterOfBinaryTree(root):
    max_diameter = 0
    
    function height(node):
        if node is None:
            return 0
        
        // Get heights of subtrees
        left_height = height(node.left)
        right_height = height(node.right)
        
        // Calculate diameter through this node
        current_diameter = left_height + right_height
        
        // Update global maximum
        max_diameter = max(max_diameter, current_diameter)
        
        // Return height to parent
        return max(left_height, right_height) + 1
    
    height(root)
    return max_diameter
```

### Implementation
```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        self.max_d = 0
        
        def depthof(root):
            if not root:
                return 0
            
            # Get heights of left and right subtrees
            left = depthof(root.left)
            right = depthof(root.right)
            
            # Update diameter (left + right edges)
            self.max_d = max(self.max_d, left + right)
            
            # Return height to parent
            return max(left, right) + 1
        
        depthof(root)
        return self.max_d
```

### Complexity Analysis
- **Time:** O(n) - Visit each node exactly once
- **Space:** O(h) - Recursion stack depth, where h = height of tree
  - Best case (balanced): O(log n)
  - Worst case (skewed): O(n)

---

## Approach 2: DFS with Return Tuple

### Logic
Instead of using a global variable, return both diameter and height as a tuple.

### Implementation
```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return (0, 0)  # (diameter, height)
            
            # Get diameter and height from children
            left_diameter, left_height = dfs(node.left)
            right_diameter, right_height = dfs(node.right)
            
            # Diameter through current node
            current_diameter = left_height + right_height
            
            # Max diameter is max of:
            # 1. Diameter through current node
            # 2. Diameter in left subtree
            # 3. Diameter in right subtree
            max_diameter = max(current_diameter, left_diameter, right_diameter)
            
            # Height of current subtree
            current_height = max(left_height, right_height) + 1
            
            return (max_diameter, current_height)
        
        diameter, _ = dfs(root)
        return diameter
```

### Pros and Cons

```
Approach 1 (Global Variable):
✓ Simpler code
✓ Easier to understand
✗ Uses instance variable (not pure function)

Approach 2 (Return Tuple):
✓ Pure function (no side effects)
✓ More functional programming style
✗ Slightly more complex
✗ Returns extra information
```

---

## Approach 3: Naive (Inefficient) - For Understanding

### Logic
For each node, calculate:
1. Depth of left subtree
2. Depth of right subtree
3. Diameter through this node
4. Recursively check left and right subtrees

### Implementation
```python
class Solution:
    def getDepth(self, root):
        """Calculate depth of tree using BFS"""
        if not root:
            return 0
        
        from collections import deque
        queue = deque([root])
        depth = 0
        
        while queue:
            size = len(queue)
            for _ in range(size):
                node = queue.popleft()
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            depth += 1
        
        return depth
    
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        
        # Diameter through root
        left_depth = self.getDepth(root.left) if root.left else 0
        right_depth = self.getDepth(root.right) if root.right else 0
        through_root = left_depth + right_depth
        
        # Diameter in left subtree
        left_diameter = self.diameterOfBinaryTree(root.left)
        
        # Diameter in right subtree
        right_diameter = self.diameterOfBinaryTree(root.right)
        
        return max(through_root, left_diameter, right_diameter)
```

### Why This is Inefficient

```
Time Complexity: O(n²)

For each node (n nodes):
  - Calculate depth: O(n)
  - Recurse on children: O(n)

Example tree with n nodes:
- Root: Calculate depth of n nodes
- Each child: Calculate depth of n/2 nodes
- Each grandchild: Calculate depth of n/4 nodes
- ...

Total: n + n + n/2 + n/4 + ... = O(n²)

Approach 1 is O(n) - much better!
```

---

## Detailed Example Walkthroughs

### Example 1: Balanced Tree

```
Tree:
        1
       / \
      2   3
     / \
    4   5

Execution:

Node 4:
  left = 0, right = 0
  diameter = 0 + 0 = 0
  max_d = 0
  return 1

Node 5:
  left = 0, right = 0
  diameter = 0 + 0 = 0
  max_d = 0
  return 1

Node 2:
  left = 1, right = 1
  diameter = 1 + 1 = 2
  max_d = 2 ✓
  return 2

Node 3:
  left = 0, right = 0
  diameter = 0 + 0 = 0
  max_d = 2
  return 1

Node 1:
  left = 2, right = 1
  diameter = 2 + 1 = 3
  max_d = 3 ✓
  return 3

Answer: 3
Path: 4 → 2 → 1 → 3 (3 edges)
```

### Example 2: Skewed Tree (Left)

```
Tree:
    1
   /
  2
 /
3

Execution:

Node 3:
  left = 0, right = 0
  diameter = 0 + 0 = 0
  max_d = 0
  return 1

Node 2:
  left = 1, right = 0
  diameter = 1 + 0 = 1
  max_d = 1 ✓
  return 2

Node 1:
  left = 2, right = 0
  diameter = 2 + 0 = 2
  max_d = 2 ✓
  return 3

Answer: 2
Path: 3 → 2 → 1 (2 edges)
```

### Example 3: Single Node

```
Tree:
    1

Execution:

Node 1:
  left = 0, right = 0
  diameter = 0 + 0 = 0
  max_d = 0
  return 1

Answer: 0
(No edges, single node)
```

### Example 4: Complex Tree

```
Tree:
        1
       / \
      2   3
     /     \
    4       5
   /         \
  6           7

Execution (bottom-up):

Node 6: diameter = 0, return 1
Node 4: diameter = 1 + 0 = 1, return 2
Node 2: diameter = 2 + 0 = 2, max_d = 2, return 3

Node 7: diameter = 0, return 1
Node 5: diameter = 0 + 1 = 1, return 2
Node 3: diameter = 0 + 2 = 2, max_d = 2, return 3

Node 1: diameter = 3 + 3 = 6, max_d = 6 ✓, return 4

Answer: 6
Path: 6 → 4 → 2 → 1 → 3 → 5 → 7 (6 edges)
```

---

## Visualization: Height vs Diameter

```
Example Tree:
        1
       / \
      2   3
     / \
    4   5

At each node, we track:

Node 4:
  Height: 1 (to parent)
  Diameter: 0 (through this node)

Node 5:
  Height: 1 (to parent)
  Diameter: 0 (through this node)

Node 2:
  Height: 2 (to parent) ← max(1,1) + 1
  Diameter: 2 (through this node) ← 1 + 1

Node 3:
  Height: 1 (to parent)
  Diameter: 0 (through this node)

Node 1:
  Height: 3 (not used)
  Diameter: 3 (through this node) ← 2 + 1

Global max_diameter: 3
```

---

## Why We Need Global Variable

```
Problem: Diameter might not pass through root!

Example:
        1
       /
      2
     / \
    3   4
   /
  5

Diameter through root (1): 3 + 0 = 3
Diameter through node 2: 2 + 1 = 3
Diameter through node 3: 1 + 0 = 1

Maximum: 3 (could be at root OR at node 2)

If we only returned from root, we might miss
the maximum diameter in a subtree!

Solution: Track global maximum across all nodes.
```

---

## Common Patterns in Tree Problems

```
This problem uses a common pattern:

1. Calculate something at each node
2. Track global maximum/minimum
3. Return different value to parent

Similar problems:
- Maximum Path Sum (LC 124)
- Binary Tree Maximum Path Sum
- Longest Univalue Path (LC 687)

Pattern:
def solve(root):
    global_result = initial_value
    
    def dfs(node):
        if not node:
            return base_case
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Update global result
        global_result = update(global_result, left, right)
        
        # Return value for parent
        return compute_for_parent(left, right)
    
    dfs(root)
    return global_result
```

---

## Critical Insights

### 1. Diameter vs Height

```
Height: Distance from node to deepest leaf
Diameter: Longest path between ANY two nodes

At each node:
- Height = max(left_height, right_height) + 1
- Diameter = left_height + right_height

Example:
        2
       / \
      4   5

Height of subtree at 2: max(1, 1) + 1 = 2
Diameter through 2: 1 + 1 = 2

They're different concepts!
```

### 2. Why Add Heights (Not Add 1)?

```
Diameter = left_height + right_height

Why not left_height + right_height + 1?

Because heights are measured in EDGES!

Example:
        2
       / \
      4   5

left_height = 1 (one edge: 2→4)
right_height = 1 (one edge: 2→5)

Path 4→2→5 has 2 edges total
= left_height + right_height
= 1 + 1 = 2 ✓

If we added 1:
= 1 + 1 + 1 = 3 ✗ (wrong!)
```

### 3. Why Post-Order Traversal?

```
We need children's information before processing parent:

        1
       / \
      2   3

To calculate diameter at 1:
- Need height of left subtree (from 2)
- Need height of right subtree (from 3)

So we MUST visit 2 and 3 first!

This is post-order: Left → Right → Root
```

### 4. The Global Variable Pattern

```
Why use self.max_d?

Because:
1. Diameter might not pass through root
2. We need to check ALL nodes
3. Each node updates global maximum
4. Return value is for parent (height)

Alternative: Return tuple (diameter, height)
But global variable is simpler!
```

### 5. Edge Count vs Node Count

```
Problem asks for EDGES, not NODES!

Path: 4 → 2 → 1 → 3

Nodes in path: 4 (nodes: 4, 2, 1, 3)
Edges in path: 3 (edges: 4-2, 2-1, 1-3)

Answer: 3 (edges) ✓

Common mistake: Counting nodes instead!
```

---

## Common Mistakes

### ❌ Mistake 1: Counting Nodes Instead of Edges

```python
# Wrong: Returns node count
def diameterOfBinaryTree(self, root):
    self.max_d = 0
    
    def dfs(node):
        if not node:
            return 0
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Wrong: Adding 1 for current node
        self.max_d = max(self.max_d, left + right + 1)
        
        return max(left, right) + 1
    
    dfs(root)
    return self.max_d

# Correct: Count edges only
self.max_d = max(self.max_d, left + right)
```

### ❌ Mistake 2: Not Using Global Variable

```python
# Wrong: Only returns diameter through root
def diameterOfBinaryTree(self, root):
    if not root:
        return 0
    
    left = self.height(root.left)
    right = self.height(root.right)
    
    return left + right  # Misses diameter in subtrees!

# Problem: Diameter might not pass through root!
```

### ❌ Mistake 3: Forgetting Base Case

```python
# Wrong: No base case
def dfs(node):
    left = dfs(node.left)  # Error if node is None!
    right = dfs(node.right)
    # ...

# Correct: Check for None
def dfs(node):
    if not node:
        return 0
    # ...
```

### ❌ Mistake 4: Wrong Return Value

```python
# Wrong: Returns diameter instead of height
def dfs(node):
    if not node:
        return 0
    
    left = dfs(node.left)
    right = dfs(node.right)
    
    self.max_d = max(self.max_d, left + right)
    
    return left + right  # Wrong! Should return height

# Correct: Return height to parent
return max(left, right) + 1
```

### ❌ Mistake 5: Not Initializing Global Variable

```python
# Wrong: max_d not initialized
def diameterOfBinaryTree(self, root):
    # Missing: self.max_d = 0
    
    def dfs(node):
        # ...
        self.max_d = max(self.max_d, left + right)  # Error!

# Correct: Initialize before use
self.max_d = 0
```

### ❌ Mistake 6: Calculating Diameter Wrong

```python
# Wrong: Adding 1 to diameter
self.max_d = max(self.max_d, left + right + 1)

# Correct: Just add heights
self.max_d = max(self.max_d, left + right)
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `[1]` | `0` | Single node, no edges |
| `[1,2]` | `1` | Two nodes, one edge |
| `[1,null,2]` | `1` | Right skewed |
| `[1,2,null]` | `1` | Left skewed |
| `[1,2,3,4,5]` | `3` | Balanced tree |

---

## Pattern Recognition

### This Pattern Applies To:

1. **Binary Tree Maximum Path Sum (LeetCode 124)**
```python
# Similar: Track global max, return value to parent
def maxPathSum(root):
    max_sum = float('-inf')
    
    def dfs(node):
        if not node:
            return 0
        
        left = max(0, dfs(node.left))  # Ignore negative
        right = max(0, dfs(node.right))
        
        max_sum = max(max_sum, left + right + node.val)
        
        return max(left, right) + node.val
```

2. **Longest Univalue Path (LeetCode 687)**
```python
# Similar: Track global max path with same values
def longestUnivaluePath(root):
    max_path = 0
    
    def dfs(node):
        if not node:
            return 0
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Only count if values match
        left = left + 1 if node.left and node.left.val == node.val else 0
        right = right + 1 if node.right and node.right.val == node.val else 0
        
        max_path = max(max_path, left + right)
        
        return max(left, right)
```

3. **Maximum Depth of Binary Tree (LeetCode 104)**
```python
# Simpler: Just return height
def maxDepth(root):
    if not root:
        return 0
    
    left = maxDepth(root.left)
    right = maxDepth(root.right)
    
    return max(left, right) + 1
```

### Key Characteristics:
- Post-order DFS traversal
- Track global maximum/result
- Return different value to parent
- Combine left and right subtree information

---

## Complete Implementations

### Implementation 1: Global Variable (Recommended) ⭐
```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        self.max_d = 0
        
        def depthof(root):
            if not root:
                return 0
            
            left = depthof(root.left)
            right = depthof(root.right)
            
            self.max_d = max(self.max_d, left + right)
            
            return max(left, right) + 1
        
        depthof(root)
        return self.max_d
```

### Implementation 2: Return Tuple
```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return (0, 0)  # (diameter, height)
            
            left_d, left_h = dfs(node.left)
            right_d, right_h = dfs(node.right)
            
            current_d = left_h + right_h
            max_d = max(current_d, left_d, right_d)
            current_h = max(left_h, right_h) + 1
            
            return (max_d, current_h)
        
        diameter, _ = dfs(root)
        return diameter
```

### Implementation 3: Using Nonlocal
```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        max_diameter = 0
        
        def dfs(node):
            nonlocal max_diameter
            
            if not node:
                return 0
            
            left = dfs(node.left)
            right = dfs(node.right)
            
            max_diameter = max(max_diameter, left + right)
            
            return max(left, right) + 1
        
        dfs(root)
        return max_diameter
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Maximum Depth (LC 104)** | Height calculation | No diameter tracking |
| **Max Path Sum (LC 124)** | Same pattern | Sum values, not count edges |
| **Longest Univalue Path (LC 687)** | Same pattern | Check value equality |
| **Binary Tree Tilt (LC 563)** | Post-order DFS | Different calculation |
| **Balanced Binary Tree (LC 110)** | Height calculation | Check balance condition |

---

## Day 59 Summary

### Problems Solved: 1
1. ✅ Diameter of Binary Tree

### Key Patterns Learned:
1. **Post-Order DFS** - Process children before parent
2. **Global Maximum Tracking** - Update max across all nodes
3. **Dual Return Values** - Track diameter globally, return height
4. **Height Calculation** - Recursive depth computation

### Techniques Mastered:
- Post-order tree traversal
- Global variable pattern
- Height vs diameter distinction
- Edge counting (not node counting)

### Complexity Insights:
- Time: O(n) - Visit each node once
- Space: O(h) - Recursion stack depth
- Optimal solution for this problem

### When to Use This Pattern:
- Tree path problems
- Global maximum/minimum tracking
- Need information from both subtrees
- Post-order traversal needed

---

## Quick Reference

### Diameter Template
```python
def diameterOfBinaryTree(root):
    max_diameter = 0
    
    def dfs(node):
        nonlocal max_diameter
        
        if not node:
            return 0
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Update global max
        max_diameter = max(max_diameter, left + right)
        
        # Return height to parent
        return max(left, right) + 1
    
    dfs(root)
    return max_diameter
```

### Key Formulas
```
Height of node:
  height = max(left_height, right_height) + 1

Diameter through node:
  diameter = left_height + right_height

Global maximum:
  max_diameter = max(max_diameter, current_diameter)
```

### Common Patterns
```python
# Post-order DFS
def dfs(node):
    if not node:
        return 0
    
    left = dfs(node.left)   # Process left
    right = dfs(node.right)  # Process right
    
    # Process current node
    result = compute(left, right)
    
    return result

# Global maximum tracking
self.max_result = initial_value

def dfs(node):
    # ...
    self.max_result = max(self.max_result, current_result)
    # ...
```

---

## Interview Tips

**If asked about Diameter of Binary Tree:**

1. **Clarify the problem**
   - "Diameter is longest path between any two nodes?"
   - "Measured in edges, not nodes?"
   - "Path may not pass through root?"

2. **Explain approach**
   - "I'll use post-order DFS"
   - "Calculate height of each subtree"
   - "Diameter through node = left_height + right_height"
   - "Track global maximum"

3. **Walk through example**
   ```
   Tree: [1,2,3,4,5]
   
   At node 2: left=1, right=1, diameter=2
   At node 1: left=2, right=1, diameter=3
   
   Answer: 3
   ```

4. **Code it up**
   - Start with base case
   - Recursive calls for left and right
   - Update global maximum
   - Return height to parent

5. **Test edge cases**
   - Single node: diameter = 0
   - Two nodes: diameter = 1
   - Skewed tree: diameter = height

6. **Mention complexity**
   - Time: O(n) - visit each node once
   - Space: O(h) - recursion stack

**Time to explain:** 5-7 minutes

---

## Key Takeaways

1. **Diameter ≠ Height** - Different concepts, both needed
2. **Post-order traversal** - Must process children first
3. **Global maximum** - Diameter might not pass through root
4. **Count edges** - Not nodes!
5. **Return height** - Parent needs this for its calculation
6. **O(n) solution** - Visit each node exactly once
7. **Common pattern** - Used in many tree path problems

---

**End of Day 59 Notes**

*Master diameter calculation and you've mastered a key tree pattern!* 🎯
