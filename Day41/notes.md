# Day 41: Remove Duplicates from Sorted List

## Problem Statement
**LeetCode 83: Remove Duplicates from Sorted List**

Given the head of a sorted linked list, delete all duplicates such that each element appears only once. Return the linked list sorted as well.

**Examples:**
```
Input: head = [1,1,2]
Output: [1,2]

Input: head = [1,1,2,3,3]
Output: [1,2,3]

Input: head = [1,1,1,1,1,1]
Output: [1]

Input: head = []
Output: []
```

**Constraints:**
- The number of nodes in the list is in the range [0, 300]
- -100 <= Node.val <= 100
- The list is guaranteed to be sorted in ascending order

---

## Problem Logic & Reasoning

### Core Concept
Since the list is **already sorted**, all duplicates are **consecutive**. We can remove duplicates in a single pass by comparing adjacent nodes.

**Key Insight:** 
- In a sorted list: [1, 1, 1, 2, 3, 3]
- Duplicates are always next to each other
- We don't need to look ahead beyond the next node

### Why Sorted Makes It Easy
```
Sorted:     [1, 1, 2, 3, 3]
            ↑  ↑     ↑  ↑
         Same Same  Same Same

Unsorted:   [1, 3, 1, 2, 3]
            ↑     ↑     ↑
         Not adjacent! Would need HashSet
```

### Visual Understanding
```
Original: 1 → 1 → 2 → 3 → 3 → null

Step 1: Compare 1 and 1 (duplicate)
        1 ----→ 2 → 3 → 3 → null
        Skip the duplicate

Step 2: Compare 1 and 2 (different)
        Move to next: 2 → 3 → 3 → null

Step 3: Compare 2 and 3 (different)
        Move to next: 3 → 3 → null

Step 4: Compare 3 and 3 (duplicate)
        3 ----→ null
        Skip the duplicate

Result: 1 → 2 → 3 → null
```

---

## Approach 1: Single-Pass with If-Else ⭐

### Logic
Traverse the list once, comparing each node with its next:
1. If current.val == current.next.val → Skip the duplicate (don't move current)
2. If current.val != current.next.val → Move to next node
3. Continue until current.next is null

### Visual Flow for [1,1,2,3,3]

```
Initial: current → 1 → 1 → 2 → 3 → 3 → null

Iteration 1:
    current.val = 1, current.next.val = 1 (equal)
    current.next = current.next.next
    1 ----→ 2 → 3 → 3 → null
    current stays at 1

Iteration 2:
    current.val = 1, current.next.val = 2 (different)
    current = current.next
    1 → 2 → 3 → 3 → null
        ↑
     current

Iteration 3:
    current.val = 2, current.next.val = 3 (different)
    current = current.next
    1 → 2 → 3 → 3 → null
            ↑
         current

Iteration 4:
    current.val = 3, current.next.val = 3 (equal)
    current.next = current.next.next
    1 → 2 → 3 ----→ null
            ↑
         current

Iteration 5:
    current.next is null, exit loop

Result: 1 → 2 → 3 → null
```

### Why Don't Move current on Duplicate?
```
List: 1 → 1 → 1 → 2

If we move current after skipping:
Step 1: Skip first 1, move current
        1 → 1 → 2
            ↑
         current
Step 2: Compare 1 and 2 (different), move
        Result: 1 → 1 → 2 ❌ (Still has duplicate!)

Correct approach (don't move):
Step 1: Skip first 1, stay at current
        1 → 1 → 2
        ↑
     current
Step 2: Skip second 1, stay at current
        1 → 2
        ↑
     current
Step 3: Compare 1 and 2 (different), move
        Result: 1 → 2 ✓
```

### Pseudocode
```
function deleteDuplicates(head):
    if head is null:
        return null
    
    current = head
    
    while current and current.next:
        if current.val == current.next.val:
            current.next = current.next.next  // Skip duplicate
        else:
            current = current.next            // Move forward
    
    return head
```

### Complexity Analysis
- **Time:** O(n) - Single pass through the list
- **Space:** O(1) - Only using pointer variables, modifying in-place

---

## Approach 2: Nested While Loop

### Logic
Use an inner while loop to skip all consecutive duplicates at once:
1. Outer loop: Traverse each unique value
2. Inner loop: Skip all duplicates of current value
3. Move to next unique value

### Visual Flow for [2,2,2,2,3,4,4,4,4,4]

```
Initial: current → 2 → 2 → 2 → 2 → 3 → 4 → 4 → 4 → 4 → 4 → null

Iteration 1:
    Outer: current at 2
    Inner: Skip all 2's
        2 ----→ 3 → 4 → 4 → 4 → 4 → 4 → null
        ↑
     current
    Move: current = current.next
        2 → 3 → 4 → 4 → 4 → 4 → 4 → null
            ↑
         current

Iteration 2:
    Outer: current at 3
    Inner: No duplicates (3 != 4)
    Move: current = current.next
        2 → 3 → 4 → 4 → 4 → 4 → 4 → null
                ↑
             current

Iteration 3:
    Outer: current at 4
    Inner: Skip all 4's
        2 → 3 → 4 ----→ null
                ↑
             current
    Move: current = current.next (becomes null)

Result: 2 → 3 → 4 → null
```

### Step-by-Step Execution
```
List: [1, 1, 1, 2, 3, 3]

current = 1
    Inner loop: 1 == 1? Yes, skip
                1 == 1? Yes, skip
                1 == 2? No, exit inner loop
    Result: 1 → 2 → 3 → 3
    Move: current = 2

current = 2
    Inner loop: 2 == 3? No, exit immediately
    Move: current = 3

current = 3
    Inner loop: 3 == 3? Yes, skip
                3 == null? Exit
    Result: 1 → 2 → 3
    Move: current = null

Exit outer loop
```

### Pseudocode
```
function deleteDuplicates(head):
    if head is null:
        return null
    
    current = head
    
    while current and current.next:
        // Inner loop: skip all consecutive duplicates
        while current.next and current.val == current.next.val:
            current.next = current.next.next
        
        current = current.next  // Move to next unique value
    
    return head
```

### Complexity Analysis
- **Time:** O(n) - Each node visited once (inner loop doesn't revisit)
- **Space:** O(1) - In-place modification

---

## Approach Comparison

| Aspect | If-Else (Approach 1) | Nested While (Approach 2) |
|--------|---------------------|---------------------------|
| **Time Complexity** | O(n) | O(n) |
| **Space Complexity** | O(1) | O(1) |
| **Code Lines** | Shorter | Slightly longer |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Intuition** | More explicit | Batch processing |
| **Best For** | Interviews | Handling long duplicate runs |

Both approaches are equally efficient! Choose based on preference.

---

## Critical Insights

### 1. Why We Can Modify in Place
```
We're not creating new nodes, just rewiring pointers:

Before: 1 → 1 → 2
After:  1 ----→ 2

The duplicate node (second 1) becomes unreachable and 
will be garbage collected.
```

### 2. Why Check current AND current.next?
```python
while current and current.next:
```
- `current`: Ensures we haven't reached the end
- `current.next`: Ensures we can safely access next node

Without both checks:
```python
while current:  # Missing current.next check
    if current.val == current.next.val:  # NullPointerException!
```

### 3. Edge Case: Empty List
```
Input: head = null
Output: null

Without check:
    current = head  # current = null
    while current and current.next:  # False, skip loop
    return head  # Returns null ✓

The check handles this automatically!
```

### 4. Edge Case: Single Node
```
Input: head = [1]
Output: [1]

current = 1
while current and current.next:  # current.next is null, exit
return head  # Returns [1] ✓
```

### 5. Why Sorted is Crucial
```
Sorted:   [1, 1, 2, 3, 3]
          O(n) time, O(1) space ✓

Unsorted: [1, 3, 1, 2, 3]
          Need HashSet: O(n) time, O(n) space
          OR sort first: O(n log n) time
```

---

## Common Mistakes

### ❌ Mistake 1: Moving current After Skipping Duplicate
```python
if current.val == current.next.val:
    current.next = current.next.next
    current = current.next  # Wrong! Might skip unique values
```
**Impact:** Fails for [1,1,1,2] → returns [1,1,2] instead of [1,2]

### ❌ Mistake 2: Not Checking current.next
```python
while current:
    if current.val == current.next.val:  # NullPointerException!
```
**Fix:** `while current and current.next:`

### ❌ Mistake 3: Creating New List Instead of Modifying
```python
# Inefficient approach
result = ListNode(0)
tail = result
seen = set()

while current:
    if current.val not in seen:
        tail.next = ListNode(current.val)
        tail = tail.next
        seen.add(current.val)
    current = current.next
```
**Problem:** O(n) space, unnecessary complexity

### ❌ Mistake 4: Forgetting to Return head
```python
def deleteDuplicates(head):
    current = head
    while current and current.next:
        ...
    # Missing: return head
```

### ❌ Mistake 5: Modifying head Pointer
```python
while head and head.next:  # Using head instead of current
    if head.val == head.next.val:
        head = head.next  # Loses reference to original head!
```
**Fix:** Use a separate current pointer

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `[]` | `[]` | Empty list |
| `[1]` | `[1]` | Single node |
| `[1,1]` | `[1]` | All duplicates |
| `[1,1,1,1,1]` | `[1]` | Many consecutive duplicates |
| `[1,2,3]` | `[1,2,3]` | No duplicates |
| `[1,1,2,3,3]` | `[1,2,3]` | Multiple duplicate groups |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Remove Duplicates from Sorted Array** - Same logic, different data structure
2. **Remove Duplicates from Sorted List II** - Remove ALL occurrences of duplicates
3. **Merge Two Sorted Lists** - Comparing adjacent/next elements
4. **Partition List** - Pointer manipulation in linked lists

### Key Characteristics:
- Sorted input (duplicates are consecutive)
- In-place modification
- Single-pass solution
- Pointer manipulation
- O(1) space complexity

---

## Complete Implementations

### Implementation 1: If-Else Approach ⭐
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def deleteDuplicates(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head:
        return None
    
    current = head
    
    while current and current.next:
        if current.val == current.next.val:
            current.next = current.next.next
        else:
            current = current.next
    
    return head
```

### Implementation 2: Nested While Loop
```python
def deleteDuplicates(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head:
        return None
    
    current = head
    
    while current and current.next:
        # Skip all consecutive duplicates
        while current.next and current.val == current.next.val:
            current.next = current.next.next
        
        current = current.next
    
    return head
```

### Implementation 3: Recursive Approach
```python
def deleteDuplicates(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head or not head.next:
        return head
    
    # Recursively process the rest of the list
    head.next = deleteDuplicates(head.next)
    
    # If current and next are duplicates, skip current
    if head.val == head.next.val:
        return head.next
    
    return head
```

### Implementation 4: Using Dummy Node (Overkill for this problem)
```python
def deleteDuplicates(head: Optional[ListNode]) -> Optional[ListNode]:
    dummy = ListNode(0, head)
    current = head
    
    while current and current.next:
        if current.val == current.next.val:
            current.next = current.next.next
        else:
            current = current.next
    
    return dummy.next
```

---

## Optimization Techniques

### 1. Early Exit for Empty/Single Node
```python
def deleteDuplicates(head: Optional[ListNode]) -> Optional[ListNode]:
    # Early exit
    if not head or not head.next:
        return head
    
    current = head
    while current and current.next:
        ...
```

### 2. Batch Deletion (Nested While)
```python
# More efficient for long duplicate runs
while current.next and current.val == current.next.val:
    current.next = current.next.next
```

### 3. Pythonic One-Liner (Less Readable)
```python
def deleteDuplicates(head):
    current = head
    while current and current.next:
        current.next = current.next.next if current.val == current.next.val else (current := current.next) and current
    return head
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Remove Duplicates from Sorted Array** | Same logic | Array instead of linked list |
| **Remove Duplicates from Sorted List II** | Similar structure | Remove ALL duplicate occurrences |
| **Remove Linked List Elements** | Pointer manipulation | Remove specific value |
| **Delete Node in Linked List** | Node deletion | Given node, not head |

---

## Comparison: Array vs Linked List

### Remove Duplicates from Sorted Array
```python
def removeDuplicates(nums):
    if not nums:
        return 0
    
    write = 1
    for read in range(1, len(nums)):
        if nums[read] != nums[read - 1]:
            nums[write] = nums[read]
            write += 1
    
    return write
```

### Remove Duplicates from Sorted List
```python
def deleteDuplicates(head):
    current = head
    while current and current.next:
        if current.val == current.next.val:
            current.next = current.next.next
        else:
            current = current.next
    return head
```

**Key Difference:**
- Array: Use two pointers (read/write)
- Linked List: Modify next pointers directly

---

## Day 41 Summary

### Problems Solved: 1
1. ✅ Remove Duplicates from Sorted List

### Key Patterns Learned:
1. **Sorted List Deduplication** - Leveraging sorted property for O(1) space
2. **In-Place Pointer Manipulation** - Modifying linked list without extra space
3. **Single-Pass Algorithm** - Solving in one traversal

### Techniques Mastered:
- Comparing adjacent nodes in linked list
- Skipping nodes by rewiring pointers
- Handling edge cases (empty, single node)
- Choosing when to move vs stay at current pointer

### Complexity Insights:
- Sorted input enables O(n) time, O(1) space
- Unsorted would require O(n) space (HashSet) or O(n log n) time (sorting)
- In-place modification avoids creating new list

### When to Use This Pattern:
- Sorted linked list problems
- Need to remove consecutive duplicates
- In-place modification required
- O(1) space constraint

---

## Quick Reference

### Linked List Deduplication Template
```python
def removeDuplicates(head):
    if not head:
        return None
    
    current = head
    
    while current and current.next:
        if condition_for_duplicate(current, current.next):
            current.next = current.next.next  # Skip
        else:
            current = current.next            # Move
    
    return head
```

### When to Move current vs Stay
```
Move current:
- When values are different
- When we want to process next unique value

Stay at current:
- When skipping duplicates
- When we might have more duplicates ahead
```

### Edge Case Checklist
```
✓ Empty list (head = null)
✓ Single node (head.next = null)
✓ All duplicates ([1,1,1,1])
✓ No duplicates ([1,2,3,4])
✓ Multiple duplicate groups ([1,1,2,3,3])
```

### Time Complexity Analysis
```
For list of length n:
- Best case: O(n) - No duplicates
- Average case: O(n) - Some duplicates
- Worst case: O(n) - All duplicates

Space: O(1) in all cases
```
