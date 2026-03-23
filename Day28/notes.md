# Day 28: Length of Last Word

## Problem: Length of Last Word

### Problem Statement
Given a string `s` consisting of words and spaces, return the length of the last word in the string.

**Word Definition**: A maximal substring consisting of non-space characters only.

### Problem Logic
Need to find the last word (ignoring trailing spaces) and return its length.

---

## Approach 1: Split and Index ⭐

### Core Insight
Split string by spaces, get last element, return its length. Python's split() automatically handles multiple spaces.

### Pseudocode
```
LENGTH_OF_LAST_WORD(s):
    words = s.split()
    return len(words[-1])
```

### Visual Flow
```
Example 1: s = "Hello World"

Step 1: Split by spaces
words = ["Hello", "World"]

Step 2: Get last word
words[-1] = "World"

Step 3: Return length
len("World") = 5

Example 2: s = "   fly me   to   the moon  "

Step 1: Split by spaces (handles multiple spaces)
words = ["fly", "me", "to", "the", "moon"]

Step 2: Get last word
words[-1] = "moon"

Step 3: Return length
len("moon") = 4
```

### Complexity
- **Time**: O(n) - split traverses entire string
- **Space**: O(n) - stores all words in list

---

## Approach 2: Reverse Iteration ⭐

### Core Insight
Iterate from end, skip trailing spaces, count characters until next space.

### Pseudocode
```
LENGTH_OF_LAST_WORD_REVERSE(s):
    count = 0
    i = len(s) - 1
    
    # Skip trailing spaces
    while i >= 0 and s[i] == ' ':
        i--
    
    # Count last word characters
    while i >= 0 and s[i] != ' ':
        count++
        i--
    
    return count
```

### Visual Flow
```
Example: s = "   fly me   to   the moon  "

Step 1: Start from end, skip trailing spaces
"   fly me   to   the moon  "
                          ↑
                         i=26

Skip spaces:
"   fly me   to   the moon  "
                      ↑
                     i=22

Step 2: Count characters until space
"   fly me   to   the moon  "
                      ↑
count=0, s[22]='n', count=1, i=21

"   fly me   to   the moon  "
                     ↑
count=1, s[21]='o', count=2, i=20

"   fly me   to   the moon  "
                    ↑
count=2, s[20]='o', count=3, i=19

"   fly me   to   the moon  "
                   ↑
count=3, s[19]='m', count=4, i=18

"   fly me   to   the moon  "
                  ↑
s[18]=' ', stop

Return count = 4
```

### Step-by-Step Example
```
s = "Hello World"

Phase 1: Skip trailing spaces
i=10: s[10]='d' (not space), skip phase

Phase 2: Count characters
i=10: s[10]='d', count=1, i=9
i=9:  s[9]='l', count=2, i=8
i=8:  s[8]='r', count=3, i=7
i=7:  s[7]='o', count=4, i=6
i=6:  s[6]='W', count=5, i=5
i=5:  s[5]=' ', stop

Return count = 5
```

### Complexity
- **Time**: O(k) where k = length of last word + trailing spaces
- **Space**: O(1) - only counter variable

---

## Approach 3: Strip and Split

### Core Insight
Strip trailing/leading spaces first, then split and get last word.

### Pseudocode
```
LENGTH_OF_LAST_WORD_STRIP(s):
    return len(s.strip().split()[-1])
```

### Visual Flow
```
s = "   fly me   to   the moon  "

Step 1: Strip leading/trailing spaces
s.strip() = "fly me   to   the moon"

Step 2: Split by spaces
split() = ["fly", "me", "to", "the", "moon"]

Step 3: Get last and return length
[-1] = "moon"
len("moon") = 4
```

### Complexity
- **Time**: O(n) - strip and split both traverse string
- **Space**: O(n) - stores word list

---

## Approach 4: rsplit with maxsplit

### Core Insight
Use rsplit (right split) with maxsplit=1 to only split once from the right, getting last word efficiently.

### Pseudocode
```
LENGTH_OF_LAST_WORD_RSPLIT(s):
    return len(s.rsplit(maxsplit=1)[-1])
```

### Visual Flow
```
s = "   fly me   to   the moon  "

Step 1: rsplit with maxsplit=1
Splits from right, only once:
["   fly me   to   the", "moon"]

Step 2: Get last element
[-1] = "moon"

Step 3: Return length
len("moon") = 4
```

### Why rsplit is Efficient
```
Regular split():
"a b c d e" → ["a", "b", "c", "d", "e"]
Creates 5 elements, processes entire string

rsplit(maxsplit=1):
"a b c d e" → ["a b c d", "e"]
Creates 2 elements, stops after first split from right
```

### Complexity
- **Time**: O(k) where k = length from end to last space
- **Space**: O(k) - stores last word only

---

## Approach Comparison

| Approach | Time | Space | Pros | Cons |
|----------|------|-------|------|------|
| **Split + Index** | O(n) | O(n) | Clean, Pythonic | Extra space for all words |
| **Reverse Iteration** ⭐ | O(k) | O(1) | Optimal space, early exit | More code |
| **Strip + Split** | O(n) | O(n) | Handles edge cases | Redundant operations |
| **rsplit(maxsplit=1)** ⭐ | O(k) | O(k) | Efficient, clean | Less known method |

**Best Choices**: 
- **Reverse Iteration** for optimal space O(1)
- **rsplit** for balance of efficiency and readability

---

## Critical Insights

### 1. Trailing Spaces Handling
```
Why skip trailing spaces?

s = "Hello World  "
Without skipping: Would count spaces
With skipping: Correctly finds "World"

Two-phase approach:
1. Skip trailing spaces
2. Count word characters
```

### 2. Python split() Behavior
```
split() with no argument:
- Splits on any whitespace
- Removes empty strings
- Handles multiple spaces automatically

"a  b   c".split() → ["a", "b", "c"]
"a  b   c".split(' ') → ["a", "", "b", "", "", "c"]

Use split() without argument for this problem!
```

### 3. Early Termination
```
Reverse iteration stops as soon as:
1. Trailing spaces skipped
2. Last word counted

Example: "many words here but we only need last"
Only processes: "last" + trailing spaces
Doesn't process: "many words here but we only need"

Efficiency: O(k) instead of O(n)
```

### 4. Edge Cases
```
Case 1: Single word
s = "hello"
Result: 5

Case 2: Trailing spaces
s = "hello   "
Result: 5 (skip spaces)

Case 3: Leading spaces
s = "   hello"
Result: 5

Case 4: Multiple spaces between words
s = "hello    world"
Result: 5 (world)

Case 5: Single character
s = "a"
Result: 1
```

---

## Common Mistakes

1. ❌ **Not handling trailing spaces**: Counting spaces as part of word
2. ❌ **Using split(' ')**: Creates empty strings with multiple spaces
3. ❌ **Not checking bounds**: Index out of range in reverse iteration
4. ❌ **Counting from start**: Inefficient, processes entire string
5. ❌ **Forgetting edge cases**: Single word, only spaces

---

## Edge Cases

```python
# Case 1: Single word
s = "hello"
Output: 5

# Case 2: Two words
s = "Hello World"
Output: 5

# Case 3: Trailing spaces
s = "Hello World   "
Output: 5

# Case 4: Leading spaces
s = "   Hello World"
Output: 5

# Case 5: Multiple spaces
s = "Hello    World"
Output: 5

# Case 6: Many words
s = "fly me to the moon"
Output: 4

# Case 7: Single character
s = "a"
Output: 1

# Case 8: Single character with spaces
s = "  a  "
Output: 1
```

---

## Implementation Variations

### Variation 1: Return Last Word (Not Length)
```python
def getLastWord(s):
    return s.strip().split()[-1]

# Example: "Hello World" → "World"
```

### Variation 2: Get All Word Lengths
```python
def getAllWordLengths(s):
    return [len(word) for word in s.split()]

# Example: "Hello World" → [5, 5]
```

### Variation 3: Count Words
```python
def countWords(s):
    return len(s.split())

# Example: "Hello World" → 2
```

### Variation 4: Get First Word Length
```python
def lengthOfFirstWord(s):
    return len(s.strip().split()[0])

# Example: "Hello World" → 5
```

---

## Detailed Comparison

### Time Complexity Analysis
```
Input: s = "word1 word2 word3 ... wordN"
n = total length

Approach 1 (split):
- split(): O(n) - scans entire string
- [-1]: O(1) - array access
- len(): O(1) - string length stored
Total: O(n)

Approach 2 (reverse iteration):
- Skip trailing spaces: O(t) where t = trailing spaces
- Count last word: O(k) where k = last word length
Total: O(t + k) = O(k) typically

Approach 3 (strip + split):
- strip(): O(n) - scans both ends
- split(): O(n) - scans entire string
- [-1]: O(1)
- len(): O(1)
Total: O(n)

Approach 4 (rsplit):
- rsplit(maxsplit=1): O(k) - scans from right until first split
- [-1]: O(1)
- len(): O(1)
Total: O(k)
```

### Space Complexity Analysis
```
Approach 1 (split):
- Stores all words: O(n)

Approach 2 (reverse iteration):
- Only counter: O(1)

Approach 3 (strip + split):
- Stores all words: O(n)

Approach 4 (rsplit):
- Stores 2 elements max: O(k)
```

---

## When to Use Each Approach

| Scenario | Best Approach | Reason |
|----------|---------------|--------|
| **Interview** | Reverse Iteration | Shows understanding, optimal |
| **Production** | rsplit(maxsplit=1) | Clean, efficient |
| **Quick Script** | split()[-1] | Simplest, readable |
| **Memory Constrained** | Reverse Iteration | O(1) space |
| **Very Long Strings** | Reverse Iteration or rsplit | O(k) time |

---

## Decision Tree

```
lengthOfLastWord(s)
    │
    ├─ Approach 1: Split
    │   ├─ s.split() → list of words
    │   ├─ Get last: words[-1]
    │   └─ Return len(words[-1])
    │
    ├─ Approach 2: Reverse Iteration
    │   ├─ Start from end: i = len(s) - 1
    │   ├─ Skip trailing spaces
    │   ├─ Count characters until space
    │   └─ Return count
    │
    ├─ Approach 3: Strip + Split
    │   ├─ s.strip() → remove leading/trailing
    │   ├─ .split() → list of words
    │   └─ Return len(split()[-1])
    │
    └─ Approach 4: rsplit
        ├─ s.rsplit(maxsplit=1) → split once from right
        └─ Return len(rsplit()[-1])
```

---

## Day 28 Summary

### Key Concepts
1. **String Splitting**: split() handles multiple spaces automatically
2. **Reverse Iteration**: Process from end for efficiency
3. **Early Termination**: Stop after finding last word
4. **rsplit**: Split from right with limit

### Pattern Recognition

| Problem | Pattern | Key Technique | Time |
|---------|---------|---------------|------|
| Last Word Length | Reverse Iteration | Two-phase (skip, count) | O(k) |
| Word Processing | String Split | Built-in methods | O(n) |
| Efficient Parsing | rsplit | Right-to-left with limit | O(k) |

### Complexity Comparison

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Split | O(n) | O(n) | Simplicity |
| Reverse Iteration | O(k) | O(1) | Optimal solution |
| Strip + Split | O(n) | O(n) | Edge case handling |
| rsplit | O(k) | O(k) | Balance |

### Critical Insights
1. **split() vs split(' ')**: Use split() without argument
2. **Two-Phase Reverse**: Skip spaces, then count
3. **Early Exit**: Don't process entire string
4. **rsplit Efficiency**: Only splits once from right
5. **Space Tradeoff**: O(1) vs O(n) for different approaches

### When to Use This Pattern
- Last element in delimited string
- Parsing from end of string
- Avoiding full string processing
- Word/token extraction

### Master Checklist
- [ ] Can implement reverse iteration approach
- [ ] Understand split() behavior with whitespace
- [ ] Know difference between split() and split(' ')
- [ ] Can handle trailing/leading spaces
- [ ] Understand rsplit with maxsplit
- [ ] Know time/space tradeoffs
- [ ] Can implement variations (first word, all words)

### Related Problems
- Reverse Words in a String
- Valid Palindrome
- String to Integer (atoi)
- Trim Spaces
- Word Break
- Split String by Separator
