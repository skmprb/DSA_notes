# Day 39: Square Root (Integer)

## Problem Statement
**LeetCode 69: Sqrt(x)**

Given a non-negative integer x, return the square root of x rounded down to the nearest integer. The returned integer should be non-negative as well.

**Constraint:** You must not use any built-in exponent function or operator (e.g., `pow(x, 0.5)` or `x ** 0.5`).

**Examples:**
```
Input: x = 4
Output: 2
Explanation: The square root of 4 is 2, so we return 2.

Input: x = 8
Output: 2
Explanation: The square root of 8 is 2.82842..., and since we round it down to the nearest integer, 2 is returned.

Input: x = 0
Output: 0

Input: x = 1
Output: 1
```

**Constraints:**
- 0 <= x <= 2^31 - 1

---

## Problem Logic & Reasoning

### Core Concept
Find the largest integer `k` such that `k² ≤ x`.

This is essentially a **search problem** in the range [0, x]:
- We're looking for the "floor" of the square root
- The answer is monotonic: if `k² > x`, then `(k+1)² > x` as well

### Why Binary Search?
The search space has a special property:
```
For x = 8:
0² = 0  ✓ (≤ 8)
1² = 1  ✓ (≤ 8)
2² = 4  ✓ (≤ 8)  ← Answer
3² = 9  ✗ (> 8)
4² = 16 ✗ (> 8)
...
```

The sequence is **monotonically increasing**, making it perfect for binary search!

### Key Insight
Instead of checking all numbers from 0 to x (O(n)), we can use binary search to find the answer in O(log n) time.

---

## Approach 1: Binary Search (Standard) ⭐

### Logic
1. Search space: [1, x//2] (since √x ≤ x/2 for x ≥ 2)
2. For each mid, check if `mid² == x`, `mid² < x`, or `mid² > x`
3. If `mid² < x`, save mid as potential answer and search right half
4. If `mid² > x`, search left half
5. Return the last valid answer

### Visual Flow for x = 8

```
Initial: left=1, right=4, ans=0

Iteration 1:
    mid = (1 + 4) // 2 = 2
    2² = 4 < 8 ✓
    ans = 2 (save this)
    left = 3
    [1, 2, 3, 4]
           ↑
         left  right

Iteration 2:
    mid = (3 + 4) // 2 = 3
    3² = 9 > 8 ✗
    right = 2
    [1, 2, 3, 4]
        ↑  ↑
      right left (left > right, stop)

Return ans = 2
```

### Step-by-Step Execution for x = 25

```
left=1, right=12, ans=0

Step 1: mid=6  → 6²=36 > 25  → right=5
Step 2: mid=3  → 3²=9 < 25   → left=4, ans=3
Step 3: mid=4  → 4²=16 < 25  → left=5, ans=4
Step 4: mid=5  → 5²=25 == 25 → return 5 ✓
```

### Pseudocode
```
function mySqrt(x):
    if x < 2:
        return x
    
    left = 1
    right = x // 2
    ans = 0
    
    while left <= right:
        mid = (left + right) // 2
        
        if mid * mid == x:
            return mid
        elif mid * mid < x:
            left = mid + 1
            ans = mid        // Save last valid answer
        else:
            right = mid - 1
    
    return ans
```

### Why Save ans?
```
For x = 8:
- When mid=2, 2²=4 < 8, we save ans=2
- When mid=3, 3²=9 > 8, we don't update ans
- Loop ends, return ans=2 (the floor value)
```

### Complexity Analysis
- **Time:** O(log n) - Binary search halves search space each iteration
- **Space:** O(1) - Only using constant variables

---

## Approach 2: Binary Search (Overflow-Safe)

### Logic
Instead of computing `mid * mid`, use division: `mid == x // mid`

This prevents integer overflow for very large values of x.

### Why This Prevents Overflow?
```
For x = 2^31 - 1:
- mid could be around 46340
- mid * mid = 2,147,395,600 (might overflow in some languages)
- mid == x // mid avoids multiplication
```

### Visual Comparison

```
Standard:           Overflow-Safe:
mid * mid == x      mid == x // mid
mid * mid < x       mid < x // mid
mid * mid > x       mid > x // mid
```

### Key Difference in Return Value
```python
# Standard approach: return ans (explicitly saved)
return ans

# Overflow-safe: return right (naturally points to floor)
return right
```

### Why Return right?
```
For x = 8:
Final state: left=3, right=2
- right=2 is the largest value where 2² ≤ 8
- left=3 is the smallest value where 3² > 8
```

### Pseudocode
```
function mySqrt(x):
    if x < 2:
        return x
    
    left = 1
    right = x // 2
    
    while left <= right:
        mid = (left + right) // 2
        
        if mid == x // mid:
            return mid
        elif mid < x // mid:
            left = mid + 1
        else:
            right = mid - 1
    
    return right    // right is the floor value
```

### Complexity Analysis
- **Time:** O(log n) - Same as standard binary search
- **Space:** O(1) - Constant space

---

## Approach 3: Newton's Method (Newton-Raphson)

### Logic
Use iterative approximation to converge to the square root:
```
x_new = (x_old + n/x_old) / 2
```

This formula comes from calculus (tangent line approximation).

### Mathematical Intuition
To find √n, we solve: `x² - n = 0`

Newton's method: `x_new = x_old - f(x_old)/f'(x_old)`
- f(x) = x² - n
- f'(x) = 2x
- x_new = x_old - (x_old² - n)/(2x_old)
- Simplifies to: x_new = (x_old + n/x_old) / 2

### Visual Flow for x = 8

```
Initial guess: x = 8

Iteration 1:
    guess = (8 + 8//8) // 2 = (8 + 1) // 2 = 4
    4² = 16 > 8 (continue)

Iteration 2:
    guess = (4 + 8//4) // 2 = (4 + 2) // 2 = 3
    3² = 9 > 8 (continue)

Iteration 3:
    guess = (3 + 8//3) // 2 = (3 + 2) // 2 = 2
    2² = 4 ≤ 8 (stop)

Return 2
```

### Convergence Visualization

```
For x = 25:
Guess 1: 25
Guess 2: (25 + 25//25) // 2 = 13
Guess 3: (13 + 25//13) // 2 = 7
Guess 4: (7 + 25//7) // 2 = 5
Guess 5: 5² = 25 ✓ (converged)

Iterations: 5 (vs ~4-5 for binary search)
```

### Pseudocode
```
function mySqrt(x):
    if x < 2:
        return x
    
    guess = x
    
    while guess * guess > x:
        guess = (guess + x // guess) // 2
    
    return guess
```

### Why It's Faster
- **Quadratic convergence**: Doubles the number of correct digits each iteration
- **Fewer iterations**: O(log log n) vs O(log n)
- **Practical speed**: Converges in 3-5 iterations for most inputs

### Complexity Analysis
- **Time:** O(log log n) - Quadratic convergence (faster than binary search)
- **Space:** O(1) - Constant space

---

## Approach Comparison

| Aspect | Binary Search | Overflow-Safe BS | Newton's Method |
|--------|---------------|------------------|-----------------|
| **Time Complexity** | O(log n) | O(log n) | O(log log n) |
| **Space Complexity** | O(1) | O(1) | O(1) |
| **Iterations (x=100)** | ~6-7 | ~6-7 | ~3-4 |
| **Overflow Risk** | Yes (large x) | No | No |
| **Intuition** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Interview Friendly** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Best For** | Understanding | Production | Performance |

---

## Critical Insights

### 1. Why Start with right = x // 2?
```
For x ≥ 2:
√x ≤ x/2

Proof:
x ≥ 2
√x ≤ x/2
x ≤ x²/4
4x ≤ x²
4 ≤ x (true for x ≥ 4)

For x = 2, 3: √x < x/2 still holds
```

### 2. Edge Cases: x = 0 and x = 1
```
x = 0: √0 = 0 (return immediately)
x = 1: √1 = 1 (return immediately)

Without this check:
- right = 1 // 2 = 0
- left = 1, right = 0 (invalid range)
```

### 3. Why ans vs right?
```
Standard Binary Search:
- Explicitly save ans when mid² < x
- Return ans at the end

Overflow-Safe:
- Don't save ans
- Return right (naturally points to floor)

Both work! Different styles.
```

### 4. Integer Division Behavior
```python
8 // 3 = 2 (floor division)
9 // 3 = 3

For mid = 3, x = 8:
mid < x // mid
3 < 8 // 3
3 < 2 (False!)

Wait, this seems wrong? Let's check:
3 < 2 is False, so we go to else: right = mid - 1
This is correct! We want to search left.
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Search Range
```python
left, right = 0, x  # Wrong! Too large
```
**Fix:** Use `right = x // 2` (except for x < 2)

### ❌ Mistake 2: Not Handling x < 2
```python
def mySqrt(x):
    left, right = 1, x // 2  # Fails for x=0,1
```
**Fix:** Add early return for x < 2

### ❌ Mistake 3: Forgetting to Save ans
```python
elif mid * mid < x:
    left = mid + 1
    # Missing: ans = mid
```
**Impact:** Returns 0 instead of correct answer

### ❌ Mistake 4: Using mid = (left + right) / 2
```python
mid = (left + right) / 2  # Float division!
```
**Fix:** Use `//` for integer division

### ❌ Mistake 5: Overflow in mid Calculation
```python
mid = (left + right) // 2  # Can overflow if left+right > MAX_INT
```
**Better:** `mid = left + (right - left) // 2`

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `0` | `0` | √0 = 0 |
| `1` | `1` | √1 = 1 |
| `2` | `1` | √2 = 1.414... → 1 |
| `4` | `2` | Perfect square |
| `8` | `2` | √8 = 2.828... → 2 |
| `2^31 - 1` | `46340` | Maximum input |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Find Peak Element** - Binary search on unsorted array
2. **Search in Rotated Sorted Array** - Modified binary search
3. **First Bad Version** - Binary search for threshold
4. **Koko Eating Bananas** - Binary search on answer

### Key Characteristics:
- Monotonic property (sorted or searchable space)
- Looking for threshold/boundary
- Can eliminate half the search space
- O(log n) time complexity

---

## Complete Implementations

### Implementation 1: Binary Search (Standard) ⭐
```python
def mySqrt(x: int) -> int:
    if x < 2:
        return x
    
    left, right = 1, x // 2
    ans = 0
    
    while left <= right:
        mid = (left + right) // 2
        
        if mid * mid == x:
            return mid
        elif mid * mid < x:
            left = mid + 1
            ans = mid
        else:
            right = mid - 1
    
    return ans
```

### Implementation 2: Binary Search (Overflow-Safe)
```python
def mySqrt(x: int) -> int:
    if x < 2:
        return x
    
    left, right = 1, x // 2
    
    while left <= right:
        mid = (left + right) // 2
        
        if mid == x // mid:
            return mid
        elif mid < x // mid:
            left = mid + 1
        else:
            right = mid - 1
    
    return right
```

### Implementation 3: Newton's Method
```python
def mySqrt(x: int) -> int:
    if x < 2:
        return x
    
    guess = x
    
    while guess * guess > x:
        guess = (guess + x // guess) // 2
    
    return guess
```

### Implementation 4: Binary Search (Overflow-Safe mid)
```python
def mySqrt(x: int) -> int:
    if x < 2:
        return x
    
    left, right = 1, x // 2
    ans = 0
    
    while left <= right:
        mid = left + (right - left) // 2  # Prevents overflow
        square = mid * mid
        
        if square == x:
            return mid
        elif square < x:
            left = mid + 1
            ans = mid
        else:
            right = mid - 1
    
    return ans
```

---

## Optimization Techniques

### 1. Early Exit for Perfect Squares
```python
# Check if x is a perfect square
import math
if int(math.sqrt(x)) ** 2 == x:
    return int(math.sqrt(x))
# But this violates the constraint!
```

### 2. Bit Manipulation (Advanced)
```python
def mySqrt(x: int) -> int:
    if x < 2:
        return x
    
    # Find the position of the most significant bit
    bit = 1 << 15  # Start from 2^15
    result = 0
    
    while bit > 0:
        if (result + bit) ** 2 <= x:
            result += bit
        bit >>= 1
    
    return result
```

### 3. Lookup Table for Small Numbers
```python
def mySqrt(x: int) -> int:
    if x < 100:
        # Precomputed lookup table
        sqrt_table = [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, ...]
        return sqrt_table[x]
    
    # Use binary search for larger numbers
    ...
```

---

## Mathematical Deep Dive

### Newton's Method Derivation
```
Goal: Find x where f(x) = 0
For square root: f(x) = x² - n = 0

Newton's formula:
x_{k+1} = x_k - f(x_k) / f'(x_k)

For f(x) = x² - n:
f'(x) = 2x

x_{k+1} = x_k - (x_k² - n) / (2x_k)
        = x_k - x_k/2 + n/(2x_k)
        = x_k/2 + n/(2x_k)
        = (x_k + n/x_k) / 2
```

### Convergence Rate Comparison
```
Binary Search:
Error after k iterations: O(1/2^k)
Linear convergence

Newton's Method:
Error after k iterations: O(1/2^(2^k))
Quadratic convergence (much faster!)
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Valid Perfect Square** | Same search space | Check if exact square exists |
| **Pow(x, n)** | Exponentiation | Multiply instead of square |
| **Find Peak Element** | Binary search | No sorted array |
| **Guess Number** | Binary search | External comparison |

---

## Day 39 Summary

### Problems Solved: 1
1. ✅ Sqrt(x) - Integer Square Root

### Key Patterns Learned:
1. **Binary Search on Answer Space** - Search for threshold in monotonic space
2. **Overflow Prevention** - Using division instead of multiplication
3. **Newton's Method** - Iterative approximation with quadratic convergence

### Techniques Mastered:
- Binary search on implicit sorted array
- Saving last valid answer during search
- Using right pointer as result
- Newton-Raphson iterative method

### Complexity Insights:
- Binary search: O(log n) time, O(1) space
- Newton's method: O(log log n) time (faster convergence)
- Both are optimal for this problem

### When to Use This Pattern:
- Finding threshold in monotonic space
- Search problems without explicit array
- Optimization problems with binary answer
- Problems requiring O(log n) solution

---

## Quick Reference

### Binary Search Template for "Find Floor"
```python
def find_floor(target):
    left, right = min_val, max_val
    ans = default_value
    
    while left <= right:
        mid = (left + right) // 2
        
        if condition_met(mid):
            ans = mid           # Save valid answer
            left = mid + 1      # Try to find larger
        else:
            right = mid - 1     # Search smaller
    
    return ans
```

### Newton's Method Template
```python
def newton_method(n):
    if n < 2:
        return n
    
    guess = n
    
    while not converged(guess):
        guess = update_formula(guess, n)
    
    return guess
```

### Time Complexity Comparison
```
For x = 10^9:
- Linear search: 10^9 operations
- Binary search: ~30 operations
- Newton's method: ~5 operations
```
