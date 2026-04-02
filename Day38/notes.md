# Day 38: Letter Combinations of a Phone Number

## Problem Statement
**LeetCode 17: Letter Combinations of a Phone Number**

Given a string containing digits from 2-9 inclusive, return all possible letter combinations that the number could represent. Return the answer in any order.

A mapping of digits to letters (just like on the telephone buttons):
```
2 → "abc"
3 → "def"
4 → "ghi"
5 → "jkl"
6 → "mno"
7 → "pqrs"
8 → "tuv"
9 → "wxyz"
```

**Examples:**
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]

Input: digits = "2"
Output: ["a","b","c"]

Input: digits = ""
Output: []
```

**Constraints:**
- 0 <= digits.length <= 4
- digits[i] is a digit in the range ['2', '9']

---

## Problem Logic & Reasoning

### Core Concept
This is a **Cartesian Product** problem disguised as a phone keypad problem. For each digit, we need to combine its letters with all combinations from the remaining digits.

**Key Insight:** For digits "23":
- Digit '2' has letters ['a', 'b', 'c']
- Digit '3' has letters ['d', 'e', 'f']
- Result = {'a', 'b', 'c'} × {'d', 'e', 'f'} = 3 × 3 = 9 combinations

### Why This Problem Needs Recursion or Iteration
1. **Variable depth**: Number of digits determines nesting depth
2. **Combinatorial explosion**: Each digit multiplies possibilities
3. **Building from smaller subproblems**: Combinations of "23" = combinations of "2" + combinations of "3"

---

## Approach 1: Recursive Backtracking ⭐

### Logic
Build combinations by recursively processing each digit:
1. Base case: When we've processed all digits, return [""] (empty string to concatenate with)
2. Recursive case: Get combinations from remaining digits, then prepend current digit's letters

### Visual Flow for digits = "23"

```
letterCombinations("23")
    ↓
combine(digits="23", index=0)
    ↓
    alpha = "abc" (for digit '2')
    next_combo = combine(digits="23", index=1)
        ↓
        alpha = "def" (for digit '3')
        next_combo = combine(digits="23", index=2)
            ↓
            index >= len(digits) → return [""]
        ↓
        Combine 'd' with [""] → ["d"]
        Combine 'e' with [""] → ["e"]
        Combine 'f' with [""] → ["f"]
        return ["d", "e", "f"]
    ↓
    Combine 'a' with ["d","e","f"] → ["ad","ae","af"]
    Combine 'b' with ["d","e","f"] → ["bd","be","bf"]
    Combine 'c' with ["d","e","f"] → ["cd","ce","cf"]
    return ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

### Recursion Tree for "23"
```
                    combine(0)
                   /    |    \
                 'a'   'b'   'c'
                  |     |     |
            combine(1) combine(1) combine(1)
            /  |  \    /  |  \    /  |  \
          'd' 'e' 'f' 'd' 'e' 'f' 'd' 'e' 'f'
           |   |   |   |   |   |   |   |   |
          ad  ae  af  bd  be  bf  cd  ce  cf
```

### Pseudocode
```
function letterCombinations(digits):
    if digits is empty:
        return []
    
    numMap = {digit → letters mapping}
    
    function combine(digits, index):
        if index >= len(digits):
            return [""]  // Base case: empty string
        
        next_combo = combine(digits, index + 1)  // Get combinations from rest
        alpha = numMap[digits[index]]            // Current digit's letters
        res = []
        
        for letter in alpha:
            for combo in next_combo:
                res.append(letter + combo)       // Cartesian product
        
        return res
    
    return combine(digits, 0)
```

### Complexity Analysis
- **Time:** O(4^n × n) where n = len(digits)
  - 4^n: Maximum combinations (digit '7' and '9' have 4 letters)
  - n: String concatenation for each combination
- **Space:** O(4^n × n) for storing all combinations + O(n) recursion stack

---

## Approach 2: Iterative Building

### Logic
Build combinations iteratively by processing one digit at a time:
1. Start with combinations from first digit
2. For each subsequent digit, expand existing combinations by appending new letters

### Visual Flow for digits = "23"

```
Initial: combination_list = None

Process digit '2' (letters: "abc"):
    combination_list = ["a", "b", "c"]

Process digit '3' (letters: "def"):
    For each existing combo ["a", "b", "c"]:
        "a" + "d" → "ad"
        "a" + "e" → "ae"
        "a" + "f" → "af"
        "b" + "d" → "bd"
        "b" + "e" → "be"
        "b" + "f" → "bf"
        "c" + "d" → "cd"
        "c" + "e" → "ce"
        "c" + "f" → "cf"
    
    combination_list = ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

### Step-by-Step Execution
```
digits = "234"

Step 1: Process '2' → ["a", "b", "c"]

Step 2: Process '3' → Expand each with "def"
    ["a","b","c"] → ["ad","ae","af","bd","be","bf","cd","ce","cf"]

Step 3: Process '4' → Expand each with "ghi"
    ["ad",...,"cf"] → ["adg","adh","adi",...,"cfg","cfh","cfi"]
    Total: 3 × 3 × 3 = 27 combinations
```

### Pseudocode
```
function letterCombinations(digits):
    if digits is empty:
        return []
    
    digit_to_letter = {digit → letters mapping}
    combination_list = None
    
    for each digit in digits:
        if combination_list is None:
            combination_list = digit_to_letter[digit]
        else:
            new_combination_list = []
            for combo in combination_list:
                for letter in digit_to_letter[digit]:
                    new_combination_list.append(combo + letter)
            combination_list = new_combination_list
    
    return combination_list
```

### Complexity Analysis
- **Time:** O(4^n × n) where n = len(digits)
  - Same as recursive: must generate all combinations
- **Space:** O(4^n × n) for storing combinations (no recursion stack)

---

## Approach Comparison

| Aspect | Recursive | Iterative |
|--------|-----------|-----------|
| **Time Complexity** | O(4^n × n) | O(4^n × n) |
| **Space Complexity** | O(4^n × n) + O(n) stack | O(4^n × n) |
| **Readability** | More intuitive (divide & conquer) | More explicit (step-by-step) |
| **Stack Overflow Risk** | Yes (for large n) | No |
| **Best For** | Understanding the pattern | Production code |

---

## Critical Insights

### 1. Why Return [""] in Base Case?
```python
if index >= len(digits):
    return [""]  # NOT []
```
- Returning `[""]` allows concatenation: `"a" + "" = "a"`
- Returning `[]` would give no combinations (empty loop)

### 2. Cartesian Product Pattern
This problem is fundamentally about computing:
```
Result = Set₁ × Set₂ × Set₃ × ... × Setₙ
```
For "23": `{"a","b","c"} × {"d","e","f"}`

### 3. Combinatorial Explosion
```
digits = "2"    → 3 combinations
digits = "23"   → 9 combinations
digits = "234"  → 27 combinations
digits = "2345" → 81 combinations
```
Growth is exponential: O(4^n) in worst case

### 4. Why Constraint is digits.length <= 4?
- 4 digits with 4 letters each = 4^4 = 256 combinations (manageable)
- 10 digits would give 4^10 = 1,048,576 combinations (too large)

---

## Common Mistakes

### ❌ Mistake 1: Forgetting Empty String Check
```python
def letterCombinations(digits):
    # Missing this check
    if digits == "":
        return []
```
**Impact:** Would return [""] instead of []

### ❌ Mistake 2: Wrong Base Case
```python
if index >= len(digits):
    return []  # Wrong! Should be [""]
```
**Impact:** No combinations generated (empty loop)

### ❌ Mistake 3: Not Handling Single Digit
```python
# Iterative approach without None check
combination_list = []  # Wrong initialization
for digit in digits:
    # This fails for first digit
    for combo in combination_list:
        ...
```

---

## Edge Cases

| Input | Output | Reason |
|-------|--------|--------|
| `""` | `[]` | Empty input → empty output |
| `"2"` | `["a","b","c"]` | Single digit |
| `"7"` | `["p","q","r","s"]` | Digit with 4 letters |
| `"79"` | 4×4=16 combinations | Maximum letters per digit |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Generate Parentheses** - All valid combinations
2. **Permutations** - All orderings of elements
3. **Subsets** - All possible subsets
4. **Combination Sum** - All combinations summing to target

### Key Characteristics:
- Need to generate ALL possibilities
- Combinatorial problem
- Can be solved with recursion/backtracking
- Exponential time complexity

---

## Complete Implementations

### Implementation 1: Recursive Approach ⭐
```python
def letterCombinations(digits: str) -> list[str]:
    if digits == "":
        return []
    
    numMap = {
        "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
        "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"
    }
    
    def combine(index):
        if index >= len(digits):
            return [""]
        
        next_combo = combine(index + 1)
        alpha = numMap[digits[index]]
        res = []
        
        for letter in alpha:
            for combo in next_combo:
                res.append(letter + combo)
        
        return res
    
    return combine(0)
```

### Implementation 2: Iterative Approach
```python
def letterCombinations(digits: str) -> list[str]:
    if digits == "":
        return []
    
    digit_to_letter = {
        "2": ["a", "b", "c"],
        "3": ["d", "e", "f"],
        "4": ["g", "h", "i"],
        "5": ["j", "k", "l"],
        "6": ["m", "n", "o"],
        "7": ["p", "q", "r", "s"],
        "8": ["t", "u", "v"],
        "9": ["w", "x", "y", "z"]
    }
    
    combination_list = None
    
    for digit in digits:
        if combination_list is None:
            combination_list = digit_to_letter[digit]
        else:
            new_combination_list = []
            for combo in combination_list:
                for letter in digit_to_letter[digit]:
                    new_combination_list.append(combo + letter)
            combination_list = new_combination_list
    
    return combination_list
```

### Implementation 3: Using itertools (Python)
```python
from itertools import product

def letterCombinations(digits: str) -> list[str]:
    if not digits:
        return []
    
    digit_to_letter = {
        "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
        "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"
    }
    
    letter_groups = [digit_to_letter[d] for d in digits]
    return [''.join(combo) for combo in product(*letter_groups)]
```

---

## Optimization Techniques

### 1. Pre-allocate Result Size
```python
# Calculate exact size needed
total_combinations = 1
for digit in digits:
    total_combinations *= len(numMap[digit])

res = [None] * total_combinations  # Pre-allocate
```

### 2. Use List Comprehension
```python
# More Pythonic
res = [letter + combo 
       for letter in alpha 
       for combo in next_combo]
```

### 3. Avoid String Concatenation in Loop
```python
# Build as list, join at end
def combine(index, current):
    if index >= len(digits):
        result.append(''.join(current))
        return
    
    for letter in numMap[digits[index]]:
        current.append(letter)
        combine(index + 1, current)
        current.pop()
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Generate Parentheses** | Backtracking pattern | Must validate combinations |
| **Permutations** | Generate all possibilities | Order matters |
| **Subsets** | Combinatorial generation | Include/exclude decision |
| **Combination Sum** | Backtracking | Must sum to target |

---

## Day 38 Summary

### Problems Solved: 1
1. ✅ Letter Combinations of a Phone Number

### Key Patterns Learned:
1. **Cartesian Product Generation** - Combining elements from multiple sets
2. **Recursive Backtracking** - Building solutions by exploring all paths
3. **Iterative Expansion** - Growing solution set step by step

### Techniques Mastered:
- Recursive combination building
- Base case design (returning [""] vs [])
- Iterative cartesian product
- Combinatorial complexity analysis

### Complexity Insights:
- Exponential growth: O(4^n) combinations
- String operations add O(n) factor
- Space dominated by output size

### When to Use This Pattern:
- Generate ALL combinations/permutations
- Explore ALL possible paths
- Combinatorial problems with constraints
- Problems requiring exhaustive search

---

## Quick Reference

### Recursion Template for Combinations
```python
def generate_combinations(input, index):
    # Base case: processed all elements
    if index >= len(input):
        return [base_result]
    
    # Get combinations from remaining elements
    sub_combinations = generate_combinations(input, index + 1)
    
    # Combine current element with sub-combinations
    result = []
    for option in current_options:
        for sub_combo in sub_combinations:
            result.append(combine(option, sub_combo))
    
    return result
```

### Time Complexity Formula
```
For n digits with average k letters per digit:
- Combinations: k^n
- String operations: O(n) per combination
- Total: O(k^n × n)
```
