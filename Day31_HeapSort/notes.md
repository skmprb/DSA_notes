# Day 31: Kth Largest Element in an Array

## Problem: Kth Largest Element in an Array

### Problem Statement
Given an integer array `nums` and an integer `k`, return the kth largest element in the array.

**Note**: It is the kth largest element in sorted order, not the kth distinct element.

**Challenge**: Can you solve it without sorting?

### Problem Logic
Find kth largest = Find element at position (n - k) in sorted array.

---

## Approach 1: Min Heap ⭐

### Core Insight
Maintain a min heap of size k. The root will always be the kth largest element.

### Pseudocode
```
FIND_KTH_LARGEST_HEAP(nums, k):
    heap = []
    
    for num in nums:
        heap.push(num)
        
        if len(heap) > k:
            heap.pop()  # Remove smallest
    
    return heap[0]  # Root is kth largest
```

### Visual Flow
```
Example: nums = [3,2,1,5,6,4], k = 2

Step 1: Process 3
heap = [3]
size = 1 < 2, keep

Step 2: Process 2
heap = [2, 3]
size = 2 = k, keep

Step 3: Process 1
heap = [1, 3, 2]
size = 3 > k, pop smallest (1)
heap = [2, 3]

Step 4: Process 5
heap = [2, 3, 5]
size = 3 > k, pop smallest (2)
heap = [3, 5]

Step 5: Process 6
heap = [3, 5, 6]
size = 3 > k, pop smallest (3)
heap = [5, 6]

Step 6: Process 4
heap = [4, 6, 5]
size = 3 > k, pop smallest (4)
heap = [5, 6]

Result: heap[0] = 5 (2nd largest)
```

### Why Min Heap?
```
Min Heap of size k:
- Keeps k largest elements
- Root is smallest of these k elements
- Root = kth largest overall

Example: k=2, nums=[3,2,1,5,6,4]
After processing: heap = [5, 6]
Root = 5 (2nd largest) ✓

If we used Max Heap:
- Would need to pop k-1 times
- Less efficient
```

### Heap Operations
```
Min Heap Structure:
        2
       / \
      3   5

Properties:
- Parent ≤ Children
- Root is minimum
- Complete binary tree

Operations:
- push(x): O(log k)
- pop(): O(log k)
- peek(): O(1)
```

### Complexity
- **Time**: O(n log k) - n insertions, each O(log k)
- **Space**: O(k) - heap size

---

## Approach 2: QuickSelect ⭐

### Core Insight
Use QuickSort's partition logic. Only recurse on the side containing kth element.

### Pseudocode
```
FIND_KTH_LARGEST_QUICKSELECT(nums, k):
    k = len(nums) - k  # Convert to index
    
    PARTITION(low, high):
        pivot = nums[high]
        i = low - 1
        
        for j in range(low, high):
            if nums[j] <= pivot:
                i++
                swap(nums[i], nums[j])
        
        swap(nums[i+1], nums[high])
        return i + 1
    
    QUICKSELECT(low, high):
        if low <= high:
            p = PARTITION(low, high)
            
            if p == k:
                return nums[p]
            elif p < k:
                return QUICKSELECT(p+1, high)
            else:
                return QUICKSELECT(low, p-1)
    
    return QUICKSELECT(0, len(nums)-1)
```

### Visual Flow
```
Example: nums = [3,2,1,5,6,4], k = 2
Target index: 6 - 2 = 4

Iteration 1: Partition with pivot=4
[3,2,1,5,6,4]
After partition: [3,2,1,4,6,5]
                        ↑
                       p=3

p=3 < k=4, search right: [6,5]

Iteration 2: Partition with pivot=5
[6,5]
After partition: [5,6]
                  ↑
                 p=4

p=4 == k=4, return nums[4] = 5
```

### Step-by-Step Example
```
nums = [3,2,1,5,6,4], k = 2
k_index = 6 - 2 = 4

Step 1: partition(0, 5) with pivot=4
i=-1, j=0: nums[0]=3 ≤ 4, i=0, swap(nums[0],nums[0])
i=0, j=1: nums[1]=2 ≤ 4, i=1, swap(nums[1],nums[1])
i=1, j=2: nums[2]=1 ≤ 4, i=2, swap(nums[2],nums[2])
i=2, j=3: nums[3]=5 > 4, skip
i=2, j=4: nums[4]=6 > 4, skip
swap(nums[3], nums[5]): [3,2,1,4,6,5]
return p=3

Step 2: p=3 < k=4, quickselect(4, 5)
partition(4, 5) with pivot=5
i=3, j=4: nums[4]=6 > 5, skip
swap(nums[4], nums[5]): [3,2,1,4,5,6]
return p=4

Step 3: p=4 == k=4, return nums[4]=5
```

### Why QuickSelect is Efficient
```
QuickSort: Recurse on BOTH sides
Time: O(n log n)

QuickSelect: Recurse on ONE side only
Time: O(n) average

Example:
n=8 elements
QuickSort: 8 → 4,4 → 2,2,2,2 → 1,1,1,1,1,1,1,1
Total: 8+8+8 = 24 comparisons

QuickSelect: 8 → 4 → 2 → 1
Total: 8+4+2+1 = 15 comparisons
```

### Complexity
- **Time**: O(n) average, O(n²) worst case
- **Space**: O(1) - in-place
- **Optimization**: Random pivot → O(n) expected

---

## Approach 3: Sorting

### Pseudocode
```
FIND_KTH_LARGEST_SORT(nums, k):
    nums.sort()
    return nums[len(nums) - k]
```

### Visual Flow
```
nums = [3,2,1,5,6,4], k = 2

Step 1: Sort
[1,2,3,4,5,6]

Step 2: Get kth largest
index = 6 - 2 = 4
nums[4] = 5
```

### Complexity
- **Time**: O(n log n) - sorting
- **Space**: O(1) or O(n) depending on sort algorithm
- **Issue**: Doesn't meet "without sorting" challenge ✗

---

## Approach 4: QuickSelect with 3-Way Partition

### Core Insight
Handle duplicates efficiently by partitioning into three parts: <pivot, =pivot, >pivot.

### Pseudocode
```
THREE_WAY_PARTITION(low, high):
    pivot = nums[high]
    i = low  # boundary for < pivot
    j = low  # current element
    p = high  # boundary for > pivot
    
    while j < p:
        if nums[j] < pivot:
            swap(nums[i], nums[j])
            i++
            j++
        elif nums[j] > pivot:
            p--
            swap(nums[j], nums[p])
        else:
            j++
    
    swap(nums[p], nums[high])
    return (i, p)  # boundaries of equal section
```

### Visual Flow
```
nums = [3,2,3,1,2,4,5,5,6], k = 4
pivot = 6

After 3-way partition:
[3,2,3,1,2,4,5,5] [6]
 < pivot          = pivot

Boundaries: left=0, right=8
k=5 (index), falls in equal section
Return 6
```

### Complexity
- **Time**: O(n) average
- **Space**: O(1)
- **Advantage**: Better for arrays with many duplicates

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Min Heap** ⭐ | O(n log k) | O(k) | Good for small k, stable | Extra space |
| **QuickSelect** ⭐ | O(n) avg | O(1) | Optimal average, in-place | O(n²) worst case |
| **Sorting** | O(n log n) | O(1) | Simple, reliable | Slower, doesn't meet challenge |
| **3-Way Partition** | O(n) avg | O(1) | Best for duplicates | More complex |

**Best Choices**:
- **Small k**: Min Heap O(n log k)
- **Large k or in-place**: QuickSelect O(n)

---

## Critical Insights

### 1. Index Conversion
```
kth largest = (n - k)th smallest

Example: [1,2,3,4,5,6], k=2
2nd largest = 5
Index in sorted: 4
Formula: 6 - 2 = 4 ✓
```

### 2. Min Heap vs Max Heap
```
For kth largest:

Min Heap (size k):
- Keep k largest elements
- Root = kth largest
- Efficient: O(n log k)

Max Heap (size n):
- Keep all elements
- Pop k-1 times
- Inefficient: O(n + k log n)

Min Heap is better!
```

### 3. QuickSelect Optimization
```
Random Pivot:
- Avoids worst case O(n²)
- Expected O(n)

Without randomization:
Sorted array → O(n²)
[1,2,3,4,5] → always picks worst pivot

With randomization:
Expected O(n) regardless of input
```

### 4. When to Use Each Approach
```
Use Min Heap when:
- k is small (k << n)
- Need stable solution
- Can afford O(k) space

Use QuickSelect when:
- Need O(1) space
- k is large
- Average case acceptable

Use Sorting when:
- Need multiple queries
- Simplicity matters
- O(n log n) acceptable
```

---

## Common Mistakes

1. ❌ **Wrong index conversion**: Using k instead of n-k
2. ❌ **Using max heap**: Less efficient than min heap
3. ❌ **Not handling duplicates**: 3-way partition helps
4. ❌ **Forgetting random pivot**: Leads to O(n²) worst case
5. ❌ **Heap size check**: Must maintain size ≤ k

---

## Edge Cases

```python
# Case 1: k = 1 (largest element)
nums = [3,2,1,5,6,4], k = 1
Output: 6

# Case 2: k = n (smallest element)
nums = [3,2,1,5,6,4], k = 6
Output: 1

# Case 3: All duplicates
nums = [5,5,5,5], k = 2
Output: 5

# Case 4: Two elements
nums = [2,1], k = 1
Output: 2

# Case 5: Single element
nums = [1], k = 1
Output: 1

# Case 6: Negative numbers
nums = [-1,-2,-3], k = 2
Output: -2
```

---

## Implementation Details

### Min Heap Implementation
```python
import heapq

def findKthLargest(nums, k):
    heap = []
    
    for num in nums:
        heapq.heappush(heap, num)
        if len(heap) > k:
            heapq.heappop(heap)
    
    return heap[0]
```

### QuickSelect with Random Pivot
```python
import random

def findKthLargest(nums, k):
    k = len(nums) - k
    
    def partition(low, high):
        # Random pivot
        pivot_idx = random.randint(low, high)
        nums[pivot_idx], nums[high] = nums[high], nums[pivot_idx]
        
        pivot = nums[high]
        i = low - 1
        
        for j in range(low, high):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        
        nums[i+1], nums[high] = nums[high], nums[i+1]
        return i + 1
    
    def quickselect(low, high):
        if low <= high:
            p = partition(low, high)
            
            if p == k:
                return nums[p]
            elif p < k:
                return quickselect(p+1, high)
            else:
                return quickselect(low, p-1)
    
    return quickselect(0, len(nums)-1)
```

---

## Heap Operations Explained

### Heapify Up (Insert)
```
Insert 2 into [3, 5, 7]:

Step 1: Add to end
[3, 5, 7, 2]

Step 2: Compare with parent
2 < 3, swap
[2, 5, 7, 3]

Step 3: Check parent again
2 < root, done
```

### Heapify Down (Delete)
```
Delete root from [2, 3, 5, 7]:

Step 1: Replace root with last
[7, 3, 5]

Step 2: Compare with children
7 > 3, swap with smaller child
[3, 7, 5]

Step 3: Compare again
7 > 5, swap
[3, 5, 7]
```

---

## QuickSelect Partition Explained

### Partition Process
```
nums = [3,2,1,5,6,4], pivot = 4

Initial:
[3, 2, 1, 5, 6, 4]
 ↑              ↑
 i=-1          pivot

j=0: 3 ≤ 4, i=0, swap(nums[0],nums[0])
[3, 2, 1, 5, 6, 4]
 ↑
 i=0

j=1: 2 ≤ 4, i=1, swap(nums[1],nums[1])
[3, 2, 1, 5, 6, 4]
    ↑
    i=1

j=2: 1 ≤ 4, i=2, swap(nums[2],nums[2])
[3, 2, 1, 5, 6, 4]
       ↑
       i=2

j=3: 5 > 4, skip
j=4: 6 > 4, skip

Final: swap(nums[3], nums[5])
[3, 2, 1, 4, 6, 5]
          ↑
         p=3

Elements ≤ 4 on left, > 4 on right
```

---

## Decision Tree

```
findKthLargest(nums, k)
    │
    ├─ Small k (k << n)?
    │   └─ Use Min Heap
    │       ├─ Build heap of size k
    │       ├─ For each element: push, pop if size > k
    │       └─ Return heap[0]
    │
    ├─ Need O(1) space?
    │   └─ Use QuickSelect
    │       ├─ Convert k to index: k = n - k
    │       ├─ Partition array
    │       ├─ If p == k: return nums[p]
    │       ├─ If p < k: recurse right
    │       └─ If p > k: recurse left
    │
    └─ Simplicity matters?
        └─ Use Sorting
            ├─ Sort array
            └─ Return nums[n-k]
```

---

## Day 31 Summary

### Key Concepts
1. **Min Heap**: Keep k largest, root is kth largest
2. **QuickSelect**: Partition-based selection, O(n) average
3. **Index Conversion**: kth largest = (n-k)th smallest
4. **Random Pivot**: Avoids worst case

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Kth Largest | Selection | Min Heap | O(n log k) |
| Kth Largest | Selection | QuickSelect | O(n) avg |
| Top K Elements | Heap | Min Heap of size k | O(n log k) |

### Complexity Comparison

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Min Heap | O(n log k) | O(k) | Small k |
| QuickSelect | O(n) avg | O(1) | Large k, in-place |
| Sorting | O(n log n) | O(1) | Multiple queries |
| 3-Way Partition | O(n) avg | O(1) | Many duplicates |

### Critical Insights
1. **Min Heap Size k**: More efficient than max heap size n
2. **QuickSelect Pruning**: Only recurse on one side
3. **Random Pivot**: Critical for expected O(n)
4. **Index Math**: kth largest = (n-k)th in sorted order
5. **Space Tradeoff**: O(k) heap vs O(1) quickselect

### When to Use This Pattern
- Finding kth element (largest, smallest)
- Top k elements
- Median finding
- Selection problems

### Master Checklist
- [ ] Can implement min heap approach
- [ ] Understand why min heap of size k works
- [ ] Can implement quickselect with partition
- [ ] Know index conversion formula
- [ ] Understand random pivot importance
- [ ] Can handle duplicates with 3-way partition
- [ ] Know when to use heap vs quickselect
- [ ] Can analyze time/space tradeoffs

### Related Problems
- Kth Smallest Element in Sorted Matrix
- Top K Frequent Elements
- Find Median from Data Stream
- Wiggle Sort II
- Kth Smallest Element in BST
- Quickselect Algorithm
- Median of Two Sorted Arrays
