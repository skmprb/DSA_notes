# Day 07: Find the Duplicate Number

## Problem Pattern
**Floyd's Cycle Detection (Tortoise and Hare)** - Treat array as linked list

## Problem Statement
Given array of n+1 integers where each integer is in range [1, n]:
- Only ONE number repeats (can repeat multiple times)
- Must solve WITHOUT modifying array
- Must use O(1) extra space

## Key Insight
**Array as Linked List**: Since values are in range [1, n], we can treat each value as a pointer to next index.

```
nums = [1, 3, 4, 2, 2]
index:  0  1  2  3  4

Linked list representation:
0 → 1 → 3 → 2 → 4 → 2 (cycle!)
            ↑_________|
```

The duplicate creates a cycle because multiple indices point to the same value!

## Pseudocode (Floyd's Algorithm)
```
function findDuplicate(nums):
    // Phase 1: Detect cycle
    slow = nums[0]
    fast = nums[0]
    
    do:
        slow = nums[slow]      // Move 1 step
        fast = nums[nums[fast]] // Move 2 steps
    while slow != fast
    
    // Phase 2: Find cycle entrance (duplicate)
    slow = nums[0]
    
    while slow != fast:
        slow = nums[slow]
        fast = nums[fast]
    
    return slow  // Cycle entrance = duplicate
```

## Flowchart

```
                    START
                      |
                      v
            slow = nums[0], fast = nums[0]
                      |
                      v
                +----------+
                | Phase 1: |
                | Detect   |
                | Cycle    |
                +----------+
                      |
                      v
            slow = nums[slow]
            fast = nums[nums[fast]]
                      |
                      v
              +---------------+
              | slow == fast? |---NO---> Loop back
              +---------------+
                      |YES (Cycle detected!)
                      v
                +----------+
                | Phase 2: |
                | Find     |
                | Entrance |
                +----------+
                      |
                      v
              slow = nums[0]
                      |
                      v
              +---------------+
              | slow == fast? |---NO---> slow = nums[slow]
              +---------------+          fast = nums[fast]
                      |YES               Loop back
                      v
              return slow (duplicate!)
                      |
                      v
                     END
```

## Logic Walkthrough
Example: `nums = [1,3,4,2,2]`

### Phase 1: Detect Cycle

| Step | slow | fast | nums[slow] | nums[fast] | Action |
|------|------|------|------------|------------|--------|
| 0    | 0    | 0    | -          | -          | Initialize |
| 1    | 1    | 3    | nums[0]=1  | nums[nums[0]]=nums[1]=3 | Move |
| 2    | 3    | 2    | nums[1]=3  | nums[nums[3]]=nums[2]=4 | Move |
| 3    | 2    | 2    | nums[3]=2  | nums[nums[4]]=nums[2]=4 | Move |
| -    | 2    | 2    | -          | -          | **Cycle detected!** |

### Phase 2: Find Entrance

| Step | slow | fast | Action |
|------|------|------|--------|
| 0    | 0    | 2    | Reset slow to start |
| 1    | 1    | 4    | slow=nums[0]=1, fast=nums[2]=4 |
| 2    | 3    | 2    | slow=nums[1]=3, fast=nums[4]=2 |
| 3    | 2    | 4    | slow=nums[3]=2, fast=nums[2]=4 |
| 4    | 4    | 2    | slow=nums[2]=4, fast=nums[4]=2 |
| 5    | 2    | 4    | slow=nums[4]=2, fast=nums[2]=4 |
| 6    | 2    | 2    | **Found duplicate: 2** |

Wait, let me recalculate Phase 2:

| Step | slow | fast | Action |
|------|------|------|--------|
| 0    | 0    | 2    | Reset slow, fast stays at meeting point |
| 1    | 1    | 4    | slow=nums[0]=1, fast=nums[2]=4 |
| 2    | 3    | 2    | slow=nums[1]=3, fast=nums[4]=2 |
| 3    | 2    | 4    | slow=nums[3]=2, fast=nums[2]=4 |
| 4    | 4    | 2    | slow=nums[2]=4, fast=nums[4]=2 |
| 5    | 2    | 4    | slow=nums[4]=2, fast=nums[2]=4 |

Actually, the correct trace:
- After Phase 1: slow=2, fast=2 (they meet)
- Phase 2: slow=nums[0]=1, fast stays at 2
- Loop: slow=nums[1]=3, fast=nums[2]=4
- Loop: slow=nums[3]=2, fast=nums[4]=2
- **They meet at 2!**

## Multiple Approaches

### Approach 1: Floyd's Cycle Detection (Optimal)
```python
def findDuplicate(nums):
    # Phase 1: Find intersection point
    slow = nums[0]
    fast = nums[0]
    
    while True:
        slow = nums[slow]
        fast = nums[nums[fast]]
        if slow == fast:
            break
    
    # Phase 2: Find entrance to cycle
    slow = nums[0]
    
    while slow != fast:
        slow = nums[slow]
        fast = nums[fast]
    
    return slow
```
- **Time**: O(n)
- **Space**: O(1)
- ✅ Meets all constraints!

### Approach 2: Frequency Array
```python
def findDuplicate(nums):
    n = len(nums)
    freq = [0] * n
    
    for num in nums:
        if freq[num] == 0:
            freq[num] = 1
        else:
            return num
```
- **Time**: O(n)
- **Space**: O(n)
- ❌ Uses extra space

### Approach 3: Boolean Array
```python
def findDuplicate(nums):
    seen = [False] * len(nums)
    
    for num in nums:
        if seen[num]:
            return num
        else:
            seen[num] = True
```
- **Time**: O(n)
- **Space**: O(n)
- ❌ Uses extra space

### Approach 4: Marking Visited (Modifies Array)
```python
def findDuplicate(nums):
    curr = 0
    
    while True:
        if nums[curr] == -1:
            return curr
        
        temp = nums[curr]
        nums[curr] = -1  # Mark as visited
        curr = temp
```
- **Time**: O(n)
- **Space**: O(1)
- ❌ Modifies array (violates constraint)

### Approach 5: Sorting (Modifies Array)
```python
def findDuplicate(nums):
    nums.sort()
    
    for i in range(1, len(nums)):
        if nums[i] == nums[i-1]:
            return nums[i]
```
- **Time**: O(n log n)
- **Space**: O(1)
- ❌ Modifies array

### Approach 6: Binary Search (Advanced)
```python
def findDuplicate(nums):
    left, right = 1, len(nums) - 1
    
    while left < right:
        mid = (left + right) // 2
        count = sum(num <= mid for num in nums)
        
        if count > mid:
            right = mid
        else:
            left = mid + 1
    
    return left
```
- **Time**: O(n log n)
- **Space**: O(1)
- ✅ Meets constraints but slower

## Why Floyd's Algorithm Works

### Mathematical Proof

**Setup**:
- Array has n+1 elements with values [1, n]
- One value repeats → creates cycle in "linked list"

**Phase 1 - Cycle Detection**:
- Slow moves 1 step: `slow = nums[slow]`
- Fast moves 2 steps: `fast = nums[nums[fast]]`
- If cycle exists, they MUST meet inside cycle

**Why they meet?**
- Once both enter cycle, distance between them decreases by 1 each step
- Eventually distance becomes 0 → they meet

**Phase 2 - Find Entrance**:
- Let's say:
  - Distance from start to cycle entrance = `a`
  - Distance from entrance to meeting point = `b`
  - Cycle length = `c`

- When they meet:
  - Slow traveled: `a + b`
  - Fast traveled: `a + b + k*c` (k = number of complete cycles)
  
- Since fast is 2x speed: `2(a + b) = a + b + k*c`
- Simplify: `a + b = k*c`
- Therefore: `a = k*c - b`

- This means: Distance from start to entrance = Distance from meeting point to entrance!

**Visual Proof**:
```
Start → → → Entrance → → Meeting Point
  a steps      b steps

Meeting Point → → → Entrance (going around cycle)
        c - b steps

Since a = k*c - b, moving a steps from start 
equals moving a steps from meeting point!
```

## Complexity Analysis

| Approach | Time | Space | Modifies Array? | Meets Constraints? |
|----------|------|-------|-----------------|-------------------|
| Floyd's Cycle | O(n) | O(1) | No | ✅ YES |
| Frequency Array | O(n) | O(n) | No | ❌ Extra space |
| Boolean Array | O(n) | O(n) | No | ❌ Extra space |
| Marking Visited | O(n) | O(1) | Yes | ❌ Modifies |
| Sorting | O(n log n) | O(1) | Yes | ❌ Modifies |
| Binary Search | O(n log n) | O(1) | No | ✅ YES (slower) |

## Shortcut Meanings & Tricks

### 1. `slow = nums[slow]` 
**Meaning**: Follow the "pointer" - treat value as next index
**Shortcut**: Think "value → index" mapping

### 2. `fast = nums[nums[fast]]`
**Meaning**: Move 2 steps at once
**Shortcut**: Double jump - `nums[nums[fast]]` = go to next, then next again

### 3. `while True:` with `break`
**Meaning**: Guaranteed to find cycle (infinite loop with exit)
**Shortcut**: Use when you KNOW loop will terminate

### 4. Reset `slow = nums[0]`
**Meaning**: Start from beginning to find cycle entrance
**Shortcut**: "Reset one pointer" is common in cycle problems

### 5. `do-while` pattern in Python
```python
# Instead of do-while (not in Python)
while True:
    # do something
    if condition:
        break

# Can also write as:
slow = nums[slow]
fast = nums[nums[fast]]
while slow != fast:
    slow = nums[slow]
    fast = nums[nums[fast]]
```

### 6. Array as Linked List trick
**Shortcut**: When values are indices, treat array as graph/linked list
**Pattern Recognition**: 
- Values in range [0, n-1] or [1, n]
- Can use value as next index
- Creates implicit linked list structure

## Common Mistakes

### Mistake 1: Starting pointers at different positions
```python
# WRONG
slow = 0
fast = 1  # Different start

# CORRECT
slow = nums[0]
fast = nums[0]  # Same start
```

### Mistake 2: Moving fast pointer incorrectly
```python
# WRONG
fast = nums[fast]
fast = nums[fast]  # Two separate moves

# CORRECT
fast = nums[nums[fast]]  # One statement, 2 steps
```

### Mistake 3: Not resetting slow in Phase 2
```python
# WRONG - slow continues from meeting point
while slow != fast:
    slow = nums[slow]
    fast = nums[fast]

# CORRECT - reset slow to start
slow = nums[0]
while slow != fast:
    slow = nums[slow]
    fast = nums[fast]
```

### Mistake 4: Using `while slow != fast` in Phase 1
```python
# WRONG - might never enter loop if both start at same value
while slow != fast:
    slow = nums[slow]
    fast = nums[nums[fast]]

# CORRECT - use do-while pattern
while True:
    slow = nums[slow]
    fast = nums[nums[fast]]
    if slow == fast:
        break
```

## Edge Cases

1. **Minimum size**: `[1,1]` → 1
2. **All same**: `[3,3,3,3,3]` → 3
3. **Duplicate at start**: `[2,1,2,3,4]` → 2
4. **Duplicate at end**: `[1,2,3,4,4]` → 4
5. **Large array**: Works efficiently with O(n) time

## Pattern Variations

### 1. Linked List Cycle Detection
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

### 2. Find Cycle Start in Linked List
```python
def detectCycle(head):
    slow = fast = head
    
    # Phase 1: Detect cycle
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        
        if slow == fast:
            break
    else:
        return None  # No cycle
    
    # Phase 2: Find entrance
    slow = head
    while slow != fast:
        slow = slow.next
        fast = fast.next
    
    return slow
```

### 3. Find Middle of Linked List
```python
def findMiddle(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    return slow  # Slow is at middle
```

### 4. Happy Number
```python
def isHappy(n):
    def get_next(num):
        return sum(int(digit)**2 for digit in str(num))
    
    slow = n
    fast = get_next(n)
    
    while fast != 1 and slow != fast:
        slow = get_next(slow)
        fast = get_next(get_next(fast))
    
    return fast == 1
```

## Visual Representation

```
Array: [1, 3, 4, 2, 2]
Index:  0  1  2  3  4

As Linked List:
    0 → 1 → 3 → 2 → 4
                ↓   ↑
                +---+
            (cycle here!)

Phase 1 - Detect Cycle:
Step 1: slow=1, fast=3
    0 → 1 → 3 → 2 → 4
        s       f   ↑
                    |
                    +

Step 2: slow=3, fast=2
    0 → 1 → 3 → 2 → 4
            s   f   ↑
                    |
                    +

Step 3: slow=2, fast=2 (MEET!)
    0 → 1 → 3 → 2 → 4
                s,f ↑
                    |
                    +

Phase 2 - Find Entrance:
Reset slow to 0, fast stays at 2

Step 1: slow=1, fast=4
    0 → 1 → 3 → 2 → 4
        s           f

Step 2: slow=3, fast=2
    0 → 1 → 3 → 2 → 4
            s   f

Step 3: slow=2, fast=4
    0 → 1 → 3 → 2 → 4
                s   f

Step 4: slow=4, fast=2
    0 → 1 → 3 → 2 → 4
                f   s

Step 5: slow=2, fast=4
    0 → 1 → 3 → 2 → 4
                s,f

FOUND! Duplicate = 2
```

## Interview Tips

### 1. Recognize the Pattern
**Clues**:
- Array with values as indices
- Find duplicate/cycle
- O(1) space constraint
- Can't modify array

### 2. Explain the Intuition
"We treat the array as a linked list where each value points to the next index. The duplicate creates a cycle, which we detect using Floyd's algorithm."

### 3. Walk Through Example
Always trace through a small example to show both phases.

### 4. Discuss Trade-offs
- Floyd's: O(n) time, O(1) space, doesn't modify
- Hash Set: O(n) time, O(n) space, simpler
- Sorting: O(n log n) time, modifies array

### 5. Handle Edge Cases
- What if no duplicate? (Problem guarantees one exists)
- What if multiple duplicates? (Problem says only one)
- What about negative numbers? (Problem says [1, n])

## Key Takeaways

1. **Array as Linked List**: When values are indices, think graph/linked list
2. **Floyd's Algorithm**: Two phases - detect cycle, find entrance
3. **Slow and Fast pointers**: Classic pattern for cycle detection
4. **Mathematical proof**: Distance relationships prove correctness
5. **O(1) space solution**: Possible without modifying array
6. **Pattern applies broadly**: Linked lists, arrays, sequences

## Practice Problems

### Similar Problems:
1. LeetCode 287: Find the Duplicate Number ⭐
2. LeetCode 142: Linked List Cycle II
3. LeetCode 141: Linked List Cycle
4. LeetCode 202: Happy Number
5. LeetCode 876: Middle of the Linked List

### Difficulty Progression:
- Easy: Linked List Cycle (141)
- Medium: Find Duplicate Number (287)
- Medium: Linked List Cycle II (142)
- Hard: Understanding the proof

## Summary

**Problem**: Find duplicate in array without extra space or modification

**Solution**: Floyd's Cycle Detection
- Phase 1: Detect cycle (slow & fast meet)
- Phase 2: Find entrance (reset slow, move both 1 step)

**Why it works**: Mathematical relationship between distances

**Time**: O(n), **Space**: O(1)

**Remember**: "Treat array as linked list, find the cycle entrance!"


---

## See Also

📚 **For comprehensive duplicate problem patterns**, see:
- `duplicate-patterns-guide.md` - Complete guide covering 7 different duplicate problem types with patterns, when to use each approach, and comparison tables

This guide covers:
- Contains Duplicate (Hash Set)
- Find Duplicate (Floyd's Cycle) ← Current problem
- Find All Duplicates (Index Marking)
- Remove Duplicates Sorted (Two Pointers)
- Remove Duplicates Unsorted (Set + Two Pointers)
- Duplicate within distance k (Sliding Window)
- Duplicate within value range (Bucket Sort)

**Quick Pattern Selector:**
- No constraints → Hash Set
- O(1) space + can't modify → Floyd's Cycle (this problem)
- O(1) space + can modify → Index Marking
- Sorted array → Two Pointers
- Distance constraint → Sliding Window
