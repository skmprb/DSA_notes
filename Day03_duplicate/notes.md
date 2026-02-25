# Day 03 - Hash Set & Prefix/Suffix Products

## Problem 1: Contains Duplicate

### Problem Statement

Given an integer array `nums`, return `true` if any value appears at least twice, and `false` if every element is distinct.

**Examples:**
```python
Input: nums = [1,2,3,1]
Output: True

Input: nums = [1,2,3,4]
Output: False
```

### Pattern Recognition

**This is a Hash Set problem!**

Why?
- ✅ Need to track seen elements
- ✅ Need O(1) lookup
- ✅ Checking for duplicates
- ✅ Don't need to count frequency (just existence)

### Solution Approaches

#### Approach 1: Brute Force (DON'T USE)
```python
def contains_duplicate(nums):
    # Time: O(n²), Space: O(1)
    for num in nums:
        if num in nums[nums.index(num) + 1:]:
            return True
    return False
```
**Issues:**
- ❌ O(n²) time complexity
- ❌ Slicing creates new list each time
- ❌ `index()` is O(n) inside loop

#### Approach 2: Hash Set (OPTIMAL)
```python
def contains_duplicate(nums):
    # Time: O(n), Space: O(n)
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
```
**Why optimal:**
- ✅ O(n) time - single pass
- ✅ O(n) space - worst case all unique
- ✅ Early return on first duplicate
- ✅ Clean and readable

#### Approach 3: Set Length Comparison (CLEVER)
```python
def contains_duplicate(nums):
    # Time: O(n), Space: O(n)
    return len(nums) != len(set(nums))
```
**Pros:**
- ✅ One-liner
- ✅ O(n) time and space
- ✅ Very concise

**Cons:**
- ❌ Always processes entire array (no early return)
- ❌ Creates entire set even if duplicate is at start

#### Approach 4: Sorting
```python
def contains_duplicate(nums):
    # Time: O(n log n), Space: O(1) or O(n) depending on sort
    nums = sorted(nums)
    for i in range(len(nums) - 1):
        if nums[i] == nums[i + 1]:
            return True
    return False
```
**When to use:**
- ✅ Memory constrained (O(1) space if in-place sort)
- ❌ Slower than hash set (O(n log n) vs O(n))

### Complexity Comparison

| Approach | Time | Space | Early Return | Best For |
|----------|------|-------|--------------|----------|
| Brute Force | O(n²) | O(1) | ✅ | Never use |
| Hash Set | O(n) | O(n) | ✅ | **Optimal** |
| Set Length | O(n) | O(n) | ❌ | Code golf |
| Sorting | O(n log n) | O(1) | ✅ | Memory constrained |

### Key Takeaways

1. **Hash Set is optimal** for duplicate detection
2. **Early return** saves time when duplicate found early
3. **One-liners aren't always better** - consider early return
4. **Set operations** are O(n) for creation

---

## Problem 2: Product of Array Except Self

### Problem Statement

Given an integer array `nums`, return an array `output` where `output[i]` is the product of all elements except `nums[i]`.

**Constraints:**
- Must run in O(n) time
- Cannot use division operator
- Follow-up: Can you do it in O(1) extra space?

**Examples:**
```python
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
Explanation: 
  output[0] = 2*3*4 = 24
  output[1] = 1*3*4 = 12
  output[2] = 1*2*4 = 8
  output[3] = 1*2*3 = 6

Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```

### Pattern Recognition

**This is a Prefix/Suffix Product pattern!**

Why?
- ✅ Need product of all elements except current
- ✅ Can split into left product × right product
- ✅ Prefix array stores left products
- ✅ Suffix array stores right products

### Solution Approaches

#### Approach 1: Prefix & Suffix Arrays (CLEAR)
```python
def product_except_self(nums):
    # Time: O(n), Space: O(n)
    n = len(nums)
    output = [1] * n
    prefix = [1] * n
    suffix = [1] * n
    
    # Build prefix products
    for i in range(1, n):
        prefix[i] = prefix[i-1] * nums[i-1]
    
    # Build suffix products
    for i in range(n-2, -1, -1):
        suffix[i] = suffix[i+1] * nums[i+1]
    
    # Combine prefix and suffix
    for i in range(n):
        output[i] = prefix[i] * suffix[i]
    
    return output
```

**Visualization:**
```
nums   = [1, 2, 3, 4]
prefix = [1, 1, 2, 6]  # product of all elements to the left
suffix = [24,12,4, 1]  # product of all elements to the right
output = [24,12,8, 6]  # prefix[i] * suffix[i]
```

**Why it works:**
- `prefix[i]` = product of all elements before index i
- `suffix[i]` = product of all elements after index i
- `output[i]` = prefix[i] × suffix[i] = product except self

#### Approach 2: Optimized O(1) Space (OPTIMAL)
```python
def product_except_self(nums):
    # Time: O(n), Space: O(1) - output array doesn't count
    n = len(nums)
    output = [1] * n
    
    # Build prefix products in output array
    for i in range(1, n):
        output[i] = output[i-1] * nums[i-1]
    
    # Multiply by suffix products on the fly
    suffix = 1
    for i in range(n-2, -1, -1):
        suffix *= nums[i+1]
        output[i] *= suffix
    
    return output
```

**Key insight:**
- Store prefix products in output array
- Calculate suffix products on the fly (no extra array needed)
- Multiply suffix into output as we go

**Step-by-step for [1,2,3,4]:**
```
After prefix pass:
output = [1, 1, 2, 6]

Suffix pass (right to left):
i=2: suffix=4, output[2] = 2*4 = 8
i=1: suffix=12, output[1] = 1*12 = 12
i=0: suffix=24, output[0] = 1*24 = 24

Final: [24, 12, 8, 6]
```

#### Approach 3: Using Division (BREAKS CONSTRAINTS)
```python
def product_except_self(nums):
    # Works only with no zeros
    # Time: O(n), Space: O(1)
    res = [0] * len(nums)
    prod = 1
    
    for i in range(len(nums)):
        prod *= nums[i]
    
    for i in range(len(nums)):
        res[i] = prod // nums[i]
    
    return res
```
**Issues:**
- ❌ Uses division (violates constraint)
- ❌ Fails with zeros in array
- ❌ Not the intended solution

#### Approach 4: Handling Zeros with Division
```python
def product_except_self(nums):
    # Time: O(n), Space: O(1)
    res = [0] * len(nums)
    prod = 1
    zeros = 0
    idx = -1
    
    for i in range(len(nums)):
        if nums[i] == 0:
            zeros += 1
            idx = i
        else:
            prod *= nums[i]
    
    if zeros == 0:
        for i in range(len(nums)):
            res[i] = prod // nums[i]
    elif zeros == 1:
        res[idx] = prod
    # If zeros >= 2, all results are 0
    
    return res
```
**Issues:**
- ❌ Still uses division
- ❌ Overly complex with zero handling
- ❌ Not the intended approach

### Complexity Comparison

| Approach | Time | Space | Uses Division | Handles Zeros |
|----------|------|-------|---------------|---------------|
| Prefix + Suffix Arrays | O(n) | O(n) | ❌ | ✅ |
| Optimized O(1) Space | O(n) | O(1) | ❌ | ✅ |
| Division (no zeros) | O(n) | O(1) | ✅ | ❌ |
| Division (with zeros) | O(n) | O(1) | ✅ | ✅ |

### Key Insights

**Why Prefix/Suffix works:**
```
For nums = [a, b, c, d]

output[0] = b * c * d = (1) * (b*c*d)
output[1] = a * c * d = (a) * (c*d)
output[2] = a * b * d = (a*b) * (d)
output[3] = a * b * c = (a*b*c) * (1)

Left part = prefix products
Right part = suffix products
```

**Space optimization:**
- Output array doesn't count toward space complexity
- Can reuse output array to store prefix products
- Calculate suffix products on the fly

**Why not use division:**
- Problem explicitly forbids it
- Teaches prefix/suffix pattern
- Division fails with zeros

### Common Mistakes

❌ **Using division when not allowed**
```python
# DON'T
res[i] = total_product // nums[i]
```

❌ **Creating unnecessary arrays**
```python
# DON'T - uses O(n) extra space
prefix = [1] * n
suffix = [1] * n
```

❌ **Not handling zeros properly**
```python
# DON'T - fails with zeros
prod // nums[i]  # Division by zero!
```

✅ **Use prefix/suffix pattern**
```python
# DO - O(1) space, no division
output[i] = output[i-1] * nums[i-1]  # prefix
output[i] *= suffix  # multiply by suffix
```

---

## Pattern Summary

### Hash Set Pattern (Contains Duplicate)

**When to use:**
- Checking for duplicates
- Tracking seen elements
- Need O(1) lookup
- Don't need to count frequency

**Template:**
```python
def has_duplicate(arr):
    seen = set()
    for item in arr:
        if item in seen:
            return True
        seen.add(item)
    return False
```

### Prefix/Suffix Pattern (Product Except Self)

**When to use:**
- Need product/sum of all elements except current
- Can split into left and right parts
- Need O(n) solution without division

**Template:**
```python
def prefix_suffix(nums):
    n = len(nums)
    output = [1] * n
    
    # Build prefix in output
    for i in range(1, n):
        output[i] = output[i-1] * nums[i-1]
    
    # Multiply by suffix on the fly
    suffix = 1
    for i in range(n-2, -1, -1):
        suffix *= nums[i+1]
        output[i] *= suffix
    
    return output
```

---

## Quick Reference

### Contains Duplicate
- **Pattern:** Hash Set
- **Time:** O(n)
- **Space:** O(n)
- **Key:** Track seen elements

### Product Except Self
- **Pattern:** Prefix/Suffix Products
- **Time:** O(n)
- **Space:** O(1) excluding output
- **Key:** Left product × Right product

### When to Use Each Pattern

| Problem Type | Pattern | Indicator |
|-------------|---------|-----------|
| Find duplicates | Hash Set | "duplicate", "unique" |
| Product except self | Prefix/Suffix | "except current", "all but one" |
| Running sum/product | Prefix Array | "sum up to index i" |
| Range queries | Prefix Sum | "sum from i to j" |

---

## Practice Problems

### Hash Set Pattern
1. Contains Duplicate
2. Contains Duplicate II (with distance k)
3. Longest Consecutive Sequence
4. Happy Number
5. Intersection of Two Arrays

### Prefix/Suffix Pattern
1. Product of Array Except Self
2. Trapping Rain Water
3. Candy
4. Best Time to Buy and Sell Stock III
5. Maximum Product Subarray

---

## Key Takeaways

1. **Hash Set** is optimal for duplicate detection - O(n) time, O(n) space
2. **Early return** can save time in hash set approach
3. **Prefix/Suffix** pattern avoids division and handles zeros
4. **Space optimization** - reuse output array for prefix products
5. **One-liners** aren't always better - consider early return
6. **Division** is not always the answer - learn the pattern

**Golden Rule:** Choose the right data structure (Set vs Array) based on what you need to track!
