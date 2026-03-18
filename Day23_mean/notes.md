# Day 23: Median of Two Sorted Arrays

## Problem: Median of Two Sorted Arrays (Hard)

### Problem Statement
Given two sorted arrays `nums1` and `nums2`, return the median of the combined sorted arrays.

**Constraint**: Must achieve O(log(m+n)) time complexity.

### Problem Logic
**Median Definition**:
- Odd length: Middle element
- Even length: Average of two middle elements

**Challenge**: Find median WITHOUT actually merging arrays (to achieve log time).

---

## Approach 1: Merge and Sort (Brute Force)

### Pseudocode
```
FIND_MEDIAN_BRUTE(nums1, nums2):
    merged = nums1 + nums2
    merged.sort()
    n = len(merged)
    
    if n is odd:
        return merged[n // 2]
    else:
        return (merged[n // 2 - 1] + merged[n // 2]) / 2
```

### Visual Flow
```
Example: nums1 = [1,2], nums2 = [3,4]

Step 1: Merge
merged = [1, 2, 3, 4]

Step 2: Find median
length = 4 (even)
median = (merged[1] + merged[2]) / 2
       = (2 + 3) / 2
       = 2.5
```

### Complexity
- **Time**: O((m+n) log(m+n)) - sorting dominates
- **Space**: O(m+n) - merged array
- **Issue**: Does NOT meet O(log(m+n)) requirement ✗

---

## Approach 2: Two Pointers Merge

### Problem Logic
Merge arrays using two pointers until reaching median position. Don't need full merge, just up to middle.

### Pseudocode
```
FIND_MEDIAN_TWO_POINTERS(nums1, nums2):
    m, n = len(nums1), len(nums2)
    p1, p2 = 0, 0
    
    GET_MIN():
        if p1 < m and p2 < n:
            if nums1[p1] < nums2[p2]:
                val = nums1[p1]
                p1++
            else:
                val = nums2[p2]
                p2++
        elif p1 == m:
            val = nums2[p2]
            p2++
        else:
            val = nums1[p1]
            p1++
        return val
    
    total = m + n
    if total is odd:
        # Skip to middle
        for i in range(total // 2):
            GET_MIN()
        return GET_MIN()
    else:
        # Skip to two middle elements
        for i in range(total // 2 - 1):
            GET_MIN()
        return (GET_MIN() + GET_MIN()) / 2
```

### Visual Flow
```
Example: nums1 = [1,3], nums2 = [2]

Step 1: Initialize
nums1: [1, 3]    p1 = 0
nums2: [2]       p2 = 0
total = 3 (odd), median at index 1

Step 2: Skip to median
i=0: get_min() → 1 (p1=1)

Step 3: Get median
get_min() → 2 (p2=1)

Result: 2
```

### Complexity
- **Time**: O(m+n) - traverse to middle
- **Space**: O(1) - only pointers
- **Issue**: Still does NOT meet O(log(m+n)) requirement ✗

---

## Approach 3: Binary Search on Partition ⭐

### Core Insight
**Partition Strategy**: 
- Divide combined array into two halves of equal size
- Use binary search to find correct partition point
- Median is at partition boundary

**Key Idea**: 
- Partition smaller array (binary search on it)
- Calculate corresponding partition in larger array
- Check if partition is valid

### Partition Validity
```
Valid partition when:
left1 ≤ right2  AND  left2 ≤ right1

nums1: [... left1 | right1 ...]
nums2: [... left2 | right2 ...]
       \_________/   \_________/
        Left half    Right half
```

### Pseudocode
```
FIND_MEDIAN_BINARY_SEARCH(nums1, nums2):
    # Ensure nums1 is smaller (optimize binary search)
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1
    
    m, n = len(nums1), len(nums2)
    half = (m + n + 1) // 2
    
    lo, hi = 0, m
    
    while lo <= hi:
        i = (lo + hi) // 2      # partition in nums1
        j = half - i             # partition in nums2
        
        # Get boundary values
        left1  = nums1[i-1] if i > 0 else -∞
        right1 = nums1[i]   if i < m else +∞
        left2  = nums2[j-1] if j > 0 else -∞
        right2 = nums2[j]   if j < n else +∞
        
        # Check if valid partition
        if left1 <= right2 and left2 <= right1:
            # Found correct partition
            if (m + n) is odd:
                return max(left1, left2)
            else:
                return (max(left1, left2) + min(right1, right2)) / 2
        
        elif left1 > right2:
            # Too many elements from nums1, move left
            hi = i - 1
        else:
            # Too few elements from nums1, move right
            lo = i + 1
```

### Visual Flow
```
Example: nums1 = [1,3], nums2 = [2,4,5]

Step 1: Setup
nums1: [1, 3]        m = 2
nums2: [2, 4, 5]     n = 3
half = (2 + 3 + 1) // 2 = 3
lo = 0, hi = 2

Step 2: Binary Search
Iteration 1:
i = (0 + 2) // 2 = 1
j = 3 - 1 = 2

Partition:
nums1: [1 | 3]       left1=1, right1=3
nums2: [2, 4 | 5]    left2=4, right2=5

Check: left1 ≤ right2? 1 ≤ 5 ✓
       left2 ≤ right1? 4 ≤ 3 ✗

left2 > right1 → Need more from nums1
lo = i + 1 = 2

Iteration 2:
i = (2 + 2) // 2 = 2
j = 3 - 2 = 1

Partition:
nums1: [1, 3 |]      left1=3, right1=+∞
nums2: [2 | 4, 5]    left2=2, right2=4

Check: left1 ≤ right2? 3 ≤ 4 ✓
       left2 ≤ right1? 2 ≤ +∞ ✓

Valid partition found!
Total = 5 (odd)
Median = max(left1, left2) = max(3, 2) = 3
```

### Detailed Example (Even Length)
```
Example: nums1 = [1,2], nums2 = [3,4]

Step 1: Setup
nums1: [1, 2]        m = 2
nums2: [3, 4]        n = 2
half = (2 + 2 + 1) // 2 = 2
lo = 0, hi = 2

Step 2: Binary Search
Iteration 1:
i = (0 + 2) // 2 = 1
j = 2 - 1 = 1

Partition:
nums1: [1 | 2]       left1=1, right1=2
nums2: [3 | 4]       left2=3, right2=4

Check: left1 ≤ right2? 1 ≤ 4 ✓
       left2 ≤ right1? 3 ≤ 2 ✗

left2 > right1 → Need more from nums1
lo = i + 1 = 2

Iteration 2:
i = (2 + 2) // 2 = 2
j = 2 - 2 = 0

Partition:
nums1: [1, 2 |]      left1=2, right1=+∞
nums2: [| 3, 4]      left2=-∞, right2=3

Check: left1 ≤ right2? 2 ≤ 3 ✓
       left2 ≤ right1? -∞ ≤ +∞ ✓

Valid partition found!
Total = 4 (even)
Median = (max(left1, left2) + min(right1, right2)) / 2
       = (max(2, -∞) + min(+∞, 3)) / 2
       = (2 + 3) / 2
       = 2.5
```

### Why Binary Search on Smaller Array?
```
nums1 (size m): Binary search space = m
nums2 (size n): Partition calculated from nums1

If m < n:
- Binary search iterations = log(m)
- Faster than log(n)

Example:
nums1 = [1,2]        (m=2, log(2)=1)
nums2 = [3,4,5,6,7]  (n=5, log(5)≈2.3)

Search on nums1 → 1 iteration
Search on nums2 → 3 iterations
```

### Partition Calculation
```
Why j = half - i?

Total elements = m + n
Left half size = (m + n + 1) // 2

If we take i elements from nums1:
We need (half - i) elements from nums2

Example: m=2, n=3, half=3
If i=1 (take 1 from nums1):
   j=3-1=2 (take 2 from nums2)
   Total in left = 1 + 2 = 3 ✓
```

### Complexity
- **Time**: O(log(min(m, n))) - binary search on smaller array
- **Space**: O(1) - only variables
- **Meets requirement**: ✓ O(log(m+n))

---

## Approach Comparison

| Approach | Time | Space | Meets Requirement | Notes |
|----------|------|-------|-------------------|-------|
| **Merge & Sort** | O((m+n)log(m+n)) | O(m+n) | ✗ | Simple but slow |
| **Two Pointers** | O(m+n) | O(1) | ✗ | Better but still linear |
| **Binary Search** ⭐ | O(log(min(m,n))) | O(1) | ✓ | Optimal solution |

---

## Critical Insights

### 1. Median Properties
```
Odd length array [1,2,3,4,5]:
- Median = arr[n//2] = arr[2] = 3

Even length array [1,2,3,4]:
- Median = (arr[n//2-1] + arr[n//2]) / 2
         = (arr[1] + arr[2]) / 2
         = (2 + 3) / 2 = 2.5
```

### 2. Partition Concept
```
Combined sorted: [1, 2, 3, 4, 5]
                     ↑
                  Partition

Left half:  [1, 2]     (smaller or equal)
Right half: [3, 4, 5]  (larger or equal)

For valid partition:
max(left) ≤ min(right)
```

### 3. Why +1 in half calculation?
```
half = (m + n + 1) // 2

Odd length (m+n=5):
half = (5 + 1) // 2 = 3
Left: 3 elements, Right: 2 elements ✓

Even length (m+n=4):
half = (4 + 1) // 2 = 2
Left: 2 elements, Right: 2 elements ✓

Without +1 for odd:
half = 5 // 2 = 2
Left: 2 elements, Right: 3 elements ✗
```

### 4. Infinity Handling
```
Why use -∞ and +∞?

When partition is at boundary:
i = 0: No elements from nums1 left side
       left1 = -∞ (always ≤ any right2)

i = m: All elements from nums1 in left side
       right1 = +∞ (always ≥ any left2)

Avoids special case handling!
```

---

## Step-by-Step Algorithm

### Step 1: Ensure nums1 is Smaller
```python
if len(nums1) > len(nums2):
    nums1, nums2 = nums2, nums1
```
**Why**: Minimize binary search iterations

### Step 2: Calculate Half Size
```python
half = (m + n + 1) // 2
```
**Why**: Number of elements in left partition

### Step 3: Binary Search on nums1
```python
lo, hi = 0, m
while lo <= hi:
    i = (lo + hi) // 2  # partition index in nums1
    j = half - i         # partition index in nums2
```
**Why**: Find correct partition point

### Step 4: Get Boundary Values
```python
left1  = nums1[i-1] if i > 0 else -∞
right1 = nums1[i]   if i < m else +∞
left2  = nums2[j-1] if j > 0 else -∞
right2 = nums2[j]   if j < n else +∞
```
**Why**: Elements at partition boundaries

### Step 5: Check Partition Validity
```python
if left1 ≤ right2 and left2 ≤ right1:
    # Valid partition found
    if (m + n) % 2 == 1:
        return max(left1, left2)
    else:
        return (max(left1, left2) + min(right1, right2)) / 2
```
**Why**: Median is at partition boundary

### Step 6: Adjust Search Range
```python
elif left1 > right2:
    hi = i - 1  # Too many from nums1
else:
    lo = i + 1  # Too few from nums1
```
**Why**: Binary search adjustment

---

## Partition Examples

### Example 1: Odd Total Length
```
nums1 = [1, 3, 8]     m = 3
nums2 = [7, 9, 10, 11] n = 4
total = 7 (odd), half = 4

Correct partition (i=2, j=2):
nums1: [1, 3 | 8]        left1=3, right1=8
nums2: [7, 9 | 10, 11]   left2=9, right2=10

Check: 3 ≤ 10 ✓, 9 ≤ 8 ✗ (invalid)

Try i=1, j=3:
nums1: [1 | 3, 8]        left1=1, right1=3
nums2: [7, 9, 10 | 11]   left2=10, right2=11

Check: 1 ≤ 11 ✓, 10 ≤ 3 ✗ (invalid)

Try i=3, j=1:
nums1: [1, 3, 8 |]       left1=8, right1=+∞
nums2: [7 | 9, 10, 11]   left2=7, right2=9

Check: 8 ≤ 9 ✓, 7 ≤ +∞ ✓ (valid!)

Merged view: [1, 3, 7, 8 | 9, 10, 11]
Median = max(8, 7) = 8
```

### Example 2: Even Total Length
```
nums1 = [1, 2]    m = 2
nums2 = [3, 4]    n = 2
total = 4 (even), half = 2

Try i=1, j=1:
nums1: [1 | 2]       left1=1, right1=2
nums2: [3 | 4]       left2=3, right2=4

Check: 1 ≤ 4 ✓, 3 ≤ 2 ✗ (invalid)
left2 > right1 → Need more from nums1

Try i=2, j=0:
nums1: [1, 2 |]      left1=2, right1=+∞
nums2: [| 3, 4]      left2=-∞, right2=3

Check: 2 ≤ 3 ✓, -∞ ≤ +∞ ✓ (valid!)

Merged view: [1, 2 | 3, 4]
Median = (max(2, -∞) + min(+∞, 3)) / 2
       = (2 + 3) / 2
       = 2.5
```

---

## Decision Tree

```
findMedianSortedArrays(nums1, nums2)
    │
    ├─ Ensure nums1 is smaller
    │
    ├─ Calculate half = (m + n + 1) // 2
    │
    └─ Binary Search on nums1
        │
        ├─ Calculate partition: i, j = half - i
        │
        ├─ Get boundaries: left1, right1, left2, right2
        │
        └─ Check validity
            │
            ├─ Valid (left1 ≤ right2 AND left2 ≤ right1)
            │   │
            │   ├─ Odd total → max(left1, left2)
            │   └─ Even total → (max(left1, left2) + min(right1, right2)) / 2
            │
            ├─ left1 > right2 → hi = i - 1
            │
            └─ left2 > right1 → lo = i + 1
```

---

## Common Mistakes

1. ❌ **Not swapping arrays**: Binary search on larger array is slower
2. ❌ **Wrong half calculation**: Forgetting +1 causes issues with odd length
3. ❌ **Index out of bounds**: Not handling i=0 or i=m cases
4. ❌ **Wrong median formula**: Confusing odd/even cases
5. ❌ **Partition check logic**: Incorrect inequality checks

---

## Edge Cases

### Case 1: One Array Empty
```
nums1 = []
nums2 = [1, 2, 3]

i = 0 (no elements from nums1)
j = 2 (take 2 from nums2)

Partition:
nums1: [|]           left1=-∞, right1=+∞
nums2: [1, 2 | 3]    left2=2, right2=3

Median = max(-∞, 2) = 2
```

### Case 2: All Elements from One Array in Left
```
nums1 = [1, 2]
nums2 = [3, 4]

i = 2 (all from nums1)
j = 0 (none from nums2)

Partition:
nums1: [1, 2 |]      left1=2, right1=+∞
nums2: [| 3, 4]      left2=-∞, right2=3

Median = (max(2, -∞) + min(+∞, 3)) / 2 = 2.5
```

### Case 3: Single Element Arrays
```
nums1 = [1]
nums2 = [2]

i = 1, j = 0

Partition:
nums1: [1 |]         left1=1, right1=+∞
nums2: [| 2]         left2=-∞, right2=2

Median = (max(1, -∞) + min(+∞, 2)) / 2 = 1.5
```

---

## Day 23 Summary

### Key Concepts
1. **Median**: Middle value(s) in sorted array
2. **Partition**: Divide combined array into equal halves
3. **Binary Search**: Find correct partition in log time
4. **Boundary Values**: Use infinity for edge cases

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Median Finding | Binary Search | Partition validation | O(log(min(m,n))) |
| Array Merging | Two Pointers | Simultaneous traversal | O(m+n) |
| Sorted Arrays | Binary Search | Exploit sorted property | O(log n) |

### Complexity Progression

| Approach | Time | Why |
|----------|------|-----|
| Merge & Sort | O((m+n)log(m+n)) | Sorting overhead |
| Two Pointers | O(m+n) | Linear merge |
| Binary Search | O(log(min(m,n))) | Search on smaller array |

### Critical Insights
1. **Optimization**: Always binary search on smaller array
2. **Partition Math**: j = half - i ensures equal halves
3. **Infinity Trick**: Eliminates boundary checks
4. **Validity Check**: Cross-comparison of boundaries
5. **Odd/Even Handling**: Different median calculations

### When to Use This Pattern
- Two sorted arrays problem
- Need better than O(m+n) time
- Finding kth element in merged arrays
- Partition-based problems

### Master Checklist
- [ ] Understand why O(log(m+n)) is required
- [ ] Can explain partition concept
- [ ] Know why to search on smaller array
- [ ] Understand half = (m+n+1)//2 formula
- [ ] Can handle infinity boundary cases
- [ ] Know difference between odd/even median calculation
- [ ] Can trace through binary search iterations
- [ ] Understand partition validity conditions

### Related Problems
- Kth Smallest Element in Sorted Matrix
- Find K Pairs with Smallest Sums
- Median of Data Stream (uses heaps)
- Merge Sorted Array (two pointers)
