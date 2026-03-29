# Day 33 (Part 2): Kth Largest Integer in Array (String Version)

## Problem: Find the Kth Largest Integer in the Array

### Problem Statement
Given an array of strings `nums` where each string represents an integer without leading zeros, and an integer `k`, return the string that represents the kth largest integer.

**Note**: Duplicate numbers should be counted distinctly.

### Problem Logic & Reasoning

#### What Makes This Problem Unique
```
Different from Day 31 (Kth Largest Element):
- Numbers are STRINGS, not integers
- Can be VERY LARGE (up to 100 digits!)
- Can't convert to int directly (overflow)
- String comparison is DIFFERENT from numeric comparison

Challenge:
"9" > "10" as strings (lexicographic)
But 9 < 10 as numbers (numeric)

Must handle string comparison correctly!
```

#### Key Insight
```
String Comparison Problem:
"2" > "10" lexicographically ✗
2 < 10 numerically ✓

Solution:
1. Compare by LENGTH first
2. If same length, compare lexicographically

Example:
"100" vs "99"
Length: 3 > 2 → "100" is larger ✓

"100" vs "200"
Length: 3 == 3 → Compare strings → "100" < "200" ✓
```

---

## Why This Problem Needs Special Handling

### The String Comparison Trap

#### Problem with Direct String Comparison
```python
# WRONG: Direct string comparison
nums = ["3", "6", "7", "10"]
sorted(nums)  # ["10", "3", "6", "7"]
# "10" comes first because "1" < "3" lexicographically!

# CORRECT: Numeric comparison
sorted(nums, key=int)  # ["3", "6", "7", "10"]
```

#### Why We Can't Just Use int()
```
Problem: Numbers can be HUGE!

Example:
nums = ["999999999999999999999999999999999999999999"]
       (42 digits)

int() would work but:
1. Inefficient for very large numbers
2. Unnecessary conversion overhead
3. Python handles it, but not all languages do

Better: Compare as strings with custom logic
```

### Custom Comparison Logic

#### Length-First Comparison
```
Rule: Longer string = larger number (no leading zeros)

Examples:
"99" (length 2) < "100" (length 3)
"9" (length 1) < "10" (length 2)
"999" (length 3) < "1000" (length 4)

Why this works:
- No leading zeros guaranteed
- Longer string has more digits
- More digits = larger number
```

#### Same Length Comparison
```
Rule: If same length, use lexicographic comparison

Examples:
"100" vs "200" (both length 3)
"1" < "2" → "100" < "200" ✓

"999" vs "100" (both length 3)
"9" > "1" → "999" > "100" ✓

Why this works:
- Same number of digits
- Compare digit by digit from left
- First different digit determines order
```

---

## Approach 1: Min Heap with Custom Comparison ⭐

### Core Insight
Use min heap of size k, but with custom comparison that handles string numbers correctly.

### Pseudocode
```
KTH_LARGEST_STRING(nums, k):
    # Custom comparison function
    def compare(a, b):
        # Compare by length first
        if len(a) != len(b):
            return len(a) - len(b)
        # If same length, compare lexicographically
        if a < b:
            return -1
        elif a > b:
            return 1
        return 0
    
    # Build heap of first k elements
    heap = []
    for i in range(k):
        heap.append(int(nums[i]))
    heapify(heap)
    
    # Process remaining elements
    for i in range(k, len(nums)):
        num = int(nums[i])
        if num > heap[0]:
            heapreplace(heap, num)
    
    return str(heap[0])
```

### Visual Flow
```
Example: nums = ["3","6","7","10"], k = 4

Step 1: Build heap with first k=4 elements
Convert to int: [3, 6, 7, 10]
Heapify:
        3
       / \
      6   7
     /
    10

heap = [3, 6, 7, 10]

Step 2: No more elements to process

Step 3: Return root
heap[0] = 3
return "3"

Explanation:
Sorted: ["3", "6", "7", "10"]
4th largest = "3" ✓
```

### Detailed Example
```
nums = ["2","21","12","1"], k = 3

Step 1: Build heap with first k=3
Convert: [2, 21, 12]
Heapify:
        2
       / \
      21  12

heap = [2, 21, 12]

Step 2: Process remaining elements
Process "1":
int("1") = 1
1 < heap[0] = 2, skip

Step 3: Return root
heap[0] = 2
return "2"

Verification:
Sorted numerically: [1, 2, 12, 21]
3rd largest = 2 ✓
```

### Why Convert to Int?
```
Python's heapq uses < operator:
- For strings: lexicographic comparison
- For ints: numeric comparison

By converting to int:
- Heap automatically uses numeric comparison
- No custom comparison needed
- Simpler implementation

Trade-off:
+ Simple code
+ Correct comparison
- Conversion overhead (but Python handles big ints)
```

### Complexity
- **Time**: O(n log k)
  - Build heap: O(k log k)
  - Process n-k elements: O((n-k) log k)
  - Total: O(n log k)
- **Space**: O(k) for heap

---

## Approach 2: Sorting with Custom Key

### Core Insight
Sort using custom comparison, then return kth from end.

### Pseudocode
```
KTH_LARGEST_STRING_SORT(nums, k):
    # Sort with custom key
    def sort_key(s):
        return (len(s), s)
    
    sorted_nums = sorted(nums, key=sort_key)
    
    return sorted_nums[-k]
```

### Visual Flow
```
nums = ["3","6","7","10"], k = 4

Step 1: Sort with custom key
Key for "3": (1, "3")
Key for "6": (1, "6")
Key for "7": (1, "7")
Key for "10": (2, "10")

Sort by (length, string):
[(1, "3"), (1, "6"), (1, "7"), (2, "10")]

sorted_nums = ["3", "6", "7", "10"]

Step 2: Get kth from end
sorted_nums[-4] = "3"
```

### Why (len(s), s) Works
```
Python tuple comparison:
- Compares first element first
- If equal, compares second element

Example:
(1, "9") < (2, "1")  # 1 < 2, so True
(2, "10") < (2, "20")  # 2 == 2, so compare "10" < "20"

This gives us:
1. Length comparison first
2. Lexicographic comparison if same length
Exactly what we need!
```

### Complexity
- **Time**: O(n log n) - sorting
- **Space**: O(n) - sorted array
- **Issue**: Doesn't meet O(n log k) for small k ✗

---

## Approach 3: Direct Int Conversion (Simplest) ⭐

### Core Insight
Python handles arbitrary precision integers. Just convert, use standard heap.

### Pseudocode
```
KTH_LARGEST_STRING_SIMPLE(nums, k):
    heap = []
    
    # Build heap of first k elements
    for i in range(k):
        heappush(heap, int(nums[i]))
    
    # Process remaining elements
    for i in range(k, len(nums)):
        num = int(nums[i])
        if num > heap[0]:
            heapreplace(heap, num)
    
    return str(heap[0])
```

### Visual Flow
```
nums = ["2","21","12","1"], k = 3

Step 1: Build heap with first k=3
heappush(heap, 2)   → heap = [2]
heappush(heap, 21)  → heap = [2, 21]
heappush(heap, 12)  → heap = [2, 21, 12]

        2
       / \
      21  12

Step 2: Process remaining
Process 1:
1 < 2, skip

Step 3: Return
str(heap[0]) = str(2) = "2"
```

### Why This Works in Python
```
Python's int type:
- Arbitrary precision (no overflow)
- Can handle any size number
- Efficient for most cases

Example:
num = "99999999999999999999999999999999"
int(num)  # Works perfectly!

Comparison:
int("10") > int("9")  # True (numeric)
"10" > "9"            # False (lexicographic)
```

### Complexity
- **Time**: O(n log k)
  - Conversion: O(n × d) where d = avg digits
  - Heap ops: O(n log k)
  - Total: O(n × d + n log k) ≈ O(n log k) if d is small
- **Space**: O(k) for heap

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Heap + int()** ⭐ | O(n log k) | O(k) | Simple, correct | Conversion overhead |
| **Sort + custom key** | O(n log n) | O(n) | Clean code | Slower for small k |
| **Heap + custom compare** | O(n log k) | O(k) | No conversion | More complex |

**Best Choice**: Heap with int() conversion - simplest and efficient

---

## Why Other Approaches Fail

### Approach 1: Direct String Heap ✗
```python
# WRONG
heap = []
for num in nums[:k]:
    heappush(heap, num)  # String comparison!

for num in nums[k:]:
    if num > heap[0]:  # Lexicographic comparison!
        heapreplace(heap, num)

# Problem:
nums = ["3", "10"]
"3" > "10" as strings → Wrong!
```

**Why it fails:**
```
String comparison is lexicographic:
"10" < "3" because "1" < "3"

But numerically:
10 > 3

Result: Wrong answer!
```

### Approach 2: Sort Strings Directly ✗
```python
# WRONG
sorted_nums = sorted(nums)
return sorted_nums[-k]

# Problem:
nums = ["3","6","7","10"]
sorted(nums) = ["10","3","6","7"]
# "10" comes first!
```

**Why it fails:**
```
Lexicographic sort:
"1" < "3" < "6" < "7"
So "10" comes before "3"

Result: Wrong order!
```

---

## String Number Comparison Deep Dive

### The Core Problem
```
Lexicographic (String) Comparison:
- Compare character by character
- '1' < '2' < '3' < ... < '9'
- "10" < "2" because '1' < '2'

Numeric Comparison:
- Compare as numbers
- 1 < 2 < 3 < ... < 10
- 10 > 2 because 10 > 2
```

### Examples of Differences
```
String vs Numeric:

"9" > "10"     (string)
9 < 10         (numeric)

"100" < "99"   (string)
100 > 99       (numeric)

"2" > "10"     (string)
2 < 10         (numeric)

"21" > "12"    (string) ✓ (same as numeric)
21 > 12        (numeric) ✓
```

### When String Comparison Works
```
Same length strings:
"100" < "200"  (string) ✓
100 < 200      (numeric) ✓

"999" > "100"  (string) ✓
999 > 100      (numeric) ✓

Why: Same number of digits, so digit-by-digit
comparison gives correct numeric order
```

### Custom Comparison Function
```python
def compare_string_numbers(a, b):
    """
    Compare two string numbers correctly.
    Returns: -1 if a < b, 0 if a == b, 1 if a > b
    """
    # Different lengths
    if len(a) != len(b):
        return -1 if len(a) < len(b) else 1
    
    # Same length - lexicographic works
    if a < b:
        return -1
    elif a > b:
        return 1
    return 0

# Usage
compare_string_numbers("9", "10")   # -1 (9 < 10)
compare_string_numbers("100", "99") # 1 (100 > 99)
compare_string_numbers("21", "12")  # 1 (21 > 12)
```

---

## Edge Cases

```python
# Case 1: All same length
nums = ["3","6","7","9"], k = 2
Output: "6"
# Lexicographic comparison works

# Case 2: Different lengths
nums = ["3","6","7","10"], k = 4
Output: "3"
# Must handle length comparison

# Case 3: Very large numbers
nums = ["999999999999999999", "1000000000000000000"], k = 1
Output: "1000000000000000000"
# int() handles it

# Case 4: Duplicates
nums = ["0","0"], k = 2
Output: "0"

# Case 5: Single digit vs multi-digit
nums = ["9","10"], k = 1
Output: "10"
# 10 > 9

# Case 6: Leading zeros not present
nums = ["01","1"], k = 1
# Invalid input (no leading zeros guaranteed)
```

---

## Common Mistakes

1. ❌ **Direct string comparison**: Gives wrong order
2. ❌ **Sorting strings directly**: Lexicographic order
3. ❌ **Not converting to int**: String heap comparison fails
4. ❌ **Assuming small numbers**: Can be 100 digits!
5. ❌ **Forgetting to convert back**: Return string, not int

---

## Implementation Tips

### Tip 1: Use int() in Python
```python
# Simple and correct
heap = []
for num in nums[:k]:
    heappush(heap, int(num))

# Python handles big integers automatically
```

### Tip 2: Custom Sort Key
```python
# For sorting approach
sorted_nums = sorted(nums, key=lambda x: (len(x), x))
# First by length, then by string
```

### Tip 3: heapreplace vs heappop + heappush
```python
# Efficient
if int(num) > heap[0]:
    heapreplace(heap, int(num))

# Less efficient
if int(num) > heap[0]:
    heappop(heap)
    heappush(heap, int(num))

# heapreplace is atomic and faster
```

---

## Complete Implementation

```python
import heapq
from typing import List

class Solution:
    def kthLargestNumber(self, nums: List[str], k: int) -> str:
        """
        Find kth largest number in string array.
        
        Approach: Min heap of size k with int conversion
        Time: O(n log k)
        Space: O(k)
        """
        # Build heap with first k elements
        heap = []
        for num in nums[:k]:
            heap.append(int(num))
        heapq.heapify(heap)
        
        # Process remaining elements
        for num in nums[k:]:
            num_int = int(num)
            if num_int > heap[0]:
                heapq.heapreplace(heap, num_int)
        
        # Return root as string
        return str(heap[0])
```

### Optimized Version
```python
class Solution:
    def kthLargestNumber(self, nums: List[str], k: int) -> str:
        """
        Optimized: Build heap incrementally
        """
        heap = []
        
        for num in nums:
            num_int = int(num)
            
            if len(heap) < k:
                heapq.heappush(heap, num_int)
            elif num_int > heap[0]:
                heapq.heapreplace(heap, num_int)
        
        return str(heap[0])
```

---

## Day 33 Part 2 Summary

### Key Concepts
1. **String Numbers**: Can be very large (100 digits)
2. **Comparison Challenge**: Lexicographic ≠ Numeric
3. **Length-First Rule**: Longer string = larger number
4. **Python int()**: Handles arbitrary precision
5. **Min Heap Pattern**: Same as Day 31/33 Part 1

### String vs Numeric Comparison

| Comparison | String | Numeric | Correct |
|------------|--------|---------|---------|
| "9" vs "10" | "9" > "10" | 9 < 10 | Numeric |
| "100" vs "99" | "100" < "99" | 100 > 99 | Numeric |
| "21" vs "12" | "21" > "12" | 21 > 12 | Both ✓ |

### Pattern Recognition

| Problem | Data Type | Key Challenge | Solution |
|---------|-----------|---------------|----------|
| Kth Largest (Day 31) | int | Selection | Min heap |
| Kth in Stream (Day 33.1) | int | Dynamic | Min heap |
| Kth String (Day 33.2) | string | Comparison | int() + heap |

### Critical Insights
1. **String Trap**: Direct comparison gives wrong order
2. **Length Matters**: Compare length before value
3. **Python Advantage**: Arbitrary precision integers
4. **Same Pattern**: Min heap of size k still works
5. **Conversion**: int() for comparison, str() for output

### When to Use This Pattern
- Numbers as strings
- Very large numbers (> 64 bits)
- Need numeric comparison on strings
- Kth element problems with string input

### Master Checklist
- [ ] Understand string vs numeric comparison
- [ ] Know why direct string comparison fails
- [ ] Can implement length-first comparison
- [ ] Understand Python's arbitrary precision int
- [ ] Can use heap with int conversion
- [ ] Know when to convert: int() for compare, str() for output
- [ ] Understand complexity: O(n log k)
- [ ] Can handle very large numbers (100 digits)

### Related Problems
- Kth Largest Element (Day 31)
- Kth Largest in Stream (Day 33 Part 1)
- Compare Version Numbers
- Valid Number
- String to Integer (atoi)
- Add Strings
- Multiply Strings
