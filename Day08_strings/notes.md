# Day 08: String Problems - Sliding Window Pattern

## Overview
Both problems use the **Sliding Window** pattern with different constraints:
1. **Longest Substring Without Repeating Characters** - No duplicates allowed
2. **Longest Repeating Character Replacement** - Can replace k characters

---

# Problem 1: Longest Substring Without Repeating Characters

## Problem Pattern
**Sliding Window + Hash Set/Map** - Variable size window

## Problem Statement
Find the length of the longest substring without duplicate characters.

**Example**: `"abcabcbb"` → 3 (substring "abc")

## Key Insight
Use a sliding window that expands when no duplicates, shrinks when duplicate found.

**Core Idea**: 
- Expand window by moving right pointer
- When duplicate found, shrink from left until duplicate removed
- Track maximum window size

## Algorithm Explanation

### Approach 1: Sliding Window with Set (Optimal)

**Logic**:
1. Use a set to track characters in current window
2. Expand window by adding right character
3. If duplicate found, remove left characters until duplicate gone
4. Track maximum window size

**Why it works**:
- Set provides O(1) lookup for duplicates
- Shrinking from left maintains valid window
- Each character visited at most twice (once by right, once by left)

### Approach 2: Sliding Window with HashMap (More Efficient)

**Logic**:
1. Use hashmap to store character → last seen index
2. When duplicate found, jump left pointer directly
3. No need to remove characters one by one

**Why it works**:
- HashMap stores last position of each character
- Can skip directly to position after duplicate
- More efficient than removing one by one

## Pseudocode

### Approach 1: With Set
```
function lengthOfLongestSubstring(s):
    char_set = empty set
    left = 0
    max_length = 0
    
    for right from 0 to length(s)-1:
        // Shrink window until no duplicate
        while s[right] in char_set:
            remove s[left] from char_set
            left++
        
        // Add current character
        add s[right] to char_set
        max_length = max(max_length, right - left + 1)
    
    return max_length
```

### Approach 2: With HashMap
```
function lengthOfLongestSubstring(s):
    char_index = empty map
    left = 0
    max_length = 0
    
    for right from 0 to length(s)-1:
        // If duplicate and within current window
        if s[right] in char_index AND char_index[s[right]] >= left:
            left = char_index[s[right]] + 1
        
        // Update index and max length
        char_index[s[right]] = right
        max_length = max(max_length, right - left + 1)
    
    return max_length
```

## Flowchart

```
                    START
                      |
                      v
        left=0, right=0, max_len=0
        char_set = {} or char_index = {}
                      |
                      v
              +---------------+
              | right < len(s)?|---NO---> return max_len
              +---------------+
                      |YES
                      v
         +-------------------------+
         | s[right] in window?     |
         +-------------------------+
              |YES          |NO
              v             v
        [Shrink Window] [Expand Window]
              |             |
              v             v
        Remove s[left]  Add s[right]
        left++          to window
              |             |
              +------+------+
                     |
                     v
        max_len = max(max_len, right-left+1)
                     |
                     v
                  right++
                     |
                     v
        Loop back to "right < len(s)?"
```

## Visual Walkthrough

Example: `s = "abcabcbb"`

```
Step 1: right=0, s[0]='a'
Window: [a]
        ^
      left/right
max_len = 1

Step 2: right=1, s[1]='b'
Window: [a, b]
        ^   ^
      left right
max_len = 2

Step 3: right=2, s[2]='c'
Window: [a, b, c]
        ^       ^
      left    right
max_len = 3

Step 4: right=3, s[3]='a' (DUPLICATE!)
Window: [a, b, c] + a
        ^       ^
      left    right
Shrink: Remove 'a'
Window: [b, c, a]
           ^    ^
         left right
max_len = 3

Step 5: right=4, s[4]='b' (DUPLICATE!)
Window: [b, c, a] + b
           ^    ^
         left right
Shrink: Remove 'b', 'c'
Window: [a, b]
              ^  ^
            left right
max_len = 3

... continues
Final: max_len = 3
```

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n³) | O(min(n,m)) | Check all substrings |
| Sliding Window + Set | O(2n) = O(n) | O(min(n,m)) | Each char visited twice max |
| Sliding Window + HashMap | O(n) | O(min(n,m)) | Each char visited once |
| Array as HashMap | O(n) | O(128) = O(1) | For ASCII characters |

*m = size of character set (26 for lowercase, 128 for ASCII)*

---

# Problem 2: Longest Repeating Character Replacement

## Problem Pattern
**Sliding Window + Frequency Count** - Variable size window with constraint

## Problem Statement
Find longest substring with same letter after replacing at most k characters.

**Example**: `s = "AABABBA", k = 1` → 4 (replace one 'A' to get "AABBBBA")

## Key Insight
**Formula**: `window_size - max_frequency <= k`

**Meaning**: 
- `max_frequency` = count of most frequent character in window
- `window_size - max_frequency` = characters that need replacement
- If replacements needed > k, shrink window

## Algorithm Explanation

**Logic**:
1. Track frequency of each character in current window
2. Track maximum frequency seen so far
3. If `(window_size - max_freq) > k`, shrink window
4. Track maximum valid window size

**Why it works**:
- We want to maximize characters of one type
- Replace all other characters to match the most frequent one
- If replacements needed > k, window is invalid

**Key Optimization**: 
- Don't need to update max_freq when shrinking
- Only care about finding larger windows
- If max_freq decreases, window won't grow anyway

## Pseudocode

```
function characterReplacement(s, k):
    count = empty map
    left = 0
    max_length = 0
    max_freq = 0
    
    for right from 0 to length(s)-1:
        // Add current character
        count[s[right]]++
        max_freq = max(max_freq, count[s[right]])
        
        // Check if window is valid
        window_size = right - left + 1
        replacements_needed = window_size - max_freq
        
        // Shrink if too many replacements needed
        while replacements_needed > k:
            count[s[left]]--
            left++
            window_size = right - left + 1
            replacements_needed = window_size - max_freq
        
        max_length = max(max_length, window_size)
    
    return max_length
```

## Flowchart

```
                    START
                      |
                      v
        left=0, right=0, max_len=0
        count={}, max_freq=0
                      |
                      v
              +---------------+
              | right < len(s)?|---NO---> return max_len
              +---------------+
                      |YES
                      v
        count[s[right]]++
        max_freq = max(max_freq, count[s[right]])
                      |
                      v
        window_size = right - left + 1
        replacements = window_size - max_freq
                      |
                      v
         +-------------------------+
         | replacements > k?       |
         +-------------------------+
              |YES          |NO
              v             v
        [Shrink]      [Valid Window]
        count[s[left]]--    |
        left++              |
              |             |
              +------+------+
                     |
                     v
        max_len = max(max_len, window_size)
                     |
                     v
                  right++
                     |
                     v
        Loop back to "right < len(s)?"
```

## Visual Walkthrough

Example: `s = "AABABBA", k = 1`

```
Step 1: right=0, s[0]='A'
Window: [A]
count: {A:1}, max_freq=1
replacements = 1-1 = 0 <= 1 ✓
max_len = 1

Step 2: right=1, s[1]='A'
Window: [A, A]
count: {A:2}, max_freq=2
replacements = 2-2 = 0 <= 1 ✓
max_len = 2

Step 3: right=2, s[2]='B'
Window: [A, A, B]
count: {A:2, B:1}, max_freq=2
replacements = 3-2 = 1 <= 1 ✓
max_len = 3

Step 4: right=3, s[3]='A'
Window: [A, A, B, A]
count: {A:3, B:1}, max_freq=3
replacements = 4-3 = 1 <= 1 ✓
max_len = 4

Step 5: right=4, s[4]='B'
Window: [A, A, B, A, B]
count: {A:3, B:2}, max_freq=3
replacements = 5-3 = 2 > 1 ✗
Shrink: left++
Window: [A, B, A, B]
count: {A:2, B:2}, max_freq=3
replacements = 4-3 = 1 <= 1 ✓
max_len = 4

... continues
Final: max_len = 4
```

## Complexity Analysis

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n²) | O(26) = O(1) | Check all substrings |
| Sliding Window | O(n) | O(26) = O(1) | Each char visited twice max |
| Optimized Window | O(n) | O(1) | Don't update max_freq |

---

# Pattern Comparison

## Similarities
1. Both use **Sliding Window** pattern
2. Both have **variable window size**
3. Both use **two pointers** (left, right)
4. Both track **maximum result**

## Differences

| Aspect | Problem 1 | Problem 2 |
|--------|-----------|-----------|
| Constraint | No duplicates | At most k replacements |
| Data Structure | Set or HashMap | Frequency map |
| Shrink Condition | Duplicate found | Replacements > k |
| Window Validity | All unique chars | max_freq + k >= window_size |

## Common Sliding Window Template

```python
def sliding_window_template(s, constraint):
    left = 0
    result = 0
    window_state = {}  # Set, Map, or Counter
    
    for right in range(len(s)):
        # 1. Add right element to window
        add_to_window(s[right], window_state)
        
        # 2. Shrink window if constraint violated
        while not is_valid(window_state, constraint):
            remove_from_window(s[left], window_state)
            left += 1
        
        # 3. Update result
        result = max(result, right - left + 1)
    
    return result
```

---

# Implementation Tips

## Problem 1: Longest Substring Without Duplicates

### Tip 1: Set vs HashMap
```python
# Set: Simpler but slower shrinking
char_set = set()
while s[right] in char_set:
    char_set.remove(s[left])
    left += 1

# HashMap: Faster, direct jump
char_index = {}
if s[right] in char_index and char_index[s[right]] >= left:
    left = char_index[s[right]] + 1
```

### Tip 2: ASCII Array Optimization
```python
# For ASCII characters (faster than HashMap)
char_index = [-1] * 128
for right in range(len(s)):
    if char_index[ord(s[right])] >= left:
        left = char_index[ord(s[right])] + 1
    char_index[ord(s[right])] = right
    max_length = max(max_length, right - left + 1)
```

### Tip 3: Handle Edge Cases
```python
if not s:  # Empty string
    return 0
if len(s) == 1:  # Single character
    return 1
```

## Problem 2: Longest Repeating Character Replacement

### Tip 1: Don't Update max_freq on Shrink
```python
# Optimization: max_freq only increases
for right in range(len(s)):
    count[s[right]] += 1
    max_freq = max(max_freq, count[s[right]])
    
    # Don't recalculate max_freq when shrinking
    if (right - left + 1) - max_freq > k:
        count[s[left]] -= 1
        left += 1
```

### Tip 2: Use get() for Cleaner Code
```python
# Instead of checking if key exists
if s[right] in count:
    count[s[right]] += 1
else:
    count[s[right]] = 1

# Use get() with default
count[s[right]] = count.get(s[right], 0) + 1
```

### Tip 3: Early Termination
```python
# If k >= len(s), entire string is valid
if k >= len(s):
    return len(s)
```

---

# Common Mistakes

## Problem 1

### Mistake 1: Not checking if index >= left
```python
# WRONG: Might use old index outside current window
if s[right] in char_index:
    left = char_index[s[right]] + 1

# CORRECT: Check if index is in current window
if s[right] in char_index and char_index[s[right]] >= left:
    left = char_index[s[right]] + 1
```

### Mistake 2: Forgetting to update index
```python
# WRONG: Index not updated
if s[right] in char_index:
    left = char_index[s[right]] + 1
max_length = max(max_length, right - left + 1)

# CORRECT: Always update index
char_index[s[right]] = right
max_length = max(max_length, right - left + 1)
```

## Problem 2

### Mistake 1: Recalculating max_freq
```python
# WRONG: Expensive to recalculate
while (right - left + 1) - max(count.values()) > k:
    count[s[left]] -= 1
    left += 1

# CORRECT: Keep max_freq variable
max_freq = max(max_freq, count[s[right]])
while (right - left + 1) - max_freq > k:
    count[s[left]] -= 1
    left += 1
```

### Mistake 2: Using if instead of while
```python
# WRONG: Might need to shrink multiple times
if (right - left + 1) - max_freq > k:
    count[s[left]] -= 1
    left += 1

# CORRECT: Use while to shrink until valid
while (right - left + 1) - max_freq > k:
    count[s[left]] -= 1
    left += 1
```

---

# Practice Problems

## Similar to Problem 1:
1. LeetCode 3: Longest Substring Without Repeating Characters ⭐
2. LeetCode 159: Longest Substring with At Most Two Distinct Characters
3. LeetCode 340: Longest Substring with At Most K Distinct Characters
4. LeetCode 992: Subarrays with K Different Integers

## Similar to Problem 2:
1. LeetCode 424: Longest Repeating Character Replacement ⭐
2. LeetCode 1004: Max Consecutive Ones III
3. LeetCode 1493: Longest Subarray of 1's After Deleting One Element
4. LeetCode 2024: Maximize the Confusion of an Exam

---

# Key Takeaways

## Problem 1: Longest Substring Without Duplicates
1. **Pattern**: Sliding window with uniqueness constraint
2. **Data Structure**: Set for O(1) lookup or HashMap for O(1) jump
3. **Time**: O(n), each character visited at most twice
4. **Space**: O(min(n, m)) where m is charset size

## Problem 2: Longest Repeating Character Replacement
1. **Pattern**: Sliding window with replacement budget
2. **Formula**: `window_size - max_freq <= k`
3. **Optimization**: Don't update max_freq on shrink
4. **Time**: O(n), **Space**: O(1) for uppercase letters

## General Sliding Window Pattern
1. **Expand**: Add right element
2. **Shrink**: Remove left elements until valid
3. **Update**: Track maximum/minimum result
4. **Repeat**: Move right pointer

**Remember**: "Expand right, shrink left, track the best!"
