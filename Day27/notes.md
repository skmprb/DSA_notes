# Day 27: Search Insert Position

## Problem: Search Insert Position

### Problem Statement
Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

**Constraint**: Must write an algorithm with O(log n) runtime complexity.

### Problem Logic
Classic binary search problem with a twist: if target not found, return insertion position.

---

## Approach 1: Binary Search ⭐

### Core Insight
Use binary search to find target. If not found, `left` pointer will be at the correct insertion position.

### Pseudocode
```
SEARCH_INSERT(nums, target):
    left = 0
    right = len(nums) - 1
    
    while left <= right:
        mid = (left + right) // 2
        
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return left
```

### Visual Flow
```
Example 1: nums = [1,3,5,6], target = 5

Initial:
[1, 3, 5, 6]
 ↑     ↑  ↑
left  mid right

Step 1: mid = (0+3)//2 = 1
nums[1] = 3 < 5
left = mid + 1 = 2

[1, 3, 5, 6]
       ↑  ↑
      left right

Step 2: mid = (2+3)//2 = 2
nums[2] = 5 == 5
Return 2 ✓

Example 2: nums = [1,3,5,6], target = 2

Initial:
[1, 3, 5, 6]
 ↑     ↑  ↑
left  mid right

Step 1: mid = (0+3)//2 = 1
nums[1] = 3 > 2
right = mid - 1 = 0

[1, 3, 5, 6]
 ↑
left/right

Step 2: mid = (0+0)//2 = 0
nums[0] = 1 < 2
left = mid + 1 = 1

[1, 3, 5, 6]
    ↑
   left (right=0)

left > right, exit loop
Return left = 1 ✓
(Insert at index 1: [1, 2, 3, 5, 6])
```

### Step-by-Step Examples

#### Example 1: Target Found
```
nums = [1,3,5,6], target = 5

Iteration 1:
left=0, right=3, mid=1
nums[1]=3 < 5 → left=2

Iteration 2:
left=2, right=3, mid=2
nums[2]=5 == 5 → return 2
```

#### Example 2: Insert in Middle
```
nums = [1,3,5,6], target = 2

Iteration 1:
left=0, right=3, mid=1
nums[1]=3 > 2 → right=0

Iteration 2:
left=0, right=0, mid=0
nums[0]=1 < 2 → left=1

left > right, return left=1
Result: [1, 2, 3, 5, 6]
```

#### Example 3: Insert at Beginning
```
nums = [1,3,5,6], target = 0

Iteration 1:
left=0, right=3, mid=1
nums[1]=3 > 0 → right=0

Iteration 2:
left=0, right=0, mid=0
nums[0]=1 > 0 → right=-1

left > right, return left=0
Result: [0, 1, 3, 5, 6]
```

#### Example 4: Insert at End
```
nums = [1,3,5,6], target = 7

Iteration 1:
left=0, right=3, mid=1
nums[1]=3 < 7 → left=2

Iteration 2:
left=2, right=3, mid=2
nums[2]=5 < 7 → left=3

Iteration 3:
left=3, right=3, mid=3
nums[3]=6 < 7 → left=4

left > right, return left=4
Result: [1, 3, 5, 6, 7]
```

### Why `left` is the Answer?
```
When loop exits (left > right):

Case 1: Target smaller than all elements
right becomes -1, left stays 0
Insert at beginning → return 0

Case 2: Target larger than all elements
left becomes len(nums)
Insert at end → return len(nums)

Case 3: Target between elements
left points to first element > target
Insert before it → return left

Key Insight: Binary search naturally positions
left at the correct insertion point!
```

### Complexity
- **Time**: O(log n) - binary search
- **Space**: O(1) - only pointers

---

## Approach 2: Linear Search

### Pseudocode
```
SEARCH_INSERT_LINEAR(nums, target):
    for i in range(len(nums)):
        if nums[i] >= target:
            return i
    
    return len(nums)
```

### Visual Flow
```
nums = [1,3,5,6], target = 2

i=0: nums[0]=1 < 2, continue
i=1: nums[1]=3 >= 2, return 1

nums = [1,3,5,6], target = 7

i=0: nums[0]=1 < 7, continue
i=1: nums[1]=3 < 7, continue
i=2: nums[2]=5 < 7, continue
i=3: nums[3]=6 < 7, continue
Loop ends, return len(nums)=4
```

### Complexity
- **Time**: O(n) - linear scan
- **Space**: O(1) - only pointer
- **Issue**: Does NOT meet O(log n) requirement ✗

---

## Approach Comparison

| Approach | Time | Space | Meets Requirement | Notes |
|----------|------|-------|-------------------|-------|
| **Binary Search** ⭐ | O(log n) | O(1) | ✓ | Optimal solution |
| **Linear Search** | O(n) | O(1) | ✗ | Too slow |
| **Built-in bisect** | O(log n) | O(1) | ✓ | Python library |

---

## Python bisect Module

### Using bisect_left
```python
import bisect

def searchInsert(nums, target):
    return bisect.bisect_left(nums, target)
```

### How bisect_left Works
```
bisect_left finds the leftmost insertion point:

nums = [1,3,3,3,5], target = 3
bisect_left returns 1 (before first 3)

nums = [1,3,5,6], target = 2
bisect_left returns 1 (between 1 and 3)
```

---

## Critical Insights

### 1. Binary Search Invariant
```
After each iteration:
- All elements in nums[0:left] < target
- All elements in nums[right+1:] > target

When left > right:
- left is the insertion position
```

### 2. Loop Termination
```
Loop continues while left <= right

When left > right:
- Binary search complete
- left points to insertion position
- No need for extra logic!
```

### 3. Mid Calculation
```
mid = (left + right) // 2

Why not (left + right) / 2?
- Integer division needed
- Avoids floating point

Overflow-safe version:
mid = left + (right - left) // 2
```

### 4. All Four Cases Covered
```
Case 1: Target found
→ Return mid

Case 2: Insert at beginning
→ left = 0

Case 3: Insert in middle
→ left = insertion index

Case 4: Insert at end
→ left = len(nums)

Single algorithm handles all!
```

---

## Common Mistakes

1. ❌ **Using `<` instead of `<=`**: Loop exits too early
2. ❌ **Returning `mid` when not found**: Should return `left`
3. ❌ **Wrong mid calculation**: Using `/` instead of `//`
4. ❌ **Not handling edge cases**: Empty array, insert at end
5. ❌ **Using linear search**: Doesn't meet O(log n) requirement

---

## Edge Cases

```python
# Case 1: Empty array
nums = [], target = 5
Output: 0

# Case 2: Single element (found)
nums = [5], target = 5
Output: 0

# Case 3: Single element (not found, insert before)
nums = [5], target = 3
Output: 0

# Case 4: Single element (not found, insert after)
nums = [5], target = 7
Output: 1

# Case 5: Insert at beginning
nums = [1,3,5,6], target = 0
Output: 0

# Case 6: Insert at end
nums = [1,3,5,6], target = 7
Output: 4

# Case 7: Insert in middle
nums = [1,3,5,6], target = 2
Output: 1

# Case 8: Target exists
nums = [1,3,5,6], target = 5
Output: 2
```

---

## Binary Search Template

### Standard Template
```python
def binarySearch(nums, target):
    left, right = 0, len(nums) - 1
    
    while left <= right:
        mid = left + (right - left) // 2
        
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return -1  # Not found
```

### Search Insert Position Template
```python
def searchInsert(nums, target):
    left, right = 0, len(nums) - 1
    
    while left <= right:
        mid = left + (right - left) // 2
        
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return left  # Insertion position
```

### Key Difference
```
Standard Binary Search:
- Return -1 if not found

Search Insert Position:
- Return left (insertion position) if not found
```

---

## Visualization of Binary Search

```
nums = [1, 3, 5, 6], target = 2

Step 1:
[1, 3, 5, 6]
 L     M     R
nums[M]=3 > 2 → R = M-1

Step 2:
[1, 3, 5, 6]
 L/R
 M
nums[M]=1 < 2 → L = M+1

Step 3:
[1, 3, 5, 6]
    L
(R is at index 0, L > R)

Return L = 1
Insert position: [1, 2, 3, 5, 6]
                     ↑
```

---

## Decision Tree

```
searchInsert(nums, target)
    │
    ├─ Initialize left=0, right=len(nums)-1
    │
    └─ While left <= right
        │
        ├─ Calculate mid = (left + right) // 2
        │
        └─ Compare nums[mid] with target
            │
            ├─ nums[mid] == target → return mid
            │
            ├─ nums[mid] < target → left = mid + 1
            │
            └─ nums[mid] > target → right = mid - 1
    
    └─ Return left (insertion position)
```

---

## Day 27 Summary

### Key Concepts
1. **Binary Search**: Divide and conquer on sorted array
2. **Insertion Position**: `left` pointer after search
3. **O(log n)**: Halve search space each iteration
4. **Loop Invariant**: Elements before left < target

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Search Insert | Binary Search | Return left on exit | O(log n) |
| Find Target | Binary Search | Return mid or -1 | O(log n) |
| Find Range | Binary Search | Two searches | O(log n) |

### Binary Search Variants

| Variant | Return Value | Use Case |
|---------|--------------|----------|
| **Standard** | mid or -1 | Find exact match |
| **Insert Position** | left | Find insertion point |
| **Lower Bound** | First >= target | Range queries |
| **Upper Bound** | First > target | Range queries |

### Critical Insights
1. **left Pointer**: Always points to insertion position
2. **Loop Condition**: `left <= right` ensures all elements checked
3. **Mid Calculation**: Use `//` for integer division
4. **No Extra Logic**: Binary search naturally finds position

### When to Use Binary Search
- Sorted array
- Need O(log n) time
- Search or insertion problems
- Range queries

### Master Checklist
- [ ] Can implement standard binary search
- [ ] Understand why `left` is insertion position
- [ ] Know loop condition `left <= right`
- [ ] Can handle all edge cases
- [ ] Understand mid calculation
- [ ] Know when binary search applies
- [ ] Can modify for variants (lower/upper bound)

### Related Problems
- Binary Search
- First Bad Version
- Search in Rotated Sorted Array
- Find First and Last Position
- Search a 2D Matrix
- Sqrt(x)
- Peak Index in Mountain Array
