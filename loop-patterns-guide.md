# Python Loop Patterns - Complete Guide

## Table of Contents
1. [Basic Loops](#basic-loops)
2. [Range Function](#range-function)
3. [Forward Iteration](#forward-iteration)
4. [Backward Iteration](#backward-iteration)
5. [Step Iteration](#step-iteration)
6. [Enumerate](#enumerate)
7. [Multiple Arrays](#multiple-arrays)
8. [Nested Loops](#nested-loops)
9. [Loop Control](#loop-control)
10. [Common Patterns](#common-patterns)

---

## 1. Basic Loops

### For Loop
```python
# Iterate over list
arr = [1, 2, 3, 4, 5]
for item in arr:
    print(item)

# Iterate over string
for char in "hello":
    print(char)

# Iterate over dict
d = {'a': 1, 'b': 2}
for key in d:
    print(key, d[key])
```

### While Loop
```python
# Basic while
i = 0
while i < 5:
    print(i)
    i += 1

# While with condition
arr = [1, 2, 3, 4, 5]
i = 0
while i < len(arr):
    print(arr[i])
    i += 1
```

---

## 2. Range Function

### Syntax
```python
range(stop)              # 0 to stop-1
range(start, stop)       # start to stop-1
range(start, stop, step) # start to stop-1 with step
```

### Examples
```python
# range(stop)
for i in range(5):
    print(i)             # 0, 1, 2, 3, 4

# range(start, stop)
for i in range(2, 5):
    print(i)             # 2, 3, 4

# range(start, stop, step)
for i in range(0, 10, 2):
    print(i)             # 0, 2, 4, 6, 8

# Convert to list
lst = list(range(5))     # [0, 1, 2, 3, 4]
```

---

## 3. Forward Iteration (Increasing Order)

### Method 1: Direct Iteration
```python
arr = [10, 20, 30, 40, 50]

# Iterate over values
for value in arr:
    print(value)         # 10, 20, 30, 40, 50
```

### Method 2: Index-based (0 to n-1)
```python
arr = [10, 20, 30, 40, 50]
n = len(arr)

# Using range(n)
for i in range(n):
    print(i, arr[i])     # 0 10, 1 20, 2 30, 3 40, 4 50

# Using range(len(arr))
for i in range(len(arr)):
    print(i, arr[i])
```

### Method 3: Start from Index 1
```python
arr = [10, 20, 30, 40, 50]
n = len(arr)

# Skip first element
for i in range(1, n):
    print(i, arr[i])     # 1 20, 2 30, 3 40, 4 50
```

### Method 4: Custom Start and End
```python
arr = [10, 20, 30, 40, 50]

# From index 1 to 3
for i in range(1, 4):
    print(i, arr[i])     # 1 20, 2 30, 3 40
```

---

## 4. Backward Iteration (Decreasing Order)

### Method 1: Reversed List
```python
arr = [10, 20, 30, 40, 50]

# Iterate in reverse
for value in reversed(arr):
    print(value)         # 50, 40, 30, 20, 10

# Using slicing
for value in arr[::-1]:
    print(value)         # 50, 40, 30, 20, 10
```

### Method 2: Index from n-1 to 0
```python
arr = [10, 20, 30, 40, 50]
n = len(arr)

# range(start, stop, step)
# start = n-1, stop = -1 (to include 0), step = -1
for i in range(n-1, -1, -1):
    print(i, arr[i])     # 4 50, 3 40, 2 30, 1 20, 0 10
```

**Explanation:**
- `n-1`: Start from last index (4)
- `-1`: Stop before -1 (includes 0)
- `-1`: Step backward by 1

### Method 3: From n-2 to 0 (Skip Last)
```python
arr = [10, 20, 30, 40, 50]
n = len(arr)

# Skip last element
for i in range(n-2, -1, -1):
    print(i, arr[i])     # 3 40, 2 30, 1 20, 0 10
```

**Use case:** Product except self (suffix calculation)
```python
# Calculate suffix products
suffix = 1
for i in range(n-2, -1, -1):
    suffix *= nums[i+1]
    output[i] *= suffix
```

### Method 4: From n-1 to 1 (Skip First)
```python
arr = [10, 20, 30, 40, 50]
n = len(arr)

# Skip first element (stop at index 1)
for i in range(n-1, 0, -1):
    print(i, arr[i])     # 4 50, 3 40, 2 30, 1 20
```

### Method 5: Custom Range Backward
```python
arr = [10, 20, 30, 40, 50]

# From index 3 to 1
for i in range(3, 0, -1):
    print(i, arr[i])     # 3 40, 2 30, 1 20
```

---

## 5. Step Iteration

### Every 2nd Element
```python
arr = [10, 20, 30, 40, 50, 60]

# Forward with step 2
for i in range(0, len(arr), 2):
    print(i, arr[i])     # 0 10, 2 30, 4 50

# Backward with step 2
for i in range(len(arr)-1, -1, -2):
    print(i, arr[i])     # 5 60, 3 40, 1 20
```

### Every 3rd Element
```python
arr = [10, 20, 30, 40, 50, 60, 70, 80, 90]

# Every 3rd element
for i in range(0, len(arr), 3):
    print(i, arr[i])     # 0 10, 3 40, 6 70
```

### Custom Step
```python
arr = list(range(20))

# Start at 2, step by 3
for i in range(2, len(arr), 3):
    print(i, arr[i])     # 2 2, 5 5, 8 8, 11 11, 14 14, 17 17
```

---

## 6. Enumerate

### Basic Enumerate
```python
arr = ['a', 'b', 'c', 'd']

# Get index and value
for i, value in enumerate(arr):
    print(i, value)      # 0 a, 1 b, 2 c, 3 d
```

### Enumerate with Start Index
```python
arr = ['a', 'b', 'c', 'd']

# Start counting from 1
for i, value in enumerate(arr, start=1):
    print(i, value)      # 1 a, 2 b, 3 c, 4 d

# Start from 10
for i, value in enumerate(arr, start=10):
    print(i, value)      # 10 a, 11 b, 12 c, 13 d
```

### Enumerate in Reverse
```python
arr = ['a', 'b', 'c', 'd']

# Reverse with enumerate
for i, value in enumerate(reversed(arr)):
    print(i, value)      # 0 d, 1 c, 2 b, 3 a

# Reverse with original indices
for i, value in enumerate(arr[::-1]):
    print(len(arr)-1-i, value)  # 3 d, 2 c, 1 b, 0 a
```

---

## 7. Multiple Arrays (Zip)

### Iterate Two Arrays
```python
names = ['Alice', 'Bob', 'Charlie']
ages = [25, 30, 35]

# Zip two arrays
for name, age in zip(names, ages):
    print(f"{name} is {age}")
    # Alice is 25
    # Bob is 30
    # Charlie is 35
```

### Iterate Three Arrays
```python
names = ['Alice', 'Bob', 'Charlie']
ages = [25, 30, 35]
cities = ['NYC', 'LA', 'Chicago']

for name, age, city in zip(names, ages, cities):
    print(f"{name}, {age}, {city}")
```

### Zip with Index
```python
names = ['Alice', 'Bob', 'Charlie']
ages = [25, 30, 35]

for i, (name, age) in enumerate(zip(names, ages)):
    print(i, name, age)  # 0 Alice 25, 1 Bob 30, 2 Charlie 35
```

### Unequal Length (stops at shortest)
```python
arr1 = [1, 2, 3, 4, 5]
arr2 = [10, 20, 30]

for a, b in zip(arr1, arr2):
    print(a, b)          # 1 10, 2 20, 3 30
```

---

## 8. Nested Loops

### 2D Array Iteration
```python
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

# Iterate rows and columns
for i in range(len(matrix)):
    for j in range(len(matrix[0])):
        print(f"[{i}][{j}] = {matrix[i][j]}")
```

### Direct 2D Iteration
```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Iterate rows
for row in matrix:
    for value in row:
        print(value)

# With enumerate
for i, row in enumerate(matrix):
    for j, value in enumerate(row):
        print(f"[{i}][{j}] = {value}")
```

### Triangular Iteration
```python
n = 5

# Upper triangle (i < j)
for i in range(n):
    for j in range(i+1, n):
        print(f"({i}, {j})")

# Lower triangle (i > j)
for i in range(n):
    for j in range(i):
        print(f"({i}, {j})")
```

---

## 9. Loop Control

### Break (Exit Loop)
```python
arr = [1, 2, 3, 4, 5]

for i in range(len(arr)):
    if arr[i] == 3:
        break            # Exit loop
    print(arr[i])        # 1, 2
```

### Continue (Skip Iteration)
```python
arr = [1, 2, 3, 4, 5]

for i in range(len(arr)):
    if arr[i] == 3:
        continue         # Skip this iteration
    print(arr[i])        # 1, 2, 4, 5
```

### Else with Loop
```python
arr = [1, 2, 3, 4, 5]

# Else executes if loop completes without break
for i in range(len(arr)):
    if arr[i] == 10:
        print("Found 10")
        break
else:
    print("10 not found")  # This executes
```

### Pass (Do Nothing)
```python
for i in range(5):
    if i == 2:
        pass             # Placeholder, do nothing
    print(i)             # 0, 1, 2, 3, 4
```

---

## 10. Common Patterns

### Pattern 1: Two Pointers (Opposite Direction)
```python
arr = [1, 2, 3, 4, 5]
left, right = 0, len(arr) - 1

while left < right:
    print(arr[left], arr[right])
    left += 1
    right -= 1
# Output: 1 5, 2 4, 3 (middle)
```

### Pattern 2: Sliding Window (Fixed Size)
```python
arr = [1, 2, 3, 4, 5, 6]
k = 3

# First window
window_sum = sum(arr[:k])

# Slide window
for i in range(k, len(arr)):
    window_sum += arr[i] - arr[i-k]
    print(f"Window: {arr[i-k+1:i+1]}, Sum: {window_sum}")
```

### Pattern 3: Sliding Window (Variable Size)
```python
arr = [1, 2, 3, 4, 5]
target = 7
left = 0

for right in range(len(arr)):
    # Expand window
    while condition:
        # Shrink window
        left += 1
    # Process window
```

### Pattern 4: Prefix Sum
```python
arr = [1, 2, 3, 4, 5]
n = len(arr)
prefix = [0] * n
prefix[0] = arr[0]

# Build prefix sum
for i in range(1, n):
    prefix[i] = prefix[i-1] + arr[i]

print(prefix)  # [1, 3, 6, 10, 15]
```

### Pattern 5: Suffix Product
```python
arr = [1, 2, 3, 4]
n = len(arr)
output = [1] * n

# Build suffix products (right to left)
suffix = 1
for i in range(n-2, -1, -1):
    suffix *= arr[i+1]
    output[i] *= suffix

print(output)
```

### Pattern 6: Skip First/Last
```python
arr = [1, 2, 3, 4, 5]

# Skip first
for i in range(1, len(arr)):
    print(arr[i])        # 2, 3, 4, 5

# Skip last
for i in range(len(arr) - 1):
    print(arr[i])        # 1, 2, 3, 4

# Skip both
for i in range(1, len(arr) - 1):
    print(arr[i])        # 2, 3, 4
```

### Pattern 7: Compare Adjacent Elements
```python
arr = [1, 2, 2, 3, 4, 4, 5]

# Compare with next
for i in range(len(arr) - 1):
    if arr[i] == arr[i+1]:
        print(f"Duplicate at {i}: {arr[i]}")

# Compare with previous
for i in range(1, len(arr)):
    if arr[i] == arr[i-1]:
        print(f"Duplicate at {i}: {arr[i]}")
```

### Pattern 8: Every Pair (Nested)
```python
arr = [1, 2, 3, 4]

# All pairs (i, j) where i < j
for i in range(len(arr)):
    for j in range(i+1, len(arr)):
        print(f"({arr[i]}, {arr[j]})")
```

### Pattern 9: Fast & Slow Pointers
```python
arr = [1, 1, 2, 2, 3, 4, 4, 5]
slow = 0

# Remove duplicates in-place
for fast in range(1, len(arr)):
    if arr[fast] != arr[slow]:
        slow += 1
        arr[slow] = arr[fast]

print(arr[:slow+1])  # [1, 2, 3, 4, 5]
```

### Pattern 10: Reverse Pairs
```python
arr = [1, 2, 3, 4, 5]
n = len(arr)

# Process pairs from both ends
for i in range(n // 2):
    left = arr[i]
    right = arr[n-1-i]
    print(f"Pair: {left}, {right}")
# Output: 1 5, 2 4, 3 (middle if odd length)
```

---

## Range Patterns Cheat Sheet

```python
n = len(arr)

# Forward
range(n)                    # 0, 1, 2, ..., n-1
range(1, n)                 # 1, 2, 3, ..., n-1
range(0, n, 2)              # 0, 2, 4, ..., n-2 or n-1

# Backward
range(n-1, -1, -1)          # n-1, n-2, ..., 1, 0
range(n-2, -1, -1)          # n-2, n-3, ..., 1, 0 (skip last)
range(n-1, 0, -1)           # n-1, n-2, ..., 2, 1 (skip first)

# Custom
range(1, n-1)               # 1, 2, ..., n-2 (skip first and last)
range(start, end)           # start to end-1
range(start, end, step)     # start to end-1 with step
```

---

## Visual Examples

### Forward: range(5)
```
Index: 0 → 1 → 2 → 3 → 4
```

### Backward: range(4, -1, -1)
```
Index: 4 → 3 → 2 → 1 → 0
```

### Skip First: range(1, 5)
```
Index: 1 → 2 → 3 → 4
```

### Skip Last: range(4)
```
Index: 0 → 1 → 2 → 3
```

### Skip Both: range(1, 4)
```
Index: 1 → 2 → 3
```

### Step 2: range(0, 6, 2)
```
Index: 0 → 2 → 4
```

### Backward Skip Last: range(3, -1, -1)
```
Index: 3 → 2 → 1 → 0
```

---

## Common Use Cases

### 1. Build Prefix Array
```python
for i in range(1, n):
    prefix[i] = prefix[i-1] + arr[i-1]
```

### 2. Build Suffix Array
```python
for i in range(n-2, -1, -1):
    suffix[i] = suffix[i+1] + arr[i+1]
```

### 3. Compare Adjacent
```python
for i in range(len(arr) - 1):
    if arr[i] == arr[i+1]:
        # Found duplicate
```

### 4. Two Pointers
```python
left, right = 0, len(arr) - 1
while left < right:
    # Process
    left += 1
    right -= 1
```

### 5. Sliding Window
```python
for i in range(k, len(arr)):
    window_sum += arr[i] - arr[i-k]
```

---

## Summary

### Forward Iteration
```python
for i in range(n):              # 0 to n-1
for i in range(1, n):           # 1 to n-1 (skip first)
for i in range(n-1):            # 0 to n-2 (skip last)
```

### Backward Iteration
```python
for i in range(n-1, -1, -1):    # n-1 to 0
for i in range(n-2, -1, -1):    # n-2 to 0 (skip last)
for i in range(n-1, 0, -1):     # n-1 to 1 (skip first)
```

### Key Points
- `range(start, stop, step)` - stop is **exclusive**
- Backward: use negative step `-1`
- `range(n-2, -1, -1)` - common for suffix calculations
- `enumerate()` - get index and value together
- `zip()` - iterate multiple arrays together
- `reversed()` - iterate in reverse order

**Golden Rule:** Understand `range(start, stop, step)` and you can iterate any way you want!
