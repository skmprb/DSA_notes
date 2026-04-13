# Day 46: Swap Nodes in Pairs

## Problem Statement
**LeetCode 24: Swap Nodes in Pairs**

Given a linked list, swap every two adjacent nodes and return its head. You must solve the problem without modifying the values in the list's nodes (i.e., only nodes themselves may be changed).

**Examples:**
```
Input: head = [1,2,3,4]
Output: [2,1,4,3]

Input: head = []
Output: []

Input: head = [1]
Output: [1]

Input: head = [1,2,3]
Output: [2,1,3]
```

**Constraints:**
- The number of nodes in the list is in the range [0, 100]
- 0 <= Node.val <= 100

---

## Problem Logic & Reasoning

### Core Concept
Swap every pair of adjacent nodes by **rewiring pointers**, not by swapping values.

**Key Insight:** Use a dummy node to handle edge cases and maintain a reference to the previous node for each swap.

### Visual Understanding for [1,2,3,4]

```
Original:
1 → 2 → 3 → 4 → null

After swapping pairs:
2 → 1 → 4 → 3 → null

Swap (1,2) and (3,4)
```

### Why Dummy Node?
```
Without dummy:
    head = 1 → 2 → 3 → 4
    After swap: head should point to 2
    Need to track and return new head

With dummy:
    dummy → 1 → 2 → 3 → 4
    After swap: dummy → 2 → 1 → 4 → 3
    Always return dummy.next (handles all cases)
```

---

## Approach 1: Iterative with Dummy Node ⭐

### Logic
1. Create dummy node pointing to head
2. Use prev pointer to track node before the pair
3. For each pair (first, second):
   - Rewire: prev → second → first → second.next
   - Move prev to first (now after second)
4. Return dummy.next

### Visual Flow for [1,2,3,4]

```
Initial setup:
dummy → 1 → 2 → 3 → 4 → null
prev

Iteration 1: Swap (1,2)
    first = 1
    second = 2
    
    Step 1: first.next = second.next
    dummy → 1 ----→ 3 → 4 → null
            ↓
            2
    
    Step 2: second.next = first
    dummy → 1 ← 2   3 → 4 → null
            ↓
            3
    
    Step 3: prev.next = second
    dummy → 2 → 1 → 3 → 4 → null
    
    Step 4: prev = first
    dummy → 2 → 1 → 3 → 4 → null
                prev

Iteration 2: Swap (3,4)
    first = 3
    second = 4
    
    After rewiring:
    dummy → 2 → 1 → 4 → 3 → null
                        prev

Result: 2 → 1 → 4 → 3 → null
```

### Step-by-Step Pointer Manipulation

```
Original: dummy → 1 → 2 → 3 → 4 → null

Step 1: Identify nodes
    prev = dummy
    first = 1
    second = 2

Step 2: first.next = second.next
    1.next = 3
    dummy → 1 ----→ 3 → 4
            ↓
            2

Step 3: second.next = first
    2.next = 1
    dummy     2 → 1 → 3 → 4
              ↑
            (floating)

Step 4: prev.next = second
    dummy.next = 2
    dummy → 2 → 1 → 3 → 4

Step 5: prev = first
    prev now points to 1
    Ready for next swap
```

### Pseudocode
```
function swapPairs(head):
    if not head or not head.next:
        return head
    
    dummy = ListNode(0)
    dummy.next = head
    prev = dummy
    
    while prev.next and prev.next.next:
        first = prev.next
        second = prev.next.next
        
        // Rewire pointers
        first.next = second.next
        second.next = first
        prev.next = second
        
        // Move to next pair
        prev = first
    
    return dummy.next
```

### Complexity Analysis
- **Time:** O(n) - Single pass through list
- **Space:** O(1) - Only pointer variables

---

## Approach 2: Recursive Solution

### Logic
1. Base case: If less than 2 nodes, return head
2. Recursive case:
   - Swap first two nodes
   - Recursively swap remaining list
   - Connect swapped pair to result

### Visual Flow for [1,2,3,4]

```
swapPairs([1,2,3,4])
    ↓
    first = 1
    second = 2
    first.next = swapPairs([3,4])
        ↓
        first = 3
        second = 4
        first.next = swapPairs([null])
            ↓
            return null
        second.next = first
        return 4 → 3 → null
    second.next = first
    return 2 → 1 → 4 → 3 → null
```

### Recursion Tree

```
                swapPairs([1,2,3,4])
                /                  \
            Swap (1,2)          swapPairs([3,4])
                                /              \
                            Swap (3,4)      swapPairs([])
                                                |
                                              null

Result: 2→1 connected to 4→3 = 2→1→4→3
```

### Pseudocode
```
function swapPairs(head):
    // Base case
    if not head or not head.next:
        return head
    
    // Identify nodes
    first = head
    second = head.next
    
    // Recursively swap remaining
    first.next = swapPairs(second.next)
    
    // Swap current pair
    second.next = first
    
    // Return new head
    return second
```

### Complexity Analysis
- **Time:** O(n) - Visit each node once
- **Space:** O(n) - Recursion stack depth

---

## Approach Comparison

| Aspect | Iterative | Recursive |
|--------|-----------|-----------|
| **Time Complexity** | O(n) | O(n) |
| **Space Complexity** | O(1) ⭐ | O(n) stack |
| **Readability** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Stack Overflow Risk** | No | Yes (large lists) |
| **Best For** | Production | Understanding |

---

## Critical Insights

### 1. Why Dummy Node is Essential
```
Without dummy:
    head = [1,2,3,4]
    After first swap, head should be 2
    Need special handling for head

With dummy:
    dummy → [1,2,3,4]
    After swap: dummy → [2,1,4,3]
    Always return dummy.next
    No special cases!
```

### 2. The Three-Step Swap Pattern
```
Step 1: first.next = second.next
    Disconnect first from second

Step 2: second.next = first
    Point second back to first

Step 3: prev.next = second
    Connect previous node to second
```

### 3. Why Move prev to first?
```
After swap: prev → second → first → ...
                              ↑
                           New prev

first is now in the position where prev should be
for the next swap!
```

### 4. Loop Condition Explained
```
while prev.next and prev.next.next:
      ↑            ↑
      first        second

Need both to exist for a valid pair to swap
```

### 5. Edge Cases Handled
```
Empty list: head = null
    if not head → return null ✓

Single node: head = [1]
    if not head.next → return [1] ✓

Odd length: head = [1,2,3]
    Last node (3) has no pair
    Loop exits, 3 remains at end ✓
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Pointer Order
```python
# Wrong order - loses reference
second.next = first
first.next = second.next  # second.next is now first!
```
**Fix:** Always disconnect first.next BEFORE connecting second.next

### ❌ Mistake 2: Not Using Dummy Node
```python
# Wrong - special case for head
if head and head.next:
    new_head = head.next
    # Complex logic to handle head swap
```

### ❌ Mistake 3: Wrong Loop Condition
```python
while prev.next:  # Missing second check
    first = prev.next
    second = prev.next.next  # NullPointerException!
```

### ❌ Mistake 4: Not Moving prev
```python
# Wrong - infinite loop
while prev.next and prev.next.next:
    # ... swap logic ...
    # Missing: prev = first
```

### ❌ Mistake 5: Swapping Values Instead of Nodes
```python
# Wrong - violates problem constraint
first.val, second.val = second.val, first.val
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `[]` | `[]` | Empty list |
| `[1]` | `[1]` | Single node (no pair) |
| `[1,2]` | `[2,1]` | One pair |
| `[1,2,3]` | `[2,1,3]` | Odd length (3 stays) |
| `[1,2,3,4]` | `[2,1,4,3]` | Even length (two pairs) |
| `[1,2,3,4,5]` | `[2,1,4,3,5]` | Odd length (5 stays) |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Reverse Nodes in k-Group** - Generalized version (swap k nodes)
2. **Reverse Linked List** - Special case (k=n)
3. **Rotate List** - Pointer manipulation
4. **Reorder List** - Complex pointer rewiring

### Key Characteristics:
- Pointer manipulation in linked list
- Dummy node for edge case handling
- Pairwise or group operations
- In-place modification

---

## Complete Implementations

### Implementation 1: Iterative with Dummy Node ⭐
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def swapPairs(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head or not head.next:
        return head
    
    dummy = ListNode(0)
    dummy.next = head
    prev = dummy
    
    while prev.next and prev.next.next:
        first = prev.next
        second = prev.next.next
        
        # Rewire pointers
        first.next = second.next
        second.next = first
        prev.next = second
        
        # Move to next pair
        prev = first
    
    return dummy.next
```

### Implementation 2: Iterative (Verbose)
```python
def swapPairs(head: Optional[ListNode]) -> Optional[ListNode]:
    # Handle edge cases
    if not head or not head.next:
        return head
    
    # Create dummy node
    dummy = ListNode(0)
    dummy.next = head
    prev = dummy
    
    # Process pairs
    while prev.next and prev.next.next:
        # Identify nodes to swap
        first = prev.next
        second = prev.next.next
        next_pair = second.next
        
        # Perform swap
        first.next = next_pair
        second.next = first
        prev.next = second
        
        # Move to next pair
        prev = first
    
    return dummy.next
```

### Implementation 3: Recursive
```python
def swapPairs(head: Optional[ListNode]) -> Optional[ListNode]:
    # Base case: 0 or 1 node
    if not head or not head.next:
        return head
    
    # Identify nodes
    first = head
    second = head.next
    
    # Recursively swap remaining list
    first.next = swapPairs(second.next)
    
    # Swap current pair
    second.next = first
    
    # Return new head of this segment
    return second
```

### Implementation 4: Iterative without Dummy (Complex)
```python
def swapPairs(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head or not head.next:
        return head
    
    # Handle first pair specially
    new_head = head.next
    head.next = new_head.next
    new_head.next = head
    
    prev = head
    
    # Process remaining pairs
    while prev.next and prev.next.next:
        first = prev.next
        second = prev.next.next
        
        first.next = second.next
        second.next = first
        prev.next = second
        
        prev = first
    
    return new_head
```

---

## Visualization: Pointer States

### Before Swap
```
prev → first → second → next
  ↓      ↓       ↓       ↓
dummy    1       2       3
```

### After first.next = second.next
```
prev → first ----→ next
  ↓      ↓          ↓
dummy    1          3
         ↓
       second
         ↓
         2
```

### After second.next = first
```
prev → first ← second   next
  ↓      ↓       ↓       ↓
dummy    1       2       3
         ↓
         3
```

### After prev.next = second
```
prev → second → first → next
  ↓      ↓       ↓       ↓
dummy    2       1       3
```

### After prev = first
```
dummy → second → first → next
                  ↑       ↓
                 prev     3
```

---

## Optimization Techniques

### 1. Early Exit for Small Lists
```python
if not head or not head.next:
    return head
```

### 2. Combine Pointer Assignments
```python
# Can be written in one line (less readable)
first.next, second.next, prev.next = second.next, first, second
```

### 3. Use Tuple Unpacking
```python
first, second = prev.next, prev.next.next
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Reverse Nodes in k-Group** | Swap groups | Swap k nodes instead of 2 |
| **Reverse Linked List** | Pointer manipulation | Reverse entire list |
| **Reverse Linked List II** | Partial reversal | Reverse specific range |
| **Odd Even Linked List** | Rearrange nodes | Group by position |

---

## Day 46 Summary

### Problems Solved: 1
1. ✅ Swap Nodes in Pairs

### Key Patterns Learned:
1. **Dummy Node Pattern** - Simplifies edge case handling
2. **Pointer Rewiring** - Three-step swap pattern
3. **Pairwise Processing** - Process elements in groups of 2

### Techniques Mastered:
- Using dummy node for linked list problems
- Three-step pointer swap technique
- Handling odd-length lists
- Recursive vs iterative approaches

### Complexity Insights:
- Iterative: O(n) time, O(1) space (optimal!)
- Recursive: O(n) time, O(n) space (stack)
- In-place modification without value swapping

### When to Use This Pattern:
- Swapping adjacent nodes in linked list
- Group-based operations on linked list
- Problems requiring pointer manipulation
- When dummy node simplifies logic

---

## Quick Reference

### Dummy Node Template
```python
def linkedListOperation(head):
    dummy = ListNode(0)
    dummy.next = head
    prev = dummy
    
    while condition:
        # Process nodes
        # Manipulate pointers
        # Move prev
        pass
    
    return dummy.next
```

### Three-Step Swap Pattern
```python
# Step 1: Disconnect first from second
first.next = second.next

# Step 2: Connect second to first
second.next = first

# Step 3: Connect prev to second
prev.next = second

# Step 4: Move prev forward
prev = first
```

### Loop Condition for Pairs
```python
while prev.next and prev.next.next:
    # Both first and second exist
    first = prev.next
    second = prev.next.next
```

### Recursive Pattern
```python
def swapPairs(head):
    if not head or not head.next:
        return head
    
    first = head
    second = head.next
    
    first.next = swapPairs(second.next)
    second.next = first
    
    return second
```

---

## Visual Summary

### The Swap Process
```
Before:  prev → 1 → 2 → 3 → 4
After:   prev → 2 → 1 → 4 → 3

Key steps:
1. Identify: first=1, second=2
2. Rewire: 1→3, 2→1, prev→2
3. Move: prev=1
4. Repeat for next pair
```

### Memory Diagram
```
Initial:
┌─────┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐
│dummy│──→│ 1 │──→│ 2 │──→│ 3 │──→│ 4 │──→null
└─────┘   └───┘   └───┘   └───┘   └───┘
  prev

After first swap:
┌─────┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐
│dummy│──→│ 2 │──→│ 1 │──→│ 3 │──→│ 4 │──→null
└─────┘   └───┘   └───┘   └───┘   └───┘
                    prev

After second swap:
┌─────┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐
│dummy│──→│ 2 │──→│ 1 │──→│ 4 │──→│ 3 │──→null
└─────┘   └───┘   └───┘   └───┘   └───┘
                                    prev
```
