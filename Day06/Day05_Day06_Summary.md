# Day 05 & 06 Summary - Binary Search & Two Pointers

## Overview

**Day 05**: Binary Search on Rotated Sorted Arrays  
**Day 06**: Two Pointers for Array Problems

Both days focus on **optimizing from O(n²) or O(n) to O(log n) or O(n)** using clever techniques.

---

## Day 05: Rotated Sorted Array Problems

### Pattern: Modified Binary Search

**Core Concept**: In a rotated sorted array, at least one half is always sorted.

### Problem 1: Find Minimum in Rotated Sorted Array

#### Your Code (Optimal)
```python
def findmin(nums):
    l = 0
    r = len(nums)-1

    while l < r:
        mid = (l+r)//2
        if nums[mid] < nums[r]:
            r = mid
        else:
            l = mid+1
    return nums[l]
```

#### Logic Explanation
```
1. Initialize left=0, right=n-1
2. While left < right:
   a. Calculate mid
   b. Compare nums[mid] with nums[right]:
      - If nums[mid] < nums[right]:
        * Right half is sorted
        * Minimum is in left half (including mid)
        * Move right = mid
      - Else:
        * Rotation point is in right half
        * Minimum is there
        * Move left = mid + 1
3. Return nums[left]
```

#### Why It Works
- **Key Insight**: Compare mid with right boundary
- If `nums[mid] < nums[right]`: Right side is sorted, min must be on left
- If `nums[mid] > nums[right]`: Rotation happened, min is on right

#### Example Walkthrough: `[3,4,5,1,2]`
```
Step 1: l=0, r=4, mid=2
        nums[2]=5, nums[4]=2
        5 > 2 → rotation in right half
        l = mid+1 = 3

Step 2: l=3, r=4, mid=3
        nums[3]=1, nums[4]=2
        1 < 2 → right half sorted
        r = mid = 3

Step 3: l=3, r=3 → stop
        Return nums[3] = 1
```

#### Complexity
- **Time**: O(log n) - binary search
- **Space**: O(1) - only pointers

#### Alternative (Not Optimal)
```python
def findmin(nums):
    nums.sort()
    return nums[0]
```
- **Time**: O(n log n) - sorting
- **Space**: O(1)
- ❌ Doesn't meet O(log n) requirement

---

### Problem 2: Search in Rotated Sorted Array

#### Your Code (Optimal)
```python
def search_key(nums, target):
    left = 0
    right = len(nums)-1

    while left <= right:
        mid = left + (right-left)//2

        if nums[mid] == target:
            return mid

        if nums[mid] >= nums[left]:
            if target >= nums[left] and target < nums[mid]:
                right = mid - 1
            else:
                left = mid + 1
        else:
            if target > nums[mid] and target <= nums[right]:
                left = mid + 1
            else:
                right = mid - 1
    return -1
```

#### Logic Explanation
```
1. Initialize left=0, right=n-1
2. While left <= right:
   a. Calculate mid
   b. If nums[mid] == target: return mid
   c. Identify which half is sorted:
      - If nums[mid] >= nums[left]: Left half sorted
        * Check if target in [nums[left], nums[mid])
        * If yes: search left (right = mid-1)
        * If no: search right (left = mid+1)
      - Else: Right half sorted
        * Check if target in (nums[mid], nums[right]]
        * If yes: search right (left = mid+1)
        * If no: search left (right = mid-1)
3. Return -1 if not found
```

#### Why It Works
- **Key Insight**: One half is always sorted
- Identify sorted half by comparing `nums[mid]` with `nums[left]`
- Check if target is in sorted half's range
- If yes, search that half; otherwise, search other half

#### Example Walkthrough: `[4,5,6,7,0,1,2]`, target = 0
```
Step 1: left=0, right=6, mid=3
        nums[3]=7, target=0
        Left half [4,5,6,7] is sorted (7 >= 4)
        0 not in [4,7) → search right
        left = 4

Step 2: left=4, right=6, mid=5
        nums[5]=1, target=0
        Right half [1,2] is sorted (1 < 4)
        0 not in (1,2] → search left
        right = 4

Step 3: left=4, right=4, mid=4
        nums[4]=0 == target
        Return 4
```

#### Complexity
- **Time**: O(log n) - binary search
- **Space**: O(1) - only pointers

---

## Day 06: Two Pointers Problems

### Pattern: Two Pointers (Opposite Direction)

**Core Concept**: Start from both ends, move pointers based on greedy choice.

### Problem 1: Container With Most Water

#### Your Code (Brute Force)
```python
def maxwaterfor(height):
    n = len(height)
    result = 0

    for i in range(n):
        for j in range(i+1, n):
            area = min(height[i], height[j]) * (j-i)
            result = max(result, area)
    
    return result
```

#### Logic Explanation (Brute Force)
```
1. Try all pairs (i, j) where i < j
2. For each pair:
   a. Calculate area = min(height[i], height[j]) × (j - i)
   b. Update maximum area
3. Return maximum
```

#### Complexity (Brute Force)
- **Time**: O(n²) - nested loops
- **Space**: O(1)
- ❌ Too slow for large inputs

---

#### Your Code (Optimal - Two Pointers)
```python
def maxWaterPointer(heights):
    left = 0
    right = len(heights)-1
    result = 0

    while left < right:
        area = min(heights[left], heights[right]) * (right - left)
        result = max(area, result)
        if heights[left] < heights[right]:
            left+=1
        else:
            right -=1

    return result
```

#### Logic Explanation (Optimal)
```
1. Initialize left=0, right=n-1, result=0
2. While left < right:
   a. Calculate area = min(height[left], height[right]) × (right - left)
   b. Update result = max(result, area)
   c. Move pointer with smaller height:
      - If height[left] < height[right]: left++
      - Else: right--
3. Return result
```

#### Why It Works (Greedy Proof)
- **Start with maximum width** (left=0, right=n-1)
- **Area = min(height) × width**
- Moving the **taller pointer**:
  - Width decreases
  - Height can only stay same or decrease (limited by min)
  - Area will definitely not increase
- Moving the **shorter pointer**:
  - Width decreases
  - Height might increase (if we find taller line)
  - Area might increase
- **Conclusion**: Moving shorter pointer is the only chance to increase area!

#### Example Walkthrough: `[1,8,6,2,5,4,8,3,7]`
```
Step 1: left=0, right=8
        height[0]=1, height[8]=7
        area = min(1,7) × 8 = 8
        1 < 7 → move left++

Step 2: left=1, right=8
        height[1]=8, height[8]=7
        area = min(8,7) × 7 = 49 ← Maximum!
        8 > 7 → move right--

Step 3: left=1, right=7
        height[1]=8, height[7]=3
        area = min(8,3) × 6 = 18
        8 > 3 → move right--

... continue until left >= right

Result: 49
```

#### Complexity (Optimal)
- **Time**: O(n) - single pass
- **Space**: O(1) - only pointers
- ✅ Optimal solution

#### Optimization
- **From O(n²) to O(n)** using two pointers
- **Key**: Greedy choice eliminates need to check all pairs

---

### Problem 2: 3Sum

#### Your Code (Hash Set Approach)
```python
def hastripletsum(nums, target):
    n = len(nums)
    for i in range(n-2):
        st = set()
        for j in range(i, n-1):
            second = target - nums[i] - nums[j]

            if second in st:
                return[nums[i], nums[j], second]
            else:
                st.add(nums[j])
    return []
```

#### Logic Explanation (Hash Set)
```
1. For each element i:
   a. Create empty set
   b. For each element j after i:
      - Calculate complement = target - nums[i] - nums[j]
      - If complement in set: found triplet
      - Else: add nums[j] to set
2. Return triplet or empty
```

#### Complexity (Hash Set)
- **Time**: O(n²) - two loops
- **Space**: O(n) - hash set
- ✅ Good but uses extra space

---

#### Your Code (Two Pointers - Optimal)
```python
def gettripletsSum(nums, target):
    n = len(nums)
    nums.sort()

    for i in range(n-2):
        second  = target - nums[i]
        j = i+1
        k = n-1
        while j < k:
            if nums[j]+nums[k] == second:
                return [nums[i], nums[j], nums[k]]
            elif nums[j]+nums[k] < second:
                j+=1
            else:
                k -= 1
    return []
```

#### Logic Explanation (Two Pointers)
```
1. Sort array
2. For each element i:
   a. Calculate target_sum = target - nums[i]
   b. Use two pointers (j=i+1, k=n-1) to find pair with sum = target_sum
   c. While j < k:
      - If nums[j] + nums[k] == target_sum: found triplet
      - If nums[j] + nums[k] < target_sum: j++ (need larger sum)
      - If nums[j] + nums[k] > target_sum: k-- (need smaller sum)
3. Return triplet or empty
```

#### Why It Works
- **Convert 3Sum to 2Sum**: Fix one element, find two others
- **Sorting enables two pointers**: Can move pointers based on sum comparison
- **Greedy choice**: Move left if sum too small, move right if sum too large

#### Example Walkthrough: `[-1,0,1,2,-1,-4]`, target = 0
```
After sorting: [-4,-1,-1,0,1,2]

i=0, nums[0]=-4, target_sum=4
  j=1, k=5: -1+2=1 < 4 → j++
  j=2, k=5: -1+2=1 < 4 → j++
  j=3, k=5: 0+2=2 < 4 → j++
  j=4, k=5: 1+2=3 < 4 → j++
  j=5, k=5: stop (no solution)

i=1, nums[1]=-1, target_sum=1
  j=2, k=5: -1+2=1 ✓ Found: [-1,-1,2]
```

#### Complexity (Two Pointers)
- **Time**: O(n²) - O(n log n) sort + O(n²) loops
- **Space**: O(1) - excluding result
- ✅ Optimal solution

#### Handling Duplicates (Your Advanced Code)
```python
def gettripletsSum(nums, target):
    n = len(nums)
    nums.sort()
    result = []
    
    for i in range(n - 2):
        # Skip duplicate values for first element
        if i > 0 and nums[i] == nums[i - 1]:
            continue
            
        left = i + 1
        right = n - 1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if current_sum == target:
                result.append([nums[i], nums[left], nums[right]])
                
                # Skip duplicates for second element
                while left < right and nums[left] == nums[left + 1]:
                    left += 1
                # Skip duplicates for third element
                while left < right and nums[right] == nums[right - 1]:
                    right -= 1
                    
                left += 1
                right -= 1
            elif current_sum < target:
                left += 1
            else:
                right -= 1
                
    return result
```

#### Logic for Duplicate Handling
```
1. Skip duplicates at three levels:
   a. First element (i): if i > 0 and nums[i] == nums[i-1]: continue
   b. Second element (left): while nums[left] == nums[left+1]: left++
   c. Third element (right): while nums[right] == nums[right-1]: right--
2. This ensures unique triplets in result
```

#### Optimization
- **From O(n³) to O(n²)** using sorting + two pointers
- **From O(n²) space to O(1)** by avoiding hash set

---

## Pattern Comparison

| Pattern | When to Use | Time | Space | Example Problems |
|---------|-------------|------|-------|------------------|
| **Binary Search (Rotated)** | Sorted but rotated array, need O(log n) | O(log n) | O(1) | Find min, search target |
| **Two Pointers (Opposite)** | Find pairs/triplets, sorted array | O(n) or O(n²) | O(1) | Container with water, 3Sum |
| **Hash Set** | Need O(1) lookup, don't mind O(n) space | O(n) or O(n²) | O(n) | 3Sum (alternative) |

---

## Key Optimizations Learned

### 1. Binary Search on Rotated Array
**Optimization**: O(n) → O(log n)
- **Before**: Linear scan to find minimum
- **After**: Binary search by identifying sorted half
- **Key**: Compare mid with boundary to determine which half to search

### 2. Container With Most Water
**Optimization**: O(n²) → O(n)
- **Before**: Check all pairs with nested loops
- **After**: Two pointers from both ends
- **Key**: Greedy choice - move shorter pointer

### 3. 3Sum
**Optimization**: O(n³) → O(n²)
- **Before**: Three nested loops
- **After**: Sort + fix one element + two pointers
- **Key**: Convert 3Sum to 2Sum problem

---

## Common Mistakes & How to Avoid

### Binary Search on Rotated Array
❌ **Mistake**: Using `nums[mid] > nums[left]` instead of `>=`
✅ **Fix**: Use `>=` to handle single element case

❌ **Mistake**: Wrong boundary update (`left = mid` or `right = mid`)
✅ **Fix**: Use `left = mid + 1` or `right = mid` based on logic

### Two Pointers
❌ **Mistake**: Moving the taller pointer in container problem
✅ **Fix**: Always move the shorter pointer (greedy choice)

❌ **Mistake**: Not skipping duplicates in 3Sum
✅ **Fix**: Skip at three levels (i, left, right)

### General
❌ **Mistake**: Using `left <= right` when should use `left < right`
✅ **Fix**: Use `<` when converging to single element, `<=` when searching

---

## Practice Strategy

### Master These Patterns
1. **Binary Search on Rotated Array**
   - Find minimum
   - Search target
   - Find rotation count
   - With duplicates

2. **Two Pointers (Opposite Direction)**
   - Container with water
   - 3Sum
   - 4Sum
   - Trapping rain water

### Progression
1. **Understand brute force** - Know the O(n²) or O(n³) solution
2. **Identify pattern** - Recognize when to use binary search or two pointers
3. **Apply optimization** - Implement optimal solution
4. **Handle edge cases** - Duplicates, empty arrays, single elements

---

## Summary

### Day 05: Binary Search
- **Pattern**: Modified binary search on rotated arrays
- **Key**: Identify sorted half, decide which half to search
- **Optimization**: O(n) → O(log n)

### Day 06: Two Pointers
- **Pattern**: Two pointers from opposite ends
- **Key**: Greedy choice on which pointer to move
- **Optimization**: O(n²) → O(n) or O(n³) → O(n²)

### Golden Rules
1. **Rotated array + O(log n)** → Binary search
2. **Sorted array + pairs/triplets** → Two pointers
3. **Greedy choice possible** → Two pointers
4. **Always consider sorting** → Enables two pointers

**Your code demonstrates excellent understanding of both patterns!** ✅
