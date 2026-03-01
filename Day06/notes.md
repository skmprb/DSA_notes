# Day 06: Container With Most Water

## Problem Pattern
**Two Pointers** - Greedy approach to maximize area

## Key Insight
- Area = min(height[left], height[right]) × (right - left)
- Start with maximum width (left=0, right=n-1)
- Move the pointer with smaller height inward (greedy choice)
- Why? Moving the taller pointer can only decrease area (width decreases, height can't increase)

## Pseudocode
```
function maxArea(height):
    left = 0
    right = length(height) - 1
    maxArea = 0
    
    while left < right:
        // Calculate current area
        width = right - left
        currentHeight = min(height[left], height[right])
        area = currentHeight × width
        
        // Update maximum
        maxArea = max(maxArea, area)
        
        // Move pointer with smaller height
        if height[left] < height[right]:
            left = left + 1
        else:
            right = right - 1
    
    return maxArea
```

## Flowchart

```
                    START
                      |
                      v
        left = 0, right = n-1, maxArea = 0
                      |
                      v
              +---------------+
              | left < right? |---NO---> return maxArea
              +---------------+
                      |YES
                      v
        width = right - left
        height = min(height[left], height[right])
        area = height × width
                      |
                      v
        maxArea = max(maxArea, area)
                      |
                      v
         +---------------------------+
         | height[left] < height[right]?|
         +---------------------------+
              |YES            |NO
              v               v
          left++          right--
              |               |
              +-------+-------+
                      |
                      v
        Loop back to "left < right?"
```

## Logic Walkthrough
Example: `[1,8,6,2,5,4,8,3,7]`

| Step | left | right | height[left] | height[right] | width | area | maxArea | Move |
|------|------|-------|--------------|---------------|-------|------|---------|------|
| 1    | 0    | 8     | 1            | 7             | 8     | 8    | 8       | left++ (1<7) |
| 2    | 1    | 8     | 8            | 7             | 7     | 49   | 49      | right-- (8>7) |
| 3    | 1    | 7     | 8            | 3             | 6     | 18   | 49      | right-- (8>3) |
| 4    | 1    | 6     | 8            | 8             | 5     | 40   | 49      | left++ (8=8) |
| 5    | 2    | 6     | 6            | 8             | 4     | 24   | 49      | left++ (6<8) |
| 6    | 3    | 6     | 2            | 8             | 3     | 6    | 49      | left++ (2<8) |
| 7    | 4    | 6     | 5            | 8             | 2     | 10   | 49      | left++ (5<8) |
| 8    | 5    | 6     | 4            | 8             | 1     | 4    | 49      | left++ (4<8) |
| 9    | 6    | 6     | -            | -             | -     | -    | 49      | STOP |

**Result**: 49

## Visual Representation

```
Initial State:
Height: [1, 8, 6, 2, 5, 4, 8, 3, 7]
Index:   0  1  2  3  4  5  6  7  8
         ^                       ^
       left                    right
Area = min(1,7) × 8 = 8

After moving left (1 < 7):
Height: [1, 8, 6, 2, 5, 4, 8, 3, 7]
            ^                    ^
          left                 right
Area = min(8,7) × 7 = 49 ← Maximum!
```

## Two Approaches Comparison

### Approach 1: Brute Force (Nested Loops)
```python
def maxArea_bruteforce(height):
    n = len(height)
    result = 0
    
    for i in range(n):
        for j in range(i+1, n):
            area = min(height[i], height[j]) * (j - i)
            result = max(result, area)
    
    return result
```
- **Time**: O(n²) - Check all pairs
- **Space**: O(1)
- ❌ Too slow for large inputs

### Approach 2: Two Pointers (Optimal)
```python
def maxArea_twopointers(height):
    left = 0
    right = len(height) - 1
    result = 0
    
    while left < right:
        area = min(height[left], height[right]) * (right - left)
        result = max(area, result)
        
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    
    return result
```
- **Time**: O(n) - Single pass
- **Space**: O(1)
- ✅ Optimal solution

## Why Two Pointers Work (Proof)

**Greedy Choice**: Always move the pointer with smaller height

**Reasoning**:
1. Start with maximum width
2. To increase area, we need greater height (since width decreases)
3. Moving the taller pointer:
   - Width decreases
   - Height can only stay same or decrease (limited by min)
   - Area will definitely decrease or stay same
4. Moving the shorter pointer:
   - Width decreases
   - Height might increase (if we find taller line)
   - Area might increase

**Conclusion**: Moving shorter pointer is the only chance to increase area!

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n²) | O(1) | Check all pairs |
| Two Pointers | O(n) | O(1) | Optimal, single pass |
| Divide & Conquer | O(n log n) | O(log n) | Possible but not optimal |

## Common Mistakes

1. **Moving wrong pointer**: Moving the taller pointer
   - Always move the shorter one for chance to increase area

2. **Wrong area calculation**: Using `max(height[left], height[right])`
   - Should use `min()` because water level is limited by shorter line

3. **Off-by-one errors**: Using `left <= right` instead of `left < right`
   - Need two different lines, so `left < right`

4. **Not updating max**: Forgetting to track maximum area
   - Must compare and update `maxArea` in each iteration

## Edge Cases

1. **Two elements**: `[1,1]` → 1
2. **Increasing heights**: `[1,2,3,4,5]` → 6 (indices 0 and 4)
3. **Decreasing heights**: `[5,4,3,2,1]` → 6 (indices 0 and 4)
4. **All same height**: `[5,5,5,5]` → 15 (indices 0 and 3)
5. **Large difference**: `[1,100,1]` → 2 (indices 0 and 2)

## Pattern Variations

### 1. Trapping Rain Water
**Problem**: Calculate total water trapped between bars
```python
def trap(height):
    left, right = 0, len(height) - 1
    left_max, right_max = 0, 0
    water = 0
    
    while left < right:
        if height[left] < height[right]:
            if height[left] >= left_max:
                left_max = height[left]
            else:
                water += left_max - height[left]
            left += 1
        else:
            if height[right] >= right_max:
                right_max = height[right]
            else:
                water += right_max - height[right]
            right -= 1
    
    return water
```

### 2. Maximum Rectangle in Histogram
**Problem**: Find largest rectangle in histogram
```python
def largestRectangleArea(heights):
    stack = []
    max_area = 0
    
    for i, h in enumerate(heights):
        start = i
        while stack and stack[-1][1] > h:
            index, height = stack.pop()
            max_area = max(max_area, height * (i - index))
            start = index
        stack.append((start, h))
    
    for i, h in stack:
        max_area = max(max_area, h * (len(heights) - i))
    
    return max_area
```

### 3. 3Sum Closest
**Problem**: Find three numbers whose sum is closest to target
```python
def threeSumClosest(nums, target):
    nums.sort()
    closest = float('inf')
    
    for i in range(len(nums) - 2):
        left, right = i + 1, len(nums) - 1
        
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

## Pattern Recognition

Use **Two Pointers** pattern when:
- ✅ Array is sorted or can be processed from both ends
- ✅ Need to find pair/triplet with certain property
- ✅ Greedy choice can be made about which pointer to move
- ✅ O(n) time complexity is required
- ✅ Problem involves comparing elements from opposite ends

## Tips for Implementation

1. **Start with maximum width**: Initialize pointers at both ends
2. **Calculate area first**: Before moving pointers
3. **Move shorter pointer**: Greedy choice for potential increase
4. **Update maximum**: Track best result seen so far
5. **Loop condition**: Use `left < right` (not `<=`)

## Related Problems
- LeetCode 11: Container With Most Water
- LeetCode 42: Trapping Rain Water
- LeetCode 84: Largest Rectangle in Histogram
- LeetCode 15: 3Sum
- LeetCode 16: 3Sum Closest
- LeetCode 167: Two Sum II - Input Array Is Sorted

## Time Complexity Breakdown

```
Best Case: O(n) - Always need to check all possibilities
Average Case: O(n) - Single pass through array
Worst Case: O(n) - Single pass through array
Space: O(1) - Only using two pointers
```

## Key Takeaways

1. **Two pointers optimize from O(n²) to O(n)** for this problem
2. **Greedy choice**: Always move the shorter pointer
3. **Area formula**: min(height[left], height[right]) × width
4. **Start with maximum width** and work inward
5. **Pattern applies to many array problems** involving pairs/triplets
