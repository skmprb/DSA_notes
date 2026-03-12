# Day 17 - Sliding Window Technique

## Problem 1: Longest Substring Without Repeating Characters

### Problem Statement
**Input:** `s = "abcabcbb"`
**Output:** `3`
**Explanation:** The answer is "abc", with length 3

**Goal:** Find the length of the longest substring with all unique characters

---

### Problem Logic

**Key Insight:** Use sliding window with a hashmap to track character positions

**Approach:**
- Expand window by moving right pointer
- When duplicate found, shrink window from left
- Track maximum window size seen

**Why Sliding Window?**
- Substring = contiguous characters
- Need to check all possible windows
- Avoid rechecking by sliding efficiently

---

### Solution Patterns

#### Pattern 1: Sliding Window with HashMap (Optimal) ⭐

**Pseudocode:**
```
FUNCTION lengthOfLongestSubstring(s):
    CREATE char_index = {} (stores last seen index)
    SET max_length = 0
    SET start = 0
    
    FOR end from 0 to n-1:
        IF s[end] in char_index AND char_index[s[end]] >= start:
            // Duplicate found in current window
            UPDATE start = char_index[s[end]] + 1
        
        UPDATE char_index[s[end]] = end
        UPDATE max_length = max(max_length, end - start + 1)
    
    RETURN max_length
```

**Code:**
```python
def lengthOfLongestSubstring(s):
    n = len(s)
    if n == 0:
        return 0
    
    char_index = {}
    max_length = 0
    start = 0
    
    for end in range(n):
        # If character seen before and within current window
        if s[end] in char_index and char_index[s[end]] >= start:
            # Move start to position after duplicate
            start = char_index[s[end]] + 1
        
        # Update last seen index
        char_index[s[end]] = end
        # Update max length
        max_length = max(max_length, end - start + 1)
    
    return max_length
```

**Complexity:**
- Time: O(n) - single pass
- Space: O(min(n, m)) where m = charset size

---

#### Pattern 2: Sliding Window with Set

**Code:**
```python
def lengthOfLongestSubstring(s):
    char_set = set()
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        # Remove characters until no duplicate
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        
        char_set.add(s[right])
        max_length = max(max_length, right - left + 1)
    
    return max_length
```

**Complexity:**
- Time: O(2n) = O(n) - each char visited at most twice
- Space: O(min(n, m))

---

### Flow Diagram (HashMap Approach)

```
Input: "abcabcbb"

Step 1: end=0, s[0]='a'
        char_index = {'a': 0}
        start=0, max_length=1
        Window: "a"

Step 2: end=1, s[1]='b'
        char_index = {'a': 0, 'b': 1}
        start=0, max_length=2
        Window: "ab"

Step 3: end=2, s[2]='c'
        char_index = {'a': 0, 'b': 1, 'c': 2}
        start=0, max_length=3
        Window: "abc"

Step 4: end=3, s[3]='a' (DUPLICATE!)
        'a' in char_index and index 0 >= start 0
        start = 0 + 1 = 1
        char_index = {'a': 3, 'b': 1, 'c': 2}
        max_length=3
        Window: "bca"

Step 5: end=4, s[4]='b' (DUPLICATE!)
        'b' in char_index and index 1 >= start 1
        start = 1 + 1 = 2
        char_index = {'a': 3, 'b': 4, 'c': 2}
        max_length=3
        Window: "cab"

... continue

Final: max_length = 3
```

---

### Visual Explanation

```
"a b c a b c b b"
 ↑                start=0, end=0, window="a", len=1
 ↑ ↑              start=0, end=1, window="ab", len=2
 ↑   ↑            start=0, end=2, window="abc", len=3
   ↑   ↑          start=1, end=3, window="bca", len=3 (duplicate 'a')
     ↑   ↑        start=2, end=4, window="cab", len=3 (duplicate 'b')
       ↑   ↑      start=3, end=5, window="abc", len=3 (duplicate 'c')
         ↑   ↑    start=4, end=6, window="bcb", len=3 (duplicate 'b')
           ↑   ↑  start=6, end=7, window="bb", len=2 (duplicate 'b')

Maximum length = 3
```

---

## Problem 2: Permutation in String

### Problem Statement
**Input:** `s1 = "ab"`, `s2 = "eidbaooo"`
**Output:** `true`
**Explanation:** s2 contains "ba" which is a permutation of "ab"

**Goal:** Check if any permutation of s1 is a substring of s2

---

### Problem Logic

**Key Insight:** Permutation means same character frequencies

**Approach:**
- Use fixed-size sliding window (size = len(s1))
- Compare character frequencies in window with s1
- Slide window and check each position

**Why Fixed Window?**
- Permutation has same length as original
- Only need to check windows of size len(s1)

---

### Solution Patterns

#### Pattern 1: Sliding Window with Frequency Array (Optimal) ⭐

**Pseudocode:**
```
FUNCTION checkInclusion(s1, s2):
    IF len(s1) > len(s2):
        RETURN False
    
    CREATE s1_count[26] = frequency of chars in s1
    CREATE s2_count[26] = frequency of first window in s2
    
    IF s1_count == s2_count:
        RETURN True
    
    FOR i from len(s1) to len(s2)-1:
        ADD s2[i] to window (increment count)
        REMOVE s2[i-len(s1)] from window (decrement count)
        
        IF s1_count == s2_count:
            RETURN True
    
    RETURN False
```

**Code:**
```python
def checkInclusion(s1, s2):
    n1, n2 = len(s1), len(s2)
    
    if n1 > n2:
        return False
    
    # Frequency arrays for lowercase letters
    s1_count = [0] * 26
    s2_count = [0] * 26
    
    # Count frequencies in first window
    for i in range(n1):
        s1_count[ord(s1[i]) - ord('a')] += 1
        s2_count[ord(s2[i]) - ord('a')] += 1
    
    # Check first window
    if s1_count == s2_count:
        return True
    
    # Slide window
    for i in range(n1, n2):
        # Add new character
        s2_count[ord(s2[i]) - ord('a')] += 1
        # Remove old character
        s2_count[ord(s2[i - n1]) - ord('a')] -= 1
        
        if s1_count == s2_count:
            return True
    
    return False
```

**Complexity:**
- Time: O(n1 + n2) - n1 for counting, n2 for sliding
- Space: O(1) - fixed size arrays (26)

---

#### Pattern 2: Sliding Window with HashMap

**Code:**
```python
def checkInclusion(s1, s2):
    from collections import Counter
    
    n1, n2 = len(s1), len(s2)
    if n1 > n2:
        return False
    
    s1_count = Counter(s1)
    window_count = Counter(s2[:n1])
    
    if s1_count == window_count:
        return True
    
    for i in range(n1, n2):
        # Add new character
        window_count[s2[i]] += 1
        # Remove old character
        window_count[s2[i - n1]] -= 1
        if window_count[s2[i - n1]] == 0:
            del window_count[s2[i - n1]]
        
        if s1_count == window_count:
            return True
    
    return False
```

**Complexity:**
- Time: O(n1 + n2)
- Space: O(1) - at most 26 characters

---

#### Pattern 3: Brute Force (Not Optimal)

**Code:**
```python
def checkInclusion(s1, s2):
    from collections import Counter
    
    n1, n2 = len(s1), len(s2)
    s1_count = Counter(s1)
    
    for i in range(n2 - n1 + 1):
        window = s2[i:i + n1]
        if Counter(window) == s1_count:
            return True
    
    return False
```

**Complexity:**
- Time: O(n1 * n2) - creating Counter for each window
- Space: O(n1)

---

### Flow Diagram (Frequency Array)

```
s1 = "ab", s2 = "eidbaooo"

Step 1: Count s1 frequencies
        s1_count = [1, 1, 0, 0, ...] (a=1, b=1)

Step 2: Count first window "ei"
        s2_count = [0, 0, 0, 0, 1, ...] (e=1, i=1)
        Not equal → continue

Step 3: Slide to "id"
        Remove 'e', Add 'd'
        s2_count = [0, 0, 0, 1, 0, ...] (d=1, i=1)
        Not equal → continue

Step 4: Slide to "db"
        Remove 'i', Add 'b'
        s2_count = [0, 1, 0, 1, 0, ...] (b=1, d=1)
        Not equal → continue

Step 5: Slide to "ba"
        Remove 'd', Add 'a'
        s2_count = [1, 1, 0, 0, ...] (a=1, b=1)
        EQUAL! → Return True
```

---

### Visual Explanation

```
s1 = "ab"
s2 = "e i d b a o o o"
      [e i]           freq: e=1, i=1 ≠ a=1, b=1
        [i d]         freq: i=1, d=1 ≠ a=1, b=1
          [d b]       freq: d=1, b=1 ≠ a=1, b=1
            [b a]     freq: b=1, a=1 = a=1, b=1 ✓

Found permutation "ba" at index 3-4
```

---

## Comparison Table

### Longest Substring Without Repeating

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| HashMap (index) | O(n) | O(min(n,m)) | **Optimal** ⭐ |
| Set (remove) | O(n) | O(min(n,m)) | Simpler logic |
| Brute Force | O(n³) | O(min(n,m)) | Small inputs |

### Permutation in String

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Frequency Array | O(n1+n2) | O(1) | **Optimal** ⭐ |
| HashMap | O(n1+n2) | O(1) | More readable |
| Brute Force | O(n1*n2) | O(n1) | Small inputs |

---

## Key Patterns Summary

### Pattern 1: Variable Size Sliding Window
**Use for:** Finding longest/shortest substring with condition
**Template:**
```python
left = 0
max_length = 0
for right in range(n):
    # Add right element
    while condition_violated:
        # Remove left element
        left += 1
    max_length = max(max_length, right - left + 1)
```

### Pattern 2: Fixed Size Sliding Window
**Use for:** Checking all windows of specific size
**Template:**
```python
# Initialize first window
for i in range(k):
    # Process first k elements

# Slide window
for i in range(k, n):
    # Remove element at i-k
    # Add element at i
    # Check condition
```

### Pattern 3: Frequency Matching
**Use for:** Anagram, permutation problems
**Template:**
```python
target_freq = count_frequency(target)
window_freq = count_frequency(window)

while sliding:
    if target_freq == window_freq:
        return True
    # Update window_freq
```

---

## Common Mistakes

### Longest Substring:
1. **Not checking if duplicate is in current window** - Must check `char_index[s[end]] >= start`
2. **Forgetting to update char_index** - Update after moving start
3. **Wrong max calculation** - Use `end - start + 1`, not `end - start`

### Permutation in String:
1. **Wrong window size** - Must be exactly len(s1)
2. **Not removing old character** - Must decrement count when sliding
3. **Comparing wrong frequencies** - Compare entire arrays, not individual chars

---

## Edge Cases

### Longest Substring:
```python
""           → 0              # Empty string
"a"          → 1              # Single character
"aaa"        → 1              # All same
"abcdef"     → 6              # All unique
"abba"       → 2              # Palindrome
```

### Permutation in String:
```python
s1="ab", s2="a"        → False  # s2 too short
s1="ab", s2="ab"       → True   # Exact match
s1="ab", s2="ba"       → True   # Reversed
s1="ab", s2="eidboaoo" → False  # No permutation
s1="adc", s2="dcda"    → True   # Permutation exists
```

---

## Optimization Tips

### Longest Substring:
1. **Use array instead of hashmap** if charset is small (e.g., lowercase letters)
2. **Early termination** if remaining length < current max
3. **Track last seen index** to avoid rechecking

### Permutation in String:
1. **Use array for frequencies** (faster than hashmap)
2. **Compare arrays directly** (O(26) = O(1))
3. **Early return** on first match

---

## Quick Reference

### Longest Substring Without Repeating:
```
1. Initialize: char_index={}, start=0, max_len=0
2. For each character:
   - If duplicate in window: move start
   - Update char_index
   - Update max_len
```

### Permutation in String:
```
1. Count s1 frequencies
2. Count first window in s2
3. Slide window:
   - Add new char
   - Remove old char
   - Compare frequencies
```

---

## Sliding Window Decision Tree

```
Need to find substring?
  |
  ├─ Fixed size window?
  |    → Use Fixed Size Sliding Window
  |    → Example: Permutation in String
  |
  └─ Variable size window?
       |
       ├─ Find maximum?
       |    → Expand right, shrink left when invalid
       |    → Example: Longest Substring
       |
       └─ Find minimum?
            → Shrink left, expand right when invalid
            → Example: Minimum Window Substring
```

---

## Key Takeaways

1. **Sliding window** avoids redundant checks (O(n) vs O(n²))
2. **HashMap/Array** tracks window state efficiently
3. **Fixed vs Variable** window depends on problem
4. **Frequency matching** is key for permutation problems
5. **Always update** window state when sliding
6. **Check boundaries** when accessing indices
7. **Use arrays** for small charsets (faster than hashmap)

---

## Practice Variations

**Longest Substring:**
- Longest substring with at most k distinct characters
- Longest substring with at most k replacements
- Longest repeating character replacement

**Permutation:**
- Find all anagrams in string
- Minimum window substring
- Substring with concatenation of all words
