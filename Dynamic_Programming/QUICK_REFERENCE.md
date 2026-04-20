# Dynamic Programming - Quick Reference Guide

## 🎯 Pattern Recognition

### Keywords That Scream DP
- **Optimization**: Maximum, Minimum, Longest, Shortest, Largest, Smallest, Best, Optimal
- **Counting**: Count number of ways, How many ways, Total number of
- **Decision**: Is it possible, Can we achieve

### The Two Golden Rules
1. **Overlapping Subproblems**: Same subproblems solved multiple times
2. **Optimal Substructure**: Optimal solution contains optimal solutions to subproblems

---

## 📋 All DP Patterns at a Glance

### 1. Linear DP (1D)
**When**: State depends on previous 1-2 states  
**Template**: `dp[i] = f(dp[i-1], dp[i-2])`

| Problem | Recurrence | Time | Space |
|---------|------------|------|-------|
| Fibonacci | dp[i] = dp[i-1] + dp[i-2] | O(n) | O(1) |
| Climbing Stairs | dp[i] = dp[i-1] + dp[i-2] | O(n) | O(1) |
| House Robber | dp[i] = max(nums[i]+dp[i-2], dp[i-1]) | O(n) | O(1) |
| Max Subarray | dp[i] = max(nums[i], dp[i-1]+nums[i]) | O(n) | O(1) |
| Coin Change | dp[i] = min(dp[i], 1+dp[i-coin]) | O(n×m) | O(n) |

---

### 2. Grid DP (2D)
**When**: Navigate through 2D grid  
**Template**: `dp[i][j] = f(dp[i-1][j], dp[i][j-1])`

| Problem | Recurrence | Time | Space |
|---------|------------|------|-------|
| Unique Paths | dp[i][j] = dp[i-1][j] + dp[i][j-1] | O(m×n) | O(n) |
| Min Path Sum | dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1]) | O(m×n) | O(n) |
| Triangle | dp[i][j] = triangle[i][j] + min(dp[i-1][j-1], dp[i-1][j]) | O(n²) | O(n) |

---

### 3. String DP (2D)
**When**: Two strings, find relationship  
**Template**: `dp[i][j] = relationship between s1[0:i] and s2[0:j]`

| Problem | Match | No Match | Time | Space |
|---------|-------|----------|------|-------|
| LCS | 1+dp[i-1][j-1] | max(dp[i-1][j], dp[i][j-1]) | O(m×n) | O(n) |
| Edit Distance | dp[i-1][j-1] | 1+min(insert, delete, replace) | O(m×n) | O(n) |
| LPS | 2+dp[i+1][j-1] | max(dp[i+1][j], dp[i][j-1]) | O(n²) | O(n²) |

---

### 4. Knapsack Pattern
**When**: Select items with constraints

#### 0/1 Knapsack (Each item once)
```python
for i in range(n):
    for w in range(capacity, weight[i]-1, -1):  # Backward!
        dp[w] = max(dp[w], value[i] + dp[w-weight[i]])
```

#### Unbounded Knapsack (Items unlimited)
```python
for i in range(n):
    for w in range(weight[i], capacity+1):  # Forward!
        dp[w] = max(dp[w], value[i] + dp[w-weight[i]])
```

| Problem | Type | Key Insight |
|---------|------|-------------|
| 0/1 Knapsack | 0/1 | Take or leave each item |
| Subset Sum | 0/1 | Can we make target sum? |
| Equal Partition | 0/1 | Subset sum = total/2 |
| Target Sum | 0/1 | P = (target + total) / 2 |
| Coin Change | Unbounded | Min coins or count ways |
| Rod Cutting | Unbounded | Max profit from cuts |

---

### 5. Advanced Patterns

#### Stock Problems
**States**: holding, sold, cooldown, transactions_left

| Problem | Constraint | Approach |
|---------|-----------|----------|
| Stock I | 1 transaction | Track min price |
| Stock II | Unlimited | Sum all profits |
| Stock III | 2 transactions | DP with k=2 |
| Stock IV | k transactions | DP[k][i] |
| Cooldown | Must rest after sell | State machine |

#### Partition DP (MCM Pattern)
**When**: Optimal way to partition/split  
**Template**: Try all partition points
```python
for length in range(2, n):
    for left in range(n-length):
        right = left + length
        for k in range(left+1, right):
            dp[left][right] = optimal(dp[left][k], dp[k][right])
```

---

## 🔧 Problem-Solving Framework

### Step 1: Identify if it's DP
- [ ] Has optimization/counting keywords?
- [ ] Can break into subproblems?
- [ ] Subproblems overlap?
- [ ] Has optimal substructure?

### Step 2: Define the State
- What changes in subproblems?
- What parameters uniquely identify a subproblem?
- Examples:
  - 1D: `dp[i]` = answer for first i elements
  - 2D Grid: `dp[i][j]` = answer for cell (i,j)
  - 2D String: `dp[i][j]` = answer for s1[0:i] and s2[0:j]
  - Knapsack: `dp[i][w]` = answer for first i items with capacity w

### Step 3: Write Recurrence Relation
- How to compute current state from previous states?
- Consider all choices/decisions at current state

### Step 4: Identify Base Cases
- What are the smallest subproblems?
- What can we answer directly?

### Step 5: Decide Approach
- **Memoization**: If recursion is natural
- **Tabulation**: If iteration is clear

### Step 6: Optimize Space
- Do we need all previous states?
- Can we use rolling array?

---

## 💡 Common Tricks

### Space Optimization
```python
# From O(n) to O(1) - Keep only last k values
prev2, prev1 = base1, base2
for i in range(2, n):
    curr = f(prev1, prev2)
    prev2, prev1 = prev1, curr

# From O(m×n) to O(n) - Keep only previous row
prev = [0] * n
for i in range(m):
    curr = [0] * n
    for j in range(n):
        curr[j] = f(prev[j], curr[j-1])
    prev = curr
```

### Handling Edge Cases
```python
# Empty input
if not arr:
    return 0

# Single element
if len(arr) == 1:
    return arr[0]

# Initialize with infinity for minimization
dp = [float('inf')] * n
dp[0] = 0

# Initialize with -infinity for maximization
dp = [float('-inf')] * n
dp[0] = 0
```

---

## 🎨 Visualization Tips

### Draw the DP Table
For small inputs, always draw the table:
```
     ""  a  b  c
""    0  0  0  0
a     0  1  1  1
c     0  1  1  2
```

### Trace the Recurrence
```
fib(5)
├── fib(4)
│   ├── fib(3) ← Computed once
│   └── fib(2)
└── fib(3) ← Reused from cache!
```

---

## 🚨 Common Pitfalls

1. **Off-by-one errors**: Be careful with indices
2. **Wrong base cases**: Double-check smallest subproblems
3. **Backward vs Forward**: 0/1 knapsack needs backward iteration
4. **State definition**: Make sure state captures all needed info
5. **Forgetting to initialize**: Always initialize DP table properly

---

## 🎯 Practice Strategy

### Week 1-2: Foundations
- Fibonacci (all 3 ways)
- Climbing Stairs
- Min Cost Climbing Stairs
- House Robber

### Week 3-4: 1D DP
- Max Subarray
- Coin Change
- Decode Ways
- Word Break

### Week 5-6: 2D DP
- Unique Paths
- Min Path Sum
- LCS
- Edit Distance

### Week 7-8: Knapsack
- 0/1 Knapsack
- Subset Sum
- Target Sum
- Coin Change II

### Week 9-10: Advanced
- Stock Problems
- Burst Balloons
- House Robber III

---

## 📊 Complexity Quick Reference

| Pattern | Typical Time | Typical Space | Optimized Space |
|---------|--------------|---------------|-----------------|
| 1D DP | O(n) | O(n) | O(1) |
| 2D Grid | O(m×n) | O(m×n) | O(n) |
| 2D String | O(m×n) | O(m×n) | O(n) |
| Knapsack | O(n×W) | O(n×W) | O(W) |
| Partition DP | O(n³) | O(n²) | O(n²) |

---

## 🔍 Pattern Matching Guide

**See "maximum/minimum path"** → Grid DP  
**See "two strings"** → String DP (LCS/Edit Distance)  
**See "count ways"** → Usually DP  
**See "select items with capacity"** → Knapsack  
**See "buy/sell with constraints"** → Stock DP  
**See "partition optimally"** → Partition DP  

---

## 💪 Final Checklist

Before solving any DP problem:
- [ ] Identified it's a DP problem
- [ ] Defined state clearly
- [ ] Written recurrence relation
- [ ] Identified base cases
- [ ] Chosen approach (memo/tab)
- [ ] Considered space optimization
- [ ] Tested with small examples
- [ ] Handled edge cases

---

**Remember**: DP is about recognizing patterns, not memorizing solutions!

Keep this guide handy while practicing. Good luck! 🚀
