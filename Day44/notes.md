# Day 44: Excel Sheet Column Title

## Problem Statement
**LeetCode 168: Excel Sheet Column Title**

Given an integer columnNumber, return its corresponding column title as it appears in an Excel sheet.

**Mapping:**
```
A → 1
B → 2
C → 3
...
Z → 26
AA → 27
AB → 28
...
AZ → 52
BA → 53
...
ZY → 701
ZZ → 702
AAA → 703
```

**Examples:**
```
Input: columnNumber = 1
Output: "A"

Input: columnNumber = 28
Output: "AB"

Input: columnNumber = 701
Output: "ZY"

Input: columnNumber = 52
Output: "AZ"
```

**Constraints:**
- 1 <= columnNumber <= 2³¹ - 1

---

## Problem Logic & Reasoning

### Core Concept
This looks like a **base-26 number system**, but with a crucial twist: **there's no zero!**

**Key Insight:** Excel columns use a 1-indexed base-26 system (A=1, not A=0). This requires subtracting 1 before each division to convert to 0-indexed.

### Why This Isn't Standard Base-26
```
Standard Base-26 (0-indexed):
0 → A
1 → B
...
25 → Z
26 → BA (1×26 + 0)

Excel (1-indexed):
1 → A
2 → B
...
26 → Z
27 → AA (not BA!)
```

### Visual Understanding for 28 → "AB"

```
Standard base conversion (WRONG):
28 % 26 = 2 → 'C'
28 // 26 = 1 → 'B'
Result: "BC" ❌

Correct approach (subtract 1 first):
28 - 1 = 27 (convert to 0-indexed)
27 % 26 = 1 → 'B'
27 // 26 = 1

1 - 1 = 0 (convert to 0-indexed)
0 % 26 = 0 → 'A'
0 // 26 = 0 (stop)

Result: "AB" ✓
```

### The Pattern
```
1-26:   A-Z (single letter)
27-52:  AA-AZ (A + A-Z)
53-78:  BA-BZ (B + A-Z)
...
701:    ZY (Z + Y)
702:    ZZ (Z + Z)
703:    AAA (start triple letters)
```

---

## Approach 1: Iterative Base-26 Conversion ⭐

### Logic
1. While columnNumber > 0:
   - Subtract 1 (convert to 0-indexed)
   - Get remainder: columnNumber % 26
   - Convert remainder to character: chr(ord('A') + remainder)
   - Prepend character to result
   - Divide by 26: columnNumber // 26

### Visual Flow for 701 → "ZY"

```
Initial: columnNumber = 701, result = ""

Iteration 1:
    columnNumber -= 1 → 700
    remainder = 700 % 26 = 24
    char = chr(ord('A') + 24) = chr(65 + 24) = chr(89) = 'Y'
    result = 'Y' + "" = "Y"
    columnNumber = 700 // 26 = 26

Iteration 2:
    columnNumber -= 1 → 25
    remainder = 25 % 26 = 25
    char = chr(ord('A') + 25) = chr(65 + 25) = chr(90) = 'Z'
    result = 'Z' + "Y" = "ZY"
    columnNumber = 25 // 26 = 0

Exit loop (columnNumber = 0)

Result: "ZY"
```

### Step-by-Step Execution for 28 → "AB"

```
columnNumber = 28, result = ""

Step 1:
    28 - 1 = 27
    27 % 26 = 1 → 'B'
    result = "B"
    27 // 26 = 1

Step 2:
    1 - 1 = 0
    0 % 26 = 0 → 'A'
    result = "AB"
    0 // 26 = 0

Result: "AB"
```

### Why Subtract 1 Each Time?

```
Without -1 (WRONG):
26 % 26 = 0 → 'A'
26 // 26 = 1
1 % 26 = 1 → 'B'
Result: "BA" ❌ (should be "Z")

With -1 (CORRECT):
26 - 1 = 25
25 % 26 = 25 → 'Z'
25 // 26 = 0
Result: "Z" ✓
```

### Pseudocode
```
function convertToTitle(columnNumber):
    result = ""
    
    while columnNumber > 0:
        columnNumber -= 1  // Convert to 0-indexed
        
        remainder = columnNumber % 26
        char = chr(ord('A') + remainder)
        result = char + result  // Prepend
        
        columnNumber = columnNumber // 26
    
    return result
```

### Complexity Analysis
- **Time:** O(log₂₆ n) - Number of digits in base-26
- **Space:** O(log₂₆ n) - Result string length

---

## Approach 2: Recursive Solution

### Logic
Recursively build the string from right to left:
1. Base case: columnNumber = 0, return ""
2. Recursive case: Convert current digit + recurse on remaining

### Visual Flow for 52 → "AZ"

```
convertToTitle(52)
    52 - 1 = 51
    51 % 26 = 25 → 'Z'
    51 // 26 = 1
    return convertToTitle(1) + 'Z'
        ↓
    convertToTitle(1)
        1 - 1 = 0
        0 % 26 = 0 → 'A'
        0 // 26 = 0
        return convertToTitle(0) + 'A'
            ↓
        convertToTitle(0)
            return ""
        
    Result: "" + 'A' + 'Z' = "AZ"
```

### Pseudocode
```
function convertToTitle(columnNumber):
    if columnNumber == 0:
        return ""
    
    columnNumber -= 1
    remainder = columnNumber % 26
    char = chr(ord('A') + remainder)
    
    return convertToTitle(columnNumber // 26) + char
```

### Complexity Analysis
- **Time:** O(log₂₆ n) - Recursion depth
- **Space:** O(log₂₆ n) - Recursion stack + result string

---

## Approach Comparison

| Aspect | Iterative | Recursive |
|--------|-----------|-----------|
| **Time Complexity** | O(log₂₆ n) | O(log₂₆ n) |
| **Space Complexity** | O(log₂₆ n) | O(log₂₆ n) + stack |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Stack Overflow Risk** | No | Yes (large n) |
| **Best For** | Production | Understanding |

---

## Critical Insights

### 1. Why This Isn't Standard Base Conversion
```
Standard base-26 (0-indexed):
A=0, B=1, ..., Z=25
26 in base-26 = "BA" (1×26 + 0)

Excel (1-indexed):
A=1, B=2, ..., Z=26
26 in Excel = "Z" (not "BA")
27 in Excel = "AA"

The -1 adjustment converts 1-indexed to 0-indexed!
```

### 2. The Magic of columnNumber -= 1
```
For columnNumber = 26 (should be "Z"):

Without -1:
26 % 26 = 0 → 'A' (wrong!)
26 // 26 = 1 → continues

With -1:
25 % 26 = 25 → 'Z' (correct!)
25 // 26 = 0 → stops
```

### 3. Why Prepend Instead of Append?
```
We process digits from right to left:
701 → Y (rightmost) → Z (leftmost)

If we append:
result = "" + 'Y' = "Y"
result = "Y" + 'Z' = "YZ" ❌

If we prepend:
result = 'Y' + "" = "Y"
result = 'Z' + "Y" = "ZY" ✓
```

### 4. Number of Digits Formula
```
1-letter columns: 1-26 (26 values)
2-letter columns: 27-702 (26² = 676 values)
3-letter columns: 703-18278 (26³ = 17576 values)

For columnNumber n:
Number of digits = ⌈log₂₆(n)⌉
```

### 5. Edge Cases
```
1 → "A" (smallest)
26 → "Z" (end of single letter)
27 → "AA" (start of double letter)
52 → "AZ" (end of A series)
702 → "ZZ" (end of double letter)
703 → "AAA" (start of triple letter)
```

---

## Common Mistakes

### ❌ Mistake 1: Not Subtracting 1
```python
# Wrong: Standard base conversion
while columnNumber > 0:
    result = chr(ord('A') + columnNumber % 26) + result
    columnNumber //= 26
```
**Impact:** 26 → "BA" instead of "Z"

### ❌ Mistake 2: Subtracting 1 After Modulo
```python
# Wrong order
remainder = columnNumber % 26
columnNumber -= 1
```
**Impact:** Incorrect character mapping

### ❌ Mistake 3: Using Append Instead of Prepend
```python
# Wrong: Appending
result += char  # "YZ" instead of "ZY"
```

### ❌ Mistake 4: Off-by-One in Character Mapping
```python
# Wrong: Using remainder directly
char = chr(remainder + ord('A'))  # Missing the -1 adjustment
```

### ❌ Mistake 5: Not Handling columnNumber = 0
```python
# Wrong: Infinite loop if columnNumber becomes 0 unexpectedly
while columnNumber:
    # Missing proper termination
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `1` | `"A"` | First column |
| `26` | `"Z"` | Last single letter |
| `27` | `"AA"` | First double letter |
| `52` | `"AZ"` | End of A series |
| `53` | `"BA"` | Start of B series |
| `701` | `"ZY"` | Given example |
| `702` | `"ZZ"` | Last double letter |
| `703` | `"AAA"` | First triple letter |
| `2147483647` | `"FXSHRXW"` | Maximum input |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Excel Sheet Column Number** (Reverse problem) - Convert "AB" → 28
2. **Integer to Roman** - Different base conversion
3. **Base 7** - Standard base conversion
4. **Convert to Base -2** - Negative base conversion

### Key Characteristics:
- Base conversion with twist
- 1-indexed instead of 0-indexed
- Requires adjustment before division
- Build result from right to left

---

## Complete Implementations

### Implementation 1: Iterative (Clean) ⭐
```python
def convertToTitle(columnNumber: int) -> str:
    result = ""
    
    while columnNumber > 0:
        columnNumber -= 1
        result = chr(ord('A') + columnNumber % 26) + result
        columnNumber //= 26
    
    return result
```

### Implementation 2: Iterative (Verbose)
```python
def convertToTitle(columnNumber: int) -> str:
    result = ""
    
    while columnNumber > 0:
        # Convert to 0-indexed
        columnNumber -= 1
        
        # Get remainder (0-25)
        remainder = columnNumber % 26
        
        # Convert to character ('A'-'Z')
        char = chr(ord('A') + remainder)
        
        # Prepend to result
        result = char + result
        
        # Move to next digit
        columnNumber = columnNumber // 26
    
    return result
```

### Implementation 3: Recursive
```python
def convertToTitle(columnNumber: int) -> str:
    if columnNumber == 0:
        return ""
    
    columnNumber -= 1
    return convertToTitle(columnNumber // 26) + chr(ord('A') + columnNumber % 26)
```

### Implementation 4: Using List (More Efficient)
```python
def convertToTitle(columnNumber: int) -> str:
    result = []
    
    while columnNumber > 0:
        columnNumber -= 1
        result.append(chr(ord('A') + columnNumber % 26))
        columnNumber //= 26
    
    return ''.join(reversed(result))
```

### Implementation 5: One-Liner (Less Readable)
```python
def convertToTitle(columnNumber: int) -> str:
    return "" if columnNumber == 0 else convertToTitle((columnNumber - 1) // 26) + chr(ord('A') + (columnNumber - 1) % 26)
```

---

## Reverse Problem: Column Title to Number

### Problem
Convert "AB" → 28

### Solution
```python
def titleToNumber(columnTitle: str) -> int:
    result = 0
    
    for char in columnTitle:
        result = result * 26 + (ord(char) - ord('A') + 1)
    
    return result
```

### Example: "AB" → 28
```
result = 0

char = 'A':
    result = 0 × 26 + (65 - 65 + 1) = 1

char = 'B':
    result = 1 × 26 + (66 - 65 + 1) = 26 + 2 = 28

Result: 28
```

---

## Optimization Techniques

### 1. Use List Instead of String Concatenation
```python
# Faster for large numbers
result = []
while columnNumber > 0:
    columnNumber -= 1
    result.append(chr(ord('A') + columnNumber % 26))
    columnNumber //= 26

return ''.join(reversed(result))
```

### 2. Pre-calculate ord('A')
```python
A_ORD = ord('A')

while columnNumber > 0:
    columnNumber -= 1
    result = chr(A_ORD + columnNumber % 26) + result
    columnNumber //= 26
```

### 3. Combine Operations
```python
while columnNumber > 0:
    columnNumber -= 1
    result = chr(ord('A') + columnNumber % 26) + result
    columnNumber //= 26
```

---

## Mathematical Deep Dive

### Why Subtract 1?
```
Excel uses 1-indexed system:
A=1, B=2, ..., Z=26

Standard base-26 uses 0-indexed:
A=0, B=1, ..., Z=25

To convert:
1-indexed → 0-indexed: subtract 1
0-indexed → 1-indexed: add 1

Example:
26 (Excel) → 25 (base-26) → 'Z'
27 (Excel) → 26 (base-26) → 'AA' (1×26 + 0)
```

### Number of Columns Formula
```
Single letter (A-Z): 26¹ = 26
Double letter (AA-ZZ): 26² = 676
Triple letter (AAA-ZZZ): 26³ = 17,576

Total columns up to n letters:
26 + 26² + 26³ + ... + 26ⁿ = 26(26ⁿ - 1) / 25
```

### Conversion Formula
```
For Excel column "ABC":
A × 26² + B × 26¹ + C × 26⁰
= 1 × 676 + 2 × 26 + 3 × 1
= 676 + 52 + 3
= 731
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Excel Sheet Column Number** | Reverse operation | String to int |
| **Integer to Roman** | Base conversion | Different symbols |
| **Base 7** | Base conversion | Standard 0-indexed |
| **Convert to Base -2** | Base conversion | Negative base |

---

## Day 44 Summary

### Problems Solved: 1
1. ✅ Excel Sheet Column Title

### Key Patterns Learned:
1. **1-Indexed Base Conversion** - Handling non-standard base systems
2. **Subtract-1 Trick** - Converting 1-indexed to 0-indexed
3. **Right-to-Left Building** - Prepending characters for correct order

### Techniques Mastered:
- Base-26 conversion with adjustment
- Character arithmetic with chr() and ord()
- String building from right to left
- Handling 1-indexed systems

### Complexity Insights:
- O(log₂₆ n) time - logarithmic in base-26
- O(log₂₆ n) space - result string length
- Each iteration processes one digit

### When to Use This Pattern:
- Base conversion problems
- 1-indexed number systems
- Excel-related problems
- Custom numeral systems

---

## Quick Reference

### Base Conversion Template (1-Indexed)
```python
def convert_to_base(number, base):
    result = ""
    
    while number > 0:
        number -= 1  # Convert to 0-indexed
        digit = number % base
        result = convert_digit(digit) + result
        number //= base
    
    return result
```

### Character Arithmetic
```python
# Convert number to letter
char = chr(ord('A') + number)  # 0→'A', 1→'B', ..., 25→'Z'

# Convert letter to number
number = ord(char) - ord('A')  # 'A'→0, 'B'→1, ..., 'Z'→25
```

### Time Complexity for Different Inputs
```
For columnNumber n:
- Number of iterations: ⌈log₂₆(n)⌉
- n = 26: 1 iteration
- n = 702: 2 iterations
- n = 18278: 3 iterations
- n = 2³¹-1: ~7 iterations
```

### Common Values Reference
```
1 → "A"
26 → "Z"
27 → "AA"
52 → "AZ"
53 → "BA"
78 → "BZ"
701 → "ZY"
702 → "ZZ"
703 → "AAA"
```
