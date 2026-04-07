# Day 43: String to Integer (atoi)

## Problem Statement
**LeetCode 8: String to Integer (atoi)**

Implement the myAtoi(string s) function, which converts a string to a 32-bit signed integer.

**Algorithm Steps:**
1. **Whitespace**: Ignore any leading whitespace (" ")
2. **Signedness**: Determine the sign by checking if the next character is '-' or '+', assuming positivity if neither present
3. **Conversion**: Read the integer by skipping leading zeros until a non-digit character is encountered or the end of the string is reached. If no digits were read, then the result is 0
4. **Rounding**: If the integer is out of the 32-bit signed integer range [-2³¹, 2³¹ - 1], then clamp the integer to remain in the range

**Examples:**
```
Input: s = "42"
Output: 42

Input: s = "   -042"
Output: -42
Explanation: Leading whitespace ignored, '-' indicates negative, leading zeros ignored

Input: s = "1337c0d3"
Output: 1337
Explanation: Reading stops at 'c' (non-digit)

Input: s = "0-1"
Output: 0
Explanation: Reading stops at '-' after '0'

Input: s = "words and 987"
Output: 0
Explanation: First character 'w' is non-digit

Input: s = "-91283472332"
Output: -2147483648
Explanation: Clamped to -2³¹
```

**Constraints:**
- 0 <= s.length <= 200
- s consists of English letters (lower-case and upper-case), digits (0-9), ' ', '+', '-', and '.'
- 32-bit signed integer range: [-2³¹, 2³¹ - 1] = [-2147483648, 2147483647]

---

## Problem Logic & Reasoning

### Core Concept
This is a **string parsing** problem with multiple edge cases. We need to carefully handle:
1. Leading whitespace
2. Optional sign
3. Digit extraction
4. Overflow/underflow

**Key Insight:** Process the string character by character in a specific order, stopping at the first invalid character.

### Visual Understanding for "   -042"

```
Step 1: Skip whitespace
"   -042"
 ^^^
Skip these

Step 2: Check sign
"   -042"
    ^
Found '-', sign = -1

Step 3: Read digits
"   -042"
     ^^^
Read "042" → 42

Step 4: Apply sign
42 × (-1) = -42

Result: -42
```

### The 32-bit Integer Range
```
Maximum positive: 2³¹ - 1 = 2,147,483,647
Maximum negative: -2³¹   = -2,147,483,648

Why asymmetric?
In two's complement representation:
- Positive: 0 to 2³¹-1
- Negative: -2³¹ to -1
- Total: 2³² values (including 0)
```

---

## Approach 1: Basic Parsing with Post-Clamping ⭐

### Logic
1. Skip leading whitespace
2. Check for optional sign ('+' or '-')
3. Read digits and build number
4. Apply sign
5. Clamp to 32-bit range

### Visual Flow for "1337c0d3"

```
Initial: i=0, result=0, sign=1

Step 1: Skip whitespace
    No whitespace, i=0

Step 2: Check sign
    s[0]='1' (not '+' or '-'), i=0, sign=1

Step 3: Read digits
    i=0: s[0]='1' → result = 0×10 + 1 = 1
    i=1: s[1]='3' → result = 1×10 + 3 = 13
    i=2: s[2]='3' → result = 13×10 + 3 = 133
    i=3: s[3]='7' → result = 133×10 + 7 = 1337
    i=4: s[4]='c' → NOT digit, stop

Step 4: Apply sign
    result = 1337 × 1 = 1337

Step 5: Check range
    -2³¹ ≤ 1337 ≤ 2³¹-1 ✓

Result: 1337
```

### Step-by-Step Execution for "   -042"

```
s = "   -042"
i = 0, result = 0, sign = 1

Phase 1: Skip whitespace
    while s[i] == ' ':
        i=0: s[0]=' ' → i=1
        i=1: s[1]=' ' → i=2
        i=2: s[2]=' ' → i=3
        i=3: s[3]='-' → exit loop
    i = 3

Phase 2: Check sign
    s[3] = '-' → sign = -1, i = 4

Phase 3: Read digits
    i=4: s[4]='0' → result = 0×10 + 0 = 0
    i=5: s[5]='4' → result = 0×10 + 4 = 4
    i=6: s[6]='2' → result = 4×10 + 2 = 42
    i=7: out of bounds, stop

Phase 4: Apply sign
    result = 42 × (-1) = -42

Phase 5: Check range
    -2³¹ ≤ -42 ≤ 2³¹-1 ✓

Result: -42
```

### Pseudocode
```
function myAtoi(s):
    i = 0
    result = 0
    sign = 1
    n = len(s)
    
    // Step 1: Skip whitespace
    while i < n and s[i] == ' ':
        i += 1
    
    // Step 2: Check sign
    if i < n and (s[i] == '+' or s[i] == '-'):
        if s[i] == '-':
            sign = -1
        i += 1
    
    // Step 3: Read digits
    while i < n and s[i].isdigit():
        result = result * 10 + int(s[i])
        i += 1
    
    // Step 4: Apply sign
    result *= sign
    
    // Step 5: Clamp to 32-bit range
    if result > 2^31 - 1:
        return 2^31 - 1
    if result < -2^31:
        return -2^31
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Single pass through string
- **Space:** O(1) - Only using constant variables

---

## Approach 2: Overflow Prevention (Early Detection) ⭐⭐

### Logic
Instead of building the full number and clamping later, detect overflow BEFORE it happens:
1. Calculate limit = 2³¹ // 10 = 214748364
2. Before adding each digit, check if result > limit
3. If result == limit, check if digit > 7 (for positive) or > 8 (for negative)

### Why This Prevents Overflow
```
Maximum positive: 2,147,483,647
Limit: 214,748,364 (max // 10)

If result > limit:
    Next multiplication will overflow
    Example: 214,748,365 × 10 = 2,147,483,650 > max

If result == limit:
    Check last digit
    214,748,364 × 10 + 8 = 2,147,483,648 > max ✗
    214,748,364 × 10 + 7 = 2,147,483,647 = max ✓
```

### Visual Flow for "-91283472332"

```
s = "-91283472332"
limit = 214748364
sign = -1

Reading digits:
i=1: digit=9, result=0
     0 < limit ✓ → result = 9

i=2: digit=1, result=9
     9 < limit ✓ → result = 91

i=3: digit=2, result=91
     91 < limit ✓ → result = 912

...continuing...

i=9: digit=3, result=214748364
     result == limit and digit=3 ≤ 7 ✓ → result = 2147483643

i=10: digit=3, result=2147483643
      result > limit ✗ → OVERFLOW!
      Return -2³¹ = -2147483648
```

### Overflow Detection Logic
```
For positive numbers:
    if result > limit:
        return 2³¹ - 1
    if result == limit and digit > 7:
        return 2³¹ - 1

For negative numbers:
    if result > limit:
        return -2³¹
    if result == limit and digit > 8:
        return -2³¹
```

### Pseudocode
```
function myAtoi(s):
    i = 0
    n = len(s)
    limit = 2^31 // 10  // 214748364
    
    // Skip whitespace
    while i < n and s[i] == ' ':
        i += 1
    
    if i == n:
        return 0
    
    // Check sign
    sign = 1
    if s[i] == '+':
        i += 1
    elif s[i] == '-':
        sign = -1
        i += 1
    
    result = 0
    
    // Read digits with overflow check
    while i < n and s[i].isdigit():
        digit = int(s[i])
        
        // Check overflow BEFORE adding
        if result > limit or (result == limit and digit > 7):
            return -2^31 if sign == -1 else 2^31 - 1
        
        result = result * 10 + digit
        i += 1
    
    return result * sign
```

### Complexity Analysis
- **Time:** O(n) - Single pass
- **Space:** O(1) - Constant space
- **Advantage:** Prevents integer overflow during computation

---

## Approach Comparison

| Aspect | Post-Clamping | Overflow Prevention |
|--------|---------------|---------------------|
| **Time Complexity** | O(n) | O(n) |
| **Space Complexity** | O(1) | O(1) |
| **Overflow Risk** | Yes (during build) | No (checked early) |
| **Code Simplicity** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Safety** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Best For** | Python (big int) | C/C++/Java |

---

## Critical Insights

### 1. Why Check i < n Everywhere?
```python
while i < n and s[i] == ' ':
```
Without `i < n`:
- After skipping whitespace, i might equal n
- Accessing s[i] would cause IndexError

### 2. Sign Must Be Checked AFTER Whitespace
```
Correct order:
1. Skip whitespace
2. Check sign
3. Read digits

Wrong: "   -42"
If we check sign before skipping whitespace:
    s[0] = ' ' (not '+' or '-')
    Miss the '-' sign!
```

### 3. Only ONE Sign Allowed
```
Input: "+-12"
After '+': i=1
s[1] = '-' (not a digit)
Stop reading, result = 0
```

### 4. Leading Zeros Are Ignored
```
"0042" → 42
"00000" → 0

This happens naturally:
0 × 10 + 0 = 0
0 × 10 + 0 = 0
0 × 10 + 4 = 4
4 × 10 + 2 = 42
```

### 5. Why 2³¹ - 1 vs -2³¹?
```
Positive max: 2,147,483,647 (2³¹ - 1)
Negative max: -2,147,483,648 (-2³¹)

Asymmetric because:
- 0 is counted as positive
- Two's complement representation
```

---

## Common Mistakes

### ❌ Mistake 1: Not Handling Empty String After Whitespace
```python
s = "    "
i = 4 (after skipping whitespace)
s[i]  # IndexError!
```
**Fix:** Check `if i == n: return 0`

### ❌ Mistake 2: Checking Sign Before Whitespace
```python
# Wrong order
if s[0] == '-':
    sign = -1
while s[i] == ' ':
    i += 1
```

### ❌ Mistake 3: Not Stopping at First Non-Digit
```python
# Wrong: continues after non-digit
for char in s:
    if char.isdigit():
        result = result * 10 + int(char)
```
**Impact:** "12a34" → 1234 (should be 12)

### ❌ Mistake 4: Applying Sign During Digit Reading
```python
# Wrong: sign applied too early
while s[i].isdigit():
    result = result * 10 + int(s[i]) * sign
```
**Impact:** Breaks overflow detection

### ❌ Mistake 5: Wrong Overflow Check
```python
# Wrong: checks after overflow
result = result * 10 + digit
if result > 2**31 - 1:
    return 2**31 - 1
```
**Problem:** result already overflowed!

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `""` | `0` | Empty string |
| `"   "` | `0` | Only whitespace |
| `"+"` | `0` | Sign only, no digits |
| `"-"` | `0` | Sign only, no digits |
| `"   +0   "` | `0` | Whitespace + sign + zero |
| `"00000"` | `0` | Leading zeros |
| `"+-12"` | `0` | Multiple signs |
| `"21474836460"` | `2147483647` | Overflow (clamped) |
| `"-91283472332"` | `-2147483648` | Underflow (clamped) |
| `"words and 987"` | `0` | Starts with non-digit |
| `"4193 with words"` | `4193` | Stops at space |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Valid Number** - More complex string parsing
2. **Roman to Integer** - String to number conversion
3. **Integer to Roman** - Number to string conversion
4. **Reverse Integer** - Integer manipulation with overflow

### Key Characteristics:
- String parsing with state machine
- Multiple validation steps
- Overflow/underflow handling
- Early termination on invalid input

---

## Complete Implementations

### Implementation 1: Basic Post-Clamping ⭐
```python
def myAtoi(s: str) -> int:
    i = 0
    result = 0
    n = len(s)
    sign = 1
    
    # Step 1: Skip whitespace
    while i < n and s[i] == ' ':
        i += 1
    
    # Step 2: Check sign
    if i < n and (s[i] == '-' or s[i] == '+'):
        if s[i] == '-':
            sign = -1
        i += 1
    
    # Step 3: Read digits
    while i < n and s[i].isdigit():
        result = result * 10 + int(s[i])
        i += 1
    
    # Step 4: Apply sign
    result *= sign
    
    # Step 5: Clamp to 32-bit range
    if result > 2**31 - 1:
        return 2**31 - 1
    if result < -2**31:
        return -2**31
    
    return result
```

### Implementation 2: Overflow Prevention ⭐⭐
```python
def myAtoi(s: str) -> int:
    if not s:
        return 0
    
    i = 0
    n = len(s)
    limit = 2**31 // 10
    
    # Skip whitespace
    while i < n and s[i] == ' ':
        i += 1
    
    if i == n:
        return 0
    
    # Check sign
    sign = 1
    if s[i] == '+':
        i += 1
    elif s[i] == '-':
        sign = -1
        i += 1
    
    result = 0
    
    # Read digits with overflow check
    while i < n and s[i].isdigit():
        digit = int(s[i])
        
        # Check overflow before adding
        if result > limit or (result == limit and digit > 7):
            return -2**31 if sign == -1 else 2**31 - 1
        
        result = result * 10 + digit
        i += 1
    
    return result * sign
```

### Implementation 3: Using Regular Expression
```python
import re

def myAtoi(s: str) -> int:
    # Match optional whitespace, optional sign, and digits
    match = re.match(r'^\s*([+-]?\d+)', s)
    
    if not match:
        return 0
    
    result = int(match.group(1))
    
    # Clamp to 32-bit range
    if result > 2**31 - 1:
        return 2**31 - 1
    if result < -2**31:
        return -2**31
    
    return result
```

### Implementation 4: State Machine Approach
```python
def myAtoi(s: str) -> int:
    state = 'start'
    sign = 1
    result = 0
    limit = 2**31 // 10
    
    for char in s:
        if state == 'start':
            if char == ' ':
                continue
            elif char in '+-':
                sign = -1 if char == '-' else 1
                state = 'sign'
            elif char.isdigit():
                result = int(char)
                state = 'number'
            else:
                break
        
        elif state == 'sign':
            if char.isdigit():
                result = int(char)
                state = 'number'
            else:
                break
        
        elif state == 'number':
            if char.isdigit():
                digit = int(char)
                if result > limit or (result == limit and digit > 7):
                    return -2**31 if sign == -1 else 2**31 - 1
                result = result * 10 + digit
            else:
                break
    
    return result * sign
```

---

## Optimization Techniques

### 1. Early Exit for Empty String
```python
if not s:
    return 0
```

### 2. Combine Whitespace and Sign Check
```python
s = s.lstrip()  # Remove leading whitespace
if not s:
    return 0
```

### 3. Use isnumeric() vs isdigit()
```python
# Both work, but isdigit() is more standard
s[i].isdigit()  # Preferred
s[i].isnumeric()  # Also works
```

### 4. Pre-calculate Constants
```python
INT_MAX = 2**31 - 1
INT_MIN = -2**31
LIMIT = 2**31 // 10
```

---

## Mathematical Deep Dive

### Why limit = 2³¹ // 10?
```
Maximum: 2,147,483,647
Limit:     214,748,364

If result > limit:
    result × 10 > 2,147,483,640
    Adding any digit (0-9) will overflow

If result == limit:
    result × 10 = 2,147,483,640
    Can add digits 0-7 safely
    Adding 8 or 9 causes overflow
```

### Two's Complement Representation
```
32-bit signed integer:
- 1 sign bit + 31 value bits
- Positive: 0 to 2³¹-1
- Negative: -2³¹ to -1

Why -2³¹ has no positive counterpart?
- Positive max: 01111111...1 = 2³¹-1
- Negative max: 10000000...0 = -2³¹
- The extra negative value is used for -2³¹
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Reverse Integer** | Overflow handling | Reverse digits |
| **Valid Number** | String parsing | More complex rules |
| **Roman to Integer** | String to int | Different symbols |
| **Integer to English Words** | Number conversion | Int to string |

---

## Day 43 Summary

### Problems Solved: 1
1. ✅ String to Integer (atoi)

### Key Patterns Learned:
1. **String Parsing State Machine** - Sequential validation steps
2. **Overflow Prevention** - Detecting overflow before it happens
3. **Edge Case Handling** - Multiple validation checks

### Techniques Mastered:
- Leading whitespace removal
- Sign detection and handling
- Digit extraction with early termination
- Overflow/underflow clamping
- Boundary condition checking

### Complexity Insights:
- O(n) time for single pass
- O(1) space for constant variables
- Overflow prevention is crucial in languages without big integers

### When to Use This Pattern:
- String to number conversion
- Input validation and parsing
- State machine problems
- Overflow-sensitive computations

---

## Quick Reference

### String Parsing Template
```python
def parse_string(s):
    i = 0
    n = len(s)
    
    # Phase 1: Skip whitespace
    while i < n and s[i] == ' ':
        i += 1
    
    # Phase 2: Check special characters
    if i < n and is_special(s[i]):
        handle_special(s[i])
        i += 1
    
    # Phase 3: Process main content
    while i < n and is_valid(s[i]):
        process(s[i])
        i += 1
    
    return result
```

### Overflow Detection Template
```python
limit = MAX_VALUE // 10

while processing:
    if result > limit:
        return MAX_VALUE
    if result == limit and digit > last_digit:
        return MAX_VALUE
    
    result = result * 10 + digit
```

### 32-bit Integer Constants
```python
INT_MAX = 2**31 - 1  # 2,147,483,647
INT_MIN = -2**31     # -2,147,483,648
LIMIT = 2**31 // 10  # 214,748,364
```
