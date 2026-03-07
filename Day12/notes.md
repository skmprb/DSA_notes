# Day 12 - String Encoding & Palindrome Counting

## Problem 1: Encode and Decode Strings

### Problem
Convert array of strings → single encoded string → decode back to original array

### Key Challenge
Strings can contain ANY ASCII character (including delimiters)

### Solution: Length-Prefix Encoding
**Format:** `length#string`

```python
def encode(strs):
    result = ""
    for s in strs:
        result += str(len(s)) + "#" + s
    return result

def decode(s):
    result = []
    i = 0
    while i < len(s):
        # Find delimiter
        j = i
        while s[j] != "#":
            j += 1
        
        # Extract length and string
        length = int(s[i:j])
        result.append(s[j+1:j+1+length])
        i = j + 1 + length
    
    return result
```

### Example
```
Input:  ["Hello", "World"]
Encode: "5#Hello5#World"
Decode: ["Hello", "World"]
```

### Why It Works
- Know exact length → don't care about string content
- Even if "#" appears in string, we read exact character count
- Handles empty strings: `""` → `"0#"`

**Time:** O(n) | **Space:** O(n)

---

## Problem 2: Palindromic Substrings (Count)

### Problem
Count all palindromic substrings in a string

### Technique: Expand Around Center

```python
def countSubstrings(s):
    def expand(l, r):
        count = 0
        while l >= 0 and r < len(s) and s[l] == s[r]:
            count += 1
            l -= 1
            r += 1
        return count
    
    total = 0
    for i in range(len(s)):
        total += expand(i, i)      # Odd length
        total += expand(i, i+1)    # Even length
    
    return total
```

### Example
```
Input: "aaa"
Palindromes:
- "a" at index 0, 1, 2 → 3
- "aa" at (0,1), (1,2) → 2
- "aaa" at (0,2) → 1
Total: 6
```

### Key Points
- Each expansion finds one palindrome per iteration
- Must check both odd and even centers
- Count increments inside while loop (each valid expansion = 1 palindrome)

**Time:** O(n²) | **Space:** O(1)

---

## Pattern Recognition

### Encode/Decode Pattern
**When:** Need to serialize/deserialize data with special characters
**Approach:** Length-prefix encoding
**Key:** Store metadata (length) before actual data

### Count Palindromes Pattern
**When:** Count all palindromic substrings
**Approach:** Expand around center
**Key:** Increment counter during expansion (not after)

---

## Common Mistakes

1. **Encode/Decode:**
   - Forgetting to handle empty strings
   - Using delimiter that can appear in strings
   - Not reading exact character count

2. **Palindrome Count:**
   - Forgetting even-length palindromes
   - Counting after expansion (should count during)
   - Not initializing count inside expand function
