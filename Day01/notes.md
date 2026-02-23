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

## 5. Common Array Operations

**Sorting:**
```python
arr.sort()              # In-place, O(n log n)
sorted_arr = sorted(arr) # New array, O(n log n)
```

**Reversing:**
```python
arr.reverse()           # In-place
arr[::-1]               # New array
```

**Slicing:**
```python
arr[start:end]          # Elements from start to end-1
arr[start:]             # From start to end
arr[:end]               # From beginning to end-1
arr[::step]             # Every step element
```

## 6. Key Patterns

**Finding pairs:** Hash map or two pointers
**Subarray problems:** Sliding window or prefix sum
**Sorting required:** Two pointers often works
**Frequency counting:** Hash map
**Multiple passes allowed:** Simplifies logic
