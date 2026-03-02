# Day 07: Next Permutation

## Problem Pattern
**In-place Array Manipulation** - Find lexicographically next greater permutation

## Problem Statement
Given an array of integers, rearrange it to the next lexicographically greater permutation.
- If no such permutation exists, return the smallest permutation (sorted ascending)
- Must modify in-place with O(1) extra space

## Key Insight
**Observation**: To get next permutation, we need to:
1. Find the rightmost position where sequence breaks (nums[i] < nums[i+1])
2. Swap with the smallest element greater than nums[i] from the right
3. Reverse everything after that position

**Why?** We want the smallest increase, so change as little as possible from the right.

## Visual Understanding

```
Example: [1, 3, 5, 4, 2]

Step 1: Find pivot (rightmost i where nums[i] < nums[i+1])
[1, 3, 5, 4, 2]
    ^
  pivot (3 < 5)
  
Step 2: Find smallest element > pivot from right
[1, 3, 5, 4, 2]
    ^       ^
  pivot   swap with 4 (smallest > 3)
  
Step 3: Swap
[1, 4, 5, 3, 2]
    ^       ^
  
Step 4: Reverse everything after pivot
[1, 4, 5, 3, 2]
       ^-----^
       reverse
       
Result: [1, 4, 2, 3, 5]
```

## Pseudocode
```
function nextPermutation(nums):
    n = length(nums)
    
    // Step 1: Find pivot (rightmost ascending pair)
    pivot = -1
    for i from n-2 down to 0:
        if nums[i] < nums[i+1]:
            pivot = i
            break
    
    // Step 2: If no pivot, array is descending (largest permutation)
    if pivot == -1:
        reverse(nums)
        return
    
    // Step 3: Find smallest element > nums[pivot] from right
    for i from n-1 down to pivot+1:
        if nums[i] > nums[pivot]:
            swap(nums[i], nums[pivot])
            break
    
    // Step 4: Reverse suffix after pivot
    reverse(nums[pivot+1:])
```

## Flowchart

```
                    START
                      |
                      v
              pivot = -1, i = n-2
                      |
                      v
              +---------------+
              | i >= 0?       |---NO---> pivot = -1
              +---------------+
                      |YES
                      v
         +-------------------------+
         | nums[i] < nums[i+1]?    |
         +-------------------------+
              |YES          |NO
              v             v
         pivot = i       i--
         break           loop back
              |
              v
         +---------------+
         | pivot == -1?  |---YES---> reverse(nums)
         +---------------+           return
              |NO
              v
         Find j where nums[j] > nums[pivot]
         (scan from right)
              |
              v
         swap(nums[pivot], nums[j])
              |
              v
         reverse(nums[pivot+1:])
              |
              v
                     END
```

## Logic Walkthrough
Example: `[2, 4, 1, 7, 5, 0]`

### Step 1: Find Pivot
```
Scan from right to left:
[2, 4, 1, 7, 5, 0]
          ^  ^
          i  i+1
7 > 5? NO

[2, 4, 1, 7, 5, 0]
       ^  ^
       i  i+1
1 < 7? YES → pivot = 2 (index)
```

### Step 2: Find Swap Element
```
Find smallest element > nums[pivot] from right:
nums[pivot] = 1

[2, 4, 1, 7, 5, 0]
       ^        ^
     pivot    0 > 1? NO

[2, 4, 1, 7, 5, 0]
       ^     ^
     pivot  5 > 1? YES → swap with 5
```

### Step 3: Swap
```
[2, 4, 1, 7, 5, 0]
       ^     ^
Swap: [2, 4, 5, 7, 1, 0]
```

### Step 4: Reverse Suffix
```
[2, 4, 5, 7, 1, 0]
          ^-----^
          reverse
          
Result: [2, 4, 5, 0, 1, 7]
```

## Multiple Approaches

### Approach 1: Optimal Algorithm (Best)
```python
def nextPermutation(nums):
    n = len(nums)
    pivot = -1
    
    # Find pivot
    for i in range(n-2, -1, -1):
        if nums[i] < nums[i+1]:
            pivot = i
            break
    
    # If no pivot, reverse entire array
    if pivot == -1:
        nums.reverse()
        return
    
    # Find swap element
    for i in range(n-1, pivot, -1):
        if nums[i] > nums[pivot]:
            nums[i], nums[pivot] = nums[pivot], nums[i]
            break
    
    # Reverse suffix
    left, right = pivot+1, n-1
    while left < right:
        nums[left], nums[right] = nums[right], nums[left]
        left += 1
        right -= 1
```
- **Time**: O(n)
- **Space**: O(1)
- ✅ Optimal solution!

### Approach 2: Using Python Slicing
```python
def nextPermutation(nums):
    n = len(nums)
    pivot = -1
    
    # Find pivot
    for i in range(n-2, -1, -1):
        if nums[i] < nums[i+1]:
            pivot = i
            break
    
    if pivot == -1:
        nums.reverse()
        return
    
    # Find swap element
    for i in range(n-1, pivot, -1):
        if nums[i] > nums[pivot]:
            nums[i], nums[pivot] = nums[pivot], nums[i]
            break
    
    # Reverse using slicing
    nums[pivot+1:] = reversed(nums[pivot+1:])
```
- **Time**: O(n)
- **Space**: O(n) for slicing
- ✅ Cleaner but uses extra space

### Approach 3: Generate All Permutations (Brute Force)
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
    
    # Find current and return next
    for i in range(len(result)):
        if result[i] == nums:
            if i < len(result) - 1:
                nums[:] = result[i+1]
            else:
                nums[:] = result[0]
            break
```
- **Time**: O(n! × n log n)
- **Space**: O(n!)
- ❌ Too slow, generates all permutations

### Approach 4: Two Nested Loops
```python
def nextPermutation(nums):
    def reverse(a, b):
        for i in range((b-a)//2):
            nums[a+i], nums[b-i-1] = nums[b-i-1], nums[a+i]
    
    for l in range(len(nums)-1, -1, -1):
        for r in range(len(nums)-1, l, -1):
            if nums[r] > nums[l]:
                nums[r], nums[l] = nums[l], nums[r]
                reverse(l+1, len(nums))
                return
    
    reverse(0, len(nums))
```
- **Time**: O(n²) worst case
- **Space**: O(1)
- ⚠️ Works but less efficient

## Why This Algorithm Works

### Lexicographic Order
Permutations in sorted order:
```
[1, 2, 3]
[1, 3, 2]
[2, 1, 3]
[2, 3, 1]
[3, 1, 2]
[3, 2, 1]
```

**Observation**: To get next permutation:
1. Change as little as possible (from right)
2. Make smallest possible increase
3. Keep prefix same as long as possible

### Why Find Pivot from Right?
```
[1, 5, 8, 4, 7, 6, 5, 3, 1]
    ^
  pivot (5 < 8)
  
Everything after 8 is descending: [4, 7, 6, 5, 3, 1]
This is the largest arrangement for these digits.
To get next permutation, we must change position 1 (the 5).
```

### Why Swap with Smallest Greater Element?
```
nums[pivot] = 5
Right side: [8, 4, 7, 6, 5, 3, 1]

Elements > 5: [8, 7, 6]
Smallest > 5: 6

Swap with 6 (not 8 or 7) to get smallest increase.
```

### Why Reverse Suffix?
```
After swap: [1, 6, 8, 4, 7, 5, 5, 3, 1]
                  ^-----------------^
                  still descending
                  
To get smallest permutation with this prefix,
reverse to make it ascending:
[1, 6, 1, 3, 4, 5, 5, 7, 8]
```

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Optimal Algorithm | O(n) | O(1) | Best solution |
| With Slicing | O(n) | O(n) | Cleaner code |
| Generate All | O(n! × n log n) | O(n!) | Too slow |
| Two Loops | O(n²) | O(1) | Less efficient |

## Shortcut Meanings & Tricks

### 1. `for i in range(n-2, -1, -1):`
**Meaning**: Scan from second-last to first (right to left)
**Shortcut**: `range(start, stop, step)` where step=-1 means backward
**Why**: We want rightmost position where order breaks

### 2. `pivot = -1`
**Meaning**: Use -1 as sentinel value (not found)
**Shortcut**: Common pattern for "not found" in array problems
**Why**: If pivot stays -1, array is fully descending (largest permutation)

### 3. `nums[i] < nums[i+1]`
**Meaning**: Find where ascending order starts
**Shortcut**: Looking for "break point" in descending sequence
**Why**: This is where we can make a change

### 4. `for i in range(n-1, pivot, -1):`
**Meaning**: Scan from end to pivot+1 (exclusive)
**Shortcut**: `range(n-1, pivot, -1)` stops at pivot+1
**Why**: Find swap candidate in suffix

### 5. `nums[i], nums[pivot] = nums[pivot], nums[i]`
**Meaning**: Python's tuple unpacking for swap
**Shortcut**: No need for temp variable
**Trick**: `a, b = b, a` swaps in one line

### 6. `nums.reverse()`
**Meaning**: Reverse entire array in-place
**Shortcut**: Built-in method, O(n) time
**Alternative**: `nums[:] = nums[::-1]` (creates new list)

### 7. `nums[pivot+1:]`
**Meaning**: Slice from pivot+1 to end
**Shortcut**: Omitting end index means "to the end"
**Trick**: `nums[start:]` = from start to end

### 8. `reversed(nums[pivot+1:])`
**Meaning**: Returns iterator of reversed slice
**Shortcut**: `reversed()` is lazy (doesn't create list immediately)
**Note**: Need to assign back: `nums[pivot+1:] = reversed(nums[pivot+1:])`

### 9. `nums[:] = result`
**Meaning**: Modify list in-place (not create new reference)
**Shortcut**: `nums[:] =` modifies original, `nums =` creates new
**Critical**: In LeetCode, must use `nums[:] =` to modify in-place

### 10. Two-pointer reverse pattern
```python
left, right = pivot+1, n-1
while left < right:
    nums[left], nums[right] = nums[right], nums[left]
    left += 1
    right -= 1
```
**Meaning**: Reverse subarray using two pointers
**Shortcut**: Classic pattern for in-place reversal
**Why**: O(1) space, O(n) time

## Common Mistakes

### Mistake 1: Wrong loop direction
```python
# WRONG: Scanning left to right
for i in range(n):
    if nums[i] < nums[i+1]:
        pivot = i

# CORRECT: Scan right to left
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i
        break  # Stop at first (rightmost) occurrence
```

### Mistake 2: Not breaking after finding pivot
```python
# WRONG: Continues scanning, finds leftmost
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i

# CORRECT: Break immediately
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i
        break
```

### Mistake 3: Forgetting to handle pivot == -1
```python
# WRONG: Will crash if array is descending
for i in range(n-1, pivot, -1):  # pivot is -1!

# CORRECT: Check first
if pivot == -1:
    nums.reverse()
    return
```

### Mistake 4: Wrong swap element
```python
# WRONG: Swap with any element > pivot
for i in range(pivot+1, n):
    if nums[i] > nums[pivot]:
        swap(nums[i], nums[pivot])
        break

# CORRECT: Scan from right to find smallest > pivot
for i in range(n-1, pivot, -1):
    if nums[i] > nums[pivot]:
        swap(nums[i], nums[pivot])
        break
```

### Mistake 5: Not reversing suffix
```python
# WRONG: Just swap and return
nums[pivot], nums[j] = nums[j], nums[pivot]
return

# CORRECT: Must reverse suffix
nums[pivot], nums[j] = nums[j], nums[pivot]
nums[pivot+1:] = reversed(nums[pivot+1:])
```

### Mistake 6: Using `nums = ...` instead of `nums[:] = ...`
```python
# WRONG: Creates new list, doesn't modify original
nums = sorted(nums)

# CORRECT: Modifies in-place
nums[:] = sorted(nums)
# OR
nums.sort()
```

## Edge Cases

1. **Smallest permutation**: `[1,2,3]` → `[1,3,2]`
2. **Largest permutation**: `[3,2,1]` → `[1,2,3]` (wrap around)
3. **All same**: `[1,1,1]` → `[1,1,1]` (no change)
4. **Two elements**: `[1,2]` → `[2,1]`
5. **Single element**: `[1]` → `[1]` (no change)
6. **Duplicates**: `[1,5,1]` → `[5,1,1]`

## Pattern Variations

### 1. Previous Permutation
```python
def previousPermutation(nums):
    n = len(nums)
    pivot = -1
    
    # Find pivot where nums[i] > nums[i+1] (descending)
    for i in range(n-2, -1, -1):
        if nums[i] > nums[i+1]:
            pivot = i
            break
    
    if pivot == -1:
        nums.reverse()
        return
    
    # Find largest element < nums[pivot] from right
    for i in range(n-1, pivot, -1):
        if nums[i] < nums[pivot]:
            nums[i], nums[pivot] = nums[pivot], nums[i]
            break
    
    # Reverse suffix
    nums[pivot+1:] = reversed(nums[pivot+1:])
```

### 2. Kth Permutation
```python
def getPermutation(n, k):
    import math
    nums = list(range(1, n+1))
    result = []
    k -= 1  # Convert to 0-indexed
    
    for i in range(n, 0, -1):
        factorial = math.factorial(i-1)
        index = k // factorial
        result.append(nums[index])
        nums.pop(index)
        k %= factorial
    
    return ''.join(map(str, result))
```

### 3. Count Permutations
```python
def countPermutations(n):
    import math
    return math.factorial(n)

def countUniquePermutations(nums):
    from collections import Counter
    import math
    
    n = len(nums)
    freq = Counter(nums)
    
    result = math.factorial(n)
    for count in freq.values():
        result //= math.factorial(count)
    
    return result
```

## Visual Step-by-Step

```
Example: [1, 3, 5, 4, 2] → Next permutation

Step 1: Find pivot (scan right to left)
[1, 3, 5, 4, 2]
 ↓  ↓  ↓  ↓  ↓
 ✓  ✓  ✗  ✗  ✗  (5 > 4, 4 > 2, descending)
    ^
  pivot (3 < 5, first ascending from right)

Step 2: Find swap element (scan right to left)
[1, 3, 5, 4, 2]
    ^        ↓  2 > 3? NO
    ^     ↓     4 > 3? YES ← swap with this
    
Step 3: Swap
[1, 3, 5, 4, 2]
    ↕       ↕
[1, 4, 5, 3, 2]

Step 4: Reverse suffix after pivot
[1, 4, 5, 3, 2]
       ↓  ↓  ↓
       reverse
[1, 4, 2, 3, 5] ← Result!

Verification:
[1, 3, 5, 4, 2] < [1, 4, 2, 3, 5] ✓
```

## Interview Tips

### 1. Explain the Intuition
"To get the next permutation, we want the smallest increase. So we:
1. Find the rightmost position where we can make a change
2. Swap with the smallest element that's larger
3. Make the rest as small as possible by reversing"

### 2. Walk Through Example
Always trace through `[1,3,5,4,2]` or similar to show all steps.

### 3. Discuss Edge Cases
- What if array is already largest? (Reverse to smallest)
- What about duplicates? (Algorithm handles them)
- Single element? (No change needed)

### 4. Optimize Step by Step
- Start with brute force (generate all permutations)
- Then optimize to O(n) algorithm
- Explain why each step is necessary

### 5. Code Cleanly
```python
# Good: Clear variable names
pivot = -1
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        pivot = i
        break

# Not: Confusing names
idx = -1
for i in range(n-2, -1, -1):
    if nums[i] < nums[i+1]:
        idx = i
        break
```

## Time Complexity Breakdown

```
Step 1: Find pivot
- Scan from right: O(n) worst case

Step 2: Find swap element
- Scan from right: O(n) worst case

Step 3: Swap
- Single operation: O(1)

Step 4: Reverse suffix
- Reverse half of array: O(n) worst case

Total: O(n) + O(n) + O(1) + O(n) = O(n)
Space: O(1) - only using pointers
```

## Key Takeaways

1. **Right-to-left scan** finds the rightmost changeable position
2. **Pivot** is where ascending order starts from right
3. **Swap with smallest greater** element for minimal increase
4. **Reverse suffix** to get smallest arrangement
5. **Handle edge case**: If no pivot, array is largest permutation
6. **In-place modification**: Use `nums[:] =` not `nums =`
7. **O(n) time, O(1) space** - optimal solution

## Practice Problems

### Similar Problems:
1. LeetCode 31: Next Permutation ⭐
2. LeetCode 60: Permutation Sequence
3. LeetCode 46: Permutations
4. LeetCode 47: Permutations II (with duplicates)
5. LeetCode 556: Next Greater Element III

### Difficulty Progression:
- Easy: Understanding permutation concept
- Medium: Next Permutation (31)
- Medium: Kth Permutation (60)
- Hard: Optimizing with duplicates

## Summary

**Problem**: Find next lexicographically greater permutation

**Algorithm**:
1. Find pivot (rightmost i where nums[i] < nums[i+1])
2. If no pivot, reverse entire array
3. Find smallest element > nums[pivot] from right
4. Swap them
5. Reverse suffix after pivot

**Time**: O(n), **Space**: O(1)

**Remember**: "Find break point, swap with next larger, reverse the rest!"
