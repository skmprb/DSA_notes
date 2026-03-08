# Day 13 - Linked List Fundamentals

## Core Concepts

### Linked List Structure
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
```

**Key Points:**
- Each node contains data and pointer to next node
- Head points to first node
- Last node points to None

---

## Problem 1: Reverse Linked List

### Iterative Approach (Preferred)
```python
def reverseList(head):
    prev = None
    current = head
    
    while current:
        next_node = current.next  # Save next
        current.next = prev       # Reverse link
        prev = current            # Move prev forward
        current = next_node       # Move current forward
    
    return prev
```

**Visualization:**
```
Original: 1 -> 2 -> 3 -> None

Step 1: None <- 1    2 -> 3 -> None
Step 2: None <- 1 <- 2    3 -> None
Step 3: None <- 1 <- 2 <- 3
```

**Time:** O(n) | **Space:** O(1)

### Recursive Approach
```python
def reverseListRecursive(head):
    if not head or not head.next:
        return head
    
    reversed_head = reverseListRecursive(head.next)
    head.next.next = head  # Reverse link
    head.next = None       # Break old link
    
    return reversed_head
```

**Time:** O(n) | **Space:** O(n) - recursion stack

---

## Problem 2: Linked List Cycle Detection

### Floyd's Cycle Detection (Tortoise & Hare)
```python
def hasCycle(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        
        if slow == fast:
            return True
    
    return False
```

**Why It Works:**
- Slow moves 1 step, fast moves 2 steps
- If cycle exists, fast will eventually catch slow
- If no cycle, fast reaches None

**Time:** O(n) | **Space:** O(1)

### Alternative: Hash Set
```python
def hasCycleHashSet(head):
    seen = set()
    while head:
        if head in seen:
            return True
        seen.add(head)
        head = head.next
    return False
```

**Time:** O(n) | **Space:** O(n)

---

## Common Linked List Operations

| Operation | Time | Description |
|-----------|------|-------------|
| Insert at beginning | O(1) | Update head pointer |
| Insert at end | O(n) | Traverse to last node |
| Delete from beginning | O(1) | Move head to next |
| Delete from end | O(n) | Find second-to-last |
| Search | O(n) | Traverse entire list |
| Reverse | O(n) | Reverse all pointers |

---

## Key Patterns

### 1. Two Pointers (Slow & Fast)
**Use for:**
- Cycle detection
- Finding middle element
- Detecting intersection

**Template:**
```python
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
```

### 2. Pointer Reversal
**Use for:**
- Reversing list
- Reversing in groups

**Template:**
```python
prev = None
current = head
while current:
    next_node = current.next
    current.next = prev
    prev = current
    current = next_node
```

### 3. Dummy Node
**Use for:**
- Simplifying edge cases
- Merging lists
- Removing nodes

**Template:**
```python
dummy = ListNode(0)
dummy.next = head
current = dummy
```

---

## Common Mistakes

1. **Reverse:**
   - Forgetting to save next_node before reversing
   - Not returning prev (new head)
   - Losing reference to rest of list

2. **Cycle Detection:**
   - Not checking `fast.next` before `fast.next.next`
   - Using wrong comparison (value vs node reference)

3. **General:**
   - Not handling empty list (head = None)
   - Not handling single node
   - Losing head reference

---

## Quick Reference

**When to use Linked List:**
- Frequent insertions/deletions at beginning
- Unknown size
- No random access needed

**When NOT to use:**
- Need random access (use array)
- Memory overhead is concern
- Cache locality important
