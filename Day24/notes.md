# Day 24: Binary Tree Level Order Traversal

## Problem: Binary Tree Level Order Traversal

### Problem Statement
Given the root of a binary tree, return the level order traversal of its nodes' values (i.e., from left to right, level by level).

**Output Format**: List of lists, where each inner list contains all nodes at that level.

### Problem Logic
Need to visit nodes level by level (breadth-first), grouping nodes at the same depth together.

### Core Insight
**BFS with Level Tracking**: Use a queue to process nodes level by level. Key is to process all nodes at current level before moving to next level.

---

## Approach: BFS with Queue ⭐

### Pseudocode
```
LEVEL_ORDER(root):
    if root is None:
        return []
    
    result = []
    queue = [root]
    
    while queue is not empty:
        level_size = len(queue)
        level = []
        
        # Process all nodes at current level
        for i in range(level_size):
            node = queue.dequeue()
            level.append(node.val)
            
            if node.left exists:
                queue.enqueue(node.left)
            if node.right exists:
                queue.enqueue(node.right)
        
        result.append(level)
    
    return result
```

### Visual Flow
```
Example: root = [3,9,20,null,null,15,7]

Tree Structure:
        3
       / \
      9   20
         /  \
        15   7

Level-by-Level Processing:

Initial:
queue = [3]
result = []

Iteration 1 (Level 0):
level_size = 1
Process: 3
  - Add 3 to level: [3]
  - Enqueue children: 9, 20
queue = [9, 20]
result = [[3]]

Iteration 2 (Level 1):
level_size = 2
Process: 9
  - Add 9 to level: [9]
  - No children
Process: 20
  - Add 20 to level: [9, 20]
  - Enqueue children: 15, 7
queue = [15, 7]
result = [[3], [9, 20]]

Iteration 3 (Level 2):
level_size = 2
Process: 15
  - Add 15 to level: [15]
  - No children
Process: 7
  - Add 7 to level: [15, 7]
  - No children
queue = []
result = [[3], [9, 20], [15, 7]]

Final Result: [[3], [9, 20], [15, 7]]
```

### Step-by-Step Execution
```
Tree:     3
         / \
        9   20
           /  \
          15   7

Step 1: Initialize
queue: [3]
result: []

Step 2: Process Level 0
queue before: [3]
level_size: 1
  - Dequeue 3, add to level: [3]
  - Enqueue 9, 20
queue after: [9, 20]
result: [[3]]

Step 3: Process Level 1
queue before: [9, 20]
level_size: 2
  - Dequeue 9, add to level: [9]
  - No children
  - Dequeue 20, add to level: [9, 20]
  - Enqueue 15, 7
queue after: [15, 7]
result: [[3], [9, 20]]

Step 4: Process Level 2
queue before: [15, 7]
level_size: 2
  - Dequeue 15, add to level: [15]
  - No children
  - Dequeue 7, add to level: [15, 7]
  - No children
queue after: []
result: [[3], [9, 20], [15, 7]]

Step 5: Queue empty, return result
```

### Queue State Visualization
```
Level 0:  queue: [3]           → process 3
Level 1:  queue: [9, 20]       → process 9, 20
Level 2:  queue: [15, 7]       → process 15, 7
Level 3:  queue: []            → done

Key Pattern:
- Queue contains nodes from SAME level
- After processing level i, queue contains ALL nodes from level i+1
- level_size captures current level's node count
```

### Why level_size is Critical
```
Without level_size:
queue = [3]
while queue:
    node = queue.pop()
    # Can't distinguish between levels!
    # When do we start new level list?

With level_size:
queue = [3]
while queue:
    level_size = len(queue)  # Snapshot of current level
    for _ in range(level_size):
        node = queue.pop()
        # Process exactly current level nodes
    # Now queue has only next level nodes
```

### Complexity
- **Time**: O(n) - visit each node once
- **Space**: O(w) - queue holds at most one level, w = max width
  - Best case (skewed): O(1)
  - Worst case (complete): O(n/2) = O(n)

---

## Alternative Approaches

### Approach 2: Recursive DFS with Level Tracking

### Pseudocode
```
LEVEL_ORDER_DFS(root):
    result = []
    
    DFS(node, level):
        if node is None:
            return
        
        # Ensure result has list for this level
        if len(result) == level:
            result.append([])
        
        # Add current node to its level
        result[level].append(node.val)
        
        # Recurse on children with level + 1
        DFS(node.left, level + 1)
        DFS(node.right, level + 1)
    
    DFS(root, 0)
    return result
```

### Visual Flow (DFS)
```
Tree:     3
         / \
        9   20
           /  \
          15   7

DFS Traversal (Preorder with level):
dfs(3, level=0)
├── result[0] = [3]
├── dfs(9, level=1)
│   ├── result[1] = [9]
│   ├── dfs(None, level=2)
│   └── dfs(None, level=2)
└── dfs(20, level=1)
    ├── result[1] = [9, 20]
    ├── dfs(15, level=2)
    │   ├── result[2] = [15]
    │   ├── dfs(None, level=3)
    │   └── dfs(None, level=3)
    └── dfs(7, level=2)
        ├── result[2] = [15, 7]
        ├── dfs(None, level=3)
        └── dfs(None, level=3)

Result: [[3], [9, 20], [15, 7]]
```

### Complexity (DFS)
- **Time**: O(n) - visit each node once
- **Space**: O(h) - recursion stack, h = height

---

## Approach Comparison

| Approach | Method | Time | Space | Pros | Cons |
|----------|--------|------|-------|------|------|
| **BFS with Queue** ⭐ | Iterative | O(n) | O(w) | Natural for level order, intuitive | Extra queue space |
| **DFS with Level** | Recursive | O(n) | O(h) | Less space for skewed trees | Less intuitive |

**Best Choice**: BFS with Queue - most natural and intuitive for level order traversal

---

## Key Patterns

### Pattern 1: Level-by-Level Processing
```
Standard BFS template for level order:

queue = [root]
while queue:
    level_size = len(queue)  # Snapshot
    level = []
    
    for _ in range(level_size):
        node = queue.pop(0)
        level.append(node.val)
        
        # Add children for next level
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    result.append(level)
```

### Pattern 2: Queue as Level Separator
```
Queue state after each level:

After Level 0: [nodes from level 1]
After Level 1: [nodes from level 2]
After Level 2: [nodes from level 3]
...

Queue naturally separates levels!
```

### Pattern 3: DFS with Level Parameter
```
Recursive template with level tracking:

def dfs(node, level):
    if not node:
        return
    
    # Ensure result has list for this level
    if len(result) == level:
        result.append([])
    
    # Process current node
    result[level].append(node.val)
    
    # Recurse with level + 1
    dfs(node.left, level + 1)
    dfs(node.right, level + 1)
```

---

## Critical Insights

### 1. Why BFS for Level Order?
```
BFS naturally processes level by level:
- Queue maintains FIFO order
- All nodes at level i processed before level i+1
- Perfect match for level order requirement

DFS processes depth-first:
- Needs extra level parameter
- Less intuitive for level grouping
```

### 2. level_size Snapshot
```
Why capture level_size before loop?

queue = [9, 20]
level_size = 2  # Snapshot

for _ in range(2):
    node = queue.pop(0)
    # Even though we add children to queue,
    # we only process 2 nodes (current level)
    queue.append(node.children)

After loop:
queue = [15, 7]  # Next level only
```

### 3. Queue vs Stack
```
Queue (FIFO):
[3] → [9, 20] → [15, 7]
Level by level ✓

Stack (LIFO):
[3] → [20, 9] → [7, 15]
Depth first, not level order ✗
```

### 4. Space Complexity Analysis
```
BFS Space: O(w) where w = max width

Complete Binary Tree:
        1
       / \
      2   3
     / \ / \
    4 5 6 7

Level 0: 1 node
Level 1: 2 nodes
Level 2: 4 nodes (max width)

Queue max size = 4 = n/2 = O(n)

Skewed Tree:
1
 \
  2
   \
    3

Queue max size = 1 = O(1)
```

---

## Variations of Level Order Traversal

### Variation 1: Right to Left
```python
def levelOrderRightToLeft(root):
    result = []
    queue = [root]
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.pop(0)
            level.append(node.val)
            
            # Add right child first!
            if node.right:
                queue.append(node.right)
            if node.left:
                queue.append(node.left)
        
        result.append(level)
    
    return result
```

### Variation 2: Bottom-Up (Reverse Level Order)
```python
def levelOrderBottomUp(root):
    result = []
    queue = [root]
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.pop(0)
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result[::-1]  # Reverse at end
```

### Variation 3: Zigzag Level Order
```python
def zigzagLevelOrder(root):
    result = []
    queue = [root]
    left_to_right = True
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.pop(0)
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        if not left_to_right:
            level.reverse()
        
        result.append(level)
        left_to_right = not left_to_right
    
    return result
```

### Variation 4: Level Averages
```python
def averageOfLevels(root):
    result = []
    queue = [root]
    
    while queue:
        level_size = len(queue)
        level_sum = 0
        
        for _ in range(level_size):
            node = queue.pop(0)
            level_sum += node.val
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level_sum / level_size)
    
    return result
```

---

## Edge Cases

### Case 1: Empty Tree
```
Input: root = None
Output: []

queue = [None]
if root is None:
    return []
```

### Case 2: Single Node
```
Input: root = [1]
Output: [[1]]

Tree: 1

queue = [1]
level_size = 1
Process 1: level = [1]
queue = []
result = [[1]]
```

### Case 3: Skewed Tree
```
Input: root = [1,null,2,null,3]

Tree:  1
        \
         2
          \
           3

Level 0: [1]
Level 1: [2]
Level 2: [3]

Output: [[1], [2], [3]]
```

### Case 4: Complete Binary Tree
```
Input: root = [1,2,3,4,5,6,7]

Tree:      1
         /   \
        2     3
       / \   / \
      4   5 6   7

Level 0: [1]
Level 1: [2, 3]
Level 2: [4, 5, 6, 7]

Output: [[1], [2, 3], [4, 5, 6, 7]]
```

---

## Implementation Tips

### Tip 1: Use deque for Efficiency
```python
from collections import deque

# Efficient O(1) operations
queue = deque([root])
node = queue.popleft()  # O(1)
queue.append(child)      # O(1)

# vs list (inefficient)
queue = [root]
node = queue.pop(0)      # O(n) - shifts all elements
queue.append(child)      # O(1)
```

### Tip 2: Handle None Root Early
```python
def levelOrder(root):
    if not root:
        return []
    
    # Rest of code assumes root exists
    queue = [root]
    ...
```

### Tip 3: Snapshot level_size
```python
# Correct
level_size = len(queue)
for _ in range(level_size):
    # Process exactly current level

# Wrong
for _ in range(len(queue)):
    # len(queue) changes during loop!
```

---

## Common Mistakes

1. ❌ **Not capturing level_size**: Processing wrong number of nodes per level
2. ❌ **Using stack instead of queue**: Results in DFS, not BFS
3. ❌ **Forgetting to check None root**: Causes errors on empty tree
4. ❌ **Adding None children to queue**: Wastes space and needs extra checks
5. ❌ **Using list.pop(0)**: O(n) operation, use deque.popleft() instead

---

## Decision Tree

```
levelOrder(root)
    │
    ├─ root is None? ──Yes──> return []
    │       │
    │      No
    │       │
    └─ Initialize queue with root
        │
        └─ While queue not empty
            │
            ├─ Capture level_size = len(queue)
            │
            ├─ Create empty level list
            │
            └─ For each node in current level
                │
                ├─ Dequeue node
                ├─ Add node.val to level
                ├─ Enqueue left child (if exists)
                └─ Enqueue right child (if exists)
            
            └─ Append level to result
```

---

## Day 24 Summary

### Key Concepts
1. **BFS**: Breadth-First Search using queue
2. **Level Tracking**: Use level_size to separate levels
3. **Queue FIFO**: First In First Out maintains level order
4. **Snapshot Pattern**: Capture queue size before processing

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Level Order | BFS | Queue with level_size | O(n) |
| Zigzag Order | BFS | Alternate reverse | O(n) |
| Bottom-Up | BFS | Reverse result | O(n) |
| Level Averages | BFS | Sum per level | O(n) |

### BFS Template
```python
def bfs_level_order(root):
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

### Critical Insights
1. **BFS = Level Order**: Natural fit for level-by-level processing
2. **level_size Snapshot**: Key to separating levels
3. **Queue State**: After processing level i, contains only level i+1
4. **Space Tradeoff**: O(w) for BFS vs O(h) for DFS
5. **Use deque**: O(1) popleft vs O(n) for list.pop(0)

### When to Use BFS
- Level order traversal
- Shortest path in unweighted graph
- Find nodes at distance k
- Level-wise processing needed
- Minimum depth problems

### Master Checklist
- [ ] Understand BFS vs DFS for trees
- [ ] Can implement level order with queue
- [ ] Know why level_size snapshot is needed
- [ ] Can handle edge cases (None root, single node)
- [ ] Understand space complexity O(w)
- [ ] Can implement variations (zigzag, bottom-up)
- [ ] Know when to use deque vs list
- [ ] Can apply BFS template to similar problems

### Related Problems
- Binary Tree Zigzag Level Order Traversal
- Binary Tree Level Order Traversal II (bottom-up)
- Average of Levels in Binary Tree
- Binary Tree Right Side View
- Minimum Depth of Binary Tree
- Maximum Width of Binary Tree
