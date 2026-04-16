# Day 51: Power of Two

## Problem Statement
**LeetCode 231: Power of Two**

Given an integer n, return true if it is a power of two. Otherwise, return false.

An integer n is a power of two, if there exists an integer x such that n == 2^x.

**Examples:**
```
Input: n = 1
Output: true
Explanation: 2^0 = 1

Input: n = 16
Output: true
Explanation: 2^4 = 16

Input: n = 3
Output: false

Input: n = 0
Output: false

Input: n = -16
Output: false
```

**Constraints:**
- -2³¹ <= n <= 2³¹ - 1

**Follow-up:** Could you solve it without loops/recursion?

---

## Problem Logic & Reasoning

### Core Concept
A number is a power of 2 if it can be expressed as 2^x for some non-negative integer x.

**Key Insight:** Powers of 2 have exactly **one bit set** in their binary representation.

### Visual Understanding - Binary Representation

```
Powers of 2:
1   = 2^0  = 0000 0001  (1 bit set)
2   = 2^1  = 0000 0010  (1 bit set)
4   = 2^2  = 0000 0100  (1 bit set)
8   = 2^3  = 0000 1000  (1 bit set)
16  = 2^4  = 0001 0000  (1 bit set)
32  = 2^5  = 0010 0000  (1 bit set)

Not powers of 2:
3   = 0000 0011  (2 bits set)
5   = 0000 0101  (2 bits set)
6   = 0000 0110  (2 bits set)
7   = 0000 0111  (3 bits set)
```

### The Magic of n & (n-1)

```
For power of 2:
n   = 8  = 1000
n-1 = 7  = 0111
n & (n-1) = 0000 = 0 ✓

For non-power of 2:
n   = 6  = 0110
n-1 = 5  = 0101
n & (n-1) = 0100 = 4 ≠ 0 ✗
```

### Why This Works

```
Power of 2: Only one bit is set
Subtracting 1: Flips all bits after the set bit

Example: 16 (10000)
16 - 1 = 15 (01111)
16 & 15 = 00000 = 0

Example: 12 (01100) - not power of 2
12 - 1 = 11 (01011)
12 & 11 = 01000 ≠ 0
```

---

## Approach 1: Bit Manipulation (n & (n-1)) ⭐⭐⭐

### Logic
A power of 2 has exactly one bit set. Using `n & (n-1)` removes the rightmost set bit. If result is 0, n was a power of 2.

### Visual Flow for n = 16

```
n = 16 = 10000 (binary)

Check: n > 0?
    16 > 0 ✓

Calculate: n & (n-1)
    n   = 16 = 10000
    n-1 = 15 = 01111
    n & (n-1) = 00000 = 0 ✓

Result: true
```

### Step-by-Step for Different Values

```
n = 8:
    8   = 1000
    7   = 0111
    8&7 = 0000 = 0 → true ✓

n = 6:
    6   = 0110
    5   = 0101
    6&5 = 0100 = 4 → false ✗

n = 1:
    1   = 0001
    0   = 0000
    1&0 = 0000 = 0 → true ✓

n = 0:
    0 > 0? false → false ✗

n = -16:
    -16 > 0? false → false ✗
```

### Pseudocode
```
function isPowerOfTwo(n):
    return n > 0 and (n & (n-1)) == 0
```

### Complexity Analysis
- **Time:** O(1) - Single bitwise operation
- **Space:** O(1) - No extra space

---

## Approach 2: Iterative Division

### Logic
Repeatedly divide by 2. If we reach 1, it's a power of 2. If we get an odd number (other than 1), it's not.

### Visual Flow for n = 16

```
n = 16

Iteration 1:
    16 % 2 == 0? Yes
    n = 16 / 2 = 8

Iteration 2:
    8 % 2 == 0? Yes
    n = 8 / 2 = 4

Iteration 3:
    4 % 2 == 0? Yes
    n = 4 / 2 = 2

Iteration 4:
    2 % 2 == 0? Yes
    n = 2 / 2 = 1

Exit loop: n == 1? Yes → true ✓
```

### Step-by-Step for n = 6

```
n = 6

Iteration 1:
    6 % 2 == 0? Yes
    n = 6 / 2 = 3

Iteration 2:
    3 % 2 == 0? No
    Exit loop

n == 1? No (n = 3) → false ✗
```

### Pseudocode
```
function isPowerOfTwo(n):
    if n == 0:
        return false
    
    while n % 2 == 0:
        n = n / 2
    
    return n == 1
```

### Complexity Analysis
- **Time:** O(log n) - Divide by 2 each iteration
- **Space:** O(1) - Only variable n

---

## Approach 3: Recursive Division

### Logic
Recursively divide by 2 until we reach 1 (power of 2) or an odd number (not power of 2).

### Visual Flow for n = 8

```
isPowerOfTwo(8)
    8 > 0? Yes
    8 == 1? No
    8 % 2 == 0? Yes
    → isPowerOfTwo(8 / 2) = isPowerOfTwo(4)
        4 > 0? Yes
        4 == 1? No
        4 % 2 == 0? Yes
        → isPowerOfTwo(4 / 2) = isPowerOfTwo(2)
            2 > 0? Yes
            2 == 1? No
            2 % 2 == 0? Yes
            → isPowerOfTwo(2 / 2) = isPowerOfTwo(1)
                1 > 0? Yes
                1 == 1? Yes
                → return true ✓

Result: true
```

### Pseudocode
```
function isPowerOfTwo(n):
    if n <= 0:
        return false
    if n == 1:
        return true
    if n % 2 != 0:
        return false
    
    return isPowerOfTwo(n / 2)
```

### Complexity Analysis
- **Time:** O(log n) - Recursion depth
- **Space:** O(log n) - Recursion stack

---

## Approach 4: Brute Force (Check All Powers)

### Logic
Check if n equals 2^i for i from 0 to 30 (since 2^31 > max int).

### Pseudocode
```
function isPowerOfTwo(n):
    for i from 0 to 30:
        if 2^i == n:
            return true
    
    return false
```

### Complexity Analysis
- **Time:** O(log n) - Check up to 31 values
- **Space:** O(1) - Only loop variable

---

## Approach Comparison

| Aspect | Bit Manipulation | Iterative | Recursive | Brute Force |
|--------|-----------------|-----------|-----------|-------------|
| **Time Complexity** | O(1) ⭐ | O(log n) | O(log n) | O(log n) |
| **Space Complexity** | O(1) ⭐ | O(1) | O(log n) | O(1) |
| **Readability** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Elegance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Best For** | Optimal solution | Understanding | Learning | Simplicity |

---

## Critical Insights

### 1. Why n > 0 Check is Essential
```
n = 0:
    0 & (0-1) = 0 & -1 = 0
    But 0 is NOT a power of 2!

n = -16:
    -16 in binary (two's complement) has multiple bits set
    But negative numbers can't be powers of 2!

Solution: Always check n > 0 first
```

### 2. The n & (n-1) Trick Explained
```
What n-1 does:
- Flips the rightmost 1 bit to 0
- Flips all 0s to the right of it to 1

Example: 12 (01100)
12 - 1 = 11 (01011)
         ↑↑↑↑↑
         Rightmost 1 flipped, rest flipped

For power of 2 (only one 1 bit):
8 (1000) - 1 = 7 (0111)
8 & 7 = 0 (no common bits!)
```

### 3. Edge Cases
```
n = 1: 2^0 = 1 → true ✓
n = 0: Not a power of 2 → false
n < 0: Negative numbers → false
n = 2^31: Overflow in some languages
```

### 4. Why This Doesn't Work for Powers of 3
```
Powers of 3: 1, 3, 9, 27, 81...
Binary: 1, 11, 1001, 11011, 1010001...

Multiple bits set! n & (n-1) trick doesn't work.

For power of 3, use: n > 0 and 3^19 % n == 0
(3^19 is largest power of 3 in 32-bit int)
```

### 5. Bit Counting Alternative
```
Another approach: Count set bits
Power of 2 has exactly 1 bit set

def isPowerOfTwo(n):
    return n > 0 and bin(n).count('1') == 1
```

---

## Common Mistakes

### ❌ Mistake 1: Forgetting n > 0 Check
```python
def isPowerOfTwo(n):
    return (n & (n-1)) == 0  # Wrong! Accepts 0 and negatives
```

### ❌ Mistake 2: Using n & n-1 Without Parentheses
```python
return n > 0 and n & (n-1) == 0  # Wrong! Precedence issue
# Correct:
return n > 0 and (n & (n-1)) == 0
```

### ❌ Mistake 3: Not Handling n = 0 in Division
```python
while n % 2 == 0:
    n = n / 2
return n == 1  # Wrong! Returns true for n=0
```

### ❌ Mistake 4: Integer Division Issues
```python
n = n / 2  # May create float in Python 3
# Better:
n = n // 2  # Integer division
```

### ❌ Mistake 5: Infinite Recursion
```python
def isPowerOfTwo(n):
    if n == 1:
        return True
    return isPowerOfTwo(n // 2)  # Missing base cases!
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `1` | `true` | 2^0 = 1 |
| `2` | `true` | 2^1 = 2 |
| `16` | `true` | 2^4 = 16 |
| `0` | `false` | Not a power of 2 |
| `-16` | `false` | Negative number |
| `3` | `false` | Not a power of 2 |
| `2147483647` | `false` | 2^31 - 1 (not power of 2) |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Power of Three** - Similar but different approach
2. **Power of Four** - Can use bit manipulation with mask
3. **Number of 1 Bits** - Count set bits
4. **Single Number** - XOR bit manipulation

### Key Characteristics:
- Bit manipulation
- Powers of numbers
- Binary representation properties
- O(1) time solutions

---

## Complete Implementations

### Implementation 1: Bit Manipulation ⭐⭐⭐
```python
def isPowerOfTwo(n: int) -> bool:
    return n > 0 and (n & (n-1)) == 0
```

### Implementation 2: Iterative Division
```python
def isPowerOfTwo(n: int) -> bool:
    if n == 0:
        return False
    
    while n % 2 == 0:
        n = n // 2
    
    return n == 1
```

### Implementation 3: Recursive Division
```python
def isPowerOfTwo(n: int) -> bool:
    if n <= 0:
        return False
    if n == 1:
        return True
    if n % 2 != 0:
        return False
    
    return isPowerOfTwo(n // 2)
```

### Implementation 4: Brute Force
```python
def isPowerOfTwo(n: int) -> bool:
    for i in range(31):
        if 2 ** i == n:
            return True
    return False
```

### Implementation 5: Bit Counting
```python
def isPowerOfTwo(n: int) -> bool:
    return n > 0 and bin(n).count('1') == 1
```

### Implementation 6: Using Math
```python
import math

def isPowerOfTwo(n: int) -> bool:
    if n <= 0:
        return False
    
    log_val = math.log2(n)
    return log_val == int(log_val)
```

---

## Related Bit Manipulation Tricks

### Power of Four
```python
def isPowerOfFour(n: int) -> bool:
    # Power of 4 is also power of 2
    # AND has 1 bit at odd position (0x55555555 = 01010101...)
    return n > 0 and (n & (n-1)) == 0 and (n & 0x55555555) != 0
```

### Power of Three
```python
def isPowerOfThree(n: int) -> bool:
    # 3^19 is largest power of 3 in 32-bit int
    return n > 0 and 1162261467 % n == 0
```

### Count Set Bits
```python
def countBits(n: int) -> int:
    count = 0
    while n:
        count += 1
        n &= (n - 1)  # Remove rightmost set bit
    return count
```

---

## Mathematical Deep Dive

### Binary Representation of Powers of 2
```
2^0  = 1     = 0000 0001
2^1  = 2     = 0000 0010
2^2  = 4     = 0000 0100
2^3  = 8     = 0000 1000
2^4  = 16    = 0001 0000
2^5  = 32    = 0010 0000
2^6  = 64    = 0100 0000
2^7  = 128   = 1000 0000

Pattern: Exactly one bit is set!
```

### Why n & (n-1) Removes Rightmost Bit
```
n     = ...10110000
n-1   = ...10101111
        ↑↑↑↑↑↑↑↑
        Rightmost 1 becomes 0
        All bits to right become 1

n & (n-1) = ...10100000
            Rightmost 1 removed!
```

### Two's Complement for Negative Numbers
```
-16 in 32-bit:
16  = 0000 0000 0000 0000 0000 0000 0001 0000
~16 = 1111 1111 1111 1111 1111 1111 1110 1111
-16 = 1111 1111 1111 1111 1111 1111 1111 0000

Multiple bits set! Not a power of 2.
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Power of Three** | Same concept | Different base |
| **Power of Four** | Same concept | Additional constraint |
| **Number of 1 Bits** | Bit manipulation | Count bits |
| **Single Number** | Bit manipulation | XOR operation |
| **Reverse Bits** | Bit manipulation | Bit reversal |

---

## Day 51 Summary

### Problems Solved: 1
1. ✅ Power of Two

### Key Patterns Learned:
1. **Bit Manipulation** - Using n & (n-1) to check single bit
2. **Binary Properties** - Powers of 2 have one bit set
3. **Multiple Approaches** - Bit tricks vs iterative vs recursive

### Techniques Mastered:
- n & (n-1) trick for removing rightmost bit
- Binary representation analysis
- Iterative and recursive division
- O(1) time bit manipulation

### Complexity Insights:
- Bit manipulation: O(1) time, O(1) space (optimal!)
- Iterative/Recursive: O(log n) time
- All approaches work, but bit manipulation is fastest

### When to Use This Pattern:
- Power of number problems
- Bit manipulation problems
- Binary representation analysis
- O(1) time requirement

---

## Quick Reference

### Bit Manipulation Template
```python
def isPowerOfTwo(n):
    return n > 0 and (n & (n-1)) == 0
```

### Powers of 2 (First 16)
```
2^0  = 1
2^1  = 2
2^2  = 4
2^3  = 8
2^4  = 16
2^5  = 32
2^6  = 64
2^7  = 128
2^8  = 256
2^9  = 512
2^10 = 1024
2^11 = 2048
2^12 = 4096
2^13 = 8192
2^14 = 16384
2^15 = 32768
```

### Common Bit Tricks
```python
# Remove rightmost set bit
n & (n - 1)

# Get rightmost set bit
n & (-n)

# Check if power of 2
n > 0 and (n & (n-1)) == 0

# Count set bits
count = 0
while n:
    count += 1
    n &= (n - 1)
```

### Binary Representation Quick Check
```python
# View binary
bin(n)  # Returns '0b1000' for 8

# Count 1 bits
bin(n).count('1')

# Check specific bit
(n >> i) & 1  # Check if ith bit is set
```
