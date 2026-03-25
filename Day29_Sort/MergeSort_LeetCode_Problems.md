# LeetCode Problems on Merge Sort
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

### 1. **88. Merge Sorted Array** ⭐⭐⭐
**Difficulty**: Easy  
**Link**: https://leetcode.com/problems/merge-sorted-array/

**Description**: Merge two sorted arrays in-place.

**Key Concepts**:
- Merge logic from merge sort
- Two pointers
- In-place merging (right to left)

**Why Important**: Foundation of merge sort's merge operation

**Time**: O(m + n) | **Space**: O(1)

```python
# Template
def merge(nums1, m, nums2, n):
    i, j, k = m - 1, n - 1, m + n - 1
    while j >= 0:
        if i >= 0 and nums1[i] > nums2[j]:
            nums1[k] = nums1[i]
            i -= 1
        else:
            nums1[k] = nums2[j]
            j -= 1
        k -= 1
```

---

### 2. **21. Merge Two Sorted Lists** ⭐⭐⭐
**Difficulty**: Easy  
**Link**: https://leetcode.com/problems/merge-two-sorted-lists/

**Description**: Merge two sorted linked lists.

**Key Concepts**:
- Same merge logic as merge sort
- Linked list manipulation
- Dummy node technique

**Why Important**: Merge sort works great on linked lists

**Time**: O(m + n) | **Space**: O(1)

```python
# Template
def mergeTwoLists(l1, l2):
    dummy = ListNode(0)
    current = dummy
    
    while l1 and l2:
        if l1.val <= l2.val:
            current.next = l1
            l1 = l1.next
        else:
            current.next = l2
            l2 = l2.next
        current = current.next
    
    current.next = l1 or l2
    return dummy.next
```

---

## Medium Problems

### 3. **148. Sort List** ⭐⭐⭐⭐⭐ (MUST DO!)
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/sort-list/

**Description**: Sort a linked list using O(n log n) time and O(1) space.

**Key Concepts**:
- Complete merge sort on linked list
- Finding middle using slow/fast pointers
- Bottom-up merge sort for O(1) space

**Why Important**: THE classic merge sort interview question

**Time**: O(n log n) | **Space**: O(log n) recursive, O(1) iterative

```python
# Template (Top-down)
def sortList(head):
    if not head or not head.next:
        return head
    
    # Find middle
    slow, fast = head, head.next
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    # Split
    mid = slow.next
    slow.next = None
    
    # Sort both halves
    left = sortList(head)
    right = sortList(mid)
    
    # Merge
    return merge(left, right)
```

---

### 4. **912. Sort an Array** ⭐⭐
**Difficulty**: Medium  
**Link**: https://leetcode.com/problems/sort-an-array/

**Description**: Sort an array using any O(n log n) algorithm.

**Key Concepts**:
- Implement merge sort from scratch
- Good for practicing the algorithm

**Why Important**: Pure merge sort implementation practice

**Time**: O(n log n) | **Space**: O(n)

```python
# Template
def sortArray(nums):
    if len(nums) <= 1:
        return nums
    
    mid = len(nums) // 2
    left = sortArray(nums[:mid])
    right = sortArray(nums[mid:])
    
    return merge(left, right)
```

---

### 5. **23. Merge k Sorted Lists** ⭐⭐⭐⭐
**Difficulty**: Hard (but Medium difficulty)  
**Link**: https://leetcode.com/problems/merge-k-sorted-lists/

**Description**: Merge k sorted linked lists into one sorted list.

**Key Concepts**:
- Divide and conquer (merge sort approach)
- Or use min heap
- Merging multiple sorted sequences

**Why Important**: Tests understanding of merge operation

**Time**: O(N log k) where N = total nodes | **Space**: O(log k)

```python
# Template (Divide & Conquer)
def mergeKLists(lists):
    if not lists:
        return None
    
    while len(lists) > 1:
        merged = []
        for i in range(0, len(lists), 2):
            l1 = lists[i]
            l2 = lists[i + 1] if i + 1 < len(lists) else None
            merged.append(mergeTwoLists(l1, l2))
        lists = merged
    
    return lists[0]
```

---

### 6. **315. Count of Smaller Numbers After Self** ⭐⭐⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/count-of-smaller-numbers-after-self/

**Description**: Count how many numbers after each element are smaller than it.

**Key Concepts**:
- Modified merge sort with counting
- Inversion count variant
- Index tracking during merge

**Why Important**: Classic merge sort application for counting

**Time**: O(n log n) | **Space**: O(n)

```python
# Template (Complex - study carefully)
def countSmaller(nums):
    def mergeSort(arr):
        if len(arr) <= 1:
            return arr
        
        mid = len(arr) // 2
        left = mergeSort(arr[:mid])
        right = mergeSort(arr[mid:])
        
        return merge(left, right)
    
    def merge(left, right):
        result = []
        i = j = 0
        
        while i < len(left) and j < len(right):
            if left[i][1] <= right[j][1]:
                result.append(left[i])
                # Count elements from right that are smaller
                counts[left[i][0]] += j
                i += 1
            else:
                result.append(right[j])
                j += 1
        
        # Process remaining
        while i < len(left):
            counts[left[i][0]] += j
            result.append(left[i])
            i += 1
        
        result.extend(right[j:])
        return result
    
    counts = [0] * len(nums)
    indexed_nums = [(i, num) for i, num in enumerate(nums)]
    mergeSort(indexed_nums)
    return counts
```

---

### 7. **493. Reverse Pairs** ⭐⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/reverse-pairs/

**Description**: Count pairs (i, j) where i < j and nums[i] > 2 * nums[j].

**Key Concepts**:
- Modified merge sort
- Count during merge phase
- Similar to inversion count

**Why Important**: Another counting application of merge sort

**Time**: O(n log n) | **Space**: O(n)

```python
# Template
def reversePairs(nums):
    def mergeSort(arr, start, end):
        if start >= end:
            return 0
        
        mid = (start + end) // 2
        count = mergeSort(arr, start, mid) + mergeSort(arr, mid + 1, end)
        
        # Count reverse pairs
        j = mid + 1
        for i in range(start, mid + 1):
            while j <= end and arr[i] > 2 * arr[j]:
                j += 1
            count += j - (mid + 1)
        
        # Merge
        merge(arr, start, mid, end)
        return count
    
    return mergeSort(nums, 0, len(nums) - 1)
```

---

### 8. **327. Count of Range Sum** ⭐⭐⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/count-of-range-sum/

**Description**: Count range sums that lie in [lower, upper].

**Key Concepts**:
- Merge sort with prefix sums
- Very advanced application
- Counting during merge

**Why Important**: Most complex merge sort application

**Time**: O(n log n) | **Space**: O(n)

```python
# Template (Very Complex)
def countRangeSum(nums, lower, upper):
    def mergeSort(sums, start, end):
        if start >= end:
            return 0
        
        mid = (start + end) // 2
        count = mergeSort(sums, start, mid) + mergeSort(sums, mid + 1, end)
        
        # Count valid ranges
        j = k = mid + 1
        for i in range(start, mid + 1):
            while j <= end and sums[j] - sums[i] < lower:
                j += 1
            while k <= end and sums[k] - sums[i] <= upper:
                k += 1
            count += k - j
        
        # Merge
        merge(sums, start, mid, end)
        return count
    
    # Build prefix sum array
    prefix = [0]
    for num in nums:
        prefix.append(prefix[-1] + num)
    
    return mergeSort(prefix, 0, len(prefix) - 1)
```

---

## Hard Problems

### 9. **4. Median of Two Sorted Arrays** ⭐⭐⭐
**Difficulty**: Hard  
**Link**: https://leetcode.com/problems/median-of-two-sorted-arrays/

**Description**: Find median of two sorted arrays in O(log(m+n)).

**Key Concepts**:
- Binary search on sorted arrays
- Divide and conquer pattern
- Similar thinking to merge sort

**Why Important**: Uses merge sort's divide & conquer concept

**Time**: O(log(min(m,n))) | **Space**: O(1)

---

## Problem Categories

### 🎯 Category 1: Direct Merge Logic
**Focus**: Practice the merge operation
- 88. Merge Sorted Array
- 21. Merge Two Sorted Lists
- 23. Merge k Sorted Lists

**Skills**: Two pointers, merging sorted sequences

---

### 🎯 Category 2: Full Merge Sort Implementation
**Focus**: Implement complete merge sort
- 912. Sort an Array
- 148. Sort List

**Skills**: Divide & conquer, recursion, merging

---

### 🎯 Category 3: Counting During Merge
**Focus**: Count inversions/pairs while sorting
- 315. Count of Smaller Numbers After Self
- 493. Reverse Pairs
- 327. Count of Range Sum

**Skills**: Modified merge sort, index tracking, counting logic

---

### 🎯 Category 4: Divide & Conquer Pattern
**Focus**: Use merge sort's recursive structure
- 4. Median of Two Sorted Arrays
- 53. Maximum Subarray (can use D&C)
- 169. Majority Element (can use D&C)

**Skills**: Recursive thinking, combining results

---

## Learning Path

### 🌱 Week 1: Master the Merge (Easy)
**Goal**: Understand merge operation perfectly

1. **Day 1-2**: 88. Merge Sorted Array
   - Practice merging from right to left
   - Understand in-place merging

2. **Day 3-4**: 21. Merge Two Sorted Lists
   - Same logic, different data structure
   - Practice with linked lists

3. **Day 5-7**: Review and practice variations

---

### 🌿 Week 2: Full Implementation (Medium)
**Goal**: Implement complete merge sort

1. **Day 1-3**: 912. Sort an Array
   - Implement merge sort on arrays
   - Practice divide & conquer

2. **Day 4-7**: 148. Sort List ⭐ IMPORTANT!
   - Merge sort on linked lists
   - Finding middle with slow/fast pointers
   - This is THE interview question

---

### 🌳 Week 3: Multiple Merges (Medium-Hard)
**Goal**: Handle multiple sorted sequences

1. **Day 1-4**: 23. Merge k Sorted Lists
   - Divide and conquer approach
   - Or heap approach
   - Compare both methods

2. **Day 5-7**: Practice and optimize

---

### 🌲 Week 4: Counting Applications (Hard)
**Goal**: Use merge sort for counting

1. **Day 1-3**: 315. Count of Smaller Numbers After Self
   - Modified merge sort
   - Index tracking
   - Counting during merge

2. **Day 4-5**: 493. Reverse Pairs
   - Similar to 315
   - Different counting condition

3. **Day 6-7**: 327. Count of Range Sum (Optional)
   - Most complex
   - Only if you have time

---

## Pattern Recognition

### Pattern 1: Two Sorted Sequences → Merge
**When to use**: Given two sorted arrays/lists, combine them

**Template**:
```python
def merge(left, right):
    result = []
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

**Problems**: 88, 21, 23

---

### Pattern 2: Unsorted Array → Sort with Merge Sort
**When to use**: Need O(n log n) sorting, stable sort, or linked list

**Template**:
```python
def mergeSort(arr):
    if len(arr) <= 1:
        return arr
    
    mid = len(arr) // 2
    left = mergeSort(arr[:mid])
    right = mergeSort(arr[mid:])
    
    return merge(left, right)
```

**Problems**: 912, 148

---

### Pattern 3: Count While Merging
**When to use**: Count inversions, pairs, or relationships

**Template**:
```python
def mergeSortWithCount(arr):
    if len(arr) <= 1:
        return arr, 0
    
    mid = len(arr) // 2
    left, count1 = mergeSortWithCount(arr[:mid])
    right, count2 = mergeSortWithCount(arr[mid:])
    
    merged, count3 = mergeAndCount(left, right)
    return merged, count1 + count2 + count3

def mergeAndCount(left, right):
    result = []
    count = 0
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            count += len(left) - i  # Count inversions
            j += 1
    
    result.extend(left[i:])
    result.extend(right[j:])
    return result, count
```

**Problems**: 315, 493, 327

---

## Quick Reference Table

| # | Problem | Difficulty | Pattern | Priority | Time | Space |
|---|---------|------------|---------|----------|------|-------|
| 88 | Merge Sorted Array | Easy | Merge | ⭐⭐⭐ | O(m+n) | O(1) |
| 21 | Merge Two Sorted Lists | Easy | Merge | ⭐⭐⭐ | O(m+n) | O(1) |
| 912 | Sort an Array | Medium | Full Sort | ⭐⭐ | O(n log n) | O(n) |
| 148 | Sort List | Medium | Full Sort | ⭐⭐⭐⭐⭐ | O(n log n) | O(log n) |
| 23 | Merge k Sorted Lists | Hard | Merge | ⭐⭐⭐⭐ | O(N log k) | O(log k) |
| 315 | Count Smaller After Self | Hard | Count | ⭐⭐⭐⭐⭐ | O(n log n) | O(n) |
| 493 | Reverse Pairs | Hard | Count | ⭐⭐⭐⭐ | O(n log n) | O(n) |
| 327 | Count of Range Sum | Hard | Count | ⭐⭐⭐⭐⭐ | O(n log n) | O(n) |

---

## Top 5 Must-Do for Interviews

1. **148. Sort List** - Most common merge sort question
2. **23. Merge k Sorted Lists** - Tests merge understanding
3. **315. Count of Smaller Numbers After Self** - Advanced application
4. **88. Merge Sorted Array** - Foundation
5. **21. Merge Two Sorted Lists** - Linked list variation

---

## Additional Practice Problems

### Related Problems (Not Pure Merge Sort)
- **977. Squares of a Sorted Array** - Two pointer merge technique
- **986. Interval List Intersections** - Merge two sorted lists
- **1508. Range Sum of Sorted Subarray Sums** - Sorting with merge
- **Merge Intervals** - Sorting then merging

---

## Tips for Success

### 1. Master the Basics First
- Start with 88 and 21
- Don't jump to hard problems too quickly
- Understand merge operation deeply

### 2. Practice Variations
- Array vs Linked List
- In-place vs New Array
- Ascending vs Descending

### 3. Understand Counting Logic
- When to count during merge
- How to track indices
- Why counting works during merge

### 4. Time Yourself
- Easy: 15-20 minutes
- Medium: 30-40 minutes
- Hard: 45-60 minutes

### 5. Review Patterns
- Recognize when to use merge sort
- Know the templates by heart
- Practice without looking at solutions

---

## Common Mistakes to Avoid

1. ❌ Forgetting to handle remaining elements after merge
2. ❌ Not considering edge cases (empty arrays, single element)
3. ❌ Incorrect index calculations in counting problems
4. ❌ Forgetting to copy indices along with values
5. ❌ Not understanding why merge from right-to-left in problem 88

---

## Resources

### Video Tutorials
- NeetCode: Merge Sort playlist
- Abdul Bari: Merge Sort algorithm
- Back to Back SWE: Merge Sort problems

### Practice Platforms
- LeetCode (primary)
- HackerRank (merge sort section)
- GeeksforGeeks (practice problems)

---

## Progress Tracker

Use this to track your progress:

```
Easy Problems:
[ ] 88. Merge Sorted Array
[ ] 21. Merge Two Sorted Lists

Medium Problems:
[ ] 912. Sort an Array
[ ] 148. Sort List ⭐ MUST DO
[ ] 23. Merge k Sorted Lists

Hard Problems:
[ ] 315. Count of Smaller Numbers After Self
[ ] 493. Reverse Pairs
[ ] 327. Count of Range Sum

Bonus:
[ ] 4. Median of Two Sorted Arrays
```

---

## Next Steps

After mastering merge sort problems:
1. Move to Quick Sort problems
2. Study other O(n log n) algorithms
3. Practice hybrid sorting problems
4. Learn about external sorting

---

**Good luck with your practice! 🚀**

Remember: Merge sort is not just about sorting - it's about divide & conquer thinking!
