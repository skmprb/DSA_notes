# Search in Rotated Sorted Array

## Problem Pattern
**Modified Binary Search** - Search for target in rotated sorted array

## Key Insight
At any point in a rotated sorted array, at least one half is guaranteed to be sorted. Use this to determine which half to search.

### Decision Logic
1. Find mid point
2. Check if `nums[mid] == target` → return mid
3. Identify which half is sorted:
   - If `nums[mid] >= nums[left]` → left half is sorted
   - Else → right half is sorted
4. Check if target is in the sorted half:
   - If yes → search that half
   - If no → search the other half

## Pseudocode
```
function search(nums, target):
    left = 0
    right = length(nums) - 1
    
    while left <= right:
        mid = (left + right) / 2
        
        if nums[mid] == target:
            return mid
        
        // Identify sorted half
        if nums[mid] >= nums[left]:
            // Left half is sorted
            if target >= nums[left] AND target < nums[mid]:
                right = mid - 1  // Search left
            else:
                left = mid + 1   // Search right
        else:
            // Right half is sorted
            if target > nums[mid] AND target <= nums[right]:
                left = mid + 1   // Search right
            else:
                right = mid - 1  // Search left
    
    return -1  // Not found
```

## Flowchart

```
                    START
                      |
                      v
            left = 0, right = n-1
                      |
                      v
              +---------------+
              | left <= right?|---NO---> return -1
              +---------------+
                      |YES
                      v
              mid = (left+right)/2
                      |
                      v
            +-------------------+
            | nums[mid]==target?|---YES---> return mid
            +-------------------+
                      |NO
                      v
         +-------------------------+
         | nums[mid] >= nums[left]?|
         +-------------------------+
            |YES              |NO
            v                 v
    [Left Half Sorted]   [Right Half Sorted]
            |                 |
            v                 v
  +-------------------+  +-------------------+
  |target in [left,mid)|  |target in (mid,right]|
  +-------------------+  +-------------------+
      |YES    |NO          |YES    |NO
      v       v            v       v
   right=  left=       left=   right=
   mid-1   mid+1       mid+1   mid-1
      |       |            |       |
      +-------+------------+-------+
              |
              v
      Loop back to "left <= right?"
```

## Logic Walkthrough
Example: `[4,5,6,7,0,1,2]`, target = 0

| Step | left | right | mid | nums[mid] | Sorted Half | Target Range Check | Action |
|------|------|-------|-----|-----------|-------------|-------------------|--------|
| 1    | 0    | 6     | 3   | 7         | Left [4-7]  | 0 not in [4,7]   | left = 4 |
| 2    | 4    | 6     | 5   | 1         | Right [1-2] | 0 not in [1,2]   | right = 4 |
| 3    | 4    | 4     | 4   | 0         | Found!      | -                 | return 4 |

## Visual Representation
```
Array: [4, 5, 6, 7, 0, 1, 2]
        ^           ^        ^
      left         mid     right

Step 1: mid=7, left half [4,5,6,7] sorted
        target=0 not in [4,7] → search right

Array: [4, 5, 6, 7, 0, 1, 2]
                    ^  ^  ^
                  left mid right

Step 2: mid=1, right half [1,2] sorted
        target=0 not in [1,2] → search left

Array: [4, 5, 6, 7, 0, 1, 2]
                    ^
                left/mid/right

Step 3: Found target at index 4
```

## Two Valid Approaches

### Approach 1: Inclusive Range Check
```python
if nums[left] <= target and nums[mid] >= target:
    right = mid - 1
```
- Checks if target ∈ [nums[left], nums[mid]]
- Uses `<=` and `>=` (symmetric)

### Approach 2: Exclusive Right Boundary
```python
if target >= nums[left] and target < nums[mid]:
    right = mid - 1
```
- Checks if target ∈ [nums[left], nums[mid])
- Uses `>=` and `<` (excludes mid explicitly)

**Both are correct** because we check `nums[mid] == target` first!

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Binary Search | O(log n) | O(1) | Optimal solution |
| Linear Scan | O(n) | O(1) | Simple but doesn't meet requirement |
| Find pivot + Binary Search | O(log n) | O(1) | Two-pass approach |

## Common Mistakes

1. **Wrong comparison**: Using `nums[mid] > nums[left]` instead of `>=`
   - Fails when left == mid (single element case)

2. **Incorrect range check**: Forgetting `=` in boundary conditions
   - Example: `target > nums[mid]` should be `target >= nums[mid]` in some cases

3. **Wrong boundary update**: Using `left = mid` or `right = mid`
   - Can cause infinite loop

4. **Not checking mid first**: Checking sorted half before `nums[mid] == target`
   - Inefficient but still works

## Edge Cases

1. **Single element**: `[1]`, target = 1 → return 0
2. **Two elements rotated**: `[3,1]`, target = 1 → return 1
3. **Not rotated**: `[1,2,3,4,5]`, target = 3 → return 2
4. **Target not found**: `[4,5,6,7,0,1,2]`, target = 3 → return -1
5. **Target at boundaries**: `[4,5,6,7,0,1,2]`, target = 4 → return 0

## Pattern Variations

### 1. Search in Rotated Array II (with duplicates)
```python
def search_with_duplicates(nums, target):
    left, right = 0, len(nums) - 1
    
    while left <= right:
        mid = (left + right) // 2
        
        if nums[mid] == target:
            return True
        
        # Handle duplicates
        if nums[left] == nums[mid] == nums[right]:
            left += 1
            right -= 1
        elif nums[left] <= nums[mid]:
            if nums[left] <= target < nums[mid]:
                right = mid - 1
            else:
                left = mid + 1
        else:
            if nums[mid] < target <= nums[right]:
                left = mid + 1
            else:
                right = mid - 1
    
    return False
```

### 2. Find Minimum (covered in min_rotated_sorted_array.ipynb)
```python
def findMin(nums):
    left, right = 0, len(nums) - 1
    
    while left < right:
        mid = (left + right) // 2
        
        if nums[mid] < nums[right]:
            right = mid
        else:
            left = mid + 1
    
    return nums[left]
```

### 3. Find Rotation Index
```python
def find_rotation_index(nums):
    left, right = 0, len(nums) - 1
    
    if nums[left] < nums[right]:
        return 0  # Not rotated
    
    while left <= right:
        mid = (left + right) // 2
        
        if nums[mid] > nums[mid + 1]:
            return mid + 1
        
        if nums[mid] < nums[left]:
            right = mid - 1
        else:
            left = mid + 1
    
    return 0
```

## Pattern Recognition

Use this pattern when:
- ✅ Array is sorted but rotated
- ✅ Need O(log n) time complexity
- ✅ Searching for specific target value
- ✅ Array has distinct values (or handle duplicates)
- ✅ Can identify sorted half by comparing boundaries

## Tips for Implementation

1. **Always check mid first**: `if nums[mid] == target: return mid`
2. **Use `>=` for sorted half check**: `nums[mid] >= nums[left]`
3. **Be careful with boundary conditions**: Include `=` where needed
4. **Loop condition**: Use `left <= right` (not `left < right`)
5. **Avoid overflow**: Use `mid = left + (right - left) // 2`

## Related Problems
- LeetCode 33: Search in Rotated Sorted Array
- LeetCode 81: Search in Rotated Sorted Array II (with duplicates)
- LeetCode 153: Find Minimum in Rotated Sorted Array
- LeetCode 154: Find Minimum in Rotated Sorted Array II
- LeetCode 162: Find Peak Element

## Time Complexity Breakdown

```
Best Case: O(1) - target is at mid in first iteration
Average Case: O(log n) - binary search
Worst Case: O(log n) - search entire array
Space: O(1) - only using pointers
```

## Key Takeaways

1. **One half is always sorted** in a rotated array
2. **Identify sorted half** using `nums[mid]` vs `nums[left]`
3. **Check if target is in sorted half** using range comparison
4. **Both inclusive and exclusive range checks work** (as long as consistent)
5. **Handle edge cases**: single element, not rotated, target at boundaries
