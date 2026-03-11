# Day 15 - Advanced Linked List Operations

## Problem 1: Remove Nth Node From End

### Problem Statement
**Input:** `head = [1,2,3,4,5]`, `n = 2`
**Output:** `[1,2,3,5]` (removed 4, which is 2nd from end)

### Pseudocode
```
FUNCTION removeNthFromEnd(head, n):
    CREATE dummy = ListNode(0)
    SET dummy.next = head
    SET fast = dummy
    SET slow = dummy
    
    // Create gap of n+1
    FOR i = 0 to n:
        MOVE fast = fast.next
    
    // Move both until fast reaches end
    WHILE fast is not None:
        MOVE fast = fast.next
        MOVE slow = slow.next
    
    // Remove node
    SET slow.next = slow.next.next
    RETURN dummy.next
```

### Flow Diagram
```
Start
  |
  v
Create dummy, point to head
  |
  v
Initialize: fast=dummy, slow=dummy
  |
  v
Move fast n+1 steps ahead
  |
  v
Is fast None? --NO--> Move both fast & slow
  |                   Loop back
  YES
  |
  v
Remove: slow.next = slow.next.next
  |
  v
Return dummy.next
  |
  v
END
```

### Two Pointer Gap Method (Optimal)
```python
def removeNthFromEnd(head, n):
    dummy = ListNode(0)
    dummy.next = head
    fast = slow = dummy
    
    # Create gap of n+1
    for _ in range(n + 1):
        fast = fast.next
    
    # Move both until fast reaches end
    while fast:
        fast = fast.next
        slow = slow.next
    
    # Remove node
    slow.next = slow.next.next
    return dummy.next
```

**Visual:**
```
List: 1 → 2 → 3 → 4 → 5, n = 2

Step 1: Create gap of n+1 (3 nodes)
dummy → 1 → 2 → 3 → 4 → 5 → None
  ↑           ↑
 slow        fast

Step 2: Move both until fast = None
dummy → 1 → 2 → 3 → 4 → 5 → None
              ↑           ↑
            slow        fast

Step 3: Remove node
slow.next = slow.next.next
Result: 1 → 2 → 3 → 5
```

**Why n+1 gap?**
- Need slow to stop at node BEFORE the one to delete
- Gap of n+1 ensures slow is at correct position

**Time:** O(n) | **Space:** O(1)

---

## Problem 2: Reorder List

### Problem Statement
**Input:** `head = [1,2,3,4,5]`
**Output:** `[1,5,2,4,3]`
**Pattern:** L0 → Ln → L1 → Ln-1 → L2 → Ln-2 ...

### Pseudocode
```
FUNCTION reorderList(head):
    IF head is None OR head.next is None:
        RETURN
    
    // Step 1: Find middle
    SET slow = head, fast = head
    WHILE fast.next AND fast.next.next:
        MOVE slow = slow.next
        MOVE fast = fast.next.next
    
    // Step 2: Reverse second half
    SET second = slow.next
    SET slow.next = None
    SET prev = None
    WHILE second is not None:
        SAVE next_node = second.next
        REVERSE second.next = prev
        MOVE prev = second
        MOVE second = next_node
    
    // Step 3: Merge alternately
    SET first = head, second = prev
    WHILE second is not None:
        SAVE temp1 = first.next
        SAVE temp2 = second.next
        CONNECT first.next = second
        CONNECT second.next = temp1
        MOVE first = temp1
        MOVE second = temp2
```

### Flow Diagram
```
Start
  |
  v
Edge case check
  |
  v
[STEP 1: Find Middle]
Use slow/fast pointers
  |
  v
Split list at middle
  |
  v
[STEP 2: Reverse Second Half]
Use prev/current/next
  |
  v
Second half reversed
  |
  v
[STEP 3: Merge Alternately]
Weave first and second
  |
  +--Take from first
  |
  +--Take from second
  |
  v
Repeat until second exhausted
  |
  v
List reordered in-place
  |
  v
END
```

### Three-Step Pattern (Optimal)
```python
def reorderList(head):
    if not head or not head.next:
        return
    
    # Step 1: Find middle
    slow = fast = head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next
    
    # Step 2: Reverse second half
    second = slow.next
    slow.next = None
    prev = None
    while second:
        next_node = second.next
        second.next = prev
        prev = second
        second = next_node
    
    # Step 3: Merge alternately
    first, second = head, prev
    while second:
        temp1, temp2 = first.next, second.next
        first.next = second
        second.next = temp1
        first, second = temp1, temp2
```

**Visual Breakdown:**

**Step 1: Find Middle**
```
1 → 2 → 3 → 4 → 5
        ↑
      slow (middle)

Split: 1 → 2 → 3 | 4 → 5
```

**Step 2: Reverse Second Half**
```
First:  1 → 2 → 3
Second: 5 → 4 (reversed)
```

**Step 3: Merge**
```
Take from first:  1
Take from second: 5
Take from first:  2
Take from second: 4
Take from first:  3

Result: 1 → 5 → 2 → 4 → 3
```

**Time:** O(n) | **Space:** O(1)

---

## Key Patterns

### Pattern 1: Gap Pointer (Nth from End)
**Use for:** Finding nth node from end, removing nodes

**Template:**
```python
fast = slow = dummy
# Create gap of n
for _ in range(n):
    fast = fast.next

# Move both
while fast:
    slow = slow.next
    fast = fast.next
```

### Pattern 2: Split-Reverse-Merge (Reorder)
**Use for:** Reordering, palindrome check, complex rearrangements

**Template:**
```python
# 1. Find middle
slow = fast = head
while fast.next and fast.next.next:
    slow = slow.next
    fast = fast.next.next

# 2. Reverse second half
second = slow.next
slow.next = None
# ... reverse logic

# 3. Merge
while second:
    # ... merge logic
```

---

## Common Mistakes

### Remove Nth Node:
1. **Wrong gap size:** Use n+1, not n
2. **No dummy node:** Fails when removing head
3. **Not checking fast:** Can be None

### Reorder List:
1. **Wrong middle condition:** Use `fast.next and fast.next.next`
2. **Not breaking link:** Must set `slow.next = None`
3. **Forgetting temp variables:** Lose references during merge

---

## Edge Cases

### Remove Nth Node:
```python
# Single node, remove it
[1], n=1 → []

# Two nodes, remove first
[1,2], n=2 → [2]

# Two nodes, remove last
[1,2], n=1 → [1]
```

### Reorder List:
```python
# Empty list
[] → []

# Single node
[1] → [1]

# Two nodes
[1,2] → [1,2]

# Odd length
[1,2,3,4,5] → [1,5,2,4,3]

# Even length
[1,2,3,4] → [1,4,2,3]
```

---

## Why Dummy Node?

**Without dummy:**
```python
# Removing head is special case
if n == length:
    return head.next
```

**With dummy:**
```python
# No special case needed
dummy.next = head
# ... logic works for all cases
return dummy.next
```

---

## Comparison

| Aspect | Remove Nth | Reorder List |
|--------|-----------|--------------|
| Pattern | Gap Pointer | Split-Reverse-Merge |
| Passes | One | One (3 steps) |
| Pointers | 2 (fast, slow) | Multiple |
| Dummy Node | Yes | No |
| Modifies | Removes node | Rearranges |

---

## Quick Reference

### Remove Nth from End:
1. Create dummy
2. Gap of n+1 between pointers
3. Move both until fast = None
4. Remove: `slow.next = slow.next.next`

### Reorder List:
1. Find middle (slow/fast)
2. Reverse second half
3. Merge alternately (save temps!)

---

## Practice Variations

**Remove Nth Node:**
- Remove duplicates
- Remove all nodes with value
- Remove middle node

**Reorder List:**
- Odd-even reorder
- Reverse in k-groups
- Palindrome check

---

## Key Takeaways

1. **Gap pointer** solves "nth from end" in one pass
2. **Dummy node** simplifies edge cases
3. **Split-Reverse-Merge** is powerful pattern
4. **Always save references** before modifying
5. **Draw diagrams** for complex operations
