# Day 25: Remove Element & Balanced Binary Tree

## Problem 1: Remove Element (Array)

### Problem Statement
Given an integer array `nums` and an integer `val`, remove all occurrences of `val` in-place. Return the number of elements not equal to `val`.

**Requirements**:
- Modify array in-place
- First k elements should contain non-val elements
- Order doesn't matter
- Return k (count of non-val elements)

### Problem Logic
Need to remove elements efficiently without creating new array. Two main strategies: overwrite or swap with end.

---

## Approach 1: Two Pointers (Overwrite) ⭐

### Core Insight
Use slow pointer (k) to track position for next valid element. Fast pointer (i) scans array. When valid element found, copy to position k.

### Pseudocode
```
REMOVE_ELEMENT(nums, val):
    k = 0
    
    for i in range(len(nums)):
        if nums[i] != val:
            nums[k] = nums[i]
            k++
    
    return k
```

### Visual Flow
```
Example: nums = [3,2,2,3], val = 3

Initial:
nums: [3, 2, 2, 3]
       ↑
      k=0, i=0

Step 1: i=0, nums[0]=3 (equals val)
Skip, k stays 0
nums: [3, 2, 2, 3]
       ↑
      k=0

Step 2: i=1, nums[1]=2 (not val)
Copy to k: nums[0] = 2, k++
nums: [2, 2, 2, 3]
          ↑
         k=1

Step 3: i=2, nums[2]=2 (not val)
Copy to k: nums[1] = 2, k++
nums: [2, 2, 2, 3]
             ↑
            k=2

Step 4: i=3, nums[3]=3 (equals val)
Skip, k stays 2
nums: [2, 2, 2, 3]
             ↑
            k=2

Result: k=2, nums=[2, 2, _, _]
```

### Complexity
- **Time**: O(n) - single pass
- **Space**: O(1) - in-place modification

---

## Approach 2: Swap with End

### Core Insight
When val found, swap with last element and reduce array size. Don't increment pointer after swap (need to check swapped element).

### Pseudocode
```
REMOVE_ELEMENT_SWAP(nums, val):
    n = len(nums)
    i = 0
    
    while i < n:
        if nums[i] == val:
            nums[i] = nums[n-1]
            n--
        else:
            i++
    
    return n
```

### Visual Flow
```
Example: nums = [3,2,2,3], val = 3

Initial:
nums: [3, 2, 2, 3]
       ↑        ↑
      i=0      n=4

Step 1: nums[0]=3 (equals val)
Swap with nums[3]: nums[0] = 3
n = 3 (don't increment i)
nums: [3, 2, 2, 3]
       ↑     ↑
      i=0   n=3

Step 2: nums[0]=3 (equals val again!)
Swap with nums[2]: nums[0] = 2
n = 2 (don't increment i)
nums: [2, 2, 2, 3]
       ↑  ↑
      i=0 n=2

Step 3: nums[0]=2 (not val)
i = 1
nums: [2, 2, 2, 3]
          ↑  ↑
         i=1 n=2

Step 4: nums[1]=2 (not val)
i = 2, i >= n, stop
nums: [2, 2, 2, 3]
             ↑
            n=2

Result: n=2, nums=[2, 2, _, _]
```

### Complexity
- **Time**: O(n) - worst case visits all elements
- **Space**: O(1) - in-place modification

---

## Approach 3: Reverse Iteration with Pop

### Core Insight
Iterate backwards and pop elements. Avoids index shifting issues when removing.

### Pseudocode
```
REMOVE_ELEMENT_POP(nums, val):
    for i in range(len(nums)-1, -1, -1):
        if nums[i] == val:
            nums.pop(i)
    
    return len(nums)
```

### Visual Flow
```
Example: nums = [3,2,2,3], val = 3

Iterate backwards:
i=3: nums[3]=3 → pop → [3, 2, 2]
i=2: nums[2]=2 → skip → [3, 2, 2]
i=1: nums[1]=2 → skip → [3, 2, 2]
i=0: nums[0]=3 → pop → [2, 2]

Result: len=2, nums=[2, 2]
```

### Complexity
- **Time**: O(n²) - pop is O(n), done n times
- **Space**: O(1) - in-place modification
- **Issue**: Inefficient due to array shifting ✗

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Two Pointers** ⭐ | O(n) | O(1) | Simple, efficient | Overwrites elements |
| **Swap with End** | O(n) | O(1) | Fewer writes | Order not preserved |
| **Reverse Pop** | O(n²) | O(1) | Clean code | Inefficient |

**Best Choice**: Two Pointers for simplicity and efficiency

---

## Problem 2: Balanced Binary Tree

### Problem Statement
Determine if a binary tree is height-balanced. A tree is balanced if for every node, the height difference between left and right subtrees is at most 1.

### Problem Logic
**Balanced Tree Definition**:
1. Left subtree is balanced
2. Right subtree is balanced
3. |height(left) - height(right)| ≤ 1

### Core Insight
Calculate height and check balance simultaneously using post-order traversal. Return both height and balance status.

---

## Approach: Post-Order DFS ⭐

### Pseudocode
```
IS_BALANCED(root):
    HELPER(node):
        if node is None:
            return (0, True)  # (height, is_balanced)
        
        left_height, left_balanced = HELPER(node.left)
        right_height, right_balanced = HELPER(node.right)
        
        height = max(left_height, right_height) + 1
        
        is_balanced = (left_balanced AND 
                      right_balanced AND 
                      abs(left_height - right_height) <= 1)
        
        return (height, is_balanced)
    
    height, is_balanced = HELPER(root)
    return is_balanced
```

### Visual Flow
```
Example 1: Balanced Tree
        3
       / \
      9   20
         /  \
        15   7

helper(3)
├── helper(9)
│   ├── helper(None) → (0, True)
│   ├── helper(None) → (0, True)
│   └── return (1, True)  # height=1, balanced
│
└── helper(20)
    ├── helper(15)
    │   ├── helper(None) → (0, True)
    │   ├── helper(None) → (0, True)
    │   └── return (1, True)
    │
    ├── helper(7)
    │   ├── helper(None) → (0, True)
    │   ├── helper(None) → (0, True)
    │   └── return (1, True)
    │
    └── return (2, True)  # height=2, balanced

Check at root (3):
left_height = 1, right_height = 2
|1 - 2| = 1 ≤ 1 ✓
Both subtrees balanced ✓
Result: (3, True)

Example 2: Unbalanced Tree
        1
       /
      2
     /
    3

helper(1)
├── helper(2)
│   ├── helper(3)
│   │   ├── helper(None) → (0, True)
│   │   ├── helper(None) → (0, True)
│   │   └── return (1, True)
│   │
│   ├── helper(None) → (0, True)
│   └── return (2, True)  # height=2, balanced
│
└── helper(None) → (0, True)

Check at root (1):
left_height = 2, right_height = 0
|2 - 0| = 2 > 1 ✗
Result: (3, False)
```

### Step-by-Step Example
```
Tree:     5
         / \
        8   10
       / \
      3   4
     /
    13

Step 1: helper(13)
left = (0, True), right = (0, True)
height = 1, balanced = True
return (1, True)

Step 2: helper(3)
left = (1, True), right = (0, True)
height = 2, |1-0| = 1 ≤ 1 ✓
return (2, True)

Step 3: helper(4)
left = (0, True), right = (0, True)
height = 1, balanced = True
return (1, True)

Step 4: helper(8)
left = (2, True), right = (1, True)
height = 3, |2-1| = 1 ≤ 1 ✓
return (3, True)

Step 5: helper(10)
left = (0, True), right = (0, True)
height = 1, balanced = True
return (1, True)

Step 6: helper(5)
left = (3, True), right = (1, True)
height = 4, |3-1| = 2 > 1 ✗
return (4, False)

Result: False (unbalanced)
```

### Complexity
- **Time**: O(n) - visit each node once
- **Space**: O(h) - recursion stack, h = height

---

## Critical Insights

### Remove Element

#### 1. Two Pointer Pattern
```
Slow pointer (k): Position for next valid element
Fast pointer (i): Scans array

When valid found: Copy to k, increment k
When invalid found: Skip, k unchanged
```

#### 2. Why Swap Approach Works
```
When val found at i:
- Swap with last element
- Reduce size (ignore last)
- Don't increment i (check swapped element)

Example: [3,2,2,3], val=3
[3,2,2,3] → swap 0 with 3 → [3,2,2,3], n=3
[3,2,2] → swap 0 with 2 → [2,2,2], n=2
[2,2] → done
```

#### 3. Order Preservation
```
Two Pointers: Preserves relative order
[3,2,2,3] → [2,2,_,_]

Swap with End: May change order
[3,2,2,3] → [2,2,_,_] or [2,2,_,_]
```

### Balanced Binary Tree

#### 1. Post-Order Traversal
```
Why post-order?
- Need children's heights first
- Calculate parent height from children
- Bottom-up approach

Process: Left → Right → Root
```

#### 2. Early Termination Optimization
```
If subtree unbalanced, no need to check further:

def helper(node):
    if not node:
        return (0, True)
    
    left_height, left_balanced = helper(node.left)
    if not left_balanced:
        return (-1, False)  # Early exit
    
    right_height, right_balanced = helper(node.right)
    if not right_balanced:
        return (-1, False)  # Early exit
    
    # Check current node
    ...
```

#### 3. Height vs Depth
```
Height: Distance from node to deepest leaf
Depth: Distance from root to node

For balanced check, we use HEIGHT:
        1         height=2, depth=0
       / \
      2   3       height=1, depth=1
     /
    4             height=0, depth=2
```

---

## Common Mistakes

### Remove Element
1. ❌ **Incrementing i after swap**: Must check swapped element
2. ❌ **Using pop in forward iteration**: Causes index shifting
3. ❌ **Creating new array**: Problem requires in-place
4. ❌ **Not returning k**: Must return count of valid elements

### Balanced Binary Tree
1. ❌ **Calculating height multiple times**: Inefficient O(n²)
2. ❌ **Forgetting to check subtree balance**: Must check all 3 conditions
3. ❌ **Using absolute value incorrectly**: abs(left - right) ≤ 1
4. ❌ **Confusing height with depth**: Use height for balance check

---

## Edge Cases

### Remove Element
```
Case 1: All elements are val
nums = [3,3,3], val = 3
Result: k=0, nums=[_,_,_]

Case 2: No elements are val
nums = [1,2,3], val = 4
Result: k=3, nums=[1,2,3]

Case 3: Empty array
nums = [], val = 1
Result: k=0, nums=[]

Case 4: Single element
nums = [1], val = 1
Result: k=0, nums=[_]
```

### Balanced Binary Tree
```
Case 1: Empty tree
root = None
Result: True (empty tree is balanced)

Case 2: Single node
root = [1]
Result: True

Case 3: Perfect binary tree
    1
   / \
  2   3
Result: True (all heights equal)

Case 4: Skewed tree
1
 \
  2
   \
    3
Result: False (height diff = 2)
```

---

## Day 25 Summary

### Key Concepts
1. **Two Pointers**: Slow/fast pointer for in-place modification
2. **Swap Strategy**: Swap with end to avoid shifting
3. **Post-Order DFS**: Calculate height bottom-up
4. **Tuple Return**: Return multiple values (height, balanced)

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Remove Element | Two Pointers | Overwrite valid elements | O(n) |
| Balanced Tree | Post-Order DFS | Height + balance check | O(n) |

### Complexity Comparison

#### Remove Element
| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Two Pointers | O(n) | O(1) | General use |
| Swap with End | O(n) | O(1) | Order doesn't matter |
| Reverse Pop | O(n²) | O(1) | Small arrays only |

#### Balanced Tree
| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Post-Order DFS | O(n) | O(h) | Optimal |
| Separate Height Calls | O(n²) | O(h) | Inefficient |

### Critical Insights
1. **In-Place Modification**: Two pointers avoid extra space
2. **Swap Optimization**: Reduces writes when order doesn't matter
3. **Post-Order for Height**: Children before parent
4. **Tuple Return**: Efficient way to return multiple values
5. **Early Termination**: Stop checking if subtree unbalanced

### Master Checklist
- [ ] Can implement two pointer pattern for array modification
- [ ] Understand when to use swap vs overwrite
- [ ] Know why reverse iteration helps with pop
- [ ] Can calculate tree height recursively
- [ ] Understand balanced tree definition (3 conditions)
- [ ] Can implement post-order DFS with tuple return
- [ ] Know difference between height and depth
- [ ] Can optimize with early termination

### Related Problems
**Remove Element Pattern**:
- Remove Duplicates from Sorted Array
- Move Zeroes
- Remove Duplicates from Sorted Array II

**Balanced Tree Pattern**:
- Maximum Depth of Binary Tree
- Minimum Depth of Binary Tree
- Diameter of Binary Tree
- Binary Tree Maximum Path Sum
