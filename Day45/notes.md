# Day 45: Majority Element & 3Sum Closest

## Problem 1: Majority Element

### Problem Statement
**LeetCode 169: Majority Element**

Given an array nums of size n, return the majority element.

The majority element is the element that appears more than ⌊n / 2⌋ times. You may assume that the majority element always exists in the array.

**Examples:**
```
Input: nums = [3,2,3]
Output: 3

Input: nums = [2,2,1,1,1,2,2]
Output: 2
```

**Constraints:**
- n == nums.length
- 1 <= n <= 5 × 10⁴
- -10⁹ <= nums[i] <= 10⁹
- The majority element always exists

**Follow-up:** Could you solve the problem in linear time and in O(1) space?

---

### Problem Logic & Reasoning

#### Core Concept
The majority element appears **more than n/2 times**, meaning it appears more than all other elements combined!

**Key Insight:** If we cancel out each occurrence of the majority element with a different element, the majority element will still remain.

#### Visual Understanding for [2,2,1,1,1,2,2]

```
Array: [2, 2, 1, 1, 1, 2, 2]
Count:  2  2  1  1  1  2  2

Majority element: 2 (appears 4 times out of 7)
4 > 7/2 = 3.5 ✓
```

---

### Approach 1: HashMap (Counter) - O(n) time, O(n) space

#### Logic
Count frequency of each element and return the one with count > n/2.

#### Pseudocode
```
function majorityElement(nums):
    count = Counter(nums)
    half = len(nums) / 2
    
    for num in nums:
        if count[num] > half:
            return num
```

#### Complexity
- **Time:** O(n) - Single pass
- **Space:** O(n) - HashMap storage

---

### Approach 2: Sorting - O(n log n) time, O(1) space

#### Logic
After sorting, the majority element will always be at index n/2.

#### Why This Works
```
Array: [2,2,1,1,1,2,2]
Sorted: [1,1,1,2,2,2,2]
         0 1 2 3 4 5 6
              ↑
           n//2 = 3

Since majority element appears > n/2 times,
it MUST occupy the middle position!
```

#### Visual Proof
```
Case 1: Majority at start
[2,2,2,2,1,1,1] → index 3 = 2 ✓

Case 2: Majority at end
[1,1,1,2,2,2,2] → index 3 = 2 ✓

Case 3: Majority in middle
[1,2,2,2,2,2,3] → index 3 = 2 ✓
```

#### Pseudocode
```
function majorityElement(nums):
    nums.sort()
    return nums[len(nums) // 2]
```

#### Complexity
- **Time:** O(n log n) - Sorting
- **Space:** O(1) - In-place sorting

---

### Approach 3: Boyer-Moore Voting Algorithm ⭐⭐⭐ - O(n) time, O(1) space

#### Logic
Maintain a candidate and count:
1. If count = 0, set current element as candidate
2. If element = candidate, increment count
3. If element ≠ candidate, decrement count
4. The surviving candidate is the majority element

#### Why This Works
Think of it as a **battle**: each occurrence of the majority element fights with one occurrence of any other element. Since majority > n/2, it will always win!

#### Visual Flow for [2,2,1,1,1,2,2]

```
Initial: candidate=2, count=1

i=1, num=2:
    2 == 2 → count++ → count=2
    State: candidate=2, count=2

i=2, num=1:
    1 != 2 → count-- → count=1
    State: candidate=2, count=1

i=3, num=1:
    1 != 2 → count-- → count=0
    State: candidate=2, count=0

i=4, num=1:
    count=0 → candidate=1, count=1
    State: candidate=1, count=1

i=5, num=2:
    2 != 1 → count-- → count=0
    State: candidate=1, count=0

i=6, num=2:
    count=0 → candidate=2, count=1
    State: candidate=2, count=1

Result: 2
```

#### Battle Analogy
```
[2, 2, 1, 1, 1, 2, 2]

2 vs nothing → 2 wins (count=1)
2 vs nothing → 2 wins (count=2)
2 vs 1 → cancel (count=1)
2 vs 1 → cancel (count=0)
1 vs nothing → 1 wins (count=1)
1 vs 2 → cancel (count=0)
2 vs nothing → 2 wins (count=1)

Winner: 2
```

#### Pseudocode
```
function majorityElement(nums):
    candidate = nums[0]
    count = 1
    
    for i from 1 to len(nums)-1:
        if nums[i] == candidate:
            count += 1
        else:
            count -= 1
        
        if count == 0:
            candidate = nums[i]
            count = 1
    
    return candidate
```

#### Complexity
- **Time:** O(n) - Single pass
- **Space:** O(1) - Only two variables ⭐

---

### Approach Comparison (Majority Element)

| Aspect | HashMap | Sorting | Boyer-Moore |
|--------|---------|---------|-------------|
| **Time** | O(n) | O(n log n) | O(n) |
| **Space** | O(n) | O(1) | O(1) ⭐ |
| **Intuition** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Best For** | Understanding | Simple solution | Optimal |

---

## Problem 2: 3Sum Closest

### Problem Statement
**LeetCode 16: 3Sum Closest**

Given an integer array nums of length n and an integer target, find three integers in nums such that the sum is closest to target.

Return the sum of the three integers.

**Examples:**
```
Input: nums = [-1,2,1,-4], target = 1
Output: 2
Explanation: The sum closest to target is 2. (-1 + 2 + 1 = 2)

Input: nums = [0,0,0], target = 1
Output: 0
```

**Constraints:**
- 3 <= nums.length <= 500
- -1000 <= nums[i] <= 1000
- -10⁴ <= target <= 10⁴

---

### Problem Logic & Reasoning

#### Core Concept
Similar to 3Sum, but instead of finding exact sum, find the **closest** sum to target.

**Key Insight:** Sort the array and use two pointers to efficiently explore all triplets.

#### Visual Understanding for [-1,2,1,-4], target=1

```
Sorted: [-4, -1, 1, 2]

Try all combinations:
-4 + -1 + 1 = -4 (distance: 5)
-4 + -1 + 2 = -3 (distance: 4)
-4 + 1 + 2 = -1 (distance: 2)
-1 + 1 + 2 = 2 (distance: 1) ← Closest!

Result: 2
```

---

### Approach: Two Pointers ⭐

#### Logic
1. Sort the array
2. For each element i, use two pointers (left, right) to find best pair
3. Track the closest sum seen so far
4. Move pointers based on whether sum is too small or too large

#### Visual Flow for [-1,2,1,-4], target=1

```
Sorted: [-4, -1, 1, 2]
         0   1  2  3

i=0 (nums[0]=-4):
    left=1, right=3
    sum = -4 + -1 + 2 = -3
    distance = |−3 − 1| = 4
    closest = -3
    sum < target → left++

    left=2, right=3
    sum = -4 + 1 + 2 = -1
    distance = |−1 − 1| = 2
    closest = -1 (better!)
    sum < target → left++

i=1 (nums[1]=-1):
    left=2, right=3
    sum = -1 + 1 + 2 = 2
    distance = |2 − 1| = 1
    closest = 2 (better!)
    sum > target → right--

i=2: left=3, right=3 (skip)

Result: 2
```

#### Step-by-Step Execution

```
nums = [-1,2,1,-4], target = 1
Sorted: [-4,-1,1,2]
closest = infinity

Outer loop i=0, nums[i]=-4:
    left=1, right=3
    
    Iteration 1:
        sum = -4 + (-1) + 2 = -3
        |-3 - 1| = 4 < |inf - 1| → closest = -3
        -3 < 1 → left = 2
    
    Iteration 2:
        sum = -4 + 1 + 2 = -1
        |-1 - 1| = 2 < |-3 - 1| = 4 → closest = -1
        -1 < 1 → left = 3 (exit)

Outer loop i=1, nums[i]=-1:
    left=2, right=3
    
    Iteration 1:
        sum = -1 + 1 + 2 = 2
        |2 - 1| = 1 < |-1 - 1| = 2 → closest = 2
        2 > 1 → right = 2 (exit)

Result: 2
```

#### Pseudocode
```
function threeSumClosest(nums, target):
    nums.sort()
    closest = infinity
    
    for i from 0 to len(nums)-3:
        left = i + 1
        right = len(nums) - 1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if current_sum == target:
                return current_sum
            
            if abs(current_sum - target) < abs(closest - target):
                closest = current_sum
            
            if current_sum < target:
                left += 1
            else:
                right -= 1
    
    return closest
```

#### Complexity
- **Time:** O(n²) - O(n log n) sort + O(n²) two pointers
- **Space:** O(1) - Only variables (ignoring sort space)

---

### Optimizations

#### Optimization 1: Skip Duplicates
```python
if i > 0 and nums[i] == nums[i-1]:
    continue
```

#### Optimization 2: Early Termination (Min Sum)
```python
# If minimum possible sum > target, no need to continue
min_sum = nums[i] + nums[i+1] + nums[i+2]
if min_sum > target:
    if min_sum - target < abs(closest - target):
        closest = min_sum
    break
```

#### Optimization 3: Skip Iteration (Max Sum)
```python
# If maximum possible sum < target, skip this i
max_sum = nums[i] + nums[-2] + nums[-1]
if max_sum < target:
    if target - max_sum < abs(closest - target):
        closest = max_sum
    continue
```

---

### Critical Insights

#### Majority Element

**1. Why Boyer-Moore Works**
```
Majority element appears > n/2 times
All other elements combined < n/2 times

In the "battle", majority will always survive!
```

**2. Why Sorting Works**
```
If element appears > n/2 times,
it MUST occupy the middle position after sorting.
```

**3. Edge Case: Single Element**
```
nums = [1]
Majority = 1 (appears 1 time > 1/2)
```

#### 3Sum Closest

**1. Why Sort First?**
```
Sorting enables two-pointer technique:
- If sum too small → increase (move left++)
- If sum too large → decrease (move right--)
```

**2. Distance Calculation**
```
Use abs(current_sum - target) to measure closeness
Smaller distance = closer to target
```

**3. Early Return on Exact Match**
```
if current_sum == target:
    return current_sum  // Can't get closer!
```

---

### Common Mistakes

#### Majority Element

**❌ Mistake 1: Wrong Threshold**
```python
if count[num] >= len(nums) / 2:  # Wrong! Should be >
```

**❌ Mistake 2: Not Resetting Count**
```python
if count < 0:
    candidate = nums[i]
    # Missing: count = 1
```

#### 3Sum Closest

**❌ Mistake 1: Not Sorting**
```python
# Two pointers won't work on unsorted array
```

**❌ Mistake 2: Wrong Distance Comparison**
```python
if current_sum - target < closest - target:  # Wrong! Need abs()
```

**❌ Mistake 3: Off-by-One in Loop**
```python
for i in range(len(nums)):  # Wrong! Should be len(nums)-2
```

---

### Complete Implementations

#### Majority Element - Boyer-Moore ⭐
```python
def majorityElement(nums: List[int]) -> int:
    candidate = nums[0]
    count = 1
    
    for i in range(1, len(nums)):
        if nums[i] == candidate:
            count += 1
        else:
            count -= 1
        
        if count == 0:
            candidate = nums[i]
            count = 1
    
    return candidate
```

#### Majority Element - Sorting
```python
def majorityElement(nums: List[int]) -> int:
    nums.sort()
    return nums[len(nums) // 2]
```

#### 3Sum Closest - Basic
```python
def threeSumClosest(nums: List[int], target: int) -> int:
    nums.sort()
    closest = float('inf')
    
    for i in range(len(nums) - 2):
        left = i + 1
        right = len(nums) - 1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if current_sum == target:
                return current_sum
            
            if abs(current_sum - target) < abs(closest - target):
                closest = current_sum
            
            if current_sum < target:
                left += 1
            else:
                right -= 1
    
    return closest
```

#### 3Sum Closest - Optimized
```python
def threeSumClosest(nums: List[int], target: int) -> int:
    nums.sort()
    closest = float('inf')
    n = len(nums)
    
    for i in range(n - 2):
        # Skip duplicates
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        # Optimization 1: Min sum check
        min_sum = nums[i] + nums[i+1] + nums[i+2]
        if min_sum > target:
            if min_sum - target < abs(closest - target):
                closest = min_sum
            break
        
        # Optimization 2: Max sum check
        max_sum = nums[i] + nums[-2] + nums[-1]
        if max_sum < target:
            if target - max_sum < abs(closest - target):
                closest = max_sum
            continue
        
        left = i + 1
        right = n - 1
        
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            
            if current_sum == target:
                return target
            
            if abs(current_sum - target) < abs(closest - target):
                closest = current_sum
            
            if current_sum < target:
                left += 1
            else:
                right -= 1
    
    return closest
```

---

## Day 45 Summary

### Problems Solved: 2
1. ✅ Majority Element
2. ✅ 3Sum Closest

### Key Patterns Learned:
1. **Boyer-Moore Voting Algorithm** - O(1) space majority finding
2. **Two Pointers on Sorted Array** - Efficient triplet search
3. **Cancellation Strategy** - Pairing elements to find majority

### Techniques Mastered:
- Voting algorithm for majority element
- Sorting + two pointers for 3Sum variants
- Distance minimization tracking
- Early termination optimizations

### Complexity Insights:
- Boyer-Moore: O(n) time, O(1) space (optimal!)
- 3Sum Closest: O(n²) time, O(1) space
- Sorting enables efficient two-pointer search

### When to Use These Patterns:
- Majority element: When element appears > n/2 times
- Two pointers: Sorted array with sum/difference problems
- Voting algorithm: Finding dominant element with O(1) space

---

## Quick Reference

### Boyer-Moore Template
```python
candidate = nums[0]
count = 1

for i in range(1, len(nums)):
    if nums[i] == candidate:
        count += 1
    else:
        count -= 1
    
    if count == 0:
        candidate = nums[i]
        count = 1

return candidate
```

### Two Pointers (3Sum) Template
```python
nums.sort()
result = initial_value

for i in range(len(nums) - 2):
    left = i + 1
    right = len(nums) - 1
    
    while left < right:
        current = compute(nums[i], nums[left], nums[right])
        update_result(current)
        
        if condition:
            left += 1
        else:
            right -= 1

return result
```
