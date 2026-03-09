# Day 14 - Merge Sorted Linked Lists

## Problem 1: Merge Two Sorted Lists

### Problem
Merge two sorted linked lists into one sorted list

### Iterative Approach (Preferred)
```python
def mergeTwoLists(list1, list2):
    dummy = ListNode(0)
    current = dummy
    
    while list1 and list2:
        if list1.val < list2.val:
            current.next = list1
            list1 = list1.next
        else:
            current.next = list2
            list2 = list2.next
        current = current.next
    
    current.next = list1 or list2
    return dummy.next
```

**Key Points:**
- Use dummy node to simplify edge cases
- Compare values and attach smaller node
- Append remaining nodes at end

**Time:** O(n + m) | **Space:** O(1)

### Recursive Approach
```python
def mergeTwoLists(list1, list2):
    if not list1 or not list2:
        return list1 or list2
    
    if list1.val <= list2.val:
        list1.next = mergeTwoLists(list1.next, list2)
        return list1
    else:
        list2.next = mergeTwoLists(list1, list2.next)
        return list2
```

**Time:** O(n + m) | **Space:** O(n + m) - recursion stack

---

## Problem 2: Merge K Sorted Lists

### Approach 1: Divide & Conquer (Best)
```python
def mergeKLists(lists):
    if not lists:
        return None
    if len(lists) == 1:
        return lists[0]
    
    mid = len(lists) // 2
    left = mergeKLists(lists[:mid])
    right = mergeKLists(lists[mid:])
    
    return mergeTwoLists(left, right)
```

**Strategy:**
- Split lists into two halves
- Recursively merge each half
- Merge the two results

**Time:** O(N log k) where N = total nodes, k = number of lists
**Space:** O(log k) - recursion depth

### Approach 2: Min Heap / Priority Queue
```python
import heapq

def mergeKLists(lists):
    heap = []
    
    # Add first node of each list to heap
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

**Time:** O(N log k) | **Space:** O(k) - heap size

### Approach 3: Sequential Merge (Simple but Slow)
```python
def mergeKLists(lists):
    if not lists:
        return None
    
    result = None
    for lst in lists:
        result = mergeTwoLists(result, lst)
    
    return result
```

**Time:** O(N * k) | **Space:** O(1)

---

## Comparison of Approaches

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Divide & Conquer | O(N log k) | O(log k) | **Optimal** |
| Min Heap | O(N log k) | O(k) | When k is small |
| Sequential | O(N * k) | O(1) | Simple implementation |

---

## Key Patterns

### 1. Dummy Node Pattern
**Use for:** Simplifying merge operations
```python
dummy = ListNode(0)
current = dummy
# ... build list
return dummy.next
```

### 2. Divide & Conquer Pattern
**Use for:** Merging multiple lists efficiently
```python
mid = len(lists) // 2
left = solve(lists[:mid])
right = solve(lists[mid:])
return merge(left, right)
```

### 3. Min Heap Pattern
**Use for:** Always getting minimum from k sources
```python
heap = []
for item in items:
    heapq.heappush(heap, (priority, item))
min_item = heapq.heappop(heap)
```

---

## Common Mistakes

1. **Merge Two Lists:**
   - Forgetting to handle empty lists
   - Not using dummy node (complicates code)
   - Forgetting to append remaining nodes

2. **Merge K Lists:**
   - Using sequential merge (O(N*k) instead of O(N log k))
   - Not handling empty lists in input array
   - Heap comparison issues with ListNode objects

3. **General:**
   - Losing reference to merged list head
   - Not moving current pointer after assignment
   - Off-by-one errors in divide & conquer

---

## Decision Guide

**Choose Divide & Conquer when:**
- Need optimal time complexity
- k is large
- Space is limited

**Choose Min Heap when:**
- k is small
- Need to process streams
- Want simpler logic

**Choose Sequential when:**
- k is very small (2-3 lists)
- Simplicity over performance
- Space is critical
