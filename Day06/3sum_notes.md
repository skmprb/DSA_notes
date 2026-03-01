# Day 06: 3Sum

## Problem Pattern
**Two Pointers + Sorting** - Find all unique triplets that sum to target (0)

## Key Insight
- Convert 3Sum to 2Sum problem
- Fix one element, find two others that sum to `target - fixed_element`
- Sort array first to:
  1. Enable two-pointer technique
  2. Skip duplicates easily
  3. Early termination when sum becomes impossible

## Pseudocode
```
function threeSum(nums):
    sort(nums)
    result = []
    
    for i from 0 to n-3:
        // Skip duplicates for first element
        if i > 0 AND nums[i] == nums[i-1]:
            continue
        
        // Two pointer approach for remaining elements
        left = i + 1
        right = n - 1
        target = -nums[i]  // We want nums[i] + nums[left] + nums[right] = 0
        
        while left < right:
            sum = nums[left] + nums[right]
            
            if sum == target:
                result.append([nums[i], nums[left], nums[right]])
                
                // Skip duplicates for second element
                while left < right AND nums[left] == nums[left+1]:
                    left++
                // Skip duplicates for third element
                while left < right AND nums[right] == nums[right-1]:
                    right--
                
                left++
                right--
            else if sum < target:
                left++
            else:
                right--
    
    return result
```

## Flowchart

```
                    START
                      |
                      v
                  Sort array
                      |
                      v
              result = [], i = 0
                      |
                      v
              +---------------+
              | i < n-2?      |---NO---> return result
              +---------------+
                      |YES
                      v
         +-------------------------+
         | i>0 AND nums[i]==nums[i-1]?|---YES---> i++, loop back
         +-------------------------+
                      |NO
                      v
        left=i+1, right=n-1, target=-nums[i]
                      |
                      v
              +---------------+
              | left < right? |---NO---> i++, loop back
              +---------------+
                      |YES
                      v
            sum = nums[left] + nums[right]
                      |
                      v
         +-------------------------+
         |    sum == target?       |
         +-------------------------+
         |YES        |NO
         v           v
    Add triplet   sum < target?
    Skip dups      |YES    |NO
    left++         v       v
    right--     left++  right--
         |           |       |
         +-----------+-------+
                     |
                     v
         Loop back to "left < right?"
```

## Logic Walkthrough
Example: `[-1,0,1,2,-1,-4]`, target = 0

**After sorting**: `[-4,-1,-1,0,1,2]`

| i | nums[i] | target | left | right | nums[left] | nums[right] | sum | Action | Result |
|---|---------|--------|------|-------|------------|-------------|-----|--------|--------|
| 0 | -4      | 4      | 1    | 5     | -1         | 2           | 1   | left++ | - |
| 0 | -4      | 4      | 2    | 5     | -1         | 2           | 1   | left++ | - |
| 0 | -4      | 4      | 3    | 5     | 0          | 2           | 2   | left++ | - |
| 0 | -4      | 4      | 4    | 5     | 1          | 2           | 3   | left++ | - |
| 1 | -1      | 1      | 2    | 5     | -1         | 2           | 1   | right-- | - |
| 1 | -1      | 1      | 2    | 4     | -1         | 1           | 0   | Found! | [-1,-1,2] |
| 1 | -1      | 1      | 3    | 3     | -          | -           | -   | Stop | - |
| 2 | -1      | 1      | -    | -     | -          | -           | -   | Skip dup | - |
| 3 | 0       | 0      | 4    | 5     | 1          | 2           | 3   | right-- | - |
| 3 | 0       | 0      | 4    | 4     | -          | -           | -   | Stop | - |

**Final Result**: `[[-1,-1,2], [-1,0,1]]`

## Multiple Approaches

### Approach 1: Brute Force (3 Nested Loops)
```python
def threeSum_bruteforce(nums):
    n = len(nums)
    result = set()
    
    for i in range(n-2):
        for j in range(i+1, n-1):
            for k in range(j+1, n):
                if nums[i] + nums[j] + nums[k] == 0:
                    triplet = tuple(sorted([nums[i], nums[j], nums[k]]))
                    result.add(triplet)
    
    return [list(t) for t in result]
```
- **Time**: O(n³)
- **Space**: O(n) for result set
- ❌ Too slow

### Approach 2: Hash Set (2 Loops + Set)
```python
def threeSum_hashset(nums, target):
    n = len(nums)
    result_set = set()
    
    for i in range(n-2):
        seen = set()
        for j in range(i+1, n):
            complement = target - nums[i] - nums[j]
            
            if complement in seen:
                triplet = tuple(sorted([nums[i], nums[j], complement]))
                result_set.add(triplet)
            else:
                seen.add(nums[j])
    
    return [list(t) for t in result_set]
```
- **Time**: O(n²)
- **Space**: O(n) for hash set
- ✅ Good but uses extra space

### Approach 3: Two Pointers (Optimal)
```python
def threeSum_twopointers(nums):
    nums.sort()
    result = []
    n = len(nums)
    
    for i in range(n-2):
        # Skip duplicates for first element
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        left = i + 1
        right = n - 1
        target = -nums[i]
        
        while left < right:
            current_sum = nums[left] + nums[right]
            
            if current_sum == target:
                result.append([nums[i], nums[left], nums[right]])
                
                # Skip duplicates
                while left < right and nums[left] == nums[left+1]:
                    left += 1
                while left < right and nums[right] == nums[right-1]:
                    right -= 1
                
                left += 1
                right -= 1
            elif current_sum < target:
                left += 1
            else:
                right -= 1
    
    return result
```
- **Time**: O(n²)
- **Space**: O(1) excluding result
- ✅ Optimal solution

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n³) | O(n) | Check all triplets |
| Hash Set | O(n²) | O(n) | Extra space for set |
| Two Pointers | O(n²) | O(1) | Optimal, no extra space |
| Sorting cost | O(n log n) | - | One-time cost |

**Overall**: O(n log n) + O(n²) = O(n²)

## Handling Duplicates

**Three levels of duplicate prevention**:

1. **First element** (i):
   ```python
   if i > 0 and nums[i] == nums[i-1]:
       continue
   ```

2. **Second element** (left):
   ```python
   while left < right and nums[left] == nums[left+1]:
       left += 1
   ```

3. **Third element** (right):
   ```python
   while left < right and nums[right] == nums[right-1]:
       right -= 1
   ```

## Visual Representation

```
Array: [-4, -1, -1, 0, 1, 2]
        i=0
        ^
        |
    target = 4 (need left+right = 4)
    
        left=1, right=5
        [-4, -1, -1, 0, 1, 2]
             ^              ^
             -1 + 2 = 1 < 4 → move left

        left=2, right=5
        [-4, -1, -1, 0, 1, 2]
                 ^          ^
                 -1 + 2 = 1 < 4 → move left
        
        ... no solution for i=0

Array: [-4, -1, -1, 0, 1, 2]
            i=1
            ^
        target = 1 (need left+right = 1)
        
        left=2, right=5
        [-4, -1, -1, 0, 1, 2]
                 ^          ^
                 -1 + 2 = 1 ✓ Found: [-1,-1,2]
```

## Common Mistakes

1. **Not sorting array**: Two-pointer technique requires sorted array
2. **Not skipping duplicates**: Results in duplicate triplets
3. **Wrong duplicate skip logic**: Must check `i > 0` not `i >= 0`
4. **Infinite loop**: Forgetting to move pointers after finding match
5. **Wrong target**: Using `0` instead of `-nums[i]`

## Edge Cases

1. **All zeros**: `[0,0,0]` → `[[0,0,0]]`
2. **No solution**: `[1,2,3]` → `[]`
3. **Multiple duplicates**: `[-1,-1,-1,2,2,2]` → `[[-1,-1,2]]`
4. **Two elements**: `[1,2]` → `[]`
5. **Negative only**: `[-3,-2,-1]` → `[]`

## Pattern Variations

### 1. 3Sum Closest
**Problem**: Find triplet with sum closest to target
```python
def threeSumClosest(nums, target):
    nums.sort()
    closest = float('inf')
    
    for i in range(len(nums)-2):
        left, right = i+1, len(nums)-1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if abs(current_sum - target) < abs(closest - target):
                closest = current_sum
            
            if current_sum < target:
                left += 1
            elif current_sum > target:
                right -= 1
            else:
                return current_sum
    
    return closest
```

### 2. 4Sum
**Problem**: Find all quadruplets that sum to target
```python
def fourSum(nums, target):
    nums.sort()
    result = []
    n = len(nums)
    
    for i in range(n-3):
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        for j in range(i+1, n-2):
            if j > i+1 and nums[j] == nums[j-1]:
                continue
            
            left, right = j+1, n-1
            
            while left < right:
                current_sum = nums[i] + nums[j] + nums[left] + nums[right]
                
                if current_sum == target:
                    result.append([nums[i], nums[j], nums[left], nums[right]])
                    
                    while left < right and nums[left] == nums[left+1]:
                        left += 1
                    while left < right and nums[right] == nums[right-1]:
                        right -= 1
                    
                    left += 1
                    right -= 1
                elif current_sum < target:
                    left += 1
                else:
                    right -= 1
    
    return result
```

### 3. 3Sum Smaller
**Problem**: Count triplets with sum less than target
```python
def threeSumSmaller(nums, target):
    nums.sort()
    count = 0
    
    for i in range(len(nums)-2):
        left, right = i+1, len(nums)-1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if current_sum < target:
                # All elements between left and right work
                count += right - left
                left += 1
            else:
                right -= 1
    
    return count
```

## Pattern Recognition

Use **3Sum pattern** when:
- ✅ Need to find triplets with specific sum property
- ✅ Array can be sorted
- ✅ Need to avoid duplicates
- ✅ O(n²) time is acceptable
- ✅ Can reduce to 2Sum problem

## Tips for Implementation

1. **Always sort first**: Enables two-pointer technique
2. **Skip duplicates at all levels**: i, left, right
3. **Check boundary conditions**: `i > 0` not `i >= 0`
4. **Move both pointers**: After finding match
5. **Use target = -nums[i]**: Clearer than checking sum == 0

## Related Problems
- LeetCode 15: 3Sum
- LeetCode 16: 3Sum Closest
- LeetCode 18: 4Sum
- LeetCode 259: 3Sum Smaller
- LeetCode 1: Two Sum
- LeetCode 167: Two Sum II

## Optimization Techniques

1. **Early termination**:
   ```python
   if nums[i] > 0:  # All remaining are positive
       break
   ```

2. **Skip impossible cases**:
   ```python
   if nums[i] + nums[i+1] + nums[i+2] > 0:
       break
   if nums[i] + nums[n-2] + nums[n-1] < 0:
       continue
   ```

3. **Use frequency map** (for arrays with many duplicates):
   ```python
   freq = {}
   for n in nums:
       freq[n] = freq.get(n, 0) + 1
   ```

## Key Takeaways

1. **Sort + Two Pointers** is the optimal approach for 3Sum
2. **Skip duplicates at three levels** to avoid duplicate triplets
3. **Convert 3Sum to 2Sum** by fixing one element
4. **Time complexity**: O(n²) after O(n log n) sorting
5. **Pattern extends to 4Sum, kSum** with additional loops
