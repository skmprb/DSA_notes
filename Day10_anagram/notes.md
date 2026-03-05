# Day 10: Anagrams & Parentheses - Complete Beginner's Guide

## 🎯 What You'll Learn
- Understanding **anagrams** (what they are and how to detect them)
- Using **Counter**, **dict**, **set**, **defaultdict**
- Understanding **Stack** data structure
- Pattern recognition for similar problems

---

# PART 1: UNDERSTANDING DATA STRUCTURES

## 1.1 Dictionary (dict) - The Foundation

### What is a Dictionary?
A **key-value** storage where you can quickly look up values using keys.

**Real-World Analogy**: Like a phone book
- **Key**: Person's name
- **Value**: Phone number
- **Lookup**: Given name, find phone number instantly

### Basic Operations
```python
# Create dictionary
phone_book = {}

# Add entries
phone_book["Alice"] = "123-4567"
phone_book["Bob"] = "987-6543"

# Look up
print(phone_book["Alice"])  # "123-4567"

# Check if key exists
if "Alice" in phone_book:
    print("Found!")

# Get with default
number = phone_book.get("Charlie", "Not found")
```

### Why Use Dictionary for Anagrams?
```python
# Count characters in a word
word = "hello"
count = {}

for char in word:
    count[char] = count.get(char, 0) + 1

# Result: {'h': 1, 'e': 1, 'l': 2, 'o': 1}
```

---

## 1.2 Counter - Dictionary on Steroids

### What is Counter?
A **specialized dictionary** that automatically counts things.

```python
from collections import Counter

# Manual way (using dict)
word = "hello"
count = {}
for char in word:
    count[char] = count.get(char, 0) + 1
# Result: {'h': 1, 'e': 1, 'l': 2, 'o': 1}

# Counter way (automatic!)
count = Counter(word)
# Result: Counter({'l': 2, 'h': 1, 'e': 1, 'o': 1})
```

### Why Counter is Better
```python
# Comparing two words
word1 = "listen"
word2 = "silent"

# Manual way (lots of code)
count1 = {}
for char in word1:
    count1[char] = count1.get(char, 0) + 1
count2 = {}
for char in word2:
    count2[char] = count2.get(char, 0) + 1
are_anagrams = (count1 == count2)

# Counter way (one line!)
are_anagrams = Counter(word1) == Counter(word2)
```

### Counter Operations
```python
from collections import Counter

count = Counter("hello")

# Get count of specific character
print(count['l'])  # 2
print(count['x'])  # 0 (doesn't error!)

# Most common
print(count.most_common(2))  # [('l', 2), ('h', 1)]

# Add counters
count1 = Counter("hello")
count2 = Counter("world")
combined = count1 + count2
# Counter({'l': 3, 'o': 2, 'h': 1, 'e': 1, 'w': 1, 'r': 1, 'd': 1})
```

---

## 1.3 Set - For Uniqueness

### What is a Set?
A collection of **unique** items (no duplicates).

**Real-World Analogy**: A bag of unique marbles
- Can't have two identical marbles
- Can quickly check if a marble is in the bag
- Don't care about order

### Basic Operations
```python
# Create set
unique_chars = set()

# Add items
unique_chars.add('a')
unique_chars.add('b')
unique_chars.add('a')  # Duplicate ignored!

print(unique_chars)  # {'a', 'b'}

# Check membership (very fast!)
if 'a' in unique_chars:
    print("Found!")

# Convert string to set (removes duplicates)
word = "hello"
unique = set(word)  # {'h', 'e', 'l', 'o'}
```

### Why Use Set?
```python
# Track which words we've already processed
processed = set()

words = ["eat", "tea", "eat", "tan"]
for word in words:
    if word in processed:
        print(f"Already saw {word}")
        continue
    processed.add(word)
    # Process word...
```

---

## 1.4 defaultdict - Dictionary with Default Values

### What is defaultdict?
A dictionary that **automatically creates** entries with default values.

```python
from collections import defaultdict

# Regular dict (causes KeyError)
count = {}
count['a'] += 1  # KeyError: 'a'

# defaultdict (works!)
count = defaultdict(int)  # int() returns 0
count['a'] += 1  # Automatically creates count['a'] = 0, then adds 1
print(count['a'])  # 1
```

### Common Default Types
```python
from collections import defaultdict

# Default to 0 (for counting)
count = defaultdict(int)
count['a'] += 1

# Default to empty list (for grouping)
groups = defaultdict(list)
groups['vowels'].append('a')
groups['vowels'].append('e')
# {'vowels': ['a', 'e']}

# Default to empty set
unique = defaultdict(set)
unique['letters'].add('a')
unique['letters'].add('a')  # Duplicate ignored
# {'letters': {'a'}}
```

### Why Use defaultdict for Grouping?
```python
# Group anagrams

# Without defaultdict (verbose)
groups = {}
for word in words:
    key = ''.join(sorted(word))
    if key not in groups:
        groups[key] = []  # Must create list first!
    groups[key].append(word)

# With defaultdict (clean!)
groups = defaultdict(list)
for word in words:
    key = ''.join(sorted(word))
    groups[key].append(word)  # Automatically creates list!
```

---

## 1.5 Stack - Last In, First Out (LIFO)

### What is a Stack?
A collection where you can only add/remove from the **top**.

**Real-World Analogy**: Stack of plates
- Add plate on top: **push**
- Remove plate from top: **pop**
- Look at top plate: **peek**
- Can't remove from middle or bottom!

### Stack in Python (Using List)
```python
stack = []

# Push (add to top)
stack.append('A')
stack.append('B')
stack.append('C')
# Stack: ['A', 'B', 'C']
#                    ↑ top

# Peek (look at top)
top = stack[-1]  # 'C'

# Pop (remove from top)
removed = stack.pop()  # 'C'
# Stack: ['A', 'B']
#              ↑ top

# Check if empty
if not stack:
    print("Stack is empty")
```

### Why Use Stack for Parentheses?
```python
# Matching parentheses is like matching pairs

s = "({[]})"

# When we see opening bracket: push to stack
# When we see closing bracket: pop and check if it matches

# Step by step:
# See '(' → push '(' → stack: ['(']
# See '{' → push '{' → stack: ['(', '{']
# See '[' → push '[' → stack: ['(', '{', '[']
# See ']' → pop '[' → matches! → stack: ['(', '{']
# See '}' → pop '{' → matches! → stack: ['(']
# See ')' → pop '(' → matches! → stack: []
# Stack empty → Valid!
```

---

# PART 2: PROBLEM 1 - VALID ANAGRAM

## 2.1 What is an Anagram?

**Definition**: Two words are anagrams if they use the **same characters** with the **same frequencies**.

### Examples
```
✅ Anagrams:
"listen" and "silent"
- Both have: l(1), i(1), s(1), t(1), e(1), n(1)

"anagram" and "nagaram"
- Both have: a(3), n(1), g(1), r(1), m(1)

❌ NOT Anagrams:
"rat" and "car"
- "rat": r(1), a(1), t(1)
- "car": c(1), a(1), r(1)
- Different characters!

"hello" and "helo"
- "hello": h(1), e(1), l(2), o(1)
- "helo": h(1), e(1), l(1), o(1)
- Different frequencies!
```

## 2.2 The Core Idea

**Strategy**: Count characters in both strings and compare.

```
s = "anagram"
t = "nagaram"

Count s: {'a': 3, 'n': 1, 'g': 1, 'r': 1, 'm': 1}
Count t: {'n': 1, 'a': 3, 'g': 1, 'r': 1, 'm': 1}

Are they equal? YES → Anagrams!
```

## 2.3 Multiple Solutions

### Solution 1: Using Counter (Easiest!)
```python
from collections import Counter

def isAnagram(s, t):
    return Counter(s) == Counter(t)
```

**Why it works**:
- Counter automatically counts all characters
- Comparing two Counters checks if counts match
- One line!

### Solution 2: Using Dictionary (Manual)
```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    
    # Count characters in s
    count_s = {}
    for char in s:
        count_s[char] = count_s.get(char, 0) + 1
    
    # Count characters in t
    count_t = {}
    for char in t:
        count_t[char] = count_t.get(char, 0) + 1
    
    # Compare
    return count_s == count_t
```

**Why it works**:
- Manually count each character
- Compare the two dictionaries
- More code but same logic as Counter

### Solution 3: Using Sorting
```python
def isAnagram(s, t):
    return sorted(s) == sorted(t)
```

**Why it works**:
```
s = "listen"
sorted(s) = ['e', 'i', 'l', 'n', 's', 't']

t = "silent"
sorted(t) = ['e', 'i', 'l', 'n', 's', 't']

Same sorted order → Anagrams!
```

### Solution 4: Using Set (Optimized)
```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    
    # Get unique characters
    chars = set(s)
    
    # Check count of each unique character
    for char in chars:
        if s.count(char) != t.count(char):
            return False
    
    return True
```

**Why it works**:
- Only check unique characters (not all positions)
- Compare counts for each character
- Efficient for strings with many duplicates

## 2.4 Complexity Comparison

| Solution | Time | Space | Notes |
|----------|------|-------|-------|
| Counter | O(n) | O(n) | Easiest, most Pythonic |
| Dictionary | O(n) | O(n) | Manual but clear |
| Sorting | O(n log n) | O(1) | Slower but simple |
| Set | O(n²) | O(n) | Good for many duplicates |

---

# PART 3: PROBLEM 2 - GROUP ANAGRAMS

## 3.1 Understanding the Problem

**Goal**: Group words that are anagrams of each other.

```
Input: ["eat", "tea", "tan", "ate", "nat", "bat"]

Output: [
    ["eat", "tea", "ate"],  # All anagrams of each other
    ["tan", "nat"],         # All anagrams of each other
    ["bat"]                 # No anagrams
]
```

## 3.2 The Key Insight

**Observation**: Anagrams have the **same sorted characters**!

```
"eat" → sorted → "aet"
"tea" → sorted → "aet"  ← Same!
"ate" → sorted → "aet"  ← Same!

"tan" → sorted → "ant"
"nat" → sorted → "ant"  ← Same!

"bat" → sorted → "abt"  ← Different!
```

**Strategy**: Use sorted string as a **key** to group anagrams.

## 3.3 Visual Walkthrough

```
words = ["eat", "tea", "tan", "ate", "nat", "bat"]

Step 1: Process "eat"
sorted("eat") = "aet"
groups = {"aet": ["eat"]}

Step 2: Process "tea"
sorted("tea") = "aet"  ← Same key!
groups = {"aet": ["eat", "tea"]}

Step 3: Process "tan"
sorted("tan") = "ant"  ← New key!
groups = {"aet": ["eat", "tea"], "ant": ["tan"]}

Step 4: Process "ate"
sorted("ate") = "aet"  ← Existing key!
groups = {"aet": ["eat", "tea", "ate"], "ant": ["tan"]}

Step 5: Process "nat"
sorted("nat") = "ant"  ← Existing key!
groups = {"aet": ["eat", "tea", "ate"], "ant": ["tan", "nat"]}

Step 6: Process "bat"
sorted("bat") = "abt"  ← New key!
groups = {
    "aet": ["eat", "tea", "ate"],
    "ant": ["tan", "nat"],
    "abt": ["bat"]
}

Result: [["eat", "tea", "ate"], ["tan", "nat"], ["bat"]]
```

## 3.4 Multiple Solutions

### Solution 1: Using defaultdict (Best!)
```python
from collections import defaultdict

def groupAnagrams(strs):
    groups = defaultdict(list)
    
    for word in strs:
        # Sort word to get key
        key = ''.join(sorted(word))
        # Add word to group
        groups[key].append(word)
    
    return list(groups.values())
```

**Why it's best**:
- `defaultdict(list)` automatically creates empty list
- No need to check if key exists
- Clean and concise

### Solution 2: Using Regular Dictionary
```python
def groupAnagrams(strs):
    groups = {}
    
    for word in strs:
        key = ''.join(sorted(word))
        
        if key in groups:
            groups[key].append(word)
        else:
            groups[key] = [word]  # Must create list first
    
    return list(groups.values())
```

**Why it works**:
- Same logic as defaultdict
- More verbose (must check if key exists)
- Good for understanding the logic

### Solution 3: Using Character Count as Key
```python
def groupAnagrams(strs):
    groups = {}
    
    for word in strs:
        # Count characters
        count = [0] * 26
        for char in word:
            count[ord(char) - ord('a')] += 1
        
        # Use tuple of counts as key
        key = tuple(count)
        
        if key in groups:
            groups[key].append(word)
        else:
            groups[key] = [word]
    
    return list(groups.values())
```

**Why it's faster**:
- Sorting is O(k log k) where k = word length
- Counting is O(k)
- Faster for long words!

## 3.5 Understanding tuple() as Key

**Question**: Why use `tuple(count)` instead of `list(count)`?

**Answer**: Dictionary keys must be **immutable** (unchangeable).

```python
# Lists are mutable (can change)
count = [1, 2, 3]
count[0] = 99  # Can change!
# Can't use as dictionary key!

# Tuples are immutable (can't change)
count = (1, 2, 3)
count[0] = 99  # Error! Can't change!
# Can use as dictionary key!

# Example
groups = {}
key = tuple([1, 2, 3])  # Convert list to tuple
groups[key] = ["word"]  # Works!
```

---

# PART 4: PROBLEM 3 - VALID PARENTHESES

## 4.1 Understanding the Problem

**Goal**: Check if brackets are properly matched and nested.

```
✅ Valid:
"()" → Each opening has matching closing
"()[]{}" → Multiple types, all matched
"([{}])" → Properly nested

❌ Invalid:
"(]" → Wrong type of closing bracket
"([)]" → Wrong nesting order
"(((" → Missing closing brackets
```

## 4.2 Why Use a Stack?

**Key Observation**: Last opened bracket must be first closed (LIFO).

```
Example: "([{}])"

Read '(' → Open bracket → Push to stack
Stack: ['(']

Read '[' → Open bracket → Push to stack
Stack: ['(', '[']

Read '{' → Open bracket → Push to stack
Stack: ['(', '[', '{']

Read '}' → Close bracket → Must match top of stack
Top of stack: '{' → Matches! → Pop
Stack: ['(', '[']

Read ']' → Close bracket → Must match top of stack
Top of stack: '[' → Matches! → Pop
Stack: ['(']

Read ')' → Close bracket → Must match top of stack
Top of stack: '(' → Matches! → Pop
Stack: []

Stack empty → Valid!
```

## 4.3 The Algorithm

```
For each character:
    If opening bracket:
        Push to stack
    
    If closing bracket:
        If stack is empty:
            return False (no matching opening)
        
        Pop from stack
        If popped bracket doesn't match:
            return False
    
At end:
    If stack is empty:
        return True (all matched)
    Else:
        return False (unmatched openings)
```

## 4.4 Complete Solution

```python
def isValid(s):
    stack = []
    
    # Mapping of closing to opening brackets
    mapping = {
        ')': '(',
        ']': '[',
        '}': '{'
    }
    
    for char in s:
        # If closing bracket
        if char in mapping:
            # Check if stack is empty
            if not stack:
                return False
            
            # Pop and check if it matches
            if stack.pop() != mapping[char]:
                return False
        
        # If opening bracket
        else:
            stack.append(char)
    
    # Check if all brackets were matched
    return not stack  # True if empty, False if not
```

## 4.5 Step-by-Step Trace

Example: `s = "([])"`

```
Step 1: char = '('
- Not in mapping → Opening bracket
- Push to stack
- stack = ['(']

Step 2: char = '['
- Not in mapping → Opening bracket
- Push to stack
- stack = ['(', '[']

Step 3: char = ']'
- In mapping → Closing bracket
- mapping[']'] = '['
- stack not empty ✓
- Pop from stack → got '['
- Does '[' == '['? YES ✓
- stack = ['(']

Step 4: char = ')'
- In mapping → Closing bracket
- mapping[')'] = '('
- stack not empty ✓
- Pop from stack → got '('
- Does '(' == '('? YES ✓
- stack = []

End: stack is empty → return True ✓
```

## 4.6 Common Edge Cases

```python
# Case 1: Empty string
s = ""
# Stack stays empty → Valid!

# Case 2: Only opening brackets
s = "((("
# Stack: ['(', '(', '(']
# Not empty at end → Invalid!

# Case 3: Only closing brackets
s = ")))"
# First ')': stack is empty → Invalid!

# Case 4: Wrong order
s = "([)]"
# Stack: ['(', '[']
# See ')': pop '[', but need '(' → Invalid!

# Case 5: Odd length
s = "(()"
# Stack: ['(']
# Not empty at end → Invalid!
```

---

# PART 5: DATA STRUCTURE CHEAT SHEET

## When to Use What?

### Use **dict** when:
- Need key-value mapping
- Need to count things manually
- Want full control over logic

### Use **Counter** when:
- Need to count things automatically
- Comparing frequencies
- Want concise code

### Use **set** when:
- Need unique items only
- Need fast membership testing
- Don't care about order or counts

### Use **defaultdict** when:
- Building dictionary with default values
- Grouping items
- Want to avoid "if key exists" checks

### Use **Stack (list)** when:
- Need LIFO (Last In, First Out)
- Matching pairs (parentheses, tags)
- Undo/redo functionality
- Backtracking problems

## Quick Reference

```python
# Dictionary
d = {}
d['key'] = 'value'
value = d.get('key', 'default')

# Counter
from collections import Counter
count = Counter("hello")
print(count['l'])  # 2

# Set
s = set()
s.add('item')
if 'item' in s:  # Fast!
    print("Found")

# defaultdict
from collections import defaultdict
d = defaultdict(list)
d['key'].append('value')  # No KeyError!

# Stack
stack = []
stack.append('item')  # Push
top = stack[-1]       # Peek
item = stack.pop()    # Pop
```

---

# PART 6: PATTERN RECOGNITION

## Pattern 1: Character Frequency
**When**: Need to count characters
**Use**: Counter or dict
**Problems**: Valid Anagram, Group Anagrams

```python
# Template
from collections import Counter
count = Counter(string)
```

## Pattern 2: Grouping by Key
**When**: Group items with same property
**Use**: defaultdict(list)
**Problems**: Group Anagrams

```python
# Template
from collections import defaultdict
groups = defaultdict(list)
for item in items:
    key = compute_key(item)
    groups[key].append(item)
```

## Pattern 3: Matching Pairs
**When**: Match opening/closing elements
**Use**: Stack
**Problems**: Valid Parentheses, HTML Tags

```python
# Template
stack = []
for char in string:
    if is_opening(char):
        stack.append(char)
    else:
        if not stack or not matches(stack.pop(), char):
            return False
return not stack
```

---

# PART 7: COMPLEXITY SUMMARY

## Valid Anagram
| Solution | Time | Space |
|----------|------|-------|
| Counter | O(n) | O(n) |
| Dictionary | O(n) | O(n) |
| Sorting | O(n log n) | O(1) |

## Group Anagrams
| Solution | Time | Space |
|----------|------|-------|
| Sort as key | O(n × k log k) | O(n × k) |
| Count as key | O(n × k) | O(n × k) |

*n = number of words, k = average word length*

## Valid Parentheses
| Solution | Time | Space |
|----------|------|-------|
| Stack | O(n) | O(n) |

---

# PART 8: PRACTICE CHECKLIST

## Before You Code

- [ ] Do I understand what anagrams are?
- [ ] Do I know when to use Counter vs dict?
- [ ] Do I understand how Stack works (LIFO)?
- [ ] Can I trace through an example manually?

## While Coding

### For Anagrams:
- [ ] Am I counting all characters correctly?
- [ ] Am I comparing the right things?
- [ ] Did I handle empty strings?

### For Grouping:
- [ ] Am I using the right key (sorted string)?
- [ ] Am I using defaultdict or checking if key exists?
- [ ] Am I returning list of values?

### For Parentheses:
- [ ] Am I pushing opening brackets?
- [ ] Am I checking if stack is empty before popping?
- [ ] Am I checking if brackets match?
- [ ] Am I checking if stack is empty at the end?

## After Coding

- [ ] Does it handle empty input?
- [ ] Does it handle single character?
- [ ] Does it handle all test cases?
- [ ] Can I explain the time/space complexity?

---

# SUMMARY

## Three Problems, Three Patterns

### 1. Valid Anagram
**Pattern**: Character Frequency Comparison
**Tool**: Counter or dict
**Key**: Count and compare

### 2. Group Anagrams
**Pattern**: Grouping by Property
**Tool**: defaultdict with sorted string as key
**Key**: Same sorted string = anagrams

### 3. Valid Parentheses
**Pattern**: Matching Pairs
**Tool**: Stack (LIFO)
**Key**: Last opened must be first closed

## Data Structures Learned

1. **dict**: Key-value mapping
2. **Counter**: Automatic counting
3. **set**: Unique items
4. **defaultdict**: Dict with defaults
5. **Stack**: LIFO using list

## Remember

- **Anagrams** = Same characters, same frequencies
- **Sorted string** = Good key for grouping anagrams
- **Stack** = Perfect for matching pairs
- **defaultdict** = Cleaner code for grouping
- **Counter** = Easiest way to count

**You're ready to solve these! 🚀**
