# Python Notes

## `if __name__ == "__main__":`

Checks whether a script is being run directly or imported as a module.

**How it works:**
- `__name__` is a special built-in variable
- When you run a file directly: `__name__ == "__main__"`
- When you import a file: `__name__` == module name

**Why use it:**

Prevents unnecessary code execution when importing. It saves compute power by running code only when needed.

**Example:**

Without the check - wastes compute on import:
```python
class Twosum():
    def twosum(self, nums, target):
        return [0, 1]

nums = [3,5,1,2,4,5,6]  # Runs on import!
print(s.twosum(nums, target))  # Executes on import!
```

With the check - efficient:
```python
class Twosum():
    def twosum(self, nums, target):
        return [0, 1]

if __name__ == "__main__":
    nums = [3,5,1,2,4,5,6]  # Only runs when executed directly
    print(s.twosum(nums, target))  # Only runs when executed directly
```

---

# Array Concepts

## 1. Array Basics

**Definition:** Contiguous memory storage for elements of the same type.

**Time Complexity:**
- Access by index: O(1)
- Search: O(n)
- Insert/Delete at end: O(1)
- Insert/Delete at beginning/middle: O(n)

**Space Complexity:** O(n)

## 2. Two Pointer Technique - Deep Dive

### Types of Two Pointers

**1. Opposite Direction (Converging)**
```python
left, right = 0, len(arr) - 1
while left < right:
    # Process arr[left] and arr[right]
    if condition:
        left += 1
    else:
        right -= 1
```

**2. Same Direction (Fast & Slow)**
```python
slow = fast = 0
for fast in range(len(arr)):
    if condition:
        arr[slow] = arr[fast]
        slow += 1
```

**3. Sliding Window (Two pointers with window)**
```python
left = 0
for right in range(len(arr)):
    # Expand window
    while window_invalid:
        # Shrink window
        left += 1
```

### Common Patterns

**Pattern 1: Two Sum (Sorted Array)**
```python
def twoSum(nums, target):
    left, right = 0, len(nums) - 1
    while left < right:
        current_sum = nums[left] + nums[right]
        if current_sum == target:
            return [left, right]
        elif current_sum < target:
            left += 1
        else:
            right -= 1
    return None
```
**Time:** O(n), **Space:** O(1)

**Pattern 2: Remove Duplicates**
```python
def removeDuplicates(nums):
    if not nums:
        return 0
    slow = 0
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    return slow + 1
```

**Pattern 3: Reverse Array**
```python
def reverse(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1
```

**Pattern 4: Partition Array**
```python
def partition(arr, pivot):
    left, right = 0, len(arr) - 1
    while left <= right:
        if arr[left] < pivot:
            left += 1
        elif arr[right] >= pivot:
            right -= 1
        else:
            arr[left], arr[right] = arr[right], arr[left]
```

**Pattern 5: Three Sum**
```python
def threeSum(nums, target):
    nums.sort()
    result = []
    for i in range(len(nums) - 2):
        left, right = i + 1, len(nums) - 1
        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]
            if current_sum == target:
                result.append([nums[i], nums[left], nums[right]])
                left += 1
                right -= 1
            elif current_sum < target:
                left += 1
            else:
                right -= 1
    return result
```

**Pattern 6: Container With Most Water**
```python
def maxArea(height):
    left, right = 0, len(height) - 1
    max_area = 0
    while left < right:
        width = right - left
        area = min(height[left], height[right]) * width
        max_area = max(max_area, area)
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    return max_area
```

### When to Use Two Pointers
- ✅ Array is sorted (or can be sorted)
- ✅ Finding pairs/triplets with target sum
- ✅ Removing duplicates in-place
- ✅ Reversing/partitioning arrays
- ✅ Need O(1) space solution
- ✅ Comparing elements from both ends
- ❌ Array order must be preserved and unsorted
- ❌ Need to track indices in original array

**Time Complexity:** O(n) typically
**Space Complexity:** O(1)

## 3. Hash Map (Dictionary) - Deep Dive

### Initialization
```python
# Empty dictionary
hashmap = {}
hashmap = dict()

# With initial values
hashmap = {'a': 1, 'b': 2}
hashmap = dict(a=1, b=2)

# From lists
keys = ['a', 'b', 'c']
values = [1, 2, 3]
hashmap = dict(zip(keys, values))

# Default values
from collections import defaultdict
hashmap = defaultdict(int)      # default 0
hashmap = defaultdict(list)     # default []
hashmap = defaultdict(set)      # default set()

# Counter for frequency counting
from collections import Counter
freq = Counter([1, 2, 2, 3, 3, 3])  # {3: 3, 2: 2, 1: 1}
```

### Essential Methods
```python
# Adding/Updating
hashmap[key] = value
hashmap.update({'key': 'value'})
hashmap.setdefault(key, default)  # Set if key doesn't exist

# Accessing
value = hashmap[key]              # Raises KeyError if not found
value = hashmap.get(key)          # Returns None if not found
value = hashmap.get(key, default) # Returns default if not found

# Checking existence
if key in hashmap:                # O(1) average
if key not in hashmap:

# Removing
del hashmap[key]                  # Raises KeyError if not found
value = hashmap.pop(key)          # Returns value, raises KeyError
value = hashmap.pop(key, default) # Returns default if not found
hashmap.clear()                   # Remove all items

# Iteration
for key in hashmap:               # Iterate keys
for key in hashmap.keys():
for value in hashmap.values():
for key, value in hashmap.items():

# Size
len(hashmap)
```

### Common Patterns

**Pattern 1: Frequency Counter**
```python
def countFrequency(arr):
    freq = {}
    for num in arr:
        freq[num] = freq.get(num, 0) + 1
    return freq

# Or using Counter
from collections import Counter
freq = Counter(arr)
```

**Pattern 2: Finding Complement/Pair**
```python
def twoSum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
```

**Pattern 3: Grouping/Categorizing**
```python
def groupAnagrams(words):
    groups = defaultdict(list)
    for word in words:
        key = ''.join(sorted(word))
        groups[key].append(word)
    return list(groups.values())
```

**Pattern 4: Index Mapping**
```python
def findDuplicates(arr):
    index_map = {}
    for i, num in enumerate(arr):
        if num in index_map:
            return [index_map[num], i]
        index_map[num] = i
```

**Pattern 5: Seen/Visited Tracking**
```python
def hasUniqueChars(s):
    seen = set()
    for char in s:
        if char in seen:
            return False
        seen.add(char)
    return True
```

### When to Use Hash Map
- ✅ Need O(1) lookup/insert/delete
- ✅ Counting frequencies
- ✅ Finding pairs/complements
- ✅ Tracking seen elements
- ✅ Grouping/categorizing data
- ✅ Caching/memoization
- ❌ Need sorted order (use sorted dict or list)
- ❌ Memory constrained (uses O(n) space)

**Time Complexity:** O(1) average for insert/delete/lookup
**Space Complexity:** O(n)

## 4. Sliding Window - Deep Dive

### Types of Sliding Window

**1. Fixed Size Window**
```python
def maxSumSubarray(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

**2. Variable Size Window**
```python
def longestSubarrayWithSum(arr, target):
    left = 0
    current_sum = 0
    max_length = 0
    
    for right in range(len(arr)):
        current_sum += arr[right]
        
        while current_sum > target:
            current_sum -= arr[left]
            left += 1
        
        max_length = max(max_length, right - left + 1)
    return max_length
```

### Common Patterns

**Pattern 1: Maximum Sum Subarray of Size K**
```python
def maxSum(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

**Pattern 2: Longest Substring Without Repeating Characters**
```python
def lengthOfLongestSubstring(s):
    char_set = set()
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        char_set.add(s[right])
        max_length = max(max_length, right - left + 1)
    return max_length
```

**Pattern 3: Minimum Window Substring**
```python
def minWindow(s, t):
    from collections import Counter
    need = Counter(t)
    have = {}
    left = 0
    min_len = float('inf')
    result = ""
    
    for right in range(len(s)):
        char = s[right]
        have[char] = have.get(char, 0) + 1
        
        while all(have.get(c, 0) >= need[c] for c in need):
            if right - left + 1 < min_len:
                min_len = right - left + 1
                result = s[left:right + 1]
            have[s[left]] -= 1
            left += 1
    return result
```

**Pattern 4: Subarray Product Less Than K**
```python
def numSubarrayProductLessThanK(nums, k):
    if k <= 1:
        return 0
    product = 1
    left = 0
    count = 0
    
    for right in range(len(nums)):
        product *= nums[right]
        while product >= k:
            product //= nums[left]
            left += 1
        count += right - left + 1
    return count
```

### When to Use Sliding Window
- ✅ Contiguous subarray/substring problems
- ✅ Finding max/min in subarrays
- ✅ Longest/shortest subarray with condition
- ✅ All subarrays of size K
- ✅ Can optimize from O(n²) to O(n)
- ❌ Need non-contiguous elements
- ❌ Elements can be reordered

**Time Complexity:** O(n)
**Space Complexity:** O(1) to O(k) depending on tracking

## 5. Array/List Methods - Complete Reference

### Adding Elements
```python
arr = [1, 2, 3]

# Add single element at end
arr.append(4)                    # [1, 2, 3, 4] - O(1)

# Add multiple elements at end
arr.extend([5, 6])               # [1, 2, 3, 4, 5, 6] - O(k)
arr += [7, 8]                    # Same as extend

# Insert at specific index
arr.insert(0, 0)                 # [0, 1, 2, 3, 4, 5, 6, 7, 8] - O(n)
arr.insert(2, 1.5)               # Insert 1.5 at index 2 - O(n)
```

### Removing Elements
```python
arr = [1, 2, 3, 2, 4, 5]

# Remove by value (first occurrence)
arr.remove(2)                    # [1, 3, 2, 4, 5] - O(n)

# Remove by index
value = arr.pop()                # Removes last, returns 5 - O(1)
value = arr.pop(0)               # Removes first, returns 1 - O(n)
value = arr.pop(2)               # Removes at index 2 - O(n)

# Delete by index or slice
del arr[0]                       # Delete first element - O(n)
del arr[1:3]                     # Delete slice - O(n)

# Clear all elements
arr.clear()                      # [] - O(n)
arr = []                         # Alternative
```

### Searching & Finding
```python
arr = [10, 20, 30, 40, 20]

# Find index of value
index = arr.index(20)            # Returns 1 (first occurrence) - O(n)
index = arr.index(20, 2)         # Search from index 2, returns 4 - O(n)

# Find all indices
indices = [i for i, x in enumerate(arr) if x == 20]  # [1, 4]

# Check if value exists
if 20 in arr:                    # True - O(n)
if 50 not in arr:                # True - O(n)

# Count occurrences
count = arr.count(20)            # Returns 2 - O(n)
```

### Sorting & Reversing
```python
arr = [3, 1, 4, 1, 5, 9, 2]

# Sort in-place
arr.sort()                       # [1, 1, 2, 3, 4, 5, 9] - O(n log n)
arr.sort(reverse=True)           # [9, 5, 4, 3, 2, 1, 1] - descending

# Sort with key function
arr.sort(key=lambda x: -x)       # Sort descending
words.sort(key=len)              # Sort by length
words.sort(key=str.lower)        # Case-insensitive sort

# Return new sorted array (original unchanged)
new_arr = sorted(arr)            # O(n log n)
new_arr = sorted(arr, reverse=True)

# Reverse in-place
arr.reverse()                    # O(n)

# Return new reversed array
new_arr = arr[::-1]              # O(n)
new_arr = list(reversed(arr))    # O(n)
```

### Copying
```python
arr = [1, 2, 3]

# Shallow copy
copy1 = arr.copy()               # O(n)
copy2 = arr[:]                   # O(n)
copy3 = list(arr)                # O(n)

# Deep copy (for nested lists)
import copy
deep = copy.deepcopy(arr)        # O(n)
```

### Slicing
```python
arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Basic slicing [start:end:step]
arr[2:5]                         # [2, 3, 4] - from index 2 to 4
arr[:5]                          # [0, 1, 2, 3, 4] - first 5
arr[5:]                          # [5, 6, 7, 8, 9] - from index 5
arr[:]                           # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] - copy

# Step slicing
arr[::2]                         # [0, 2, 4, 6, 8] - every 2nd element
arr[1::2]                        # [1, 3, 5, 7, 9] - odd indices
arr[::-1]                        # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] - reverse

# Negative indices
arr[-1]                          # 9 - last element
arr[-3:]                         # [7, 8, 9] - last 3 elements
arr[:-2]                         # [0, 1, 2, 3, 4, 5, 6, 7] - all except last 2
```

### Other Useful Methods
```python
arr = [1, 2, 3, 4, 5]

# Length
len(arr)                         # 5 - O(1)

# Min/Max
min(arr)                         # 1 - O(n)
max(arr)                         # 5 - O(n)

# Sum
sum(arr)                         # 15 - O(n)

# All/Any
all([True, True, False])         # False - all elements truthy?
any([False, False, True])        # True - any element truthy?

# Enumerate (get index and value)
for i, val in enumerate(arr):
    print(f"Index {i}: {val}")

# Enumerate with start index
for i, val in enumerate(arr, start=1):
    print(f"Position {i}: {val}")

# Zip (combine multiple lists)
names = ['Alice', 'Bob']
ages = [25, 30]
for name, age in zip(names, ages):
    print(f"{name} is {age}")

# Map (apply function to all elements)
squares = list(map(lambda x: x**2, arr))  # [1, 4, 9, 16, 25]

# Filter (keep elements matching condition)
evens = list(filter(lambda x: x % 2 == 0, arr))  # [2, 4]
```

### List Comprehensions
```python
# Basic
squares = [x**2 for x in range(5)]           # [0, 1, 4, 9, 16]

# With condition
evens = [x for x in range(10) if x % 2 == 0] # [0, 2, 4, 6, 8]

# With if-else
result = [x if x > 0 else 0 for x in [-1, 2, -3, 4]]

# Nested
matrix = [[i*j for j in range(3)] for i in range(3)]

# Flatten 2D list
flat = [item for sublist in matrix for item in sublist]
```

### Creating Arrays
```python
# Empty array
arr = []

# With initial values
arr = [1, 2, 3, 4, 5]

# Repeated values
arr = [0] * 5                    # [0, 0, 0, 0, 0]

# Range
arr = list(range(5))             # [0, 1, 2, 3, 4]
arr = list(range(1, 6))          # [1, 2, 3, 4, 5]
arr = list(range(0, 10, 2))      # [0, 2, 4, 6, 8]

# 2D array
matrix = [[0] * 3 for _ in range(3)]  # 3x3 matrix
# DON'T use: [[0] * 3] * 3 (creates shallow copies!)
```

### Time Complexity Summary
| Operation | Time Complexity |
|-----------|----------------|
| Access by index | O(1) |
| Search by value | O(n) |
| Append | O(1) |
| Insert at beginning | O(n) |
| Insert at end | O(1) |
| Delete at beginning | O(n) |
| Delete at end | O(1) |
| Sort | O(n log n) |
| Reverse | O(n) |
| Copy | O(n) |

## 6. Key Patterns

**Finding pairs:** Hash map or two pointers
**Subarray problems:** Sliding window or prefix sum
**Sorting required:** Two pointers often works
**Frequency counting:** Hash map
**Multiple passes allowed:** Simplifies logic

---

# Additional Concepts

## Infinity in Python

**Usage:**
```python
positive_inf = float("inf")   # Positive infinity (∞)
negative_inf = float("-inf")  # Negative infinity (-∞)
```

**When to use:**
- Finding minimum: initialize with `float("inf")`
- Finding maximum: initialize with `float("-inf")`
- When you don't know the initial value

**Example:**
```python
# Finding minimum
min_val = float("inf")
for num in [5, 2, 8, 1]:
    min_val = min(min_val, num)  # min_val = 1

# Finding maximum
max_val = float("-inf")
for num in [5, 2, 8, 1]:
    max_val = max(max_val, num)  # max_val = 8
```

**Properties:**
```python
float("inf") > any_number      # True
float("-inf") < any_number     # True
float("inf") + 1 == float("inf")  # True
float("inf") == float("inf")  # True
```

**Alternative (often better):**
```python
# Instead of infinity, use first element
min_val = arr[0]
max_val = arr[0]
```

## Stock Buy/Sell Problem - Solution Comparison

**Problem:** Find max profit from buying and selling stock once.

**Optimal Solution (Recommended):**
```python
def maxProfit(prices):
    # Time: O(n), Space: O(1)
    min_soFar = prices[0]
    res = 0
    
    for i in range(1, len(prices)):
        min_soFar = min(min_soFar, prices[i])
        res = max(res, prices[i] - min_soFar)
    
    return res
```
**Why it's optimal:**
- ✅ Only 2 variables (minimal space)
- ✅ Single pass from index 1 (efficient)
- ✅ Clean, readable logic
- ✅ O(n) time, O(1) space - can't do better

**Alternative 1: With infinity initialization**
```python
def maxProfit(prices):
    buy = float("inf")
    profit = 0
    
    for price in prices:
        buy = min(buy, price)
        profit = max(profit, price - buy)
    
    return profit
```
**Issues:**
- ❌ Unnecessary infinity initialization
- ❌ Iterates from index 0 (redundant first check)

**Alternative 2: Verbose version**
```python
def maxProfit(prices):
    if len(prices) < 2:
        return 0
    
    min_price = prices[0]
    max_profit = 0
    
    for price in prices:
        if price < min_price:
            min_price = price
        else:
            profit = price - min_price
            if profit > max_profit:
                max_profit = profit
    
    return max_profit
```
**Issues:**
- ❌ Extra `profit` variable in loop
- ❌ Unnecessary edge case check
- ❌ More verbose if-else logic

**Alternative 3: Overcomplicated (DON'T USE)**
```python
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
```
**Issues:**
- ❌ 3 variables instead of 2
- ❌ Unnecessary `sell` tracking
- ❌ Complex logic with `continue`
- ❌ Harder to understand

**Key Takeaway:** Simpler is better. The optimal solution uses minimal variables and clean logic.

## Python-Specific Concepts

### if __name__ == "__main__":

Checks whether a script is being run directly or imported as a module.

**How it works:**
- `__name__` is a special built-in variable
- When you run a file directly: `__name__ == "__main__"`
- When you import a file: `__name__` == module name

**Why use it:**
Prevents unnecessary code execution when importing. Saves compute power by running code only when needed.

**Without the check - wastes compute:**
```python
class Twosum():
    def twosum(self, nums, target):
        return [0, 1]

nums = [3,5,1,2,4,5,6]  # Runs on import!
print(s.twosum(nums, target))  # Executes on import!
```

**With the check - efficient:**
```python
class Twosum():
    def twosum(self, nums, target):
        return [0, 1]

if __name__ == "__main__":
    nums = [3,5,1,2,4,5,6]  # Only runs when executed directly
    print(s.twosum(nums, target))  # Only runs when executed directly
```

**What "runs on import" means:**

If you have `file1.py`:
```python
class Twosum():
    def twosum(self, nums, target):
        return [0, 1]

print("This prints!")  # Executes when imported
```

And in `file2.py`:
```python
from file1 import Twosum  # "This prints!" appears here
```

With `if __name__ == "__main__":`, the print only runs when you execute `file1.py` directly, not when importing.

### Arrays vs Lists in Python

In Python, **arrays and lists are the same thing**:
```python
arr = [1, 2, 3]  # This is a list
lst = [1, 2, 3]  # Same thing
```

All methods (append, extend, insert, remove, pop, sort, etc.) work on Python lists.

**Note:** `array.array` from the array module exists for typed arrays but is rarely used.

### Getting Index from Value

```python
arr = [10, 20, 30, 40, 20]

# Method 1: index() - returns first occurrence
index = arr.index(20)  # Returns 1, O(n)

# Method 2: index() with start position
index = arr.index(20, 2)  # Search from index 2, returns 4

# Method 3: Find all indices
indices = [i for i, x in enumerate(arr) if x == 20]  # [1, 4]

# Method 4: Check if exists first (avoid ValueError)
if 20 in arr:
    index = arr.index(20)
else:
    print("Value not found")

# Method 5: Try-except
try:
    index = arr.index(20)
except ValueError:
    print("Value not found")
```

**Common error:**
```python
prices.index(sell_day_price)  # ValueError if value doesn't exist!
```

**Always check existence first or use try-except.**

### Memory Optimization Myths

**Myth:** More code = less memory

**Reality:** Variable count matters, not code length.

```python
# Solution 1: 2 variables - O(1) space
min_soFar = prices[0]
res = 0

# Solution 2: 3 variables - O(1) space (but worse)
buy = float("inf")
sell = float("-inf")
profit = 0
```

Both are O(1), but Solution 1 is better because:
- Fewer variables
- Simpler logic
- More readable

**Key principle:** Optimize for clarity first, then performance. Don't sacrifice readability for negligible gains.
