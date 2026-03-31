# Day 36: Add Binary

## Problem: Add Binary

### Problem Statement
Given two binary strings `a` and `b`, return their sum as a binary string.

**Constraints**:
- 1 ≤ a.length, b.length ≤ 10⁴
- a and b consist only of '0' or '1' characters
- No leading zeros except for zero itself

### Problem Logic & Reasoning

#### What is Binary Addition?
```
Binary uses base-2 (only 0 and 1):
0 + 0 = 0
0 + 1 = 1
1 + 0 = 1
1 + 1 = 10 (0 with carry 1)
1 + 1 + 1 = 11 (1 with carry 1)

Similar to decimal addition, but:
- Carry happens at 2 (not 10)
- Each position is power of 2
```

#### Key Insight
```
Process right to left (like decimal addition):
1. Add corresponding digits + carry
2. Result digit = sum % 2
3. New carry = sum // 2
4. Continue until all digits processed

Example:
    11  (3 in decimal)
  +  1  (1 in decimal)
  ----
   100  (4 in decimal)
```

---

## Approach 1: Digit-by-Digit Addition ⭐

### Core Insight
Simulate manual binary addition: process from right to left, track carry.

### Pseudocode
```
ADD_BINARY(a, b):
    result = []
    carry = 0
    i = len(a) - 1
    j = len(b) - 1
    
    while i >= 0 OR j >= 0 OR carry:
        total = carry
        
        if i >= 0:
            total += int(a[i])
            i--
        
        if j >= 0:
            total += int(b[j])
            j--
        
        result.append(str(total % 2))
        carry = total // 2
    
    return reverse(result)
```

### Visual Flow - Example 1
```
a = "11", b = "1"

Initial state:
a:    1  1
      ↑  ↑
      i=0 i=1

b:       1
         ↑
        j=0

carry = 0
result = []

Step 1: i=1, j=0
Add: a[1]=1, b[0]=1, carry=0
total = 1 + 1 + 0 = 2
result digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['0']

Step 2: i=0, j=-1
Add: a[0]=1, carry=1
total = 1 + 1 = 2
result digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['0', '0']

Step 3: i=-1, j=-1, carry=1
Add: carry=1
total = 1
result digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['0', '0', '1']

Step 4: Reverse
result = ['1', '0', '0']
return "100"

Verification:
11 (binary) = 3 (decimal)
 1 (binary) = 1 (decimal)
100 (binary) = 4 (decimal) ✓
```

### Visual Flow - Example 2
```
a = "1010", b = "1011"

Position:  3 2 1 0
a:         1 0 1 0
b:         1 0 1 1
           -------

Step 1: Position 0 (rightmost)
a[3]=0, b[3]=1, carry=0
total = 0 + 1 + 0 = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1']

Step 2: Position 1
a[2]=1, b[2]=1, carry=0
total = 1 + 1 + 0 = 2
digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['1', '0']

Step 3: Position 2
a[1]=0, b[1]=0, carry=1
total = 0 + 0 + 1 = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1', '0', '1']

Step 4: Position 3
a[0]=1, b[0]=1, carry=0
total = 1 + 1 + 0 = 2
digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['1', '0', '1', '0']

Step 5: Final carry
carry = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1', '0', '1', '0', '1']

Step 6: Reverse
result = ['1', '0', '1', '0', '1']
return "10101"

Verification:
1010 (binary) = 10 (decimal)
1011 (binary) = 11 (decimal)
10101 (binary) = 21 (decimal) ✓
```

### Binary Addition Table
```
Digit1 + Digit2 + Carry = Result + New Carry

0 + 0 + 0 = 0 (carry 0)
0 + 0 + 1 = 1 (carry 0)
0 + 1 + 0 = 1 (carry 0)
0 + 1 + 1 = 0 (carry 1)
1 + 0 + 0 = 1 (carry 0)
1 + 0 + 1 = 0 (carry 1)
1 + 1 + 0 = 0 (carry 1)
1 + 1 + 1 = 1 (carry 1)

Pattern:
Result = (digit1 + digit2 + carry) % 2
Carry = (digit1 + digit2 + carry) // 2
```

### Why Process Right to Left?
```
Binary addition (like decimal):
- Start from least significant bit (rightmost)
- Carry propagates left
- Can't determine left digits without right digits

Example:
  111  (carry)
  101
+ 011
-----
 1000

Must process right to left to handle carries correctly!
```

### Complexity
- **Time**: O(max(n, m)) where n = len(a), m = len(b)
  - Process each digit once
- **Space**: O(max(n, m)) for result string

---

## Approach 2: Convert to Integer ⭐

### Core Insight
Convert binary strings to integers, add, convert back to binary.

### Pseudocode
```
ADD_BINARY_INT(a, b):
    num_a = int(a, 2)  # Convert binary string to int
    num_b = int(b, 2)
    sum = num_a + num_b
    return bin(sum)[2:]  # Convert to binary, remove '0b' prefix
```

### Visual Flow
```
a = "11", b = "1"

Step 1: Convert to integers
int("11", 2) = 3
int("1", 2) = 1

Step 2: Add
3 + 1 = 4

Step 3: Convert to binary
bin(4) = "0b100"
Remove "0b": "100"

Result: "100"
```

### Why This Works
```
Python's int(string, base):
- Converts string to integer in given base
- int("11", 2) interprets "11" as binary

Python's bin(number):
- Converts integer to binary string
- Returns "0b" prefix + binary digits
- bin(4) = "0b100"

Slicing [2:]:
- Removes first 2 characters ("0b")
- "0b100"[2:] = "100"
```

### Complexity
- **Time**: O(n + m) for conversion + O(max(n,m)) for addition
- **Space**: O(max(n, m)) for result
- **Note**: Simple but uses built-in functions

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Digit-by-Digit** ⭐ | O(max(n,m)) | O(max(n,m)) | Shows understanding, handles large numbers | More code |
| **Convert to Int** ⭐ | O(n+m) | O(max(n,m)) | Simple, clean | Uses built-ins, may overflow in other languages |

**Best Choices**:
- **Interview**: Digit-by-Digit (shows understanding)
- **Production**: Convert to Int (simpler, Python handles big ints)

---

## Why Digit-by-Digit is Important

### Understanding Binary Addition
```
Manual process teaches:
1. How carry works in binary
2. Bit manipulation concepts
3. Right-to-left processing
4. Handling different lengths

Essential for:
- Hardware design
- Low-level programming
- Bit manipulation problems
- Understanding computer arithmetic
```

### Handling Different Lengths
```
a = "1111"  (length 4)
b = "1"     (length 1)

Process:
Position: 3 2 1 0
a:        1 1 1 1
b:            0 1  (conceptually padded with 0s)

Algorithm handles this naturally:
- When j < 0, don't add from b
- When i < 0, don't add from a
- Continue while carry exists
```

### Carry Propagation
```
Example: 111 + 1

Position: 2 1 0
a:        1 1 1
b:            1
          -----

Step 1: 1 + 1 = 0, carry 1
Step 2: 1 + 0 + carry(1) = 0, carry 1
Step 3: 1 + 0 + carry(1) = 0, carry 1
Step 4: carry(1) = 1

Result: 1000

Carry propagates through all positions!
```

---

## Edge Cases

```python
# Case 1: Different lengths
a = "1111", b = "1"
Output: "10000"

# Case 2: Same length, no carry
a = "10", b = "01"
Output: "11"

# Case 3: All carries
a = "111", b = "1"
Output: "1000"

# Case 4: Zero
a = "0", b = "0"
Output: "0"

# Case 5: One is zero
a = "1010", b = "0"
Output: "1010"

# Case 6: Maximum carry propagation
a = "1111", b = "1111"
Output: "11110"

# Case 7: Single digit
a = "1", b = "1"
Output: "10"
```

---

## Common Mistakes

1. ❌ **Processing left to right**: Carry goes wrong direction
2. ❌ **Forgetting final carry**: Missing leading 1
3. ❌ **Not handling different lengths**: Index out of bounds
4. ❌ **Wrong carry calculation**: Using % 10 instead of % 2
5. ❌ **Not reversing result**: Building backwards but not reversing

---

## Implementation Details

### Why Use List for Result?
```python
# GOOD: Use list
result = []
result.append('0')
result.append('1')
return ''.join(reversed(result))

# BAD: String concatenation
result = ""
result = '0' + result  # O(n) operation!
result = '1' + result  # O(n) operation!

String concatenation in loop: O(n²)
List append + join: O(n)
```

### Why Reverse at End?
```
Build result right to left:
- Process digits right to left
- Append to list (efficient)
- Result is backwards

Example:
Processing "11" + "1":
result = ['0', '0', '1']  (backwards)
Reverse: ['1', '0', '0']
Join: "100" ✓

Alternative: Insert at beginning
result.insert(0, digit)  # O(n) per insert!
Total: O(n²)
```

### Handling Carry After Loop
```python
while i >= 0 or j >= 0 or carry:
    # Process digits and carry
    ...

# Why "or carry" in condition?
# Example: "111" + "1"
# After processing all digits, carry = 1
# Need one more iteration to add carry!

Without "or carry":
Result: "000" (wrong!)

With "or carry":
Result: "1000" (correct!)
```

---

## Step-by-Step Trace

### Example: "1010" + "1011"
```
Initial:
a = "1010", b = "1011"
i = 3, j = 3
carry = 0
result = []

Iteration 1:
i=3, j=3, carry=0
a[3]='0', b[3]='1'
total = 0 + 1 + 0 = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1']
i=2, j=2

Iteration 2:
i=2, j=2, carry=0
a[2]='1', b[2]='1'
total = 1 + 1 + 0 = 2
digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['1', '0']
i=1, j=1

Iteration 3:
i=1, j=1, carry=1
a[1]='0', b[1]='0'
total = 0 + 0 + 1 = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1', '0', '1']
i=0, j=0

Iteration 4:
i=0, j=0, carry=0
a[0]='1', b[0]='1'
total = 1 + 1 + 0 = 2
digit = 2 % 2 = 0
carry = 2 // 2 = 1
result = ['1', '0', '1', '0']
i=-1, j=-1

Iteration 5:
i=-1, j=-1, carry=1
total = 1
digit = 1 % 2 = 1
carry = 1 // 2 = 0
result = ['1', '0', '1', '0', '1']

Reverse:
result = ['1', '0', '1', '0', '1']
return "10101"
```

---

## Binary Number System Review

### Powers of 2
```
Position: 7  6  5  4  3  2  1  0
Power:    128 64 32 16 8  4  2  1

Example: 10101
= 1×16 + 0×8 + 1×4 + 0×2 + 1×1
= 16 + 4 + 1
= 21
```

### Binary to Decimal
```
"1010" → 1×8 + 0×4 + 1×2 + 0×1 = 10
"1011" → 1×8 + 0×4 + 1×2 + 1×1 = 11
"10101" → 1×16 + 0×8 + 1×4 + 0×2 + 1×1 = 21
```

### Decimal to Binary
```
21 ÷ 2 = 10 remainder 1
10 ÷ 2 = 5 remainder 0
5 ÷ 2 = 2 remainder 1
2 ÷ 2 = 1 remainder 0
1 ÷ 2 = 0 remainder 1

Read remainders bottom to top: 10101
```

---

## Complete Implementation

```python
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        """
        Add two binary strings.
        
        Approach: Digit-by-digit addition with carry
        Time: O(max(n, m))
        Space: O(max(n, m))
        """
        result = []
        carry = 0
        i, j = len(a) - 1, len(b) - 1
        
        # Process while digits remain or carry exists
        while i >= 0 or j >= 0 or carry:
            total = carry
            
            # Add digit from a if available
            if i >= 0:
                total += int(a[i])
                i -= 1
            
            # Add digit from b if available
            if j >= 0:
                total += int(b[j])
                j -= 1
            
            # Append result digit and calculate carry
            result.append(str(total % 2))
            carry = total // 2
        
        # Reverse and join
        return ''.join(reversed(result))
```

### Alternative: Convert to Int
```python
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        """
        Add two binary strings using int conversion.
        
        Time: O(n + m)
        Space: O(max(n, m))
        """
        return bin(int(a, 2) + int(b, 2))[2:]
```

---

## Day 36 Summary

### Key Concepts
1. **Binary Addition**: Base-2 arithmetic with carry
2. **Right-to-Left Processing**: Like decimal addition
3. **Carry Logic**: sum % 2 for digit, sum // 2 for carry
4. **String Building**: Use list + reverse for efficiency

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Add Binary | Digit-by-Digit | Carry propagation | O(n) |
| Add Strings | Digit-by-Digit | Same logic, base 10 | O(n) |
| Multiply Strings | Digit-by-Digit | Nested loops | O(n×m) |

### Binary Addition Rules

| Input | Output | Carry |
|-------|--------|-------|
| 0 + 0 + 0 | 0 | 0 |
| 0 + 0 + 1 | 1 | 0 |
| 0 + 1 + 0 | 1 | 0 |
| 0 + 1 + 1 | 0 | 1 |
| 1 + 0 + 0 | 1 | 0 |
| 1 + 0 + 1 | 0 | 1 |
| 1 + 1 + 0 | 0 | 1 |
| 1 + 1 + 1 | 1 | 1 |

### Critical Insights
1. **Carry at 2**: Binary carry happens at 2, not 10
2. **Modulo for Digit**: total % 2 gives result digit
3. **Division for Carry**: total // 2 gives new carry
4. **Loop Condition**: Continue while digits OR carry exists
5. **Reverse Result**: Build backwards, reverse at end

### When to Use This Pattern
- Binary arithmetic
- String number addition
- Bit manipulation problems
- Understanding computer arithmetic
- Low-level programming

### Master Checklist
- [ ] Understand binary number system
- [ ] Can perform binary addition manually
- [ ] Know carry logic: % 2 and // 2
- [ ] Can handle different length strings
- [ ] Understand right-to-left processing
- [ ] Know why to use list + reverse
- [ ] Can implement both approaches
- [ ] Understand when carry propagates

### Related Problems
- Add Strings (decimal version)
- Add Two Numbers (linked list)
- Multiply Strings
- Plus One
- Add to Array-Form of Integer
- Binary Number with Alternating Bits
- Number of 1 Bits
