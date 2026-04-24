# Day 58: Add Strings

## Problem Statement
**LeetCode 415: Add Strings**

Given two non-negative integers, num1 and num2 represented as strings, return the sum of num1 and num2 as a string.

**Important Constraints:**
- You must solve the problem **without using any built-in library** for handling large integers (such as BigInteger)
- You must also **not convert the inputs to integers directly**

**Examples:**
```
Input: num1 = "11", num2 = "123"
Output: "134"

Input: num1 = "456", num2 = "77"
Output: "533"

Input: num1 = "0", num2 = "0"
Output: "0"
```

**Constraints:**
- 1 <= num1.length, num2.length <= 10⁴
- num1 and num2 consist of only digits
- num1 and num2 don't have any leading zeros except for the zero itself

---

## Problem Logic & Reasoning

### Core Concept
Simulate **elementary school addition** - add digits from right to left, handling carries.

**Key Insight:** This is how you would add numbers on paper, digit by digit!

### Visual Understanding - Elementary School Addition

```
Example: "456" + "77"

Step 1: Align numbers from right
    4 5 6
  +   7 7
  -------

Step 2: Add from right to left with carry

Position 0 (rightmost):
    4 5 6
  +   7 7
  -------
        3  (6 + 7 = 13, write 3, carry 1)
    carry: 1

Position 1:
    4 5 6
  +   7 7
  -------
      3 3  (5 + 7 + 1 = 13, write 3, carry 1)
    carry: 1

Position 2:
    4 5 6
  +   7 7
  -------
    5 3 3  (4 + 0 + 1 = 5, write 5, carry 0)
    carry: 0

Result: "533"
```

### Breaking Down the Addition Process

```
"123" + "456"

Step-by-step:
i=2, j=2: 3 + 6 = 9, carry = 0 → digit = 9
i=1, j=1: 2 + 5 + 0 = 7, carry = 0 → digit = 7
i=0, j=0: 1 + 4 + 0 = 5, carry = 0 → digit = 5

Result: [9, 7, 5] → reverse → "579"
```

### The Carry Mechanism

```
Example: "99" + "1"

Position 0: 9 + 1 = 10
  digit = 0, carry = 1

Position 1: 9 + 0 + 1 = 10
  digit = 0, carry = 1

Position 2: 0 + 0 + 1 = 1
  digit = 1, carry = 0

Result: "100"

Key: Carry propagates left!
```

### Why We Can't Use int()

```
Problem constraint: Numbers can be up to 10,000 digits!

Example:
num1 = "99999999999999999999999999999999..." (10,000 digits)
num2 = "11111111111111111111111111111111..." (10,000 digits)

int(num1) would overflow in most languages!
Python can handle it, but problem forbids it.

Solution: Process digit by digit, like on paper.
```

---

## Approach: Elementary School Addition ⭐⭐⭐⭐⭐

### Logic
Simulate manual addition from right to left:
1. Start from the rightmost digits (least significant)
2. Add corresponding digits plus any carry
3. Store the result digit and update carry
4. Move to the next digits (going left)
5. Continue until all digits processed and no carry remains
6. Reverse the result (we built it backwards)

### Visual Flow for "456" + "77"

```
Initial state:
num1 = "456"  (i starts at index 2)
num2 = "77"   (j starts at index 1)
result = []
carry = 0

Step 1: i=2, j=1
  digit1 = num1[2] = '6' → 6
  digit2 = num2[1] = '7' → 7
  sum = 6 + 7 + 0 = 13
  carry = 13 // 10 = 1
  digit = 13 % 10 = 3
  result = ['3']
  i=1, j=0

Step 2: i=1, j=0
  digit1 = num1[1] = '5' → 5
  digit2 = num2[0] = '7' → 7
  sum = 5 + 7 + 1 = 13
  carry = 13 // 10 = 1
  digit = 13 % 10 = 3
  result = ['3', '3']
  i=0, j=-1

Step 3: i=0, j=-1
  digit1 = num1[0] = '4' → 4
  digit2 = 0 (j < 0, no more digits)
  sum = 4 + 0 + 1 = 5
  carry = 5 // 10 = 0
  digit = 5 % 10 = 5
  result = ['3', '3', '5']
  i=-1, j=-2

Step 4: i=-1, j=-2, carry=0
  All done!

Reverse result: ['5', '3', '3']
Join: "533"
```

### Detailed Step-by-Step for "999" + "1"

```
num1 = "999", num2 = "1"
i = 2, j = 0, carry = 0, result = []

Iteration 1:
  i=2, j=0
  a = int(num1[2]) = 9
  b = int(num2[0]) = 1
  sum = 9 + 1 + 0 = 10
  carry, digit = divmod(10, 10) = (1, 0)
  result = ['0']
  i=1, j=-1

Iteration 2:
  i=1, j=-1
  a = int(num1[1]) = 9
  b = 0 (j < 0)
  sum = 9 + 0 + 1 = 10
  carry, digit = divmod(10, 10) = (1, 0)
  result = ['0', '0']
  i=0, j=-2

Iteration 3:
  i=0, j=-2
  a = int(num1[0]) = 9
  b = 0 (j < 0)
  sum = 9 + 0 + 1 = 10
  carry, digit = divmod(10, 10) = (1, 0)
  result = ['0', '0', '0']
  i=-1, j=-3

Iteration 4:
  i=-1, j=-3, carry=1
  a = 0 (i < 0)
  b = 0 (j < 0)
  sum = 0 + 0 + 1 = 1
  carry, digit = divmod(1, 10) = (0, 1)
  result = ['0', '0', '0', '1']
  i=-2, j=-4

Exit loop (i < 0, j < 0, carry = 0)

Reverse: ['1', '0', '0', '0']
Join: "1000"
```

### The divmod() Function

```python
divmod(a, b) returns (a // b, a % b)

Examples:
divmod(13, 10) = (1, 3)  # carry=1, digit=3
divmod(7, 10) = (0, 7)   # carry=0, digit=7
divmod(10, 10) = (1, 0)  # carry=1, digit=0

Why use divmod?
- Gets both quotient (carry) and remainder (digit) in one operation
- More efficient than separate // and % operations
- Cleaner code
```

### Handling Different Lengths

```
Example: "12345" + "67"

    1 2 3 4 5
  +       6 7
  -----------

Position 0: 5 + 7 = 12 → digit=2, carry=1
Position 1: 4 + 6 + 1 = 11 → digit=1, carry=1
Position 2: 3 + 0 + 1 = 4 → digit=4, carry=0
Position 3: 2 + 0 + 0 = 2 → digit=2, carry=0
Position 4: 1 + 0 + 0 = 1 → digit=1, carry=0

Result: "12412"

Key: When one number runs out, use 0 for its digits
```

### Pseudocode
```
function addStrings(num1, num2):
    i = len(num1) - 1  // Start from rightmost
    j = len(num2) - 1
    result = []
    carry = 0
    
    while i >= 0 or j >= 0 or carry > 0:
        // Get digits (or 0 if exhausted)
        digit1 = int(num1[i]) if i >= 0 else 0
        digit2 = int(num2[j]) if j >= 0 else 0
        
        // Add with carry
        total = digit1 + digit2 + carry
        carry = total // 10
        digit = total % 10
        
        // Store digit
        result.append(str(digit))
        
        // Move left
        i -= 1
        j -= 1
    
    // Reverse and join
    return "".join(result[::-1])
```

### Implementation
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        # Initialize pointers to rightmost digits
        i, j = len(num1) - 1, len(num2) - 1
        
        # List to store result digits
        ans = []
        
        # Carry variable
        c = 0
        
        # Continue while digits remain or carry exists
        while i >= 0 or j >= 0 or c:
            # Get digit or 0 if exhausted
            a = 0 if i < 0 else int(num1[i])
            b = 0 if j < 0 else int(num2[j])
            
            # Add with carry, divmod returns (carry, digit)
            c, v = divmod(a + b + c, 10)
            
            # Append digit to result
            ans.append(str(v))
            
            # Move to next digits
            i, j = i - 1, j - 1
        
        # Reverse and join
        return "".join(ans[::-1])
```

### Alternative Implementation (More Explicit)
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        i = len(num1) - 1
        j = len(num2) - 1
        carry = 0
        result = []
        
        while i >= 0 or j >= 0 or carry:
            # Get current digits
            digit1 = int(num1[i]) if i >= 0 else 0
            digit2 = int(num2[j]) if j >= 0 else 0
            
            # Calculate sum
            total = digit1 + digit2 + carry
            
            # Extract carry and digit
            carry = total // 10
            digit = total % 10
            
            # Add to result
            result.append(str(digit))
            
            # Move pointers
            i -= 1
            j -= 1
        
        # Reverse and return
        return "".join(reversed(result))
```

### Complexity Analysis
- **Time:** O(max(m, n)) - Process each digit once, where m = len(num1), n = len(num2)
- **Space:** O(max(m, n)) - Result array stores at most max(m,n)+1 digits

---

## Critical Insights

### 1. Why Process Right to Left?

```
Addition works from least significant to most significant digit:

  1 2 3
+   4 5
-------

We can't compute the leftmost digit first because:
- We don't know if there's a carry from the right
- Carry propagates from right to left

Example:
  9 9
+  1
----

If we start from left:
  9 + 0 = 9? Wrong! Should be 10 (with carry from right)

Correct (right to left):
  9 + 1 = 10 → digit=0, carry=1
  9 + 0 + 1 = 10 → digit=0, carry=1
  0 + 0 + 1 = 1 → digit=1
  Result: 100 ✓
```

### 2. Why Build Result Backwards?

```
We process digits right to left:
"456" + "77"

Step 1: 6 + 7 = 13 → append '3'
Step 2: 5 + 7 + 1 = 13 → append '3'
Step 3: 4 + 0 + 1 = 5 → append '5'

result = ['3', '3', '5']

But we want "533", not "335"!

Solution: Reverse at the end
result[::-1] = ['5', '3', '3']
"".join() = "533" ✓

Alternative: Could prepend each digit, but that's O(n) per operation
Appending + reversing is more efficient
```

### 3. The Loop Condition

```python
while i >= 0 or j >= 0 or c:
```

**Why three conditions?**

```
Condition 1: i >= 0
  Still have digits in num1

Condition 2: j >= 0
  Still have digits in num2

Condition 3: c > 0
  Still have carry to process

Example showing why we need all three:

"99" + "1"
i=1, j=0: 9+1=10, carry=1
i=0, j=-1: 9+0+1=10, carry=1
i=-1, j=-2, carry=1: Need one more iteration!
  0+0+1=1, carry=0
  
Without "or c", we'd get "00" instead of "100"!
```

### 4. Handling Zero Digits

```python
a = 0 if i < 0 else int(num1[i])
b = 0 if j < 0 else int(num2[j])
```

**Why use 0 for exhausted digits?**

```
Example: "123" + "45"

    1 2 3
  +   4 5
  -------

Position 0: 3 + 5 = 8
Position 1: 2 + 4 = 6
Position 2: 1 + ? (num2 exhausted)

We treat missing digit as 0:
Position 2: 1 + 0 = 1

This is mathematically correct:
  123 + 45 = 123 + 045 = 168
```

### 5. Why divmod() is Perfect

```python
c, v = divmod(a + b + c, 10)
```

**Elegant one-liner for:**
```python
# Instead of:
total = a + b + c
c = total // 10  # New carry
v = total % 10   # Digit to store

# We do:
c, v = divmod(a + b + c, 10)
```

**Benefits:**
- Single operation (more efficient)
- Cleaner code
- Less chance of error
- Pythonic

---

## Common Mistakes

### ❌ Mistake 1: Converting to Integer

```python
# Wrong: Violates problem constraint
def addStrings(num1, num2):
    return str(int(num1) + int(num2))

# Problems:
# 1. Violates "don't convert to integer" rule
# 2. Fails for very large numbers (overflow in some languages)
# 3. Defeats the purpose of the problem
```

### ❌ Mistake 2: Wrong Loop Condition

```python
# Wrong: Stops too early
while i >= 0 and j >= 0:
    # ...

# Problem: Stops when one number exhausted
# Example: "123" + "45"
# Would only process "23" + "45", missing the '1'

# Correct: Use OR
while i >= 0 or j >= 0 or carry:
```

### ❌ Mistake 3: Forgetting to Check Carry

```python
# Wrong: Doesn't check carry in loop condition
while i >= 0 or j >= 0:
    # ...

# Problem: "99" + "1" = "00" instead of "100"
# Last carry is lost!

# Correct: Include carry
while i >= 0 or j >= 0 or carry:
```

### ❌ Mistake 4: Not Reversing Result

```python
# Wrong: Returns backwards result
def addStrings(num1, num2):
    # ... build result ...
    return "".join(ans)  # Missing [::-1]

# Example: "11" + "22"
# Returns "33" (correct by luck)
# But "12" + "34" returns "64" instead of "46"

# Correct: Reverse
return "".join(ans[::-1])
```

### ❌ Mistake 5: Index Out of Bounds

```python
# Wrong: Doesn't check if index is valid
while i >= 0 or j >= 0:
    a = int(num1[i])  # Error if i < 0!
    b = int(num2[j])  # Error if j < 0!

# Correct: Check before accessing
a = 0 if i < 0 else int(num1[i])
b = 0 if j < 0 else int(num2[j])
```

### ❌ Mistake 6: Wrong Carry Calculation

```python
# Wrong: Carry is boolean instead of value
carry = 1 if total >= 10 else 0

# Problem: Works for single digit carry
# But what if we're adding in base 16 or other bases?

# Correct: Use integer division
carry = total // 10
```

### ❌ Mistake 7: Starting from Left

```python
# Wrong: Processing from left to right
i, j = 0, 0
while i < len(num1) or j < len(num2):
    # ...

# Problem: Can't handle carry properly
# Carry propagates right to left!

# Correct: Start from right
i, j = len(num1) - 1, len(num2) - 1
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `"0", "0"` | `"0"` | Both zero |
| `"1", "9"` | `"10"` | Carry creates extra digit |
| `"99", "1"` | `"100"` | Multiple carries |
| `"999", "1"` | `"1000"` | Carry propagates through all digits |
| `"123", "0"` | `"123"` | Adding zero |
| `"1", "999"` | `"1000"` | Different lengths |
| `"9999999999", "1"` | `"10000000000"` | Large numbers |

---

## Visualization: Carry Propagation

```
Example: "9999" + "1"

Step 1: Position 0
  9 + 1 = 10
  digit = 0, carry = 1
  result = ['0']

Step 2: Position 1
  9 + 0 + 1 = 10
  digit = 0, carry = 1
  result = ['0', '0']

Step 3: Position 2
  9 + 0 + 1 = 10
  digit = 0, carry = 1
  result = ['0', '0', '0']

Step 4: Position 3
  9 + 0 + 1 = 10
  digit = 0, carry = 1
  result = ['0', '0', '0', '0']

Step 5: No more digits, but carry = 1
  0 + 0 + 1 = 1
  digit = 1, carry = 0
  result = ['0', '0', '0', '0', '1']

Reverse: "10000"

Carry cascaded through all digits!
```

---

## Pattern Recognition

### This Pattern Applies To:

1. **Add Binary (LeetCode 67)** - Same logic, base 2
```python
# Same algorithm, but divmod(sum, 2)
# '0' + '1' = '1'
# '1' + '1' = '10' (carry in binary)
```

2. **Multiply Strings (LeetCode 43)** - Extension of addition
```python
# Multiply digit by digit
# Add partial results (using string addition)
```

3. **Plus One (LeetCode 66)** - Special case of addition
```python
# Add 1 to number represented as array
# Same carry logic
```

4. **Add Two Numbers (LeetCode 2)** - Linked list version
```python
# Same logic but with linked list nodes
# Process from left to right (already reversed)
```

### Key Characteristics:
- Digit-by-digit processing
- Carry handling
- Right-to-left processing
- String/array manipulation
- Simulating manual arithmetic

---

## Bonus: Subtract Strings

### Logic for Subtraction
Similar to addition, but with borrowing instead of carrying:
1. Ensure num1 >= num2 (swap if needed, track sign)
2. Process right to left
3. If digit1 < digit2, borrow from next position
4. Remove leading zeros
5. Add negative sign if needed

### Visual Flow for "533" - "456"

```
    5 3 3
  - 4 5 6
  -------

Position 0: 3 - 6 = -3
  Need to borrow: 3 + 10 - 6 = 7
  borrow = 1
  result = ['7']

Position 1: 3 - 5 - 1 = -3
  Need to borrow: 3 + 10 - 5 - 1 = 7
  borrow = 1
  result = ['7', '7']

Position 2: 5 - 4 - 1 = 0
  borrow = 0
  result = ['7', '7', '0']

Remove leading zeros: ['7', '7']
Reverse: "77"
```

### Implementation
```python
class Solution:
    def subStrings(self, num1: str, num2: str) -> str:
        # Check if result will be negative
        m, n = len(num1), len(num2)
        neg = m < n or (m == n and num1 < num2)
        
        # Swap to ensure num1 >= num2
        if neg:
            num1, num2 = num2, num1
        
        # Initialize pointers
        i, j = len(num1) - 1, len(num2) - 1
        ans = []
        borrow = 0
        
        # Process all digits
        while i >= 0:
            # Calculate difference
            diff = int(num1[i]) - borrow - (0 if j < 0 else int(num2[j]))
            
            # Handle borrowing
            ans.append(str((diff + 10) % 10))
            borrow = 1 if diff < 0 else 0
            
            # Move to next digits
            i, j = i - 1, j - 1
        
        # Remove leading zeros
        while len(ans) > 1 and ans[-1] == '0':
            ans.pop()
        
        # Add negative sign if needed
        if neg:
            ans.append('-')
        
        return ''.join(ans[::-1])
```

### Example: "1000" - "1"

```
    1 0 0 0
  -       1
  ---------

Position 0: 0 - 1 = -1
  Borrow: 0 + 10 - 1 = 9
  borrow = 1
  result = ['9']

Position 1: 0 - 0 - 1 = -1
  Borrow: 0 + 10 - 0 - 1 = 9
  borrow = 1
  result = ['9', '9']

Position 2: 0 - 0 - 1 = -1
  Borrow: 0 + 10 - 0 - 1 = 9
  borrow = 1
  result = ['9', '9', '9']

Position 3: 1 - 0 - 1 = 0
  borrow = 0
  result = ['9', '9', '9', '0']

Remove leading zero: ['9', '9', '9']
Reverse: "999"
```

---

## Complete Implementations

### Implementation 1: Using divmod() ⭐
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        i, j = len(num1) - 1, len(num2) - 1
        ans = []
        c = 0
        
        while i >= 0 or j >= 0 or c:
            a = 0 if i < 0 else int(num1[i])
            b = 0 if j < 0 else int(num2[j])
            c, v = divmod(a + b + c, 10)
            ans.append(str(v))
            i, j = i - 1, j - 1
        
        return "".join(ans[::-1])
```

### Implementation 2: Explicit Carry/Digit
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        i = len(num1) - 1
        j = len(num2) - 1
        carry = 0
        result = []
        
        while i >= 0 or j >= 0 or carry:
            digit1 = int(num1[i]) if i >= 0 else 0
            digit2 = int(num2[j]) if j >= 0 else 0
            
            total = digit1 + digit2 + carry
            carry = total // 10
            digit = total % 10
            
            result.append(str(digit))
            i -= 1
            j -= 1
        
        return "".join(reversed(result))
```

### Implementation 3: Using List Comprehension
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        # Pad shorter string with zeros
        max_len = max(len(num1), len(num2))
        num1 = num1.zfill(max_len)
        num2 = num2.zfill(max_len)
        
        result = []
        carry = 0
        
        for i in range(max_len - 1, -1, -1):
            total = int(num1[i]) + int(num2[i]) + carry
            carry = total // 10
            result.append(str(total % 10))
        
        if carry:
            result.append(str(carry))
        
        return "".join(reversed(result))
```

### Implementation 4: Recursive (Not Recommended)
```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        def helper(i, j, carry):
            if i < 0 and j < 0 and carry == 0:
                return ""
            
            a = int(num1[i]) if i >= 0 else 0
            b = int(num2[j]) if j >= 0 else 0
            
            total = a + b + carry
            digit = total % 10
            new_carry = total // 10
            
            return helper(i - 1, j - 1, new_carry) + str(digit)
        
        return helper(len(num1) - 1, len(num2) - 1, 0)
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Add Binary (LC 67)** | Same pattern | Base 2 instead of 10 |
| **Multiply Strings (LC 43)** | String arithmetic | Multiplication logic |
| **Plus One (LC 66)** | Carry handling | Array instead of string |
| **Add Two Numbers (LC 2)** | Digit addition | Linked list structure |
| **Add Two Numbers II (LC 445)** | Digit addition | Reverse order |

---

## Day 58 Summary

### Problems Solved: 1 (+ Bonus)
1. ✅ Add Strings
2. ✅ Subtract Strings (Bonus)

### Key Patterns Learned:
1. **Elementary School Addition** - Digit-by-digit processing
2. **Carry Handling** - Propagating carry left
3. **Right-to-Left Processing** - Starting from least significant digit
4. **String Manipulation** - Building result backwards

### Techniques Mastered:
- Two-pointer technique (from right)
- Carry propagation
- Handling different lengths
- String reversal
- divmod() for efficiency

### Complexity Insights:
- Time: O(max(m, n)) - Process each digit once
- Space: O(max(m, n)) - Store result digits
- Optimal for this problem

### When to Use This Pattern:
- String arithmetic problems
- Digit-by-digit processing
- Carry/borrow handling
- Large number operations
- Base conversion problems

---

## Quick Reference

### Add Strings Template
```python
def addStrings(num1, num2):
    i, j = len(num1) - 1, len(num2) - 1
    result = []
    carry = 0
    
    while i >= 0 or j >= 0 or carry:
        digit1 = int(num1[i]) if i >= 0 else 0
        digit2 = int(num2[j]) if j >= 0 else 0
        
        total = digit1 + digit2 + carry
        carry = total // 10
        digit = total % 10
        
        result.append(str(digit))
        i -= 1
        j -= 1
    
    return "".join(reversed(result))
```

### Key Formulas
```
Addition:
  total = digit1 + digit2 + carry
  carry = total // 10
  digit = total % 10

Or using divmod:
  carry, digit = divmod(digit1 + digit2 + carry, 10)

Subtraction:
  diff = digit1 - digit2 - borrow
  digit = (diff + 10) % 10
  borrow = 1 if diff < 0 else 0
```

### Common Patterns
```python
# Two pointers from right
i, j = len(num1) - 1, len(num2) - 1

# Handle exhausted digits
digit = int(num[i]) if i >= 0 else 0

# Loop condition (all three!)
while i >= 0 or j >= 0 or carry:

# Build backwards, then reverse
result.append(digit)
return "".join(reversed(result))
```

---

## Interview Tips

**If asked about Add Strings:**

1. **Clarify constraints**
   - "Can I use int()?" → No
   - "How large can numbers be?" → Up to 10,000 digits
   - "Any leading zeros?" → No (except "0" itself)

2. **Explain approach**
   - "I'll simulate elementary school addition"
   - "Process digits right to left"
   - "Handle carry at each step"

3. **Walk through example**
   ```
   "456" + "77"
   6+7=13 → digit=3, carry=1
   5+7+1=13 → digit=3, carry=1
   4+0+1=5 → digit=5, carry=0
   Result: "533"
   ```

4. **Code it up**
   - Start with clear variable names
   - Handle edge cases (carry, different lengths)
   - Don't forget to reverse!

5. **Test edge cases**
   - "0" + "0" = "0"
   - "99" + "1" = "100"
   - "123" + "456" = "579"

6. **Mention extensions**
   - "Same logic works for Add Binary"
   - "Can extend to Multiply Strings"
   - "Similar to linked list addition"

**Time to explain:** 5-7 minutes

---

## Key Takeaways

1. **Simulate manual arithmetic** - Think like you're doing it on paper
2. **Right-to-left processing** - Carry propagates this direction
3. **Handle different lengths** - Use 0 for exhausted digits
4. **Don't forget carry** - Check in loop condition
5. **Build backwards** - Append then reverse (efficient)
6. **divmod() is elegant** - Gets carry and digit in one operation
7. **Test carry propagation** - "999" + "1" = "1000"

---

**End of Day 58 Notes**

*Master string addition and you've mastered digit-by-digit processing!* 🎯
