# LeetCode Problems on HeapSort & Heap
## Complete Practice Guide

---

## 📚 Table of Contents
1. [Easy Problems](#easy-problems)
2. [Medium Problems](#medium-problems)
3. [Hard Problems](#hard-problems)
4. [Problem Categories](#problem-categories)
5. [Learning Path](#learning-path)
6. [Pattern Recognition](#pattern-recognition)

---

## Easy Problems

### 1. **703. Kth Largest Element in a Stream** ⭐⭐⭐
**Difficulty**: Easy  
**Link**: https://leetcode.com/problems/kth-largest-element-in-a-stream/

**Description**: Design a class to find the kth largest element in a stream.

**Key Concepts**:
- Min heap of size k
- Maintain k largest elements
- Heap operations: push, pop

**Why Important**: Foundation of heap usage

**Time**: O(log k) per add | **Space**: O(k)

```python
# Template
import heapq

class KthLargest:
    def __init__(self, k, nums):
        self.k = k
        self.heap = nums
        heapq.heapify(self.heap)
        
        # Keep only k largest
        while len(self.heap) > k:
            heapq.heappop(self.heap)
    
    def add(self, val):
        heapq.heappush(self.heap, val)
        if len(self.heap) > self.k:
            heapq.heappop(self.heap)
        return self.heap[0]
```

---

### 2. **1046. Last Stone Weight** ⭐⭐
**Difficulty**: Easy  
**Link**: https://leetcode.com/problems/last-stone-weight/

**Description**: Smash two heaviest stones repeatedly until one or none remain.

**Key Concepts**:
- Max heap (negate values for Python)
- Heap operations
- Simulation

**Why Important**: Basic heap manipulation

**Time**: O(n log n) | **Space**: O(n)

```python
# Template
import heapq

def lastStoneWeight(stones):
    # Python has min heap, so negate for max heap
    heap = [-stone for stone in stones]
    heapq.heapify(heap)
    
    while len(heap) > 1:
        first = -heapq.heappop(heap)
        second = -heapq.heappop(heap)
        
        if first != second:
            heapq.heappush(heap, -(first - second))
    
    return -heap[0] if heap else 0
```

---

## Medium Problems

### 3. **215. Kth Largest Element in an Array** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/kth-largest-element-in-an-array/

**Description**: Find the kth largest element in an unsorted array.

**Key Concepts**:
- Min heap of size k
- Or use HeapSort
- Or use QuickSelect

**Why Important**: Classic heap problem, multiple solutions

**Time**: O(n log k) heap, O(n log n) heapsort | **Space**: O(k) or O(1)

```python
# Solution 1: Min Heap
import heapq

def findKthLargest(nums, k):
    heap = nums[:k]
    heapq.heapify(heap)
    
    for num in nums[k:]:
        if num > heap[0]:
            heapq.heapreplace(heap, num)
    
    return heap[0]

# Solution 2: HeapSort
def findKthLargest(nums, k):
    def heapify(arr, n, i):
        largest = i
        l = 2 * i + 1
        r = 2 * i + 2
        
        if l < n and arr[l] > arr[largest]:
            largest = l
        if r < n and arr[r] > arr[largest]:
            largest = r
        
        if largest != i:
            arr[i], arr[largest] = arr[largest], arr[i]
            heapify(arr, n, largest)
    
    n = len(nums)
    
    # Build max heap
    for i in range(n // 2 - 1, -1, -1):
        heapify(nums, n, i)
    
    # Extract max k-1 times
    for i in range(n - 1, n - k, -1):
        nums[0], nums[i] = nums[i], nums[0]
        heapify(nums, i, 0)
    
    return nums[0]
```

---

### 4. **347. Top K Frequent Elements** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/top-k-frequent-elements/

**Description**: Find k most frequent elements.

**Key Concepts**:
- Min heap of size k with frequencies
- HashMap + Heap
- Custom comparator

**Why Important**: Combines counting with heap

**Time**: O(n log k) | **Space**: O(n)

```python
# Template
import heapq
from collections import Counter

def topKFrequent(nums, k):
    count = Counter(nums)
    
    # Min heap of (frequency, number)
    heap = []
    
    for num, freq in count.items():
        heapq.heappush(heap, (freq, num))
        if len(heap) > k:
            heapq.heappop(heap)
    
    return [num for freq, num in heap]
```

---

### 5. **973. K Closest Points to Origin** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/k-closest-points-to-origin/

**Description**: Find k closest points to origin (0, 0).

**Key Concepts**:
- Max heap of size k (negate distances)
- Distance calculation
- Partial sorting

**Why Important**: Heap with custom distance

**Time**: O(n log k) | **Space**: O(k)

```python
# Template
import heapq

def kClosest(points, k):
    # Max heap of size k (negate for max heap)
    heap = []
    
    for x, y in points:
        dist = -(x*x + y*y)  # Negative for max heap
        
        if len(heap) < k:
            heapq.heappush(heap, (dist, x, y))
        elif dist > heap[0][0]:
            heapq.heapreplace(heap, (dist, x, y))
    
    return [[x, y] for dist, x, y in heap]
```

---

### 6. **692. Top K Frequent Words** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/top-k-frequent-words/

**Description**: Find k most frequent words, lexicographically sorted if tie.

**Key Concepts**:
- Min heap with custom comparator
- Frequency + lexicographic order
- Tuple comparison in Python

**Why Important**: Complex heap comparator

**Time**: O(n log k) | **Space**: O(n)

```python
# Template
import heapq
from collections import Counter

class Word:
    def __init__(self, word, freq):
        self.word = word
        self.freq = freq
    
    def __lt__(self, other):
        # Min heap: lower frequency first, higher lexicographic first
        if self.freq != other.freq:
            return self.freq < other.freq
        return self.word > other.word

def topKFrequent(words, k):
    count = Counter(words)
    heap = []
    
    for word, freq in count.items():
        heapq.heappush(heap, Word(word, freq))
        if len(heap) > k:
            heapq.heappop(heap)
    
    result = [heapq.heappop(heap).word for _ in range(len(heap))]
    return result[::-1]
```

---

### 7. **295. Find Median from Data Stream** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/find-median-from-data-stream/

**Description**: Design a data structure to find median from a stream.

**Key Concepts**:
- Two heaps: max heap (left half) + min heap (right half)
- Balance heaps to keep sizes equal or differ by 1
- Median is at heap tops

**Why Important**: THE classic two-heap problem

**Time**: O(log n) per add, O(1) per median | **Space**: O(n)

```python
# Template
import heapq

class MedianFinder:
    def __init__(self):
        self.small = []  # Max heap (negate values)
        self.large = []  # Min heap
    
    def addNum(self, num):
        # Add to max heap (small)
        heapq.heappush(self.small, -num)
        
        # Balance: move largest from small to large
        heapq.heappush(self.large, -heapq.heappop(self.small))
        
        # Balance sizes
        if len(self.large) > len(self.small):
            heapq.heappush(self.small, -heapq.heappop(self.large))
    
    def findMedian(self):
        if len(self.small) > len(self.large):
            return -self.small[0]
        return (-self.small[0] + self.large[0]) / 2
```

---

### 8. **23. Merge k Sorted Lists** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/merge-k-sorted-lists/

**Description**: Merge k sorted linked lists into one sorted list.

**Key Concepts**:
- Min heap with list nodes
- Extract min repeatedly
- Heap of (value, node)

**Why Important**: Classic heap merging problem

**Time**: O(N log k) where N = total nodes | **Space**: O(k)

```python
# Template
import heapq

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def mergeKLists(lists):
    heap = []
    
    # Add first node from each list
    for i, node in enumerate(lists):
        if node:
            heapq.heappush(heap, (node.val, i, node))
    
    dummy = ListNode(0)
    current = dummy
    
    while heap:
        val, i, node = heapq.heappop(heap)
        current.next = node
        current = current.next
        
        if node.next:
            heapq.heappush(heap, (node.next.val, i, node.next))
    
    return dummy.next
```

---

### 9. **378. Kth Smallest Element in a Sorted Matrix** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/

**Description**: Find kth smallest element in row and column sorted matrix.

**Key Concepts**:
- Min heap with matrix indices
- Merge k sorted arrays pattern
- Or binary search approach

**Why Important**: Heap on 2D structure

**Time**: O(k log n) | **Space**: O(n)

```python
# Template
import heapq

def kthSmallest(matrix, k):
    n = len(matrix)
    heap = []
    
    # Add first element from each row
    for r in range(min(n, k)):
        heapq.heappush(heap, (matrix[r][0], r, 0))
    
    result = 0
    for _ in range(k):
        result, r, c = heapq.heappop(heap)
        
        if c + 1 < n:
            heapq.heappush(heap, (matrix[r][c + 1], r, c + 1))
    
    return result
```

---

### 10. **767. Reorganize String** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/reorganize-string/

**Description**: Rearrange string so no two adjacent characters are same.

**Key Concepts**:
- Max heap by frequency
- Greedy: always pick most frequent
- Cooldown pattern

**Why Important**: Heap for greedy scheduling

**Time**: O(n log k) where k = unique chars | **Space**: O(k)

```python
# Template
import heapq
from collections import Counter

def reorganizeString(s):
    count = Counter(s)
    
    # Max heap (negate frequencies)
    heap = [(-freq, char) for char, freq in count.items()]
    heapq.heapify(heap)
    
    result = []
    prev_freq, prev_char = 0, ''
    
    while heap:
        freq, char = heapq.heappop(heap)
        result.append(char)
        
        # Add previous back if still has frequency
        if prev_freq < 0:
            heapq.heappush(heap, (prev_freq, prev_char))
        
        # Update previous
        prev_freq, prev_char = freq + 1, char
    
    result_str = ''.join(result)
    return result_str if len(result_str) == len(s) else ""
```

---

## Hard Problems

### 11. **502. IPO** ⭐⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/ipo/

**Description**: Maximize capital by selecting at most k projects.

**Key Concepts**:
- Two heaps: available projects (by capital) and profitable projects (by profit)
- Greedy selection
- Dynamic heap updates

**Why Important**: Complex two-heap problem

**Time**: O(n log n) | **Space**: O(n)

```python
# Template
import heapq

def findMaximizedCapital(k, w, profits, capital):
    projects = sorted(zip(capital, profits))
    available = []  # Max heap of profits
    i = 0
    
    for _ in range(k):
        # Add all affordable projects
        while i < len(projects) and projects[i][0] <= w:
            heapq.heappush(available, -projects[i][1])
            i += 1
        
        if not available:
            break
        
        # Pick most profitable
        w += -heapq.heappop(available)
    
    return w
```

---

### 12. **480. Sliding Window Median** ⭐⭐⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/sliding-window-median/

**Description**: Find median in each sliding window of size k.

**Key Concepts**:
- Two heaps (like problem 295)
- Remove elements from heaps (lazy deletion)
- Rebalance after each slide

**Why Important**: Most complex heap problem

**Time**: O(n log k) | **Space**: O(k)

```python
# Template (Complex - study carefully)
import heapq
from collections import defaultdict

def medianSlidingWindow(nums, k):
    small = []  # Max heap
    large = []  # Min heap
    removed = defaultdict(int)
    
    def balance():
        # Move from small to large
        while small and (not large or len(small) > len(large) + 1):
            heapq.heappush(large, -heapq.heappop(small))
        
        # Move from large to small
        while large and len(large) > len(small):
            heapq.heappush(small, -heapq.heappop(large))
    
    def clean_top(heap, sign):
        while heap and removed[sign * heap[0]] > 0:
            removed[sign * heap[0]] -= 1
            heapq.heappop(heap)
    
    def get_median():
        if k % 2 == 1:
            return -small[0]
        return (-small[0] + large[0]) / 2
    
    # Initialize first window
    for i in range(k):
        heapq.heappush(small, -nums[i])
    balance()
    
    result = [get_median()]
    
    # Slide window
    for i in range(k, len(nums)):
        # Remove outgoing element
        out_num = nums[i - k]
        removed[out_num] += 1
        
        # Add incoming element
        if small and nums[i] <= -small[0]:
            heapq.heappush(small, -nums[i])
        else:
            heapq.heappush(large, nums[i])
        
        # Clean and balance
        clean_top(small, -1)
        clean_top(large, 1)
        balance()
        
        result.append(get_median())
    
    return result
```

---

## Problem Categories

### 🎯 Category 1: Basic Heap Operations
**Focus**: Learn heap push, pop, heapify
- 703. Kth Largest in Stream
- 1046. Last Stone Weight

**Skills**: Basic heap manipulation

---

### 🎯 Category 2: Top K Elements
**Focus**: Maintain k largest/smallest elements
- 215. Kth Largest Element ⭐ MOST IMPORTANT
- 347. Top K Frequent Elements
- 973. K Closest Points
- 692. Top K Frequent Words

**Skills**: Min/max heap of size k, custom comparators

---

### 🎯 Category 3: Two Heaps
**Focus**: Maintain two heaps for median/balance
- 295. Find Median from Data Stream ⭐ CRITICAL
- 480. Sliding Window Median

**Skills**: Balancing heaps, median calculation

---

### 🎯 Category 4: Merge K Sorted
**Focus**: Merge multiple sorted sequences
- 23. Merge k Sorted Lists ⭐ CRITICAL
- 378. Kth Smallest in Sorted Matrix

**Skills**: Heap for merging, tracking indices

---

### 🎯 Category 5: Greedy with Heap
**Focus**: Greedy selection using heap
- 767. Reorganize String
- 502. IPO

**Skills**: Greedy algorithms, heap for priority

---

## Learning Path

### 🌱 Week 1: Heap Basics (Easy)
**Goal**: Understand heap operations

1. **Day 1-2**: 703. Kth Largest in Stream
   - Min heap of size k
   - Push and pop operations

2. **Day 3-4**: 1046. Last Stone Weight
   - Max heap simulation
   - Python heap tricks (negate for max)

3. **Day 5-7**: Practice and review

---

### 🌿 Week 2: Top K Problems (Medium)
**Goal**: Master top k pattern

1. **Day 1-3**: 215. Kth Largest Element ⭐ CRITICAL!
   - Min heap approach
   - HeapSort approach
   - Compare with QuickSelect

2. **Day 4-5**: 347. Top K Frequent Elements
   - HashMap + Heap
   - Frequency-based heap

3. **Day 6-7**: 973. K Closest Points
   - Custom distance calculation
   - Max heap of size k

---

### 🌳 Week 3: Advanced Patterns (Medium-Hard)
**Goal**: Two heaps and merging

1. **Day 1-4**: 295. Find Median from Data Stream ⭐ CRITICAL!
   - Two heap technique
   - Balancing heaps
   - This is THE interview question

2. **Day 5-7**: 23. Merge k Sorted Lists
   - Min heap for merging
   - Linked list with heap

---

### 🌲 Week 4: Complex Applications (Hard)
**Goal**: Master advanced heap problems

1. **Day 1-3**: 692. Top K Frequent Words
   - Custom comparator
   - Lexicographic ordering

2. **Day 4-5**: 767. Reorganize String
   - Greedy with heap
   - Cooldown pattern

3. **Day 6-7**: 480. Sliding Window Median (Optional)
   - Most complex
   - Lazy deletion

---

## Pattern Recognition

### Pattern 1: Top K Elements (Min Heap of Size K)
**When to use**: Find k largest/smallest/most frequent

**Template**:
```python
import heapq

def topK(arr, k):
    heap = []
    
    for item in arr:
        heapq.heappush(heap, item)  # Or (priority, item)
        if len(heap) > k:
            heapq.heappop(heap)
    
    return heap
```

**Problems**: 215, 347, 973, 692, 703

---

### Pattern 2: Two Heaps (Median)
**When to use**: Find median or split data into two halves

**Template**:
```python
import heapq

class MedianFinder:
    def __init__(self):
        self.small = []  # Max heap (left half)
        self.large = []  # Min heap (right half)
    
    def addNum(self, num):
        heapq.heappush(self.small, -num)
        heapq.heappush(self.large, -heapq.heappop(self.small))
        
        if len(self.large) > len(self.small):
            heapq.heappush(self.small, -heapq.heappop(self.large))
    
    def findMedian(self):
        if len(self.small) > len(self.large):
            return -self.small[0]
        return (-self.small[0] + self.large[0]) / 2
```

**Problems**: 295, 480

---

### Pattern 3: Merge K Sorted
**When to use**: Merge multiple sorted sequences

**Template**:
```python
import heapq

def mergeKSorted(lists):
    heap = []
    
    # Initialize heap with first element from each list
    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(heap, (lst[0], i, 0))
    
    result = []
    
    while heap:
        val, list_idx, elem_idx = heapq.heappop(heap)
        result.append(val)
        
        # Add next element from same list
        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(heap, (next_val, list_idx, elem_idx + 1))
    
    return result
```

**Problems**: 23, 378

---

### Pattern 4: Greedy with Heap
**When to use**: Always pick best available option

**Template**:
```python
import heapq

def greedyWithHeap(items):
    heap = []
    
    for item in items:
        heapq.heappush(heap, (-priority(item), item))
    
    result = []
    
    while heap and can_pick():
        priority, item = heapq.heappop(heap)
        result.append(item)
        
        # May add back with updated priority
        if should_add_back(item):
            heapq.heappush(heap, (new_priority(item), item))
    
    return result
```

**Problems**: 767, 502

---

## Quick Reference Table

| # | Problem | Difficulty | Pattern | Priority | Time | Space |
|---|---------|------------|---------|----------|------|-------|
| 703 | Kth Largest in Stream | Easy | Top K | ⭐⭐⭐ | O(log k) | O(k) |
| 1046 | Last Stone Weight | Easy | Basic | ⭐⭐ | O(n log n) | O(n) |
| 215 | Kth Largest Element | Medium | Top K | ⭐⭐⭐⭐⭐ | O(n log k) | O(k) |
| 347 | Top K Frequent | Medium | Top K | ⭐⭐⭐⭐ | O(n log k) | O(n) |
| 973 | K Closest Points | Medium | Top K | ⭐⭐⭐⭐ | O(n log k) | O(k) |
| 692 | Top K Frequent Words | Medium | Top K | ⭐⭐⭐⭐ | O(n log k) | O(n) |
| 295 | Find Median Stream | Hard | Two Heaps | ⭐⭐⭐⭐⭐ | O(log n) | O(n) |
| 23 | Merge k Sorted Lists | Hard | Merge K | ⭐⭐⭐⭐⭐ | O(N log k) | O(k) |
| 378 | Kth in Sorted Matrix | Medium | Merge K | ⭐⭐⭐⭐ | O(k log n) | O(n) |
| 767 | Reorganize String | Medium | Greedy | ⭐⭐⭐⭐ | O(n log k) | O(k) |
| 502 | IPO | Hard | Greedy | ⭐⭐⭐⭐ | O(n log n) | O(n) |
| 480 | Sliding Window Median | Hard | Two Heaps | ⭐⭐⭐⭐⭐ | O(n log k) | O(k) |

---

## Top 5 Must-Do for Interviews

1. **295. Find Median from Data Stream** - Most common two-heap question
2. **215. Kth Largest Element** - Classic top k problem
3. **23. Merge k Sorted Lists** - Classic merge k problem
4. **347. Top K Frequent Elements** - Frequency + heap
5. **973. K Closest Points to Origin** - Custom comparator

---

## Tips for Success

### 1. Python Heap is Min Heap
- For max heap: negate values
- `heapq.heappush(heap, -value)`
- Remember to negate when popping

### 2. Top K Largest → Min Heap
- Keep k largest elements
- Min heap ensures smallest of k largest is at top
- Easy to remove when new larger element comes

### 3. Two Heaps for Median
- Max heap (left half) + Min heap (right half)
- Keep sizes balanced (differ by at most 1)
- Median is at heap tops

### 4. Custom Comparator
- Use tuples: `(priority, value)`
- Or create class with `__lt__` method
- Python compares tuples element by element

### 5. Heap vs HeapSort
- Heap (data structure): For top k, median, merging
- HeapSort (algorithm): For full sorting
- Different use cases!

---

## Common Mistakes to Avoid

1. ❌ Forgetting to negate for max heap in Python
2. ❌ Using max heap for top k largest (should use min heap)
3. ❌ Not balancing two heaps properly in median problems
4. ❌ Forgetting to handle empty heap cases
5. ❌ Not using `heapq.heapify()` for initial heap creation (O(n) vs O(n log n))

---

## Heap vs Other Sorting Algorithms

| Aspect | Heap | QuickSort | MergeSort |
|--------|------|-----------|-----------|
| **Top K** | O(n log k) ⭐ | O(n) avg | O(n log n) |
| **Full Sort** | O(n log n) | O(n log n) avg | O(n log n) |
| **Space** | O(k) or O(1) | O(log n) | O(n) |
| **Stability** | Not stable | Not stable | Stable |
| **Best For** | Top k, median | In-place sort | Stable sort |
| **Streaming** | Yes ⭐ | No | No |

---

## When to Use Heap vs QuickSelect

### Use Heap When:
- Need top k elements (not just kth)
- Streaming data (elements come one by one)
- Need to maintain top k dynamically
- Multiple queries

### Use QuickSelect When:
- Only need kth element (not all top k)
- All data available at once
- One-time query
- Want O(n) average time

---

## Advanced Topics

### 1. Lazy Deletion
- Mark elements as deleted without removing
- Clean up when accessing top
- Used in sliding window median

### 2. Indexed Heap
- Track element positions in heap
- Allows O(log n) update/delete
- Complex but powerful

### 3. Fibonacci Heap
- Better amortized time for decrease-key
- Used in Dijkstra's algorithm
- Theoretical importance

---

## Progress Tracker

```
Easy Problems:
[ ] 703. Kth Largest in Stream
[ ] 1046. Last Stone Weight

Medium Problems:
[ ] 215. Kth Largest Element ⭐ MUST DO
[ ] 347. Top K Frequent Elements
[ ] 973. K Closest Points
[ ] 692. Top K Frequent Words
[ ] 378. Kth in Sorted Matrix
[ ] 767. Reorganize String

Hard Problems:
[ ] 295. Find Median Stream ⭐ MUST DO
[ ] 23. Merge k Sorted Lists ⭐ MUST DO
[ ] 502. IPO
[ ] 480. Sliding Window Median
```

---

## Next Steps

After mastering heap problems:
1. Study priority queue applications
2. Learn about advanced heap variants
3. Practice graph algorithms using heaps (Dijkstra, Prim)
4. Combine heaps with other data structures

---

**Good luck with your practice! 🚀**

Remember: Heaps are perfect for "top k" and "median" problems!
