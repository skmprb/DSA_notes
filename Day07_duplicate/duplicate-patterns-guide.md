# Duplicate Problems - Complete Pattern Guide

## Overview

Duplicate detection problems come in many variations. Each requires different patterns based on constraints.

---

## Problem Types & Patterns

| Problem Type | Constraints | Best Pattern | Time | Space |
|-------------|-------------|--------------|------|-------|
| Contains Duplicate | None | Hash Set | O(n) | O(n) |
| Find Duplicate (n+1 elements, [1,n]) | No modify, O(1) space | Floyd's Cycle | O(n) | O(1) |
| Find All Duplicates | Values in [1,n] | Index Marking | O(n) | O(1) |
| Remove Duplicates (sorted) | In-place | Two Pointers | O(n) | O(1) |
| Remove Duplicates (unsorted) | In-place | Hash Set + Two Pointers | O(n) | O(n) |

---

## Pattern 1: Contains Duplicate (Simple Detection)

### Problem
Check if array contains any duplicates.

### Constraints
- No special constraints
- Just need to return true/false

### Approaches

#### Approach 1: Hash Set (Optimal)
```python
def containsDuplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
```

**Logic:**
```
1. Create empty set
2. For each element:
   - If already in set: duplicate found
   - Else: add to set
3. If loop completes: no duplicates
```

**Complexity:**
- Time: O(n)
- Space: O(n)

#### Approach 2: Set Length Comparison
```python
def containsDuplicate(nums):
    return len(nums) != len(set(nums))
```

**Logic:**
```
1. Convert array to set (removes duplicates)
2. If lengths differ: duplicates existed
```

**Complexity:**
- Time: O(n)
- Space: O(n)
- ❌ No early return

#### Approach 3: Sorting
```python
def containsDuplicate(nums):
    nums.sort()
    for i in range(len(nums) - 1):
        if nums[i] == nums[i+1]:
            return True
    return False
```

**Logic:**
```
1. Sort array
2. Check adjacent elements
3. If any match: duplicate found
```

**Complexity:**
- Time: O(n log n)
- Space: O(1) or O(n) depending on sort

---

## Pattern 2: Find the Duplicate Number (Floyd's Cycle)

### Problem
Array of n+1 integers where each is in [1, n]. Find the ONE duplicate.

### Constraints
- **Cannot modify array**
- **Must use O(1) space**
- Only one number repeats (can repeat multiple times)

### Optimal Approach: Floyd's Cycle Detection

#### Your Code (Optimal)
```python
def findDuplicate(nums):
    slow = nums[0]
    fast = nums[0]

    # Phase 1: Detect cycle
    while True:
        slow = nums[slow]
        fast = nums[nums[fast]]
        if slow == fast:
            break
    
    # Phase 2: Find entrance (duplicate)
    slow = nums[0]

    while slow != fast:
        slow = nums[slow]
        fast = nums[fast]

    return slow
```

**Logic:**
```
Treat array as linked list:
- Index i points to index nums[i]
- Duplicate creates cycle

Phase 1: Detect cycle
1. slow moves 1 step: slow = nums[slow]
2. fast moves 2 steps: fast = nums[nums[fast]]
3. When they meet: cycle detected

Phase 2: Find entrance
1. Reset slow to start
2. Move both 1 step at a time
3. When they meet: that's the duplicate
```

**Why it works:**
- Values in [1, n] can be used as indices
- Duplicate value means multiple indices point to same value
- This creates a cycle in the "linked list"
- Cycle entrance = duplicate value

**Example:** `[1,3,4,2,2]`
```
Index: 0 → 1 → 3 → 2 → 4 → 2 (cycle!)
                    ↑_________|
                    
Duplicate = 2 (cycle entrance)
```

**Complexity:**
- Time: O(n)
- Space: O(1)
- ✅ Meets all constraints!

### Alternative Approaches (Don't Meet Constraints)

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

#### Approach 4: Marking Visited (Modifies Array)
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

---

## Pattern 3: Find All Duplicates

### Problem
Array of n integers where each is in [1, n]. Some elements appear twice, others once. Find all duplicates.

### Constraints
- Values in range [1, n]
- Can modify array
- O(1) extra space

### Optimal Approach: Index Marking

```python
def findDuplicates(nums):
    result = []
    
    for num in nums:
        index = abs(num) - 1
        
        # If already negative, we've seen this number
        if nums[index] < 0:
            result.append(abs(num))
        else:
            # Mark as visited by negating
            nums[index] = -nums[index]
    
    return result
```

**Logic:**
```
1. Use value as index (value - 1)
2. Mark visited by negating value at that index
3. If already negative: duplicate found
4. Use abs() to handle already-negated values
```

**Example:** `[4,3,2,7,8,2,3,1]`
```
Step 1: num=4, index=3
[4, 3, 2, -7, 8, 2, 3, 1]
         ^
         mark negative

Step 2: num=3, index=2
[4, 3, -2, -7, 8, 2, 3, 1]
      ^
      mark negative

...

Step 6: num=2, index=1
[4, -3, -2, -7, 8, 2, 3, 1]
    ^
    already negative → 2 is duplicate!

Result: [2, 3]
```

**Complexity:**
- Time: O(n)
- Space: O(1) excluding result
- ✅ Optimal for this constraint!

### Alternative: Hash Set
```python
def findDuplicates(nums):
    seen = set()
    result = []
    
    for num in nums:
        if num in seen:
            result.append(num)
        else:
            seen.add(num)
    
    return result
```
- Time: O(n), Space: O(n)
- ❌ Uses extra space

---

## Pattern 4: Remove Duplicates (Sorted Array)

### Problem
Remove duplicates from sorted array in-place. Return new length.

### Constraints
- Array is sorted
- Modify in-place
- O(1) extra space

### Optimal Approach: Two Pointers (Fast & Slow)

```python
def removeDuplicates(nums):
    if not nums:
        return 0
    
    slow = 0
    
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    
    return slow + 1
```

**Logic:**
```
1. slow = position for next unique element
2. fast = scan through array
3. When nums[fast] != nums[slow]:
   - Found new unique element
   - Move slow forward
   - Copy nums[fast] to nums[slow]
4. Return slow + 1 (length of unique elements)
```

**Example:** `[1,1,2,2,3]`
```
Initial: slow=0, fast=1
[1, 1, 2, 2, 3]
 s  f

fast=1: nums[1]=1 == nums[0]=1 → skip

fast=2: nums[2]=2 != nums[0]=1 → copy
[1, 2, 2, 2, 3]
    s     f

fast=3: nums[3]=2 == nums[1]=2 → skip

fast=4: nums[4]=3 != nums[1]=2 → copy
[1, 2, 3, 2, 3]
       s        f

Result: length = 3, array = [1,2,3,...]
```

**Complexity:**
- Time: O(n)
- Space: O(1)
- ✅ Optimal!

---

## Pattern 5: Remove Duplicates (Unsorted Array)

### Problem
Remove duplicates from unsorted array in-place.

### Approach: Hash Set + Two Pointers

```python
def removeDuplicates(nums):
    seen = set()
    write = 0
    
    for read in range(len(nums)):
        if nums[read] not in seen:
            seen.add(nums[read])
            nums[write] = nums[read]
            write += 1
    
    return write
```

**Logic:**
```
1. Use set to track seen elements
2. write = position for next unique element
3. read = scan through array
4. If not seen:
   - Add to set
   - Copy to write position
   - Move write forward
```

**Complexity:**
- Time: O(n)
- Space: O(n) for set

---

## Pattern 6: Contains Duplicate II (Within Distance k)

### Problem
Check if array contains duplicates within distance k.

### Approach: Sliding Window with Set

```python
def containsNearbyDuplicate(nums, k):
    window = set()
    
    for i in range(len(nums)):
        # If duplicate in window
        if nums[i] in window:
            return True
        
        # Add to window
        window.add(nums[i])
        
        # Maintain window size k
        if len(window) > k:
            window.remove(nums[i - k])
    
    return False
```

**Logic:**
```
1. Maintain sliding window of size k
2. Check if current element in window
3. Add current element
4. Remove element that's k+1 positions back
```

**Complexity:**
- Time: O(n)
- Space: O(k)

---

## Pattern 7: Contains Duplicate III (Within Value Range)

### Problem
Check if there are two distinct indices i and j such that:
- abs(nums[i] - nums[j]) <= t
- abs(i - j) <= k

### Approach: Bucket Sort

```python
def containsNearbyAlmostDuplicate(nums, k, t):
    if t < 0:
        return False
    
    buckets = {}
    bucket_size = t + 1
    
    for i in range(len(nums)):
        bucket = nums[i] // bucket_size
        
        # Check current bucket
        if bucket in buckets:
            return True
        
        # Check adjacent buckets
        if bucket - 1 in buckets and abs(nums[i] - buckets[bucket - 1]) <= t:
            return True
        if bucket + 1 in buckets and abs(nums[i] - buckets[bucket + 1]) <= t:
            return True
        
        # Add to bucket
        buckets[bucket] = nums[i]
        
        # Maintain window size k
        if i >= k:
            del buckets[nums[i - k] // bucket_size]
    
    return False
```

**Complexity:**
- Time: O(n)
- Space: O(min(n, k))

---

## Quick Reference: When to Use Which Pattern

### Use Hash Set when:
- ✅ Just need to detect duplicates
- ✅ No space constraint
- ✅ Need O(n) time
- ✅ Array is unsorted

### Use Floyd's Cycle when:
- ✅ Values are in range [1, n]
- ✅ Cannot modify array
- ✅ Must use O(1) space
- ✅ Finding single duplicate

### Use Index Marking when:
- ✅ Values are in range [1, n]
- ✅ Can modify array
- ✅ Need O(1) space
- ✅ Finding all duplicates

### Use Two Pointers when:
- ✅ Array is sorted
- ✅ Remove duplicates in-place
- ✅ Need O(1) space

### Use Sliding Window when:
- ✅ Duplicates within distance k
- ✅ Need to maintain window
- ✅ O(k) space acceptable

---

## Comparison Table

| Problem | Pattern | Modify Array? | Space | Time | Best For |
|---------|---------|---------------|-------|------|----------|
| Contains Duplicate | Hash Set | No | O(n) | O(n) | Simple detection |
| Find Duplicate (n+1, [1,n]) | Floyd's Cycle | No | O(1) | O(n) | Strict constraints |
| Find All Duplicates | Index Marking | Yes | O(1) | O(n) | Multiple duplicates |
| Remove Duplicates (sorted) | Two Pointers | Yes | O(1) | O(n) | Sorted array |
| Remove Duplicates (unsorted) | Set + Two Pointers | Yes | O(n) | O(n) | Unsorted array |
| Duplicate within k | Sliding Window | No | O(k) | O(n) | Distance constraint |
| Duplicate within value t | Bucket Sort | No | O(k) | O(n) | Value range constraint |

---

## Common Mistakes

### Mistake 1: Using wrong pattern for constraints
```python
# WRONG: Using hash set when O(1) space required
def findDuplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return num
        seen.add(num)

# CORRECT: Use Floyd's cycle for O(1) space
def findDuplicate(nums):
    slow = fast = nums[0]
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

### Mistake 2: Modifying array when not allowed
```python
# WRONG: Modifying array when constraint says don't
def findDuplicate(nums):
    for i in range(len(nums)):
        index = abs(nums[i]) - 1
        if nums[index] < 0:
            return abs(nums[i])
        nums[index] = -nums[index]

# CORRECT: Use Floyd's cycle (doesn't modify)
```

### Mistake 3: Not handling edge cases
```python
# WRONG: Crashes on empty array
def removeDuplicates(nums):
    slow = 0
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    return slow + 1

# CORRECT: Check for empty
def removeDuplicates(nums):
    if not nums:
        return 0
    slow = 0
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    return slow + 1
```

---

## Practice Problems

### Easy
1. LeetCode 217: Contains Duplicate
2. LeetCode 26: Remove Duplicates from Sorted Array
3. LeetCode 83: Remove Duplicates from Sorted List

### Medium
4. LeetCode 287: Find the Duplicate Number ⭐
5. LeetCode 442: Find All Duplicates in an Array
6. LeetCode 219: Contains Duplicate II
7. LeetCode 80: Remove Duplicates from Sorted Array II

### Hard
8. LeetCode 220: Contains Duplicate III
9. LeetCode 41: First Missing Positive (related pattern)

---

## Key Takeaways

1. **Different constraints → Different patterns**
   - No constraints: Hash Set
   - O(1) space + can't modify: Floyd's Cycle
   - O(1) space + can modify: Index Marking
   - Sorted array: Two Pointers

2. **Floyd's Cycle is special**
   - Only works when values are indices
   - Treats array as linked list
   - O(n) time, O(1) space without modifying

3. **Index Marking trick**
   - Use sign to mark visited
   - Only works for positive numbers in [1, n]
   - Modifies array but O(1) space

4. **Two Pointers for sorted**
   - Fast pointer scans
   - Slow pointer writes unique elements
   - Classic in-place pattern

5. **Always check constraints first!**
   - Can modify array?
   - Space limit?
   - Value range?
   - Sorted or unsorted?

**Golden Rule:** Match the pattern to the constraints, not just the problem type!
