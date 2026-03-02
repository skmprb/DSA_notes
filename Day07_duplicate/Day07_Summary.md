# Day 07 Summary - Advanced Array Problems

## Overview

**Day 07** covers two advanced array manipulation problems:
1. **Find the Duplicate Number** - Floyd's Cycle Detection
2. **Next Permutation** - In-place Array Manipulation

Both require clever techniques to meet strict constraints.

---

## Problem 1: Find the Duplicate Number

### Your Code (Optimal - Floyd's Cycle)
```python
def findDuplicate(nums):
    slow = nums[0]
    fast = nums[0]

    while True:
        slow = nums[slow]
        fast = nums[nums[fast]]
        if slow == fast:
            break
    
    slow = nums[0]

    while slow != fast:
        slow = nums[slow]
        fast = nums[fast]

    return slow
```

### Logic Explanation
```
Key Insight: Treat array as linked list
- Values in [1, n] can be used as indices
- Duplicate creates cycle

Phase 1: Detect Cycle
1. slow moves 1 step: slow = nums[slow]
2. fast moves 2 steps: fast = nums[nums[fast]]
3. Loop until they meet

Phase 2: Find Entrance (Duplicate)
1. Reset slow to start (nums[0])
2. Move both 1 step at a time
3. When they meet: that's the duplicate
```

### Why It Works
**Mathematical Proof:**
- Let distance from start to cycle entrance = `a`
- Let distance from entrance to meeting point = `b`
- When they meet:
  - Slow traveled: `a + b`
  - Fast traveled: `a + b + k*c` (k cycles)
- Since fast is 2x speed: `2(a + b) = a + b + k*c`
- Therefore: `a = k*c - b`
- This means: Distance from start to entrance = Distance from meeting point to entrance!

### Example Walkthrough: `[1,3,4,2,2]`
```
Array as linked list:
Index: 0 → 1 → 3 → 2 → 4 → 2 (cycle!)
                    ↑_________|

Phase 1:
Step 1: slow=1, fast=3
Step 2: slow=3, fast=2
Step 3: slow=2, fast=2 (MEET!)

Phase 2:
Reset slow=0, fast stays at 2
Step 1: slow=1, fast=4
Step 2: slow=3, fast=2
Step 3: slow=2, fast=4
Step 4: slow=4, fast=2
Step 5: slow=2, fast=4
Step 6: slow=2, fast=2 (MEET!)

Result: 2
```

### Complexity
- **Time**: O(n) - two passes
- **Space**: O(1) - only pointers
- ✅ Meets all constraints!

### Alternative Approaches (Your Code)

#### Approach 2: Frequency Array
```python
def findDuplicate(nums):
    n = len(nums)
    freq = [0] * n
    for num in nums:
        if freq[num] == 0:
            freq[num] = 1
        else:
            return num
```
- Time: O(n), Space: O(n)
- ❌ Uses extra space

#### Approach 3: Boolean Array
```python
def findDuplicate(nums):
    seen = [False] * len(nums)
    for num in nums:
        if seen[num]:
            return num
        else:
            seen[num] = True
```
- Time: O(n), Space: O(n)
- ❌ Uses extra space

#### Approach 4: Marking Visited
```python
def findDuplicate(nums):
    curr = 0
    while True:
        if nums[curr] == -1:
            return curr
        temp = nums[curr]
        nums[curr] = -1
        curr = temp
```
- Time: O(n), Space: O(1)
- ❌ Modifies array

### Key Insights
1. **Array as Linked List**: When values are indices, think graph/linked list
2. **Floyd's Algorithm**: Two phases - detect cycle, find entrance
3. **Slow and Fast pointers**: Classic pattern for cycle detection
4. **O(1) space solution**: Possible without modifying array

---

## Problem 2: Next Permutation

### Your Code (Optimal)
```python
def nextPermutation(nums):
    n = len(nums)
    pivot = -1
    
    # Step 1: Find pivot
    for i in range(n-2, -1, -1):
        if nums[i] < nums[i+1]:
            pivot = i
            break
    
    # Step 2: If no pivot, reverse entire array
    if pivot == -1:
        nums.reverse()
        return
    
    # Step 3: Find swap element
    for i in range(n-1, pivot, -1):
        if nums[i] > nums[pivot]:
            nums[i], nums[pivot] = nums[pivot], nums[i]
            break
    
    # Step 4: Reverse suffix
    left, right = pivot+1, n-1
    while left < right:
        nums[left], nums[right] = nums[right], nums[left]
        left += 1
        right -= 1
```

### Logic Explanation
```
Goal: Find next lexicographically greater permutation

Step 1: Find Pivot (rightmost ascending pair)
- Scan from right to left
- Find first i where nums[i] < nums[i+1]
- This is the position we can change

Step 2: Handle Edge Case
- If no pivot found: array is descending (largest permutation)
- Reverse to get smallest permutation

Step 3: Find Swap Element
- Scan from right to left
- Find smallest element > nums[pivot]
- Swap with pivot

Step 4: Reverse Suffix
- Reverse everything after pivot
- Makes suffix smallest possible
```

### Why It Works
**Lexicographic Order Principle:**
- To get next permutation, make smallest possible increase
- Change as little as possible from the right
- Keep prefix same as long as possible

**Why find pivot from right?**
- Everything after pivot is descending (largest arrangement)
- To get next permutation, must change pivot position

**Why swap with smallest greater element?**
- Gives smallest increase at pivot position

**Why reverse suffix?**
- After swap, suffix is still descending
- Reverse to make it ascending (smallest arrangement)

### Example Walkthrough: `[2,4,1,7,5,0]`
```
Step 1: Find Pivot
[2, 4, 1, 7, 5, 0]
       ^  ^
       i  i+1
1 < 7? YES → pivot = 2

Step 2: Find Swap Element
nums[pivot] = 1
Scan from right: 0,5,7
Smallest > 1: 5
[2, 4, 1, 7, 5, 0]
       ^     ^
     pivot  swap

Step 3: Swap
[2, 4, 5, 7, 1, 0]

Step 4: Reverse Suffix
[2, 4, 5, 7, 1, 0]
          ^-----^
          reverse
          
Result: [2, 4, 5, 0, 1, 7]
```

### Complexity
- **Time**: O(n) - three passes (find pivot, find swap, reverse)
- **Space**: O(1) - in-place modification
- ✅ Optimal solution!

### Alternative Approaches (Your Code)

#### Approach 2: Generate All Permutations
```python
def nextPermutation(nums):
    def generatePermutations(arr, idx, result):
        if idx == len(arr) - 1:
            result.append(arr[:])
            return
        for i in range(idx, len(arr)):
            arr[idx], arr[i] = arr[i], arr[idx]
            generatePermutations(arr, idx+1, result)
            arr[idx], arr[i] = arr[i], arr[idx]
    
    result = []
    generatePermutations(nums, 0, result)
    result.sort()
    
    for i in range(len(result)):
        if result[i] == nums:
            if i < len(result) - 1:
                nums[:] = result[i+1]
            else:
                nums[:] = result[0]
            break
```
- Time: O(n! × n log n), Space: O(n!)
- ❌ Too slow, generates all permutations

### Key Insights
1. **Right-to-left scan** finds the rightmost changeable position
2. **Pivot** is where ascending order starts from right
3. **Swap with smallest greater** element for minimal increase
4. **Reverse suffix** to get smallest arrangement
5. **In-place modification**: Use `nums[:] =` not `nums =`

---

## Pattern Comparison

| Problem | Pattern | Key Technique | Time | Space |
|---------|---------|---------------|------|-------|
| Find Duplicate | Floyd's Cycle | Treat array as linked list | O(n) | O(1) |
| Next Permutation | In-place Manipulation | Find pivot, swap, reverse | O(n) | O(1) |

---

## Common Patterns Learned

### 1. Array as Linked List
**When to use:**
- Values are in range that can be used as indices
- Need to detect cycles
- O(1) space constraint

**Example:** Find Duplicate Number

### 2. In-place Array Manipulation
**When to use:**
- Must modify array in-place
- O(1) space constraint
- Need to rearrange elements

**Example:** Next Permutation

### 3. Two-Phase Algorithm
**When to use:**
- Problem has two distinct steps
- First phase detects/finds something
- Second phase processes result

**Examples:**
- Floyd's Cycle: Detect cycle → Find entrance
- Next Permutation: Find pivot → Swap and reverse

---

## Key Optimizations

### Find Duplicate Number
**Optimization**: O(n) space → O(1) space
- **Before**: Use hash set or frequency array
- **After**: Floyd's cycle detection
- **Key**: Treat array as linked list

### Next Permutation
**Optimization**: O(n!) → O(n)
- **Before**: Generate all permutations and sort
- **After**: Find pivot, swap, reverse
- **Key**: Understand lexicographic order properties

---

## Common Mistakes & How to Avoid

### Find Duplicate Number

❌ **Mistake**: Not resetting slow in Phase 2
```python
# WRONG
while slow != fast:
    slow = nums[slow]
    fast = nums[fast]

# CORRECT
slow = nums[0]  # Reset first!
while slow != fast:
    slow = nums[slow]
    fast = nums[fast]
```

❌ **Mistake**: Using `while slow != fast` in Phase 1
```python
# WRONG - might never enter loop
while slow != fast:
    slow = nums[slow]
    fast = nums[nums[fast]]

# CORRECT - use do-while pattern
while True:
    slow = nums[slow]
    fast = nums[nums[fast]]
    if slow == fast:
        break
```

### Next Permutation

❌ **Mistake**: Not breaking after finding pivot
```python
# WRONG - finds leftmost, not rightmost
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i

# CORRECT - break immediately
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i
        break
```

❌ **Mistake**: Forgetting to reverse suffix
```python
# WRONG - just swap and return
nums[pivot], nums[j] = nums[j], nums[pivot]
return

# CORRECT - must reverse suffix
nums[pivot], nums[j] = nums[j], nums[pivot]
nums[pivot+1:] = reversed(nums[pivot+1:])
```

---

## Practice Strategy

### Master These Patterns
1. **Floyd's Cycle Detection**
   - Find duplicate number
   - Linked list cycle
   - Happy number

2. **In-place Array Manipulation**
   - Next permutation
   - Rotate array
   - Reverse array sections

### Progression
1. **Understand the constraint** - Why can't we use simple approach?
2. **Identify the pattern** - Array as linked list? Lexicographic order?
3. **Apply the technique** - Floyd's cycle? Find pivot?
4. **Handle edge cases** - No cycle? No pivot?

---

## Additional Resources

### Duplicate Problems Guide
See `duplicate-patterns-guide.md` for comprehensive coverage of 7 different duplicate problem types:
- Contains Duplicate (Hash Set)
- Find Duplicate (Floyd's Cycle)
- Find All Duplicates (Index Marking)
- Remove Duplicates Sorted (Two Pointers)
- Remove Duplicates Unsorted (Set + Two Pointers)
- Duplicate within distance k (Sliding Window)
- Duplicate within value range (Bucket Sort)

---

## Summary

### Find Duplicate Number
- **Pattern**: Floyd's Cycle Detection
- **Key**: Treat array as linked list
- **Phases**: Detect cycle → Find entrance
- **Complexity**: O(n) time, O(1) space

### Next Permutation
- **Pattern**: In-place Array Manipulation
- **Key**: Find pivot, swap, reverse
- **Steps**: Find pivot → Swap with smallest greater → Reverse suffix
- **Complexity**: O(n) time, O(1) space

### Golden Rules
1. **Values as indices** → Think linked list/graph
2. **Lexicographic order** → Change from right, make smallest increase
3. **O(1) space + can't modify** → Floyd's cycle
4. **In-place rearrangement** → Find pattern, swap, reverse

**Your code demonstrates excellent understanding of both advanced patterns!** ✅
