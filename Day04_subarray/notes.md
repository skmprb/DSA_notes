# Day 04 - Maximum Subarray Problems

## Overview

Two classic subarray problems:
1. **Maximum Subarray Sum** (Kadane's Algorithm)
2. **Maximum Subarray Product** (Modified Kadane's)

Both use **dynamic programming** pattern but with different considerations.

---

## Problem 1: Maximum Subarray Sum

### Problem Statement

Given an integer array, find the contiguous subarray with the largest sum.

**Examples:**
```python
Input: [2, 3, -8, 7, -1, 2, 3]
Output: 11  # [7, -1, 2, 3]

Input: [-2, 1, -3, 4, -1, 2, 1, -5, 4]
Output: 6   # [4, -1, 2, 1]
```

### Pattern Recognition

**This is a Dynamic Programming (Kadane's Algorithm) problem!**

Why?
- ✅ Need to find optimal contiguous subarray
- ✅ At each position, make decision based on previous state
- ✅ Optimal substructure: solution at i depends on solution at i-1
- ✅ Can optimize from O(n²) to O(n)

---

## Solution 1: Brute Force (Your Code)

### Code
```python
def max_subarray_sum(List):
    n = len(List)
    max_sum = List[0]

    for i in range(n):
        current_sum = 0
        for j in range(i, n):
            current_sum += List[j]
            max_sum = max(max_sum, current_sum)
    return max_sum
```

### Logic (Pseudo Code)
```
1. Initialize max_sum with first element
2. For each starting position i:
   a. Reset current_sum to 0
   b. For each ending position j from i to n:
      - Add List[j] to current_sum
      - Update max_sum if current_sum is larger
3. Return max_sum
```

### Explanation
- Try all possible subarrays [i, j]
- For each subarray, calculate sum by extending from i to j
- Keep track of maximum sum found

### Complexity
- **Time:** O(n²) - nested loops
- **Space:** O(1) - only variables

### Why Not Optimal?
- Recalculates sums for overlapping subarrays
- Example: [2,3,-8] calculated, then [2,3,-8,7] recalculates [2,3,-8]

---

## Solution 2: Kadane's Algorithm (Your Code - OPTIMAL)

### Code
```python
def max_subarray_kadane(list):
    n = len(list)
    res = list[0]  # Global maximum sum found so far

    max_ending = list[0]  # Maximum sum ending at current position

    for i in range(1, n):
        # Key decision: extend current subarray OR start new subarray from current element
        # If max_ending+list[i] < list[i], previous sum is dragging us down, so restart
        max_ending = max(max_ending+list[i], list[i])

        res = max(res, max_ending)  # Update global max
    
    return res
```

### Logic (Pseudo Code)
```
1. Initialize:
   - res = first element (global maximum)
   - max_ending = first element (max sum ending at current position)

2. For each element from index 1 to n-1:
   a. Decision: Should we extend previous subarray or start fresh?
      - Extend: max_ending + current_element
      - Start fresh: current_element
      - Choose whichever is larger
   
   b. Update global maximum if current max_ending is larger

3. Return global maximum
```

### Explanation in Sentences

**Key Insight:** At each position, we decide:
- **Extend:** Add current element to previous subarray (if it helps)
- **Start Fresh:** Begin new subarray from current element (if previous sum is negative)

**Why it works:**
- If `max_ending + list[i] < list[i]`, the previous sum is negative and dragging us down
- Better to start fresh from current element
- We track the best sum ending at each position
- Global maximum is the best among all positions

**Example walkthrough:** `[2, 3, -8, 7, -1, 2, 3]`
```
i=0: max_ending=2, res=2
i=1: max_ending=max(2+3, 3)=5, res=5
i=2: max_ending=max(5-8, -8)=-3, res=5
i=3: max_ending=max(-3+7, 7)=7, res=7  (start fresh!)
i=4: max_ending=max(7-1, -1)=6, res=7
i=5: max_ending=max(6+2, 2)=8, res=8
i=6: max_ending=max(8+3, 3)=11, res=11
```

### Complexity
- **Time:** O(n) - single pass
- **Space:** O(1) - only two variables

### Why Optimal?
- ✅ Single pass through array
- ✅ Constant space
- ✅ Can't do better than O(n) (must check every element)

---

## Solution 3: With Subarray Indices (Your Code)

### Code
```python
def max_subarray_with_indices(list):
    n = len(list)
    max_ending = list[0]
    res = list[0]
    start, end, tempstart = 0, 0, 0

    for i in range(1, n):
        if list[i] > max_ending + list[i]:
            max_ending = list[i]
            tempstart = i  # Starting fresh, update temp start
        else:
            max_ending += list[i]  # Extending, keep temp start
        
        if max_ending > res:
            res = max_ending
            start = tempstart  # Update actual start
            end = i
    
    return list[start:end+1], res
```

### Logic
```
1. Same as Kadane's, but track indices
2. tempstart: potential start of current subarray
3. When starting fresh (list[i] > max_ending + list[i]):
   - Update tempstart to i
4. When finding new global max:
   - Update actual start and end indices
5. Return subarray and sum
```

### Complexity
- **Time:** O(n)
- **Space:** O(1) excluding output

---

## Solution 4: Divide and Conquer (Your Code)

### Code
```python
def max_crossing_sum(arr, left, mid, right):
    # Max sum ending at mid (going left)
    left_sum = float('-inf')
    curr_sum = 0
    for i in range(mid, left - 1, -1):
        curr_sum += arr[i]
        left_sum = max(left_sum, curr_sum)
    
    # Max sum starting from mid+1 (going right)
    right_sum = float('-inf')
    curr_sum = 0
    for i in range(mid + 1, right + 1):
        curr_sum += arr[i]
        right_sum = max(right_sum, curr_sum)
    
    return left_sum + right_sum

def max_subarray_divide_conquer(arr, left, right):
    if left == right:  # Base case: single element
        return arr[left]
    
    mid = (left + right) // 2
    
    # Max is either in left half, right half, or crosses middle
    left_max = max_subarray_divide_conquer(arr, left, mid)
    right_max = max_subarray_divide_conquer(arr, mid + 1, right)
    cross_max = max_crossing_sum(arr, left, mid, right)
    
    return max(left_max, right_max, cross_max)
```

### Logic
```
1. Divide array into two halves
2. Maximum subarray is in one of three places:
   a. Entirely in left half
   b. Entirely in right half
   c. Crosses the middle
3. Recursively find max in left and right
4. Find max crossing sum separately
5. Return maximum of all three
```

### Complexity
- **Time:** O(n log n) - divide into log n levels, each level O(n)
- **Space:** O(log n) - recursion stack

### Why Not Optimal?
- Slower than Kadane's O(n)
- More complex implementation
- Uses recursion (stack space)

---

## Alternative Solutions (From Your Code)

### Alternative 1: Using Array to Store Max Values
```python
def maxSubArray(self, nums: List[int]) -> int:
    max_val = [nums[0]]
    for i in range(1, len(nums)):
        max_val.append(max(nums[i], nums[i]+max_val[i-1]))
    return max(max_val)
```

**Logic:** Store max_ending at each position in array

**Complexity:**
- Time: O(n)
- Space: O(n) - array storage

**Why not optimal?** Uses O(n) space when O(1) is possible

### Alternative 2: Reset on Negative
```python
def maxSubArray(self, nums: List[int]) -> int:
    maxSum = float('-inf')
    currentSum = 0
    
    for num in nums:
        currentSum += num
        
        if currentSum > maxSum:
            maxSum = currentSum
        
        if currentSum < 0:
            currentSum = 0
    
    return maxSum
```

**Logic:** Reset current sum to 0 when it becomes negative

**Complexity:** Time O(n), Space O(1)

**Note:** Cleaner version of Kadane's - reset instead of max comparison

### Alternative 3: Prefix Sum Approach
```python
def maxSubArray(self, nums: List[int]) -> int:
    psum = []
    currSum = 0
    for num in nums:
        currSum += num
        psum.append(currSum)
    
    minSum = float('inf')
    biggestDiff = float('-inf')
    for ps in psum:
        biggestDiff = max(biggestDiff, ps)
        biggestDiff = max(biggestDiff, ps - minSum)
        if ps < minSum:
            minSum = ps
    
    return biggestDiff
```

**Logic:** 
- Build prefix sum array
- Max subarray = max(prefix[j] - prefix[i]) for j > i
- Track minimum prefix sum seen so far

**Complexity:** Time O(n), Space O(n)

**Why not optimal?** Uses O(n) space

---

## Problem 2: Maximum Product Subarray

### Problem Statement

Given an integer array, find the contiguous subarray with the largest product.

**Examples:**
```python
Input: [2, 3, -2, 4]
Output: 6  # [2, 3]

Input: [-2, 3, -4]
Output: 24  # [-2, 3, -4]
```

### Key Difference from Sum

**Challenge:** Negative numbers!
- Negative × Negative = Positive (can flip min to max!)
- Zero resets the product
- Need to track both max AND min

---

## Solution 1: Brute Force (Your Code)

### Code
```python
def maxminum_product_subarrat(nums):
    n = len(nums)
    max_prod = nums[0]

    for i in range(n):
        current_prod = 1
        for j in range(i, n):
            current_prod *= nums[j]
            max_prod = max(current_prod, max_prod)
    
    return max_prod
```

### Logic
```
1. Try all subarrays [i, j]
2. Calculate product by multiplying elements
3. Track maximum product
```

### Complexity
- **Time:** O(n²)
- **Space:** O(1)

---

## Solution 2: Track Max and Min (Your Code - OPTIMAL)

### Code
```python
def max_product(nums):
    n = len(nums)
    curr_max = nums[0]
    curr_min = nums[0]
    max_prod = nums[0]

    for i in range(1, n):
        # Consider: start fresh, extend max, extend min (for negatives)
        temp = max(nums[i], curr_max*nums[i], curr_min*nums[i])
        curr_min = min(nums[i], curr_max*nums[i], curr_min*nums[i])
        curr_max = temp
        
        max_prod = max(max_prod, curr_max)
    
    return max_prod
```

### Logic (Pseudo Code)
```
1. Initialize:
   - curr_max = first element (max product ending here)
   - curr_min = first element (min product ending here)
   - max_prod = first element (global maximum)

2. For each element from index 1 to n-1:
   a. Calculate three candidates:
      - nums[i] alone (start fresh)
      - curr_max * nums[i] (extend max)
      - curr_min * nums[i] (negative can flip min to max!)
   
   b. Update curr_max = max of three candidates
   c. Update curr_min = min of three candidates
   d. Update global max_prod

3. Return max_prod
```

### Explanation in Sentences

**Key Insight:** Track both maximum AND minimum product ending at each position.

**Why track minimum?**
- A negative number can turn the minimum (most negative) into maximum
- Example: curr_min = -10, nums[i] = -2 → product = 20 (new max!)

**Three choices at each position:**
1. **Start fresh:** Use nums[i] alone
2. **Extend max:** Multiply curr_max by nums[i]
3. **Flip min:** Multiply curr_min by nums[i] (important for negatives!)

**Example walkthrough:** `[2, 3, -2, 4]`
```
i=0: curr_max=2, curr_min=2, max_prod=2
i=1: curr_max=max(3, 2*3, 2*3)=6, curr_min=min(3, 6, 6)=3, max_prod=6
i=2: curr_max=max(-2, 6*-2, 3*-2)=-2, curr_min=min(-2, -12, -6)=-12, max_prod=6
i=3: curr_max=max(4, -2*4, -12*4)=4, curr_min=min(4, -8, -48)=-48, max_prod=6
```

### Complexity
- **Time:** O(n) - single pass
- **Space:** O(1) - only three variables

### Why Optimal?
- ✅ Handles negatives correctly
- ✅ Single pass
- ✅ Constant space

---

## Solution 3: Swap on Negative (Your Code)

### Code
```python
def max_product_swap(nums):
    global_max = float('-inf')
    curr_max = 1
    curr_min = 1

    for num in nums:
        if num < 0:  # Swap when negative
            curr_max, curr_min = curr_min, curr_max
        
        curr_max = max(num, num * curr_max)
        curr_min = min(num, num * curr_min)
        global_max = max(curr_max, global_max)
    
    return global_max
```

### Logic
```
1. When encountering negative number, swap curr_max and curr_min
2. Why? Negative flips the relationship:
   - What was max becomes min (negative * positive = negative)
   - What was min becomes max (negative * negative = positive)
3. Then proceed with normal max/min calculation
```

### Complexity
- **Time:** O(n)
- **Space:** O(1)

### Clever Optimization
- Simpler logic than tracking three candidates
- Swap handles the negative flip automatically

---

## Solution 4: Two-Pass (Your Code)

### Code
```python
def max_product_two_pass(nums):
    ans = float("-inf")
    curr_prod = 1

    # Left to right
    for num in nums:
        if curr_prod == 0:
            curr_prod = 1
        curr_prod *= num
        ans = max(curr_prod, ans)
    
    # Right to left
    curr_prod = 1
    for i in range(len(nums) - 1, -1, -1):
        if curr_prod == 0:
            curr_prod = 1
        curr_prod *= nums[i]
        ans = max(curr_prod, ans)
    
    return ans
```

### Logic
```
1. Scan left to right, track running product
2. Reset to 1 when hitting zero
3. Scan right to left, track running product
4. Reset to 1 when hitting zero
5. Return maximum found in both passes
```

### Why Two Passes?
- Handles odd number of negatives
- Left-to-right might miss optimal subarray ending before last negative
- Right-to-left catches it

**Example:** `[2, -5, -2, -4, 3]`
- Left-to-right: 2, -10, 20, -80, -240
- Right-to-left: 3, -12, 24, -120, -240
- Max = 24 (found in right-to-left)

### Complexity
- **Time:** O(n) - two passes
- **Space:** O(1)

---

## Solution 5: Zero Reset (Your Code)

### Code
```python
def max_product_zero_reset(nums):
    res = max(nums)
    curmax, curmin = 1, 1
    
    for i in nums:
        if i == 0:  # Reset on zero
            curmin, curmax = 1, 1
            continue
        
        temp = curmax * i
        curmax = max(curmax*i, curmin*i, i)
        curmin = min(temp, curmin*i, i)
        res = max(res, curmax)
    
    return res
```

### Logic
```
1. Initialize res with max element (handles all-negative case)
2. When encountering zero:
   - Reset curr_max and curr_min to 1
   - Skip to next element
3. Otherwise, same as Solution 2
```

### Why Reset on Zero?
- Zero makes product 0
- Can't extend subarray through zero
- Must start fresh after zero

### Complexity
- **Time:** O(n)
- **Space:** O(1)

---

## Comparison Table

### Maximum Subarray Sum

| Solution | Time | Space | Complexity | Best For |
|----------|------|-------|------------|----------|
| Brute Force | O(n²) | O(1) | Simple | Small arrays |
| Kadane's | O(n) | O(1) | Optimal | **Production** |
| With Indices | O(n) | O(1) | Optimal | Need subarray |
| Divide & Conquer | O(n log n) | O(log n) | Complex | Learning |
| Array Storage | O(n) | O(n) | Wasteful | Debugging |
| Prefix Sum | O(n) | O(n) | Wasteful | Range queries |

### Maximum Product Subarray

| Solution | Time | Space | Handles Negatives | Handles Zeros | Best For |
|----------|------|-------|-------------------|---------------|----------|
| Brute Force | O(n²) | O(1) | ✅ | ✅ | Small arrays |
| Track Max/Min | O(n) | O(1) | ✅ | ✅ | **Production** |
| Swap on Negative | O(n) | O(1) | ✅ | ❌ | Clean code |
| Two-Pass | O(n) | O(1) | ✅ | ✅ | Alternative |
| Zero Reset | O(n) | O(1) | ✅ | ✅ | Explicit handling |

---

## Pattern Summary

### Kadane's Algorithm Pattern

**When to use:**
- ✅ Find maximum/minimum subarray sum
- ✅ Contiguous subarray optimization
- ✅ Can make decision at each position based on previous

**Template:**
```python
def kadane(arr):
    max_ending = arr[0]  # Best ending at current position
    global_max = arr[0]  # Best overall
    
    for i in range(1, len(arr)):
        # Extend or start fresh
        max_ending = max(arr[i], max_ending + arr[i])
        global_max = max(global_max, max_ending)
    
    return global_max
```

### Modified Kadane's for Product

**Key differences:**
- Track both max AND min (negatives flip)
- Handle zeros explicitly
- Three candidates: start fresh, extend max, extend min

**Template:**
```python
def kadane_product(arr):
    curr_max = curr_min = arr[0]
    global_max = arr[0]
    
    for i in range(1, len(arr)):
        temp = max(arr[i], curr_max*arr[i], curr_min*arr[i])
        curr_min = min(arr[i], curr_max*arr[i], curr_min*arr[i])
        curr_max = temp
        global_max = max(global_max, curr_max)
    
    return global_max
```

---

## Key Takeaways

### Maximum Subarray Sum
1. **Kadane's Algorithm is optimal** - O(n) time, O(1) space
2. **Key decision:** Extend current subarray or start fresh
3. **When to start fresh:** When previous sum is negative
4. **Divide & Conquer** works but slower (O(n log n))

### Maximum Product Subarray
1. **Must track both max AND min** - negatives flip values
2. **Three candidates** at each position: alone, extend max, extend min
3. **Handle zeros** - reset or skip
4. **Two-pass approach** - alternative that handles odd negatives

### General Patterns
- **Brute force:** O(n²) - try all subarrays
- **Dynamic Programming:** O(n) - make decision at each position
- **Optimal substructure:** Solution at i depends on solution at i-1
- **Greedy choice:** At each position, choose best option

---

## Practice Problems

### Similar to Maximum Sum
1. Maximum Subarray Sum (Kadane's)
2. Maximum Circular Subarray Sum
3. Maximum Sum of Non-Adjacent Elements
4. Best Time to Buy and Sell Stock

### Similar to Maximum Product
1. Maximum Product Subarray
2. Maximum Product of Three Numbers
3. Product of Array Except Self (related)

---

## Summary

**Your code demonstrates:**
- ✅ Understanding of brute force → optimization progression
- ✅ Multiple approaches to same problem
- ✅ Handling edge cases (negatives, zeros)
- ✅ Tracking indices for subarray

**Optimal solutions:**
- **Sum:** Kadane's Algorithm - O(n) time, O(1) space
- **Product:** Track max/min - O(n) time, O(1) space

**Golden Rule:** For subarray optimization problems, think Kadane's - make decision at each position based on previous state!
