# Day 19 - Advanced Stack Patterns & Monotonic Stack

## Core Stack Concepts Deep Dive

### What is a Stack?

**Definition:** A linear data structure following LIFO (Last In, First Out) principle

**Real-world Analogy:**
- Stack of plates: Add/remove from top only
- Browser history: Back button removes most recent page
- Undo/Redo: Most recent action undone first

**Operations:**
```python
push(x)    # Add element to top - O(1)
pop()      # Remove top element - O(1)
peek()     # View top element - O(1)
isEmpty()  # Check if empty - O(1)
size()     # Get number of elements - O(1)
```

---

## Types of Stacks

### 1. Simple Stack (Basic Stack)
**Description:** Standard LIFO stack
**Use Case:** General purpose, function calls, undo/redo
```python
stack = []
stack.append(1)  # push
stack.pop()      # pop
```

### 2. Monotonic Stack ⭐
**Description:** Maintains elements in monotonic order (increasing or decreasing)
**Types:**
- **Monotonic Increasing:** Elements increase bottom to top
- **Monotonic Decreasing:** Elements decrease bottom to top

**Use Case:** Next greater/smaller element, histogram problems
```python
# Monotonic Decreasing
stack = []
for num in arr:
    while stack and stack[-1] < num:
        stack.pop()
    stack.append(num)
# Result: [largest, ..., smallest]
```

### 3. Min/Max Stack
**Description:** Stack that tracks minimum/maximum in O(1)
**Use Case:** Get min/max without scanning entire stack
```python
class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []
    
    def push(self, val):
        self.stack.append(val)
        min_val = min(val, self.min_stack[-1] if self.min_stack else val)
        self.min_stack.append(min_val)
    
    def getMin(self):
        return self.min_stack[-1]
```

### 4. Two Stack (Deque Simulation)
**Description:** Two stacks to simulate queue or deque
**Use Case:** Implement queue using stacks
```python
class QueueUsingStacks:
    def __init__(self):
        self.stack1 = []  # For enqueue
        self.stack2 = []  # For dequeue
    
    def enqueue(self, x):
        self.stack1.append(x)
    
    def dequeue(self):
        if not self.stack2:
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        return self.stack2.pop() if self.stack2 else None
```

### 5. Auxiliary Stack
**Description:** Additional stack to track extra information
**Use Case:** Track min/max, frequency, or other properties
```python
class StackWithFrequency:
    def __init__(self):
        self.stack = []
        self.freq_stack = []  # Track frequency at each level
```

### 6. Bounded Stack (Fixed Size)
**Description:** Stack with maximum capacity
**Use Case:** Memory-constrained environments
```python
class BoundedStack:
    def __init__(self, capacity):
        self.capacity = capacity
        self.stack = []
    
    def push(self, val):
        if len(self.stack) < self.capacity:
            self.stack.append(val)
        else:
            raise Exception("Stack Overflow")
```

### 7. Persistent Stack (Immutable)
**Description:** Stack where operations create new versions
**Use Case:** Functional programming, version control
```python
class PersistentStack:
    def __init__(self, items=None):
        self.items = items or []
    
    def push(self, val):
        return PersistentStack(self.items + [val])
    
    def pop(self):
        return PersistentStack(self.items[:-1]), self.items[-1]
```

### 8. Indexed Stack
**Description:** Stack with random access by index
**Use Case:** When need both stack and array operations
```python
class IndexedStack:
    def __init__(self):
        self.items = []
    
    def push(self, val):
        self.items.append(val)
    
    def get(self, index):
        return self.items[index]  # O(1) access
```

### 9. Concurrent Stack (Thread-Safe)
**Description:** Stack safe for multi-threaded access
**Use Case:** Parallel processing, multi-threading
```python
import threading

class ConcurrentStack:
    def __init__(self):
        self.stack = []
        self.lock = threading.Lock()
    
    def push(self, val):
        with self.lock:
            self.stack.append(val)
    
    def pop(self):
        with self.lock:
            return self.stack.pop() if self.stack else None
```

### 10. Lazy Stack
**Description:** Stack that defers operations until needed
**Use Case:** Optimization, batch processing
```python
class LazyStack:
    def __init__(self):
        self.operations = []  # Store operations
    
    def push(self, val):
        self.operations.append(('push', val))
    
    def evaluate(self):
        stack = []
        for op, val in self.operations:
            if op == 'push':
                stack.append(val)
        return stack
```

---

## Stack Type Comparison

| Type | Space | getMin/Max | Use Case |
|------|-------|------------|----------|
| Simple | O(n) | O(n) | General purpose |
| Monotonic | O(n) | O(1) | Next greater/smaller |
| Min/Max | O(n) | O(1) | Track extremes |
| Two Stack | O(n) | O(n) | Queue simulation |
| Auxiliary | O(n) | Varies | Extra tracking |
| Bounded | O(k) | O(k) | Fixed memory |
| Persistent | O(n*m) | O(n) | Immutability |
| Indexed | O(n) | O(n) | Random access |
| Concurrent | O(n) | O(n) | Thread-safe |
| Lazy | O(n) | O(n) | Deferred execution |

---

## When to Use Each Type

```
Use Simple Stack when:
✓ Basic LIFO operations
✓ Function call stack
✓ Undo/Redo
✓ Backtracking

Use Monotonic Stack when:
✓ Next greater/smaller element
✓ Histogram problems
✓ Stock span problems
✓ Need O(n) for comparisons

Use Min/Max Stack when:
✓ Need constant time min/max
✓ Sliding window problems
✓ Range queries

Use Two Stack when:
✓ Implement queue with stacks
✓ Palindrome checking
✓ Reverse operations

Use Auxiliary Stack when:
✓ Track additional properties
✓ Frequency counting
✓ State management

Use Bounded Stack when:
✓ Memory constraints
✓ Prevent overflow
✓ Fixed capacity needed

Use Persistent Stack when:
✓ Functional programming
✓ Need history/versions
✓ Immutability required

Use Indexed Stack when:
✓ Need random access
✓ Both stack and array ops
✓ Frequent lookups

Use Concurrent Stack when:
✓ Multi-threaded environment
✓ Parallel processing
✓ Race condition prevention

Use Lazy Stack when:
✓ Batch operations
✓ Optimization needed
✓ Deferred execution
```

---

## Stack Implementation

### Using Python List
```python
class Stack:
    def __init__(self):
        self.items = []
    
    def push(self, item):
        self.items.append(item)
    
    def pop(self):
        if not self.is_empty():
            return self.items.pop()
        return None
    
    def peek(self):
        if not self.is_empty():
            return self.items[-1]
        return None
    
    def is_empty(self):
        return len(self.items) == 0
    
    def size(self):
        return len(self.items)
```

### Using Linked List
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Stack:
    def __init__(self):
        self.top = None
        self.count = 0
    
    def push(self, data):
        new_node = Node(data)
        new_node.next = self.top
        self.top = new_node
        self.count += 1
    
    def pop(self):
        if self.top:
            data = self.top.data
            self.top = self.top.next
            self.count -= 1
            return data
        return None
```

---

## Stack Patterns & Algorithms

### Pattern 1: Monotonic Stack

**Definition:** Stack that maintains elements in monotonic order (increasing or decreasing)

**Types:**
1. **Monotonic Increasing:** Elements increase from bottom to top
2. **Monotonic Decreasing:** Elements decrease from bottom to top

**When to Use:**
- Find next greater/smaller element
- Find previous greater/smaller element
- Calculate spans, ranges, or distances

**Template:**
```python
# Monotonic Decreasing (for next greater element)
def next_greater(arr):
    stack = []
    result = [-1] * len(arr)
    
    for i in range(len(arr)):
        while stack and arr[stack[-1]] < arr[i]:
            idx = stack.pop()
            result[idx] = arr[i]
        stack.append(i)
    
    return result

# Monotonic Increasing (for next smaller element)
def next_smaller(arr):
    stack = []
    result = [-1] * len(arr)
    
    for i in range(len(arr)):
        while stack and arr[stack[-1]] > arr[i]:
            idx = stack.pop()
            result[idx] = arr[i]
        stack.append(i)
    
    return result
```

---

### Pattern 2: Expression Evaluation

**Infix to Postfix Conversion:**
```python
def infix_to_postfix(expression):
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    stack = []
    output = []
    
    for char in expression:
        if char.isalnum():
            output.append(char)
        elif char == '(':
            stack.append(char)
        elif char == ')':
            while stack and stack[-1] != '(':
                output.append(stack.pop())
            stack.pop()  # Remove '('
        else:  # Operator
            while (stack and stack[-1] != '(' and
                   precedence.get(stack[-1], 0) >= precedence[char]):
                output.append(stack.pop())
            stack.append(char)
    
    while stack:
        output.append(stack.pop())
    
    return ''.join(output)
```

---

### Pattern 3: Backtracking with Stack

**DFS Traversal:**
```python
def dfs_iterative(graph, start):
    visited = set()
    stack = [start]
    
    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            # Process node
            for neighbor in graph[node]:
                if neighbor not in visited:
                    stack.append(neighbor)
    
    return visited
```

---

### Pattern 4: Stock Span Problem

**Find span of stock prices:**
```python
def calculate_span(prices):
    stack = []
    spans = []
    
    for i, price in enumerate(prices):
        # Pop elements while current price is greater
        while stack and prices[stack[-1]] <= price:
            stack.pop()
        
        # Span is distance to previous greater element
        span = i + 1 if not stack else i - stack[-1]
        spans.append(span)
        stack.append(i)
    
    return spans
```

---

### Pattern 5: Histogram Problems

**Maximum rectangle in histogram:**
```python
def largest_rectangle(heights):
    stack = []
    max_area = 0
    
    for i, h in enumerate(heights):
        start = i
        while stack and stack[-1][0] > h:
            height, index = stack.pop()
            max_area = max(max_area, height * (i - index))
            start = index
        stack.append((h, start))
    
    # Process remaining
    for h, i in stack:
        max_area = max(max_area, h * (len(heights) - i))
    
    return max_area
```

---

## Problem 1: Daily Temperatures

### Problem Statement
**Input:** `temperatures = [73,74,75,71,69,72,76,73]`
**Output:** `[1,1,4,2,1,1,0,0]`

**Goal:** For each day, find how many days until a warmer temperature

---

### Problem Logic

**Key Insight:** Use monotonic decreasing stack to track temperatures waiting for warmer day

**Approach:**
- Stack stores indices of temperatures
- When warmer temperature found, pop all colder temperatures
- Calculate days difference

**Why Monotonic Stack?**
- Need to find "next greater element"
- Stack maintains decreasing order
- When greater element found, all smaller elements get their answer

---

### Solution Patterns

#### Pattern 1: Monotonic Stack (Optimal) ⭐

**Pseudocode:**
```
FUNCTION dailyTemperatures(temps):
    CREATE result = [0] * len(temps)
    CREATE stack = []  // stores (temp, index)
    
    FOR i, temp in enumerate(temps):
        WHILE stack not empty AND stack.top.temp < temp:
            POP old_temp, old_index from stack
            SET result[old_index] = i - old_index
        PUSH (temp, i) to stack
    
    RETURN result
```

**Code:**
```python
def dailyTemperatures(temperatures):
    n = len(temperatures)
    result = [0] * n
    stack = []  # Store indices
    
    for i, temp in enumerate(temperatures):
        # Pop all temperatures colder than current
        while stack and temperatures[stack[-1]] < temp:
            prev_index = stack.pop()
            result[prev_index] = i - prev_index
        
        stack.append(i)
    
    return result
```

**Complexity:**
- Time: O(n) - each element pushed/popped once
- Space: O(n) - stack size

---

#### Pattern 2: Reverse Iteration

**Code:**
```python
def dailyTemperatures(temperatures):
    n = len(temperatures)
    result = [0] * n
    stack = []
    
    # Iterate from right to left
    for i in range(n - 1, -1, -1):
        # Pop elements <= current temperature
        while stack and temperatures[stack[-1]] <= temperatures[i]:
            stack.pop()
        
        # If stack not empty, calculate days
        if stack:
            result[i] = stack[-1] - i
        
        stack.append(i)
    
    return result
```

**Complexity:**
- Time: O(n)
- Space: O(n)

---

#### Pattern 3: Optimized Without Stack

**Code:**
```python
def dailyTemperatures(temperatures):
    n = len(temperatures)
    result = [0] * n
    hottest = 0
    
    for i in range(n - 1, -1, -1):
        if temperatures[i] >= hottest:
            hottest = temperatures[i]
            continue
        
        days = 1
        while temperatures[i + days] <= temperatures[i]:
            # Jump using previously computed results
            days += result[i + days]
        result[i] = days
    
    return result
```

**Complexity:**
- Time: O(n) - amortized
- Space: O(1) - excluding output

---

### Flow Diagram

```
Input: [73, 74, 75, 71, 69, 72, 76, 73]

Step 1: i=0, temp=73
        Stack: [(73, 0)]
        Result: [0, 0, 0, 0, 0, 0, 0, 0]

Step 2: i=1, temp=74 > 73
        Pop (73, 0), result[0] = 1 - 0 = 1
        Stack: [(74, 1)]
        Result: [1, 0, 0, 0, 0, 0, 0, 0]

Step 3: i=2, temp=75 > 74
        Pop (74, 1), result[1] = 2 - 1 = 1
        Stack: [(75, 2)]
        Result: [1, 1, 0, 0, 0, 0, 0, 0]

Step 4: i=3, temp=71 < 75
        Stack: [(75, 2), (71, 3)]
        Result: [1, 1, 0, 0, 0, 0, 0, 0]

Step 5: i=4, temp=69 < 71
        Stack: [(75, 2), (71, 3), (69, 4)]
        Result: [1, 1, 0, 0, 0, 0, 0, 0]

Step 6: i=5, temp=72 > 69, 72 > 71
        Pop (69, 4), result[4] = 5 - 4 = 1
        Pop (71, 3), result[3] = 5 - 3 = 2
        Stack: [(75, 2), (72, 5)]
        Result: [1, 1, 0, 2, 1, 0, 0, 0]

Step 7: i=6, temp=76 > 72, 76 > 75
        Pop (72, 5), result[5] = 6 - 5 = 1
        Pop (75, 2), result[2] = 6 - 2 = 4
        Stack: [(76, 6)]
        Result: [1, 1, 4, 2, 1, 1, 0, 0]

Step 8: i=7, temp=73 < 76
        Stack: [(76, 6), (73, 7)]
        Result: [1, 1, 4, 2, 1, 1, 0, 0]

Final: [1, 1, 4, 2, 1, 1, 0, 0]
```

---

## Problem 2: Largest Rectangle in Histogram

### Problem Statement
**Input:** `heights = [2,1,5,6,2,3]`
**Output:** `10`

**Visual:**
```
    6
  5 █
  █ █
  █ █   3
  █ █ 2 █
2 █ █ █ █
█ █ █ █ █
```
**Largest rectangle:** height=5, width=2, area=10

---

### Problem Logic

**Key Insight:** For each bar, find maximum rectangle with that bar as the smallest height

**Approach:**
- Use monotonic increasing stack
- When shorter bar found, calculate rectangles for all taller bars
- Width = distance between boundaries

**Why Monotonic Stack?**
- Need to find boundaries where height decreases
- Stack maintains increasing heights
- When decrease found, we know the extent of previous bars

---

### Solution Patterns

#### Pattern 1: Monotonic Stack (Optimal) ⭐

**Pseudocode:**
```
FUNCTION largestRectangle(heights):
    CREATE stack = []  // stores (height, start_index)
    SET max_area = 0
    
    FOR i, height in enumerate(heights):
        SET start = i
        
        WHILE stack not empty AND stack.top.height > height:
            POP h, index from stack
            CALCULATE area = h * (i - index)
            UPDATE max_area
            SET start = index
        
        PUSH (height, start) to stack
    
    // Process remaining bars
    FOR height, index in stack:
        CALCULATE area = height * (n - index)
        UPDATE max_area
    
    RETURN max_area
```

**Code:**
```python
def largestRectangleArea(heights):
    stack = []
    max_area = 0
    
    for i, h in enumerate(heights):
        start = i
        
        # Pop taller bars and calculate their areas
        while stack and stack[-1][0] > h:
            height, index = stack.pop()
            max_area = max(max_area, height * (i - index))
            start = index
        
        stack.append((h, start))
    
    # Process remaining bars
    for h, i in stack:
        max_area = max(max_area, h * (len(heights) - i))
    
    return max_area
```

**Complexity:**
- Time: O(n) - each bar pushed/popped once
- Space: O(n) - stack size

---

#### Pattern 2: Stack with Sentinel

**Code:**
```python
def largestRectangleArea(heights):
    stack = []
    max_area = 0
    heights.append(0)  # Sentinel to process all bars
    
    for i in range(len(heights)):
        while stack and heights[stack[-1]] > heights[i]:
            h = heights[stack.pop()]
            
            # Calculate width
            if not stack:
                width = i
            else:
                width = i - stack[-1] - 1
            
            max_area = max(max_area, h * width)
        
        stack.append(i)
    
    return max_area
```

**Complexity:**
- Time: O(n)
- Space: O(n)

---

### Flow Diagram

```
Input: [2, 1, 5, 6, 2, 3]

Step 1: i=0, h=2
        Stack: [(2, 0)]
        max_area = 0

Step 2: i=1, h=1 < 2
        Pop (2, 0), area = 2 * (1 - 0) = 2
        Stack: [(1, 0)]  // start extended to 0
        max_area = 2

Step 3: i=2, h=5 > 1
        Stack: [(1, 0), (5, 2)]
        max_area = 2

Step 4: i=3, h=6 > 5
        Stack: [(1, 0), (5, 2), (6, 3)]
        max_area = 2

Step 5: i=4, h=2 < 6, 2 < 5
        Pop (6, 3), area = 6 * (4 - 3) = 6
        Pop (5, 2), area = 5 * (4 - 2) = 10 ✓
        Stack: [(1, 0), (2, 2)]  // start extended to 2
        max_area = 10

Step 6: i=5, h=3 > 2
        Stack: [(1, 0), (2, 2), (3, 5)]
        max_area = 10

End: Process remaining
     (3, 5): area = 3 * (6 - 5) = 3
     (2, 2): area = 2 * (6 - 2) = 8
     (1, 0): area = 1 * (6 - 0) = 6

Final: max_area = 10
```

---

### Visual Explanation

```
Heights: [2, 1, 5, 6, 2, 3]

For height 5 at index 2:
  - Can extend left to index 2 (stopped by 1)
  - Can extend right to index 3 (stopped by 2)
  - Width = 4 - 2 = 2
  - Area = 5 * 2 = 10 ✓

    6
  5 █
  █ █
  █ █   3
  █ █ 2 █
2 █ █ █ █
█ █ █ █ █
0 1 2 3 4 5

Rectangle: indices 2-3, height 5
```

---

## Comparison Table

### Daily Temperatures

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Monotonic Stack | O(n) | O(n) | **Optimal** ⭐ |
| Reverse + Stack | O(n) | O(n) | Alternative |
| Optimized No Stack | O(n) | O(1) | Space-critical |
| Brute Force | O(n²) | O(1) | Small inputs |

### Largest Rectangle

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Monotonic Stack | O(n) | O(n) | **Optimal** ⭐ |
| Stack + Sentinel | O(n) | O(n) | Cleaner code |
| Divide & Conquer | O(n log n) | O(log n) | Recursive |
| Brute Force | O(n²) | O(1) | Small inputs |

---

## Advanced Stack Patterns

### Pattern 6: Next Greater Element Circular

```python
def nextGreaterCircular(nums):
    n = len(nums)
    result = [-1] * n
    stack = []
    
    # Process array twice for circular
    for i in range(2 * n):
        while stack and nums[stack[-1]] < nums[i % n]:
            result[stack.pop()] = nums[i % n]
        if i < n:
            stack.append(i)
    
    return result
```

---

### Pattern 7: Trapping Rain Water

```python
def trap(height):
    stack = []
    water = 0
    
    for i, h in enumerate(height):
        while stack and height[stack[-1]] < h:
            bottom = stack.pop()
            if not stack:
                break
            
            distance = i - stack[-1] - 1
            bounded_height = min(h, height[stack[-1]]) - height[bottom]
            water += distance * bounded_height
        
        stack.append(i)
    
    return water
```

---

### Pattern 8: Remove K Digits

```python
def removeKdigits(num, k):
    stack = []
    
    for digit in num:
        while k > 0 and stack and stack[-1] > digit:
            stack.pop()
            k -= 1
        stack.append(digit)
    
    # Remove remaining k digits
    stack = stack[:-k] if k else stack
    
    # Remove leading zeros
    return ''.join(stack).lstrip('0') or '0'
```

---

## Stack Applications Summary

| Application | Pattern | Example |
|-------------|---------|---------|
| Matching Pairs | Basic Stack | Parentheses, Tags |
| Next Greater/Smaller | Monotonic Stack | Daily Temps, Stock Span |
| Expression Evaluation | Operator Stack | Calculator, RPN |
| Histogram Problems | Monotonic Stack | Largest Rectangle |
| Backtracking | DFS Stack | Maze, Sudoku |
| Undo/Redo | Command Stack | Text Editor |
| Function Calls | Call Stack | Recursion |

---

## Common Mistakes

### Daily Temperatures:
1. **Storing temperatures instead of indices** - Need indices for distance calculation
2. **Not handling last element** - Should remain 0
3. **Wrong comparison** - Use `<` not `<=` for strictly warmer

### Largest Rectangle:
1. **Forgetting to process remaining stack** - Bars extending to end
2. **Wrong width calculation** - Must account for popped bars
3. **Not extending start index** - When popping, extend to popped index

### General Monotonic Stack:
1. **Wrong monotonic order** - Increasing vs decreasing
2. **Not saving index** - Often need position, not just value
3. **Forgetting edge cases** - Empty stack, single element

---

## Quick Reference

### Monotonic Stack Template:
```python
# Next Greater Element
stack = []
result = [-1] * n
for i in range(n):
    while stack and arr[stack[-1]] < arr[i]:
        result[stack.pop()] = arr[i]
    stack.append(i)
```

### When to Use Monotonic Stack:
- ✓ Find next/previous greater/smaller
- ✓ Calculate spans or ranges
- ✓ Histogram-type problems
- ✓ Need O(n) solution for comparisons

---

## Key Takeaways

1. **Monotonic stack** solves "next greater/smaller" in O(n)
2. **Each element** pushed and popped at most once
3. **Store indices** not values (usually need position)
4. **Increasing stack** for next smaller, **decreasing** for next greater
5. **Process remaining** stack at end
6. **Extend boundaries** when popping (histogram problems)
7. **Stack = LIFO** - perfect for nested/recent tracking
8. **Amortized O(n)** - total operations across all elements

---

## Practice Problems

**Monotonic Stack:**
- Next Greater Element I, II
- Online Stock Span
- Sum of Subarray Minimums
- Maximal Rectangle

**Histogram:**
- Largest Rectangle in Histogram
- Maximal Rectangle in Binary Matrix
- Trapping Rain Water

**Expression:**
- Basic Calculator I, II, III
- Decode String
- Remove K Digits
