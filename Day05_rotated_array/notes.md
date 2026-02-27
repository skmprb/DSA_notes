# Day 05: Rotated Sorted Array - Find Minimum

## Problem Pattern
**Modified Binary Search** on rotated sorted array

## Core Pattern: Binary Search on Rotated Array

This pattern applies when:
- Array is sorted but rotated at an unknown pivot
- Need O(log n) time complexity
- Must determine which half to search based on rotation

### Pattern Template
```python
def binary_search_rotated(nums):
    left, right = 0, len(nums) - 1
    
    while left < right:
        mid = (left + right) // 2
        
        # Compare mid with boundary to determine sorted half
        if condition_to_identify_sorted_half:
            # Adjust search space
            right = mid  # or left = mid + 1
        else:
            left = mid + 1  # or right = mid
    
    return nums[left]
```

## Key Insight
In a rotated sorted array, comparing `nums[mid]` with `nums[right]` tells us which half contains the minimum:
- If `nums[mid] < nums[right]`: Right half is sorted → minimum is in left half (including mid)
- If `nums[mid] > nums[right]`: Rotation point is in right half → minimum is there

## Pseudocode
```
function findMin(nums):
    left = 0
    right = length(nums) - 1
    
    while left < right:
        mid = (left + right) / 2
        
        if nums[mid] < nums[right]:
            // Right half sorted, search left
            right = mid
        else:
            // Rotation in right half
            left = mid + 1
    
    return nums[left]
```

## Flowchart

```
                START
                  |
                  v
        left = 0, right = n-1
                  |
                  v
          +--------------+
          | left < right?|---NO---> return nums[left]
          +--------------+
                  |YES
                  v
        mid = (left+right)/2
                  |
                  v
        +---------------------+
        | nums[mid] < nums[right]?|
        +---------------------+
            |YES          |NO
            v              v
    [Right half      [Rotation point
     is sorted]       in right half]
            |              |
            v              v
        right = mid    left = mid+1
            |              |
            +------+-------+
                   |
                   v
        Loop back to "left < right?"
                   |
                   v
            return nums[left]
                   |
                   v
                  END
```

## Logic Walkthrough
Example: `[3,4,5,1,2]`

| Step | l | r | mid | nums[mid] | nums[r] | Action |
|------|---|---|-----|-----------|---------|--------|
| 1    | 0 | 4 | 2   | 5         | 2       | 5 > 2 → l = 3 |
| 2    | 3 | 4 | 3   | 1         | 2       | 1 < 2 → r = 3 |
| 3    | 3 | 3 | -   | -         | -       | Return nums[3] = 1 |

## Complexity Analysis

### Approach 1: Sorting
- **Time**: O(n log n)
- **Space**: O(1) or O(n) depending on sort implementation
- ❌ Does not meet O(log n) requirement

### Approach 2: Binary Search (Optimal)
- **Time**: O(log n)
- **Space**: O(1)
- ✅ Meets requirement

### Approach 3: Linear Scan
- **Time**: O(n)
- **Space**: O(1)
- ❌ Does not meet O(log n) requirement

## Similar Problems Using This Pattern

### 1. Search in Rotated Sorted Array (LeetCode 33)
**Problem**: Find target value in rotated sorted array
```python
def search(nums, target):
    l, r = 0, len(nums) - 1
    
    while l <= r:
        mid = (l + r) // 2
        if nums[mid] == target:
            return mid
        
        # Identify which half is sorted
        if nums[l] <= nums[mid]:  # Left half sorted
            if nums[l] <= target < nums[mid]:
                r = mid - 1
            else:
                l = mid + 1
        else:  # Right half sorted
            if nums[mid] < target <= nums[r]:
                l = mid + 1
            else:
                r = mid - 1
    return -1
```

### 2. Find Rotation Count
**Problem**: Count how many times array was rotated
```python
def find_rotation_count(nums):
    l, r = 0, len(nums) - 1
    
    while l < r:
        if nums[l] < nums[r]:  # Not rotated
            return l
        
        mid = (l + r) // 2
        
        if nums[mid] > nums[r]:
            l = mid + 1
        else:
            r = mid
    
    return l  # Index of minimum = rotation count
```

### 3. Find Peak Element in Rotated Array
**Problem**: Find maximum element (peak before rotation)
```python
def find_peak(nums):
    l, r = 0, len(nums) - 1
    
    while l < r:
        mid = (l + r) // 2
        
        if nums[mid] > nums[mid + 1]:
            return mid  # Found peak
        
        if nums[mid] >= nums[l]:
            l = mid + 1
        else:
            r = mid
    
    return l
```

### 4. Find Minimum in Rotated Sorted Array II (with duplicates)
**Problem**: Same but array may contain duplicates
```python
def findMin_with_duplicates(nums):
    l, r = 0, len(nums) - 1
    
    while l < r:
        mid = (l + r) // 2
        
        if nums[mid] < nums[r]:
            r = mid
        elif nums[mid] > nums[r]:
            l = mid + 1
        else:  # nums[mid] == nums[r], can't determine, shrink right
            r -= 1
    
    return nums[l]
```

### 5. Search in Nearly Sorted Array
**Problem**: Element at index i might be at i-1, i, or i+1
```python
def search_nearly_sorted(nums, target):
    l, r = 0, len(nums) - 1
    
    while l <= r:
        mid = (l + r) // 2
        
        if nums[mid] == target:
            return mid
        if mid > 0 and nums[mid - 1] == target:
            return mid - 1
        if mid < len(nums) - 1 and nums[mid + 1] == target:
            return mid + 1
        
        if nums[mid] < target:
            l = mid + 2
        else:
            r = mid - 2
    
    return -1
```

## Pattern Recognition Checklist

Use **Modified Binary Search on Rotated Array** when:
- ✅ Array is sorted but rotated
- ✅ Need O(log n) time complexity
- ✅ Looking for min, max, target, or rotation point
- ✅ Can identify which half is sorted by comparing boundaries
- ✅ Array elements are comparable

## Common Variations

| Variation | Key Difference | Adjustment |
|-----------|----------------|------------|
| With duplicates | Can't always determine sorted half | Add `nums[mid] == nums[r]` case, shrink boundary |
| Find maximum | Looking for peak instead of valley | Reverse comparison logic |
| Search target | Need exact match | Check `nums[mid] == target` first |
| Count rotations | Return index not value | Return `left` index at end |

## Edge Cases
1. Array not rotated: `[1,2,3,4,5]` → Still works, returns 1
2. Single element: `[5]` → Returns 5
3. Two elements: `[2,1]` → Returns 1
4. Fully rotated (n times): Same as original array
5. All duplicates: `[2,2,2,2]` → Need special handling

## Tips for Implementation

1. **Choose comparison wisely**: Compare `mid` with `right` (not `left`) for finding minimum
2. **Boundary updates**: Use `r = mid` (not `mid - 1`) when mid could be answer
3. **Loop condition**: Use `l < r` (not `l <= r`) when converging to single element
4. **Early exit**: Check if `nums[l] < nums[r]` for non-rotated case
5. **Avoid overflow**: Use `mid = l + (r - l) // 2` for very large arrays

## Related Patterns
- Binary Search (standard)
- Two Pointers
- Divide and Conquer
- Peak Finding
