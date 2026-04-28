# Day 61: Combination Sum

## Problem Statement
**LeetCode 39: Combination Sum**

Given an array of **distinct** integers `candidates` and a target integer `target`, return a list of **all unique combinations** of `candidates` where the chosen numbers sum to `target`. You may return the combinations in any order.

**Key Points:**
- The **same number** may be chosen from candidates an **unlimited number of times**
- Two combinations are unique if the frequency of at least one of the chosen numbers is different
- The test cases guarantee less than 150 unique combinations

**Examples:**
```
Example 1:
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation:
  2 + 2 + 3 = 7 (2 can be used multiple times)
  7 = 7
  These are the only two combinations.

Example 2:
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]

Example 3:
Input: candidates = [2], target = 1
Output: []
Explanation: No combination sums to 1
```

**Constraints:**
- 1 <= candidates.length <= 30
- 2 <= candidates[i] <= 40
- All elements of candidates are **distinct**
- 1 <= target <= 40

---

## Problem Logic & Reasoning

### Core Concept
Find all **unique combinations** that sum to target, where each number can be used **unlimited times**.

**Key Insight:** Use backtracking to explore all possibilities, allowing reuse of same number.

### Visual Understanding for candidates=[2,3,6,7], target=7

```
All possible combinations:
[2] → sum=2, continue
[2,2] → sum=4, continue
[2,2,2] → sum=6, continue
[2,2,2,2] → sum=8 > 7, stop ✗
[2,2,3] → sum=7 ✓ Found!
[2,3] → sum=5, continue
[2,3,3] → sum=8 > 7, stop ✗
[2,6] → sum=8 > 7, stop ✗
[2,7] → sum=9 > 7, stop ✗
[3] → sum=3, continue
[3,3] → sum=6, continue
[3,3,3] → sum=9 > 7, stop ✗
[3,6] → sum=9 > 7, stop ✗
[3,7] → sum=10 > 7, stop ✗
[6] → sum=6, continue
[6,6] → sum=12 > 7, stop ✗
[6,7] → sum=13 > 7, stop ✗
[7] → sum=7 ✓ Found!

Valid combinations: [[2,2,3], [7]]
```

### The Backtracking Tree for candidates=[2,3], target=5

```
Start: []
├─ Add 2 → [2] (sum=2)
│  ├─ Add 2 → [2,2] (sum=4)
│  │  ├─ Add 2 → [2,2,2] (sum=6 > 5) ✗ Stop
│  │  └─ Add 3 → [2,2,3] (sum=7 > 5) ✗ Stop
│  └─ Add 3 → [2,3] (sum=5) ✓ Found!
└─ Add 3 → [3] (sum=3)
   ├─ Add 3 → [3,3] (sum=6 > 5) ✗ Stop
   └─ Skip (no more candidates)

Valid combinations: [[2,3]]
```

### Why We Can Reuse Numbers

```
Problem says: "same number may be chosen unlimited times"

Example: target=8, candidates=[2,3,5]

Valid combinations:
[2,2,2,2] ✓ - Uses 2 four times
[2,3,3] ✓ - Uses 3 twice
[3,5] ✓ - Uses each once

Key: When we choose a number, we can choose it again!
```

### Avoiding Duplicates

```
Problem: How to avoid duplicate combinations?

Wrong approach:
[2,3] and [3,2] are considered different
Result: [[2,3], [3,2]] - duplicates!

Correct approach:
Always move forward in candidates array
Once we skip a number, never go back to it

Example: candidates=[2,3,5]
If we're at [2], we can add:
  - 2 (same position) ✓
  - 3 (next position) ✓
  - 5 (next position) ✓
  
But NOT:
  - Go back to previous positions ✗

This ensures [2,3] is found but [3,2] is not!
```

### The Three Key Rules

```
Rule 1: Can reuse same number
  When adding candidates[i], next call starts at i (not i+1)
  
  Example: [2] → can add 2 again → [2,2]

Rule 2: Always move forward (no backtracking to earlier indices)
  When exploring, only consider candidates[i] onwards
  
  Example: At [2], can't go back to add numbers before 2

Rule 3: Stop when sum exceeds target
  If current_sum > target, prune this branch
  
  Example: [2,2,2,2] → sum=8 > 7, stop exploring
```

---

## Approach: Backtracking with Reuse ⭐⭐⭐⭐⭐

### Logic
Use backtracking to explore all combinations:
1. Start with empty combination and sum=0
2. For each candidate starting from current index:
   - Add candidate to current combination
   - Recursively explore with same index (allow reuse)
   - If sum equals target, save combination
   - If sum exceeds target, stop exploring
   - Backtrack (remove candidate) and try next

### Visual Flow for candidates=[2,3,6,7], target=7

```
backtrack(start=0, current=[], sum=0)
├─ Try candidates[0]=2
│  backtrack(start=0, current=[2], sum=2)
│  ├─ Try candidates[0]=2
│  │  backtrack(start=0, current=[2,2], sum=4)
│  │  ├─ Try candidates[0]=2
│  │  │  backtrack(start=0, current=[2,2,2], sum=6)
│  │  │  ├─ Try candidates[0]=2
│  │  │  │  backtrack(start=0, current=[2,2,2,2], sum=8)
│  │  │  │  sum > target, return ✗
│  │  │  ├─ Try candidates[1]=3
│  │  │  │  backtrack(start=1, current=[2,2,2,3], sum=9)
│  │  │  │  sum > target, return ✗
│  │  │  └─ Try candidates[2]=6, sum=12 > 7, skip
│  │  ├─ Try candidates[1]=3
│  │  │  backtrack(start=1, current=[2,2,3], sum=7)
│  │  │  sum == target! Add [2,2,3] ✓
│  │  └─ Try candidates[2]=6, sum=10 > 7, skip
│  ├─ Try candidates[1]=3
│  │  backtrack(start=1, current=[2,3], sum=5)
│  │  ├─ Try candidates[1]=3
│  │  │  backtrack(start=1, current=[2,3,3], sum=8)
│  │  │  sum > target, return ✗
│  │  └─ Try candidates[2]=6, sum=11 > 7, skip
│  └─ Try candidates[2]=6, sum=8 > 7, skip
├─ Try candidates[1]=3
│  backtrack(start=1, current=[3], sum=3)
│  ├─ Try candidates[1]=3
│  │  backtrack(start=1, current=[3,3], sum=6)
│  │  ├─ Try candidates[1]=3, sum=9 > 7, skip
│  │  └─ Try candidates[2]=6, sum=12 > 7, skip
│  └─ Try candidates[2]=6, sum=9 > 7, skip
├─ Try candidates[2]=6
│  backtrack(start=2, current=[6], sum=6)
│  ├─ Try candidates[2]=6, sum=12 > 7, skip
│  └─ Try candidates[3]=7, sum=13 > 7, skip
└─ Try candidates[3]=7
   backtrack(start=3, current=[7], sum=7)
   sum == target! Add [7] ✓

Result: [[2,2,3], [7]]
```

### Detailed Step-by-Step for candidates=[2,3], target=5

```
Call 1: backtrack(start=0, current=[], sum=0)
  Try i=0 (candidate=2):
    current.append(2) → current=[2]
    → Call 2: backtrack(0, [2], 2)

Call 2: backtrack(start=0, current=[2], sum=2)
  Try i=0 (candidate=2):
    current.append(2) → current=[2,2]
    → Call 3: backtrack(0, [2,2], 4)

Call 3: backtrack(start=0, current=[2,2], sum=4)
  Try i=0 (candidate=2):
    current.append(2) → current=[2,2,2]
    → Call 4: backtrack(0, [2,2,2], 6)

Call 4: backtrack(start=0, current=[2,2,2], sum=6)
  sum=6 > target=5, return ✗
  
Back to Call 3:
  current.pop() → current=[2,2]
  Try i=1 (candidate=3):
    current.append(3) → current=[2,2,3]
    → Call 5: backtrack(1, [2,2,3], 7)

Call 5: backtrack(start=1, current=[2,2,3], sum=7)
  sum=7 > target=5, return ✗

Back to Call 3:
  current.pop() → current=[2,2]
  No more candidates, return

Back to Call 2:
  current.pop() → current=[2]
  Try i=1 (candidate=3):
    current.append(3) → current=[2,3]
    → Call 6: backtrack(1, [2,3], 5)

Call 6: backtrack(start=1, current=[2,3], sum=5)
  sum == target! ✓
  result.append([2,3])
  return

Back to Call 2:
  current.pop() → current=[2]
  No more candidates, return

Back to Call 1:
  current.pop() → current=[]
  Try i=1 (candidate=3):
    current.append(3) → current=[3]
    → Call 7: backtrack(1, [3], 3)

Call 7: backtrack(start=1, current=[3], sum=3)
  Try i=1 (candidate=3):
    current.append(3) → current=[3,3]
    → Call 8: backtrack(1, [3,3], 6)

Call 8: backtrack(start=1, current=[3,3], sum=6)
  sum=6 > target=5, return ✗

Back to Call 7:
  current.pop() → current=[3]
  No more candidates, return

Back to Call 1:
  current.pop() → current=[]
  No more candidates, done

Final result: [[2,3]]
```

### Why start=i (Not start=i+1)?

```
Key difference from other backtracking problems:

Combination Sum: Can reuse numbers
  backtrack(i, ...) → Next call starts at i
  
  Example: [2] → can add 2 again → [2,2]

Combination Sum II: Can't reuse numbers
  backtrack(i+1, ...) → Next call starts at i+1
  
  Example: [2] → can't add 2 again → [2,3]

In this problem:
  for i in range(start, len(candidates)):
      current.append(candidates[i])
      backtrack(i, current, sum + candidates[i])  ← Note: i, not i+1
      current.pop()
```

### The Backtracking Pattern

```
Template:
1. Base case: If sum == target, add to result
2. Pruning: If sum > target, return early
3. For each candidate from start index:
   a. Add candidate to current
   b. Recurse with same index (allow reuse)
   c. Remove candidate (backtrack)

Key insight:
- Pass 'i' (not 'i+1') to allow reuse
- Pass 'start' to avoid duplicates
```

### Pseudocode
```
function combinationSum(candidates, target):
    result = []
    
    function backtrack(start, current, sum):
        // Base case: Found valid combination
        if sum == target:
            result.append(copy of current)
            return
        
        // Pruning: Sum exceeded target
        if sum > target:
            return
        
        // Try each candidate from start index
        for i from start to len(candidates)-1:
            // Add candidate
            current.append(candidates[i])
            
            // Recurse with same index (allow reuse)
            backtrack(i, current, sum + candidates[i])
            
            // Backtrack
            current.pop()
    
    backtrack(0, [], 0)
    return result
```

### Implementation
```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        
        def backtrack(start, current, total):
            # Base case: Found valid combination
            if total == target:
                result.append(current[:])  # Make a copy!
                return
            
            # Pruning: Exceeded target
            if total > target:
                return
            
            # Try each candidate from start
            for i in range(start, len(candidates)):
                current.append(candidates[i])
                backtrack(i, current, total + candidates[i])  # Note: i, not i+1
                current.pop()
        
        backtrack(0, [], 0)
        return result
```

### Complexity Analysis
- **Time:** O(N^(T/M)) where:
  - N = number of candidates
  - T = target value
  - M = minimal value among candidates
  - In worst case, we explore N^(T/M) combinations
- **Space:** O(T/M) - Recursion stack depth (maximum T/M elements in combination)

### Why Time Complexity is O(N^(T/M))?

```
Analysis:
- Maximum depth of recursion: T/M
  (If we keep adding smallest candidate M)
  
- At each level, we have N choices
  (Can choose any of N candidates)
  
- Total nodes in tree: N^(T/M)

Example: candidates=[2,3,5], target=8
  M = 2 (smallest)
  T/M = 8/2 = 4 (max depth)
  N = 3 (number of candidates)
  Complexity: 3^4 = 81 nodes (upper bound)
  
Actual: Much less due to pruning!
```

---

## Optimizations

### Optimization 1: Sort Candidates First

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()  # Sort first!
        result = []
        
        def backtrack(start, current, total):
            if total == target:
                result.append(current[:])
                return
            
            for i in range(start, len(candidates)):
                candidate = candidates[i]
                
                # Early termination: If current candidate exceeds target,
                # all remaining candidates will too (since sorted)
                if total + candidate > target:
                    break  # Stop, don't continue
                
                current.append(candidate)
                backtrack(i, current, total + candidate)
                current.pop()
        
        backtrack(0, [], 0)
        return result
```

**Why sorting helps:**
```
Without sorting: candidates=[7,6,3,2]
  Try 7: sum=7, found!
  Try 6: sum=6, continue...
  Try 3: sum=3, continue...
  Try 2: sum=2, continue...
  
  Must check all candidates even if sum exceeded

With sorting: candidates=[2,3,6,7]
  Try 2: sum=2, continue...
  Try 3: sum=3, continue...
  Try 6: sum=6, continue...
  Try 7: sum=7, found!
  
  If sum + candidate > target, break!
  All remaining candidates are larger, so skip them

Benefit: Early termination saves time!
```

### Optimization 2: Pass Remaining Instead of Total

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        
        def backtrack(start, current, remaining):
            # Base case: No more to add
            if remaining == 0:
                result.append(current[:])
                return
            
            # Pruning: Can't reach target
            if remaining < 0:
                return
            
            for i in range(start, len(candidates)):
                current.append(candidates[i])
                backtrack(i, current, remaining - candidates[i])
                current.pop()
        
        backtrack(0, [], target)
        return result
```

**Why this is cleaner:**
```
Approach 1: Track total sum
  if total == target: ...
  if total > target: ...
  backtrack(i, current, total + candidates[i])

Approach 2: Track remaining
  if remaining == 0: ...
  if remaining < 0: ...
  backtrack(i, current, remaining - candidates[i])

Approach 2 is more intuitive:
- Start with target
- Subtract each candidate
- When remaining reaches 0, we're done!
```

### Optimization 3: Avoid Copying Current

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        
        def backtrack(start, current, remaining):
            if remaining == 0:
                result.append(current)  # Don't copy, pass new list
                return
            
            if remaining < 0:
                return
            
            for i in range(start, len(candidates)):
                # Pass new list instead of modifying and backtracking
                backtrack(i, current + [candidates[i]], remaining - candidates[i])
        
        backtrack(0, [], target)
        return result
```

**Trade-off:**
```
Approach 1: Modify and backtrack
  current.append(candidate)
  backtrack(...)
  current.pop()
  
  Pros: No list copying
  Cons: Must remember to backtrack

Approach 2: Pass new list
  backtrack(..., current + [candidate], ...)
  
  Pros: No backtracking needed, cleaner
  Cons: Creates new list each time (O(k) where k = current length)

For this problem: Approach 1 is more efficient
```

---

## Alternative Approaches

### Approach 2: Dynamic Programming (Bottom-Up)

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        # dp[i] = list of combinations that sum to i
        dp = [[] for _ in range(target + 1)]
        dp[0] = [[]]  # Base case: one way to make 0 (empty combination)
        
        for candidate in candidates:
            for i in range(candidate, target + 1):
                for combination in dp[i - candidate]:
                    dp[i].append(combination + [candidate])
        
        return dp[target]
```

**How it works:**
```
Example: candidates=[2,3], target=5

Initial: dp[0] = [[]]

Process candidate=2:
  i=2: dp[2] = dp[0] + [2] = [[2]]
  i=3: dp[3] = dp[1] + [2] = [] (dp[1] is empty)
  i=4: dp[4] = dp[2] + [2] = [[2,2]]
  i=5: dp[5] = dp[3] + [2] = [] (dp[3] is empty)

Process candidate=3:
  i=3: dp[3] = dp[0] + [3] = [[3]]
  i=4: dp[4] = [[2,2]] + (dp[1] + [3]) = [[2,2]]
  i=5: dp[5] = (dp[2] + [3]) + (dp[2] + [3]) = [[2,3], [2,3]]
       Wait, this creates duplicates!

Problem: DP approach creates duplicates like [2,3] and [3,2]
Solution: Need to deduplicate or use different approach

Conclusion: Backtracking is better for this problem!
```

---

## Detailed Example Walkthroughs

### Example 1: candidates=[2,3,5], target=8

```
Execution tree (sorted candidates):

backtrack(0, [], 8)
├─ Add 2 → backtrack(0, [2], 6)
│  ├─ Add 2 → backtrack(0, [2,2], 4)
│  │  ├─ Add 2 → backtrack(0, [2,2,2], 2)
│  │  │  ├─ Add 2 → backtrack(0, [2,2,2,2], 0) ✓ Found [2,2,2,2]
│  │  │  ├─ Add 3 → backtrack(1, [2,2,2,3], -1) ✗ Exceeded
│  │  │  └─ Add 5 → backtrack(2, [2,2,2,5], -3) ✗ Exceeded
│  │  ├─ Add 3 → backtrack(1, [2,2,3], 1)
│  │  │  ├─ Add 3 → backtrack(1, [2,2,3,3], -2) ✗ Exceeded
│  │  │  └─ Add 5 → backtrack(2, [2,2,3,5], -4) ✗ Exceeded
│  │  └─ Add 5 → backtrack(2, [2,2,5], -1) ✗ Exceeded
│  ├─ Add 3 → backtrack(1, [2,3], 3)
│  │  ├─ Add 3 → backtrack(1, [2,3,3], 0) ✓ Found [2,3,3]
│  │  └─ Add 5 → backtrack(2, [2,3,5], -2) ✗ Exceeded
│  └─ Add 5 → backtrack(2, [2,5], 1)
│     ├─ Add 5 → backtrack(2, [2,5,5], -4) ✗ Exceeded
├─ Add 3 → backtrack(1, [3], 5)
│  ├─ Add 3 → backtrack(1, [3,3], 2)
│  │  ├─ Add 3 → backtrack(1, [3,3,3], -1) ✗ Exceeded
│  │  └─ Add 5 → backtrack(2, [3,3,5], -3) ✗ Exceeded
│  └─ Add 5 → backtrack(2, [3,5], 0) ✓ Found [3,5]
└─ Add 5 → backtrack(2, [5], 3)
   └─ Add 5 → backtrack(2, [5,5], -2) ✗ Exceeded

Result: [[2,2,2,2], [2,3,3], [3,5]]
```

### Example 2: Why Order Matters

```
candidates=[2,3], target=5

Correct (start from index):
  [2,3] ✓ - Start at 0, add 2, then start at 0, add 3
  [3,2] ✗ - Never generated (when we add 3, we start at 1)

Wrong (if we always start at 0):
  [2,3] ✓
  [3,2] ✓ - Duplicate!

The 'start' parameter prevents duplicates by ensuring
we only move forward in the candidates array.
```

---

## Comparison: Combination Sum Variants

```
Combination Sum (LC 39):
- Can reuse numbers unlimited times
- backtrack(i, ...) ← Same index

Combination Sum II (LC 40):
- Each number used at most once
- backtrack(i+1, ...) ← Next index
- Need to skip duplicates in candidates

Combination Sum III (LC 216):
- Use numbers 1-9 exactly once
- Fixed combination size k
- backtrack(i+1, ...) ← Next index

Combination Sum IV (LC 377):
- Count number of combinations (not list them)
- Order matters: [1,2] and [2,1] are different
- Use DP instead of backtracking
```

---

## Visualization: State Space Tree

```
candidates=[2,3], target=5

                    []
                    |
            +-------+-------+
            |               |
           [2]             [3]
            |               |
        +---+---+       +---+---+
        |       |       |       |
      [2,2]   [2,3]   [3,3]   [3,5]✗
        |       |       |
    +---+---+   5✓      8✗
    |       |
  [2,2,2] [2,2,3]
    |       |
    6✗      7✗

Legend:
✓ = Valid combination (sum == target)
✗ = Invalid (sum > target)
Number = Current sum

Pruning: Stop exploring when sum > target
```

---

## Critical Insights

### 1. Why Pass 'i' (Not 'i+1')?

```
Key difference:

Combination Sum: Can reuse
  backtrack(i, current, ...)
  
  Example: [2] → can add 2 again → [2,2]

Other problems: Can't reuse
  backtrack(i+1, current, ...)
  
  Example: [2] → can't add 2 again → [2,3]

The index parameter controls reusability!
```

### 2. Why We Need 'start' Parameter?

```
Without 'start':
  for i in range(len(candidates)):  # Always start at 0
  
  Problem: Creates duplicates
  [2,3] and [3,2] both generated

With 'start':
  for i in range(start, len(candidates)):
  
  Solution: Only move forward
  [2,3] generated, but [3,2] is not
  
The 'start' parameter prevents duplicates!
```

### 3. Must Copy Current When Adding to Result

```
Wrong:
  if total == target:
      result.append(current)  # Adds reference!
  
  Problem: current keeps changing
  All results end up being the same (last state)

Correct:
  if total == target:
      result.append(current[:])  # Makes a copy!
  
  or
  
  result.append(list(current))
  result.append(current.copy())
```

### 4. Sorting Enables Early Termination

```
Without sorting: [7,6,3,2], target=5
  Must try all candidates even if sum exceeded
  
With sorting: [2,3,6,7], target=5
  If current + 6 > 5, break!
  No need to try 7 (it's even larger)
  
Sorting + break = significant speedup!
```

### 5. The Backtracking Pattern

```
Standard backtracking template:
1. Make choice
2. Recurse
3. Undo choice (backtrack)

In code:
  current.append(candidate)  # Make choice
  backtrack(...)             # Recurse
  current.pop()              # Undo choice

This pattern appears in many problems!
```

---

## Common Mistakes

### ❌ Mistake 1: Passing i+1 Instead of i

```python
# Wrong: Can't reuse numbers
for i in range(start, len(candidates)):
    current.append(candidates[i])
    backtrack(i+1, current, total + candidates[i])  # Wrong!
    current.pop()

# Problem: [2,2,2,2] can't be generated

# Correct: Allow reuse
backtrack(i, current, total + candidates[i])  # Pass i, not i+1
```

### ❌ Mistake 2: Not Copying Current

```python
# Wrong: Adds reference
if total == target:
    result.append(current)  # All results will be same!

# Correct: Make a copy
if total == target:
    result.append(current[:])  # or list(current)
```

### ❌ Mistake 3: Starting Loop at 0 Instead of start

```python
# Wrong: Creates duplicates
for i in range(len(candidates)):  # Always starts at 0
    current.append(candidates[i])
    backtrack(i, current, total + candidates[i])
    current.pop()

# Problem: Generates [2,3] and [3,2]

# Correct: Start at 'start'
for i in range(start, len(candidates)):
```

### ❌ Mistake 4: Forgetting to Backtrack

```python
# Wrong: Doesn't remove candidate
for i in range(start, len(candidates)):
    current.append(candidates[i])
    backtrack(i, current, total + candidates[i])
    # Missing: current.pop()

# Problem: current keeps growing, never backtracks

# Correct: Always backtrack
current.append(candidates[i])
backtrack(i, current, total + candidates[i])
current.pop()  # Backtrack!
```

### ❌ Mistake 5: Wrong Base Case

```python
# Wrong: Only checks if total equals target
if total == target:
    result.append(current[:])
    return

# Missing: What if total > target?
# Will keep recursing unnecessarily

# Correct: Check both conditions
if total == target:
    result.append(current[:])
    return

if total > target:
    return  # Prune this branch
```

### ❌ Mistake 6: Using 'continue' Instead of 'break' After Sorting

```python
# Wrong: Continues checking even after exceeding
candidates.sort()
for i in range(start, len(candidates)):
    if total + candidates[i] > target:
        continue  # Wrong! Should break

# Problem: Still checks remaining candidates

# Correct: Break early
if total + candidates[i] > target:
    break  # Stop, all remaining are larger
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `candidates=[2], target=1` | `[]` | No combination possible |
| `candidates=[1], target=1` | `[[1]]` | Single element |
| `candidates=[1], target=2` | `[[1,1]]` | Reuse same element |
| `candidates=[2,3,5], target=8` | `[[2,2,2,2],[2,3,3],[3,5]]` | Multiple combinations |
| `candidates=[7,3,2], target=18` | Multiple | Large target |

---

## Pattern Recognition

### This Pattern Applies To:

1. **Combination Sum II (LeetCode 40)**
```python
# Similar but each number used at most once
def combinationSum2(candidates, target):
    candidates.sort()
    result = []
    
    def backtrack(start, current, remaining):
        if remaining == 0:
            result.append(current[:])
            return
        
        for i in range(start, len(candidates)):
            # Skip duplicates
            if i > start and candidates[i] == candidates[i-1]:
                continue
            
            if remaining < candidates[i]:
                break
            
            current.append(candidates[i])
            backtrack(i+1, current, remaining - candidates[i])  # i+1, not i
            current.pop()
    
    backtrack(0, [], target)
    return result
```

2. **Combination Sum III (LeetCode 216)**
```python
# Use numbers 1-9, combination size = k
def combinationSum3(k, n):
    result = []
    
    def backtrack(start, current, remaining):
        if len(current) == k and remaining == 0:
            result.append(current[:])
            return
        
        if len(current) >= k or remaining <= 0:
            return
        
        for i in range(start, 10):
            current.append(i)
            backtrack(i+1, current, remaining - i)
            current.pop()
    
    backtrack(1, [], n)
    return result
```

3. **Subsets (LeetCode 78)**
```python
# Generate all subsets
def subsets(nums):
    result = []
    
    def backtrack(start, current):
        result.append(current[:])  # Add every combination
        
        for i in range(start, len(nums)):
            current.append(nums[i])
            backtrack(i+1, current)
            current.pop()
    
    backtrack(0, [])
    return result
```

### Key Characteristics:
- Generate all combinations
- Use backtracking
- Track start index
- Allow/disallow reuse based on problem
- Prune invalid branches

---

## Complete Implementations

### Implementation 1: Basic Backtracking ⭐
```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        
        def backtrack(start, current, total):
            if total == target:
                result.append(current[:])
                return
            
            if total > target:
                return
            
            for i in range(start, len(candidates)):
                current.append(candidates[i])
                backtrack(i, current, total + candidates[i])
                current.pop()
        
        backtrack(0, [], 0)
        return result
```

### Implementation 2: With Sorting (Optimized) ⭐⭐
```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        result = []
        
        def backtrack(start, current, total):
            if total == target:
                result.append(current[:])
                return
            
            for i in range(start, len(candidates)):
                if total + candidates[i] > target:
                    break  # Early termination
                
                current.append(candidates[i])
                backtrack(i, current, total + candidates[i])
                current.pop()
        
        backtrack(0, [], 0)
        return result
```

### Implementation 3: Using Remaining ⭐⭐⭐
```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        result = []
        
        def backtrack(start, current, remaining):
            if remaining == 0:
                result.append(current[:])
                return
            
            if remaining < 0:
                return
            
            for i in range(start, len(candidates)):
                if candidates[i] > remaining:
                    break
                
                current.append(candidates[i])
                backtrack(i, current, remaining - candidates[i])
                current.pop()
        
        backtrack(0, [], target)
        return result
```

### Implementation 4: Without Explicit Backtracking
```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        
        def backtrack(start, current, remaining):
            if remaining == 0:
                result.append(current)
                return
            
            if remaining < 0:
                return
            
            for i in range(start, len(candidates)):
                # Pass new list instead of modifying
                backtrack(i, current + [candidates[i]], remaining - candidates[i])
        
        backtrack(0, [], target)
        return result
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Combination Sum II (LC 40)** | Same pattern | Each number used once, skip duplicates |
| **Combination Sum III (LC 216)** | Same pattern | Fixed size k, numbers 1-9 |
| **Combination Sum IV (LC 377)** | Count combinations | Order matters, use DP |
| **Subsets (LC 78)** | Backtracking | Generate all subsets |
| **Permutations (LC 46)** | Backtracking | Order matters |

---

## Day 61 Summary

### Problems Solved: 1
1. ✅ Combination Sum

### Key Patterns Learned:
1. **Backtracking with Reuse** - Pass same index to allow reuse
2. **Start Index** - Prevents duplicate combinations
3. **Pruning** - Stop when sum exceeds target
4. **Sorting Optimization** - Enable early termination

### Techniques Mastered:
- Backtracking with state
- Allowing number reuse
- Avoiding duplicates with start index
- Early termination with sorting
- Copying vs reference

### Complexity Insights:
- Time: O(N^(T/M)) - Exponential but pruned
- Space: O(T/M) - Recursion depth
- Sorting improves practical performance

### When to Use This Pattern:
- Generate all combinations
- Can reuse elements
- Need to avoid duplicates
- Sum/product constraints

---

## Quick Reference

### Backtracking Template
```python
def combinationSum(candidates, target):
    result = []
    
    def backtrack(start, current, remaining):
        # Base case
        if remaining == 0:
            result.append(current[:])
            return
        
        # Pruning
        if remaining < 0:
            return
        
        # Try each candidate
        for i in range(start, len(candidates)):
            current.append(candidates[i])
            backtrack(i, current, remaining - candidates[i])  # i, not i+1!
            current.pop()
    
    backtrack(0, [], target)
    return result
```

### Key Points
```
1. Pass 'i' (not 'i+1') to allow reuse
2. Use 'start' parameter to avoid duplicates
3. Always copy when adding to result: current[:]
4. Sort + break for early termination
5. Backtrack after recursion: current.pop()
```

---

## Interview Tips

**If asked about Combination Sum:**

1. **Clarify the problem**
   - "Can I reuse numbers?"
   - "Do I need to avoid duplicate combinations?"
   - "Any constraints on combination size?"

2. **Explain approach**
   - "I'll use backtracking"
   - "Try each candidate, allow reuse"
   - "Use start index to avoid duplicates"
   - "Prune when sum exceeds target"

3. **Walk through example**
   ```
   candidates=[2,3], target=5
   
   [] → [2] → [2,2] → [2,2,2] (6 > 5, stop)
             → [2,3] (5 == 5, found!)
      → [3] → [3,3] (6 > 5, stop)
   
   Result: [[2,3]]
   ```

4. **Code it up**
   - Start with base cases
   - Loop from start index
   - Recurse with same index (allow reuse)
   - Backtrack

5. **Mention optimization**
   - "Can sort first for early termination"
   - "Break when candidate exceeds remaining"

**Time to explain:** 7-10 minutes

---

## Key Takeaways

1. **Pass 'i' not 'i+1'** - Allows number reuse
2. **Start index prevents duplicates** - Only move forward
3. **Must copy current** - Avoid reference issues
4. **Sorting enables pruning** - Break early
5. **Backtracking pattern** - Add, recurse, remove
6. **Exponential but pruned** - Much faster in practice
7. **Classic backtracking** - Foundation for many problems

---

**End of Day 61 Notes**

*Master Combination Sum and you've mastered backtracking with reuse!* 🎯
