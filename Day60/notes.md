# Day 60: Generate Parentheses

## Problem Statement
**LeetCode 22: Generate Parentheses**

Given n pairs of parentheses, write a function to generate **all combinations** of well-formed parentheses.

**Examples:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]

Input: n = 1
Output: ["()"]

Input: n = 2
Output: ["(())","()()"]
```

**Constraints:**
- 1 <= n <= 8

---

## Problem Logic & Reasoning

### Core Concept
Generate all **valid** combinations of n pairs of parentheses using **backtracking**.

**Key Insight:** At each step, we can add '(' or ')' based on certain rules to ensure validity.

### What Makes Parentheses Valid?

```
Valid:
✓ "()"
✓ "(())"
✓ "()()"
✓ "((()))"

Invalid:
✗ ")("      - Close before open
✗ "((("     - Too many open
✗ ")))"     - Too many close
✗ "(()"     - Unmatched open
✗ "())"     - Unmatched close

Rules for validity:
1. Number of '(' must equal number of ')'
2. At any point, number of ')' cannot exceed number of '('
3. Total pairs must equal n
```

### Visual Understanding for n=2

```
All possible combinations (without rules):
"(((("  ✗ - Too many open
"((())" ✗ - Unmatched
"(())"  ✓ - Valid!
"(()(" ✗ - Unmatched
"()()"  ✓ - Valid!
"()()(" ✗ - Too many open
...

Valid combinations only:
1. "(())"
2. "()()"

Total: 2 valid combinations
```

### The Backtracking Tree for n=2

```
Start: ""
├─ Add '(' → "("
│  ├─ Add '(' → "(("
│  │  └─ Add ')' → "(()"
│  │     └─ Add ')' → "(())" ✓ Valid!
│  └─ Add ')' → "()"
│     └─ Add '(' → "()("
│        └─ Add ')' → "()()" ✓ Valid!

Rules applied:
- Can add '(' if open_count < n
- Can add ')' if close_count < open_count
- Stop when open_count == close_count == n
```

### Breaking Down the Rules

```
Rule 1: Can add '(' if open_count < n
  Why? We need exactly n opening brackets
  
  Example: n=2
  "((" → Can't add more '(' (already have 2)

Rule 2: Can add ')' if close_count < open_count
  Why? Can't close more than we've opened
  
  Example: 
  "(" → Can add ')' (close_count=0 < open_count=1)
  ")(" → Invalid! (tried to close before opening)

Rule 3: Stop when open_count == close_count == n
  Why? We have a complete valid combination
  
  Example: n=2
  "(())" → open=2, close=2 → Done! ✓
```

### The Catalan Number Connection

```
Number of valid combinations for n pairs:
n=1: 1 combination
n=2: 2 combinations
n=3: 5 combinations
n=4: 14 combinations
n=5: 42 combinations

This follows the Catalan number sequence!
C(n) = (2n)! / ((n+1)! * n!)

For n=3: C(3) = 6! / (4! * 3!) = 720 / (24 * 6) = 5 ✓
```

---

## Approach: Backtracking ⭐⭐⭐⭐⭐

### Logic
Use backtracking to build valid combinations:
1. Start with empty string
2. At each step, try adding '(' or ')'
3. Add '(' if we haven't used all n opening brackets
4. Add ')' if it won't exceed number of '(' used
5. When we have n pairs, add to result
6. Backtrack and try other possibilities

### Visual Flow for n=3

```
Decision Tree (showing first few branches):

""
├─ "(" (open=1, close=0)
│  ├─ "((" (open=2, close=0)
│  │  ├─ "(((" (open=3, close=0)
│  │  │  ├─ "((()" (open=3, close=1)
│  │  │  │  ├─ "((())" (open=3, close=2)
│  │  │  │  │  └─ "((()))" ✓ (open=3, close=3) VALID!
│  │  │  └─ Can't add '(' (already have 3)
│  │  └─ "(()" (open=2, close=1)
│  │     ├─ "(()(" (open=3, close=1)
│  │     │  ├─ "(()()" (open=3, close=2)
│  │     │  │  └─ "(()())" ✓ (open=3, close=3) VALID!
│  │     └─ "(())" (open=2, close=2)
│  │        └─ "(())) " (open=3, close=2)
│  │           └─ "(())()" ✓ (open=3, close=3) VALID!
│  └─ "()" (open=1, close=1)
│     └─ "()(" (open=2, close=1)
│        ... (continues)

Total valid combinations: 5
["((()))","(()())","(())()","()(())","()()()"]
```

### Detailed Step-by-Step for n=2

```
Call 1: backtrack(open=0, close=0, current="")
  Can add '('? Yes (0 < 2)
  → Call 2: backtrack(1, 0, "(")

Call 2: backtrack(open=1, close=0, current="(")
  Can add '('? Yes (1 < 2)
  → Call 3: backtrack(2, 0, "((")
  
Call 3: backtrack(open=2, close=0, current="((")
  Can add '('? No (2 == 2)
  Can add ')'? Yes (0 < 2)
  → Call 4: backtrack(2, 1, "(()")

Call 4: backtrack(open=2, close=1, current="(()")
  Can add '('? No (2 == 2)
  Can add ')'? Yes (1 < 2)
  → Call 5: backtrack(2, 2, "(())")

Call 5: backtrack(open=2, close=2, current="(())")
  open == close == n? Yes!
  Add "(())" to result ✓
  Return

Back to Call 4: Done exploring
Back to Call 3: Done exploring
Back to Call 2:
  Can add ')'? Yes (0 < 1)
  → Call 6: backtrack(1, 1, "()")

Call 6: backtrack(open=1, close=1, current="()")
  Can add '('? Yes (1 < 2)
  → Call 7: backtrack(2, 1, "()("

Call 7: backtrack(open=2, close=1, current="()(")
  Can add '('? No (2 == 2)
  Can add ')'? Yes (1 < 2)
  → Call 8: backtrack(2, 2, "()()")

Call 8: backtrack(open=2, close=2, current="()()")
  open == close == n? Yes!
  Add "()()" to result ✓
  Return

Final result: ["(())", "()()"]
```

### The Backtracking Pattern

```
Backtracking template:
1. Base case: If solution is complete, add to result
2. For each choice:
   a. Make choice (add '(' or ')')
   b. Recurse with new state
   c. Undo choice (implicit in recursion)

In this problem:
- Choice 1: Add '(' (if open_count < n)
- Choice 2: Add ')' (if close_count < open_count)
- Base case: open_count == close_count == n
```

### Why This Works

```
Key observations:
1. We never add ')' before '('
   → close_count < open_count ensures this

2. We never add too many '(' or ')'
   → open_count < n and close_count < n ensure this

3. We explore all valid paths
   → Backtracking tries all possibilities

4. We only save complete valid combinations
   → Base case checks open_count == close_count == n
```

### Pseudocode
```
function generateParenthesis(n):
    result = []
    
    function backtrack(open_count, close_count, current_string):
        // Base case: Complete valid combination
        if open_count == n and close_count == n:
            result.append(current_string)
            return
        
        // Choice 1: Add opening bracket
        if open_count < n:
            backtrack(open_count + 1, close_count, current_string + "(")
        
        // Choice 2: Add closing bracket
        if close_count < open_count:
            backtrack(open_count, close_count + 1, current_string + ")")
    
    backtrack(0, 0, "")
    return result
```

### Implementation
```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        
        def backtrack(open_count, close_count, current_string):
            # Base case: Complete combination
            if open_count == close_count == n:
                result.append(current_string)
                return
            
            # Add '(' if we can
            if open_count < n:
                backtrack(open_count + 1, close_count, current_string + "(")
            
            # Add ')' if valid
            if close_count < open_count:
                backtrack(open_count, close_count + 1, current_string + ")")
        
        backtrack(0, 0, "")
        return result
```

### Complexity Analysis
- **Time:** O(4^n / √n) - Catalan number, approximately exponential
- **Space:** O(n) - Recursion stack depth (at most 2n calls deep)

### Why Time Complexity is O(4^n / √n)?

```
Upper bound analysis:
- At each step, we have at most 2 choices
- Maximum depth is 2n (n opens + n closes)
- Naive bound: O(2^(2n)) = O(4^n)

But many paths are pruned by our rules!

Actual number of valid combinations:
- Catalan number: C(n) = (2n)! / ((n+1)! * n!)
- Asymptotic: C(n) ≈ 4^n / (n^(3/2) * √π)
- Simplified: O(4^n / √n)

For n=8 (max constraint):
- Naive: 4^8 = 65,536 paths
- Actual: C(8) = 1,430 valid combinations
- Pruning saves 98% of work!
```

---

## Alternative Approaches

### Approach 2: Using List Instead of String Concatenation

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        
        def backtrack(open_count, close_count, path):
            if open_count == close_count == n:
                result.append(''.join(path))
                return
            
            if open_count < n:
                path.append('(')
                backtrack(open_count + 1, close_count, path)
                path.pop()  # Backtrack
            
            if close_count < open_count:
                path.append(')')
                backtrack(open_count, close_count + 1, path)
                path.pop()  # Backtrack
        
        backtrack(0, 0, [])
        return result
```

**Why use list?**
```
String concatenation: O(n) per operation
  current_string + "(" creates new string

List append/pop: O(1) per operation
  path.append('(') modifies in place

For n=8:
  String: ~1,430 * 16 = 22,880 character operations
  List: ~1,430 * 1 = 1,430 operations

List is more efficient!
```

### Approach 3: Iterative with Stack (BFS-style)

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        # Stack stores: (current_string, open_count, close_count)
        stack = [("", 0, 0)]
        
        while stack:
            current, open_count, close_count = stack.pop()
            
            # Base case
            if open_count == close_count == n:
                result.append(current)
                continue
            
            # Add '('
            if open_count < n:
                stack.append((current + "(", open_count + 1, close_count))
            
            # Add ')'
            if close_count < open_count:
                stack.append((current + ")", open_count, close_count + 1))
        
        return result
```

**Pros and Cons:**
```
Recursive (Approach 1):
✓ More intuitive
✓ Cleaner code
✗ Stack overflow risk (but n ≤ 8, so safe)

Iterative (Approach 3):
✓ No recursion stack
✓ Easier to debug (can print stack)
✗ More verbose
✗ Less intuitive
```

---

## Detailed Visualizations

### Complete Tree for n=2

```
                    ""
                    |
                   "("
                  /   \
               "(("     "()"
                |        |
              "(()"    "()("
                |        |
             "(())"✓  "()()"✓

Legend:
✓ = Valid combination (added to result)
Each level represents one character added
```

### State Space Exploration for n=3

```
Level 0: ""
         open=0, close=0

Level 1: "("
         open=1, close=0

Level 2: "((" or "()"
         open=2,close=0  open=1,close=1

Level 3: "(((" or "(()" or "()(" or "()"
         ...

Level 6: All strings of length 6
         Only valid ones added to result

Total levels: 2n = 6
Valid combinations: 5
```

### Pruning Visualization

```
Without pruning (generate all 2^6 = 64 combinations):
"((((((", "((((())", "(((()(", ... (64 total)

With pruning (only valid paths):
At "(((": Can't add more '(' (already 3)
At ")": Can't start with ')' (no matching '(')
At "())": Can't add ')' (would exceed '(')

Result: Only 5 valid combinations generated
Pruning efficiency: 92% reduction!
```

---

## Complete Example Walkthrough: n=3

```
Starting: backtrack(0, 0, "")

Branch 1: Add '('
  backtrack(1, 0, "(")
  
  Branch 1.1: Add '('
    backtrack(2, 0, "((")
    
    Branch 1.1.1: Add '('
      backtrack(3, 0, "(((")
      
      Branch 1.1.1.1: Add ')'
        backtrack(3, 1, "((()") 
        
        Branch 1.1.1.1.1: Add ')'
          backtrack(3, 2, "((())") 
          
          Branch 1.1.1.1.1.1: Add ')'
            backtrack(3, 3, "((()))") 
            ✓ Result: ["((()))"]
            
    Branch 1.1.2: Add ')'
      backtrack(2, 1, "(()")
      
      Branch 1.1.2.1: Add '('
        backtrack(3, 1, "(()(")
        
        Branch 1.1.2.1.1: Add ')'
          backtrack(3, 2, "(()()") 
          
          Branch 1.1.2.1.1.1: Add ')'
            backtrack(3, 3, "(()())") 
            ✓ Result: ["((()))", "(()())"]
            
      Branch 1.1.2.2: Add ')'
        backtrack(2, 2, "(())")
        
        Branch 1.1.2.2.1: Add '('
          backtrack(3, 2, "((())") 
          
          Branch 1.1.2.2.1.1: Add ')'
            backtrack(3, 3, "(())()") 
            ✓ Result: ["((()))", "(()())", "(())()"]
            
  Branch 1.2: Add ')'
    backtrack(1, 1, "()")
    
    Branch 1.2.1: Add '('
      backtrack(2, 1, "()(")
      
      Branch 1.2.1.1: Add '('
        backtrack(3, 1, "()((")
        
        Branch 1.2.1.1.1: Add ')'
          backtrack(3, 2, "()(()") 
          
          Branch 1.2.1.1.1.1: Add ')'
            backtrack(3, 3, "()(())") 
            ✓ Result: ["((()))", "(()())", "(())()", "()(())"]
            
      Branch 1.2.1.2: Add ')'
        backtrack(2, 2, "()()")
        
        Branch 1.2.1.2.1: Add '('
          backtrack(3, 2, "()()()") 
          
          Branch 1.2.1.2.1.1: Add ')'
            backtrack(3, 3, "()()()") 
            ✓ Result: ["((()))", "(()())", "(())()", "()(())", "()()()"]

Final Result: ["((()))", "(()())", "(())()", "()(())", "()()()"]
```

---

## Pattern Recognition: Backtracking Template

```
General backtracking pattern:

def backtrack(state, choices):
    if is_solution(state):
        add_to_result(state)
        return
    
    for choice in get_valid_choices(state):
        make_choice(state, choice)
        backtrack(new_state, choices)
        undo_choice(state, choice)  # Optional if using immutable state

For Generate Parentheses:
- State: (open_count, close_count, current_string)
- Choices: ['(', ')']
- Valid choices:
  - '(' if open_count < n
  - ')' if close_count < open_count
- Solution: open_count == close_count == n
```

---

## Comparison: All Valid Combinations

```
n=1: 1 combination
["()"]

n=2: 2 combinations
["(())", "()()"]

n=3: 5 combinations
["((()))", "(()())", "(())()", "()(())", "()()()"]

n=4: 14 combinations
["(((())))", "((()()))", "((())())", "((()))()", "(()(()))",
 "(()()())", "(()())()", "(())(())", "(())()()", "()((()))",
 "()(()())", "()(())()", "()()(())", "()()()()"]

Pattern: Catalan numbers (1, 1, 2, 5, 14, 42, 132, 429, ...)
```

---

## Why Backtracking Works Here

```
Problem characteristics:
1. Need to generate ALL solutions
   → Backtracking explores all paths

2. Have clear constraints
   → open_count < n
   → close_count < open_count

3. Can prune invalid paths early
   → Don't explore paths that violate constraints

4. Solution space is tree-structured
   → Each choice leads to new state

5. Need to build solution incrementally
   → Add one character at a time

All these make backtracking ideal!
```

---

## Optimization: Early Termination

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        
        def backtrack(open_count, close_count, current):
            # Early termination: Can't possibly form valid combination
            if close_count > open_count:
                return  # Invalid state
            
            if open_count > n:
                return  # Too many opens
            
            # Base case
            if open_count == close_count == n:
                result.append(current)
                return
            
            # Try adding '('
            backtrack(open_count + 1, close_count, current + "(")
            
            # Try adding ')'
            backtrack(open_count, close_count + 1, current + ")")
        
        backtrack(0, 0, "")
        return result
```

**Note:** The checks `close_count > open_count` and `open_count > n` are redundant with our if conditions, but make the logic more explicit.

---

## Critical Insights

### 1. The Two Key Rules

```
Rule 1: open_count < n
  Why? We need exactly n opening brackets
  
  Example: n=2
  "((" → Can add '(' (open_count=2 < 2? No!)
  "(" → Can add '(' (open_count=1 < 2? Yes!)

Rule 2: close_count < open_count
  Why? Can't close more than we've opened
  
  Example:
  "(" → Can add ')' (close_count=0 < open_count=1? Yes!)
  ")(" → Invalid! (tried close_count=1 when open_count=0)
  
These two rules guarantee validity!
```

### 2. Why Backtracking (Not Iteration)?

```
Could we use iteration?

Attempt 1: Generate all 2^(2n) strings
  For n=3: 2^6 = 64 strings
  Then filter valid ones
  → Too slow! O(2^(2n) * n)

Attempt 2: Use dynamic programming
  Build from smaller n to larger n
  → Possible but complex

Backtracking:
  Only generates valid combinations
  Prunes invalid paths early
  → Optimal for this problem!
```

### 3. Order of Recursive Calls Matters

```
Current implementation:
  if open_count < n:
      backtrack(open_count + 1, ...)  # Try '(' first
  if close_count < open_count:
      backtrack(..., close_count + 1)  # Then try ')'

This gives lexicographically sorted output:
["((()))", "(()())", "(())()", "()(())", "()()()"]

If we swap the order:
  if close_count < open_count:
      backtrack(..., close_count + 1)  # Try ')' first
  if open_count < n:
      backtrack(open_count + 1, ...)  # Then try '('

Output would be different order (but same combinations)
```

### 4. String vs List Performance

```
String concatenation:
  current + "(" creates new string
  Time: O(n) per operation
  Total: O(n * number_of_calls)

List append/pop:
  path.append('(') modifies in place
  Time: O(1) per operation
  Total: O(number_of_calls)

For n=8:
  String: ~23,000 operations
  List: ~1,400 operations
  
List is 16x faster!
```

### 5. The Catalan Number Connection

```
Number of valid combinations = C(n)
C(n) = (2n)! / ((n+1)! * n!)

This is the nth Catalan number!

Catalan numbers appear in:
- Valid parentheses combinations
- Number of binary trees with n nodes
- Number of ways to triangulate a polygon
- Number of paths in a grid (not crossing diagonal)

All these problems have similar structure!
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Base Case

```python
# Wrong: Checking only length
if len(current) == 2 * n:
    result.append(current)

# Problem: Might add invalid combinations like "((("

# Correct: Check both counts
if open_count == close_count == n:
    result.append(current)
```

### ❌ Mistake 2: Wrong Condition for Adding ')'

```python
# Wrong: Checking against n
if close_count < n:
    backtrack(open_count, close_count + 1, current + ")")

# Problem: Allows ")(" - close before open!

# Correct: Check against open_count
if close_count < open_count:
    backtrack(open_count, close_count + 1, current + ")")
```

### ❌ Mistake 3: Not Passing Updated Counts

```python
# Wrong: Not incrementing counts
if open_count < n:
    backtrack(open_count, close_count, current + "(")

# Problem: Infinite recursion! open_count never increases

# Correct: Increment the count
if open_count < n:
    backtrack(open_count + 1, close_count, current + "(")
```

### ❌ Mistake 4: Modifying Shared State Without Backtracking

```python
# Wrong: Modifying list without backtracking
def backtrack(open_count, close_count, path):
    if open_count == close_count == n:
        result.append(''.join(path))
        return
    
    if open_count < n:
        path.append('(')
        backtrack(open_count + 1, close_count, path)
        # Missing: path.pop()

# Problem: path keeps growing, never backtracks

# Correct: Backtrack after recursion
if open_count < n:
    path.append('(')
    backtrack(open_count + 1, close_count, path)
    path.pop()  # Backtrack!
```

### ❌ Mistake 5: Using == Instead of <

```python
# Wrong: Using equality
if open_count == n:
    backtrack(open_count + 1, close_count, current + "(")

# Problem: Never adds '(' because condition is never true

# Correct: Use less than
if open_count < n:
    backtrack(open_count + 1, close_count, current + "(")
```

### ❌ Mistake 6: Forgetting to Initialize Result

```python
# Wrong: No result list
def generateParenthesis(n):
    def backtrack(open_count, close_count, current):
        if open_count == close_count == n:
            result.append(current)  # Error! result not defined
    
    backtrack(0, 0, "")
    return result

# Correct: Initialize result
def generateParenthesis(n):
    result = []  # Initialize!
    
    def backtrack(open_count, close_count, current):
        if open_count == close_count == n:
            result.append(current)
    
    backtrack(0, 0, "")
    return result
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `n = 1` | `["()"]` | Single pair |
| `n = 2` | `["(())","()()"]` | Two pairs |
| `n = 3` | `5 combinations` | Catalan number C(3) = 5 |
| `n = 8` | `1430 combinations` | Maximum constraint |

---

## Pattern Recognition

### This Pattern Applies To:

1. **Letter Combinations of Phone Number (LeetCode 17)**
```python
# Similar: Generate all combinations
def letterCombinations(digits):
    result = []
    
    def backtrack(index, path):
        if index == len(digits):
            result.append(path)
            return
        
        for letter in digit_to_letters[digits[index]]:
            backtrack(index + 1, path + letter)
```

2. **Permutations (LeetCode 46)**
```python
# Similar: Generate all permutations
def permute(nums):
    result = []
    
    def backtrack(path, remaining):
        if not remaining:
            result.append(path[:])
            return
        
        for i in range(len(remaining)):
            backtrack(path + [remaining[i]], 
                     remaining[:i] + remaining[i+1:])
```

3. **Subsets (LeetCode 78)**
```python
# Similar: Generate all subsets
def subsets(nums):
    result = []
    
    def backtrack(start, path):
        result.append(path[:])
        
        for i in range(start, len(nums)):
            backtrack(i + 1, path + [nums[i]])
```

### Key Characteristics:
- Generate all valid combinations
- Use backtracking/recursion
- Have clear constraints
- Build solution incrementally
- Prune invalid paths early

---

## Complete Implementations

### Implementation 1: String Concatenation (Simple) ⭐
```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        
        def backtrack(open_count, close_count, current):
            if open_count == close_count == n:
                result.append(current)
                return
            
            if open_count < n:
                backtrack(open_count + 1, close_count, current + "(")
            
            if close_count < open_count:
                backtrack(open_count, close_count + 1, current + ")")
        
        backtrack(0, 0, "")
        return result
```

### Implementation 2: List with Backtracking (Efficient) ⭐⭐
```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        
        def backtrack(open_count, close_count, path):
            if open_count == close_count == n:
                result.append(''.join(path))
                return
            
            if open_count < n:
                path.append('(')
                backtrack(open_count + 1, close_count, path)
                path.pop()
            
            if close_count < open_count:
                path.append(')')
                backtrack(open_count, close_count + 1, path)
                path.pop()
        
        backtrack(0, 0, [])
        return result
```

### Implementation 3: Iterative with Stack
```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []
        stack = [("", 0, 0)]
        
        while stack:
            current, open_count, close_count = stack.pop()
            
            if open_count == close_count == n:
                result.append(current)
                continue
            
            if open_count < n:
                stack.append((current + "(", open_count + 1, close_count))
            
            if close_count < open_count:
                stack.append((current + ")", open_count, close_count + 1))
        
        return result
```

### Implementation 4: Using Closure (Catalan Recurrence)
```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        if n == 0:
            return [""]
        
        result = []
        for i in range(n):
            for left in self.generateParenthesis(i):
                for right in self.generateParenthesis(n - 1 - i):
                    result.append(f"({left}){right}")
        
        return result
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Valid Parentheses (LC 20)** | Parentheses validation | Check validity, not generate |
| **Remove Invalid Parentheses (LC 301)** | Parentheses manipulation | Remove to make valid |
| **Letter Combinations (LC 17)** | Backtracking | Different choices |
| **Permutations (LC 46)** | Backtracking | Generate permutations |
| **Subsets (LC 78)** | Backtracking | Generate subsets |

---

## Day 60 Summary

### Problems Solved: 1
1. ✅ Generate Parentheses

### Key Patterns Learned:
1. **Backtracking** - Explore all valid paths
2. **Pruning** - Skip invalid paths early
3. **State Tracking** - Track open and close counts
4. **Catalan Numbers** - Mathematical connection

### Techniques Mastered:
- Backtracking with constraints
- Recursive state management
- String vs list performance
- Early pruning optimization

### Complexity Insights:
- Time: O(4^n / √n) - Catalan number
- Space: O(n) - Recursion depth
- Pruning reduces work by 98%!

### When to Use This Pattern:
- Generate all valid combinations
- Have clear constraints
- Can prune invalid paths
- Tree-structured solution space

---

## Quick Reference

### Backtracking Template
```python
def generateParenthesis(n):
    result = []
    
    def backtrack(open_count, close_count, current):
        # Base case
        if open_count == close_count == n:
            result.append(current)
            return
        
        # Choice 1: Add '('
        if open_count < n:
            backtrack(open_count + 1, close_count, current + "(")
        
        # Choice 2: Add ')'
        if close_count < open_count:
            backtrack(open_count, close_count + 1, current + ")")
    
    backtrack(0, 0, "")
    return result
```

### Key Rules
```
Rule 1: Can add '(' if open_count < n
Rule 2: Can add ')' if close_count < open_count
Base case: open_count == close_count == n
```

### Catalan Numbers
```
C(0) = 1
C(1) = 1
C(2) = 2
C(3) = 5
C(4) = 14
C(5) = 42
C(n) = (2n)! / ((n+1)! * n!)
```

---

## Interview Tips

**If asked about Generate Parentheses:**

1. **Clarify the problem**
   - "Generate all valid combinations?"
   - "n pairs means n opening and n closing?"
   - "Order of output matters?"

2. **Explain approach**
   - "I'll use backtracking"
   - "At each step, try adding '(' or ')'"
   - "Add '(' if we haven't used all n"
   - "Add ')' if it won't exceed '('"

3. **Walk through example**
   ```
   n=2:
   "" → "(" → "((" → "(()" → "(())" ✓
                  → "()" → "()(" → "()()" ✓
   ```

4. **Code it up**
   - Start with base case
   - Add '(' with condition
   - Add ')' with condition
   - Collect results

5. **Test edge cases**
   - n=1: ["()"]
   - n=2: ["(())","()()"]
   - n=3: 5 combinations

6. **Mention optimization**
   - "Could use list instead of string for better performance"
   - "This generates Catalan number of combinations"

**Time to explain:** 7-10 minutes

---

## Key Takeaways

1. **Backtracking is perfect** - For generating all valid combinations
2. **Two key rules** - open_count < n and close_count < open_count
3. **Pruning is powerful** - Reduces work by 98%
4. **Catalan numbers** - Mathematical pattern in result count
5. **List > String** - For performance (16x faster)
6. **Order matters** - Affects output order (but not correctness)
7. **Classic problem** - Teaches backtracking fundamentals

---

**End of Day 60 Notes**

*Master Generate Parentheses and you've mastered backtracking!* 🎯
