# Day 54: Contains Duplicate II

## Problem Statement
**LeetCode 219: Contains Duplicate II**

Given an integer array nums and an integer k, return true if there are two distinct indices i and j in the array such that nums[i] == nums[j] and abs(i - j) <= k.

**Examples:**
```
Input: nums = [1,2,3,1], k = 3
Output: true
Explanation: nums[0] = nums[3] = 1, and |0 - 3| = 3 <= 3

Input: nums = [1,0,1,1], k = 1
Output: true
Explanation: nums[2] = nums[3] = 1, and |2 - 3| = 1 <= 1

Input: nums = [1,2,3,1,2,3], k = 2
Output: false
Explanation: No duplicates within distance 2
```

**Constraints:**
- 1 <= nums.length <= 10⁵
- -10⁹ <= nums[i] <= 10⁹
- 0 <= k <= 10⁵

---

## Problem Logic & Reasoning

### Core Concept
Find if there exist two **duplicate values** in the array where their **indices are at most k apart**.

**Key Insight:** We need to track both the **value** and its **position** to check if duplicates are within distance k.

### Visual Understanding

```
Example: nums = [1,2,3,1], k = 3

Index:  0  1  2  3
Value: [1, 2, 3, 1]
        ↑        ↑
        i=0     j=3

nums[0] == nums[3] = 1 ✓
|0 - 3| = 3 <= 3 ✓

Result: true
```

### Breaking Down the Problem

```
Example: nums = [1,2,3,1,2,3], k = 2

Check each pair:
i=0, j=3: nums[0]=1, nums[3]=1, |0-3|=3 > 2 ✗
i=1, j=4: nums[1]=2, nums[4]=2, |1-4|=3 > 2 ✗
i=2, j=5: nums[2]=3, nums[5]=3, |2-5|=3 > 2 ✗

No valid pairs → false
```

### The Sliding Window Concept

```
Think of k as a "window size":
- Keep track of elements within window of size k
- If we see a duplicate in this window → true
- Slide the window as we move through array

Example: nums = [1,2,3,1], k = 3

Window at i=0: {1}
Window at i=1: {1, 2}
Window at i=2: {1, 2, 3}
Window at i=3: {1, 2, 3, 1}  ← 1 appears twice! ✓
```

---

## Approach 1: Brute Force (Nested Loops) ⭐

### Logic
Check every pair of indices (i, j) where i < j:
1. If nums[i] == nums[j] AND abs(i - j) <= k
2. Return true
3. If no such pair found, return false

### Visual Flow for [1,2,3,1], k=3

```
i=0, nums[0]=1:
  j=1: nums[1]=2, 1≠2 ✗
  j=2: nums[2]=3, 1≠3 ✗
  j=3: nums[3]=1, 1==1 ✓, |0-3|=3<=3 ✓
  → Return true

Result: true
```

### Step-by-Step Execution

```
nums = [1,2,3,1,2,3], k = 2

i=0, nums[0]=1:
  j=1: nums[1]=2, 1≠2 ✗
  j=2: nums[2]=3, 1≠3 ✗
  j=3: nums[3]=1, 1==1 ✓, |0-3|=3>2 ✗

i=1, nums[1]=2:
  j=2: nums[2]=3, 2≠3 ✗
  j=3: nums[3]=1, 2≠1 ✗
  j=4: nums[4]=2, 2==2 ✓, |1-4|=3>2 ✗

i=2, nums[2]=3:
  j=3: nums[3]=1, 3≠1 ✗
  j=4: nums[4]=2, 3≠2 ✗
  j=5: nums[5]=3, 3==3 ✓, |2-5|=3>2 ✗

i=3, nums[3]=1:
  j=4: nums[4]=2, 1≠2 ✗
  j=5: nums[5]=3, 1≠3 ✗

i=4, nums[4]=2:
  j=5: nums[5]=3, 2≠3 ✗

No valid pairs → false
```

### Pseudocode
```
function containsNearbyDuplicate(nums, k):
    for i from 0 to len(nums)-1:
        for j from i+1 to len(nums)-1:
            if nums[i] == nums[j] and abs(i - j) <= k:
                return true
    
    return false
```

### Complexity Analysis
- **Time:** O(n²) - Nested loops check all pairs
- **Space:** O(1) - No extra space

---

## Approach 2: Optimized Brute Force (Limited Range) ⭐⭐

### Logic
Instead of checking all j > i, only check j in range [i+1, min(i+k+1, n)]:
1. For each i, check only next k elements
2. If duplicate found within range → true
3. Otherwise → false

### Visual Flow for [1,2,3,1], k=3

```
i=0, nums[0]=1:
  Check j in [1, min(4, 4)] = [1, 4]
  j=1: nums[1]=2 ✗
  j=2: nums[2]=3 ✗
  j=3: nums[3]=1 ✓, |0-3|=3<=3 ✓
  → Return true

Result: true
```

### Why This is Better

```
Original: Check all pairs
nums = [1,2,3,4,5,6,7,8,9,10], k = 2

i=0: Check j=1,2,3,4,5,6,7,8,9 (9 checks)
i=1: Check j=2,3,4,5,6,7,8,9 (8 checks)
...
Total: 9+8+7+...+1 = 45 checks

Optimized: Check only within window
i=0: Check j=1,2 (2 checks)
i=1: Check j=2,3 (2 checks)
...
Total: 2×10 = 20 checks

Savings: 45 → 20 (56% reduction)
```

### Pseudocode
```
function containsNearbyDuplicate(nums, k):
    for i from 0 to len(nums)-1:
        for j from i+1 to min(i+k+1, len(nums)):
            if nums[i] == nums[j]:
                return true
    
    return false
```

### Complexity Analysis
- **Time:** O(n × k) - For each element, check k elements
- **Space:** O(1) - No extra space

---

## Approach 3: HashMap (Track Last Index) ⭐⭐⭐

### Logic
Use a HashMap to store the last seen index of each value:
1. For each element, check if it exists in map
2. If yes, check if current_index - last_index <= k
3. Update the last seen index
4. If no valid pair found, return false

### Visual Flow for [1,2,3,1], k=3

```
Initial: map = {}

i=0, nums[0]=1:
  1 not in map
  map[1] = 0
  map = {1: 0}

i=1, nums[1]=2:
  2 not in map
  map[2] = 1
  map = {1: 0, 2: 1}

i=2, nums[2]=3:
  3 not in map
  map[3] = 2
  map = {1: 0, 2: 1, 3: 2}

i=3, nums[3]=1:
  1 in map ✓
  last_index = map[1] = 0
  |3 - 0| = 3 <= 3 ✓
  → Return true

Result: true
```

### Step-by-Step for [1,2,3,1,2,3], k=2

```
Initial: map = {}

i=0, nums[0]=1:
  1 not in map
  map[1] = 0
  map = {1: 0}

i=1, nums[1]=2:
  2 not in map
  map[2] = 1
  map = {1: 0, 2: 1}

i=2, nums[2]=3:
  3 not in map
  map[3] = 2
  map = {1: 0, 2: 1, 3: 2}

i=3, nums[3]=1:
  1 in map ✓
  last_index = map[1] = 0
  |3 - 0| = 3 > 2 ✗
  map[1] = 3 (update)
  map = {1: 3, 2: 1, 3: 2}

i=4, nums[4]=2:
  2 in map ✓
  last_index = map[2] = 1
  |4 - 1| = 3 > 2 ✗
  map[2] = 4 (update)
  map = {1: 3, 2: 4, 3: 2}

i=5, nums[5]=3:
  3 in map ✓
  last_index = map[3] = 2
  |5 - 2| = 3 > 2 ✗
  map[3] = 5 (update)
  map = {1: 3, 2: 4, 3: 5}

No valid pairs → false
```

### Pseudocode
```
function containsNearbyDuplicate(nums, k):
    map = {}
    
    for i from 0 to len(nums)-1:
        if nums[i] in map:
            if i - map[nums[i]] <= k:
                return true
        
        map[nums[i]] = i
    
    return false
```

### Complexity Analysis
- **Time:** O(n) - Single pass through array
- **Space:** O(min(n, k)) - HashMap stores at most n elements

---

## Understanding the "seen" Set Pattern 🎯

### What is the "seen" Set?

The **"seen" set** is a data structure pattern used to track elements we've already encountered while iterating through a collection.

```python
seen = set()  # Empty set to track what we've "seen"

for element in array:
    if element in seen:
        # We've seen this before!
        return True
    seen.add(element)  # Mark as seen
```

### Why Use a Set (Not List or Array)?

**Performance Comparison:**

```python
# Using List (SLOW)
seen_list = []
for element in array:
    if element in seen_list:  # O(n) lookup!
        return True
    seen_list.append(element)
# Total: O(n²) time

# Using Set (FAST)
seen_set = set()
for element in array:
    if element in seen_set:  # O(1) lookup!
        return True
    seen_set.add(element)
# Total: O(n) time
```

**Why Set is Better:**

| Operation | List | Set |
|-----------|------|-----|
| **Lookup (x in container)** | O(n) | O(1) ⭐ |
| **Add element** | O(1) | O(1) |
| **Remove element** | O(n) | O(1) ⭐ |
| **Space** | O(n) | O(n) |

**Key Insight:** Sets use **hash tables** internally, giving O(1) average-case lookup!

### How Sets Work Internally

```
Set uses Hash Table:

When you add element to set:
1. Compute hash(element)
2. Store in hash table bucket
3. O(1) operation

When you check "element in set":
1. Compute hash(element)
2. Look up in hash table
3. O(1) operation

Example:
seen = {1, 5, 9}

Internal representation (simplified):
Bucket 0: []
Bucket 1: [1]
Bucket 2: []
Bucket 3: []
Bucket 4: []
Bucket 5: [5]
Bucket 6: []
Bucket 7: []
Bucket 8: []
Bucket 9: [9]

Check "5 in seen":
  → hash(5) = 5
  → Look at bucket 5
  → Found! O(1)
```

### When to Use the "seen" Set Pattern

**Use "seen" set when you need to:**

✅ **1. Detect Duplicates**
```python
# Problem: Find if array has duplicates
def hasDuplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True  # Found duplicate!
        seen.add(num)
    return False

# Example: [1,2,3,1]
# i=0: seen={1}
# i=1: seen={1,2}
# i=2: seen={1,2,3}
# i=3: 1 in seen → True!
```

✅ **2. Track Visited Elements**
```python
# Problem: Find first repeating character
def firstRepeating(s):
    seen = set()
    for char in s:
        if char in seen:
            return char  # First repeat!
        seen.add(char)
    return None

# Example: "abcabc"
# i=0: seen={'a'}
# i=1: seen={'a','b'}
# i=2: seen={'a','b','c'}
# i=3: 'a' in seen → return 'a'
```

✅ **3. Check Membership Quickly**
```python
# Problem: Find intersection of two arrays
def intersection(nums1, nums2):
    seen = set(nums1)  # Convert to set
    result = []
    for num in nums2:
        if num in seen:  # O(1) lookup!
            result.append(num)
    return result
```

✅ **4. Remove Duplicates**
```python
# Problem: Get unique elements
def uniqueElements(nums):
    seen = set()
    unique = []
    for num in nums:
        if num not in seen:
            unique.append(num)
            seen.add(num)
    return unique

# Or simply:
def uniqueElements(nums):
    return list(set(nums))
```

### When NOT to Use "seen" Set

❌ **1. Need to Preserve Order (Use dict instead)**
```python
# Wrong: Set doesn't preserve order
seen = set([3, 1, 2])
print(seen)  # Could be {1, 2, 3} or any order

# Right: Use dict (Python 3.7+) or OrderedDict
from collections import OrderedDict
seen = OrderedDict.fromkeys([3, 1, 2])
print(list(seen.keys()))  # [3, 1, 2] - order preserved
```

❌ **2. Need to Count Occurrences (Use Counter or dict)**
```python
# Wrong: Set only tracks presence
seen = set()
for num in [1, 1, 2, 2, 2]:
    seen.add(num)
print(seen)  # {1, 2} - lost count info!

# Right: Use Counter
from collections import Counter
count = Counter([1, 1, 2, 2, 2])
print(count)  # Counter({2: 3, 1: 2})
```

❌ **3. Need to Track Positions (Use dict)**
```python
# Wrong: Set doesn't store positions
seen = set()
for i, num in enumerate([1, 2, 3]):
    seen.add(num)  # Lost position info!

# Right: Use dict
positions = {}
for i, num in enumerate([1, 2, 3]):
    positions[num] = i
print(positions)  # {1: 0, 2: 1, 3: 2}
```

### Evolution: From List to Set to Sliding Window

**Problem: Contains Duplicate II**

**Approach 1: List (Naive)**
```python
def containsNearbyDuplicate(nums, k):
    seen = []  # Using list
    for i, num in enumerate(nums):
        if num in seen:  # O(n) lookup - SLOW!
            return True
        seen.append(num)
    return False

# Time: O(n²) - List lookup is O(n)
# Space: O(n)
```

**Approach 2: Set (Better)**
```python
def containsNearbyDuplicate(nums, k):
    seen = set()  # Using set
    for i, num in enumerate(nums):
        if num in seen:  # O(1) lookup - FAST!
            return True
        seen.add(num)
    return False

# Time: O(n) - Set lookup is O(1)
# Space: O(n)
# Problem: Doesn't check distance k!
```

**Approach 3: Sliding Window Set (Optimal)**
```python
def containsNearbyDuplicate(nums, k):
    seen = set()  # Sliding window
    for i, num in enumerate(nums):
        if i > k:
            seen.remove(nums[i - k - 1])  # Remove old
        
        if num in seen:  # O(1) lookup
            return True
        
        seen.add(num)
    return False

# Time: O(n) - Set operations are O(1)
# Space: O(k) - Only store k elements
# Perfect: Fast AND space-efficient!
```

### Visual: How "seen" Set Evolves

**Example: nums = [1,2,3,1,2,3], k = 2**

```
Without Sliding Window (stores everything):
i=0: seen = {1}
i=1: seen = {1, 2}
i=2: seen = {1, 2, 3}
i=3: seen = {1, 2, 3}  ← 1 already in seen, but too far!
i=4: seen = {1, 2, 3}  ← 2 already in seen, but too far!
i=5: seen = {1, 2, 3}  ← 3 already in seen, but too far!

Problem: Can't check distance!

With Sliding Window (stores only k+1 elements):
i=0: seen = {1}           window: [1]
i=1: seen = {1, 2}        window: [1, 2]
i=2: seen = {1, 2, 3}     window: [1, 2, 3]
i=3: seen = {2, 3, 1}     window: [2, 3, 1]  ← Removed 1, added 1
     1 not in {2,3} before adding → OK
i=4: seen = {3, 1, 2}     window: [3, 1, 2]  ← Removed 2, added 2
     2 not in {3,1} before adding → OK
i=5: seen = {1, 2, 3}     window: [1, 2, 3]  ← Removed 3, added 3
     3 not in {1,2} before adding → OK

Result: false (no duplicates within distance k)
```

### Common Patterns with "seen" Set

**Pattern 1: Simple Duplicate Detection**
```python
seen = set()
for element in array:
    if element in seen:
        return True
    seen.add(element)
return False
```

**Pattern 2: Sliding Window**
```python
seen = set()
for i in range(len(array)):
    if i > window_size:
        seen.remove(array[i - window_size - 1])
    
    if array[i] in seen:
        return True
    
    seen.add(array[i])
return False
```

**Pattern 3: Two Sets (Intersection)**
```python
seen1 = set(array1)
seen2 = set(array2)
intersection = seen1 & seen2  # Set intersection
```

**Pattern 4: Set with Condition**
```python
seen = set()
for element in array:
    if condition(element) and element in seen:
        return True
    if condition(element):
        seen.add(element)
return False
```

### Real-World Analogy

**Think of "seen" set like a bouncer's list at a club:**

```
Bouncer has a list of people who already entered:

Person arrives:
1. Check list: "Have you been here before?"
   - If YES → "You can't enter twice!" (duplicate found)
   - If NO → "Welcome! Let me add you to the list"

2. Add to list

With sliding window:
- List has limited space (only k people)
- When full, remove oldest person
- This is like "people who entered in last k minutes"

Example with k=2:
Time 0: Alice enters → List: [Alice]
Time 1: Bob enters → List: [Alice, Bob]
Time 2: Carol enters → List: [Alice, Bob, Carol]
Time 3: Alice tries again → List: [Bob, Carol]
        Alice not in list → OK, she left long ago
        Add Alice → List: [Bob, Carol, Alice]
```

### Memory Comparison

**Example: nums = [1,2,3,4,5,6,7,8,9,10], k = 3**

```
Approach 1: Store all elements
seen = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
Memory: 10 elements

Approach 2: Sliding window (k=3)
At any time: seen = {7, 8, 9, 10} (max 4 elements)
Memory: 4 elements (k+1)

Savings: 10 → 4 (60% reduction!)

For large arrays:
nums = 1 million elements, k = 100
Without window: 1,000,000 elements in memory
With window: 101 elements in memory
Savings: 99.99% reduction!
```

### Key Takeaways

1. **"seen" set = tracking what we've encountered**
2. **Set gives O(1) lookup** (vs O(n) for list)
3. **Use set when you only care about presence** (not count or position)
4. **Sliding window set = space-efficient** (O(k) vs O(n))
5. **Always check BEFORE adding** to avoid finding element itself

---

## Approach 4: Sliding Window with Set ⭐⭐⭐⭐

### Logic
Maintain a sliding window of size k using a set:
1. Keep a set of elements in current window
2. If current element is in set → duplicate found
3. Add current element to set
4. If window size > k, remove leftmost element
5. If no duplicate found, return false

### Visual Flow for [1,2,3,1], k=3

```
Initial: window = set(), i=0

i=0, nums[0]=1:
  1 not in window
  window.add(1)
  window = {1}
  window_size = 1 <= 3 ✓

i=1, nums[1]=2:
  2 not in window
  window.add(2)
  window = {1, 2}
  window_size = 2 <= 3 ✓

i=2, nums[2]=3:
  3 not in window
  window.add(3)
  window = {1, 2, 3}
  window_size = 3 <= 3 ✓

i=3, nums[3]=1:
  1 in window ✓
  → Return true

Result: true
```

### Step-by-Step for [1,2,3,1,2,3], k=2

```
Initial: window = set()

i=0, nums[0]=1:
  1 not in window
  window.add(1)
  window = {1}
  i > k? 0 > 2? No

i=1, nums[1]=2:
  2 not in window
  window.add(2)
  window = {1, 2}
  i > k? 1 > 2? No

i=2, nums[2]=3:
  3 not in window
  window.add(3)
  window = {1, 2, 3}
  i > k? 2 > 2? No

i=3, nums[3]=1:
  1 in window ✓
  But wait... let's check distance
  
  Actually, we need to remove nums[i-k-1]
  i > k? 3 > 2? Yes
  Remove nums[3-2-1] = nums[0] = 1
  window.remove(1)
  window = {2, 3}
  
  Now check: 1 in window? No
  window.add(1)
  window = {2, 3, 1}

i=4, nums[4]=2:
  i > k? 4 > 2? Yes
  Remove nums[4-2-1] = nums[1] = 2
  window.remove(2)
  window = {3, 1}
  
  2 in window? No
  window.add(2)
  window = {3, 1, 2}

i=5, nums[5]=3:
  i > k? 5 > 2? Yes
  Remove nums[5-2-1] = nums[2] = 3
  window.remove(3)
  window = {1, 2}
  
  3 in window? No
  window.add(3)
  window = {1, 2, 3}

No duplicates in any window → false
```

### Correct Implementation Logic

```
The key is to check BEFORE adding to window:

for i in range(len(nums)):
    # Step 1: Remove element outside window
    if i > k:
        window.remove(nums[i - k - 1])
    
    # Step 2: Check if current element is in window
    if nums[i] in window:
        return True  # Found duplicate within distance k
    
    # Step 3: Add current element to window
    window.add(nums[i])

return False
```

### Visual Window Movement

```
nums = [1,2,3,1,2,3], k = 2

Window size = k = 2

i=0: window = {1}           [1]
i=1: window = {1,2}         [1,2]
i=2: window = {1,2,3}       [1,2,3]  ← Size > k
i=3: window = {2,3,1}       [2,3,1]  ← Removed 1, added 1
i=4: window = {3,1,2}       [3,1,2]  ← Removed 2, added 2
i=5: window = {1,2,3}       [1,2,3]  ← Removed 3, added 3

At each step, check if element exists before adding
```

### Pseudocode
```
function containsNearbyDuplicate(nums, k):
    window = set()
    
    for i from 0 to len(nums)-1:
        // Remove element outside window
        if i > k:
            window.remove(nums[i - k - 1])
        
        // Check if duplicate in window
        if nums[i] in window:
            return true
        
        // Add current element
        window.add(nums[i])
    
    return false
```

### Complexity Analysis
- **Time:** O(n) - Single pass, O(1) set operations
- **Space:** O(min(n, k)) - Set stores at most k+1 elements

---

## Approach Comparison

| Aspect | Brute Force | Optimized BF | HashMap | Sliding Window |\n|--------|-------------|--------------|---------|----------------|\n| **Time Complexity** | O(n²) | O(n×k) | O(n) | O(n) |\n| **Space Complexity** | O(1) | O(1) | O(n) | O(k) |\n| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |\n| **Efficiency** | ⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |\n| **Best For** | Small arrays | Medium k | General case | Large arrays |\n

---

## Critical Insights

### 1. Why Sliding Window is Optimal

```
HashMap approach:
- Stores ALL seen elements
- Space: O(n) in worst case
- Example: [1,2,3,4,5], k=1
  map = {1:0, 2:1, 3:2, 4:3, 5:4}
  Stores 5 elements

Sliding Window approach:
- Stores only k+1 elements
- Space: O(k)
- Example: [1,2,3,4,5], k=1
  window = {4, 5} (max 2 elements)
  Stores 2 elements

When k << n, sliding window saves significant space!
```

### 2. The Window Size is k, Not k+1

```
Why we check i > k (not i >= k)?

Window should contain elements at indices:
[i-k, i-k+1, ..., i-1, i]

This is k+1 elements total!

Example: i=3, k=2
Window: [i-2, i-1, i] = [1, 2, 3]
That's 3 elements (k+1)

When i > k, we remove nums[i-k-1]:
i=3, k=2: remove nums[3-2-1] = nums[0]
```

### 3. Check Before Adding

```
Why check BEFORE adding to window?

Correct order:
1. Remove old element (if needed)
2. Check if current element exists
3. Add current element

Wrong order (check after adding):
1. Add current element
2. Check if exists
→ Will always find itself! ✗

Example: nums = [1,2,3], k=2
i=0: add 1, check → finds 1 (itself) ✗
```

### 4. Early Optimization

```
If no duplicates exist at all:
nums = [1,2,3,4,5], k=3

Quick check:
if len(nums) == len(set(nums)):
    return False

This avoids unnecessary processing!
```

### 5. Edge Case: k=0

```
k=0 means indices must be equal
But problem says "distinct indices"
So k=0 should always return False

if k == 0:
    return False
```

---

## Common Mistakes

### ❌ Mistake 1: Checking After Adding to Set

```python
# Wrong: Check after adding
if nums[i] in window:
    return True
window.add(nums[i])  # Will always find itself

# Correct: Check before adding
if nums[i] in window:
    return True
window.add(nums[i])
```

### ❌ Mistake 2: Wrong Window Size

```python
# Wrong: Remove when i >= k
if i >= k:
    window.remove(nums[i - k])

# Correct: Remove when i > k
if i > k:
    window.remove(nums[i - k - 1])
```

### ❌ Mistake 3: Not Updating HashMap

```python
# Wrong: Don't update index
if nums[i] in map:
    if i - map[nums[i]] <= k:
        return True
# Missing: map[nums[i]] = i

# Correct: Always update
if nums[i] in map:
    if i - map[nums[i]] <= k:
        return True
map[nums[i]] = i  # Update for next check
```

### ❌ Mistake 4: Using abs() Unnecessarily

```python
# Unnecessary: i is always > map[nums[i]]
if abs(i - map[nums[i]]) <= k:

# Better: i is always greater
if i - map[nums[i]] <= k:
```

### ❌ Mistake 5: Not Handling k=0

```python
# Wrong: Doesn't handle k=0
for i in range(len(nums)):
    # ... will check same index

# Correct: Early return
if k == 0:
    return False
```

---

## Edge Cases

| Input | Output | Reason |\n|-------|--------|--------|\n| `[1], k=1` | `false` | Single element |\n| `[1,1], k=0` | `false` | k=0, need distinct indices |\n| `[1,1], k=1` | `true` | Adjacent duplicates |\n| `[1,2,1], k=0` | `false` | k=0 always false |\n| `[1,2,1], k=2` | `true` | Duplicates within k |\n| `[1,2,3,4,5], k=10` | `false` | No duplicates |\n

---

## Pattern Recognition

### This Pattern Applies To:

1. **Contains Duplicate III** - Similar but with value difference
2. **Longest Substring Without Repeating Characters** - Sliding window
3. **Max Consecutive Ones III** - Sliding window with constraint
4. **Subarray Sum Equals K** - HashMap tracking

### Key Characteristics:
- Finding duplicates/patterns within distance
- Sliding window technique
- HashMap for tracking positions
- O(n) time optimization

---

## Complete Implementations

### Implementation 1: Brute Force
```python
def containsNearbyDuplicate(nums: List[int], k: int) -> bool:
    for i in range(len(nums)):
        for j in range(i + 1, len(nums)):
            if nums[i] == nums[j] and abs(i - j) <= k:
                return True
    return False
```

### Implementation 2: Optimized Brute Force
```python
def containsNearbyDuplicate(nums: List[int], k: int) -> bool:
    for i in range(len(nums)):
        for j in range(i + 1, min(i + k + 1, len(nums))):
            if nums[i] == nums[j]:
                return True
    return False
```

### Implementation 3: HashMap ⭐⭐⭐
```python
def containsNearbyDuplicate(nums: List[int], k: int) -> bool:
    map = {}
    
    for i in range(len(nums)):
        if nums[i] in map:
            if i - map[nums[i]] <= k:
                return True
        
        map[nums[i]] = i
    
    return False
```

### Implementation 4: Sliding Window ⭐⭐⭐⭐
```python
def containsNearbyDuplicate(nums: List[int], k: int) -> bool:
    window = set()
    
    for i in range(len(nums)):
        # Remove element outside window
        if i > k:
            window.remove(nums[i - k - 1])
        
        # Check if duplicate in window
        if nums[i] in window:
            return True
        
        # Add current element
        window.add(nums[i])
    
    return False
```

### Implementation 5: With Early Optimization
```python
def containsNearbyDuplicate(nums: List[int], k: int) -> bool:
    # Early exit if no duplicates at all
    if len(nums) == len(set(nums)):
        return False
    
    window = set()
    
    for i in range(len(nums)):
        if i > k:
            window.remove(nums[i - k - 1])
        
        if nums[i] in window:
            return True
        
        window.add(nums[i])
    
    return False
```

---

## Related Problems

| Problem | Similarity | Key Difference |\n|---------|-----------|----------------|\n| **Contains Duplicate** | Find duplicates | No distance constraint |\n| **Contains Duplicate III** | Distance constraint | Value difference constraint |\n| **Longest Substring Without Repeating** | Sliding window | Find longest, not boolean |\n| **Max Consecutive Ones III** | Sliding window | Different constraint |\n

---

## Day 54 Summary

### Problems Solved: 1
1. ✅ Contains Duplicate II

### Key Patterns Learned:
1. **Sliding Window** - Maintain window of size k
2. **HashMap Tracking** - Store last seen index
3. **Set for Duplicates** - O(1) lookup in window

### Techniques Mastered:
- Sliding window with set
- HashMap for position tracking
- Space optimization (O(k) vs O(n))
- Early termination checks

### Complexity Insights:
- Brute force: O(n²) time, O(1) space
- HashMap: O(n) time, O(n) space
- Sliding window: O(n) time, O(k) space (optimal!)
- Trade-off: Time vs space

### When to Use This Pattern:
- Finding patterns within distance k
- Duplicate detection with constraints
- Sliding window problems
- Position tracking problems

---

## Quick Reference

### Sliding Window Template
```python
def containsNearbyDuplicate(nums, k):
    window = set()
    
    for i in range(len(nums)):
        if i > k:
            window.remove(nums[i - k - 1])
        
        if nums[i] in window:
            return True
        
        window.add(nums[i])
    
    return False
```

### HashMap Template
```python
def containsNearbyDuplicate(nums, k):
    map = {}
    
    for i in range(len(nums)):
        if nums[i] in map and i - map[nums[i]] <= k:
            return True
        map[nums[i]] = i
    
    return False
```

### Key Formulas
```
Window size: k + 1 elements
Remove index: i - k - 1
Distance check: i - last_index <= k
```

### Common Patterns
```python
# Check before adding
if element in window:
    return True
window.add(element)

# Remove old element
if i > k:
    window.remove(nums[i - k - 1])

# Update position
map[nums[i]] = i
```
