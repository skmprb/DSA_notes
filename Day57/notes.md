# Day 57: Fibonacci Number

## Problem Statement
**LeetCode 509: Fibonacci Number**

The Fibonacci numbers, commonly denoted F(n) form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1.

**Formula:**
```
F(0) = 0
F(1) = 1
F(n) = F(n-1) + F(n-2), for n > 1
```

Given n, calculate F(n).

**Examples:**
```
Input: n = 2
Output: 1
Explanation: F(2) = F(1) + F(0) = 1 + 0 = 1

Input: n = 3
Output: 2
Explanation: F(3) = F(2) + F(1) = 1 + 1 = 2

Input: n = 4
Output: 3
Explanation: F(4) = F(3) + F(2) = 2 + 1 = 3
```

**Constraints:**
- 0 <= n <= 30

---

## Problem Logic & Reasoning

### Core Concept
The Fibonacci sequence is a classic example of a **recursive relationship** where each number depends on the previous two numbers.

**Key Insight:** This is the foundation problem for understanding Dynamic Programming!

### Visual Understanding - The Fibonacci Sequence

```
Position:  0  1  2  3  4  5  6  7  8  9  10
Value:     0  1  1  2  3  5  8  13 21 34 55
           ↑  ↑
         Base cases

Pattern:
F(2) = F(1) + F(0) = 1 + 0 = 1
F(3) = F(2) + F(1) = 1 + 1 = 2
F(4) = F(3) + F(2) = 2 + 1 = 3
F(5) = F(4) + F(3) = 3 + 2 = 5
F(6) = F(5) + F(4) = 5 + 3 = 8
```

### Breaking Down F(5)

```
F(5) = F(4) + F(3)
     = (F(3) + F(2)) + (F(2) + F(1))
     = ((F(2) + F(1)) + (F(1) + F(0))) + ((F(1) + F(0)) + F(1))
     = ((1 + 1) + (1 + 0)) + ((1 + 0) + 1)
     = (2 + 1) + (1 + 1)
     = 3 + 2
     = 5
```

### The Recursion Tree for F(5)

```
                    F(5)
                   /    \
                F(4)      F(3)
               /   \      /   \
            F(3)   F(2) F(2)  F(1)
           /  \    /  \  /  \
        F(2) F(1) F(1) F(0) F(1) F(0)
        /  \
     F(1) F(0)

Notice:
- F(3) is calculated 2 times
- F(2) is calculated 3 times
- F(1) is calculated 5 times
- F(0) is calculated 3 times

This is MASSIVE redundancy! 🔴
```

### Why This Problem is Important

```
Fibonacci teaches us:
1. Recursion basics
2. Overlapping subproblems
3. Memoization (caching)
4. Dynamic Programming
5. Space optimization

It's the "Hello World" of DP!
```

---

## Approach 1: Naive Recursion ⭐

### Logic
Directly implement the mathematical definition:
- Base cases: F(0) = 0, F(1) = 1
- Recursive case: F(n) = F(n-1) + F(n-2)

### Visual Flow for F(5)

```
Call Stack Visualization:

fib(5)
  → fib(4)
      → fib(3)
          → fib(2)
              → fib(1) = 1
              → fib(0) = 0
              → return 1
          → fib(1) = 1
          → return 2
      → fib(2)
          → fib(1) = 1
          → fib(0) = 0
          → return 1
      → return 3
  → fib(3)
      → fib(2)
          → fib(1) = 1
          → fib(0) = 0
          → return 1
      → fib(1) = 1
      → return 2
  → return 5

Total function calls: 15 calls for F(5)!
```

### Step-by-Step Execution

```
fib(4):
  Call 1: fib(4)
  Call 2:   fib(3)
  Call 3:     fib(2)
  Call 4:       fib(1) → 1
  Call 5:       fib(0) → 0
            fib(2) → 1
  Call 6:     fib(1) → 1
          fib(3) → 2
  Call 7:   fib(2)
  Call 8:     fib(1) → 1
  Call 9:     fib(0) → 0
          fib(2) → 1
        fib(4) → 3

Total: 9 function calls for F(4)
```

### The Exponential Growth Problem

```
Number of calls for each n:

n = 0: 1 call
n = 1: 1 call
n = 2: 3 calls
n = 3: 5 calls
n = 4: 9 calls
n = 5: 15 calls
n = 6: 25 calls
n = 10: 177 calls
n = 20: 21,891 calls
n = 30: 2,692,537 calls! 😱

Pattern: Approximately 2^n calls
```

### Pseudocode
```
function fib(n):
    if n <= 1:
        return n
    
    return fib(n-1) + fib(n-2)
```

### Implementation
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        return self.fib(n - 1) + self.fib(n - 2)
```

### Complexity Analysis
- **Time:** O(2^n) - Exponential! Each call makes 2 more calls
- **Space:** O(n) - Recursion stack depth

### Why This is Terrible

```
For n = 30:
- Makes ~2.7 million function calls
- Takes several seconds
- Recalculates same values millions of times

Example: F(2) is calculated 514,229 times! 🤯

This is why we need optimization!
```

---

## Approach 2: Memoization (Top-Down DP) ⭐⭐⭐

### Logic
Cache the results of subproblems to avoid recalculation:
1. Create a memo array to store computed values
2. Before computing, check if value is already in memo
3. If yes, return cached value
4. If no, compute and store in memo

### Visual Flow for F(5) with Memoization

```
Initial: memo = [-1, -1, -1, -1, -1, -1]
         (indices 0 to 5)

Call fib(5):
  memo[5] = -1 (not computed)
  
  Call fib(4):
    memo[4] = -1 (not computed)
    
    Call fib(3):
      memo[3] = -1 (not computed)
      
      Call fib(2):
        memo[2] = -1 (not computed)
        
        Call fib(1): return 1 (base case)
        Call fib(0): return 0 (base case)
        
        memo[2] = 1 + 0 = 1 ✓
        return 1
      
      Call fib(1): return 1 (base case)
      
      memo[3] = 1 + 1 = 2 ✓
      return 2
    
    Call fib(2):
      memo[2] = 1 (already computed!) ✓
      return 1 (no recursion needed!)
    
    memo[4] = 2 + 1 = 3 ✓
    return 3
  
  Call fib(3):
    memo[3] = 2 (already computed!) ✓
    return 2 (no recursion needed!)
  
  memo[5] = 3 + 2 = 5 ✓
  return 5

Final memo: [0, 1, 1, 2, 3, 5]

Total function calls: 9 calls (vs 15 without memo!)
```

### Comparison: With vs Without Memoization

```
Without Memoization (F(5)):
                    F(5)
                   /    \
                F(4)      F(3)
               /   \      /   \
            F(3)   F(2) F(2)  F(1)
           /  \    /  \  /  \
        F(2) F(1) F(1) F(0) F(1) F(0)
        /  \
     F(1) F(0)

Total: 15 calls

With Memoization (F(5)):
                    F(5)
                   /    \
                F(4)      F(3) ← cached!
               /   \      
            F(3)   F(2) ← cached!
           /  \    
        F(2) F(1)
        /  \
     F(1) F(0)

Total: 9 calls (40% reduction!)
```

### Step-by-Step with Memo Array

```
n = 5, memo = [-1, -1, -1, -1, -1, -1]

Step 1: fib(5)
  memo[5] = -1, need to compute

Step 2: fib(4)
  memo[4] = -1, need to compute

Step 3: fib(3)
  memo[3] = -1, need to compute

Step 4: fib(2)
  memo[2] = -1, need to compute

Step 5: fib(1)
  return 1 (base case)

Step 6: fib(0)
  return 0 (base case)

Step 7: Back to fib(2)
  memo[2] = 1 + 0 = 1
  memo = [-1, -1, 1, -1, -1, -1]

Step 8: Back to fib(3), need fib(1)
  return 1 (base case)

Step 9: Back to fib(3)
  memo[3] = 1 + 1 = 2
  memo = [-1, -1, 1, 2, -1, -1]

Step 10: Back to fib(4), need fib(2)
  memo[2] = 1 (cached!) ✓
  return 1

Step 11: Back to fib(4)
  memo[4] = 2 + 1 = 3
  memo = [-1, -1, 1, 2, 3, -1]

Step 12: Back to fib(5), need fib(3)
  memo[3] = 2 (cached!) ✓
  return 2

Step 13: Back to fib(5)
  memo[5] = 3 + 2 = 5
  memo = [-1, -1, 1, 2, 3, 5]

Result: 5
```

### Pseudocode
```
function fib(n):
    memo = array of size (n+1) filled with -1
    
    function helper(n):
        // Check if already computed
        if memo[n] != -1:
            return memo[n]
        
        // Base cases
        if n <= 1:
            return n
        
        // Compute and store
        memo[n] = helper(n-1) + helper(n-2)
        
        return memo[n]
    
    return helper(n)
```

### Implementation
```python
class Solution:
    def fib(self, n: int) -> int:
        memo = [-1] * (n + 1)
        
        def helper(n):
            # Check cache
            if memo[n] != -1:
                return memo[n]
            
            # Base cases
            if n <= 1:
                return n
            
            # Compute and cache
            memo[n] = helper(n - 1) + helper(n - 2)
            
            return memo[n]
        
        return helper(n)
```

### Complexity Analysis
- **Time:** O(n) - Each value computed once
- **Space:** O(n) - Memo array + recursion stack

### Why This is Much Better

```
For n = 30:
Without memo: ~2.7 million calls
With memo: 59 calls

Speedup: 45,000x faster! 🚀

Each F(i) is computed exactly once
Then reused from cache
```

---

## Approach 3: Tabulation (Bottom-Up DP) ⭐⭐⭐⭐

### Logic
Build the solution iteratively from bottom up:
1. Create a table to store all values from F(0) to F(n)
2. Fill base cases: F(0) = 0, F(1) = 1
3. Iterate from 2 to n, computing each F(i) using previous values
4. Return F(n)

### Visual Flow for F(5)

```
Step-by-step table building:

Initial: dp = [0, 1, _, _, _, _]
              ↑  ↑
           F(0) F(1) (base cases)

i = 2:
  dp[2] = dp[1] + dp[0] = 1 + 0 = 1
  dp = [0, 1, 1, _, _, _]

i = 3:
  dp[3] = dp[2] + dp[1] = 1 + 1 = 2
  dp = [0, 1, 1, 2, _, _]

i = 4:
  dp[4] = dp[3] + dp[2] = 2 + 1 = 3
  dp = [0, 1, 1, 2, 3, _]

i = 5:
  dp[5] = dp[4] + dp[3] = 3 + 2 = 5
  dp = [0, 1, 1, 2, 3, 5]

Result: dp[5] = 5
```

### Detailed Execution

```
n = 6

Initialize:
dp = [0, 1, 0, 0, 0, 0, 0]
      ↑  ↑
    F(0) F(1)

Loop from i = 2 to 6:

i = 2:
  dp[2] = dp[1] + dp[0]
  dp[2] = 1 + 0 = 1
  dp = [0, 1, 1, 0, 0, 0, 0]

i = 3:
  dp[3] = dp[2] + dp[1]
  dp[3] = 1 + 1 = 2
  dp = [0, 1, 1, 2, 0, 0, 0]

i = 4:
  dp[4] = dp[3] + dp[2]
  dp[4] = 2 + 1 = 3
  dp = [0, 1, 1, 2, 3, 0, 0]

i = 5:
  dp[5] = dp[4] + dp[3]
  dp[5] = 3 + 2 = 5
  dp = [0, 1, 1, 2, 3, 5, 0]

i = 6:
  dp[6] = dp[5] + dp[4]
  dp[6] = 5 + 3 = 8
  dp = [0, 1, 1, 2, 3, 5, 8]

Return: dp[6] = 8
```

### Why Bottom-Up is Better Than Top-Down

```
Top-Down (Memoization):
- Starts from F(n)
- Recursively breaks down
- Uses recursion stack
- May not compute all values

Bottom-Up (Tabulation):
- Starts from F(0), F(1)
- Builds up iteratively
- No recursion stack
- Computes all values up to n

Advantages of Bottom-Up:
✓ No recursion overhead
✓ Better cache locality
✓ Easier to optimize space
✓ More predictable performance
```

### Pseudocode
```
function fib(n):
    if n <= 1:
        return n
    
    dp = array of size (n+1)
    dp[0] = 0
    dp[1] = 1
    
    for i from 2 to n:
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

### Implementation
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        dp = [0] * (n + 1)
        dp[0] = 0
        dp[1] = 1
        
        for i in range(2, n + 1):
            dp[i] = dp[i - 1] + dp[i - 2]
        
        return dp[n]
```

### Alternative Implementation (Using List Building)
```python
class Solution:
    def fib(self, n: int) -> int:
        if n == 0:
            return 0
        if n == 1:
            return 1
        
        dp = [0, 1]
        while len(dp) < n + 1:
            dp.append(dp[-1] + dp[-2])
        
        return dp[-1]
```

### Complexity Analysis
- **Time:** O(n) - Single loop from 2 to n
- **Space:** O(n) - DP array of size n+1

### Comparison with Memoization

```
Memoization (Top-Down):
- Recursive
- Space: O(n) array + O(n) stack = O(n)
- May skip some values
- Natural for recursive problems

Tabulation (Bottom-Up):
- Iterative
- Space: O(n) array only
- Computes all values
- Natural for iterative problems

Both have O(n) time and space
But tabulation is slightly faster in practice
```

---

## Approach 4: Space Optimized (Two Variables) ⭐⭐⭐⭐⭐

### Logic
Observe that we only need the last two values to compute the next:
1. Keep only two variables: prev and curr
2. Iterate from 2 to n
3. Update: prev, curr = curr, prev + curr
4. Return curr

### The Key Observation

```
To compute F(i), we only need:
- F(i-1) (previous value)
- F(i-2) (value before previous)

We don't need F(0), F(1), ..., F(i-3)!

Example for F(5):
dp = [0, 1, 1, 2, 3, 5]
              ↑  ↑  ↑
           Don't  Need these
           need   to compute F(5)
           these
```

### Visual Flow for F(5)

```
Initial:
prev = 0 (F(0))
curr = 1 (F(1))

i = 2:
  next = prev + curr = 0 + 1 = 1
  prev = curr = 1
  curr = next = 1
  State: prev=1, curr=1 (F(2)=1)

i = 3:
  next = prev + curr = 1 + 1 = 2
  prev = curr = 1
  curr = next = 2
  State: prev=1, curr=2 (F(3)=2)

i = 4:
  next = prev + curr = 1 + 2 = 3
  prev = curr = 2
  curr = next = 3
  State: prev=2, curr=3 (F(4)=3)

i = 5:
  next = prev + curr = 2 + 3 = 5
  prev = curr = 3
  curr = next = 5
  State: prev=3, curr=5 (F(5)=5)

Result: curr = 5
```

### Sliding Window Visualization

```
Think of it as a sliding window of size 2:

Computing F(5):

Step 0: [0, 1] _ _ _ _
         ↑  ↑
       prev curr

Step 1: _ [1, 1] _ _ _
           ↑  ↑
         prev curr (F(2)=1)

Step 2: _ _ [1, 2] _ _
             ↑  ↑
           prev curr (F(3)=2)

Step 3: _ _ _ [2, 3] _
               ↑  ↑
             prev curr (F(4)=3)

Step 4: _ _ _ _ [3, 5]
                 ↑  ↑
               prev curr (F(5)=5)

We only keep 2 values at a time!
```

### Detailed Execution

```
n = 6

Initial:
a = 0 (F(0))
b = 1 (F(1))

i = 2:
  a, b = b, a + b
  a, b = 1, 0 + 1
  a = 1, b = 1 (F(2) = 1)

i = 3:
  a, b = b, a + b
  a, b = 1, 1 + 1
  a = 1, b = 2 (F(3) = 2)

i = 4:
  a, b = b, a + b
  a, b = 2, 1 + 2
  a = 2, b = 3 (F(4) = 3)

i = 5:
  a, b = b, a + b
  a, b = 3, 2 + 3
  a = 3, b = 5 (F(5) = 5)

i = 6:
  a, b = b, a + b
  a, b = 5, 3 + 5
  a = 5, b = 8 (F(6) = 8)

Result: b = 8
```

### The Elegant Python Swap

```python
# Python's tuple unpacking makes this elegant:
a, b = b, a + b

# This is equivalent to:
temp = a + b
a = b
b = temp

# But more concise and Pythonic!

Example:
a = 1, b = 2
a, b = b, a + b
# Right side evaluated first: (2, 1+2) = (2, 3)
# Then assigned: a = 2, b = 3
```

### Pseudocode
```
function fib(n):
    if n <= 1:
        return n
    
    a = 0  // F(0)
    b = 1  // F(1)
    
    for i from 2 to n:
        a, b = b, a + b
    
    return b
```

### Implementation
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        
        return b
```

### Alternative Implementation (More Explicit)
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        prev = 0
        curr = 1
        
        for i in range(2, n + 1):
            next_val = prev + curr
            prev = curr
            curr = next_val
        
        return curr
```

### Complexity Analysis
- **Time:** O(n) - Single loop from 2 to n
- **Space:** O(1) - Only two variables! 🎉

### Space Comparison

```
Approach 1 (Naive Recursion):
  Time: O(2^n)
  Space: O(n) - recursion stack

Approach 2 (Memoization):
  Time: O(n)
  Space: O(n) - memo array + stack

Approach 3 (Tabulation):
  Time: O(n)
  Space: O(n) - dp array

Approach 4 (Space Optimized):
  Time: O(n)
  Space: O(1) - two variables ⭐

This is OPTIMAL!
```

### Why This Works

```
Key insight:
F(n) = F(n-1) + F(n-2)

We only need the last 2 values!

Think of it like climbing stairs:
- You're on step n
- You can only reach it from step n-1 or n-2
- You don't care about steps before n-2

Same with Fibonacci:
- To compute F(n)
- You only need F(n-1) and F(n-2)
- Earlier values are irrelevant
```

---

## Approach Comparison

| Aspect | Naive Recursion | Memoization | Tabulation | Space Optimized |
|--------|----------------|-------------|------------|-----------------|
| **Time Complexity** | O(2^n) 🔴 | O(n) ✅ | O(n) ✅ | O(n) ✅ |
| **Space Complexity** | O(n) | O(n) | O(n) | O(1) ⭐ |
| **Approach** | Top-Down | Top-Down | Bottom-Up | Bottom-Up |
| **Recursion** | Yes | Yes | No | No |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Performance** | Terrible | Good | Better | Best |
| **Best For** | Learning | Understanding DP | Production | Optimal solution |

---

## Critical Insights

### 1. The Overlapping Subproblems

```
Why naive recursion is slow:

F(5) calls F(4) and F(3)
F(4) calls F(3) and F(2)
F(3) is called TWICE!

For F(10):
F(5) is called 8 times
F(4) is called 13 times
F(3) is called 21 times
F(2) is called 34 times

This is the "overlapping subproblems" property
→ Perfect candidate for Dynamic Programming!
```

### 2. Memoization vs Tabulation

```
Memoization (Top-Down):
✓ Natural for recursive problems
✓ Only computes needed values
✓ Easier to write from recursive solution
✗ Recursion overhead
✗ Stack space usage

Tabulation (Bottom-Up):
✓ No recursion overhead
✓ Better cache locality
✓ Easier to optimize space
✗ Computes all values (even if not needed)
✗ Less intuitive for some problems

For Fibonacci: Tabulation is better
For complex problems: Memoization might be easier
```

### 3. The Space Optimization Trick

```
General pattern for space optimization:

If dp[i] only depends on:
- dp[i-1] → Use 1 variable
- dp[i-1] and dp[i-2] → Use 2 variables
- dp[i-1], dp[i-2], ..., dp[i-k] → Use k variables

Fibonacci: dp[i] = dp[i-1] + dp[i-2]
→ Only need 2 variables!

This pattern applies to many DP problems:
- Climbing Stairs
- House Robber
- Min Cost Climbing Stairs
```

### 4. Why F(0) = 0 and F(1) = 1?

```
Mathematical definition:
F(0) = 0 (by convention)
F(1) = 1 (by convention)

These are the "seed values" that generate the sequence.

Different seeds create different sequences:
Seeds (0, 1): 0, 1, 1, 2, 3, 5, 8, 13... (Fibonacci)
Seeds (2, 1): 2, 1, 3, 4, 7, 11, 18... (Lucas numbers)
Seeds (1, 1): 1, 1, 2, 3, 5, 8, 13... (Fibonacci starting at 1)
```

### 5. The Golden Ratio Connection

```
As n grows, the ratio F(n)/F(n-1) approaches φ (phi):

φ = (1 + √5) / 2 ≈ 1.618 (Golden Ratio)

Example:
F(10) / F(9) = 55 / 34 ≈ 1.617647
F(20) / F(19) = 6765 / 4181 ≈ 1.618034
F(30) / F(29) = 832040 / 514229 ≈ 1.618034

This leads to the closed-form formula (Binet's formula):
F(n) = (φ^n - ψ^n) / √5
where ψ = (1 - √5) / 2

But this has floating-point precision issues!
```

---

## Common Mistakes

### ❌ Mistake 1: Forgetting Base Cases

```python
# Wrong: Missing base case
def fib(n):
    return fib(n-1) + fib(n-2)  # Infinite recursion!

# Correct: Handle base cases
def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)
```

### ❌ Mistake 2: Wrong Memo Initialization

```python
# Wrong: Using 0 as "not computed" marker
memo = [0] * (n + 1)
# Problem: F(0) = 0, can't distinguish!

# Correct: Use -1 or None
memo = [-1] * (n + 1)
# or
memo = [None] * (n + 1)
```

### ❌ Mistake 3: Off-by-One in Loop

```python
# Wrong: Loop doesn't reach n
for i in range(2, n):  # Stops at n-1
    dp[i] = dp[i-1] + dp[i-2]

# Correct: Include n
for i in range(2, n + 1):  # Includes n
    dp[i] = dp[i-1] + dp[i-2]
```

### ❌ Mistake 4: Wrong Variable Update Order

```python
# Wrong: Updates prev before using it
prev = curr
curr = prev + curr  # Uses new prev value!

# Correct: Use simultaneous assignment
prev, curr = curr, prev + curr
# or save in temp
temp = prev + curr
prev = curr
curr = temp
```

### ❌ Mistake 5: Not Handling n=0

```python
# Wrong: Doesn't handle n=0
def fib(n):
    if n == 1:
        return 1
    # What about n=0? Returns None or error!

# Correct: Handle both base cases
def fib(n):
    if n <= 1:
        return n  # Returns 0 for n=0, 1 for n=1
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `n = 0` | `0` | Base case F(0) = 0 |
| `n = 1` | `1` | Base case F(1) = 1 |
| `n = 2` | `1` | F(2) = F(1) + F(0) = 1 + 0 = 1 |
| `n = 30` | `832040` | Large but within constraints |

---

## Pattern Recognition

### This Pattern Applies To:

1. **Climbing Stairs (LeetCode 70)** - Identical to Fibonacci!
```python
# Ways to climb n stairs (1 or 2 steps at a time)
# Same as Fibonacci!
def climbStairs(n):
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    return b
```

2. **House Robber (LeetCode 198)** - Similar DP pattern
```python
# dp[i] depends on dp[i-1] and dp[i-2]
# Can optimize to O(1) space
```

3. **Min Cost Climbing Stairs (LeetCode 746)** - Similar pattern
```python
# dp[i] = cost[i] + min(dp[i-1], dp[i-2])
```

4. **Tribonacci Number (LeetCode 1137)** - Extension to 3 previous values
```python
# T(n) = T(n-1) + T(n-2) + T(n-3)
# Need 3 variables instead of 2
```

### Key Characteristics:
- Current state depends on previous states
- Overlapping subproblems
- Can be optimized with DP
- Space can be optimized to O(1)

---

## Complete Implementations

### Implementation 1: Naive Recursion
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        return self.fib(n - 1) + self.fib(n - 2)

# Time: O(2^n), Space: O(n)
```

### Implementation 2: Memoization (Top-Down DP)
```python
class Solution:
    def fib(self, n: int) -> int:
        memo = [-1] * (n + 1)
        
        def helper(n):
            if memo[n] != -1:
                return memo[n]
            
            if n <= 1:
                return n
            
            memo[n] = helper(n - 1) + helper(n - 2)
            return memo[n]
        
        return helper(n)

# Time: O(n), Space: O(n)
```

### Implementation 3: Tabulation (Bottom-Up DP)
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        dp = [0] * (n + 1)
        dp[0] = 0
        dp[1] = 1
        
        for i in range(2, n + 1):
            dp[i] = dp[i - 1] + dp[i - 2]
        
        return dp[n]

# Time: O(n), Space: O(n)
```

### Implementation 4: Space Optimized ⭐
```python
class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        
        return b

# Time: O(n), Space: O(1) - OPTIMAL!
```

### Implementation 5: Using List Building
```python
class Solution:
    def fib(self, n: int) -> int:
        if n == 0:
            return 0
        if n == 1:
            return 1
        
        fib_list = [0, 1]
        while len(fib_list) < n + 1:
            fib_list.append(fib_list[-1] + fib_list[-2])
        
        return fib_list[-1]

# Time: O(n), Space: O(n)
```

### Implementation 6: Using @lru_cache (Python)
```python
from functools import lru_cache

class Solution:
    @lru_cache(maxsize=None)
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        return self.fib(n - 1) + self.fib(n - 2)

# Time: O(n), Space: O(n)
# Python's built-in memoization!
```

---

## Performance Comparison

### Execution Time for Different n

```
n = 10:
Naive:     0.001 seconds
Memo:      0.0001 seconds
Tabulation: 0.0001 seconds
Optimized: 0.0001 seconds

n = 20:
Naive:     0.005 seconds
Memo:      0.0001 seconds
Tabulation: 0.0001 seconds
Optimized: 0.0001 seconds

n = 30:
Naive:     0.5 seconds 🐌
Memo:      0.0001 seconds ⚡
Tabulation: 0.0001 seconds ⚡
Optimized: 0.0001 seconds ⚡

n = 35:
Naive:     5 seconds 🐌🐌
Memo:      0.0001 seconds ⚡
Tabulation: 0.0001 seconds ⚡
Optimized: 0.0001 seconds ⚡

n = 40:
Naive:     60+ seconds 🐌🐌🐌
Memo:      0.0001 seconds ⚡
Tabulation: 0.0001 seconds ⚡
Optimized: 0.0001 seconds ⚡
```

### Memory Usage

```
n = 1000:
Naive:     Stack overflow! 💥
Memo:      ~8 KB (array + stack)
Tabulation: ~8 KB (array only)
Optimized: ~16 bytes (2 integers) ⭐

n = 10000:
Naive:     Stack overflow! 💥
Memo:      ~80 KB
Tabulation: ~80 KB
Optimized: ~16 bytes ⭐

Space savings: 5000x less memory!
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Climbing Stairs (LC 70)** | Identical pattern | Same as Fibonacci |
| **Tribonacci (LC 1137)** | Similar pattern | Sum of 3 previous |
| **House Robber (LC 198)** | DP pattern | Max instead of sum |
| **Min Cost Climbing Stairs (LC 746)** | DP pattern | Cost + min |
| **N-th Tribonacci Number** | Extension | 3 previous values |

---

## Day 57 Summary

### Problems Solved: 1
1. ✅ Fibonacci Number

### Key Patterns Learned:
1. **Naive Recursion** - Understanding the problem
2. **Memoization** - Top-down DP with caching
3. **Tabulation** - Bottom-up DP with table
4. **Space Optimization** - Reducing O(n) to O(1)

### Techniques Mastered:
- Identifying overlapping subproblems
- Converting recursion to DP
- Memoization with cache
- Tabulation with iteration
- Space optimization with variables

### Complexity Insights:
- Naive: O(2^n) time - exponential, terrible
- Memoization: O(n) time, O(n) space - good
- Tabulation: O(n) time, O(n) space - better
- Optimized: O(n) time, O(1) space - optimal!

### When to Use This Pattern:
- Problems with overlapping subproblems
- Current state depends on previous states
- Can be solved recursively
- Need to optimize recursive solution

---

## Quick Reference

### Space Optimized Template (BEST)
```python
def fib(n):
    if n <= 1:
        return n
    
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    
    return b
```

### Tabulation Template
```python
def fib(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[0], dp[1] = 0, 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

### Memoization Template
```python
def fib(n):
    memo = {}
    
    def helper(n):
        if n in memo:
            return memo[n]
        if n <= 1:
            return n
        
        memo[n] = helper(n-1) + helper(n-2)
        return memo[n]
    
    return helper(n)
```

### Key Formulas
```
F(0) = 0
F(1) = 1
F(n) = F(n-1) + F(n-2)

Space optimization:
- If dp[i] depends on k previous values
- Use k variables instead of array
```

### Common Patterns
```python
# Two-variable pattern (Fibonacci, Climbing Stairs)
a, b = 0, 1
for _ in range(2, n + 1):
    a, b = b, a + b

# Three-variable pattern (Tribonacci)
a, b, c = 0, 1, 1
for _ in range(3, n + 1):
    a, b, c = b, c, a + b + c
```

---

## The Evolution of Fibonacci Solutions

```
Step 1: Understand the problem
→ Write naive recursive solution
→ O(2^n) time - too slow!

Step 2: Identify overlapping subproblems
→ Add memoization (cache results)
→ O(n) time, O(n) space - much better!

Step 3: Convert to iterative
→ Use tabulation (bottom-up)
→ O(n) time, O(n) space - no recursion overhead

Step 4: Optimize space
→ Keep only needed values
→ O(n) time, O(1) space - optimal!

This is the journey of Dynamic Programming! 🚀
```

---

## Key Takeaways

1. **Fibonacci is the "Hello World" of DP** - Master this, understand DP
2. **Overlapping subproblems** - Key indicator for DP
3. **Memoization = Top-Down** - Start from problem, cache results
4. **Tabulation = Bottom-Up** - Start from base, build up
5. **Space optimization** - If dp[i] depends on k previous, use k variables
6. **O(1) space is possible** - When only recent values matter
7. **Practice makes perfect** - Fibonacci teaches fundamental DP concepts

---

## Interview Tips

**If asked about Fibonacci:**

1. **Start with naive recursion** - Show you understand the problem
   ```python
   def fib(n):
       if n <= 1:
           return n
       return fib(n-1) + fib(n-2)
   ```

2. **Explain the problem** - "This is O(2^n) because of repeated calculations"

3. **Optimize with memoization** - "We can cache results"
   ```python
   memo = {}
   # ... add caching
   ```

4. **Convert to tabulation** - "We can do this iteratively"
   ```python
   dp = [0] * (n+1)
   # ... build table
   ```

5. **Optimize space** - "We only need last 2 values"
   ```python
   a, b = 0, 1
   for _ in range(2, n+1):
       a, b = b, a+b
   ```

6. **Mention related problems** - "This pattern applies to Climbing Stairs, House Robber..."

**Time to explain:** 5-10 minutes for all approaches

---

**End of Day 57 Notes**

*Master Fibonacci and you've mastered the foundation of Dynamic Programming!* 🎯
