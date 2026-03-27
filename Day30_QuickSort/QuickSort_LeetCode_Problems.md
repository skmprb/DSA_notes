# LeetCode Problems on QuickSort
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

### 1. **912. Sort an Array** ⭐⭐⭐
**Difficulty**: Medium (but good for practice)  
**Link**: https://leetcode.com/problems/sort-an-array/

**Description**: Sort an array using any O(n log n) algorithm.

**Key Concepts**:
- Implement QuickSort from scratch
- Partition algorithm
- Random pivot to avoid worst case

**Why Important**: Pure QuickSort implementation practice

**Time**: O(n log n) average, O(n²) worst | **Space**: O(log n)

```python
# Template
import random

def sortArray(nums):
    def quickSort(arr, low, high):
        if low < high:
            p = partition(arr, low, high)
            quickSort(arr, low, p - 1)
            quickSort(arr, p + 1, high)
    
    def partition(arr, low, high):
        # Random pivot to avoid worst case
        pivot_idx = random.randint(low, high)
        arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
        
        pivot = arr[high]
        i = low - 1
        
        for j in range(low, high):
            if arr[j] <= pivot:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1
    
    quickSort(nums, 0, len(nums) - 1)
    return nums
```

---

## Medium Problems

### 2. **215. Kth Largest Element in an Array** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/kth-largest-element-in-an-array/

**Description**: Find the kth largest element in an unsorted array.

**Key Concepts**:
- QuickSelect algorithm (partial QuickSort)
- Partition once, recurse on one side only
- O(n) average time complexity

**Why Important**: THE classic QuickSelect interview question

**Time**: O(n) average, O(n²) worst | **Space**: O(1)

```python
# Template
import random

def findKthLargest(nums, k):
    def quickSelect(arr, low, high, k):
        if low == high:
            return arr[low]
        
        p = partition(arr, low, high)
        
        if k == p:
            return arr[k]
        elif k < p:
            return quickSelect(arr, low, p - 1, k)
        else:
            return quickSelect(arr, p + 1, high, k)
    
    def partition(arr, low, high):
        pivot_idx = random.randint(low, high)
        arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
        
        pivot = arr[high]
        i = low - 1
        
        for j in range(low, high):
            if arr[j] <= pivot:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1
    
    n = len(nums)
    return quickSelect(nums, 0, n - 1, n - k)
```

---

### 3. **973. K Closest Points to Origin** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/k-closest-points-to-origin/

**Description**: Find k closest points to origin (0, 0).

**Key Concepts**:
- QuickSelect with custom comparator
- Partition by distance
- Partial sorting

**Why Important**: QuickSelect with custom comparison

**Time**: O(n) average | **Space**: O(1)

```python
# Template
import random

def kClosest(points, k):
    def distance(point):
        return point[0]**2 + point[1]**2
    
    def partition(arr, low, high):
        pivot_idx = random.randint(low, high)
        arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
        
        pivot_dist = distance(arr[high])
        i = low - 1
        
        for j in range(low, high):
            if distance(arr[j]) <= pivot_dist:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1
    
    def quickSelect(arr, low, high, k):
        if low >= high:
            return
        
        p = partition(arr, low, high)
        
        if k == p:
            return
        elif k < p:
            quickSelect(arr, low, p - 1, k)
        else:
            quickSelect(arr, p + 1, high, k)
    
    quickSelect(points, 0, len(points) - 1, k - 1)
    return points[:k]
```

---

### 4. **347. Top K Frequent Elements** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/top-k-frequent-elements/

**Description**: Find k most frequent elements.

**Key Concepts**:
- QuickSelect on frequency array
- HashMap + QuickSelect
- Alternative to heap approach

**Why Important**: Combines counting with QuickSelect

**Time**: O(n) average | **Space**: O(n)

```python
# Template
import random
from collections import Counter

def topKFrequent(nums, k):
    count = Counter(nums)
    unique = list(count.keys())
    
    def partition(arr, low, high):
        pivot_idx = random.randint(low, high)
        arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
        
        pivot_freq = count[arr[high]]
        i = low - 1
        
        for j in range(low, high):
            if count[arr[j]] <= pivot_freq:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1
    
    def quickSelect(arr, low, high, k):
        if low == high:
            return
        
        p = partition(arr, low, high)
        
        if k == p:
            return
        elif k < p:
            quickSelect(arr, low, p - 1, k)
        else:
            quickSelect(arr, p + 1, high, k)
    
    n = len(unique)
    quickSelect(unique, 0, n - 1, n - k)
    return unique[n - k:]
```

---

### 5. **75. Sort Colors** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/sort-colors/

**Description**: Sort array with only 0s, 1s, and 2s (Dutch National Flag problem).

**Key Concepts**:
- Three-way partitioning
- Extension of QuickSort partition
- One-pass algorithm

**Why Important**: Classic three-way partition problem

**Time**: O(n) | **Space**: O(1)

```python
# Template
def sortColors(nums):
    low, mid, high = 0, 0, len(nums) - 1
    
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

---

### 6. **324. Wiggle Sort II** ⭐⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/wiggle-sort-ii/

**Description**: Rearrange array so nums[0] < nums[1] > nums[2] < nums[3]...

**Key Concepts**:
- Find median using QuickSelect
- Three-way partition around median
- Virtual indexing

**Why Important**: Advanced QuickSelect application

**Time**: O(n) average | **Space**: O(1)

```python
# Template
def wiggleSort(nums):
    # Find median using QuickSelect
    n = len(nums)
    median = findKthLargest(nums, (n + 1) // 2)
    
    # Three-way partition with virtual indexing
    def index(i):
        return (1 + 2 * i) % (n | 1)
    
    low, mid, high = 0, 0, n - 1
    
    while mid <= high:
        if nums[index(mid)] > median:
            nums[index(low)], nums[index(mid)] = nums[index(mid)], nums[index(low)]
            low += 1
            mid += 1
        elif nums[index(mid)] < median:
            nums[index(mid)], nums[index(high)] = nums[index(high)], nums[index(mid)]
            high -= 1
        else:
            mid += 1
```

---

## Hard Problems

### 7. **4. Median of Two Sorted Arrays** ⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/median-of-two-sorted-arrays/

**Description**: Find median of two sorted arrays in O(log(m+n)).

**Key Concepts**:
- Binary search (similar to QuickSelect thinking)
- Partition both arrays
- Divide and conquer

**Why Important**: Uses QuickSelect-like partitioning concept

**Time**: O(log(min(m,n))) | **Space**: O(1)

---

### 8. **162. Find Peak Element** ⭐⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/find-peak-element/

**Description**: Find a peak element in O(log n).

**Key Concepts**:
- Binary search (QuickSort-like divide & conquer)
- Partition search space
- Similar thinking to QuickSelect

**Why Important**: Divide & conquer pattern

**Time**: O(log n) | **Space**: O(1)

```python
# Template
def findPeakElement(nums):
    left, right = 0, len(nums) - 1
    
    while left < right:
        mid = (left + right) // 2
        
        if nums[mid] > nums[mid + 1]:
            right = mid
        else:
            left = mid + 1
    
    return left
```

---

### 9. **Quick Sort on Linked List** ⭐⭐⭐⭐
**Difficulty**: Medium (not on LeetCode, but common interview)

**Description**: Implement QuickSort on a linked list.

**Key Concepts**:
- Partition linked list
- Last node as pivot
- Recursive sorting

**Why Important**: Tests deep understanding of QuickSort

**Time**: O(n log n) average | **Space**: O(log n)

```python
# Template
def quickSortList(head):
    if not head or not head.next:
        return head
    
    # Partition
    pivot = head
    smaller = smaller_tail = ListNode(0)
    equal = equal_tail = ListNode(0)
    larger = larger_tail = ListNode(0)
    
    curr = head
    while curr:
        if curr.val < pivot.val:
            smaller_tail.next = curr
            smaller_tail = curr
        elif curr.val == pivot.val:
            equal_tail.next = curr
            equal_tail = curr
        else:
            larger_tail.next = curr
            larger_tail = curr
        curr = curr.next
    
    smaller_tail.next = equal_tail.next = larger_tail.next = None
    
    # Recursively sort
    smaller.next = quickSortList(smaller.next)
    larger.next = quickSortList(larger.next)
    
    # Concatenate
    # Find tail of smaller
    curr = smaller
    while curr.next:
        curr = curr.next
    curr.next = equal.next
    
    # Find tail of equal
    while curr.next:
        curr = curr.next
    curr.next = larger.next
    
    return smaller.next
```

---

## Problem Categories

### 🎯 Category 1: Full QuickSort Implementation
**Focus**: Implement complete QuickSort
- 912. Sort an Array
- Quick Sort on Linked List

**Skills**: Partition, recursion, pivot selection

---

### 🎯 Category 2: QuickSelect (Kth Element)
**Focus**: Find kth element without full sorting
- 215. Kth Largest Element ⭐ MOST IMPORTANT
- 973. K Closest Points to Origin
- 347. Top K Frequent Elements

**Skills**: Partial sorting, one-sided recursion, O(n) average time

---

### 🎯 Category 3: Three-Way Partitioning
**Focus**: Partition into three sections
- 75. Sort Colors (Dutch National Flag)
- 324. Wiggle Sort II

**Skills**: Three pointers, handling duplicates

---

### 🎯 Category 4: Divide & Conquer Pattern
**Focus**: Use QuickSort's recursive structure
- 162. Find Peak Element
- 4. Median of Two Sorted Arrays

**Skills**: Binary search, partitioning search space

---

## Learning Path

### 🌱 Week 1: Master Partition (Easy-Medium)
**Goal**: Understand partition algorithm perfectly

1. **Day 1-3**: 912. Sort an Array
   - Implement basic QuickSort
   - Practice partition algorithm
   - Try different pivot strategies

2. **Day 4-5**: 75. Sort Colors
   - Three-way partitioning
   - Dutch National Flag problem
   - One-pass solution

3. **Day 6-7**: Review and practice variations

---

### 🌿 Week 2: QuickSelect Mastery (Medium)
**Goal**: Master QuickSelect for kth element problems

1. **Day 1-4**: 215. Kth Largest Element ⭐ CRITICAL!
   - Understand QuickSelect
   - Random pivot to avoid TLE
   - Practice until you can code it blindfolded

2. **Day 5-7**: 973. K Closest Points to Origin
   - QuickSelect with custom comparator
   - Distance calculation
   - Partial sorting

---

### 🌳 Week 3: Advanced QuickSelect (Medium-Hard)
**Goal**: Apply QuickSelect to complex problems

1. **Day 1-3**: 347. Top K Frequent Elements
   - Combine HashMap with QuickSelect
   - Frequency-based partition

2. **Day 4-7**: 324. Wiggle Sort II
   - Find median with QuickSelect
   - Three-way partition
   - Virtual indexing (advanced)

---

### 🌲 Week 4: Advanced Applications (Hard)
**Goal**: Master advanced patterns

1. **Day 1-3**: Quick Sort on Linked List
   - Partition linked list
   - Recursive sorting
   - Concatenation

2. **Day 4-5**: 162. Find Peak Element
   - Binary search pattern
   - Divide & conquer

3. **Day 6-7**: Review all problems

---

## Pattern Recognition

### Pattern 1: Full QuickSort
**When to use**: Need to sort entire array in-place

**Template**:
```python
import random

def quickSort(arr, low, high):
    if low < high:
        p = partition(arr, low, high)
        quickSort(arr, low, p - 1)
        quickSort(arr, p + 1, high)

def partition(arr, low, high):
    # Random pivot
    pivot_idx = random.randint(low, high)
    arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
    
    pivot = arr[high]
    i = low - 1
    
    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1
```

**Problems**: 912

---

### Pattern 2: QuickSelect (Kth Element)
**When to use**: Find kth largest/smallest without full sorting

**Template**:
```python
import random

def quickSelect(arr, low, high, k):
    if low == high:
        return arr[low]
    
    p = partition(arr, low, high)
    
    if k == p:
        return arr[k]
    elif k < p:
        return quickSelect(arr, low, p - 1, k)
    else:
        return quickSelect(arr, p + 1, high, k)

def partition(arr, low, high):
    pivot_idx = random.randint(low, high)
    arr[pivot_idx], arr[high] = arr[high], arr[pivot_idx]
    
    pivot = arr[high]
    i = low - 1
    
    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1
```

**Problems**: 215, 973, 347

---

### Pattern 3: Three-Way Partition
**When to use**: Array with many duplicates or three distinct values

**Template**:
```python
def threeWayPartition(arr, target):
    low, mid, high = 0, 0, len(arr) - 1
    
    while mid <= high:
        if arr[mid] < target:
            arr[low], arr[mid] = arr[mid], arr[low]
            low += 1
            mid += 1
        elif arr[mid] == target:
            mid += 1
        else:  # arr[mid] > target
            arr[mid], arr[high] = arr[high], arr[mid]
            high -= 1
```

**Problems**: 75, 324

---

## Quick Reference Table

| # | Problem | Difficulty | Pattern | Priority | Time | Space |
|---|---------|------------|---------|----------|------|-------|
| 912 | Sort an Array | Medium | Full Sort | ⭐⭐⭐ | O(n log n) | O(log n) |
| 215 | Kth Largest Element | Medium | QuickSelect | ⭐⭐⭐⭐⭐ | O(n) avg | O(1) |
| 973 | K Closest Points | Medium | QuickSelect | ⭐⭐⭐⭐ | O(n) avg | O(1) |
| 347 | Top K Frequent | Medium | QuickSelect | ⭐⭐⭐⭐ | O(n) avg | O(n) |
| 75 | Sort Colors | Medium | 3-Way | ⭐⭐⭐⭐⭐ | O(n) | O(1) |
| 324 | Wiggle Sort II | Medium | 3-Way | ⭐⭐⭐⭐ | O(n) avg | O(1) |
| 162 | Find Peak Element | Medium | D&C | ⭐⭐⭐ | O(log n) | O(1) |

---

## Top 5 Must-Do for Interviews

1. **215. Kth Largest Element** - Most common QuickSelect question
2. **75. Sort Colors** - Classic three-way partition
3. **973. K Closest Points to Origin** - QuickSelect with custom comparator
4. **347. Top K Frequent Elements** - Combines counting with QuickSelect
5. **912. Sort an Array** - Full QuickSort implementation

---

## Tips for Success

### 1. Always Use Random Pivot
- Avoids O(n²) worst case on sorted/duplicate arrays
- Critical for passing LeetCode tests
- Import random module

### 2. Master the Partition
- Understand `i = low - 1` (boundary of smaller elements)
- Know why pivot goes at `i + 1`
- Practice until it's muscle memory

### 3. QuickSelect vs QuickSort
- QuickSelect: Recurse on ONE side only → O(n) average
- QuickSort: Recurse on BOTH sides → O(n log n)

### 4. Handle Duplicates
- Use `<=` in partition for stability
- Consider three-way partition for many duplicates
- Test with all same values

### 5. Base Case
- `if low < high` for QuickSort
- `if low == high` for QuickSelect
- Don't forget!

---

## Common Mistakes to Avoid

1. ❌ Using first/last element as pivot without randomization (TLE on sorted arrays)
2. ❌ Forgetting `i = low - 1` (using `i = low` causes bugs)
3. ❌ Using `partition(arr, 0, high)` instead of `partition(arr, low, high)` in recursion
4. ❌ Including pivot in recursive calls: `quickSort(arr, low, p)` should be `quickSort(arr, low, p-1)`
5. ❌ Using `<` instead of `<=` in partition (causes issues with duplicates)

---

## Key Differences: QuickSort vs MergeSort

| Aspect | QuickSort | MergeSort |
|--------|-----------|-----------|
| **Partition** | Before recursion | After recursion (merge) |
| **Space** | O(log n) in-place | O(n) extra space |
| **Stability** | Not stable | Stable |
| **Worst Case** | O(n²) | O(n log n) |
| **Best For** | Arrays, in-place | Linked lists, stable sort |
| **Pivot** | Critical choice | No pivot |
| **Practical** | Usually faster | More predictable |

---

## Advanced Topics

### 1. Median of Medians (Guaranteed O(n))
- Deterministic pivot selection
- Guarantees O(n) worst case for QuickSelect
- Complex but theoretically important

### 2. Dual-Pivot QuickSort
- Used in Java's Arrays.sort()
- Two pivots instead of one
- Better performance in practice

### 3. Introsort (Hybrid)
- Starts with QuickSort
- Switches to HeapSort if recursion depth exceeds limit
- Used in C++ std::sort()

---

## Progress Tracker

```
Easy/Medium Problems:
[ ] 912. Sort an Array
[ ] 215. Kth Largest Element ⭐ MUST DO
[ ] 973. K Closest Points to Origin
[ ] 347. Top K Frequent Elements
[ ] 75. Sort Colors ⭐ MUST DO
[ ] 324. Wiggle Sort II

Advanced:
[ ] 162. Find Peak Element
[ ] Quick Sort on Linked List
```

---

## Next Steps

After mastering QuickSort problems:
1. Compare with HeapSort for kth element problems
2. Study hybrid sorting algorithms
3. Learn about external sorting
4. Practice choosing right algorithm for each problem

---

**Good luck with your practice! 🚀**

Remember: QuickSort is about smart partitioning and choosing the right pivot!
