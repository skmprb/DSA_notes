# Day 50: Count Elements With Maximum Frequency

## Problem Statement
**LeetCode 3005: Count Elements With Maximum Frequency**

You are given an array nums consisting of positive integers.

Return the total frequencies of elements in nums such that those elements all have the maximum frequency.

The frequency of an element is the number of occurrences of that element in the array.

**Examples:**
```
Input: nums = [1,2,2,3,1,4]
Output: 4
Explanation: Elements 1 and 2 both have frequency 2 (maximum).
Total count: 2 + 2 = 4

Input: nums = [1,2,3,4,5]
Output: 5
Explanation: All elements have frequency 1 (maximum).
Total count: 1 + 1 + 1 + 1 + 1 = 5

Input: nums = [1,2,2,2,3,1,1,4]
Output: 6
Explanation: Elements 1 and 2 both have frequency 3 (maximum).
Total count: 3 + 3 = 6
```

**Constraints:**
- 1 <= nums.length <= 100
- 1 <= nums[i] <= 100

---

## Problem Logic & Reasoning

### Core Concept
Find the **maximum frequency** in the array, then sum up the frequencies of all elements that have this maximum frequency.

**Key Insight:** We need to count frequencies AND track which elements have the maximum frequency.

### Visual Understanding for [1,2,2,3,1,4]

```
Array: [1, 2, 2, 3, 1, 4]

Frequency count:
1 → 2 times
2 → 2 times
3 → 1 time
4 → 1 time

Maximum frequency: 2

Elements with max frequency: 1 and 2
Total count: 2 + 2 = 4
```

### Breaking Down the Problem

```
Step 1: Count frequencies
{1: 2, 2: 2, 3: 1, 4: 1}

Step 2: Find maximum frequency
max_freq = 2

Step 3: Sum frequencies of elements with max_freq
Elements with freq=2: 1 and 2
Result: 2 + 2 = 4
```

---

## Approach 1: HashMap with Two Passes ⭐

### Logic
1. First pass: Count frequency of each element
2. Find maximum frequency
3. Second pass: Sum frequencies equal to maximum

### Visual Flow for [1,2,2,2,3,1,1,4]

```
Array: [1, 2, 2, 2, 3, 1, 1, 4]

Pass 1: Build frequency map
    i=0, num=1: freq={1:1}
    i=1, num=2: freq={1:1, 2:1}
    i=2, num=2: freq={1:1, 2:2}
    i=3, num=2: freq={1:1, 2:3}
    i=4, num=3: freq={1:1, 2:3, 3:1}
    i=5, num=1: freq={1:2, 2:3, 3:1}
    i=6, num=1: freq={1:3, 2:3, 3:1}
    i=7, num=4: freq={1:3, 2:3, 3:1, 4:1}

Find max frequency:
    max_freq = 3

Pass 2: Sum frequencies equal to max_freq
    1: freq=3 (equals max) → result += 3
    2: freq=3 (equals max) → result += 3
    3: freq=1 (not max)
    4: freq=1 (not max)

Result: 3 + 3 = 6
```

### Step-by-Step Execution

```
nums = [1,2,2,3,1,4]

Step 1: Count frequencies
    freq = {}
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
    
    freq = {1: 2, 2: 2, 3: 1, 4: 1}

Step 2: Find max frequency
    max_freq = max(freq.values())
    max_freq = 2

Step 3: Sum frequencies equal to max
    result = 0
    for count in freq.values():
        if count == max_freq:
            result += count
    
    1: count=2 → result = 0 + 2 = 2
    2: count=2 → result = 2 + 2 = 4
    3: count=1 (skip)
    4: count=1 (skip)

Result: 4
```

### Pseudocode
```
function maxFrequencyElements(nums):
    freq = {}
    
    // Count frequencies
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
    
    // Find maximum frequency
    max_freq = max(freq.values())
    
    // Sum frequencies equal to max
    result = 0
    for count in freq.values():
        if count == max_freq:
            result += count
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Two passes through array/map
- **Space:** O(k) - HashMap with k unique elements

---

## Approach 2: Single Pass with Tracking ⭐⭐

### Logic
Track maximum frequency while building the frequency map:
1. Count frequencies and update max_freq on the fly
2. When max_freq increases, reset result
3. When frequency equals max_freq, add to result

### Visual Flow for [1,2,2,3,1,4]

```
Initial: freq={}, max_freq=0, result=0

i=0, num=1:
    freq[1] = 1
    1 > 0 → max_freq=1, result=1
    State: freq={1:1}, max_freq=1, result=1

i=1, num=2:
    freq[2] = 1
    1 == 1 → result += 1
    State: freq={1:1, 2:1}, max_freq=1, result=2

i=2, num=2:
    freq[2] = 2
    2 > 1 → max_freq=2, result=2
    State: freq={1:1, 2:2}, max_freq=2, result=2

i=3, num=3:
    freq[3] = 1
    1 < 2 → no change
    State: freq={1:1, 2:2, 3:1}, max_freq=2, result=2

i=4, num=1:
    freq[1] = 2
    2 == 2 → result += 2
    State: freq={1:2, 2:2, 3:1}, max_freq=2, result=4

i=5, num=4:
    freq[4] = 1
    1 < 2 → no change
    State: freq={1:2, 2:2, 3:1, 4:1}, max_freq=2, result=4

Result: 4
```

### Pseudocode
```
function maxFrequencyElements(nums):
    freq = {}
    max_freq = 0
    result = 0
    
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
        current_freq = freq[num]
        
        if current_freq > max_freq:
            max_freq = current_freq
            result = current_freq
        elif current_freq == max_freq:
            result += current_freq
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Single pass
- **Space:** O(k) - HashMap with k unique elements

---

## Approach 3: Using Counter (Python)

### Logic
Use Python's Counter for cleaner frequency counting.

### Pseudocode
```
from collections import Counter

function maxFrequencyElements(nums):
    freq = Counter(nums)
    max_freq = max(freq.values())
    
    result = sum(count for count in freq.values() if count == max_freq)
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Counter is O(n), max is O(k), sum is O(k)
- **Space:** O(k) - Counter storage

---

## Approach Comparison

| Aspect | Two Pass | Single Pass | Counter |
|--------|----------|-------------|---------|
| **Time Complexity** | O(n) | O(n) | O(n) |
| **Space Complexity** | O(k) | O(k) | O(k) |
| **Passes** | 2 | 1 | 2 |
| **Readability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Best For** | Understanding | Optimization | Python |

---

## Critical Insights

### 1. What We're Counting
```
NOT: Number of unique elements with max frequency
BUT: Total count of all occurrences of elements with max frequency

Example: [1,2,2,3,1,4]
Elements with max freq: 1 and 2
Answer: 2 + 2 = 4 (not 2!)
```

### 2. When Max Frequency Changes
```
Single pass approach:
When new max found → reset result to new max
When equal to max → add to result

Example: [1,2,2]
1: max=1, result=1
2: max=1, result=2 (equal)
2: max=2, result=2 (new max, reset!)
```

### 3. Edge Case: All Same Frequency
```
nums = [1,2,3,4,5]
All have frequency 1
Result: 1+1+1+1+1 = 5 (length of array)
```

### 4. Edge Case: All Same Element
```
nums = [1,1,1,1]
Only 1 has frequency 4
Result: 4
```

### 5. Why Track During Build?
```
Two pass: Simple but requires two iterations
Single pass: More complex logic but one iteration
Trade-off: Simplicity vs efficiency
```

---

## Common Mistakes

### ❌ Mistake 1: Counting Elements Instead of Frequencies
```python
# Wrong: Count number of elements with max freq
result = 0
for count in freq.values():
    if count == max_freq:
        result += 1  # Wrong! Should be += count
```
**Impact:** [1,2,2,3,1,4] → returns 2 instead of 4

### ❌ Mistake 2: Not Resetting Result in Single Pass
```python
if current_freq > max_freq:
    max_freq = current_freq
    # Missing: result = current_freq
    result += current_freq  # Wrong! Accumulates old values
```

### ❌ Mistake 3: Wrong Initial max_freq
```python
max_freq = 1  # Wrong! Should be 0
# Fails when all elements appear once
```

### ❌ Mistake 4: Not Handling Empty Array
```python
max_freq = max(freq.values())  # ValueError if freq is empty
```

### ❌ Mistake 5: Modifying While Iterating
```python
for num in nums:
    freq[num] += 1
    if freq[num] == max_freq:
        result += freq[num]
        del freq[num]  # Wrong! Don't modify during iteration
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `[1]` | `1` | Single element |
| `[1,1,1]` | `3` | All same element |
| `[1,2,3]` | `3` | All frequency 1 |
| `[1,1,2,2]` | `4` | Two elements with max freq |
| `[1,2,2,2]` | `3` | One element with max freq |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Top K Frequent Elements** - Find k most frequent
2. **Sort Characters by Frequency** - Order by frequency
3. **First Unique Character** - Find frequency 1
4. **Majority Element** - Element with freq > n/2

### Key Characteristics:
- Frequency counting
- HashMap/Counter usage
- Finding maximum/minimum frequency
- Aggregating based on frequency

---

## Complete Implementations

### Implementation 1: Two Pass ⭐
```python
def maxFrequencyElements(nums: List[int]) -> int:
    # Count frequencies
    freq = {}
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
    
    # Find max frequency
    max_freq = max(freq.values())
    
    # Sum frequencies equal to max
    result = 0
    for count in freq.values():
        if count == max_freq:
            result += count
    
    return result
```

### Implementation 2: Single Pass ⭐⭐
```python
def maxFrequencyElements(nums: List[int]) -> int:
    freq = {}
    max_freq = 0
    result = 0
    
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
        current_freq = freq[num]
        
        if current_freq > max_freq:
            max_freq = current_freq
            result = current_freq
        elif current_freq == max_freq:
            result += current_freq
    
    return result
```

### Implementation 3: Using Counter
```python
from collections import Counter

def maxFrequencyElements(nums: List[int]) -> int:
    freq = Counter(nums)
    max_freq = max(freq.values())
    
    return sum(count for count in freq.values() if count == max_freq)
```

### Implementation 4: One-Liner (Python)
```python
from collections import Counter

def maxFrequencyElements(nums: List[int]) -> int:
    c = Counter(nums)
    return sum(v for v in c.values() if v == max(c.values()))
```

### Implementation 5: Using defaultdict
```python
from collections import defaultdict

def maxFrequencyElements(nums: List[int]) -> int:
    freq = defaultdict(int)
    
    for num in nums:
        freq[num] += 1
    
    max_freq = max(freq.values())
    
    return sum(count for count in freq.values() if count == max_freq)
```

---

## Optimization Techniques

### 1. Early Exit (Not Applicable)
```python
# Can't exit early - need to process all elements
# to know the true maximum frequency
```

### 2. Use Counter for Cleaner Code
```python
from collections import Counter
freq = Counter(nums)  # More Pythonic
```

### 3. Combine Operations
```python
# Instead of separate loops
max_freq = max(freq.values())
result = sum(c for c in freq.values() if c == max_freq)
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Top K Frequent Elements** | Frequency counting | Find k most frequent |
| **Sort by Frequency** | Frequency counting | Sort by frequency |
| **Majority Element** | Frequency counting | Find freq > n/2 |
| **First Unique Character** | Frequency counting | Find freq = 1 |

---

## Day 50 Summary

### Problems Solved: 1
1. ✅ Count Elements With Maximum Frequency

### Key Patterns Learned:
1. **Frequency Counting** - Using HashMap to count occurrences
2. **Maximum Tracking** - Finding and using maximum frequency
3. **Conditional Aggregation** - Summing based on condition

### Techniques Mastered:
- HashMap frequency counting
- Single pass vs two pass trade-offs
- Using Counter for cleaner code
- Tracking maximum while building map

### Complexity Insights:
- All approaches: O(n) time, O(k) space
- Single pass slightly more efficient
- Counter provides cleaner syntax
- Space depends on unique elements (k ≤ n)

### When to Use This Pattern:
- Frequency-based problems
- Finding elements with specific frequency
- Aggregating based on frequency
- Counting occurrences

---

## Quick Reference

### Frequency Counting Template
```python
def frequency_problem(nums):
    freq = {}
    
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
    
    # Process frequencies
    max_freq = max(freq.values())
    
    # Aggregate based on condition
    result = sum(count for count in freq.values() 
                 if condition(count, max_freq))
    
    return result
```

### Single Pass Template
```python
def single_pass_frequency(nums):
    freq = {}
    max_freq = 0
    result = 0
    
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
        current = freq[num]
        
        if current > max_freq:
            max_freq = current
            result = current
        elif current == max_freq:
            result += current
    
    return result
```

### Counter Template (Python)
```python
from collections import Counter

def counter_approach(nums):
    freq = Counter(nums)
    max_freq = max(freq.values())
    
    return sum(c for c in freq.values() if c == max_freq)
```

### Common Frequency Operations
```python
# Count frequencies
freq = Counter(nums)

# Get max frequency
max_freq = max(freq.values())

# Get elements with max frequency
max_elements = [k for k, v in freq.items() if v == max_freq]

# Sum frequencies equal to max
total = sum(v for v in freq.values() if v == max_freq)

# Count elements with max frequency
count = sum(1 for v in freq.values() if v == max_freq)
```
