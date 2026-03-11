# Day 16 - Two Pointers Advanced Problems

## Problem 1: Sort Colors (Dutch National Flag)

### Problem Statement
**Input:** `nums = [2,0,2,1,1,0]`
**Output:** `[0,0,1,1,2,2]`
**Constraint:** Sort in-place, one-pass, O(1) space

**Colors:** 0 = Red, 1 = White, 2 = Blue

---

### Problem Logic

**Goal:** Partition array into 3 sections: [0s | 1s | 2s]

**Key Insight:** Use 3 pointers to maintain regions:
- `low`: boundary of 0s (everything before low is 0)
- `mid`: current element being examined
- `high`: boundary of 2s (everything after high is 2)

**Invariant:**
```
[0, 0, 0, ... | 1, 1, 1, ... | ?, ?, ? | 2, 2, 2, ...]
              ↑              ↑        ↑
             low            mid      high
```

---

### Solution Patterns

#### Pattern 1: Dutch National Flag (Optimal) ⭐

**Pseudocode:**
```
FUNCTION sortColors(nums):
    SET low = 0, mid = 0, high = n-1
    
    WHILE mid <= high:
        IF nums[mid] == 0:
            SWAP nums[low] with nums[mid]
            INCREMENT low, mid
        ELSE IF nums[mid] == 1:
            INCREMENT mid
        ELSE:  // nums[mid] == 2
            SWAP nums[mid] with nums[high]
            DECREMENT high
            // Don't increment mid (need to check swapped element)
    
    RETURN nums
```

**Code:**
```python
def sortColors(nums):
    low = 0
    mid = 0
    high = len(nums) - 1
    
    while mid <= high:
        if nums[mid] == 0:
            nums[low], nums[mid] = nums[mid], nums[low]
            low += 1
            mid += 1
        elif nums[mid] == 1:
            mid += 1
        else:  # nums[mid] == 2
            nums[mid], nums[high] = nums[high], nums[mid]
            high -= 1
```

**Complexity:**
- Time: O(n) - single pass
- Space: O(1) - in-place

---

#### Pattern 2: Counting Sort

**Pseudocode:**
```
FUNCTION sortColors(nums):
    COUNT occurrences of 0, 1, 2
    OVERWRITE array with counted values
```

**Code:**
```python
def sortColors(nums):
    count = [0, 0, 0]
    
    # Count occurrences
    for num in nums:
        count[num] += 1
    
    # Overwrite array
    idx = 0
    for color in range(3):
        for _ in range(count[color]):
            nums[idx] = color
            idx += 1
```

**Complexity:**
- Time: O(n) - two passes
- Space: O(1) - fixed size array

---

#### Pattern 3: Separate Lists (Not Optimal)

**Code:**
```python
def sortColors(nums):
    zeros = []
    ones = []
    twos = []
    
    for num in nums:
        if num == 0:
            zeros.append(num)
        elif num == 1:
            ones.append(num)
        else:
            twos.append(num)
    
    return zeros + ones + twos
```

**Complexity:**
- Time: O(n)
- Space: O(n) - extra arrays

---

### Flow Diagram (Dutch National Flag)

```
Start: [2, 0, 2, 1, 1, 0]
       low=0, mid=0, high=5

Step 1: nums[mid]=2
        Swap with high
        [0, 0, 2, 1, 1, 2]
        low=0, mid=0, high=4

Step 2: nums[mid]=0
        Swap with low
        [0, 0, 2, 1, 1, 2]
        low=1, mid=1, high=4

Step 3: nums[mid]=0
        Swap with low
        [0, 0, 2, 1, 1, 2]
        low=2, mid=2, high=4

Step 4: nums[mid]=2
        Swap with high
        [0, 0, 1, 1, 2, 2]
        low=2, mid=2, high=3

Step 5: nums[mid]=1
        Just move mid
        low=2, mid=3, high=3

Step 6: nums[mid]=1
        Just move mid
        low=2, mid=4, high=3

mid > high → STOP
Result: [0, 0, 1, 1, 2, 2]
```

---

### Visual Explanation

```
Initial: [2, 0, 2, 1, 1, 0]
          ↑     ↑        ↑
         low   mid     high

Process:
- If 0: swap with low, move both
- If 1: just move mid
- If 2: swap with high, move high only

Final: [0, 0, 1, 1, 2, 2]
```

---

## Problem 2: Trap Rain Water

### Problem Statement
**Input:** `height = [0,1,0,2,1,0,1,3,2,1,2,1]`
**Output:** `6` (units of water trapped)

**Visual:**
```
               █
   █   █       █ █   █
   █   █ █   █ █ █ █ █ █
[0,1,0,2,1,0,1,3,2,1,2,1]
```

---

### Problem Logic

**Key Insight:** Water at position i = min(max_left, max_right) - height[i]

**Why?**
- Water level limited by shorter wall
- Can only trap water if there are taller walls on both sides

**Formula:**
```
water[i] = min(leftMax, rightMax) - height[i]
```

---

### Solution Patterns

#### Pattern 1: Two Pointers (Optimal) ⭐

**Pseudocode:**
```
FUNCTION trap(height):
    SET left = 0, right = n-1
    SET leftMax = 0, rightMax = 0
    SET water = 0
    
    WHILE left < right:
        IF height[left] < height[right]:
            IF height[left] >= leftMax:
                UPDATE leftMax = height[left]
            ELSE:
                ADD water = leftMax - height[left]
            INCREMENT left
        ELSE:
            IF height[right] >= rightMax:
                UPDATE rightMax = height[right]
            ELSE:
                ADD water = rightMax - height[right]
            DECREMENT right
    
    RETURN water
```

**Code:**
```python
def trap(height):
    if not height:
        return 0
    
    left, right = 0, len(height) - 1
    leftMax, rightMax = 0, 0
    water = 0
    
    while left < right:
        if height[left] < height[right]:
            if height[left] >= leftMax:
                leftMax = height[left]
            else:
                water += leftMax - height[left]
            left += 1
        else:
            if height[right] >= rightMax:
                rightMax = height[right]
            else:
                water += rightMax - height[right]
            right -= 1
    
    return water
```

**Complexity:**
- Time: O(n) - single pass
- Space: O(1) - constant space

---

#### Pattern 2: Precompute Max Arrays

**Pseudocode:**
```
FUNCTION trap(height):
    CREATE leftMax array
    CREATE rightMax array
    
    // Fill leftMax
    FOR i from 0 to n-1:
        leftMax[i] = max of all elements from 0 to i
    
    // Fill rightMax
    FOR i from n-1 to 0:
        rightMax[i] = max of all elements from i to n-1
    
    // Calculate water
    FOR i from 0 to n-1:
        water += min(leftMax[i], rightMax[i]) - height[i]
    
    RETURN water
```

**Code:**
```python
def trap(height):
    n = len(height)
    if n == 0:
        return 0
    
    leftMax = [0] * n
    rightMax = [0] * n
    
    # Fill leftMax
    leftMax[0] = height[0]
    for i in range(1, n):
        leftMax[i] = max(leftMax[i-1], height[i])
    
    # Fill rightMax
    rightMax[n-1] = height[n-1]
    for i in range(n-2, -1, -1):
        rightMax[i] = max(rightMax[i+1], height[i])
    
    # Calculate water
    water = 0
    for i in range(n):
        water += min(leftMax[i], rightMax[i]) - height[i]
    
    return water
```

**Complexity:**
- Time: O(n) - three passes
- Space: O(n) - two arrays

---

#### Pattern 3: Brute Force (Not Optimal)

**Code:**
```python
def trap(height):
    n = len(height)
    water = 0
    
    for i in range(1, n-1):
        # Find max on left
        leftMax = max(height[:i+1])
        
        # Find max on right
        rightMax = max(height[i:])
        
        # Add water at position i
        water += min(leftMax, rightMax) - height[i]
    
    return water
```

**Complexity:**
- Time: O(n²) - nested loops
- Space: O(1)

---

### Flow Diagram (Two Pointers)

```
height = [0,1,0,2,1,0,1,3,2,1,2,1]

Initial:
left=0, right=11
leftMax=0, rightMax=0
water=0

Step 1: height[0]=0 < height[11]=1
        leftMax=0, water=0
        left=1

Step 2: height[1]=1 < height[11]=1
        leftMax=1, water=0
        left=2

Step 3: height[2]=0 < height[11]=1
        water += 1-0 = 1
        left=3

Step 4: height[3]=2 > height[11]=1
        rightMax=1, water=1
        right=10

... continue until left >= right

Final: water = 6
```

---

### Visual Step-by-Step

```
Position: 0  1  2  3  4  5  6  7  8  9  10 11
Height:   0  1  0  2  1  0  1  3  2  1  2  1

At position 2:
  leftMax = 1 (from position 1)
  rightMax = 3 (from position 7)
  water = min(1,3) - 0 = 1

At position 4:
  leftMax = 2
  rightMax = 3
  water = min(2,3) - 1 = 1

At position 5:
  leftMax = 2
  rightMax = 3
  water = min(2,3) - 0 = 2

Total: 1 + 1 + 2 + ... = 6
```

---

## Comparison Table

### Sort Colors

| Approach | Time | Space | Passes | Best For |
|----------|------|-------|--------|----------|
| Dutch Flag | O(n) | O(1) | 1 | **Optimal** |
| Counting Sort | O(n) | O(1) | 2 | Simple logic |
| Separate Lists | O(n) | O(n) | 1 | Not in-place |

### Trap Rain Water

| Approach | Time | Space | Passes | Best For |
|----------|------|-------|--------|----------|
| Two Pointers | O(n) | O(1) | 1 | **Optimal** |
| Precompute Arrays | O(n) | O(n) | 3 | Easier to understand |
| Brute Force | O(n²) | O(1) | n | Small inputs |

---

## Key Patterns Summary

### Pattern 1: Three-Way Partitioning (Dutch Flag)
**Use for:** Sorting with 3 distinct values
**Template:**
```python
low, mid, high = 0, 0, n-1
while mid <= high:
    if condition1:
        swap(low, mid)
        low += 1
        mid += 1
    elif condition2:
        mid += 1
    else:
        swap(mid, high)
        high -= 1
```

### Pattern 2: Two Pointers with Max Tracking
**Use for:** Problems requiring left/right max values
**Template:**
```python
left, right = 0, n-1
leftMax, rightMax = 0, 0
while left < right:
    if height[left] < height[right]:
        # Process left
        left += 1
    else:
        # Process right
        right -= 1
```

---

## Common Mistakes

### Sort Colors:
1. **Incrementing mid after swapping with high** - Wrong! Need to check swapped element
2. **Wrong loop condition** - Use `mid <= high`, not `mid < high`
3. **Not handling all three cases** - Must handle 0, 1, and 2

### Trap Rain Water:
1. **Forgetting edge cases** - Empty array, single element
2. **Wrong water calculation** - Must subtract current height
3. **Not updating max values** - Update before calculating water

---

## Edge Cases

### Sort Colors:
```python
[0]           → [0]           # Single element
[2,1,0]       → [0,1,2]       # Reverse sorted
[0,0,0]       → [0,0,0]       # All same
[1,1,1,1]     → [1,1,1,1]     # All middle value
```

### Trap Rain Water:
```python
[]            → 0              # Empty
[3]           → 0              # Single bar
[3,0,0,2]     → 4              # Valley
[0,1,0,2,1,0,1,3,2,1,2,1] → 6 # Complex
```

---

## Best Practices

1. **Sort Colors:**
   - Use Dutch National Flag for optimal solution
   - Remember: don't increment mid when swapping with high
   - Maintain invariant: [0s | 1s | unknown | 2s]

2. **Trap Rain Water:**
   - Two pointers is most space-efficient
   - Always move pointer with smaller height
   - Update max before calculating water

---

## Quick Reference

### Sort Colors (Dutch Flag):
```
1. Initialize: low=0, mid=0, high=n-1
2. While mid <= high:
   - If 0: swap(low,mid), low++, mid++
   - If 1: mid++
   - If 2: swap(mid,high), high--
```

### Trap Rain Water (Two Pointers):
```
1. Initialize: left=0, right=n-1, leftMax=0, rightMax=0
2. While left < right:
   - If height[left] < height[right]:
     - Update leftMax or add water
     - left++
   - Else:
     - Update rightMax or add water
     - right--
```

---

## Key Takeaways

1. **Dutch National Flag** is the standard for 3-way partitioning
2. **Two pointers** with max tracking solves water trapping optimally
3. **Space optimization** often comes from clever pointer manipulation
4. **Invariants** help maintain correctness (especially in Dutch Flag)
5. **Draw diagrams** to visualize water levels and partitions
