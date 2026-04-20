# Day 53: Regular Expression Matching - Detailed Notes

## Problem Statement

**LeetCode #10 - Regular Expression Matching (Hard)**

Given an input string `s` and a pattern `p`, implement regular expression matching with support for `.` and `*` where:

- `.` matches any single character
- `*` matches zero or more of the **preceding element**

Return `true` if the pattern matches the **entire** input string (not partial).

**Examples:**

```
Input: s = "aa", p = "a"
Output: false
Explanation: "a" does not match the entire string "aa"

Input: s = "aa", p = "a*"
Output: true
Explanation: '*' means zero or more 'a', so "a*" becomes "aa"

Input: s = "ab", p = ".*"
Output: true
Explanation: ".*" means zero or more of any character

Input: s = "aab", p = "c*a*b"
Output: true
Explanation: c* = 0 c's, a* = 2 a's, b = 1 b
```

**Constraints:**
- 1 ≤ s.length ≤ 20
- 1 ≤ p.length ≤ 20
- s contains only lowercase English letters
- p contains only lowercase English letters, `.`, and `*`
- Each `*` has a valid preceding character

---

## Problem Logic & Reasoning

### Understanding the Special Characters

**1. The `.` (Dot) Character:**
- Matches exactly ONE character
- Can be any character
- Examples:
  - `"a"` matches `"."` ✓
  - `"b"` matches `"."` ✓
  - `"ab"` matches `".."` ✓
  - `"a"` matches `".."` ✗ (need 2 chars)

**2. The `*` (Star) Character:**
- Matches ZERO or MORE of the **preceding element**
- Always paired with the character before it
- Examples:
  - `"aa"` matches `"a*"` ✓ (use 'a' 2 times)
  - `""` matches `"a*"` ✓ (use 'a' 0 times)
  - `"aaa"` matches `"a*"` ✓ (use 'a' 3 times)
  - `"b"` matches `"a*b"` ✓ (use 'a' 0 times, then 'b')

**3. Combined `.*` Pattern:**
- Matches ZERO or MORE of ANY character
- Most powerful pattern - can match anything
- Examples:
  - `"abc"` matches `".*"` ✓
  - `""` matches `".*"` ✓
  - `"anything"` matches `".*"` ✓

### Key Insights

**Why This is Hard:**
1. `*` affects the **preceding** character, not itself
2. `*` can match 0 times (skip the char) or multiple times
3. Need to try both possibilities: use `*` or skip it
4. Must match the **entire** string, not just a substring
5. Order matters - can't rearrange pattern

**The Core Challenge:**
When we see `x*` in the pattern, we have TWO choices:
- **Choice 1:** Use `*` zero times (skip both `x` and `*`)
- **Choice 2:** Use `*` one or more times (if current char matches `x`)

This creates a decision tree → Perfect for Dynamic Programming!

---

## Approach 1: Bottom-Up Dynamic Programming (Tabulation) ⭐⭐⭐

### Strategy

Build a 2D DP table where `dp[i][j]` represents:
- **Does `s[0:i]` match `p[0:j]`?**
- `i` = number of characters used from string `s`
- `j` = number of characters used from pattern `p`

### Visual Representation

**Example: s = "aab", p = "c*a*b"**

```
DP Table Construction:

       ""  c  *  a  *  b
    ""  T  F  T  F  T  F
    a   F  F  F  T  T  F
    a   F  F  F  F  T  F
    b   F  F  F  F  F  T

Legend:
T = True (match)
F = False (no match)
```

**Step-by-Step Explanation:**

```
Initial State (Base Cases):
       ""  c  *  a  *  b
    ""  T  F  T  F  T  F
    
dp[0][0] = True  → empty string matches empty pattern
dp[0][2] = True  → "" matches "c*" (use c zero times)
dp[0][4] = True  → "" matches "c*a*" (use both zero times)
```

```
Processing s[0] = 'a':
       ""  c  *  a  *  b
    ""  T  F  T  F  T  F
    a   F  F  F  T  T  F
                 ↑
dp[1][3] = True  → "a" matches "c*a"
  - c* matches 0 chars
  - a matches a
  
dp[1][4] = True  → "a" matches "c*a*"
  - Can use a* one time
```

```
Processing s[1] = 'a':
       ""  c  *  a  *  b
    ""  T  F  T  F  T  F
    a   F  F  F  T  T  F
    a   F  F  F  F  T  F
                    ↑
dp[2][4] = True  → "aa" matches "c*a*"
  - c* matches 0 chars
  - a* matches "aa" (use 2 times)
```

```
Processing s[2] = 'b':
       ""  c  *  a  *  b
    ""  T  F  T  F  T  F
    a   F  F  F  T  T  F
    a   F  F  F  F  T  F
    b   F  F  F  F  F  T
                       ↑
dp[3][5] = True  → "aab" matches "c*a*b"
  - c* matches 0 chars
  - a* matches "aa"
  - b matches b
```

### Algorithm Logic

**Three Main Cases:**

**Case 1: Pattern has `*`**
```
When p[j-1] == '*':
  prev_char = p[j-2]  (the char before *)
  
  Option A: Use * zero times
    dp[i][j] = dp[i][j-2]
    (Skip both prev_char and *)
  
  Option B: Use * one or more times
    if prev_char matches s[i-1]:
      dp[i][j] = dp[i][j] OR dp[i-1][j]
      (Keep the * pattern, consume one char from s)
```

**Case 2: Pattern has `.` or matching character**
```
When p[j-1] == '.' OR p[j-1] == s[i-1]:
  dp[i][j] = dp[i-1][j-1]
  (Both match, move both pointers)
```

**Case 3: Characters don't match**
```
When p[j-1] != s[i-1] and p[j-1] != '.':
  dp[i][j] = False
  (No match possible)
```

### Detailed Walkthrough

**Example: s = "aa", p = "a*"**

```
Step 1: Initialize DP table
       ""  a  *
    "" [T][F][F]
    a  [F][F][F]
    a  [F][F][F]

Step 2: Handle base case for empty string
       ""  a  *
    "" [T][F][T]  ← p="a*" can match "" (use a zero times)
    a  [F][F][F]
    a  [F][F][F]

Step 3: Process s[0]='a', p[0]='a'
       ""  a  *
    "" [T][F][T]
    a  [F][T][F]  ← 'a' matches 'a'
    a  [F][F][F]
    
    dp[1][1] = dp[0][0] = True

Step 4: Process s[0]='a', p[1]='*'
       ""  a  *
    "" [T][F][T]
    a  [F][T][T]  ← "a" matches "a*"
    a  [F][F][F]
    
    dp[1][2]:
      - Use * zero times: dp[1][0] = False
      - Use * one time: prev_char='a' matches s[0]='a'
        dp[0][2] = True ✓
      - Result: True

Step 5: Process s[1]='a', p[0]='a'
       ""  a  *
    "" [T][F][T]
    a  [F][T][T]
    a  [F][F][F]  ← "aa" doesn't match "a"
    
    dp[2][1] = dp[1][0] = False

Step 6: Process s[1]='a', p[1]='*'
       ""  a  *
    "" [T][F][T]
    a  [F][T][T]
    a  [F][F][T]  ← "aa" matches "a*"
    
    dp[2][2]:
      - Use * zero times: dp[2][0] = False
      - Use * multiple times: prev_char='a' matches s[1]='a'
        dp[1][2] = True ✓
      - Result: True

Final Answer: dp[2][2] = True
```

### Complete Implementation

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        # Create DP table: dp[i][j] = does s[0:i] match p[0:j]
        dp = [[False] * (len(p) + 1) for _ in range(len(s) + 1)]
        
        # Base case: empty string matches empty pattern
        dp[0][0] = True
        
        # Handle patterns like a*, a*b*, a*b*c* that can match empty string
        # Only * can match empty string (by using preceding char 0 times)
        for j in range(2, len(p) + 1):
            if p[j - 1] == '*':
                dp[0][j] = dp[0][j - 2]
        
        # Fill the DP table
        for i in range(1, len(s) + 1):
            for j in range(1, len(p) + 1):
                s_char = s[i - 1]  # Current char in string
                p_char = p[j - 1]  # Current char in pattern
                
                if p_char == '*':
                    # '*' matches zero or more of preceding element
                    prev_p_char = p[j - 2]
                    
                    # Case 1: Use * zero times (ignore prev_char and *)
                    dp[i][j] = dp[i][j - 2]
                    
                    # Case 2: Use * one or more times
                    # Only if current s_char matches the preceding pattern char
                    if prev_p_char == s_char or prev_p_char == '.':
                        dp[i][j] = dp[i][j] or dp[i - 1][j]
                
                elif p_char == '.' or p_char == s_char:
                    # Characters match or pattern has '.'
                    dp[i][j] = dp[i - 1][j - 1]
        
        return dp[len(s)][len(p)]
```

### Why This Works

**1. Subproblem Structure:**
- If we know whether `s[0:i-1]` matches `p[0:j-1]`
- We can determine if `s[0:i]` matches `p[0:j]`
- This is optimal substructure

**2. The `*` Logic:**
```
When we see x* in pattern:

Option 1: Use 0 times
  "aab" matches "c*a*b"
  Skip "c*", check if "aab" matches "a*b"
  → dp[i][j] = dp[i][j-2]

Option 2: Use 1+ times
  "aa" matches "a*"
  If s[i] matches 'a', check if "a" matches "a*"
  Then we can add one more 'a'
  → dp[i][j] = dp[i-1][j]
```

**3. Why OR Logic:**
```python
dp[i][j] = dp[i][j-2] or (match and dp[i-1][j])
```
- We succeed if EITHER option works
- Don't need both to be true
- This explores all possible matching paths

### Complexity Analysis

**Time Complexity: O(m × n)**
- m = length of string s
- n = length of pattern p
- Fill m×n table
- Each cell: O(1) operations

**Space Complexity: O(m × n)**
- DP table of size (m+1) × (n+1)
- No recursion stack

### Critical Insights

**1. Index Management:**
```python
dp[i][j] represents s[0:i] and p[0:j]
But we access s[i-1] and p[j-1]
This is because dp has extra row/col for empty string
```

**2. The `*` Always Looks Back:**
```python
When p[j-1] == '*':
  prev_p_char = p[j-2]  # Must look at preceding char
```

**3. Two Ways to Use `*`:**
```python
# Zero times: skip pattern[j-2] and pattern[j-1]
dp[i][j] = dp[i][j-2]

# One or more times: keep pattern, consume string char
if match:
    dp[i][j] = dp[i][j] or dp[i-1][j]
```

**4. Base Case for Empty String:**
```python
# Patterns like "a*b*c*" can match empty string
for j in range(2, len(p) + 1):
    if p[j-1] == '*':
        dp[0][j] = dp[0][j-2]
```

### Common Mistakes

❌ **Mistake 1: Wrong index mapping**
```python
# Wrong: confusing dp indices with string indices
if p[j] == '*':  # Should be p[j-1]
```

✓ **Correct:**
```python
if p[j-1] == '*':  # dp[j] represents p[0:j], so use p[j-1]
```

❌ **Mistake 2: Forgetting to check match before using `*`**
```python
# Wrong: always use * without checking
if p[j-1] == '*':
    dp[i][j] = dp[i-1][j]  # Missing match check
```

✓ **Correct:**
```python
if p[j-1] == '*':
    prev_p_char = p[j-2]
    if prev_p_char == s[i-1] or prev_p_char == '.':
        dp[i][j] = dp[i][j] or dp[i-1][j]
```

❌ **Mistake 3: Using AND instead of OR**
```python
# Wrong: both conditions must be true
dp[i][j] = dp[i][j-2] and dp[i-1][j]
```

✓ **Correct:**
```python
# Either option can make it work
dp[i][j] = dp[i][j-2] or dp[i-1][j]
```

### Edge Cases

**1. Empty String:**
```python
s = "", p = "a*"     → True  (use a zero times)
s = "", p = "a*b*"   → True  (use both zero times)
s = "", p = ".*"     → True  (use . zero times)
s = "", p = "a"      → False (can't match)
```

**2. Empty Pattern:**
```python
s = "a", p = ""      → False (can't match non-empty string)
s = "", p = ""       → True  (both empty)
```

**3. Pattern Longer Than String:**
```python
s = "a", p = "ab*"   → True  (b* matches zero times)
s = "a", p = "a*a"   → True  (a* matches zero, then a matches)
```

**4. All `.*` Pattern:**
```python
s = "anything", p = ".*"  → True (matches everything)
```

**5. Multiple Stars:**
```python
s = "aab", p = "c*a*b"    → True
  c* → 0 c's
  a* → 2 a's
  b  → 1 b
```

### Test Cases Walkthrough

**Test 1: s = "aa", p = "a"**
```
       ""  a
    "" [T][F]
    a  [F][T]
    a  [F][F]  ← Result: False

"aa" needs 2 chars, "a" provides only 1
```

**Test 2: s = "aa", p = "a*"**
```
       ""  a  *
    "" [T][F][T]
    a  [F][T][T]
    a  [F][F][T]  ← Result: True

a* can match "aa" by using 'a' twice
```

**Test 3: s = "ab", p = ".*"**
```
       ""  .  *
    "" [T][F][T]
    a  [F][T][T]
    b  [F][F][T]  ← Result: True

.* matches any string
```

**Test 4: s = "aab", p = "c*a*b"**
```
       ""  c  *  a  *  b
    "" [T][F][T][F][T][F]
    a  [F][F][F][T][T][F]
    a  [F][F][F][F][T][F]
    b  [F][F][F][F][F][T]  ← Result: True

c*=0, a*=2, b=1
```

---

## Summary

**Approach 1 - Bottom-Up DP:**
- ⭐⭐⭐ Most intuitive and clear
- Build table from base cases up
- Easy to debug by printing table
- Time: O(m×n), Space: O(m×n)

**Key Takeaways:**
1. `*` operates on the **preceding** character
2. Two choices with `*`: use 0 times or 1+ times
3. Use OR logic to try both possibilities
4. DP table indices are offset by 1 from string indices
5. Base case: empty string can match patterns with `*`

**When to Use This Pattern:**
- String matching with wildcards
- Pattern matching problems
- Problems with "zero or more" semantics
- When you need to try multiple possibilities

---

## Approach 2: Top-Down Recursion with Memoization ⭐⭐⭐

### Strategy

Instead of building the table bottom-up, we start from the problem and recursively break it down:
- Start with full string and full pattern
- Make decisions at each step
- Cache results to avoid recomputation
- Let recursion handle the state transitions

### Recursive Thinking

**The Recursive Question:**
"Does s[i:] match p[j:]?"

At each step, we ask:
1. Are we done? (base case)
2. Does current character match?
3. Is next character a `*`? (special handling)
4. Otherwise, match current and recurse

### Visual Recursion Tree

**Example: s = "aa", p = "a*"**

```
Start: isMatch("aa", "a*")
                    |
                    i=0, j=0
                    s[0]='a', p[0]='a', p[1]='*'
                    |
        +-----------+-----------+
        |                       |
   Use * zero times        Use * one+ times
   Skip "a*"               Match 'a', keep "a*"
        |                       |
   isMatch("aa", "")      isMatch("a", "a*")
        |                       |
     FALSE                  i=1, j=0
   (pattern empty,          s[1]='a', p[0]='a', p[1]='*'
    string not)                 |
                    +-----------+-----------+
                    |                       |
               Use * zero              Use * one+ times
                    |                       |
              isMatch("a", "")       isMatch("", "a*")
                    |                       |
                 FALSE                   i=2, j=0
                                         p[1]='*'
                                            |
                                    Use * zero times
                                            |
                                      isMatch("", "")
                                            |
                                          TRUE ✓

Result: TRUE (found at least one path)
```

### Algorithm Logic

**Base Cases:**

```python
# Case 1: Pattern exhausted
if j == len(p):
    return i == len(s)  # True only if string also exhausted

# Case 2: String exhausted but pattern remains
# Pattern can still match if it's all x* patterns
# This is handled by the * logic below
```

**Recursive Cases:**

```python
# Step 1: Check if current characters match
first_match = (i < len(s) and 
               (p[j] == s[i] or p[j] == '.'))

# Step 2: Check if next character is '*'
if j + 1 < len(p) and p[j + 1] == '*':
    # Two choices:
    # 1. Use * zero times: skip p[j] and p[j+1]
    # 2. Use * one+ times: if match, consume s[i]
    return (dp(i, j+2) or 
            (first_match and dp(i+1, j)))
else:
    # No *, just match current and move forward
    return first_match and dp(i+1, j+1)
```

### Detailed Walkthrough

**Example: s = "aab", p = "c*a*b"**

```
Call Stack Visualization:

1. dp(0, 0): s="aab", p="c*a*b"
   s[0]='a', p[0]='c', p[1]='*'
   first_match = False (a != c)
   
   Option A: Use c* zero times
     → dp(0, 2): s="aab", p="a*b"
   
   Option B: Use c* one+ times
     → first_match is False, skip this
   
   Continue with Option A...

2. dp(0, 2): s="aab", p="a*b"
   s[0]='a', p[2]='a', p[3]='*'
   first_match = True (a == a)
   
   Option A: Use a* zero times
     → dp(0, 4): s="aab", p="b"
   
   Option B: Use a* one+ times
     → dp(1, 2): s="ab", p="a*b"
   
   Try Option B first...

3. dp(1, 2): s="ab", p="a*b"
   s[1]='a', p[2]='a', p[3]='*'
   first_match = True (a == a)
   
   Option A: Use a* zero times
     → dp(1, 4): s="ab", p="b"
   
   Option B: Use a* one+ times
     → dp(2, 2): s="b", p="a*b"
   
   Try Option B first...

4. dp(2, 2): s="b", p="a*b"
   s[2]='b', p[2]='a', p[3]='*'
   first_match = False (b != a)
   
   Option A: Use a* zero times
     → dp(2, 4): s="b", p="b"
   
   Option B: Skip (no match)
   
   Continue with Option A...

5. dp(2, 4): s="b", p="b"
   s[2]='b', p[4]='b', no * after
   first_match = True (b == b)
   
   → dp(3, 5): s="", p=""

6. dp(3, 5): s="", p=""
   j == len(p) and i == len(s)
   → Return TRUE ✓

Backtrack:
5. dp(2, 4) = TRUE
4. dp(2, 2) = TRUE
3. dp(1, 2) = TRUE
2. dp(0, 2) = TRUE
1. dp(0, 0) = TRUE

Final Answer: TRUE
```

### Memoization Visualization

**Without Memoization:**
```
Same subproblems computed multiple times:

dp(1, 2) called from:
  - dp(0, 2) with Option B
  - dp(0, 0) → dp(0, 2) → ...
  
Exponential time complexity: O(2^(m+n))
```

**With Memoization:**
```
memo = {
    (0, 0): True,
    (0, 2): True,
    (1, 2): True,
    (2, 2): True,
    (2, 4): True,
    (3, 5): True,
    ...
}

Each (i, j) computed only once
Time complexity: O(m × n)
```

### Complete Implementation

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        memo = {}  # Cache for (i, j) → result
        
        def dp(i, j):
            """Does s[i:] match p[j:]?"""
            
            # Check cache first
            if (i, j) in memo:
                return memo[(i, j)]
            
            # Base case: pattern exhausted
            if j == len(p):
                # True only if string also exhausted
                return i == len(s)
            
            # Check if current characters match
            # Must check i < len(s) to avoid index error
            first_match = (i < len(s) and 
                          (p[j] == s[i] or p[j] == '.'))
            
            # Check if next character is '*'
            if j + 1 < len(p) and p[j + 1] == '*':
                # Two choices with *:
                # 1. Use * zero times: skip p[j] and p[j+1]
                # 2. Use * one or more times: if first_match, consume s[i]
                result = (dp(i, j + 2) or 
                         (first_match and dp(i + 1, j)))
            else:
                # No *, just match current and move forward
                result = first_match and dp(i + 1, j + 1)
            
            # Cache the result
            memo[(i, j)] = result
            return result
        
        return dp(0, 0)
```

### Why This Works

**1. Recursive Structure:**
```
Problem: Does "aab" match "c*a*b"?
  ↓
Subproblem 1: Does "aab" match "a*b"? (skip c*)
  ↓
Subproblem 2: Does "ab" match "a*b"? (use a* once)
  ↓
Subproblem 3: Does "b" match "a*b"? (use a* twice)
  ↓
Subproblem 4: Does "b" match "b"? (skip a*)
  ↓
Base case: Does "" match ""? → TRUE
```

**2. The `*` Decision Tree:**
```
When we see x* at position j:

         x* in pattern
              |
      +-------+-------+
      |               |
  Use 0 times    Use 1+ times
      |               |
   dp(i, j+2)    first_match?
                      |
                  +---+---+
                  |       |
                 Yes      No
                  |       |
              dp(i+1,j)  False
              
We succeed if ANY path returns True
```

**3. Memoization Benefit:**
```
Without memo:
  dp(1,2) might be called 10 times
  Each time recomputes everything
  
With memo:
  dp(1,2) computed once
  Subsequent calls: O(1) lookup
  
Savings: Exponential → Polynomial
```

### Comparison: Recursion vs Iteration

**Recursion (Top-Down):**
```python
# Start from the problem
dp(0, 0)  # Does full string match full pattern?
  → dp(0, 2)  # Try skipping first pattern
    → dp(1, 2)  # Try matching first char
      → ...

# Natural way to think about the problem
# "To solve this, I need to solve smaller versions"
```

**Iteration (Bottom-Up):**
```python
# Start from base cases
dp[0][0] = True  # Empty matches empty
dp[1][1] = ...   # Build up
dp[2][2] = ...   # Build up
  → ...
  → dp[m][n]  # Final answer

# Build from known to unknown
# "I know small cases, build up to big case"
```

### Complexity Analysis

**Time Complexity: O(m × n)**
- m = length of string s
- n = length of pattern p
- Total possible states: m × n
- Each state computed once (memoization)
- Each computation: O(1)

**Space Complexity: O(m × n)**
- Memoization dictionary: O(m × n) entries
- Recursion call stack: O(m + n) depth
- Total: O(m × n)

**Space Breakdown:**
```
Memo dictionary: {(i,j): result}
  - Max entries: (m+1) × (n+1)
  - Each entry: O(1) space
  - Total: O(m × n)

Call stack:
  - Max depth: m + n (worst case)
  - Each frame: O(1) space
  - Total: O(m + n)

Overall: O(m × n) dominates
```

### Critical Insights

**1. Why Check `i < len(s)` First:**
```python
first_match = i < len(s) and (p[j] == s[i] or p[j] == '.')

# If i >= len(s), s[i] would cause IndexError
# Short-circuit evaluation prevents this
# If i >= len(s), first_match = False (no crash)
```

**2. The `*` Always Looks Ahead:**
```python
if j + 1 < len(p) and p[j + 1] == '*':
    # We check p[j+1] to see if * follows
    # This determines our strategy
```

**3. Two Recursive Calls for `*`:**
```python
# Option 1: Use * zero times
dp(i, j + 2)  # Skip both p[j] and p[j+1]

# Option 2: Use * one or more times
dp(i + 1, j)  # Consume s[i], keep pattern
                # (so we can use * again)
```

**4. Why Keep Pattern in Option 2:**
```python
# When using * one or more times:
dp(i + 1, j)  # NOT dp(i + 1, j + 2)

# We keep j the same because:
# - We might need to use * again
# - "a*" can match "aaa" by staying at "a*"
```

### Common Mistakes

❌ **Mistake 1: Not checking bounds before accessing**
```python
# Wrong: might access s[i] when i >= len(s)
first_match = (p[j] == s[i] or p[j] == '.')
```

✓ **Correct:**
```python
first_match = i < len(s) and (p[j] == s[i] or p[j] == '.')
```

❌ **Mistake 2: Advancing pattern when using `*` multiple times**
```python
# Wrong: this only uses * once
if first_match:
    result = dp(i + 1, j + 2)  # Should be j, not j+2
```

✓ **Correct:**
```python
if first_match:
    result = dp(i + 1, j)  # Keep pattern to use * again
```

❌ **Mistake 3: Forgetting to memoize**
```python
# Wrong: recomputes same states
def dp(i, j):
    if j == len(p):
        return i == len(s)
    # ... compute result
    return result  # Not cached!
```

✓ **Correct:**
```python
def dp(i, j):
    if (i, j) in memo:
        return memo[(i, j)]
    # ... compute result
    memo[(i, j)] = result
    return result
```

❌ **Mistake 4: Wrong base case**
```python
# Wrong: doesn't handle pattern with * remaining
if i == len(s) and j == len(p):
    return True
return False
```

✓ **Correct:**
```python
if j == len(p):
    return i == len(s)  # Pattern done, check if string done
# Continue processing (pattern might have x* that matches empty)
```

### Edge Cases

**1. Empty String with `*` Pattern:**
```python
s = "", p = "a*"

dp(0, 0):
  p[1] = '*'
  Option A: Use a* zero times
    → dp(0, 2)
      j == len(p) and i == len(s)
      → TRUE ✓
```

**2. String Exhausted, Pattern Remains:**
```python
s = "a", p = "ab*"

dp(0, 0):
  first_match = True (a == a)
  No * after p[0]
  → dp(1, 1)

dp(1, 1):
  i == len(s), p[1] = 'b', p[2] = '*'
  first_match = False (i >= len(s))
  Option A: Use b* zero times
    → dp(1, 3)
      j == len(p) and i == len(s)
      → TRUE ✓
```

**3. Pattern Exhausted, String Remains:**
```python
s = "aa", p = "a"

dp(0, 0):
  first_match = True
  No * after p[0]
  → dp(1, 1)

dp(1, 1):
  j == len(p) but i < len(s)
  → FALSE ✗
```

### Recursion Trace Example

**Example: s = "aa", p = "a*"**

```
Call 1: dp(0, 0)
  s[0]='a', p[0]='a', p[1]='*'
  first_match = True
  
  Try: dp(0, 2) OR (True AND dp(1, 0))
  
  Call 2: dp(0, 2)
    j == len(p), i == 0 < len(s)
    Return: False
  
  Call 3: dp(1, 0)
    s[1]='a', p[0]='a', p[1]='*'
    first_match = True
    
    Try: dp(1, 2) OR (True AND dp(2, 0))
    
    Call 4: dp(1, 2)
      j == len(p), i == 1 < len(s)
      Return: False
    
    Call 5: dp(2, 0)
      s exhausted (i == len(s))
      p[0]='a', p[1]='*'
      first_match = False (i >= len(s))
      
      Try: dp(2, 2) OR (False AND ...)
      
      Call 6: dp(2, 2)
        j == len(p) and i == len(s)
        Return: True ✓
      
      Return: True OR False = True
    
    Return: False OR True = True
  
  Return: False OR True = True

Final: True

Memo after execution:
{
  (2, 2): True,
  (2, 0): True,
  (1, 2): False,
  (1, 0): True,
  (0, 2): False,
  (0, 0): True
}
```

### When to Use This Approach

**Prefer Top-Down Recursion When:**
- ✓ More intuitive to think recursively
- ✓ Don't need to compute all states
- ✓ Problem naturally breaks into subproblems
- ✓ Easier to understand the logic flow

**Prefer Bottom-Up DP When:**
- ✓ Need to compute all states anyway
- ✓ Want to avoid recursion overhead
- ✓ Easier to optimize space
- ✓ Want to visualize the table

---

## Approach 3: Space-Optimized DP (Using 2 Rows) ⭐⭐

### Strategy

Optimize the bottom-up DP approach by observing:
- Each row only depends on the **previous row**
- We don't need to store the entire m×n table
- Use only 2 rows: `prev` and `curr`
- Swap rows after processing each string character

### Space Optimization Insight

**Original DP Table:**
```
       ""  c  *  a  *  b
    "" [T][F][T][F][T][F]
    a  [F][F][F][T][T][F]
    a  [F][F][F][F][T][F]
    b  [F][F][F][F][F][T]
    
Space: O(m × n) = 4 × 6 = 24 cells
```

**Optimized with 2 Rows:**
```
Processing s[0]='a':
prev = [T][F][T][F][T][F]  ← Previous row (empty string)
curr = [F][F][F][T][T][F]  ← Current row ("a")

Processing s[1]='a':
prev = [F][F][F][T][T][F]  ← Previous row ("a")
curr = [F][F][F][F][T][F]  ← Current row ("aa")

Processing s[2]='b':
prev = [F][F][F][F][T][F]  ← Previous row ("aa")
curr = [F][F][F][F][F][T]  ← Current row ("aab")

Space: O(2 × n) = 2 × 6 = 12 cells
Savings: 50% reduction
```

### Visual Flow

**How Rows Are Used:**

```
Iteration 1 (i=1, s[0]='a'):
┌─────────────────────────────┐
│ prev: [T][F][T][F][T][F]   │ ← Base case (empty string)
└─────────────────────────────┘
           ↓ ↓ ↓ (read from)
┌─────────────────────────────┐
│ curr: [F][F][F][T][T][F]   │ ← Computing for "a"
└─────────────────────────────┘

Swap: prev ↔ curr

Iteration 2 (i=2, s[1]='a'):
┌─────────────────────────────┐
│ prev: [F][F][F][T][T][F]   │ ← Now contains "a" results
└─────────────────────────────┘
           ↓ ↓ ↓ (read from)
┌─────────────────────────────┐
│ curr: [F][F][F][F][T][F]   │ ← Computing for "aa"
└─────────────────────────────┘

Swap: prev ↔ curr

Iteration 3 (i=3, s[2]='b'):
┌─────────────────────────────┐
│ prev: [F][F][F][F][T][F]   │ ← Now contains "aa" results
└─────────────────────────────┘
           ↓ ↓ ↓ (read from)
┌─────────────────────────────┐
│ curr: [F][F][F][F][F][T]   │ ← Computing for "aab"
└─────────────────────────────┘

Final answer: prev[n] = True
```

### Dependency Analysis

**What Each Cell Depends On:**

```
For dp[i][j], we need:

Case 1: p[j-1] == '*'
  - curr[j-2]  (same row, 2 positions left)
  - prev[j]    (previous row, same column)

Case 2: p[j-1] matches s[i-1]
  - prev[j-1]  (previous row, one position left)

Visualization:
       j-2  j-1   j
    ┌─────┬─────┬─────┐
i-1 │     │  ③  │  ②  │  ← prev row
    ├─────┼─────┼─────┤
 i  │     │  ①  │  ?  │  ← curr row (computing ?)
    └─────┴─────┴─────┘

? depends on: ① (curr[j-2]), ② (prev[j]), ③ (prev[j-1])

All dependencies are from:
- Current row (left side, already computed)
- Previous row (any position)

✓ We only need 2 rows!
```

### Algorithm Logic

**Initialization:**
```python
prev = [False] * (n + 1)
curr = [False] * (n + 1)

# Base case: empty string matches empty pattern
prev[0] = True

# Handle patterns like a*, a*b* matching empty string
for j in range(2, n + 1):
    if p[j-1] == '*':
        prev[j] = prev[j-2]
```

**Row Processing:**
```python
for i in range(1, m + 1):
    curr[0] = False  # Non-empty string can't match empty pattern
    
    for j in range(1, n + 1):
        # Compute curr[j] using prev and curr
        # (same logic as 2D DP)
    
    # Swap rows for next iteration
    prev, curr = curr, prev
```

**Final Answer:**
```python
return prev[n]  # After swap, prev contains last computed row
```

### Detailed Walkthrough

**Example: s = "aa", p = "a*"**

```
Step 1: Initialize
prev = [T, F, F]  ← Represents empty string ""
curr = [F, F, F]  ← Will compute for s[0]

Handle base case for empty string:
prev = [T, F, T]  ← "" matches "a*" (use a zero times)
              ↑
         p[1]='*', so prev[2] = prev[0] = True

Step 2: Process i=1 (s[0]='a')
curr[0] = False  ← Non-empty string can't match empty pattern

  j=1: s[0]='a', p[0]='a'
    No * after p[0]
    'a' == 'a' ✓
    curr[1] = prev[0] = True
    
  j=2: s[0]='a', p[1]='*'
    prev_p_char = p[0] = 'a'
    
    Option A: Use a* zero times
      curr[2] = curr[0] = False
    
    Option B: Use a* one or more times
      'a' == 'a' ✓
      curr[2] = curr[2] OR prev[2]
      curr[2] = False OR True = True

prev = [T, F, T]
curr = [F, T, T]  ← Results for "a"

Swap: prev ↔ curr
prev = [F, T, T]  ← Now prev contains "a" results
curr = [T, F, T]  ← Reuse old prev array

Step 3: Process i=2 (s[1]='a')
curr[0] = False

  j=1: s[1]='a', p[0]='a'
    No * after p[0]
    'a' == 'a' ✓
    curr[1] = prev[0] = False
    
  j=2: s[1]='a', p[1]='*'
    prev_p_char = p[0] = 'a'
    
    Option A: Use a* zero times
      curr[2] = curr[0] = False
    
    Option B: Use a* one or more times
      'a' == 'a' ✓
      curr[2] = curr[2] OR prev[2]
      curr[2] = False OR True = True

prev = [F, T, T]
curr = [F, F, T]  ← Results for "aa"

Swap: prev ↔ curr
prev = [F, F, T]  ← Final results

Step 4: Return answer
return prev[n] = prev[2] = True ✓
```

### Complete Implementation

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        m, n = len(s), len(p)
        
        # Use only 2 rows instead of full table
        prev = [False] * (n + 1)
        curr = [False] * (n + 1)
        
        # Base case: empty string matches empty pattern
        prev[0] = True
        
        # Initialize first row (empty string matching pattern)
        # Patterns like a*, a*b*, a*b*c* can match empty string
        for j in range(2, n + 1):
            if p[j - 1] == '*':
                prev[j] = prev[j - 2]
        
        # Fill row by row
        for i in range(1, m + 1):
            # Non-empty string can't match empty pattern
            curr[0] = False
            
            for j in range(1, n + 1):
                s_char = s[i - 1]
                p_char = p[j - 1]
                
                if p_char == '*':
                    # '*' matches zero or more of preceding element
                    prev_p_char = p[j - 2]
                    
                    # Case 1: Use * zero times (ignore prev_char and *)
                    curr[j] = curr[j - 2]
                    
                    # Case 2: Use * one or more times
                    if prev_p_char == s_char or prev_p_char == '.':
                        curr[j] = curr[j] or prev[j]
                
                elif p_char == '.' or p_char == s_char:
                    # Characters match or pattern has '.'
                    curr[j] = prev[j - 1]
                
                else:
                    # Characters don't match
                    curr[j] = False
            
            # Swap rows for next iteration
            prev, curr = curr, prev
        
        # After all swaps, prev contains the last computed row
        return prev[n]
```

### Why This Works

**1. Row Dependency:**
```
To compute row i, we only need:
- Row i-1 (previous row)
- Row i (current row, left side)

We never need row i-2, i-3, etc.

       j-2  j-1   j
    ┌─────┬─────┬─────┐
i-1 │  ✓  │  ✓  │  ✓  │  ← Need this (prev)
    ├─────┼─────┼─────┤
 i  │  ✓  │  ✓  │  ?  │  ← Computing this (curr)
    ├─────┼─────┼─────┤
i+1 │     │     │     │  ← Don't need yet
    └─────┴─────┴─────┘
```

**2. The Swap Trick:**
```python
prev, curr = curr, prev

# This is efficient because:
# - No array copying (just pointer swap)
# - O(1) operation
# - Reuses memory

# What happens:
Before swap:
  prev → [F, T, T]  (old results)
  curr → [F, F, T]  (new results)

After swap:
  prev → [F, F, T]  (new results, for next iteration)
  curr → [F, T, T]  (will be overwritten)
```

**3. Why Reset curr[0]:**
```python
for i in range(1, m + 1):
    curr[0] = False  # Important!
    
# Because:
# - curr[0] represents non-empty string matching empty pattern
# - This is always False (except for empty string)
# - After swap, curr might have True from previous iteration
# - Must reset to False
```

### Complexity Analysis

**Time Complexity: O(m × n)**
- m = length of string s
- n = length of pattern p
- Still need to compute all m×n states
- Each state: O(1) operations
- **Same as 2D DP approach**

**Space Complexity: O(n)**
- Two arrays of size n+1
- Total: 2(n+1) = O(n)
- **Improvement from O(m×n) to O(n)**

**Space Comparison:**
```
Approach 1 (2D DP):
  Space = (m+1) × (n+1)
  Example: m=20, n=20
  Space = 21 × 21 = 441 cells

Approach 3 (2 Rows):
  Space = 2 × (n+1)
  Example: m=20, n=20
  Space = 2 × 21 = 42 cells
  
Savings: 441 → 42 (90% reduction!)
```

### Critical Insights

**1. Why We Can't Optimize to O(1):**
```
For dp[i][j], we need:
- curr[j-2]  (2 positions left in current row)
- prev[j]    (same position in previous row)
- prev[j-1]  (one position left in previous row)

We need to keep:
- Entire previous row (for prev[j] and prev[j-1])
- Current row up to j-2 (for curr[j-2])

✗ Can't reduce to O(1) without losing information
✓ O(n) is optimal for this approach
```

**2. The Swap is Crucial:**
```python
# Wrong: Forgetting to swap
for i in range(1, m + 1):
    for j in range(1, n + 1):
        # Compute curr[j]
    # Missing: prev, curr = curr, prev

# Result: prev never updates, always has base case
# Answer will be wrong!
```

**3. Order of Operations Matters:**
```python
# Correct order:
curr[j] = curr[j - 2]  # Read from curr (already computed)
curr[j] = curr[j] or prev[j]  # Read from prev (previous row)

# We compute left to right, so curr[j-2] is ready
# prev is from previous iteration, so prev[j] is ready
```

**4. Why Return prev[n] Not curr[n]:**
```python
for i in range(1, m + 1):
    # Compute curr
    prev, curr = curr, prev  # Swap at end

# After loop:
# - Last iteration computed results in curr
# - Then swapped: prev = curr, curr = prev
# - So prev has the final results

return prev[n]  # Correct
```

### Common Mistakes

❌ **Mistake 1: Forgetting to reset curr[0]**
```python
for i in range(1, m + 1):
    # Missing: curr[0] = False
    for j in range(1, n + 1):
        # ...

# Problem: curr[0] might be True from previous iteration
# Result: Wrong answer
```

✓ **Correct:**
```python
for i in range(1, m + 1):
    curr[0] = False  # Reset for each row
    for j in range(1, n + 1):
        # ...
```

❌ **Mistake 2: Forgetting to swap rows**
```python
for i in range(1, m + 1):
    for j in range(1, n + 1):
        # Compute curr[j]
    # Missing: prev, curr = curr, prev

return prev[n]  # Returns base case, not final result
```

✓ **Correct:**
```python
for i in range(1, m + 1):
    for j in range(1, n + 1):
        # Compute curr[j]
    prev, curr = curr, prev  # Swap!

return prev[n]
```

❌ **Mistake 3: Returning curr[n] instead of prev[n]**
```python
for i in range(1, m + 1):
    # ...
    prev, curr = curr, prev

return curr[n]  # Wrong! curr is now the old prev
```

✓ **Correct:**
```python
for i in range(1, m + 1):
    # ...
    prev, curr = curr, prev

return prev[n]  # Correct! prev is now the new results
```

❌ **Mistake 4: Not initializing curr properly**
```python
# Wrong: curr might have garbage values
for j in range(1, n + 1):
    if p[j-1] == '*':
        curr[j] = curr[j-2]  # curr[j-2] might be uninitialized
```

✓ **Correct:**
```python
curr = [False] * (n + 1)  # Initialize all to False

for i in range(1, m + 1):
    curr[0] = False  # Reset first element
    for j in range(1, n + 1):
        # Now safe to read curr[j-2]
```

### Edge Cases

**1. Empty String:**
```python
s = "", p = "a*b*"

Initialization:
prev = [T, F, T, F, T]  ← Handles this correctly
       ↑     ↑     ↑
      ""    "a*"  "a*b*"

No iterations (m=0)
Return prev[4] = True ✓
```

**2. Empty Pattern:**
```python
s = "a", p = ""

Initialization:
prev = [T]  ← Only one element
curr = [F]  ← Will stay False

Iteration i=1:
  curr[0] = False
  No j iterations (n=0)
  
Swap: prev = [F]
Return prev[0] = False ✓
```

**3. Long String, Short Pattern:**
```python
s = "aaaa", p = "a*"

Space used: 2 × 3 = 6 cells
Vs 2D DP: 5 × 3 = 15 cells
Savings: 60%
```

### Comparison with Other Approaches

| Aspect | 2D DP | 2-Row DP | Recursion+Memo |
|--------|-------|----------|----------------|
| **Time** | O(m×n) | O(m×n) | O(m×n) |
| **Space** | O(m×n) | O(n) | O(m×n) |
| **Intuitive** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Debug** | Easy (print table) | Medium | Hard (call stack) |
| **Code** | Simple | Medium | Simple |
| **Memory** | High | Low | High (stack+memo) |

### When to Use This Approach

**Use 2-Row Optimization When:**
- ✓ Space is a constraint
- ✓ m >> n (string much longer than pattern)
- ✓ Already have working 2D DP solution
- ✓ Don't need to debug by printing table

**Don't Use When:**
- ✗ Need to trace back solution path
- ✗ Debugging complex logic
- ✗ Space is not a concern
- ✗ Code clarity is more important

### Optimization Potential

**Can We Do Better?**

```
Current: O(n) space with 2 rows

Can we use 1 row?
  ✗ No, we need prev[j] and prev[j-1]
  ✗ If we overwrite prev, we lose information
  
Can we use O(1) space?
  ✗ No, we need to store n values
  ✗ Each position depends on multiple previous positions
  
Conclusion: O(n) is optimal for this approach
```

**Alternative: Optimize for Pattern Length**
```python
# If m < n, we can swap roles:
if len(s) < len(p):
    # Use O(m) space instead of O(n)
    # Iterate over pattern, track string states
    # More complex but saves space when m << n
```

---

## Approach Comparison Summary

### Quick Reference

| Approach | Time | Space | Difficulty | Best For |
|----------|------|-------|------------|----------|
| **1. Bottom-Up DP** | O(m×n) | O(m×n) | ⭐⭐ | Learning, Debugging |
| **2. Top-Down Recursion** | O(m×n) | O(m×n) | ⭐⭐ | Intuitive thinking |
| **3. Space-Optimized** | O(m×n) | O(n) | ⭐⭐⭐ | Memory constraints |

### Detailed Comparison

**Approach 1: Bottom-Up DP ⭐⭐⭐**
```python
Pros:
+ Easy to visualize (print table)
+ Straightforward logic
+ No recursion overhead
+ Good for learning DP

Cons:
- Uses O(m×n) space
- Computes all states (even if not needed)

Best for:
- First implementation
- Understanding the problem
- Debugging
```

**Approach 2: Top-Down Recursion ⭐⭐⭐**
```python
Pros:
+ Natural recursive thinking
+ Only computes needed states
+ Easy to understand logic flow
+ Matches problem structure

Cons:
- Recursion stack overhead
- Uses O(m×n) space for memo
- Harder to debug

Best for:
- Intuitive solution
- When not all states needed
- Recursive thinkers
```

**Approach 3: Space-Optimized ⭐⭐**
```python
Pros:
+ Saves space: O(n) instead of O(m×n)
+ Same time complexity
+ Good for large inputs

Cons:
- More complex code
- Harder to debug
- Can't trace back solution
- Need to understand 2D DP first

Best for:
- Memory-constrained environments
- After mastering 2D DP
- Production code with large inputs
```

### Which Approach to Choose?

**For Interviews:**
```
1. Start with Approach 1 (2D DP)
   - Explain the logic clearly
   - Show the DP table
   
2. Mention Approach 2 (Recursion)
   - "Could also solve recursively"
   - Show you understand both paradigms
   
3. Optimize to Approach 3 (2-Row)
   - "Can optimize space to O(n)"
   - Shows optimization skills
```

**For Production:**
```
If space is critical:
  → Use Approach 3 (2-Row)
  
If clarity is critical:
  → Use Approach 1 (2D DP)
  
If inputs are small:
  → Any approach works
  
If need to debug often:
  → Use Approach 1 (2D DP)
```

---

## Pattern Recognition

### When to Recognize This Pattern

**Problem Characteristics:**
```
✓ String matching with wildcards
✓ Pattern has special characters (*, ., ?)
✓ Need to match ENTIRE string
✓ Multiple ways to match (try all possibilities)
✓ Optimal substructure (subproblems overlap)
```

**Key Indicators:**
- "Match pattern with wildcards"
- "* matches zero or more"
- "? matches any single character"
- "Return true if entire string matches"
- "Implement regex matching"

### Similar Problems

**1. Wildcard Matching (LeetCode #44)**
```
Similarity: Pattern matching with wildcards
Difference: 
  - * matches any sequence (not just preceding char)
  - ? matches any single character (like .)
  
Example:
  s = "adceb", p = "*a*b"
  * can match any sequence
  
Approach: Same DP logic, different * handling
```

**2. Edit Distance (LeetCode #72)**
```
Similarity: 2D DP on two strings
Difference:
  - Count operations (insert/delete/replace)
  - No wildcards
  
DP Table:
  dp[i][j] = min operations to convert s[0:i] to t[0:j]
  
Pattern: String transformation DP
```

**3. Longest Common Subsequence (LeetCode #1143)**
```
Similarity: 2D DP comparing two strings
Difference:
  - Find longest common subsequence
  - No wildcards
  
DP Table:
  dp[i][j] = LCS length of s[0:i] and t[0:j]
  
Pattern: String comparison DP
```

**4. Distinct Subsequences (LeetCode #115)**
```
Similarity: Match string with pattern
Difference:
  - Count number of ways
  - No wildcards
  
DP Table:
  dp[i][j] = ways to match s[0:i] with t[0:j]
  
Pattern: Counting DP
```

**5. Interleaving String (LeetCode #97)**
```
Similarity: 2D DP on strings
Difference:
  - Check if s3 is interleaving of s1 and s2
  - No wildcards
  
DP Table:
  dp[i][j] = can s3[0:i+j] be formed from s1[0:i] and s2[0:j]
  
Pattern: String combination DP
```

### Pattern Template

**Generic Wildcard Matching Template:**

```python
def wildcardMatch(s: str, p: str) -> bool:
    m, n = len(s), len(p)
    dp = [[False] * (n + 1) for _ in range(m + 1)]
    
    # Base case
    dp[0][0] = True
    
    # Initialize first row (empty string matching pattern)
    for j in range(1, n + 1):
        if p[j-1] == '*':  # Or other wildcard logic
            dp[0][j] = dp[0][j-1]  # Or dp[0][j-2] for regex
    
    # Fill table
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if p[j-1] == '*':
                # Wildcard logic (problem-specific)
                dp[i][j] = dp[i][j-1] or dp[i-1][j]
            elif p[j-1] == '.' or p[j-1] == s[i-1]:
                # Match current character
                dp[i][j] = dp[i-1][j-1]
    
    return dp[m][n]
```

**Recursive Template:**

```python
def wildcardMatch(s: str, p: str) -> bool:
    memo = {}
    
    def dp(i: int, j: int) -> bool:
        if (i, j) in memo:
            return memo[(i, j)]
        
        # Base cases
        if j == len(p):
            return i == len(s)
        
        # Check current match
        first_match = i < len(s) and (p[j] == s[i] or p[j] == '.')
        
        # Handle wildcards (problem-specific)
        if j + 1 < len(p) and p[j + 1] == '*':
            result = dp(i, j + 2) or (first_match and dp(i + 1, j))
        else:
            result = first_match and dp(i + 1, j + 1)
        
        memo[(i, j)] = result
        return result
    
    return dp(0, 0)
```

---

## Related Concepts

### 1. Dynamic Programming Paradigms

**Bottom-Up (Tabulation):**
```
Characteristics:
- Build from base cases up
- Iterative approach
- Fill table systematically
- Easy to visualize

When to use:
- Need all subproblem solutions
- Want to avoid recursion overhead
- Easy to optimize space
```

**Top-Down (Memoization):**
```
Characteristics:
- Start from problem, recurse down
- Recursive approach
- Compute only needed states
- Natural problem decomposition

When to use:
- Not all states needed
- Recursive thinking is natural
- Problem has clear recursive structure
```

### 2. State Space Design

**Choosing State Variables:**
```
For this problem:
  State = (i, j)
  i = position in string s
  j = position in pattern p
  
Why these states?
  - Uniquely identify subproblem
  - Sufficient to make decision
  - Lead to optimal substructure
```

**State Transition:**
```
From state (i, j), we can go to:
  - (i+1, j+1): Match current, move both
  - (i, j+2): Skip pattern (with *)
  - (i+1, j): Use * multiple times
  
Transitions depend on:
  - Current characters
  - Presence of wildcards
  - Match conditions
```

### 3. Greedy vs DP

**Why Greedy Fails:**
```
Example: s = "aaa", p = "a*a"

Greedy approach:
  "Use * as many times as possible"
  a* matches "aaa"
  Then 'a' has nothing to match
  Result: False ✗
  
Correct approach:
  Try both options:
    1. a* matches "aa", then 'a' matches "a" ✓
    2. a* matches "aaa", then 'a' fails ✗
  Result: True (option 1 works)
  
Lesson: Need to try all possibilities (DP)
```

**When Greedy Works:**
```
Problems where:
- Local optimal = global optimal
- No need to backtrack
- One clear best choice at each step

Examples:
- Activity selection
- Huffman coding
- Dijkstra's algorithm
```

### 4. Space Optimization Techniques

**Rolling Array:**
```python
# Instead of full 2D array
dp = [[False] * n for _ in range(m)]

# Use 2 rows
prev = [False] * n
curr = [False] * n

# Swap after each iteration
prev, curr = curr, prev
```

**In-Place Modification:**
```python
# For some problems, can update array in-place
# Not applicable here (need previous values)
```

**State Compression:**
```python
# For some problems, can encode state in bits
# Example: Traveling Salesman with bitmask DP
```

---

## Common Mistakes & How to Avoid

### Mistake 1: Confusing `*` Semantics

**Wrong Understanding:**
```
"* matches zero or more of ANY character"

Example: "a*" matches "abc" ✗
```

**Correct Understanding:**
```
"* matches zero or more of PRECEDING character"

Example: "a*" matches "aaa" ✓
Example: "a*" matches "" ✓
Example: "a*" matches "b" ✗
```

**How to Avoid:**
- Always look at p[j-2] when handling `*`
- Remember: `*` is paired with preceding char

### Mistake 2: Index Off-by-One Errors

**Wrong:**
```python
if p[j] == '*':  # Should be p[j-1]
    prev_char = p[j-1]  # Should be p[j-2]
```

**Correct:**
```python
if p[j-1] == '*':  # dp[j] represents p[0:j]
    prev_char = p[j-2]  # Character before *
```

**How to Avoid:**
- Remember: dp[i][j] uses s[i-1] and p[j-1]
- Draw a diagram showing index mapping
- Test with small examples

### Mistake 3: Forgetting Base Cases

**Wrong:**
```python
dp[0][0] = True
# Missing: patterns like "a*b*" can match empty string
```

**Correct:**
```python
dp[0][0] = True
for j in range(2, n + 1):
    if p[j-1] == '*':
        dp[0][j] = dp[0][j-2]
```

**How to Avoid:**
- Think about empty string cases
- Test with s="", p="a*b*"
- Initialize first row/column carefully

### Mistake 4: Using AND Instead of OR

**Wrong:**
```python
if p[j-1] == '*':
    dp[i][j] = dp[i][j-2] and dp[i-1][j]  # Wrong!
```

**Correct:**
```python
if p[j-1] == '*':
    dp[i][j] = dp[i][j-2] or (match and dp[i-1][j])
```

**Why:**
- We succeed if EITHER option works
- Don't need BOTH to be true
- OR explores all possible paths

**How to Avoid:**
- Think: "Does ANY path lead to success?"
- Remember: Multiple ways to match
- Test with examples that need both options

### Mistake 5: Not Checking Bounds

**Wrong:**
```python
first_match = (p[j] == s[i] or p[j] == '.')
# Crashes if i >= len(s)
```

**Correct:**
```python
first_match = i < len(s) and (p[j] == s[i] or p[j] == '.')
```

**How to Avoid:**
- Always check array bounds first
- Use short-circuit evaluation
- Test with empty strings

---

## Optimization Techniques

### 1. Early Termination

```python
def isMatch(self, s: str, p: str) -> bool:
    # Quick checks
    if not p:
        return not s
    
    # If pattern has no *, lengths must match (with .)
    if '*' not in p:
        if len(s) != len(p):
            return False
    
    # Continue with DP...
```

### 2. Pattern Preprocessing

```python
def isMatch(self, s: str, p: str) -> bool:
    # Remove consecutive * patterns
    # "a**" is same as "a*"
    # "a*a*" can be simplified
    
    # Precompute which pattern positions have *
    has_star = [False] * len(p)
    for i in range(len(p)):
        if p[i] == '*':
            has_star[i] = True
    
    # Continue with DP...
```

### 3. Memoization with Tuple Keys

```python
# Instead of dictionary
memo = {}

# Use tuple for faster hashing
memo[(i, j)] = result

# Or use 2D array if indices are small
memo = [[None] * n for _ in range(m)]
```

### 4. Space Optimization

```python
# Already covered: Use 2 rows instead of full table
# Further: Use 1D array if possible (not for this problem)
```

---

## Test Cases & Edge Cases

### Comprehensive Test Suite

```python
test_cases = [
    # Basic cases
    ("aa", "a", False),
    ("aa", "a*", True),
    ("ab", ".*", True),
    
    # Empty string
    ("", "", True),
    ("", "a*", True),
    ("", "a*b*", True),
    ("", "a*b*c*", True),
    ("", "a", False),
    
    # Empty pattern
    ("a", "", False),
    
    # Single character
    ("a", "a", True),
    ("a", ".", True),
    ("a", "b", False),
    
    # Dot wildcard
    ("ab", "..", True),
    ("ab", ".", False),
    ("a", "..", False),
    
    # Star wildcard
    ("aaa", "a*", True),
    ("aaa", "a*a", True),
    ("aaa", "ab*a*c*a", True),
    
    # Combined wildcards
    ("aab", "c*a*b", True),
    ("mississippi", "mis*is*p*.", False),
    ("mississippi", "mis*is*ip*.", True),
    
    # Pattern longer than string
    ("a", "ab*", True),
    ("a", "ab*c*", True),
    ("a", "ab*c*d*", True),
    
    # String longer than pattern
    ("aaa", "a*", True),
    ("aaa", ".*", True),
    
    # Multiple stars
    ("aaa", "a*a*a*", True),
    ("", "a*b*c*", True),
    
    # Complex patterns
    ("aaa", "aaaa", False),
    ("aaa", "a*aa", True),
    ("ab", ".*c", False),
    ("aab", "c*a*b", True),
    
    # Edge cases
    ("a", ".*..a*", False),
    ("ab", ".*..c*", True),
    ("aaa", "ab*ac*a", True),
]

def run_tests():
    sol = Solution()
    passed = 0
    failed = 0
    
    for s, p, expected in test_cases:
        result = sol.isMatch(s, p)
        if result == expected:
            passed += 1
            print(f"✓ s='{s}', p='{p}' => {result}")
        else:
            failed += 1
            print(f"✗ s='{s}', p='{p}' => {result} (expected {expected})")
    
    print(f"\nPassed: {passed}/{len(test_cases)}")
    print(f"Failed: {failed}/{len(test_cases)}")
```

### Edge Case Categories

**1. Empty Inputs:**
```python
("", "")         → True
("", "a*")       → True
("", "a*b*c*")   → True
("a", "")        → False
```

**2. Single Characters:**
```python
("a", "a")       → True
("a", ".")       → True
("a", "b")       → False
("a", "a*")      → True
```

**3. Pattern Longer:**
```python
("a", "ab*")     → True  (b* = 0 b's)
("a", "ab*c*")   → True  (b*c* = 0 chars)
```

**4. String Longer:**
```python
("aaa", "a*")    → True  (a* = 3 a's)
("aaa", ".*")    → True  (.* = any 3 chars)
```

**5. No Match Possible:**
```python
("aa", "a")      → False (need 2 chars)
("ab", "a")      → False (b doesn't match)
("a", "b*")      → False (b* can't match 'a')
```

---

## Day 53 Summary

### Problem: Regular Expression Matching

**Difficulty:** Hard 🔴

**Core Concept:** Dynamic Programming on two strings with wildcard matching

**Key Insights:**
1. `*` operates on **preceding character**, not itself
2. Two choices with `*`: use 0 times or 1+ times
3. Use **OR logic** to try both possibilities
4. DP table: `dp[i][j]` = does `s[0:i]` match `p[0:j]`
5. Base case: empty string can match patterns with `*`

**Three Approaches:**

| Approach | Time | Space | Difficulty | Best For |
|----------|------|-------|------------|----------|
| Bottom-Up DP | O(m×n) | O(m×n) | ⭐⭐ | Learning, Debugging |
| Top-Down Recursion | O(m×n) | O(m×n) | ⭐⭐ | Intuitive thinking |
| Space-Optimized | O(m×n) | O(n) | ⭐⭐⭐ | Memory constraints |

**Pattern Recognition:**
- String matching with wildcards
- Multiple ways to match (try all)
- Optimal substructure
- Overlapping subproblems

**Related Problems:**
- Wildcard Matching (LeetCode #44)
- Edit Distance (LeetCode #72)
- Longest Common Subsequence (LeetCode #1143)
- Distinct Subsequences (LeetCode #115)

**Common Mistakes:**
1. Confusing `*` semantics (it's for preceding char)
2. Index off-by-one errors (dp[i][j] uses s[i-1])
3. Forgetting base cases (patterns can match empty string)
4. Using AND instead of OR (need ANY path to work)
5. Not checking bounds (i < len(s) before s[i])

**Key Takeaways:**
- ⭐ `*` always looks back at preceding character
- ⭐ Try both options: use `*` zero times OR one+ times
- ⭐ OR logic explores all possible matching paths
- ⭐ DP table indices offset by 1 from string indices
- ⭐ Space can be optimized from O(m×n) to O(n)

**Interview Tips:**
1. Start with examples to understand `*` behavior
2. Draw DP table for small example
3. Explain base cases clearly
4. Code bottom-up DP first (clearer)
5. Mention space optimization if time permits
6. Test with edge cases (empty string, pattern)

**Time Spent:** Understanding wildcards (15 min) + DP design (20 min) + Implementation (25 min) = ~60 min

**Difficulty Rating:** 8/10
- Complex wildcard semantics
- Multiple edge cases
- Requires careful index management
- But follows standard DP pattern once understood

---

## Quick Reference

### Bottom-Up DP Template

```python
def isMatch(s: str, p: str) -> bool:
    m, n = len(s), len(p)
    dp = [[False] * (n + 1) for _ in range(m + 1)]
    
    dp[0][0] = True
    for j in range(2, n + 1):
        if p[j-1] == '*':
            dp[0][j] = dp[0][j-2]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if p[j-1] == '*':
                dp[i][j] = dp[i][j-2]
                if p[j-2] == s[i-1] or p[j-2] == '.':
                    dp[i][j] = dp[i][j] or dp[i-1][j]
            elif p[j-1] == '.' or p[j-1] == s[i-1]:
                dp[i][j] = dp[i-1][j-1]
    
    return dp[m][n]
```

### Top-Down Recursion Template

```python
def isMatch(s: str, p: str) -> bool:
    memo = {}
    
    def dp(i, j):
        if (i, j) in memo:
            return memo[(i, j)]
        if j == len(p):
            return i == len(s)
        
        first_match = i < len(s) and (p[j] == s[i] or p[j] == '.')
        
        if j + 1 < len(p) and p[j+1] == '*':
            result = dp(i, j+2) or (first_match and dp(i+1, j))
        else:
            result = first_match and dp(i+1, j+1)
        
        memo[(i, j)] = result
        return result
    
    return dp(0, 0)
```

### Space-Optimized Template

```python
def isMatch(s: str, p: str) -> bool:
    m, n = len(s), len(p)
    prev = [False] * (n + 1)
    curr = [False] * (n + 1)
    
    prev[0] = True
    for j in range(2, n + 1):
        if p[j-1] == '*':
            prev[j] = prev[j-2]
    
    for i in range(1, m + 1):
        curr[0] = False
        for j in range(1, n + 1):
            if p[j-1] == '*':
                curr[j] = curr[j-2]
                if p[j-2] == s[i-1] or p[j-2] == '.':
                    curr[j] = curr[j] or prev[j]
            elif p[j-1] == '.' or p[j-1] == s[i-1]:
                curr[j] = prev[j-1]
            else:
                curr[j] = False
        prev, curr = curr, prev
    
    return prev[n]
```

---

**End of Day 53 Notes**

*Master this problem and you'll understand:*
- *Advanced DP on two strings*
- *Wildcard matching patterns*
- *Space optimization techniques*
- *Recursive vs iterative DP*
- *Complex state transitions*
