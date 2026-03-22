# Day 26: Find First Occurrence in String

## Problem: Find the Index of the First Occurrence in a String

### Problem Statement
Given two strings `needle` and `haystack`, return the index of the first occurrence of `needle` in `haystack`, or -1 if `needle` is not part of `haystack`.

### Problem Logic
Classic string matching problem. Need to find substring efficiently.

---

## Approach 1: Sliding Window (Two Pointers) ⭐

### Core Insight
Slide through haystack, at each position check if substring matches needle character by character.

### Pseudocode
```
FIND_FIRST_OCCURRENCE(haystack, needle):
    n = len(haystack)
    m = len(needle)
    
    for i in range(n - m + 1):
        match = True
        for j in range(m):
            if haystack[i + j] != needle[j]:
                match = False
                break
        
        if match:
            return i
    
    return -1
```

### Visual Flow
```
Example: haystack = "sadbutsad", needle = "sad"

i=0: Check "sad" vs "sad"
     s a d b u t s a d
     ↑ ↑ ↑
     Match! Return 0

Example: haystack = "leetcode", needle = "leeto"

i=0: Check "leeto" vs "leetc"
     l e e t c o d e
     ↑ ↑ ↑ ↑ ✗
     Mismatch at index 4

i=1: Check "leeto" vs "eetco"
     l e e t c o d e
       ↑ ✗
     Mismatch at index 0

...continue until end
Return -1 (not found)
```

### Step-by-Step Example
```
haystack = "sadbutsad", needle = "sad"

i=0: Compare haystack[0:3] with "sad"
     "sad" == "sad" ✓
     Return 0

haystack = "hello", needle = "ll"

i=0: Compare haystack[0:2] with "ll"
     "he" != "ll" ✗

i=1: Compare haystack[1:3] with "ll"
     "el" != "ll" ✗

i=2: Compare haystack[2:4] with "ll"
     "ll" == "ll" ✓
     Return 2
```

### Complexity
- **Time**: O(n × m) where n = len(haystack), m = len(needle)
  - Worst case: Check every position, compare m characters
- **Space**: O(1) - only using pointers

---

## Approach 2: Python Built-in Methods

### Method 1: Using `in` and `index()`
```python
def strStr(haystack, needle):
    if needle not in haystack:
        return -1
    return haystack.index(needle)
```

### Method 2: Using `find()`
```python
def strStr(haystack, needle):
    return haystack.find(needle)
```

### Method 3: Using Slicing
```python
def strStr(haystack, needle):
    for i in range(len(haystack) - len(needle) + 1):
        if haystack[i:i+len(needle)] == needle:
            return i
    return -1
```

### Complexity
- **Time**: O(n × m) - Python's string methods use similar algorithms
- **Space**: O(1) for find(), O(m) for slicing

---

## Approach 3: KMP Algorithm (Advanced)

### Core Insight
Build a prefix table to avoid redundant comparisons. When mismatch occurs, use table to skip ahead.

### Pseudocode
```
BUILD_LPS(needle):
    m = len(needle)
    lps = [0] * m
    length = 0
    i = 1
    
    while i < m:
        if needle[i] == needle[length]:
            length++
            lps[i] = length
            i++
        else:
            if length != 0:
                length = lps[length - 1]
            else:
                lps[i] = 0
                i++
    
    return lps

KMP_SEARCH(haystack, needle):
    n = len(haystack)
    m = len(needle)
    
    lps = BUILD_LPS(needle)
    
    i = 0  # haystack pointer
    j = 0  # needle pointer
    
    while i < n:
        if haystack[i] == needle[j]:
            i++
            j++
        
        if j == m:
            return i - j
        
        elif i < n and haystack[i] != needle[j]:
            if j != 0:
                j = lps[j - 1]
            else:
                i++
    
    return -1
```

### Visual Flow (KMP)
```
Example: haystack = "ababcababa", needle = "ababa"

Step 1: Build LPS table for "ababa"
Pattern: a b a b a
LPS:     0 0 1 2 3

Step 2: Search
haystack: a b a b c a b a b a
needle:   a b a b a
          ↑ ↑ ↑ ↑ ✗
          
Mismatch at index 4
Use LPS[3] = 2, shift needle:

haystack: a b a b c a b a b a
needle:       a b a b a
              ↑ ✗

Continue...
```

### Complexity (KMP)
- **Time**: O(n + m) - linear time!
- **Space**: O(m) - LPS table

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Sliding Window** ⭐ | O(n×m) | O(1) | Simple, intuitive | Slower for large inputs |
| **Built-in find()** | O(n×m) | O(1) | One-liner, clean | Implementation-dependent |
| **Slicing** | O(n×m) | O(m) | Readable | Extra space for slices |
| **KMP** | O(n+m) | O(m) | Optimal time | Complex implementation |

**Best Choice**: Sliding Window for interviews (simple), KMP for optimal performance

---

## Critical Insights

### 1. Loop Range Optimization
```
Why range(n - m + 1)?

haystack = "hello", needle = "ll"
n = 5, m = 2

Last valid starting position: 5 - 2 = 3
Range: 0, 1, 2, 3 (4 positions)

Formula: n - m + 1 positions to check
```

### 2. Early Termination
```python
for j in range(len(needle)):
    if haystack[i+j] != needle[j]:
        match = False
        break  # Stop checking this position
```

### 3. Edge Cases
```
Case 1: needle longer than haystack
haystack = "a", needle = "aa"
Result: -1 (impossible to find)

Case 2: Empty needle
haystack = "hello", needle = ""
Result: 0 (by convention, empty string at index 0)

Case 3: needle equals haystack
haystack = "abc", needle = "abc"
Result: 0
```

### 4. Multiple Occurrences
```
Problem asks for FIRST occurrence:

haystack = "sadbutsad", needle = "sad"
Occurrences at: 0, 6
Return: 0 (first one)
```

---

## Common Mistakes

1. ❌ **Wrong loop range**: Using `range(len(haystack))` causes index out of bounds
2. ❌ **Not breaking on mismatch**: Wastes comparisons
3. ❌ **Forgetting edge cases**: Empty strings, needle longer than haystack
4. ❌ **Off-by-one errors**: Incorrect slice indices
5. ❌ **Not returning -1**: Must return -1 when not found

---

## Edge Cases

```python
# Case 1: Not found
haystack = "hello", needle = "world"
Output: -1

# Case 2: Found at start
haystack = "hello", needle = "hel"
Output: 0

# Case 3: Found at end
haystack = "hello", needle = "lo"
Output: 3

# Case 4: Single character
haystack = "a", needle = "a"
Output: 0

# Case 5: Needle longer
haystack = "ab", needle = "abc"
Output: -1

# Case 6: Multiple matches
haystack = "aaaaa", needle = "aa"
Output: 0 (first occurrence)
```

---

## Implementation Variations

### Variation 1: Find All Occurrences
```python
def findAllOccurrences(haystack, needle):
    result = []
    for i in range(len(haystack) - len(needle) + 1):
        if haystack[i:i+len(needle)] == needle:
            result.append(i)
    return result

# Example: "sadbutsad", "sad" → [0, 6]
```

### Variation 2: Case-Insensitive Search
```python
def strStrCaseInsensitive(haystack, needle):
    haystack = haystack.lower()
    needle = needle.lower()
    return haystack.find(needle)

# Example: "Hello", "LLO" → 2
```

### Variation 3: Count Occurrences
```python
def countOccurrences(haystack, needle):
    count = 0
    for i in range(len(haystack) - len(needle) + 1):
        if haystack[i:i+len(needle)] == needle:
            count += 1
    return count

# Example: "aaaa", "aa" → 3
```

---

## Day 26 Summary

### Key Concepts
1. **Sliding Window**: Check each position in haystack
2. **Character-by-Character**: Compare needle with substring
3. **Early Termination**: Break on first mismatch
4. **Loop Range**: n - m + 1 positions to check

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Substring Search | Sliding Window | Two nested loops | O(n×m) |
| Pattern Matching | KMP | Prefix table | O(n+m) |

### Complexity Analysis

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Brute Force | O(n×m) | O(1) | Small inputs, interviews |
| KMP | O(n+m) | O(m) | Large inputs, optimal |
| Rabin-Karp | O(n+m) | O(1) | Multiple pattern search |

### Critical Insights
1. **Range Calculation**: n - m + 1 avoids out of bounds
2. **Early Break**: Stop checking position on mismatch
3. **Built-in Methods**: Python's find() is optimized
4. **KMP Optimization**: Avoids redundant comparisons

### When to Use This Pattern
- Substring search in string
- Pattern matching
- Text processing
- DNA sequence matching

### Master Checklist
- [ ] Can implement sliding window approach
- [ ] Understand loop range calculation
- [ ] Know when to break early
- [ ] Can handle edge cases (empty, not found)
- [ ] Understand KMP algorithm concept
- [ ] Know complexity tradeoffs
- [ ] Can implement variations (all occurrences, case-insensitive)

### Related Problems
- Implement strStr() / indexOf()
- Repeated Substring Pattern
- Shortest Palindrome
- KMP String Matching
- Rabin-Karp Algorithm
- Boyer-Moore Algorithm
