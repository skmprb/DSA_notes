# Python Data Structures - Complete Guide

## Overview Comparison

| Feature | List | Tuple | Set | Dict | Hash |
|---------|------|-------|-----|------|------|
| **Mutable** | ✅ | ❌ | ✅ | ✅ | Concept |
| **Ordered** | ✅ | ✅ | ❌ | ✅ (3.7+) | N/A |
| **Indexed** | ✅ | ✅ | ❌ | By key | N/A |
| **Duplicates** | ✅ | ✅ | ❌ | Keys: ❌, Values: ✅ | N/A |
| **Syntax** | `[]` | `()` | `{}` | `{k:v}` | Function |
| **Use Case** | General collection | Immutable data | Unique items | Key-value pairs | Fast lookup |

---

## 1. List (Array)

### Definition
Ordered, mutable collection that allows duplicates.

### Creation
```python
# Empty list
lst = []
lst = list()

# With values
lst = [1, 2, 3, 4, 5]
lst = list(range(5))          # [0, 1, 2, 3, 4]

# Repeated values
lst = [0] * 5                 # [0, 0, 0, 0, 0]

# List comprehension
lst = [x**2 for x in range(5)]  # [0, 1, 4, 9, 16]

# 2D list
matrix = [[0] * 3 for _ in range(3)]  # 3x3 matrix
```

### Methods

#### Adding Elements
```python
lst = [1, 2, 3]

lst.append(4)                 # [1, 2, 3, 4] - O(1)
lst.extend([5, 6])            # [1, 2, 3, 4, 5, 6] - O(k)
lst.insert(0, 0)              # [0, 1, 2, 3, 4, 5, 6] - O(n)
lst += [7, 8]                 # Same as extend
```

#### Removing Elements
```python
lst.remove(2)                 # Remove first occurrence - O(n)
value = lst.pop()             # Remove & return last - O(1)
value = lst.pop(0)            # Remove & return at index - O(n)
del lst[0]                    # Delete by index - O(n)
del lst[1:3]                  # Delete slice - O(n)
lst.clear()                   # Remove all - O(n)
```

#### Searching & Accessing
```python
value = lst[0]                # Access by index - O(1)
index = lst.index(5)          # Find index - O(n)
count = lst.count(3)          # Count occurrences - O(n)
exists = 5 in lst             # Check existence - O(n)
```

#### Sorting & Reversing
```python
lst.sort()                    # Sort in-place - O(n log n)
lst.sort(reverse=True)        # Descending
lst.sort(key=lambda x: -x)    # Custom sort
lst.reverse()                 # Reverse in-place - O(n)
new_lst = sorted(lst)         # Return new sorted list
new_lst = lst[::-1]           # Return new reversed list
```

#### Other Operations
```python
length = len(lst)             # Length - O(1)
lst.copy()                    # Shallow copy - O(n)
lst[:]                        # Slice copy - O(n)
```

### Time Complexity
| Operation | Average | Worst |
|-----------|---------|-------|
| Access | O(1) | O(1) |
| Search | O(n) | O(n) |
| Append | O(1) | O(1) |
| Insert | O(n) | O(n) |
| Delete | O(n) | O(n) |
| Pop last | O(1) | O(1) |

### When to Use
- ✅ Need ordered collection
- ✅ Need to modify elements
- ✅ Allow duplicates
- ✅ Need indexing
- ❌ Need fast lookup (use dict/set)
- ❌ Need immutability (use tuple)

---

## 2. Tuple

### Definition
Ordered, **immutable** collection that allows duplicates.

### Creation
```python
# Empty tuple
tup = ()
tup = tuple()

# With values
tup = (1, 2, 3, 4, 5)
tup = 1, 2, 3              # Parentheses optional
tup = (1,)                 # Single element (comma required!)

# From list
tup = tuple([1, 2, 3])

# Tuple unpacking
a, b, c = (1, 2, 3)
```

### Methods (Limited - Immutable!)
```python
tup = (1, 2, 3, 2, 4)

# Only 2 methods!
count = tup.count(2)       # Count occurrences - O(n)
index = tup.index(3)       # Find index - O(n)

# Access
value = tup[0]             # Access by index - O(1)
exists = 2 in tup          # Check existence - O(n)
length = len(tup)          # Length - O(1)

# Slicing (returns new tuple)
sub = tup[1:3]             # (2, 3)
```

### Operations
```python
# Concatenation (creates new tuple)
tup1 = (1, 2)
tup2 = (3, 4)
tup3 = tup1 + tup2         # (1, 2, 3, 4)

# Repetition
tup = (1, 2) * 3           # (1, 2, 1, 2, 1, 2)

# Cannot modify!
# tup[0] = 5               # TypeError!
# tup.append(6)            # AttributeError!
```

### Time Complexity
| Operation | Average |
|-----------|---------|
| Access | O(1) |
| Search | O(n) |
| Iteration | O(n) |

### When to Use
- ✅ Data should not change (immutable)
- ✅ Use as dictionary keys (hashable)
- ✅ Return multiple values from function
- ✅ Slightly faster than lists
- ✅ Less memory than lists
- ❌ Need to modify data (use list)

### List vs Tuple
```python
# List - mutable
lst = [1, 2, 3]
lst[0] = 10                # ✅ Works
lst.append(4)              # ✅ Works

# Tuple - immutable
tup = (1, 2, 3)
# tup[0] = 10              # ❌ TypeError
# tup.append(4)            # ❌ AttributeError

# Tuple as dict key
d = {(1, 2): "value"}      # ✅ Works
# d = {[1, 2]: "value"}    # ❌ TypeError (list not hashable)
```

---

## 3. Set

### Definition
**Unordered** collection of **unique** elements. Mutable but elements must be immutable.

### Creation
```python
# Empty set
s = set()                  # Must use set(), not {}
# s = {}                   # This creates empty dict!

# With values
s = {1, 2, 3, 4, 5}
s = set([1, 2, 2, 3])      # {1, 2, 3} - duplicates removed

# From string
s = set("hello")           # {'h', 'e', 'l', 'o'}

# Set comprehension
s = {x**2 for x in range(5)}  # {0, 1, 4, 9, 16}
```

### Methods

#### Adding Elements
```python
s = {1, 2, 3}

s.add(4)                   # {1, 2, 3, 4} - O(1)
s.update([5, 6])           # {1, 2, 3, 4, 5, 6} - O(k)
s.update({7, 8}, [9])      # Can add multiple iterables
```

#### Removing Elements
```python
s.remove(2)                # Remove element, raises KeyError if not found - O(1)
s.discard(2)               # Remove element, no error if not found - O(1)
value = s.pop()            # Remove & return arbitrary element - O(1)
s.clear()                  # Remove all elements - O(n)
```

#### Set Operations
```python
s1 = {1, 2, 3, 4}
s2 = {3, 4, 5, 6}

# Union (all elements from both)
s1 | s2                    # {1, 2, 3, 4, 5, 6}
s1.union(s2)

# Intersection (common elements)
s1 & s2                    # {3, 4}
s1.intersection(s2)

# Difference (in s1 but not s2)
s1 - s2                    # {1, 2}
s1.difference(s2)

# Symmetric Difference (in either but not both)
s1 ^ s2                    # {1, 2, 5, 6}
s1.symmetric_difference(s2)

# Subset
{1, 2}.issubset({1, 2, 3})        # True
{1, 2} <= {1, 2, 3}               # True

# Superset
{1, 2, 3}.issuperset({1, 2})      # True
{1, 2, 3} >= {1, 2}               # True

# Disjoint (no common elements)
{1, 2}.isdisjoint({3, 4})         # True
```

#### Checking & Accessing
```python
exists = 3 in s            # Check membership - O(1) average
length = len(s)            # Length - O(1)

# Cannot access by index!
# s[0]                     # TypeError: 'set' object is not subscriptable
```

### Frozen Set (Immutable Set)
```python
fs = frozenset([1, 2, 3])
# fs.add(4)                # AttributeError - immutable!

# Can be used as dict key
d = {frozenset([1, 2]): "value"}  # ✅ Works
```

### Time Complexity
| Operation | Average | Worst |
|-----------|---------|-------|
| Add | O(1) | O(n) |
| Remove | O(1) | O(n) |
| Search | O(1) | O(n) |
| Union | O(len(s1) + len(s2)) | |
| Intersection | O(min(len(s1), len(s2))) | |

### When to Use
- ✅ Need unique elements only
- ✅ Need fast membership testing O(1)
- ✅ Need set operations (union, intersection)
- ✅ Remove duplicates from list
- ❌ Need ordered collection (use list)
- ❌ Need indexing (use list)
- ❌ Need to store mutable objects (use list)

---

## 4. Dictionary (Dict)

### Definition
Unordered (ordered in Python 3.7+) collection of **key-value pairs**. Keys must be unique and immutable.

### Creation
```python
# Empty dict
d = {}
d = dict()

# With values
d = {'a': 1, 'b': 2, 'c': 3}
d = dict(a=1, b=2, c=3)

# From lists
keys = ['a', 'b', 'c']
values = [1, 2, 3]
d = dict(zip(keys, values))

# Dict comprehension
d = {x: x**2 for x in range(5)}  # {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# Default values
from collections import defaultdict
d = defaultdict(int)       # Default 0
d = defaultdict(list)      # Default []
d = defaultdict(set)       # Default set()
```

### Methods

#### Adding/Updating
```python
d = {'a': 1, 'b': 2}

d['c'] = 3                 # Add new key - O(1)
d['a'] = 10                # Update existing - O(1)
d.update({'d': 4, 'e': 5}) # Update multiple - O(k)
d.setdefault('f', 6)       # Set if key doesn't exist - O(1)
```

#### Accessing
```python
value = d['a']             # Access by key, raises KeyError if not found - O(1)
value = d.get('a')         # Returns None if not found - O(1)
value = d.get('z', 0)      # Returns default if not found - O(1)
```

#### Removing
```python
del d['a']                 # Delete key, raises KeyError if not found - O(1)
value = d.pop('b')         # Remove & return value - O(1)
value = d.pop('z', None)   # With default if not found
key, value = d.popitem()   # Remove & return arbitrary pair - O(1)
d.clear()                  # Remove all - O(n)
```

#### Checking
```python
exists = 'a' in d          # Check if key exists - O(1)
exists = 'a' in d.keys()   # Same as above
exists = 1 in d.values()   # Check if value exists - O(n)
```

#### Iteration
```python
d = {'a': 1, 'b': 2, 'c': 3}

# Iterate keys
for key in d:
    print(key)

for key in d.keys():
    print(key)

# Iterate values
for value in d.values():
    print(value)

# Iterate key-value pairs
for key, value in d.items():
    print(f"{key}: {value}")
```

#### Other Methods
```python
keys = d.keys()            # View of keys
values = d.values()        # View of values
items = d.items()          # View of (key, value) pairs
length = len(d)            # Number of key-value pairs - O(1)
d.copy()                   # Shallow copy - O(n)
```

### Advanced: Counter
```python
from collections import Counter

# Count frequencies
freq = Counter([1, 2, 2, 3, 3, 3])  # Counter({3: 3, 2: 2, 1: 1})
freq = Counter("hello")              # Counter({'l': 2, 'h': 1, 'e': 1, 'o': 1})

# Most common
freq.most_common(2)        # [(3, 3), (2, 2)]

# Operations
c1 = Counter(['a', 'b', 'c'])
c2 = Counter(['b', 'c', 'd'])
c1 + c2                    # Add counts
c1 - c2                    # Subtract counts
c1 & c2                    # Intersection (min)
c1 | c2                    # Union (max)
```

### Time Complexity
| Operation | Average | Worst |
|-----------|---------|-------|
| Access | O(1) | O(n) |
| Insert | O(1) | O(n) |
| Delete | O(1) | O(n) |
| Search key | O(1) | O(n) |
| Search value | O(n) | O(n) |

### When to Use
- ✅ Need key-value mapping
- ✅ Need fast lookup by key O(1)
- ✅ Count frequencies
- ✅ Cache/memoization
- ✅ Group data by category
- ❌ Need ordered by value (use sorted)
- ❌ Keys need to be mutable (use list of tuples)

---

## 5. Hash / Hashing

### Definition
**Hash** is not a data structure but a **concept/technique** used by sets and dicts for fast O(1) lookup.

### What is Hashing?

**Hash Function:** Converts a key into an integer (hash code) that determines where to store the value.

```python
# Python's built-in hash function
hash(5)                    # 5
hash("hello")              # Some integer
hash((1, 2, 3))            # Some integer

# Mutable objects are not hashable
# hash([1, 2, 3])          # TypeError: unhashable type: 'list'
# hash({1, 2, 3})          # TypeError: unhashable type: 'set'
```

### Hashable vs Unhashable

**Hashable (can be dict keys or set elements):**
- ✅ Immutable types: int, float, str, tuple, frozenset
- ✅ Custom objects (by default)

**Unhashable (cannot be dict keys or set elements):**
- ❌ Mutable types: list, dict, set

```python
# Valid
d = {5: "int"}             # ✅
d = {"key": "str"}         # ✅
d = {(1, 2): "tuple"}      # ✅
s = {1, 2, 3}              # ✅

# Invalid
# d = {[1, 2]: "list"}     # ❌ TypeError
# d = {{1, 2}: "set"}      # ❌ TypeError
# s = {[1, 2], [3, 4]}     # ❌ TypeError
```

### How Hash Tables Work

```
Key → Hash Function → Hash Code → Index in Array → Value

Example:
"apple" → hash("apple") → 12345 → 12345 % 10 = 5 → array[5] = "red"
```

**Collision Handling:**
When two keys hash to same index:
1. **Chaining:** Store multiple items at same index (linked list)
2. **Open Addressing:** Find next available slot

### Hash in Python

**Dict and Set use hash tables internally:**
```python
# Dict: key → hash(key) → value
d = {"apple": "red"}
# Internally: hash("apple") → index → "red"

# Set: element → hash(element) → exists
s = {1, 2, 3}
# Internally: hash(1) → index → True
```

**Why O(1) lookup?**
- Hash function computes index directly
- No need to search through all elements
- Average case: O(1), Worst case: O(n) with many collisions

### Custom Hash Function
```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __hash__(self):
        return hash((self.x, self.y))
    
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

# Now can use as dict key or in set
p1 = Point(1, 2)
p2 = Point(1, 2)
d = {p1: "point"}
print(p1 in d)             # True
print(p2 in d)             # True (same hash and equal)
```

### When Hashing is Used
- ✅ Dictionary key lookup
- ✅ Set membership testing
- ✅ Finding duplicates
- ✅ Caching (memoization)
- ✅ Hash tables, hash maps

---

## Quick Comparison

### Mutability
```python
# Mutable (can change)
lst = [1, 2, 3]
lst[0] = 10                # ✅

s = {1, 2, 3}
s.add(4)                   # ✅

d = {'a': 1}
d['a'] = 2                 # ✅

# Immutable (cannot change)
tup = (1, 2, 3)
# tup[0] = 10              # ❌ TypeError
```

### Ordering
```python
# Ordered (maintains insertion order)
lst = [3, 1, 2]            # [3, 1, 2]
tup = (3, 1, 2)            # (3, 1, 2)
d = {'c': 3, 'a': 1}       # {'c': 3, 'a': 1} (Python 3.7+)

# Unordered (no guaranteed order)
s = {3, 1, 2}              # Could be {1, 2, 3} or any order
```

### Duplicates
```python
# Allow duplicates
lst = [1, 1, 2, 2]         # [1, 1, 2, 2]
tup = (1, 1, 2, 2)         # (1, 1, 2, 2)

# No duplicates
s = {1, 1, 2, 2}           # {1, 2}
d = {'a': 1, 'a': 2}       # {'a': 2} (last value wins)
```

### Indexing
```python
# Indexed (access by position)
lst = [10, 20, 30]
lst[0]                     # 10

tup = (10, 20, 30)
tup[1]                     # 20

# Not indexed (access by key or no access)
s = {10, 20, 30}
# s[0]                     # ❌ TypeError

d = {'a': 10, 'b': 20}
d['a']                     # 10 (by key, not position)
```

---

## Performance Comparison

| Operation | List | Tuple | Set | Dict |
|-----------|------|-------|-----|------|
| Access by index | O(1) | O(1) | N/A | N/A |
| Access by key | N/A | N/A | N/A | O(1) |
| Search | O(n) | O(n) | O(1) | O(1) |
| Insert | O(n) | N/A | O(1) | O(1) |
| Delete | O(n) | N/A | O(1) | O(1) |
| Append | O(1) | N/A | O(1) | O(1) |
| Memory | Medium | Low | High | High |

---

## Use Case Decision Tree

```
Need key-value pairs?
├─ Yes → Dict
└─ No
   ├─ Need unique elements only?
   │  ├─ Yes → Set
   │  └─ No
   │     ├─ Need to modify?
   │     │  ├─ Yes → List
   │     │  └─ No → Tuple
   │     └─ Need fast lookup?
   │        ├─ Yes → Set/Dict
   │        └─ No → List/Tuple
```

---

## Common Patterns

### Remove Duplicates
```python
# Using set
lst = [1, 2, 2, 3, 3, 3]
unique = list(set(lst))    # [1, 2, 3] (order not preserved)

# Preserve order
seen = set()
unique = []
for x in lst:
    if x not in seen:
        unique.append(x)
        seen.add(x)
```

### Count Frequencies
```python
# Using dict
lst = [1, 2, 2, 3, 3, 3]
freq = {}
for num in lst:
    freq[num] = freq.get(num, 0) + 1

# Using Counter
from collections import Counter
freq = Counter(lst)        # Counter({3: 3, 2: 2, 1: 1})
```

### Group By Key
```python
# Using defaultdict
from collections import defaultdict
words = ["apple", "banana", "apricot", "blueberry"]
groups = defaultdict(list)
for word in words:
    groups[word[0]].append(word)
# {'a': ['apple', 'apricot'], 'b': ['banana', 'blueberry']}
```

### Find Intersection
```python
# Using set
list1 = [1, 2, 3, 4]
list2 = [3, 4, 5, 6]
common = list(set(list1) & set(list2))  # [3, 4]
```

---

## Summary

### List
- **Use for:** General-purpose ordered collection
- **Key feature:** Mutable, indexed, allows duplicates
- **Time:** O(1) access, O(n) search

### Tuple
- **Use for:** Immutable data, dict keys, function returns
- **Key feature:** Immutable, indexed, allows duplicates
- **Time:** O(1) access, O(n) search

### Set
- **Use for:** Unique elements, fast membership testing
- **Key feature:** Unique, unordered, O(1) lookup
- **Time:** O(1) add/remove/search

### Dict
- **Use for:** Key-value mapping, fast lookup by key
- **Key feature:** Key-value pairs, O(1) lookup
- **Time:** O(1) access/insert/delete by key

### Hash
- **Concept:** Technique for O(1) lookup
- **Used by:** Dict and Set internally
- **Requirement:** Keys/elements must be hashable (immutable)

**Golden Rule:** Choose based on your needs - ordering, uniqueness, mutability, and lookup speed!
