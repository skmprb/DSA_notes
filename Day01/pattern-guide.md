# DSA Pattern Recognition Guide

## How to Identify Which Pattern to Use

### 🔍 Pattern Decision Tree

```
Is it an ARRAY/STRING problem?
│
├─ Need to find PAIRS/TRIPLETS with target sum?
│  ├─ Array is SORTED → Use TWO POINTERS
│  └─ Array is UNSORTED → Use HASH MAP
│
├─ Need CONTIGUOUS subarray/substring?
│  ├─ Fixed size window → Use SLIDING WINDOW (fixed)
│  └─ Variable size window → Use SLIDING WINDOW (variable)
│
├─ Need to COUNT FREQUENCY?
│  └─ Use HASH MAP or Counter
│
├─ Need to TRACK SEEN elements?
│  └─ Use HASH MAP or SET
│
├─ Need to find MIN/MAX in subarrays?
│  └─ Use SLIDING WINDOW
│
└─ Need IN-PLACE modification?
   └─ Use TWO POINTERS (fast & slow)
```

---

## Pattern 1: Two Pointers

### 🎯 When to Use
- ✅ Array is **sorted** (or can be sorted)
- ✅ Finding **pairs/triplets** with target sum
- ✅ **Reversing** or **partitioning** arrays
- ✅ **Removing duplicates** in-place
- ✅ Need **O(1) space** solution
- ✅ Comparing elements from **both ends**

### ❌ When NOT to Use
- Array order must be preserved and is unsorted
- Need to track original indices
- Problem requires non-contiguous elements

### 🔑 Key Indicators in Problem Statement
- "sorted array"
- "find two numbers that sum to"
- "remove duplicates"
- "reverse"
- "partition"
- "in-place"

### 📝 Template

**Opposite Direction (Converging):**
```python
def two_pointer_opposite(arr, target):
    left, right = 0, len(arr) - 1
    
    while left < right:
        current = arr[left] + arr[right]
        
        if current == target:
            return [left, right]
        elif current < target:
            left += 1
        else:
            right -= 1
    
    return None
```

**Same Direction (Fast & Slow):**
```python
def two_pointer_same(arr):
    slow = 0
    
    for fast in range(len(arr)):
        if condition:
            arr[slow] = arr[fast]
            slow += 1
    
    return slow
```

### 💡 Common Problems
1. **Two Sum (sorted)** - Find pair with target sum
2. **Three Sum** - Find triplets with target sum
3. **Remove Duplicates** - Remove duplicates in-place
4. **Container With Most Water** - Find max area
5. **Valid Palindrome** - Check if string is palindrome
6. **Move Zeroes** - Move all zeros to end

### 🎓 Example: Two Sum (Sorted Array)

**Problem:** Find two numbers that add up to target in sorted array.

**Why Two Pointers?**
- ✅ Array is sorted
- ✅ Finding a pair
- ✅ Can use O(1) space

**Solution:**
```python
def twoSum(nums, target):
    left, right = 0, len(nums) - 1
    
    while left < right:
        current_sum = nums[left] + nums[right]
        
        if current_sum == target:
            return [left, right]
        elif current_sum < target:
            left += 1  # Need larger sum
        else:
            right -= 1  # Need smaller sum
    
    return None

# Time: O(n), Space: O(1)
```

---

## Pattern 2: Hash Map

### 🎯 When to Use
- ✅ Need **O(1) lookup/insert/delete**
- ✅ **Counting frequencies**
- ✅ Finding **pairs/complements** in unsorted array
- ✅ **Tracking seen** elements
- ✅ **Grouping/categorizing** data
- ✅ **Caching/memoization**

### ❌ When NOT to Use
- Need sorted order (use sorted dict or list)
- Memory constrained (uses O(n) space)
- Array is already sorted (two pointers is better)

### 🔑 Key Indicators in Problem Statement
- "unsorted array"
- "find two numbers"
- "count frequency"
- "first occurrence"
- "group by"
- "anagram"
- "duplicate"

### 📝 Template

**Finding Complement:**
```python
def hash_map_complement(arr, target):
    seen = {}
    
    for i, num in enumerate(arr):
        complement = target - num
        
        if complement in seen:
            return [seen[complement], i]
        
        seen[num] = i
    
    return None
```

**Frequency Counter:**
```python
def hash_map_frequency(arr):
    freq = {}
    
    for num in arr:
        freq[num] = freq.get(num, 0) + 1
    
    return freq

# Or use Counter
from collections import Counter
freq = Counter(arr)
```

### 💡 Common Problems
1. **Two Sum (unsorted)** - Find pair with target sum
2. **Group Anagrams** - Group strings that are anagrams
3. **First Unique Character** - Find first non-repeating character
4. **Contains Duplicate** - Check if array has duplicates
5. **Longest Substring Without Repeating** - Find longest unique substring
6. **Subarray Sum Equals K** - Count subarrays with sum K

### 🎓 Example: Two Sum (Unsorted Array)

**Problem:** Find two numbers that add up to target in unsorted array.

**Why Hash Map?**
- ✅ Array is unsorted
- ✅ Need O(n) solution
- ✅ Can use O(n) space

**Solution:**
```python
def twoSum(nums, target):
    seen = {}
    
    for i, num in enumerate(nums):
        complement = target - num
        
        if complement in seen:
            return [seen[complement], i]
        
        seen[num] = i
    
    return None

# Time: O(n), Space: O(n)
```

---

## Pattern 3: Sliding Window

### 🎯 When to Use
- ✅ **Contiguous** subarray/substring problems
- ✅ Finding **max/min** in subarrays
- ✅ **Longest/shortest** subarray with condition
- ✅ All subarrays of **size K**
- ✅ Can optimize from **O(n²) to O(n)**

### ❌ When NOT to Use
- Need non-contiguous elements
- Elements can be reordered
- Problem requires global view of array

### 🔑 Key Indicators in Problem Statement
- "contiguous subarray"
- "substring"
- "window of size K"
- "longest subarray"
- "shortest subarray"
- "maximum sum of subarray"
- "all subarrays"

### 📝 Template

**Fixed Size Window:**
```python
def sliding_window_fixed(arr, k):
    # Initialize window
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    # Slide window
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    
    return max_sum
```

**Variable Size Window:**
```python
def sliding_window_variable(arr, target):
    left = 0
    window_sum = 0
    max_length = 0
    
    for right in range(len(arr)):
        # Expand window
        window_sum += arr[right]
        
        # Shrink window if needed
        while window_sum > target:
            window_sum -= arr[left]
            left += 1
        
        # Update result
        max_length = max(max_length, right - left + 1)
    
    return max_length
```

### 💡 Common Problems
1. **Maximum Sum Subarray of Size K** - Find max sum in fixed window
2. **Longest Substring Without Repeating** - Find longest unique substring
3. **Minimum Window Substring** - Find smallest window containing all chars
4. **Longest Subarray with Sum K** - Find longest subarray with sum
5. **Max Consecutive Ones** - Find max consecutive 1s
6. **Fruit Into Baskets** - Pick fruits with at most 2 types

### 🎓 Example: Maximum Sum Subarray of Size K

**Problem:** Find maximum sum of any contiguous subarray of size K.

**Why Sliding Window?**
- ✅ Contiguous subarray
- ✅ Fixed size K
- ✅ Finding maximum

**Solution:**
```python
def maxSumSubarray(arr, k):
    # Initialize first window
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    # Slide window: add new element, remove old element
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    
    return max_sum

# Time: O(n), Space: O(1)
# Without sliding window: O(n*k)
```

---

## Pattern 4: Tracking Min/Max

### 🎯 When to Use
- ✅ Need to track **minimum/maximum** so far
- ✅ **Single pass** through array
- ✅ Making decisions based on **previous min/max**
- ✅ **Greedy** approach works

### 🔑 Key Indicators in Problem Statement
- "maximum profit"
- "best time to"
- "minimum/maximum difference"
- "largest/smallest"

### 📝 Template
```python
def track_min_max(arr):
    min_so_far = arr[0]  # or float('inf')
    result = 0
    
    for i in range(1, len(arr)):
        # Update min/max
        min_so_far = min(min_so_far, arr[i])
        
        # Calculate result based on current and min/max
        result = max(result, arr[i] - min_so_far)
    
    return result
```

### 💡 Common Problems
1. **Best Time to Buy and Sell Stock** - Max profit from one transaction
2. **Maximum Subarray** - Find subarray with largest sum
3. **Trapping Rain Water** - Calculate trapped water
4. **Largest Rectangle in Histogram** - Find largest rectangle area

### 🎓 Example: Best Time to Buy and Sell Stock

**Problem:** Find maximum profit from buying and selling stock once.

**Why Track Min?**
- ✅ Need minimum price seen so far
- ✅ Single pass solution
- ✅ Greedy approach works

**Solution:**
```python
def maxProfit(prices):
    min_price = prices[0]
    max_profit = 0
    
    for i in range(1, len(prices)):
        # Track minimum price
        min_price = min(min_price, prices[i])
        
        # Calculate profit if selling today
        max_profit = max(max_profit, prices[i] - min_price)
    
    return max_profit

# Time: O(n), Space: O(1)
```

**Why this pattern?**
- We only care about the minimum price before current day
- Don't need to track all prices (no hash map needed)
- Don't need two pointers (not finding pairs)
- Not a window problem (not contiguous subarray)

---

## Quick Reference Table

| Problem Type | Pattern | Time | Space | Key Indicator |
|-------------|---------|------|-------|---------------|
| Two Sum (sorted) | Two Pointers | O(n) | O(1) | "sorted array" |
| Two Sum (unsorted) | Hash Map | O(n) | O(n) | "unsorted array" |
| Max sum subarray size K | Sliding Window | O(n) | O(1) | "contiguous", "size K" |
| Longest substring unique | Sliding Window + Set | O(n) | O(k) | "substring", "longest" |
| Remove duplicates | Two Pointers | O(n) | O(1) | "in-place", "duplicates" |
| Count frequency | Hash Map | O(n) | O(n) | "count", "frequency" |
| Stock buy/sell | Track Min | O(n) | O(1) | "maximum profit" |
| Group anagrams | Hash Map | O(n*k) | O(n) | "group", "anagram" |
| Three sum | Two Pointers | O(n²) | O(1) | "triplets", "sum" |
| Subarray sum equals K | Hash Map + Prefix | O(n) | O(n) | "subarray", "sum equals" |

---

## Practice Strategy

### Step 1: Read Problem Carefully
- Identify input type (array, string, etc.)
- Identify what you're looking for (pair, subarray, max, min, etc.)
- Note constraints (sorted? in-place? size limit?)

### Step 2: Ask Key Questions
1. Is the array sorted?
2. Do I need contiguous elements?
3. Am I finding pairs/complements?
4. Do I need to count/track something?
5. Is there a fixed window size?
6. Can I modify in-place?

### Step 3: Match to Pattern
- Use the decision tree at the top
- Check key indicators in problem statement
- Consider time/space constraints

### Step 4: Apply Template
- Start with the pattern template
- Modify for specific problem
- Test with examples

### Step 5: Optimize
- Can you reduce space?
- Can you reduce passes?
- Is there a simpler approach?

---

## Common Mistakes to Avoid

### ❌ Using Hash Map when Two Pointers works
```python
# DON'T: Use hash map on sorted array
def twoSum(nums, target):  # nums is sorted
    seen = {}
    for i, num in enumerate(nums):
        if target - num in seen:
            return [seen[target - num], i]
        seen[num] = i

# DO: Use two pointers
def twoSum(nums, target):
    left, right = 0, len(nums) - 1
    while left < right:
        if nums[left] + nums[right] == target:
            return [left, right]
        elif nums[left] + nums[right] < target:
            left += 1
        else:
            right -= 1
```

### ❌ Using Nested Loops when Sliding Window works
```python
# DON'T: O(n*k) solution
def maxSum(arr, k):
    max_sum = 0
    for i in range(len(arr) - k + 1):
        current_sum = sum(arr[i:i+k])
        max_sum = max(max_sum, current_sum)
    return max_sum

# DO: O(n) sliding window
def maxSum(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

### ❌ Overcomplicating Simple Problems
```python
# DON'T: Track unnecessary variables
def maxProfit(prices):
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

# DO: Keep it simple
def maxProfit(prices):
    min_price = prices[0]
    max_profit = 0
    for i in range(1, len(prices)):
        min_price = min(min_price, prices[i])
        max_profit = max(max_profit, prices[i] - min_price)
    return max_profit
```

---

## Summary

**Remember:**
1. **Sorted array + pairs** → Two Pointers
2. **Unsorted array + pairs** → Hash Map
3. **Contiguous subarray** → Sliding Window
4. **Count/frequency** → Hash Map
5. **Track min/max** → Single pass with variable
6. **In-place modification** → Two Pointers (fast & slow)

**Golden Rule:** Start simple, optimize only if needed. Clarity > Cleverness.
