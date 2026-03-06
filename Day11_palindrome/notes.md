# Day 11: Palindromes - Complete Beginner's Guide

## 🎯 What You'll Learn
- Understanding **palindromes** (what they are)
- **Two Pointers** technique for palindromes
- **Expand Around Center** algorithm
- String manipulation methods (regex, filter, isalnum)
- Multiple approaches from simple to optimal

---

# PART 1: UNDERSTANDING PALINDROMES

## 1.1 What is a Palindrome?

**Definition**: A word, phrase, or sequence that reads the **same forward and backward**.

### Simple Examples
```
✅ Palindromes:
"racecar" → r-a-c-e-c-a-r (same both ways)
"madam" → m-a-d-a-m
"noon" → n-o-o-n
"a" → single character (always palindrome)
"" → empty string (considered palindrome)

❌ NOT Palindromes:
"hello" → h-e-l-l-o vs o-l-l-e-h (different!)
"world" → w-o-r-l-d vs d-l-r-o-w
```

### Visual Understanding
```
"racecar"
 ↓ ↓ ↓ ↓ ↓ ↓ ↓
 r a c e c a r
 ↑           ↑  Match!
   ↑       ↑    Match!
     ↑   ↑      Match!
       ↑        Match! (center)

All positions match → Palindrome!
```

## 1.2 Types of Palindromes

### Type 1: Odd Length (has center character)
```
"racecar" (length 7)
 r a c e c a r
       ↑
     center

"aba" (length 3)
 a b a
   ↑
 center
```

### Type 2: Even Length (has center gap)
```
"abba" (length 4)
 a b b a
    ↑↑
  center gap

"noon" (length 4)
 n o o n
    ↑↑
  center gap
```

---

# PART 2: PROBLEM 1 - VALID PALINDROME

## 2.1 Understanding the Problem

**Goal**: Check if a string is a palindrome after:
1. Converting to lowercase
2. Removing non-alphanumeric characters (keep only letters and numbers)

### Examples
```
Input: "A man, a plan, a canal: Panama"
After cleanup: "amanaplanacanalpanama"
Check: a-m-a-n-a-p-l-a-n-a-c-a-n-a-l-p-a-n-a-m-a
       ↑                                       ↑
       Same!
Result: true ✓

Input: "race a car"
After cleanup: "raceacar"
Check: r-a-c-e-a-c-a-r
       ↑             ↑
       r ≠ r... wait, they match!
       But: r-a-c-e vs r-a-c-e-a (different lengths)
Result: false ✗
```

## 2.2 String Cleaning Methods

### Method 1: Using Regex (re.sub)
```python
import re

s = "A man, a plan, a canal: Panama"

# Remove all non-alphanumeric characters
cleaned = re.sub(r'[^a-zA-Z0-9]', '', s)
# Result: "AmanaplanacanalPanama"

# Convert to lowercase
cleaned = cleaned.lower()
# Result: "amanaplanacanalpanama"

# One line
cleaned = re.sub(r'[^a-zA-Z0-9]', '', s).lower()
```

**What does `re.sub(r'[^a-zA-Z0-9]', '', s)` mean?**
- `re.sub` = "substitute" (replace)
- `r'[^a-zA-Z0-9]'` = pattern to match
  - `[^...]` = NOT these characters
  - `a-zA-Z` = all letters
  - `0-9` = all digits
  - So: "match anything that's NOT a letter or digit"
- `''` = replace with empty string (remove it)
- `s` = the string to clean

### Method 2: Using filter() and isalnum()
```python
s = "A man, a plan, a canal: Panama"

# Filter only alphanumeric characters
cleaned = filter(str.isalnum, s.lower())
# Result: iterator of ['a','m','a','n',...]

# Convert to list
cleaned = list(filter(str.isalnum, s.lower()))
# Result: ['a','m','a','n','a','p','l',...]

# Join to string
cleaned = ''.join(filter(str.isalnum, s.lower()))
# Result: "amanaplanacanalpanama"
```

**What does `filter(str.isalnum, s.lower())` mean?**
- `filter(function, iterable)` = keep only items where function returns True
- `str.isalnum` = function that checks if character is alphanumeric
- `s.lower()` = lowercase string to filter
- Result: only alphanumeric characters

### Method 3: Using isalnum() in loop
```python
s = "A man, a plan, a canal: Panama"

cleaned = ""
for char in s:
    if char.isalnum():
        cleaned += char.lower()

# Result: "amanaplanacanalpanama"
```

**What does `char.isalnum()` mean?**
- Returns `True` if character is letter or digit
- Returns `False` for spaces, punctuation, etc.

```python
'a'.isalnum()  # True
'5'.isalnum()  # True
' '.isalnum()  # False
','.isalnum()  # False
'!'.isalnum()  # False
```

## 2.3 Checking Palindrome

### Approach 1: Clean Then Reverse (Simplest!)
```python
def isPalindrome(s):
    # Clean string
    cleaned = ''.join(filter(str.isalnum, s.lower()))
    
    # Check if same as reversed
    return cleaned == cleaned[::-1]
```

**Why it works**:
- `cleaned[::-1]` reverses the string
- If original == reversed, it's a palindrome!

**Example**:
```python
s = "racecar"
reversed = s[::-1]  # "racecar"
s == reversed  # True → Palindrome!

s = "hello"
reversed = s[::-1]  # "olleh"
s == reversed  # False → Not palindrome
```

### Approach 2: Two Pointers (Optimal!)
```python
def isPalindrome(s):
    left = 0
    right = len(s) - 1
    
    while left < right:
        # Skip non-alphanumeric from left
        while left < right and not s[left].isalnum():
            left += 1
        
        # Skip non-alphanumeric from right
        while left < right and not s[right].isalnum():
            right -= 1
        
        # Compare characters
        if s[left].lower() != s[right].lower():
            return False
        
        left += 1
        right -= 1
    
    return True
```

**Why it's optimal**:
- No extra space for cleaned string
- Checks while cleaning (one pass)
- O(1) space complexity

### Visual Walkthrough: Two Pointers

Example: `s = "A man, a plan, a canal: Panama"`

```
Step 1: left=0, right=30
s[0]='A', s[30]='a'
'A'.lower() == 'a'.lower()? YES ✓
left=1, right=29

Step 2: left=1, right=29
s[1]=' ' → not alphanumeric, skip
left=2

Step 3: left=2, right=29
s[2]='m', s[29]='m'
'm' == 'm'? YES ✓
left=3, right=28

... continue until left >= right

All matched → Palindrome!
```

## 2.4 Complexity Comparison

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Clean + Reverse | O(n) | O(n) | Simplest code |
| Two Pointers | O(n) | O(1) | Most efficient |
| Regex | O(n) | O(n) | Requires import |

---

# PART 3: PROBLEM 2 - LONGEST PALINDROMIC SUBSTRING

## 3.1 Understanding the Problem

**Goal**: Find the longest substring that is a palindrome.

### Examples
```
Input: "babad"
Possible palindromes:
- "b" (length 1)
- "a" (length 1)
- "bab" (length 3) ← Longest!
- "aba" (length 3) ← Also longest!
- "d" (length 1)
Output: "bab" or "aba"

Input: "cbbd"
Possible palindromes:
- "c" (length 1)
- "bb" (length 2) ← Longest!
- "b" (length 1)
- "d" (length 1)
Output: "bb"
```

## 3.2 The Core Idea: Expand Around Center

**Key Insight**: Every palindrome has a **center** that we can expand from.

### Why This Works

```
Palindrome: "racecar"
            r a c e c a r
                  ↑
                center

Start from center 'e':
- Check: e == e? YES (trivial)
- Expand: c == c? YES
- Expand: a == a? YES
- Expand: r == r? YES
- Can't expand more → Found "racecar"!
```

### Two Cases to Handle

**Case 1: Odd Length (single center)**
```
"aba"
  ↑
center = 'b'

Start: b
Expand: a == a? YES
Result: "aba"
```

**Case 2: Even Length (center gap)**
```
"abba"
  ↑↑
center gap between b's

Start: b == b? YES
Expand: a == a? YES
Result: "abba"
```

## 3.3 The Algorithm

```python
def longestPalindrome(s):
    def expand(left, right):
        # Expand while characters match
        while left >= 0 and right < len(s) and s[left] == s[right]:
            left -= 1
            right += 1
        
        # Return the palindrome (not including last mismatch)
        return s[left+1:right]
    
    result = ""
    
    for i in range(len(s)):
        # Check odd length (single center)
        odd_palindrome = expand(i, i)
        
        # Check even length (center gap)
        even_palindrome = expand(i, i+1)
        
        # Keep the longest
        result = max(result, odd_palindrome, even_palindrome, key=len)
    
    return result
```

### Understanding `expand(left, right)`

```python
def expand(left, right):
    while left >= 0 and right < len(s) and s[left] == s[right]:
        left -= 1
        right += 1
    return s[left+1:right]
```

**What it does**:
1. Start with `left` and `right` pointers
2. While characters match, expand outward
3. When mismatch or boundary, stop
4. Return the palindrome substring

**Example**: `s = "babad"`, `expand(1, 1)` (center at 'a')

```
Step 1: left=1, right=1
s[1]='a', s[1]='a'
Match! Expand: left=0, right=2

Step 2: left=0, right=2
s[0]='b', s[2]='b'
Match! Expand: left=-1, right=3

Step 3: left=-1 (out of bounds)
Stop! Return s[0:3] = "bab"
```

## 3.4 Step-by-Step Walkthrough

Example: `s = "babad"`

```
i=0 (center at 'b'):
  Odd: expand(0,0)
    - s[0]='b' → "b"
  Even: expand(0,1)
    - s[0]='b', s[1]='a' → mismatch → ""
  Best so far: "b"

i=1 (center at 'a'):
  Odd: expand(1,1)
    - s[1]='a' → "a"
    - s[0]='b', s[2]='b' → match! → "bab"
  Even: expand(1,2)
    - s[1]='a', s[2]='b' → mismatch → ""
  Best so far: "bab" (length 3)

i=2 (center at 'b'):
  Odd: expand(2,2)
    - s[2]='b' → "b"
    - s[1]='a', s[3]='a' → match! → "aba"
  Even: expand(2,3)
    - s[2]='b', s[3]='a' → mismatch → ""
  Best so far: "bab" or "aba" (both length 3)

i=3 (center at 'a'):
  Odd: expand(3,3)
    - s[3]='a' → "a"
    - s[2]='b', s[4]='d' → mismatch → "a"
  Even: expand(3,4)
    - s[3]='a', s[4]='d' → mismatch → ""
  Best so far: "bab" (length 3)

i=4 (center at 'd'):
  Odd: expand(4,4)
    - s[4]='d' → "d"
  Even: expand(4,5)
    - out of bounds → ""
  Best so far: "bab" (length 3)

Final result: "bab"
```

## 3.5 Multiple Approaches

### Approach 1: Brute Force (Check All Substrings)
```python
def longestPalindrome(s):
    def is_palindrome(sub):
        return sub == sub[::-1]
    
    longest = ""
    
    for i in range(len(s)):
        for j in range(i, len(s)):
            substring = s[i:j+1]
            if is_palindrome(substring) and len(substring) > len(longest):
                longest = substring
    
    return longest
```

**Time**: O(n³) - Too slow!
- O(n²) to generate all substrings
- O(n) to check each palindrome

### Approach 2: Expand Around Center (Optimal!)
```python
def longestPalindrome(s):
    def expand(left, right):
        while left >= 0 and right < len(s) and s[left] == s[right]:
            left -= 1
            right += 1
        return s[left+1:right]
    
    result = ""
    for i in range(len(s)):
        result = max(result, expand(i, i), expand(i, i+1), key=len)
    return result
```

**Time**: O(n²) - Much better!
- O(n) centers to check
- O(n) to expand each center

### Approach 3: Expand with Tracking (Cleaner)
```python
def longestPalindrome(s):
    start, max_len = 0, 1
    
    for i in range(len(s)):
        # Check both odd and even
        for j in range(2):
            left, right = i, i + j
            
            while left >= 0 and right < len(s) and s[left] == s[right]:
                current_len = right - left + 1
                if current_len > max_len:
                    start = left
                    max_len = current_len
                left -= 1
                right += 1
    
    return s[start:start+max_len]
```

**Why `for j in range(2)`?**
- `j=0`: Check odd length (left=i, right=i)
- `j=1`: Check even length (left=i, right=i+1)
- Clever way to check both cases in one loop!

## 3.6 Understanding `max()` with `key=len`

```python
result = max(result, expand(i, i), expand(i, i+1), key=len)
```

**What it does**:
- Compare three strings: `result`, `expand(i,i)`, `expand(i,i+1)`
- Use `len` function to determine "max"
- Return the longest string

**Example**:
```python
a = "ab"
b = "xyz"
c = "hello"

max(a, b, c, key=len)  # "hello" (length 5)

# Without key=len (compares alphabetically)
max(a, b, c)  # "xyz" (alphabetically last)
```

## 3.7 Complexity Comparison

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n³) | O(1) | Too slow |
| Expand Around Center | O(n²) | O(1) | Optimal |
| Dynamic Programming | O(n²) | O(n²) | Alternative |

---

# PART 4: COMMON PATTERNS & TECHNIQUES

## 4.1 Two Pointers for Palindromes

**Pattern**: Start from both ends, move toward center

```python
def is_palindrome_two_pointers(s):
    left, right = 0, len(s) - 1
    
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    
    return True
```

**When to use**:
- Checking if string is palindrome
- In-place checking (no extra space)
- Need to skip certain characters

## 4.2 Expand Around Center

**Pattern**: Start from center, expand outward

```python
def expand_around_center(s, left, right):
    while left >= 0 and right < len(s) and s[left] == s[right]:
        left -= 1
        right += 1
    return left + 1, right - 1  # Return valid range
```

**When to use**:
- Finding longest palindrome
- Counting palindromes
- Need to find all palindromes

## 4.3 String Slicing Tricks

### Reverse String
```python
s = "hello"
reversed_s = s[::-1]  # "olleh"
```

### Substring
```python
s = "hello"
s[1:4]    # "ell" (from index 1 to 3)
s[:3]     # "hel" (from start to index 2)
s[2:]     # "llo" (from index 2 to end)
s[:]      # "hello" (entire string)
```

### Check Palindrome (One Line!)
```python
def is_palindrome(s):
    return s == s[::-1]
```

---

# PART 5: HELPER METHODS EXPLAINED

## 5.1 String Methods

### `str.isalnum()`
```python
'a'.isalnum()   # True (letter)
'5'.isalnum()   # True (digit)
'A'.isalnum()   # True (letter)
' '.isalnum()   # False (space)
','.isalnum()   # False (punctuation)
'!'.isalnum()   # False (special char)
```

### `str.lower()`
```python
'Hello'.lower()  # 'hello'
'ABC'.lower()    # 'abc'
'123'.lower()    # '123' (no change)
```

### `str.upper()`
```python
'hello'.upper()  # 'HELLO'
'abc'.upper()    # 'ABC'
```

## 5.2 Built-in Functions

### `filter(function, iterable)`
```python
# Keep only even numbers
numbers = [1, 2, 3, 4, 5]
evens = list(filter(lambda x: x % 2 == 0, numbers))
# [2, 4]

# Keep only alphanumeric
s = "Hello, World!"
cleaned = ''.join(filter(str.isalnum, s))
# "HelloWorld"
```

### `max()` with `key`
```python
# Find longest string
strings = ["a", "abc", "ab"]
longest = max(strings, key=len)  # "abc"

# Find string with most vowels
def count_vowels(s):
    return sum(1 for c in s if c in 'aeiou')

words = ["hello", "world", "aeiou"]
most_vowels = max(words, key=count_vowels)  # "aeiou"
```

## 5.3 Regex (re module)

### `re.sub(pattern, replacement, string)`
```python
import re

# Remove all digits
s = "Hello123World456"
result = re.sub(r'\d', '', s)  # "HelloWorld"

# Remove all non-letters
s = "Hello, World!"
result = re.sub(r'[^a-zA-Z]', '', s)  # "HelloWorld"

# Replace spaces with underscores
s = "Hello World"
result = re.sub(r' ', '_', s)  # "Hello_World"
```

**Common Patterns**:
- `\d` = digit
- `\w` = word character (letter, digit, underscore)
- `\s` = whitespace
- `[^...]` = NOT these characters
- `[a-z]` = lowercase letters
- `[A-Z]` = uppercase letters
- `[0-9]` = digits

---

# PART 6: PRACTICE PROBLEMS

## Similar Problems

### Easy:
1. Valid Palindrome ⭐ (Day 11)
2. Palindrome Number
3. Reverse String

### Medium:
1. Longest Palindromic Substring ⭐ (Day 11)
2. Palindromic Substrings (count all)
3. Valid Palindrome II (can remove one character)
4. Longest Palindrome (construct from characters)

### Hard:
1. Shortest Palindrome
2. Palindrome Pairs
3. Minimum Insertion Steps to Make String Palindrome

---

# PART 7: COMPLEXITY SUMMARY

## Valid Palindrome

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Clean + Reverse | O(n) | O(n) | Simplest |
| Two Pointers | O(n) | O(1) | Optimal |

## Longest Palindromic Substring

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Brute Force | O(n³) | O(1) | Too slow |
| Expand Around Center | O(n²) | O(1) | Optimal |
| Dynamic Programming | O(n²) | O(n²) | Alternative |
| Manacher's Algorithm | O(n) | O(n) | Advanced |

---

# PART 8: CHECKLIST

## Before You Code

- [ ] Do I understand what a palindrome is?
- [ ] Do I know the difference between odd/even length palindromes?
- [ ] Do I understand two pointers technique?
- [ ] Do I understand expand around center?

## While Coding

### For Valid Palindrome:
- [ ] Am I handling non-alphanumeric characters?
- [ ] Am I converting to same case?
- [ ] Am I checking from both ends?

### For Longest Palindrome:
- [ ] Am I checking both odd and even lengths?
- [ ] Am I expanding correctly?
- [ ] Am I tracking the longest found?
- [ ] Am I handling single characters?

## After Coding

- [ ] Does it handle empty string?
- [ ] Does it handle single character?
- [ ] Does it handle all same characters?
- [ ] Can I explain the time/space complexity?

---

# SUMMARY

## Two Problems, Two Techniques

### 1. Valid Palindrome
**Technique**: Two Pointers (converging)
**Pattern**: Compare from both ends
**Key**: Skip non-alphanumeric, compare case-insensitive

### 2. Longest Palindromic Substring
**Technique**: Expand Around Center
**Pattern**: Try each position as center, expand outward
**Key**: Check both odd and even length palindromes

## Key Concepts Learned

1. **Palindrome**: Reads same forward and backward
2. **Two Pointers**: Start from ends, move toward center
3. **Expand Around Center**: Start from center, expand outward
4. **String Cleaning**: Remove unwanted characters
5. **String Slicing**: `s[::-1]` reverses string

## Helper Methods

- `str.isalnum()` - Check if alphanumeric
- `str.lower()` - Convert to lowercase
- `filter()` - Keep only matching items
- `re.sub()` - Replace with regex
- `max(key=len)` - Find longest string

## Remember

- **Odd length palindrome**: Single center character
- **Even length palindrome**: Center gap between two characters
- **Two pointers**: O(1) space, check from ends
- **Expand around center**: O(n²) time, check all centers
- **Always check both odd and even cases!**

**You're ready to solve palindrome problems! 🚀**
