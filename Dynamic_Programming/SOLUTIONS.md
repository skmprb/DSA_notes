# Solutions Guide - Dynamic Programming Labs

## 📖 How to Use This Guide

**IMPORTANT:** Try to solve the problems yourself first! Only look at solutions when:
- You're completely stuck after 15-20 minutes
- You want to verify your solution
- You want to see alternative approaches

---

## Lab 1: What is Dynamic Programming?

### Task 1: Simple Recursive Fibonacci

```python
def fib_recursive(n):
    if n <= 1:
        return n
    return fib_recursive(n-1) + fib_recursive(n-2)
```

### Task 2: Track Function Calls

```python
call_count = {}

def fib_with_count(n):
    call_count[n] = call_count.get(n, 0) + 1
    
    if n <= 1:
        return n
    
    return fib_with_count(n-1) + fib_with_count(n-2)
```

### Task 3: Time Measurement

```python
import time

start = time.time()
result = fib_recursive(30)
end = time.time()
print(f"Time taken: {end - start} seconds")
print(f"Result: {result}")
```

### Task 4: Memoization

```python
def fib_memo(n, memo={}):
    if n in memo:
        return memo[n]
    
    if n <= 1:
        return n
    
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]
```

### Challenge: Climbing Stairs

```python
# Recursive
def climb_stairs_recursive(n):
    if n <= 1:
        return 1
    return climb_stairs_recursive(n-1) + climb_stairs_recursive(n-2)

# Memoized
def climb_stairs_memo(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return 1
    memo[n] = climb_stairs_memo(n-1, memo) + climb_stairs_memo(n-2, memo)
    return memo[n]
```

---

## Lab 2: Memoization

### Task 1: Dictionary Memoization

```python
def fib_memo_dict(n, memo={}):
    if n in memo:
        return memo[n]
    
    if n <= 1:
        return n
    
    memo[n] = fib_memo_dict(n-1, memo) + fib_memo_dict(n-2, memo)
    return memo[n]
```

### Task 2: Array Memoization

```python
def fib_memo_array(n):
    memo = [-1] * (n + 1)
    
    def helper(n):
        if memo[n] != -1:
            return memo[n]
        
        if n <= 1:
            return n
        
        memo[n] = helper(n-1) + helper(n-2)
        return memo[n]
    
    return helper(n)
```

### Task 3: @lru_cache

```python
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_lru(n):
    if n <= 1:
        return n
    return fib_lru(n-1) + fib_lru(n-2)

# Check cache info
print(fib_lru.cache_info())
```

### Task 4: Climbing Stairs

```python
def climb_stairs(n):
    memo = {}
    
    def helper(n):
        if n in memo:
            return memo[n]
        
        if n <= 1:
            return 1
        
        memo[n] = helper(n-1) + helper(n-2)
        return memo[n]
    
    return helper(n)
```

### Task 5: Min Cost Climbing Stairs

```python
def min_cost_climbing(cost):
    n = len(cost)
    memo = {}
    
    def helper(i):
        if i >= n:
            return 0
        
        if i in memo:
            return memo[i]
        
        memo[i] = cost[i] + min(helper(i+1), helper(i+2))
        return memo[i]
    
    return min(helper(0), helper(1))
```

### Challenge: Tribonacci

```python
# Dictionary
def tribonacci_dict(n, memo={}):
    if n in memo:
        return memo[n]
    if n == 0:
        return 0
    if n <= 2:
        return 1
    memo[n] = tribonacci_dict(n-1, memo) + tribonacci_dict(n-2, memo) + tribonacci_dict(n-3, memo)
    return memo[n]

# Array
def tribonacci_array(n):
    if n == 0:
        return 0
    if n <= 2:
        return 1
    
    memo = [-1] * (n + 1)
    memo[0], memo[1], memo[2] = 0, 1, 1
    
    def helper(n):
        if memo[n] != -1:
            return memo[n]
        memo[n] = helper(n-1) + helper(n-2) + helper(n-3)
        return memo[n]
    
    return helper(n)

# @lru_cache
from functools import lru_cache

@lru_cache(maxsize=None)
def tribonacci_lru(n):
    if n == 0:
        return 0
    if n <= 2:
        return 1
    return tribonacci_lru(n-1) + tribonacci_lru(n-2) + tribonacci_lru(n-3)
```

---

## Lab 3: Tabulation

### Task 1: Fibonacci Tabulation

```python
def fib_tabulation(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

### Task 2: Visualization

```python
def fib_tabulation_visual(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1
    
    print("Building DP table:")
    print(f"dp[0] = {dp[0]}")
    print(f"dp[1] = {dp[1]}")
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
        print(f"dp[{i}] = dp[{i-1}] + dp[{i-2}] = {dp[i-1]} + {dp[i-2]} = {dp[i]}")
    
    return dp[n]
```

### Task 3: Space Optimization

```python
def fib_optimized(n):
    if n <= 1:
        return n
    
    prev2 = 0
    prev1 = 1
    
    for i in range(2, n + 1):
        curr = prev1 + prev2
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

### Task 4: Climbing Stairs

```python
# Tabulation
def climb_stairs_tabulation(n):
    if n <= 1:
        return 1
    
    dp = [0] * (n + 1)
    dp[0] = 1
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]

# Optimized
def climb_stairs_optimized(n):
    if n <= 1:
        return 1
    
    prev2 = 1
    prev1 = 1
    
    for i in range(2, n + 1):
        curr = prev1 + prev2
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

### Task 5: Min Cost Climbing Stairs

```python
# Tabulation
def min_cost_climbing_tabulation(cost):
    n = len(cost)
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 0
    
    for i in range(2, n + 1):
        dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2])
    
    return dp[n]

# Optimized
def min_cost_climbing_optimized(cost):
    n = len(cost)
    prev2 = 0
    prev1 = 0
    
    for i in range(2, n + 1):
        curr = min(prev1 + cost[i-1], prev2 + cost[i-2])
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

### Task 6: House Robber

```python
# Tabulation
def house_robber(nums):
    if not nums:
        return 0
    if len(nums) == 1:
        return nums[0]
    
    n = len(nums)
    dp = [0] * n
    dp[0] = nums[0]
    dp[1] = max(nums[0], nums[1])
    
    for i in range(2, n):
        dp[i] = max(nums[i] + dp[i-2], dp[i-1])
    
    return dp[n-1]

# Optimized
def house_robber_optimized(nums):
    if not nums:
        return 0
    if len(nums) == 1:
        return nums[0]
    
    prev2 = nums[0]
    prev1 = max(nums[0], nums[1])
    
    for i in range(2, len(nums)):
        curr = max(nums[i] + prev2, prev1)
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

### Challenge: Tribonacci

```python
# Tabulation
def tribonacci_tabulation(n):
    if n == 0:
        return 0
    if n <= 2:
        return 1
    
    dp = [0] * (n + 1)
    dp[0], dp[1], dp[2] = 0, 1, 1
    
    for i in range(3, n + 1):
        dp[i] = dp[i-1] + dp[i-2] + dp[i-3]
    
    return dp[n]

# Optimized
def tribonacci_optimized(n):
    if n == 0:
        return 0
    if n <= 2:
        return 1
    
    prev3 = 0
    prev2 = 1
    prev1 = 1
    
    for i in range(3, n + 1):
        curr = prev1 + prev2 + prev3
        prev3 = prev2
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

---

## 💡 Tips for Success

1. **Don't look at solutions immediately** - Struggle is part of learning!
2. **Understand, don't memorize** - Focus on the pattern, not the code
3. **Try variations** - Change the problem slightly and solve again
4. **Draw it out** - Visualize the DP table on paper
5. **Explain it** - If you can explain it to someone, you understand it

---

## 🎯 When to Look at Solutions

✅ **Good reasons:**
- Stuck for 20+ minutes
- Want to verify your working solution
- Want to see optimization techniques
- Comparing different approaches

❌ **Bad reasons:**
- Haven't tried for at least 10 minutes
- Didn't read the problem carefully
- Skipping the thinking process
- Just want to copy-paste

---

## 📚 Next Steps After Seeing a Solution

1. **Close the solution**
2. **Delete your code**
3. **Implement it again from memory**
4. **Explain each line out loud**
5. **Try a similar problem**

Remember: The goal is LEARNING, not just completing the labs!

**You've got this! 🚀**
