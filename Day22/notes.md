# Day 22: Subtree of Another Tree

## Problem: Subtree of Another Tree

### Problem Statement
Given roots of two binary trees `root` and `subRoot`, return true if there is a subtree of `root` with the same structure and node values as `subRoot`.

**Subtree Definition**: A subtree consists of a node and ALL its descendants.

### Problem Logic
Need to check if `subRoot` appears as a complete subtree anywhere in `root`. This requires:
1. Finding a matching root node in the main tree
2. Verifying the entire subtree matches from that point

### Core Insight
**Two-Level Check**:
1. **Outer Search**: Traverse main tree to find potential matching nodes
2. **Inner Comparison**: At each node, check if subtrees are identical (reuse "Same Tree" logic)

---

## Approach 1: DFS with Same Tree Check ⭐

### Pseudocode
```
IS_SUBTREE(root, subRoot):
    if root is None:
        return False
    
    # Check if current node matches
    if IS_SAME_TREE(root, subRoot):
        return True
    
    # Search in left or right subtree
    return IS_SUBTREE(root.left, subRoot) OR 
           IS_SUBTREE(root.right, subRoot)

IS_SAME_TREE(p, q):
    if p is None and q is None:
        return True
    if p is None or q is None:
        return False
    if p.val != q.val:
        return False
    
    return IS_SAME_TREE(p.left, q.left) AND 
           IS_SAME_TREE(p.right, q.right)
```

### Visual Flow
```
Example 1: root = [3,4,5,1,2], subRoot = [4,1,2]

Main Tree:          SubRoot:
      3                4
     / \              / \
    4   5            1   2
   / \
  1   2

Step-by-step:
1. isSubtree(3, [4,1,2])
   ├── isSameTree(3, 4)? → False (3 ≠ 4)
   ├── isSubtree(4, [4,1,2])
   │   └── isSameTree(4, 4)? → True ✓
   │       ├── 4 == 4 ✓
   │       ├── isSameTree(1, 1) → True ✓
   │       └── isSameTree(2, 2) → True ✓
   └── Result: True

Example 2: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]

Main Tree:          SubRoot:
      3                4
     / \              / \
    4   5            1   2
   / \
  1   2
     /
    0

Step-by-step:
1. isSubtree(3, [4,1,2])
   ├── isSameTree(3, 4)? → False
   ├── isSubtree(4, [4,1,2])
   │   └── isSameTree(4, 4)?
   │       ├── 4 == 4 ✓
   │       ├── isSameTree(1, 1) → True ✓
   │       └── isSameTree(2, 2)?
   │           ├── 2 == 2 ✓
   │           ├── isSameTree(0, None) → False ✗
   │           └── Result: False
   └── isSubtree(5, [4,1,2]) → False
Result: False
```

### Execution Trace
```
isSubtree(root=3, subRoot=4)
│
├─ isSameTree(3, 4) → False
│
├─ isSubtree(root.left=4, subRoot=4)
│  │
│  ├─ isSameTree(4, 4)
│  │  ├─ 4 == 4 ✓
│  │  ├─ isSameTree(1, 1) → True
│  │  └─ isSameTree(2, 2) → True
│  │
│  └─ Return True ✓
│
└─ Short-circuit (OR found True)
```

### Complexity
- **Time**: O(n × m) where n = nodes in root, m = nodes in subRoot
  - Worst case: Check every node in root (n), each check compares m nodes
- **Space**: O(h₁ + h₂) for recursion stack
  - h₁ = height of root, h₂ = height of subRoot

---

## Approach 2: Serialization with String Matching

### Problem Logic
Serialize both trees to strings, then check if subRoot's serialization is a substring of root's serialization.

### Pseudocode
```
IS_SUBTREE(root, subRoot):
    root_str = SERIALIZE(root)
    sub_str = SERIALIZE(subRoot)
    
    return sub_str in root_str

SERIALIZE(root):
    if root is None:
        return "."
    
    # Use delimiters to avoid false matches
    return "(" + str(root.val) + ")" + 
           SERIALIZE(root.left) + 
           SERIALIZE(root.right)
```

### Visual Flow
```
Example: root = [3,4,5,1,2], subRoot = [4,1,2]

Serialize root:
      3
     / \
    4   5
   / \
  1   2

Preorder with markers: "(3)(4)(1)..(.)(2)..(5).."

Serialize subRoot:
    4
   / \
  1   2

Preorder with markers: "(4)(1)..(.)(2).."

Check: "(4)(1)..(.)(2).." in "(3)(4)(1)..(.)(2)..(5).."
Result: True ✓
```

### Why Delimiters?
```
Without delimiters:
Tree 1: [12]     → "12"
Tree 2: [1,2]    → "12"
False match! ✗

With delimiters:
Tree 1: [12]     → "(12).."
Tree 2: [1,2]    → "(1)(2).."
Correct! ✓
```

### Complexity
- **Time**: O(n + m) for serialization + O(n) for substring search = O(n + m)
- **Space**: O(n + m) for storing serialized strings

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **DFS + Same Tree** ⭐ | O(n × m) | O(h₁ + h₂) | Intuitive, reuses same tree logic | Slower for large trees |
| **Serialization** | O(n + m) | O(n + m) | Faster time complexity | More space, string overhead |
| **Hash-based** | O(n + m) | O(n + m) | Fast with hashing | Complex implementation |

**Best Choice**: DFS + Same Tree for clarity and moderate input sizes

---

## Key Patterns

### Pattern 1: Nested Tree Traversal
```
Outer function: Traverse main tree
Inner function: Compare subtrees at each node

isSubtree(root, subRoot):
    ├── Traverse root (DFS/BFS)
    └── At each node: isSameTree(node, subRoot)
```

### Pattern 2: Reusing Helper Functions
```
Problem decomposition:
1. Subtree check = Tree traversal + Tree comparison
2. Reuse isSameTree from previous problem
3. Combine with DFS traversal
```

### Pattern 3: String Matching for Trees
```
Tree problem → String problem
1. Serialize trees to strings
2. Use string matching algorithms
3. Be careful with delimiters
```

---

## Critical Insights

### 1. Subtree vs Subset
```
Subtree (✓):        Subset (✗):
    4                  3
   / \                / \
  1   2              4   5
                    /
Must include       1
ALL descendants    (missing 2)
```

### 2. Edge Cases
```
Case 1: subRoot is None
- Technically None is subtree of any tree
- Usually return True

Case 2: root is None, subRoot is not
- Cannot find non-empty subtree in empty tree
- Return False

Case 3: Single node match
- If root.val == subRoot.val and both are leaves
- Return True
```

### 3. Why OR in Outer, AND in Inner?
```
Outer (isSubtree):
- Need to find match in LEFT OR RIGHT
- Only one match needed
- Use OR

Inner (isSameTree):
- Need LEFT AND RIGHT to match
- Both must be identical
- Use AND
```

---

## Implementation Tips

### Tip 1: Separate Concerns
```python
# Good: Two separate functions
def isSubtree(root, subRoot):
    # Handles traversal
    ...

def isSameTree(p, q):
    # Handles comparison
    ...

# Bad: Mixed logic in one function
def isSubtree(root, subRoot):
    # Traversal + comparison mixed
    ...
```

### Tip 2: Base Cases Order
```python
# Optimal order:
1. Check if root is None → False
2. Check if trees are same → True
3. Recurse on children → OR

# Why this order?
- Early exit if no tree to search
- Early exit if match found
- Continue search otherwise
```

### Tip 3: Short-circuit Evaluation
```python
# Python evaluates OR left-to-right
return isSubtree(root.left, subRoot) or isSubtree(root.right, subRoot)

# If left returns True, right is NOT evaluated
# Saves unnecessary computation
```

---

## Day 22 Summary

### Key Concepts
1. **Subtree**: Must include ALL descendants from matching node
2. **Two-Level Check**: Traverse + Compare
3. **Function Reuse**: Leverage isSameTree from Day 21
4. **Serialization**: Alternative approach using string matching

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Subtree Check | Nested Traversal | DFS + Same Tree | O(n × m) |
| Tree Comparison | Parallel DFS | Simultaneous traversal | O(m) |
| Serialization | String Matching | Preorder with markers | O(n + m) |

### Complexity Analysis

| Operation | Time | Space | Notes |
|-----------|------|-------|-------|
| **isSubtree** | O(n × m) | O(h₁ + h₂) | Check each node |
| **isSameTree** | O(m) | O(h₂) | Compare subtrees |
| **Serialize** | O(n) | O(n) | Build string |

### Common Mistakes
1. ❌ Forgetting to check if root is None before recursing
2. ❌ Using AND instead of OR in outer function
3. ❌ Not including delimiters in serialization (false positives)
4. ❌ Confusing subtree (all descendants) with subset (partial)
5. ❌ Checking only root values without verifying entire subtree

### Problem-Solving Strategy
```
Step 1: Identify if problem needs nested traversal
Step 2: Reuse existing helper functions (isSameTree)
Step 3: Choose approach based on constraints:
        - Small/medium trees → DFS + Same Tree
        - Large trees with many checks → Serialization
Step 4: Handle edge cases (None trees)
```

### Master Checklist
- [ ] Can implement subtree check using DFS + Same Tree
- [ ] Understand why OR is used in outer function
- [ ] Can serialize tree with proper delimiters
- [ ] Know when to use each approach
- [ ] Can identify subtree vs subset difference
- [ ] Understand time complexity O(n × m) derivation
- [ ] Can reuse helper functions from previous problems

### Related Problems
- Same Tree (Day 21) - Building block for subtree check
- Serialize/Deserialize Binary Tree - Uses serialization pattern
- Symmetric Tree - Similar comparison logic
- Tree Isomorphism - Extended comparison with structure flexibility
