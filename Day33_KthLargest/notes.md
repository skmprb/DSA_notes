# Day 33: Kth Largest Element in a Stream

## Problem: Kth Largest Element in a Stream

### Problem Statement
Design a class to find the kth largest element in a stream. The class should support:
- **Constructor**: `KthLargest(k, nums)` - Initialize with k and initial array
- **add(val)**: Add new value to stream and return kth largest element

**Real-World Context**: University admissions tracking kth highest test score in real-time to determine cut-off marks dynamically.

### Problem Logic & Reasoning

#### Why This Problem is Unique
```
Static Array Problem (Day 31):
- Find kth largest ONCE
- Array doesn't change
- Can use QuickSelect or Heap

Stream Problem (Day 33):
- Find kth largest REPEATEDLY
- Array keeps growing
- Need EFFICIENT updates
- Must handle MULTIPLE queries
```

#### Key Insight
```
After each add():
- Array grows by 1 element
- Need to return kth largest IMMEDIATELY
- Can't re-sort entire array each time
- Need O(log k) per operation, not O(n log n)

Example:
Initial: [4, 5, 8, 2], k=3
add(3): [4, 5, 8, 2, 3] → return 4
add(5): [4, 5, 8, 2, 3, 5] → return 5
add(10): [4, 5, 8, 2, 3, 5, 10] → return 5
...

Need efficient way to track kth largest as stream grows!
```

---

## Why Heap is THE Solution

### The Fundamental Reasoning

#### Problem Requirements Analysis
```
1. DYNAMIC: Elements added continuously
2. REPEATED QUERIES: Return kth largest after EACH add
3. EFFICIENCY: Can't afford O(n) or O(n log n) per add
4. MEMORY: Don't need ALL elements, just top k

Perfect Match for Min Heap of Size k!
```

#### Why Min Heap of Size k?
```
Brilliant Insight:
- Keep ONLY k largest elements
- Smallest of these k = kth largest overall
- Min heap root = smallest in heap = kth largest!

Example: k=3, stream=[4,5,8,2,3,5,10,9,4]

After processing all:
Heap (size 3): [8, 9, 10]
                ↑
              root = 8 (3rd largest)

Why this works:
- Heap has 3 largest: 8, 9, 10
- Smallest of these 3 = 8
- 8 is the 3rd largest overall ✓
```

---

## Approach: Min Heap of Size k ⭐

### Core Insight
**Maintain a min heap of exactly k elements containing the k largest values seen so far. The root is always the kth largest.**

### Pseudocode
```
CLASS KthLargest:
    CONSTRUCTOR(k, nums):
        self.k = k
        self.heap = nums
        
        # Convert to min heap
        heapify(self.heap)
        
        # Keep only k largest elements
        while len(self.heap) > k:
            heappop(self.heap)
    
    ADD(val):
        # Add new value
        heappush(self.heap, val)
        
        # Maintain size k
        if len(self.heap) > k:
            heappop(self.heap)
        
        # Root is kth largest
        return self.heap[0]
```

### Detailed Visual Flow

#### Initialization Phase
```
k = 3, nums = [4, 5, 8, 2]

Step 1: Create heap from nums
heap = [4, 5, 8, 2]

Step 2: Heapify (convert to min heap)
        2
       / \
      4   8
     /
    5

Array representation: [2, 4, 8, 5]

Step 3: Reduce to size k=3
Pop smallest (2):
        4
       / \
      5   8

heap = [4, 5, 8]
Root = 4 (3rd largest in [4,5,8,2])
```

#### Add Operations - Complete Trace

##### add(3) - Detailed Steps
```
Current heap: [4, 5, 8]
Add 3:

Step 1: Push 3
        4
       / \
      5   8
     /
    3

heap = [3, 4, 8, 5]
size = 4 > k=3

Step 2: Pop smallest (3)
        4
       / \
      5   8

heap = [4, 5, 8]

Step 3: Return root
return 4

Reasoning:
Elements: [4, 5, 8, 2, 3]
Sorted: [2, 3, 4, 5, 8]
3rd largest = 4 ✓
```

##### add(5) - Detailed Steps
```
Current heap: [4, 5, 8]
Add 5:

Step 1: Push 5
        4
       / \
      5   8
     /
    5

heap = [4, 5, 8, 5]
size = 4 > k=3

Step 2: Pop smallest (4)
        5
       / \
      5   8

heap = [5, 5, 8]

Step 3: Return root
return 5

Reasoning:
Elements: [4, 5, 8, 2, 3, 5]
Sorted: [2, 3, 4, 5, 5, 8]
3rd largest = 5 ✓
```

##### add(10) - Detailed Steps
```
Current heap: [5, 5, 8]
Add 10:

Step 1: Push 10
        5
       / \
      5   8
     /
    10

heap = [5, 5, 8, 10]
size = 4 > k=3

Step 2: Pop smallest (5)
        5
       / \
      10  8

heap = [5, 10, 8]

Step 3: Return root
return 5

Reasoning:
Elements: [4, 5, 8, 2, 3, 5, 10]
Sorted: [2, 3, 4, 5, 5, 8, 10]
3rd largest = 5 ✓
```

##### add(9) - Detailed Steps
```
Current heap: [5, 10, 8]
Add 9:

Step 1: Push 9
        5
       / \
      10  8
     /
    9

heap = [5, 9, 8, 10]
size = 4 > k=3

Step 2: Pop smallest (5)
        8
       / \
      9   10

heap = [8, 9, 10]

Step 3: Return root
return 8

Reasoning:
Elements: [4, 5, 8, 2, 3, 5, 10, 9]
Sorted: [2, 3, 4, 5, 5, 8, 9, 10]
3rd largest = 8 ✓
```

##### add(4) - Detailed Steps
```
Current heap: [8, 9, 10]
Add 4:

Step 1: Push 4
        8
       / \
      9   10
     /
    4

heap = [4, 8, 10, 9]
size = 4 > k=3

Step 2: Pop smallest (4)
        8
       / \
      9   10

heap = [8, 9, 10]

Step 3: Return root
return 8

Reasoning:
Elements: [4, 5, 8, 2, 3, 5, 10, 9, 4]
Sorted: [2, 3, 4, 4, 5, 5, 8, 9, 10]
3rd largest = 8 ✓
```

---

## Understanding heapq Module

### What is heapq?
```
Python's heapq module implements a MIN HEAP:
- Binary tree stored as array
- Parent ≤ Children (min heap property)
- Root is always minimum
- Efficient O(log n) operations
```

### Key heapq Operations

#### 1. heapify(list)
```python
nums = [4, 5, 8, 2]
heapq.heapify(nums)
# nums becomes: [2, 4, 8, 5]

Visual:
Before:     After heapify:
[4,5,8,2]        2
               /   \
              4     8
             /
            5

Time: O(n)
```

#### 2. heappush(heap, item)
```python
heap = [2, 4, 8, 5]
heapq.heappush(heap, 3)
# heap becomes: [2, 3, 8, 5, 4]

Visual:
        2
       / \
      3   8
     / \
    5   4

Process:
1. Add 3 to end: [2, 4, 8, 5, 3]
2. Bubble up: 3 < 4, swap
3. Result: [2, 3, 8, 5, 4]

Time: O(log n)
```

#### 3. heappop(heap)
```python
heap = [2, 3, 8, 5, 4]
min_val = heapq.heappop(heap)
# min_val = 2
# heap becomes: [3, 4, 8, 5]

Visual:
Before:     After:
    2           3
   / \         / \
  3   8       4   8
 / \         /
5   4       5

Process:
1. Save root (2)
2. Move last to root: [4, 3, 8, 5]
3. Bubble down: 4 > 3, swap
4. Result: [3, 4, 8, 5]

Time: O(log n)
```

#### 4. heappushpop(heap, item)
```python
heap = [3, 4, 8, 5]
result = heapq.heappushpop(heap, 6)
# result = 3 (old root)
# heap becomes: [4, 5, 8, 6]

Optimization:
- Push then pop in ONE operation
- More efficient than separate push + pop
- Useful when heap is at capacity

Time: O(log n)
```

### Heap Array Representation
```
Tree:       Array:
    2       [2, 4, 8, 5, 9]
   / \       0  1  2  3  4
  4   8
 / \
5   9

Index relationships:
- Parent of i: (i-1) // 2
- Left child of i: 2*i + 1
- Right child of i: 2*i + 2

Example:
Node at index 1 (value 4):
- Parent: (1-1)//2 = 0 (value 2)
- Left child: 2*1+1 = 3 (value 5)
- Right child: 2*1+2 = 4 (value 9)
```

---

## Why Other Approaches Fail

### Approach 1: Sorting Every Time ✗
```python
class KthLargest:
    def __init__(self, k, nums):
        self.k = k
        self.nums = nums
    
    def add(self, val):
        self.nums.append(val)
        self.nums.sort()
        return self.nums[-self.k]
```

**Why it fails:**
```
Time Complexity: O(n log n) per add
- Sort entire array each time
- Extremely inefficient for streams

Example: 10,000 adds
- Total: 10,000 × n log n
- With heap: 10,000 × log k

If n=10,000, k=100:
Sorting: 10,000 × 10,000 × log(10,000) ≈ 1.3 billion ops
Heap: 10,000 × log(100) ≈ 66,000 ops

Heap is 20,000x faster!
```

### Approach 2: Max Heap of All Elements ✗
```python
class KthLargest:
    def __init__(self, k, nums):
        self.k = k
        self.heap = [-x for x in nums]  # Negate for max heap
        heapq.heapify(self.heap)
    
    def add(self, val):
        heapq.heappush(self.heap, -val)
        # Pop k-1 times to get kth largest
        temp = []
        for _ in range(self.k - 1):
            temp.append(heapq.heappop(self.heap))
        result = -self.heap[0]
        # Push back
        for x in temp:
            heapq.heappush(self.heap, x)
        return result
```

**Why it fails:**
```
Time Complexity: O(k log n) per add
- Need to pop k-1 times
- Need to push k-1 times back
- Inefficient for large k

Space: O(n) - stores ALL elements
- Wastes memory
- Don't need all elements!

Example: k=1000, n=10,000
Each add: 1000 pops + 1000 pushes = 2000 operations
With min heap of size k: 1 push + 1 pop = 2 operations

Min heap is 1000x faster!
```

### Approach 3: Sorted List with Binary Search ✗
```python
import bisect

class KthLargest:
    def __init__(self, k, nums):
        self.k = k
        self.nums = sorted(nums)
    
    def add(self, val):
        bisect.insort(self.nums, val)
        return self.nums[-self.k]
```

**Why it fails:**
```
Time Complexity: O(n) per add
- Binary search: O(log n)
- Insertion: O(n) - shifts elements
- Total: O(n)

Example: n=10,000
Each add: 10,000 shifts
With heap: log(k) operations

If k=100:
Sorted list: 10,000 ops per add
Heap: log(100) ≈ 7 ops per add

Heap is 1400x faster!
```

### Approach 4: Keep All in Heap, Query Each Time ✗
```python
class KthLargest:
    def __init__(self, k, nums):
        self.k = k
        self.heap = nums
        heapq.heapify(self.heap)
    
    def add(self, val):
        heapq.heappush(self.heap, val)
        # Create temp heap to find kth largest
        temp = self.heap[:]
        for _ in range(len(temp) - self.k):
            heapq.heappop(temp)
        return temp[0]
```

**Why it fails:**
```
Time Complexity: O(n log n) per add
- Copy heap: O(n)
- Pop n-k times: O((n-k) log n)
- Total: O(n log n)

Space: O(n) - duplicate heap each time

This is worse than sorting!
```

---

## Why Min Heap of Size k is Perfect

### Comparison Table

| Approach | Time per add | Space | Why it fails |
|----------|-------------|-------|--------------|
| **Min Heap (size k)** ⭐ | **O(log k)** | **O(k)** | **Perfect!** |
| Sort every time | O(n log n) | O(n) | Too slow |
| Max heap (all elements) | O(k log n) | O(n) | Wastes time & space |
| Sorted list + bisect | O(n) | O(n) | Insertion too slow |
| Heap with temp copy | O(n log n) | O(n) | Extremely inefficient |

### Why Min Heap Wins

#### 1. Optimal Time Complexity
```
Per add operation: O(log k)
- Push: O(log k)
- Pop: O(log k)
- Total: O(log k)

For m adds: O(m log k)

Example: m=10,000, k=100
Total: 10,000 × log(100) ≈ 66,000 operations

Compare to sorting: 10,000 × n log n
If n grows to 10,000: 1.3 billion operations!
```

#### 2. Optimal Space Complexity
```
Space: O(k)
- Only store k elements
- Don't need the rest!

Example: k=100, n=1,000,000
Heap: 100 elements
Other approaches: 1,000,000 elements

Heap uses 10,000x less memory!
```

#### 3. Constant Time Query
```
After add, return heap[0]: O(1)
- Root is always kth largest
- No additional computation needed
```

#### 4. Handles Duplicates Naturally
```
Duplicates don't affect heap operations:
add(5), add(5), add(5) all work correctly

Example: k=3, nums=[7,7,7,7,8,3]
Heap: [7, 7, 8]
Root = 7 (3rd largest) ✓
```

---

## Complete Implementation with Comments

```python
import heapq
from typing import List

class KthLargest:
    """
    Maintains kth largest element in a stream using min heap.
    
    Key Insight: Min heap of size k contains k largest elements.
    Root of this heap is the kth largest element overall.
    """
    
    def __init__(self, k: int, nums: List[int]):
        """
        Initialize with k and initial array.
        
        Time: O(n) for heapify + O((n-k) log n) for pops = O(n)
        Space: O(k)
        """
        self.k = k
        self.heap = nums
        
        # Convert list to min heap: O(n)
        heapq.heapify(self.heap)
        
        # Keep only k largest elements: O((n-k) log n)
        while len(self.heap) > k:
            heapq.heappop(self.heap)
    
    def add(self, val: int) -> int:
        """
        Add value to stream and return kth largest.
        
        Time: O(log k)
        Space: O(1)
        """
        # Add new value: O(log k)
        heapq.heappush(self.heap, val)
        
        # Maintain size k: O(log k)
        if len(self.heap) > self.k:
            heapq.heappop(self.heap)
        
        # Root is kth largest: O(1)
        return self.heap[0]
```

### Optimized Version
```python
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.heap = []
        
        # Build heap by adding elements one by one
        for num in nums:
            self.add(num)
    
    def add(self, val: int) -> int:
        # If heap not full, just add
        if len(self.heap) < self.k:
            heapq.heappush(self.heap, val)
        # If new value larger than root, replace root
        elif val > self.heap[0]:
            heapq.heappushpop(self.heap, val)
        
        return self.heap[0]
```

**Optimization Benefits:**
```
1. heappushpop: Single operation instead of push + pop
2. Early exit: Don't add if val ≤ root
3. Cleaner initialization: Reuse add method
```

---

## Complexity Analysis

### Time Complexity

#### Initialization
```
Method 1 (heapify then pop):
- heapify: O(n)
- pop (n-k) times: O((n-k) log n)
- Total: O(n + (n-k) log n) = O(n log n) worst case

Method 2 (add one by one):
- n calls to add: O(n log k)
- Total: O(n log k)

Method 2 is better when k << n!
```

#### Add Operation
```
- heappush: O(log k)
- heappop: O(log k)
- Total: O(log k)

For m add operations: O(m log k)
```

### Space Complexity
```
Heap size: O(k)
- Only stores k elements
- Constant extra space for variables

Total: O(k)
```

### Comparison with Alternatives
```
Problem: m adds, final array size n, track kth largest

Min Heap (size k):
Time: O(n log k + m log k) = O((n+m) log k)
Space: O(k)

Sorting each time:
Time: O(m × n log n)
Space: O(n)

Ratio: (m × n log n) / ((n+m) log k)
If m=n=10,000, k=100:
Ratio ≈ 10,000 × 10,000 × 13 / (20,000 × 7)
     ≈ 1,300,000,000 / 140,000
     ≈ 9,300x slower!
```

---

## Edge Cases

```python
# Case 1: k = 1 (track maximum)
obj = KthLargest(1, [5, 3, 8])
obj.add(7)  # return 8
obj.add(10) # return 10

# Case 2: k = n (track minimum)
obj = KthLargest(3, [1, 2, 3])
obj.add(0)  # return 1
obj.add(-1) # return 0

# Case 3: All duplicates
obj = KthLargest(2, [7, 7, 7, 7])
obj.add(7)  # return 7

# Case 4: Empty initial array
obj = KthLargest(1, [])
obj.add(5)  # return 5

# Case 5: Negative numbers
obj = KthLargest(2, [-1, -2, -3])
obj.add(-4) # return -2
obj.add(0)  # return -1
```

---

## Common Mistakes

1. ❌ **Using max heap**: Need to pop k-1 times, inefficient
2. ❌ **Storing all elements**: Wastes space, O(n) instead of O(k)
3. ❌ **Sorting every time**: O(n log n) per add, too slow
4. ❌ **Wrong heap size**: Must maintain exactly k elements
5. ❌ **Forgetting to pop**: Heap grows unbounded

---

## Day 33 Summary

### Key Concepts
1. **Streaming Problem**: Elements added continuously, need repeated queries
2. **Min Heap of Size k**: Perfect data structure for this problem
3. **Root Property**: Root of min heap = smallest = kth largest
4. **Efficiency**: O(log k) per add vs O(n log n) for sorting

### Why Heap is THE Solution

| Requirement | Heap Solution | Why Perfect |
|-------------|---------------|-------------|
| **Dynamic** | Add in O(log k) | Efficient updates |
| **Repeated Queries** | Return root in O(1) | Instant answer |
| **Space Efficient** | Store only k elements | Minimal memory |
| **Handles Duplicates** | Natural heap behavior | No special handling |

### Pattern Recognition

| Problem Type | Data Structure | Key Insight |
|--------------|----------------|-------------|
| **Kth in Stream** | Min Heap (size k) | Root = kth largest |
| **Top K in Stream** | Min Heap (size k) | All elements in heap |
| **Median in Stream** | Two Heaps | Balance left/right |

### Critical Insights
1. **Size k Heap**: Only need k largest, not all elements
2. **Min Heap Property**: Smallest in heap = kth largest overall
3. **O(log k) Updates**: Much better than O(n) or O(n log n)
4. **Space Optimization**: O(k) vs O(n) for other approaches
5. **heappushpop**: Atomic operation for efficiency

### When to Use This Pattern
- Streaming data (continuous input)
- Need kth element repeatedly
- Can't afford to sort each time
- Space is limited (can't store all)
- Real-time requirements

### Master Checklist
- [ ] Understand why min heap of size k works
- [ ] Can explain why root is kth largest
- [ ] Know heapq operations (push, pop, heapify)
- [ ] Understand heap array representation
- [ ] Can analyze why other approaches fail
- [ ] Know time complexity: O(log k) per add
- [ ] Understand space optimization: O(k) not O(n)
- [ ] Can implement both standard and optimized versions

### Related Problems
- Find Median from Data Stream (Two Heaps)
- Top K Frequent Elements
- Kth Largest Element in Array (Day 31)
- Sliding Window Median
- IPO (Maximize Capital)
- Meeting Rooms II
