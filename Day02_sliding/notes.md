# Day 02 - Sliding Window & Stock Problems

## Sliding Window Pattern

### What is Sliding Window?

A technique to efficiently process contiguous subarrays/substrings by maintaining a "window" that slides through the data.

**Key Idea:** Instead of recalculating from scratch, add new element and remove old element.

### Types of Sliding Window

#### 1. Fixed Size Window

Window size remains constant throughout.

**Template:**
```python
def fixed_window(arr, k):
    # Initialize first window
    window_sum = sum(arr[:k])
    result = window_sum
    
    # Slide window
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]  # Add new, remove old
        result = max(result, window_sum)
    
    return result
```

**Time:** O(n) instead of O(n*k)

#### 2. Variable Size Window

Window size changes based on conditions.

**Template:**
```python
def variable_window(arr, condition):
    left = 0
    window_state = initial_value
    result = 0
    
    for right in range(len(arr)):
        # Expand window - add arr[right]
        window_state += arr[right]
        
        # Shrink window while condition violated
        while condition_violated:
            window_state -= arr[left]
            left += 1
        
        # Update result
        result = max(result, right - left + 1)
    
    return result
```

### When to Use Sliding Window

✅ **Use when:**
- Contiguous subarray/substring
- Finding max/min in subarrays
- Longest/shortest subarray with condition
- All subarrays of size K
- Can optimize from O(n²) to O(n)

❌ **Don't use when:**
- Need non-contiguous elements
- Elements can be reordered
- Need global view of entire array

### Common Problems

1. **Maximum Sum Subarray of Size K** - Fixed window
2. **Longest Substring Without Repeating Characters** - Variable window
3. **Minimum Window Substring** - Variable window
4. **Subarray Product Less Than K** - Variable window
5. **Max Consecutive Ones** - Variable window

---

## Stock Buy/Sell Problem

### Problem Statement

Given an array of stock prices where `prices[i]` is the price on day i, find the maximum profit from buying once and selling once.

**Constraints:**
- Must buy before selling
- Only one transaction allowed
- Return 0 if no profit possible

### Examples

```python
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy at 1, sell at 6, profit = 5

Input: prices = [7,6,4,3,1]
Output: 0
Explanation: Prices only decrease, no profit possible
```

### Pattern Recognition

**This is NOT a sliding window problem!**

Why?
- ❌ Not finding a contiguous subarray
- ❌ Not maintaining a window of elements
- ✅ Tracking minimum value seen so far
- ✅ Making greedy decision at each step

**This is a "Track Min/Max" pattern.**

### Optimal Solution

```python
def maxProfit(prices):
    # Time: O(n), Space: O(1)
    min_price = prices[0]
    max_profit = 0
    
    for i in range(1, len(prices)):
        # Track minimum price seen so far
        min_price = min(min_price, prices[i])
        
        # Calculate profit if selling today
        max_profit = max(max_profit, prices[i] - min_price)
    
    return max_profit
```

### Why This Solution is Optimal

**Time Complexity: O(n)**
- Single pass through array
- Can't do better (must check every price)

**Space Complexity: O(1)**
- Only 2 variables: `min_price` and `max_profit`
- Can't reduce further

**Logic:**
1. Track the minimum price seen so far
2. At each day, calculate profit if we sell today
3. Keep track of maximum profit

### Key Insights

**Greedy Approach:**
- We want to buy at the lowest price before selling
- At each day, we know the minimum price up to that day
- We can calculate the best profit if we sell on that day

**Why not use two pointers?**
- Not finding pairs that sum to target
- Not comparing elements from both ends
- Need to track historical minimum, not current pair

**Why not use hash map?**
- Not finding complements
- Not counting frequencies
- Not tracking seen elements
- Just need min value tracking

**Why not use sliding window?**
- Not finding contiguous subarray
- Not maintaining a window of elements
- Buy and sell days can be far apart

### Alternative Solutions (NOT Recommended)

#### Alternative 1: Brute Force
```python
def maxProfit(prices):
    # Time: O(n²), Space: O(1)
    max_profit = 0
    
    for i in range(len(prices)):
        for j in range(i + 1, len(prices)):
            profit = prices[j] - prices[i]
            max_profit = max(max_profit, profit)
    
    return max_profit
```
**Issues:** Too slow, O(n²) time complexity

#### Alternative 2: With Infinity
```python
def maxProfit(prices):
    # Time: O(n), Space: O(1)
    buy = float("inf")
    profit = 0
    
    for price in prices:
        buy = min(buy, price)
        profit = max(profit, price - buy)
    
    return profit
```
**Issues:** 
- Unnecessary infinity initialization
- Iterates from index 0 (redundant first check)

#### Alternative 3: Overcomplicated
```python
def maxProfit(prices):
    # Time: O(n), Space: O(1)
    buy = float("inf")
    sell = float("-inf")
    profit = 0
    
    for p in prices:
        if p < buy:
            buy = sell = p
            continue
        if p > sell:
            sell = p
            profit = max(profit, sell - buy)
    
    return profit
```
**Issues:**
- 3 variables instead of 2
- Unnecessary `sell` tracking
- Complex logic with `continue`

### Complexity Analysis

| Solution | Time | Space | Variables | Clarity |
|----------|------|-------|-----------|---------|
| Optimal | O(n) | O(1) | 2 | ⭐⭐⭐⭐⭐ |
| With infinity | O(n) | O(1) | 2 | ⭐⭐⭐⭐ |
| Overcomplicated | O(n) | O(1) | 3 | ⭐⭐ |
| Brute force | O(n²) | O(1) | 1 | ⭐⭐⭐ |

---

## Key Takeaways

### Pattern Recognition
1. **Contiguous subarray** → Sliding Window
2. **Track min/max for decisions** → Single pass with variable
3. **Find pairs in sorted array** → Two Pointers
4. **Find pairs in unsorted array** → Hash Map

### Stock Problem Lessons
- Not every array problem is sliding window
- Simpler is better (2 variables > 3 variables)
- Start from index 1 when first element is initialization
- Avoid unnecessary infinity when you have first element
- Greedy works when optimal substructure exists

### Optimization Principles
1. **Time first:** Get correct time complexity
2. **Space second:** Minimize variables
3. **Clarity always:** Readable code is maintainable code

### Common Mistakes
❌ Using sliding window for non-contiguous problems
❌ Overcomplicating with extra variables
❌ Using infinity when first element works
❌ Iterating from 0 when starting from 1 is cleaner

---

## Practice Problems

### Sliding Window
1. Maximum Sum Subarray of Size K
2. Longest Substring Without Repeating Characters
3. Minimum Window Substring
4. Longest Subarray with Sum K
5. Max Consecutive Ones III

### Track Min/Max
1. Best Time to Buy and Sell Stock
2. Maximum Subarray (Kadane's Algorithm)
3. Trapping Rain Water
4. Container With Most Water

### Mixed Patterns
1. Subarray Product Less Than K (Sliding Window)
2. Best Time to Buy and Sell Stock II (Greedy)
3. Maximum Profit in Job Scheduling (DP)

---

## Quick Reference

### Sliding Window Checklist
- [ ] Is it contiguous?
- [ ] Fixed or variable size?
- [ ] What to track in window?
- [ ] When to expand/shrink?
- [ ] What's the result?

### Track Min/Max Checklist
- [ ] Need historical min/max?
- [ ] Single pass possible?
- [ ] Greedy approach works?
- [ ] What to update at each step?

### Debugging Tips
1. Print window boundaries (left, right)
2. Print window state at each step
3. Verify window size calculation
4. Check edge cases (empty, size 1, all same)
5. Test with examples from problem

---

## Summary

**Sliding Window:**
- For contiguous subarrays/substrings
- Optimizes from O(n²) to O(n)
- Two types: fixed and variable size

**Stock Problem:**
- Track minimum pattern, not sliding window
- O(n) time, O(1) space is optimal
- Greedy approach with historical minimum

**Golden Rule:** Identify the pattern first, then apply the template. Don't force a pattern that doesn't fit!
