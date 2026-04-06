# Day 40: Climbing Stairs

## Problem Statement
**LeetCode 70: Climbing Stairs**

You are climbing a staircase. It takes n steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Examples:**
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps

Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step

Input: n = 4
Output: 5
Explanation: Five ways:
1. 1+1+1+1
2. 1+1+2
3. 1+2+1
4. 2+1+1
5. 2+2
```

**Constraints:**
- 1 <= n <= 45

---

## Problem Logic & Reasoning

### Core Concept
This is a **classic Dynamic Programming** problem that's actually the **Fibonacci sequence** in disguise!

**Key Insight:** To reach step n, you can come from:
- Step (n-1) by taking 1 step, OR
- Step (n-2) by taking 2 steps

Therefore: `ways(n) = ways(n-1) + ways(n-2)`

### Why This is Fibonacci?
```
n = 1: 1 way  → [1]
n = 2: 2 ways → [1+1, 2]
n = 3: 3 ways → [1+1+1, 1+2, 2+1]
n = 4: 5 ways → [1+1+1+1, 1+1+2, 1+2+1, 2+1+1, 2+2]
n = 5: 8 ways
n = 6: 13 ways

Sequence: 1, 2, 3, 5, 8, 13, 21...
This is Fibonacci starting from F(1)=1, F(2)=2!
```

### Visual Understanding for n = 4

```
                    Step 4
                   /      \
              (from 3)  (from 2)
              +1 step   +2 steps
                 /          \
            Step 3        Step 2
           /      \       /      \
      (from 2) (from 1) (from 1) (from 0)
      +1 step  +2 steps +1 step  +2 steps

Total paths to Step 4 = paths to Step 3 + paths to Step 2
                      = 3 + 2 = 5
```

---

## Approach 1: Naive Recursion (TLE - Time Limit Exceeded)

### Logic
Directly implement the recurrence relation:
- Base case: n ≤ 1 returns 1
- Recursive case: ways(n) = ways(n-1) + ways(n-2)

### Visual Flow for n = 4

```
                        ways(4)
                       /        \
                  ways(3)      ways(2)
                 /      \       /     \
            ways(2)  ways(1) ways(1) ways(0)
           /     \      |       |       |
      ways(1) ways(0)   1       1       1
         |       |
         1       1

Result: 1+1 + 1 + 1 + 1 = 5
```

### Recursion Tree Analysis
```
For n = 5:
                    ways(5)
                   /        \
              ways(4)      ways(3)
             /      \       /      \
        ways(3)  ways(2) ways(2) ways(1)
        /    \    /   \   /   \     |
      ...   ...  ...  ... ... ...   1

Notice: ways(3) is calculated TWICE!
        ways(2) is calculated THREE times!
        Massive redundant computation!
```

### Pseudocode
```
function climbStairs(n):
    if n <= 1:
        return 1
    return climbStairs(n-1) + climbStairs(n-2)
```

### Complexity Analysis
- **Time:** O(2^n) - Exponential! Each call branches into 2 calls
- **Space:** O(n) - Recursion stack depth
- **Problem:** For n=45, this makes ~2^45 = 35 trillion calls! ❌

---

## Approach 2: Recursion with Memoization (Top-Down DP) ⭐

### Logic
Cache previously computed results to avoid redundant calculations:
1. Use a dictionary/map to store computed values
2. Before computing, check if result exists in cache
3. If exists, return cached value; otherwise compute and cache

### Visual Flow for n = 4 with Memoization

```
                        ways(4)
                       /        \
                  ways(3)      ways(2) ← cached!
                 /      \       
            ways(2)  ways(1)
           /     \      
      ways(1) ways(0)

Calls made: ways(4), ways(3), ways(2), ways(1), ways(0)
Total: 5 calls (vs 9 without memoization)
```

### Step-by-Step Execution
```
n = 5, memo = {}

Call ways(5):
  → Call ways(4): memo[4] not found
    → Call ways(3): memo[3] not found
      → Call ways(2): memo[2] not found
        → Call ways(1): return 1
        → Call ways(0): return 1
        → memo[2] = 1 + 1 = 2
      → Call ways(1): return 1
      → memo[3] = 2 + 1 = 3
    → Call ways(2): memo[2] found! return 2 ✓
    → memo[4] = 3 + 2 = 5
  → Call ways(3): memo[3] found! return 3 ✓
  → memo[5] = 5 + 3 = 8

Result: 8
```

### Pseudocode
```
function climbStairs(n):
    memo = {}
    
    function helper(n):
        if n <= 1:
            return 1
        
        if n in memo:
            return memo[n]
        
        memo[n] = helper(n-1) + helper(n-2)
        return memo[n]
    
    return helper(n)
```

### Complexity Analysis
- **Time:** O(n) - Each subproblem computed once
- **Space:** O(n) - Memo dictionary + recursion stack
- **Improvement:** From O(2^n) to O(n) - HUGE speedup! ✓

---

## Approach 3: Bottom-Up Dynamic Programming (Iterative)

### Logic
Build solution iteratively from base cases upward:
1. Create dp array where dp[i] = ways to reach step i
2. Initialize base cases: dp[0] = 1, dp[1] = 1
3. Fill array using: dp[i] = dp[i-1] + dp[i-2]

### Visual Flow for n = 6

```
Step:  0   1   2   3   4   5   6
dp:   [1,  1,  ?,  ?,  ?,  ?,  ?]

i=2: dp[2] = dp[1] + dp[0] = 1 + 1 = 2
dp:   [1,  1,  2,  ?,  ?,  ?,  ?]

i=3: dp[3] = dp[2] + dp[1] = 2 + 1 = 3
dp:   [1,  1,  2,  3,  ?,  ?,  ?]

i=4: dp[4] = dp[3] + dp[2] = 3 + 2 = 5
dp:   [1,  1,  2,  3,  5,  ?,  ?]

i=5: dp[5] = dp[4] + dp[3] = 5 + 3 = 8
dp:   [1,  1,  2,  3,  5,  8,  ?]

i=6: dp[6] = dp[5] + dp[4] = 8 + 5 = 13
dp:   [1,  1,  2,  3,  5,  8,  13]

Result: dp[6] = 13
```

### Building the DP Table
```
n = 5

Initial: dp = [1, 1, 0, 0, 0, 0]

Loop i from 2 to 5:
  i=2: dp[2] = dp[1] + dp[0] = 1 + 1 = 2
  i=3: dp[3] = dp[2] + dp[1] = 2 + 1 = 3
  i=4: dp[4] = dp[3] + dp[2] = 3 + 2 = 5
  i=5: dp[5] = dp[4] + dp[3] = 5 + 3 = 8

Final: dp = [1, 1, 2, 3, 5, 8]
Return: dp[5] = 8
```

### Pseudocode
```
function climbStairs(n):
    if n <= 1:
        return 1
    
    dp = array of size (n+1)
    dp[0] = 1
    dp[1] = 1
    
    for i from 2 to n:
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

### Complexity Analysis
- **Time:** O(n) - Single loop through n steps
- **Space:** O(n) - DP array of size n+1
- **Advantage:** No recursion overhead, easier to understand

---

## Approach 4: Space-Optimized DP (Constant Space) ⭐⭐

### Logic
Since we only need the last 2 values, we don't need the entire array:
1. Keep two variables: prev1 (n-1) and prev2 (n-2)
2. Compute current = prev1 + prev2
3. Shift variables: prev2 = prev1, prev1 = current

### Visual Flow for n = 6

```
Initial: prev2=1, prev1=1

i=2: current = 1 + 1 = 2
     prev2=1, prev1=2

i=3: current = 2 + 1 = 3
     prev2=2, prev1=3

i=4: current = 3 + 2 = 5
     prev2=3, prev1=5

i=5: current = 5 + 3 = 8
     prev2=5, prev1=8

i=6: current = 8 + 5 = 13
     prev2=8, prev1=13

Result: 13
```

### Sliding Window Analogy
```
Think of it as a sliding window of size 2:

Step:     0   1   2   3   4   5   6
Values:   1   1   2   3   5   8   13
         [1,  1]
             [1,  2]
                 [2,  3]
                     [3,  5]
                         [5,  8]
                             [8, 13]
```

### Pseudocode
```
function climbStairs(n):
    if n <= 1:
        return 1
    
    prev2 = 1  // ways(0)
    prev1 = 1  // ways(1)
    
    for i from 2 to n:
        current = prev1 + prev2
        prev2 = prev1
        prev1 = current
    
    return prev1
```

### Complexity Analysis
- **Time:** O(n) - Single loop
- **Space:** O(1) - Only 3 variables! ⭐
- **Best:** Optimal time and space!

---

## Approach Comparison

| Aspect | Naive Recursion | Memoization | Bottom-Up DP | Space-Optimized |
|--------|----------------|-------------|--------------|-----------------|
| **Time Complexity** | O(2^n) ❌ | O(n) ✓ | O(n) ✓ | O(n) ✓ |
| **Space Complexity** | O(n) stack | O(n) memo+stack | O(n) array | O(1) ⭐ |
| **For n=45** | ~35 trillion ops | 45 ops | 45 ops | 45 ops |
| **Intuition** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Interview** | ❌ TLE | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Best For** | Understanding | Top-down thinking | Learning DP | Production |

---

## Critical Insights

### 1. Why This is Fibonacci
```
Climbing Stairs:  1, 2, 3, 5, 8, 13, 21...
Fibonacci:        1, 1, 2, 3, 5, 8, 13, 21...

Climbing Stairs(n) = Fibonacci(n+1)
```

### 2. Why Base Case is n ≤ 1 returns 1?
```
n = 0: 1 way (don't move - already at top)
n = 1: 1 way (take 1 step)

This makes the recurrence work:
ways(2) = ways(1) + ways(0) = 1 + 1 = 2 ✓
```

### 3. Overlapping Subproblems
```
For n = 5:
ways(5) needs ways(4) and ways(3)
ways(4) needs ways(3) and ways(2)
ways(3) needs ways(2) and ways(1)

ways(3) is needed by both ways(5) and ways(4)!
ways(2) is needed by ways(4) and ways(3)!

This overlap makes memoization crucial.
```

### 4. Why Not Use Recursion for Large n?
```
For n = 45:
- Naive recursion: 2^45 = 35,184,372,088,832 calls
- With memoization: 45 calls
- Speedup: 782 billion times faster!
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Base Case
```python
if n == 0:
    return 0  # Wrong! Should be 1
```
**Impact:** ways(2) = ways(1) + ways(0) = 1 + 0 = 1 (should be 2)

### ❌ Mistake 2: Off-by-One in DP Array
```python
dp = [0] * n  # Wrong! Should be n+1
dp[0] = 1
dp[1] = 1  # Index out of bounds for n=1
```

### ❌ Mistake 3: Not Handling n=1
```python
def climbStairs(n):
    dp = [0] * (n + 1)
    dp[0] = 1
    dp[1] = 1  # Fails if n=0
```
**Fix:** Add early return for n ≤ 1

### ❌ Mistake 4: Wrong Variable Update Order
```python
# Wrong order:
prev1 = current
prev2 = prev1  # This uses the NEW prev1!

# Correct:
prev2 = prev1
prev1 = current
```

### ❌ Mistake 5: Forgetting to Return Correct Value
```python
# Space-optimized approach
return current  # Wrong! current is out of scope

# Correct:
return prev1  # prev1 holds the final answer
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `n = 1` | `1` | Only one way: [1] |
| `n = 2` | `2` | Two ways: [1+1, 2] |
| `n = 3` | `3` | Three ways: [1+1+1, 1+2, 2+1] |
| `n = 45` | `1,836,311,903` | Maximum constraint |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Fibonacci Number** - Exact same recurrence
2. **House Robber** - Similar DP with constraints
3. **Min Cost Climbing Stairs** - Weighted version
4. **Decode Ways** - Similar recurrence structure
5. **Unique Paths** - 2D version of same concept

### Key Characteristics:
- Optimal substructure (solution built from subproblems)
- Overlapping subproblems (same subproblems computed multiple times)
- Recurrence relation: f(n) = f(n-1) + f(n-2)
- Can be optimized to O(1) space

---

## Complete Implementations

### Implementation 1: Recursion with Memoization ⭐
```python
def climbStairs(n: int) -> int:
    memo = {}
    
    def helper(n):
        if n <= 1:
            return 1
        
        if n in memo:
            return memo[n]
        
        memo[n] = helper(n - 1) + helper(n - 2)
        return memo[n]
    
    return helper(n)
```

### Implementation 2: Bottom-Up DP
```python
def climbStairs(n: int) -> int:
    if n <= 1:
        return 1
    
    dp = [0] * (n + 1)
    dp[0] = 1
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    
    return dp[n]
```

### Implementation 3: Space-Optimized DP ⭐⭐
```python
def climbStairs(n: int) -> int:
    if n <= 1:
        return 1
    
    prev2, prev1 = 1, 1
    
    for i in range(2, n + 1):
        current = prev1 + prev2
        prev2 = prev1
        prev1 = current
    
    return prev1
```

### Implementation 4: Space-Optimized (Pythonic)
```python
def climbStairs(n: int) -> int:
    if n <= 1:
        return 1
    
    prev2, prev1 = 1, 1
    
    for _ in range(2, n + 1):
        prev2, prev1 = prev1, prev1 + prev2
    
    return prev1
```

### Implementation 5: Using Matrix Exponentiation (Advanced)
```python
def climbStairs(n: int) -> int:
    # O(log n) using matrix exponentiation
    # [[F(n+1), F(n)], [F(n), F(n-1)]] = [[1,1],[1,0]]^n
    
    def matrix_mult(A, B):
        return [
            [A[0][0]*B[0][0] + A[0][1]*B[1][0], A[0][0]*B[0][1] + A[0][1]*B[1][1]],
            [A[1][0]*B[0][0] + A[1][1]*B[1][0], A[1][0]*B[0][1] + A[1][1]*B[1][1]]
        ]
    
    def matrix_pow(M, n):
        if n == 1:
            return M
        if n % 2 == 0:
            half = matrix_pow(M, n // 2)
            return matrix_mult(half, half)
        return matrix_mult(M, matrix_pow(M, n - 1))
    
    if n <= 1:
        return 1
    
    result = matrix_pow([[1, 1], [1, 0]], n)
    return result[0][0]
```

---

## Optimization Techniques

### 1. Fibonacci Formula (Binet's Formula)
```python
import math

def climbStairs(n: int) -> int:
    # O(1) time using closed-form formula
    sqrt5 = math.sqrt(5)
    phi = (1 + sqrt5) / 2
    psi = (1 - sqrt5) / 2
    
    return int((phi**(n+1) - psi**(n+1)) / sqrt5)
```
**Note:** May have floating-point precision issues for large n

### 2. Iterative with Tuple Unpacking
```python
def climbStairs(n: int) -> int:
    a, b = 1, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

### 3. Using functools.lru_cache
```python
from functools import lru_cache

@lru_cache(maxsize=None)
def climbStairs(n: int) -> int:
    if n <= 1:
        return 1
    return climbStairs(n - 1) + climbStairs(n - 2)
```

---

## Mathematical Deep Dive

### Fibonacci Recurrence Relation
```
F(0) = 0
F(1) = 1
F(n) = F(n-1) + F(n-2)

Climbing Stairs:
C(0) = 1
C(1) = 1
C(n) = C(n-1) + C(n-2)

Therefore: C(n) = F(n+1)
```

### Why Matrix Exponentiation Works
```
[F(n+1)]   [1 1]^n   [1]
[F(n)  ] = [1 0]   × [0]

This gives O(log n) time complexity using fast exponentiation!
```

### Growth Rate
```
Fibonacci grows exponentially:
F(n) ≈ φ^n / √5

where φ = (1 + √5) / 2 ≈ 1.618 (golden ratio)

For n=45: F(45) ≈ 1.8 billion
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Fibonacci Number** | Identical recurrence | Direct Fibonacci |
| **Min Cost Climbing Stairs** | Same structure | Add cost consideration |
| **House Robber** | DP with choice | Can't take adjacent |
| **Decode Ways** | Similar recurrence | String parsing logic |
| **Unique Paths** | Grid DP | 2D version |

---

## Day 40 Summary

### Problems Solved: 1
1. ✅ Climbing Stairs - Classic DP/Fibonacci

### Key Patterns Learned:
1. **Dynamic Programming** - Building solution from subproblems
2. **Memoization** - Caching to avoid redundant computation
3. **Space Optimization** - Reducing O(n) to O(1) space
4. **Fibonacci Pattern** - Recognizing hidden Fibonacci sequence

### Techniques Mastered:
- Top-down DP with memoization
- Bottom-up iterative DP
- Space optimization using sliding window
- Recognizing overlapping subproblems

### Complexity Insights:
- Naive recursion: O(2^n) - exponential disaster
- With memoization: O(n) - linear time
- Space optimization: O(1) - constant space
- Matrix exponentiation: O(log n) - logarithmic time

### When to Use This Pattern:
- Problems with optimal substructure
- Overlapping subproblems
- Counting number of ways
- Fibonacci-like recurrence relations

---

## Quick Reference

### DP Problem Checklist
```
✓ Can problem be broken into subproblems?
✓ Do subproblems overlap?
✓ Can we define recurrence relation?
✓ What are base cases?
✓ Can we optimize space?
```

### DP Template (Bottom-Up)
```python
def dp_problem(n):
    # 1. Define dp array
    dp = [0] * (n + 1)
    
    # 2. Initialize base cases
    dp[0] = base_case_0
    dp[1] = base_case_1
    
    # 3. Fill dp array using recurrence
    for i in range(2, n + 1):
        dp[i] = recurrence_relation(dp, i)
    
    # 4. Return final answer
    return dp[n]
```

### Space Optimization Template
```python
def dp_optimized(n):
    # Only keep last k values needed
    prev_k = initial_values
    
    for i in range(k, n + 1):
        current = compute_from_prev(prev_k)
        update_prev(prev_k, current)
    
    return current_value
```

### Time Complexity Comparison
```
For n = 45:
- Naive recursion: ~35 trillion operations (TLE)
- Memoization: 45 operations
- Bottom-up DP: 45 operations
- Space-optimized: 45 operations
- Matrix exponentiation: ~6 operations
```
