# Day 37: Number of 1 Bits (Hamming Weight)

## Problem: Number of 1 Bits

### Problem Statement
Given a positive integer `n`, return the number of set bits (1s) in its binary representation. This is also known as the **Hamming weight**.

**Constraints**:
- 1 ≤ n ≤ 2³¹ - 1

### Problem Logic & Reasoning

#### What is Hamming Weight?
```
Hamming Weight = Count of 1 bits in binary representation

Examples:
11 (decimal) = 1011 (binary) → 3 ones
128 (decimal) = 10000000 (binary) → 1 one
7 (decimal) = 111 (binary) → 3 ones
```

#### Key Insight
```
Need to count 1s in binary representation:
- Can't just look at decimal value
- Must examine each bit
- Multiple approaches with different efficiency
```

---

## Approach 1: Brian Kernighan's Algorithm ⭐

### Core Insight
**Magic trick**: `n & (n-1)` removes the rightmost 1 bit!

### The Magic Behind n & (n-1)

#### How n-1 Works
```
When you subtract 1 from n:
1. Rightmost 1 bit becomes 0
2. All bits to the right become 1

Examples:
n = 12:  1100
n-1 = 11: 1011
         ↑ rightmost 1 flipped to 0
          ↑↑ trailing 0s became 1s

n = 8:   1000
n-1 = 7:  0111
         ↑ rightmost 1 flipped to 0
          ↑↑↑ trailing 0s became 1s

n = 11:  1011
n-1 = 10: 1010
           ↑ rightmost 1 flipped to 0
```

#### How n & (n-1) Removes Rightmost 1
```
AND operation keeps only common 1s:

Example 1: n = 12
n:     1100
n-1:   1011
n&(n-1): 1000  (removed rightmost 1)

Example 2: n = 11
n:     1011
n-1:   1010
n&(n-1): 1010  (removed rightmost 1)

Example 3: n = 8
n:     1000
n-1:   0111
n&(n-1): 0000  (removed rightmost 1)

Pattern: Each operation removes exactly one 1 bit!
```

### Pseudocode
```
HAMMING_WEIGHT(n):
    count = 0
    
    while n != 0:
        n = n & (n-1)  # Remove rightmost 1
        count++
    
    return count
```

### Visual Flow - Example 1
```
n = 11 (binary: 1011)

Iteration 1:
n = 1011
n-1 = 1010
n & (n-1) = 1010
count = 1

Iteration 2:
n = 1010
n-1 = 1001
n & (n-1) = 1000
count = 2

Iteration 3:
n = 1000
n-1 = 0111
n & (n-1) = 0000
count = 3

n = 0, stop
Result: 3
```

### Visual Flow - Example 2
```
n = 128 (binary: 10000000)

Iteration 1:
n = 10000000
n-1 = 01111111
n & (n-1) = 00000000
count = 1

n = 0, stop
Result: 1
```

### Step-by-Step Trace
```
n = 11 (1011 in binary)

Step 1: Check n != 0? Yes (1011)
  n & (n-1):
    1011 (11)
  & 1010 (10)
  -------
    1010 (10)
  count = 1

Step 2: Check n != 0? Yes (1010)
  n & (n-1):
    1010 (10)
  & 1001 (9)
  -------
    1000 (8)
  count = 2

Step 3: Check n != 0? Yes (1000)
  n & (n-1):
    1000 (8)
  & 0111 (7)
  -------
    0000 (0)
  count = 3

Step 4: Check n != 0? No (0000)
  Exit loop

Return count = 3
```

### Why This is Brilliant
```
Efficiency:
- Only iterates for each 1 bit
- Not for each bit position
- O(k) where k = number of 1s

Example:
n = 10000000 (128)
- Has 1 one bit
- Only 1 iteration!

Compare to checking all 32 bits:
- Would need 32 iterations
- Brian Kernighan: 1 iteration
- 32x faster!
```

### Complexity
- **Time**: O(k) where k = number of 1 bits
  - Best case: O(1) for powers of 2 (single 1 bit)
  - Worst case: O(32) for all 1s (still constant)
- **Space**: O(1)

---

## Approach 2: Check Each Bit with Right Shift

### Core Insight
Check least significant bit, then shift right. Repeat until n becomes 0.

### Pseudocode
```
HAMMING_WEIGHT_SHIFT(n):
    count = 0
    
    while n != 0:
        if n & 1:  # Check if LSB is 1
            count++
        n = n >> 1  # Right shift by 1
    
    return count
```

### Visual Flow
```
n = 11 (binary: 1011)

Iteration 1:
n = 1011
n & 1 = 1 (LSB is 1)
count = 1
n >> 1 = 0101 (5)

Iteration 2:
n = 0101
n & 1 = 1 (LSB is 1)
count = 2
n >> 1 = 0010 (2)

Iteration 3:
n = 0010
n & 1 = 0 (LSB is 0)
count = 2
n >> 1 = 0001 (1)

Iteration 4:
n = 0001
n & 1 = 1 (LSB is 1)
count = 3
n >> 1 = 0000 (0)

n = 0, stop
Result: 3
```

### How Right Shift Works
```
Right shift (>>) divides by 2:

1011 >> 1 = 0101  (11 >> 1 = 5)
0101 >> 1 = 0010  (5 >> 1 = 2)
0010 >> 1 = 0001  (2 >> 1 = 1)
0001 >> 1 = 0000  (1 >> 1 = 0)

Each shift moves bits one position right:
- Rightmost bit is discarded
- 0 is added on the left
```

### Complexity
- **Time**: O(log n) or O(32) for 32-bit integer
  - Must check all bit positions
- **Space**: O(1)

---

## Approach 3: Built-in Function

### Core Insight
Use Python's built-in bin() and count().

### Pseudocode
```
HAMMING_WEIGHT_BUILTIN(n):
    return bin(n).count('1')
```

### Visual Flow
```
n = 11

Step 1: Convert to binary string
bin(11) = "0b1011"

Step 2: Count '1' characters
"0b1011".count('1') = 3

Result: 3
```

### Complexity
- **Time**: O(log n) - bin() creates string of length log n
- **Space**: O(log n) - stores binary string

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Brian Kernighan** ⭐ | O(k) | O(1) | Optimal, elegant | Requires understanding |
| **Right Shift** | O(log n) | O(1) | Straightforward | Checks all bits |
| **Built-in** | O(log n) | O(log n) | Simple | Uses extra space |

**Best Choice**: Brian Kernighan's algorithm - most efficient

---

## Understanding Bit Operations

### AND Operation (&)
```
Returns 1 only if both bits are 1:

  1011
& 1010
------
  1010

Bit-by-bit:
1 & 1 = 1
0 & 0 = 0
1 & 1 = 1
1 & 0 = 0
```

### Right Shift (>>)
```
Shifts bits to the right, fills with 0 on left:

1011 >> 1 = 0101
0101 >> 1 = 0010
0010 >> 1 = 0001
0001 >> 1 = 0000

Equivalent to dividing by 2 (integer division)
```

### Check LSB (n & 1)
```
AND with 1 checks if last bit is 1:

1011 & 0001 = 0001 (1) → LSB is 1
1010 & 0001 = 0000 (0) → LSB is 0
0101 & 0001 = 0001 (1) → LSB is 1
0100 & 0001 = 0000 (0) → LSB is 0

Pattern: n & 1 returns 1 if n is odd, 0 if even
```

---

## Why n & (n-1) is Magic

### Mathematical Proof
```
Let n have binary representation: ...1000...0
                                      ↑
                                  rightmost 1

n-1 flips this 1 and all trailing 0s:
n:   ...1000...0
n-1: ...0111...1

n & (n-1):
  ...1000...0
& ...0111...1
-------------
  ...0000...0

Result: All bits after rightmost 1 become 0,
        rightmost 1 becomes 0
```

### Examples with Different Patterns

#### Power of 2 (single 1 bit)
```
n = 8:   1000
n-1 = 7: 0111
n & (n-1) = 0000

One operation removes the only 1!
```

#### Multiple 1 bits
```
n = 15:  1111
n-1 = 14: 1110
n & (n-1) = 1110

n = 14:  1110
n-1 = 13: 1101
n & (n-1) = 1100

n = 12:  1100
n-1 = 11: 1011
n & (n-1) = 1000

n = 8:   1000
n-1 = 7:  0111
n & (n-1) = 0000

Four operations for four 1s!
```

#### Alternating bits
```
n = 10:  1010
n-1 = 9:  1001
n & (n-1) = 1000

n = 8:   1000
n-1 = 7:  0111
n & (n-1) = 0000

Two operations for two 1s!
```

---

## Edge Cases

```python
# Case 1: Power of 2 (single 1 bit)
n = 1 (0001)
Output: 1

n = 128 (10000000)
Output: 1

# Case 2: All 1s
n = 15 (1111)
Output: 4

n = 255 (11111111)
Output: 8

# Case 3: Alternating bits
n = 5 (0101)
Output: 2

n = 10 (1010)
Output: 2

# Case 4: Maximum 32-bit value
n = 2147483647 (01111111111111111111111111111111)
Output: 31

# Case 5: Minimum value
n = 1 (0001)
Output: 1
```

---

## Common Mistakes

1. ❌ **Using n & n-1 without parentheses**: Operator precedence issues
2. ❌ **Forgetting to increment count**: Counting iterations, not 1s
3. ❌ **Checking n > 0 instead of n != 0**: Doesn't work for all cases
4. ❌ **Using left shift instead of right shift**: Wrong direction
5. ❌ **Not understanding why n & (n-1) works**: Can't debug issues

---

## Bit Manipulation Fundamentals

### Binary Representation
```
Decimal → Binary:
11 = 8 + 2 + 1 = 1011
128 = 128 = 10000000
7 = 4 + 2 + 1 = 111

Position: 7 6 5 4 3 2 1 0
Power:    128 64 32 16 8 4 2 1
```

### Common Bit Operations
```
Check if bit i is set:
n & (1 << i)

Set bit i:
n | (1 << i)

Clear bit i:
n & ~(1 << i)

Toggle bit i:
n ^ (1 << i)

Check if power of 2:
n & (n-1) == 0

Get rightmost 1:
n & -n
```

---

## Complete Implementation

```python
class Solution:
    def hammingWeight(self, n: int) -> int:
        """
        Count number of 1 bits using Brian Kernighan's algorithm.
        
        Time: O(k) where k = number of 1 bits
        Space: O(1)
        """
        count = 0
        
        while n:
            n = n & (n-1)  # Remove rightmost 1 bit
            count += 1
        
        return count
```

### Alternative: Right Shift
```python
class Solution:
    def hammingWeight(self, n: int) -> int:
        """
        Count number of 1 bits using right shift.
        
        Time: O(log n)
        Space: O(1)
        """
        count = 0
        
        while n:
            count += n & 1  # Add 1 if LSB is 1
            n >>= 1         # Right shift
        
        return count
```

### Alternative: Built-in
```python
class Solution:
    def hammingWeight(self, n: int) -> int:
        """
        Count number of 1 bits using built-in.
        
        Time: O(log n)
        Space: O(log n)
        """
        return bin(n).count('1')
```

---

## Performance Comparison

### Example: n = 10000000 (128)
```
Brian Kernighan:
- 1 iteration (only 1 one bit)
- O(1) time

Right Shift:
- 8 iterations (8 bit positions)
- O(log n) time

Built-in:
- Creates string "0b10000000"
- Counts '1' characters
- O(log n) time + O(log n) space
```

### Example: n = 11111111 (255)
```
Brian Kernighan:
- 8 iterations (8 one bits)
- O(8) time

Right Shift:
- 8 iterations (8 bit positions)
- O(8) time

Same performance when all bits are 1!
```

### Example: n = 10101010 (170)
```
Brian Kernighan:
- 4 iterations (4 one bits)
- O(4) time

Right Shift:
- 8 iterations (8 bit positions)
- O(8) time

Brian Kernighan is 2x faster!
```

---

## Applications of Hamming Weight

### 1. Error Detection
```
Hamming distance between two numbers:
- XOR the numbers
- Count 1s in result

Example:
a = 1011
b = 1001
a ^ b = 0010 (1 bit different)
Hamming distance = 1
```

### 2. Check Power of 2
```
Power of 2 has exactly one 1 bit:

n & (n-1) == 0

Examples:
8 (1000) & 7 (0111) = 0 → Power of 2 ✓
6 (0110) & 5 (0101) = 4 → Not power of 2 ✗
```

### 3. Count Bits to Flip
```
To convert a to b, count bits that differ:

a = 10
b = 7
a ^ b = 13 (1101)
Bits to flip = hammingWeight(13) = 3
```

---

## Day 37 Summary

### Key Concepts
1. **Hamming Weight**: Count of 1 bits in binary
2. **Brian Kernighan's Algorithm**: n & (n-1) removes rightmost 1
3. **Bit Operations**: AND, shift, check LSB
4. **Efficiency**: O(k) vs O(log n)

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Count 1 Bits | Bit Manipulation | n & (n-1) | O(k) |
| Check Power of 2 | Bit Manipulation | n & (n-1) == 0 | O(1) |
| Hamming Distance | Bit Manipulation | XOR + count 1s | O(k) |

### Bit Operations Summary

| Operation | Syntax | Purpose | Example |
|-----------|--------|---------|---------|
| AND | a & b | Keep common 1s | 1011 & 1010 = 1010 |
| OR | a \| b | Combine 1s | 1011 \| 1010 = 1011 |
| XOR | a ^ b | Find differences | 1011 ^ 1010 = 0001 |
| NOT | ~a | Flip all bits | ~1011 = 0100 |
| Left Shift | a << n | Multiply by 2ⁿ | 1011 << 1 = 10110 |
| Right Shift | a >> n | Divide by 2ⁿ | 1011 >> 1 = 0101 |

### Critical Insights
1. **n & (n-1) Magic**: Removes rightmost 1 bit
2. **Iteration Count**: Only iterates for each 1 bit
3. **n & 1 Check**: Tests if LSB is 1 (odd/even)
4. **Right Shift**: Divides by 2, moves bits right
5. **Efficiency**: O(k) better than O(log n) when k << log n

### When to Use This Pattern
- Counting set bits
- Bit manipulation problems
- Power of 2 checks
- Hamming distance calculations
- Error detection/correction

### Master Checklist
- [ ] Understand binary representation
- [ ] Know how n-1 flips bits
- [ ] Can explain why n & (n-1) removes rightmost 1
- [ ] Understand AND, OR, XOR, shift operations
- [ ] Know difference between O(k) and O(log n)
- [ ] Can implement Brian Kernighan's algorithm
- [ ] Understand when to use each approach
- [ ] Know applications (power of 2, Hamming distance)

### Related Problems
- Power of Two
- Counting Bits
- Hamming Distance
- Single Number
- Reverse Bits
- Bitwise AND of Numbers Range
- Sum of Two Integers
- Missing Number
