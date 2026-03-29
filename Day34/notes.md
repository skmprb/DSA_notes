# Day 34: Divide Two Integers

## Problem: Divide Two Integers (LeetCode 29)

### Problem Statement
Divide two integers **without** using multiplication, division, or mod operator. Truncate toward zero.

**Constraints:**
- `-2^31 <= dividend, divisor <= 2^31 - 1`
- `divisor != 0`
- If quotient overflows 32-bit signed integer, return `2^31 - 1`

### Examples
```
Input: dividend = 10, divisor = 3 → Output: 3
Input: dividend = 7, divisor = -3 → Output: -2
Input: dividend = -2147483648, divisor = -1 → Output: 2147483647 (overflow clamped)
```

---

## Deep Dive: Python's abs() Function

### What is abs()?
```
abs(x) returns the absolute value of x — the distance from zero on the number line.

abs(5)   → 5    (already positive)
abs(-5)  → 5    (negated to positive)
abs(0)   → 0    (zero stays zero)
abs(-3.7)→ 3.7  (works on floats too)
```

### Why abs() Matters in This Problem
```
Division logic is SIMPLER with positive numbers.
Instead of handling 4 sign combinations:
  (+, +), (+, -), (-, +), (-, -)

We:
1. Convert both to positive using abs()
2. Do the division on positives
3. Apply the correct sign at the end

Example: 7 / -3
Step 1: abs(7) = 7, abs(-3) = 3
Step 2: 7 / 3 = 2 (using bit shifting)
Step 3: Signs differ → -2
```

### How abs() Works Internally
```
For integers:
  abs(x) = x    if x >= 0
  abs(x) = -x   if x < 0

For floats:
  Same logic, but on floating point representation

For complex numbers:
  abs(3+4j) = sqrt(3² + 4²) = 5.0  (magnitude)
```

### abs() vs Manual Negation
```python
# These are equivalent for integers:
abs_val = abs(x)
abs_val = x if x >= 0 else -x

# But abs() is:
# 1. More readable
# 2. Works on floats, complex numbers
# 3. Handles edge cases (like -0.0)
```

### Critical Edge Case: abs(-2^31)
```
32-bit signed integer range: [-2147483648, 2147483647]

abs(-2147483648) = 2147483648  ← OVERFLOWS in C/Java!

In C/Java:
  int x = -2147483648;
  abs(x) → -2147483648  (undefined behavior / wraps around!)

In Python:
  abs(-2147483648) → 2147483648  (works fine, arbitrary precision)

This is why the problem has the special edge case:
  dividend = -2147483648, divisor = -1
  Result = 2147483648 → exceeds INT_MAX → return 2147483647
```

### abs() with Different Types
```python
abs(-42)        # int → 42
abs(-3.14)      # float → 3.14
abs(3+4j)       # complex → 5.0 (magnitude)
abs(True)       # bool → 1 (True is 1)
abs(False)      # bool → 0

# Custom objects can define __abs__:
class Vector:
    def __init__(self, x, y):
        self.x, self.y = x, y
    def __abs__(self):
        return (self.x**2 + self.y**2)**0.5

abs(Vector(3, 4))  # → 5.0
```

---

## Problem Logic & Reasoning

### Why Can't We Use *, /, %?
```
The problem tests understanding of how division works at the BIT level.
Division is fundamentally repeated subtraction:
  10 / 3 = ?
  10 - 3 = 7  (count 1)
  7 - 3 = 4   (count 2)
  4 - 3 = 1   (count 3)
  1 < 3 → stop
  Answer: 3
```

### Naive Subtraction is Too Slow
```
dividend = 2147483647, divisor = 1
→ 2,147,483,647 subtractions!
→ TLE (Time Limit Exceeded)

Need a faster approach...
```

### Key Insight: Bit Shifting = Doubling
```
Instead of subtracting divisor ONE at a time,
DOUBLE the divisor using left shift (<<) until it exceeds dividend.

Left shift << 1 = multiply by 2
  3 << 0 = 3   (3 × 1)
  3 << 1 = 6   (3 × 2)
  3 << 2 = 12  (3 × 4)
  3 << 3 = 24  (3 × 8)

This lets us subtract LARGE chunks at once!
```

---

## Approach 1: Bit Shifting (Top-Down) ⭐

### Core Idea
Try the largest possible power-of-2 multiple of divisor first, then work down.

### Pseudocode
```
DIVIDE(dividend, divisor):
    Handle overflow edge case
    abs_d = abs(dividend)
    abs_r = abs(divisor)
    quotient = 0

    for i from 31 down to 0:
        if (abs_r << i) <= abs_d:
            abs_d -= (abs_r << i)
            quotient += (1 << i)

    Apply sign and return
```

### Detailed Visual Flow

#### Example: dividend = 43, divisor = 5
```
abs_d = 43, abs_r = 5, quotient = 0

i=31 to i=4: 5 << i > 43, skip all

i=3: 5 << 3 = 40 ≤ 43 ✓
     abs_d = 43 - 40 = 3
     quotient = 0 + 8 = 8

i=2: 5 << 2 = 20 > 3, skip
i=1: 5 << 1 = 10 > 3, skip
i=0: 5 << 0 = 5 > 3, skip

quotient = 8
43 / 5 = 8 remainder 3 ✓
```

#### Example: dividend = 10, divisor = 3
```
abs_d = 10, abs_r = 3, quotient = 0

i=31 to i=2: 3 << i > 10 for i≥2 (3<<2=12), skip

i=1: 3 << 1 = 6 ≤ 10 ✓
     abs_d = 10 - 6 = 4
     quotient = 0 + 2 = 2

i=0: 3 << 0 = 3 ≤ 4 ✓
     abs_d = 4 - 3 = 1
     quotient = 2 + 1 = 3

quotient = 3
10 / 3 = 3 remainder 1 ✓
```

#### Example: dividend = 7, divisor = -3
```
abs_d = 7, abs_r = 3, quotient = 0

i=1: 3 << 1 = 6 ≤ 7 ✓
     abs_d = 7 - 6 = 1
     quotient = 0 + 2 = 2

i=0: 3 << 0 = 3 > 1, skip

quotient = 2
Signs differ (7 > 0, -3 < 0) → -2
```

### Why Start from i=31?
```
32-bit signed integer max = 2^31 - 1
Starting from 31 ensures we try the LARGEST chunk first.

Think of it like making change:
  Instead of giving 43 pennies (43 subtractions),
  give 1 quarter + 1 dime + 1 nickel + 3 pennies.

  Similarly: 43 / 5
  = 8 fives (5 << 3 = 40)
  + 0 more
  = 8
```

---

## Approach 2: Bit Shifting (Bottom-Up / While Loop)

### Core Idea
Double the divisor until it exceeds dividend, then subtract and repeat.

### Pseudocode
```
DIVIDE(dividend, divisor):
    Handle overflow
    sign = determine sign
    dividend, divisor = abs(dividend), abs(divisor)
    quotient = 0

    while dividend >= divisor:
        temp = divisor
        multiple = 1
        while dividend >= (temp << 1):
            temp <<= 1
            multiple <<= 1
        dividend -= temp
        quotient += multiple

    Apply sign and return
```

### Detailed Visual Flow

#### Example: dividend = 43, divisor = 5
```
Outer loop iteration 1:
  temp = 5, multiple = 1
  Inner loop:
    43 >= 10? Yes → temp=10, multiple=2
    43 >= 20? Yes → temp=20, multiple=4
    43 >= 40? Yes → temp=40, multiple=8
    43 >= 80? No → stop
  dividend = 43 - 40 = 3
  quotient = 0 + 8 = 8

Outer loop iteration 2:
  3 >= 5? No → stop

quotient = 8 ✓
```

#### Example: dividend = 100, divisor = 7
```
Iteration 1:
  temp=7, multiple=1
  100 >= 14? Yes → temp=14, multiple=2
  100 >= 28? Yes → temp=28, multiple=4
  100 >= 56? Yes → temp=56, multiple=8
  100 >= 112? No → stop
  dividend = 100 - 56 = 44, quotient = 8

Iteration 2:
  temp=7, multiple=1
  44 >= 14? Yes → temp=14, multiple=2
  44 >= 28? Yes → temp=28, multiple=4
  44 >= 56? No → stop
  dividend = 44 - 28 = 16, quotient = 8 + 4 = 12

Iteration 3:
  temp=7, multiple=1
  16 >= 14? Yes → temp=14, multiple=2
  16 >= 28? No → stop
  dividend = 16 - 14 = 2, quotient = 12 + 2 = 14

Iteration 4:
  2 >= 7? No → stop

quotient = 14
100 / 7 = 14 remainder 2 ✓
```

---

## Approach 3: Striver's Style (Explicit Sign + Overflow Handling)

### Pseudocode
```
DIVIDE(dividend, divisor):
    if dividend == divisor: return 1

    sign = True
    if signs differ: sign = False

    n = abs(dividend)
    d = abs(divisor)
    ans = 0

    while n >= d:
        cnt = 0
        while n >= (d << (cnt + 1)):
            cnt += 1
        ans += 1 << cnt
        n -= d << cnt

    Clamp to 32-bit range
    Apply sign and return
```

### Key Difference: Overflow Clamping
```
After computing ans:
  if ans >= 2^31 and sign is positive → return INT_MAX (2^31 - 1)
  if ans >= 2^31 and sign is negative → return INT_MIN (-2^31)

This handles: -2147483648 / -1 = 2147483648 > INT_MAX → return 2147483647
```

---

## Sign Determination Techniques

### Method 1: XOR of Sign Bits
```python
sign = -1 if (dividend < 0) ^ (divisor < 0) else 1
```
```
XOR truth table for signs:
  (+, +) → False ^ False = False → sign = 1
  (+, -) → False ^ True  = True  → sign = -1
  (-, +) → True  ^ False = True  → sign = -1
  (-, -) → True  ^ True  = False → sign = 1
```

### Method 2: Equality Check
```python
return quotient if (dividend > 0) == (divisor > 0) else -quotient
```
```
Both positive or both negative → same sign → positive result
One positive, one negative → different signs → negative result
```

### Method 3: Explicit Conditions
```python
sign = True
if dividend >= 0 and divisor < 0: sign = False
if dividend < 0 and divisor >= 0: sign = False
```

---

## Bit Shifting Explained

### Left Shift (<<)
```
x << n = x × 2^n

Binary view:
  5 = 00000101
  5 << 1 = 00001010 = 10
  5 << 2 = 00010100 = 20
  5 << 3 = 00101000 = 40

Used in this problem to:
1. Double the divisor: divisor << 1 = divisor × 2
2. Track the multiple: 1 << i = 2^i
```

### Why << Instead of ×?
```
The problem forbids multiplication.
Left shift IS multiplication by powers of 2,
but it's a BIT OPERATION, not arithmetic multiplication.

Hardware level:
  << just shifts bits left, fills with 0s
  × requires ALU multiplication circuit

So << is allowed by the problem constraints.
```

### Building Quotient with Bit Shifts
```
quotient is built bit by bit:

Example: 43 / 5 = 8

Binary of 8 = 1000

i=3: 5 << 3 = 40 ≤ 43 → quotient += 1<<3 = 8  → quotient = 1000
i=2: 5 << 2 = 20 > 3  → skip
i=1: 5 << 1 = 10 > 3  → skip
i=0: 5 << 0 = 5  > 3  → skip

quotient = 1000 (binary) = 8 (decimal) ✓
```

---

## Edge Cases

### The Critical Overflow Case
```
dividend = -2147483648 (-2^31)
divisor = -1

Expected: 2147483648 (2^31)
But 2^31 > INT_MAX (2^31 - 1)!

Must return 2147483647 (INT_MAX)

This is the ONLY overflow case because:
- Max positive result: 2^31 / 1 = 2^31 → overflow
- But 2^31 is not a valid dividend (max is 2^31-1)
- Only -2^31 is valid, and -2^31 / -1 = 2^31 → overflow
```

### Other Edge Cases
```python
# divisor = 1 → return dividend
divide(10, 1)  # → 10

# divisor = -1 → return -dividend (watch overflow)
divide(10, -1)  # → -10

# dividend = 0 → return 0
divide(0, 5)  # → 0

# dividend < divisor → return 0
divide(3, 5)  # → 0

# dividend = divisor → return 1
divide(5, 5)  # → 1

# dividend = -divisor → return -1
divide(5, -5)  # → -1
```

---

## Complexity Analysis

### Approach 1: Top-Down (for loop)
```
Time: O(32) = O(1)
  - Fixed 32 iterations (one per bit)
  - Each iteration: O(1) shift and compare

Space: O(1)
  - Only a few variables
```

### Approach 2: Bottom-Up (while loop)
```
Time: O(32) = O(1)
  - Outer loop: at most 32 iterations (each removes at least 1 bit)
  - Inner loop: at most 32 doublings total across all outer iterations
  - Total: O(32) = O(1)

Space: O(1)
```

### Why Both Are O(1)
```
The quotient has at most 32 bits.
Each approach processes each bit exactly once.
So total work is bounded by 32 operations regardless of input.
```

---

## Comparison of All Three Approaches

| Aspect | Top-Down (for loop) | Bottom-Up (while) | Striver's Style |
|--------|--------------------|--------------------|-----------------|
| **Loop** | Fixed 32 iterations | Variable iterations | Variable iterations |
| **Direction** | Bit 31 → Bit 0 | Small → Large → subtract | Small → Large → subtract |
| **Overflow** | Pre-check | Post-check via sign | Post-check via clamping |
| **Readability** | Most concise | Clear doubling logic | Most explicit |
| **Time** | O(1) | O(1) | O(1) |
| **Space** | O(1) | O(1) | O(1) |

---

## Day 34 Summary

### Key Concepts
1. **Division = Repeated Subtraction** accelerated by bit shifting
2. **abs()** simplifies sign handling — convert to positive, divide, apply sign
3. **Left shift <<** doubles values without using multiplication
4. **32-bit overflow** must be explicitly handled for `-2^31 / -1`

### Pattern: Bit Manipulation for Arithmetic
```
When arithmetic operators are restricted:
- Addition → bit-by-bit with carry (XOR + AND + shift)
- Multiplication → repeated addition with shifts
- Division → repeated subtraction with shifts ← THIS PROBLEM
```

### Master Checklist
- [ ] Understand why naive subtraction is O(n) and too slow
- [ ] Can explain bit shifting as doubling
- [ ] Know both top-down (for) and bottom-up (while) approaches
- [ ] Understand abs() behavior and its edge case with -2^31
- [ ] Can handle sign determination (XOR method)
- [ ] Know the single overflow case and why it exists
- [ ] Can trace through examples step by step

### Related Problems
- Pow(x, n) — similar bit manipulation for exponentiation
- Add Binary — bit-level arithmetic
- Sum of Two Integers — addition without + operator
- Multiply Strings — multiplication without * operator
