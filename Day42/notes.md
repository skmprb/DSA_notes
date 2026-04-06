# Day 42: ZigZag Conversion

## Problem Statement
**LeetCode 6: ZigZag Conversion**

The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this:
```
P   A   H   N
A P L S I I G
Y   I   R
```

And then read line by line: "PAHNAPLSIIGYIR"

Write the code that will take a string and make this conversion given a number of rows.

**Examples:**
```
Input: s = "PAYPALISHIRING", numRows = 3
Output: "PAHNAPLSIIGYIR"
Explanation:
P   A   H   N
A P L S I I G
Y   I   R

Input: s = "PAYPALISHIRING", numRows = 4
Output: "PINALSIGYAHRPI"
Explanation:
P     I    N
A   L S  I G
Y A   H R
P     I

Input: s = "A", numRows = 1
Output: "A"
```

**Constraints:**
- 1 <= s.length <= 1000
- s consists of English letters (lower-case and upper-case), ',' and '.'
- 1 <= numRows <= 1000

---

## Problem Logic & Reasoning

### Core Concept
The zigzag pattern moves **down** through rows, then **diagonally up**, repeating this cycle.

**Key Insight:** We don't need to actually create the visual zigzag. We just need to know which row each character belongs to, then read rows in order.

### Visual Understanding for "PAYPALISHIRING", numRows = 3

```
Index:  0 1 2 3 4 5 6 7 8 9 10 11 12 13
Char:   P A Y P A L I S H I R  I  N  G

Pattern:
Row 0:  P       A       H       N
Row 1:    A   P   L   S   I   I   G
Row 2:      Y       I       R

Direction: ↓ ↓ ↑ ↓ ↓ ↑ ↓ ↓ ↑ ↓ ↓  ↑  ↓  ↓

Row assignment:
0 → P (row 0)
1 → A (row 1)
2 → Y (row 2) [hit bottom, change direction]
3 → P (row 1) [going up]
4 → A (row 0) [hit top, change direction]
5 → L (row 1) [going down]
6 → I (row 2) [hit bottom, change direction]
...

Result: Row 0 + Row 1 + Row 2 = "PAHN" + "APLSIIG" + "YIR" = "PAHNAPLSIIGYIR"
```

### The Pattern
```
For numRows = 4:
Row 0: 0       6        12
Row 1: 1     5 7    11 13
Row 2: 2   4   8  10
Row 3: 3       9

Movement: Down (0→1→2→3), Up (2→1→0), Down (1→2→3), Up (2→1→0)...
```

---

## Approach 1: Row-by-Row Simulation (Direction Flag) ⭐

### Logic
Simulate the zigzag movement using a direction flag:
1. Create array of strings, one for each row
2. Track current row and direction (going_down)
3. For each character, append to current row
4. Update direction when hitting top (row 0) or bottom (row numRows-1)
5. Join all rows

### Visual Flow for "PAYPALISHIRING", numRows = 3

```
Initial: rows = ["", "", ""], current_row = 0, going_down = False

i=0, char='P':
    rows[0] += 'P' → ["P", "", ""]
    current_row = 0 → going_down = True
    current_row += 1 → current_row = 1

i=1, char='A':
    rows[1] += 'A' → ["P", "A", ""]
    current_row += 1 → current_row = 2

i=2, char='Y':
    rows[2] += 'Y' → ["P", "A", "Y"]
    current_row = 2 (bottom) → going_down = False
    current_row -= 1 → current_row = 1

i=3, char='P':
    rows[1] += 'P' → ["P", "AP", "Y"]
    current_row -= 1 → current_row = 0

i=4, char='A':
    rows[0] += 'A' → ["PA", "AP", "Y"]
    current_row = 0 (top) → going_down = True
    current_row += 1 → current_row = 1

i=5, char='L':
    rows[1] += 'L' → ["PA", "APL", "Y"]
    current_row += 1 → current_row = 2

...continuing...

Final: rows = ["PAHN", "APLSIIG", "YIR"]
Result: "PAHNAPLSIIGYIR"
```

### Direction Change Logic
```
At row 0 (top):
    going_down = True
    Next: current_row += 1

At row numRows-1 (bottom):
    going_down = False
    Next: current_row -= 1

In between:
    If going_down: current_row += 1
    Else: current_row -= 1
```

### Pseudocode
```
function convert(s, numRows):
    if numRows == 1 or len(s) <= numRows:
        return s
    
    rows = [""] * numRows
    current_row = 0
    going_down = False
    
    for char in s:
        rows[current_row] += char
        
        if current_row == 0:
            going_down = True
        if current_row == numRows - 1:
            going_down = False
        
        if going_down:
            current_row += 1
        else:
            current_row -= 1
    
    return "".join(rows)
```

### Complexity Analysis
- **Time:** O(n) - Single pass through string
- **Space:** O(n) - Storing all characters in rows array

---

## Approach 2: Mathematical Pattern (Cycle-Based)

### Logic
Observe that the zigzag follows a repeating cycle pattern:
- Cycle length = 2 × numRows - 2
- Characters cycle through: [0, 1, 2, ..., numRows-1, numRows-2, ..., 1]

### Pattern Discovery for numRows = 4

```
Full cycle: [0, 1, 2, 3, 2, 1]
Length: 2 × 4 - 2 = 6

Index:  0  1  2  3  4  5  6  7  8  9  10 11 12 13
Char:   P  A  Y  P  A  L  I  S  H  I  R  I  N  G
Row:    0  1  2  3  2  1  0  1  2  3  2  1  0  1

Pattern repeats every 6 characters!
```

### Visual Flow
```
Cycle pattern for numRows = 4:
    [0, 1, 2, 3, 2, 1]
     ↓  ↓  ↓  ↓  ↑  ↑
    down down down up up

For each character at index i:
    row = pattern[i % cycle_length]
```

### Pseudocode
```
function convert(s, numRows):
    if numRows == 1:
        return s
    
    # Create cycle pattern: [0,1,2,...,numRows-1,numRows-2,...,1]
    pattern = list(range(numRows)) + list(range(numRows-2, 0, -1))
    
    rows = [""] * numRows
    
    for i, char in enumerate(s):
        row_index = pattern[i % len(pattern)]
        rows[row_index] += char
    
    return "".join(rows)
```

### Complexity Analysis
- **Time:** O(n) - Single pass
- **Space:** O(n) - Rows array + O(numRows) for pattern

---

## Approach 3: 2D Array Simulation

### Logic
Actually create the 2D grid and fill it in zigzag pattern:
1. Calculate required columns
2. Create 2D grid
3. Fill grid following zigzag movement
4. Read row by row, skipping empty cells

### Visual Flow for "PAYPALISHIRING", numRows = 3

```
Grid creation:
Cycle length = 2×3-2 = 4
Columns needed ≈ len(s) / 2 = 7

Grid (3 rows × 7 cols):
[['', '', '', '', '', '', ''],
 ['', '', '', '', '', '', ''],
 ['', '', '', '', '', '', '']]

Filling:
Step 1-3 (going down):
[['P', '', '', '', '', '', ''],
 ['A', '', '', '', '', '', ''],
 ['Y', '', '', '', '', '', '']]

Step 4 (diagonal up):
[['P', '', '', '', '', '', ''],
 ['A', 'P', '', '', '', '', ''],
 ['Y', '', '', '', '', '', '']]

Step 5 (hit top, going down):
[['P', 'A', '', '', '', '', ''],
 ['A', 'P', '', '', '', '', ''],
 ['Y', '', '', '', '', '', '']]

...continuing...

Final grid:
[['P', 'A', '', '', 'H', '', '', '', 'N', '', '', '', '', ''],
 ['A', '', 'P', 'L', '', 'S', '', 'I', '', 'I', '', 'G', '', ''],
 ['Y', '', '', '', 'I', '', '', '', 'R', '', '', '', '', '']]

Read row by row: "PAHNAPLSIIGYIR"
```

### Pseudocode
```
function convert(s, numRows):
    if numRows == 1:
        return s
    
    cycle_len = 2 * numRows - 2
    num_cols = calculate_columns(len(s), cycle_len, numRows)
    
    grid = [['' for _ in range(num_cols)] for _ in range(numRows)]
    
    row, col = 0, 0
    going_down = True
    
    for char in s:
        grid[row][col] = char
        
        if going_down:
            if row == numRows - 1:
                going_down = False
                row -= 1
                col += 1
            else:
                row += 1
        else:
            if row == 0:
                going_down = True
                row += 1
            else:
                row -= 1
                col += 1
    
    result = ""
    for r in range(numRows):
        for c in range(num_cols):
            if grid[r][c] != '':
                result += grid[r][c]
    
    return result
```

### Complexity Analysis
- **Time:** O(n) - Fill grid + read grid
- **Space:** O(n × m) - 2D grid (less efficient)

---

## Approach Comparison

| Aspect | Row Simulation | Mathematical Pattern | 2D Array |
|--------|---------------|---------------------|----------|
| **Time Complexity** | O(n) | O(n) | O(n) |
| **Space Complexity** | O(n) | O(n) | O(n × m) |
| **Intuition** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Code Simplicity** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Space Efficiency** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Best For** | Interviews | Elegant solution | Visualization |

---

## Critical Insights

### 1. Why numRows = 1 is Special
```
For numRows = 1:
    No zigzag, just return original string
    
Without check:
    cycle = 2×1-2 = 0 (division by zero!)
    going_down logic breaks
```

### 2. The Cycle Pattern
```
numRows = 3: [0, 1, 2, 1] → cycle length = 4
numRows = 4: [0, 1, 2, 3, 2, 1] → cycle length = 6
numRows = 5: [0, 1, 2, 3, 4, 3, 2, 1] → cycle length = 8

Formula: cycle_length = 2 × numRows - 2
```

### 3. Why Update Direction BEFORE Moving?
```
Correct order:
1. Add character to current row
2. Check if at boundary (update direction)
3. Move to next row

Wrong order (update after moving):
1. Add character
2. Move
3. Check boundary
Result: Skips rows at boundaries!
```

### 4. Edge Case: len(s) <= numRows
```
Input: s = "ABC", numRows = 5

Pattern:
Row 0: A
Row 1: B
Row 2: C
Row 3: (empty)
Row 4: (empty)

Result: "ABC" (same as input)
Can return early!
```

### 5. String Concatenation Efficiency
```
Inefficient:
result = ""
for row in rows:
    result += row  # Creates new string each time

Efficient:
return "".join(rows)  # Single concatenation
```

---

## Common Mistakes

### ❌ Mistake 1: Wrong Direction Update Order
```python
# Wrong: Update direction after moving
if going_down:
    current_row += 1
if current_row == 0:
    going_down = True
```
**Impact:** Skips rows at boundaries

### ❌ Mistake 2: Not Handling numRows = 1
```python
def convert(s, numRows):
    rows = [""] * numRows
    # Missing: if numRows == 1: return s
    
    cycle = 2 * numRows - 2  # 0 for numRows=1!
```

### ❌ Mistake 3: Using += for Direction
```python
# Wrong: Both conditions can be true
if current_row == 0:
    going_down = True
    current_row += 1  # Moves immediately!
if current_row == numRows - 1:
    going_down = False
    current_row -= 1  # Might execute same iteration!
```

### ❌ Mistake 4: Inefficient String Building
```python
result = ""
for row in rows:
    for char in row:
        result += char  # O(n²) time!
```
**Fix:** Use "".join(rows)

### ❌ Mistake 5: Wrong Initial Direction
```python
going_down = True  # Wrong! Should be False initially
current_row = 0

# First iteration will increment to row 1 before adding char!
```

---

## Edge Cases

| Input | numRows | Output | Reason |
|-------|---------|--------|--------|
| `"A"` | `1` | `"A"` | Single character |
| `"AB"` | `1` | `"AB"` | numRows = 1 (no zigzag) |
| `"ABC"` | `5` | `"ABC"` | len(s) < numRows |
| `"PAYPALISHIRING"` | `14` | `"PAYPALISHIRING"` | len(s) = numRows |
| `""` | `1` | `""` | Empty string |

---

## Pattern Recognition

### This Pattern Applies To:
1. **Spiral Matrix** - Similar directional movement
2. **Diagonal Traverse** - Changing directions in 2D
3. **Snake Pattern** - Alternating directions
4. **Matrix Rotation** - Directional traversal

### Key Characteristics:
- Directional movement with boundary checks
- Pattern repetition (cycles)
- Row/column tracking
- String building from parts

---

## Complete Implementations

### Implementation 1: Row Simulation (Direction Flag) ⭐
```python
def convert(s: str, numRows: int) -> str:
    if numRows == 1 or len(s) <= numRows:
        return s
    
    rows = [""] * numRows
    current_row = 0
    going_down = False
    
    for char in s:
        rows[current_row] += char
        
        if current_row == 0:
            going_down = True
        if current_row == numRows - 1:
            going_down = False
        
        if going_down:
            current_row += 1
        else:
            current_row -= 1
    
    return "".join(rows)
```

### Implementation 2: Using Direction Variable (+1 or -1)
```python
def convert(s: str, numRows: int) -> str:
    if numRows == 1 or len(s) <= numRows:
        return s
    
    rows = [""] * numRows
    current_row = 0
    direction = 1  # 1 for down, -1 for up
    
    for char in s:
        rows[current_row] += char
        
        if current_row == 0:
            direction = 1
        elif current_row == numRows - 1:
            direction = -1
        
        current_row += direction
    
    return "".join(rows)
```

### Implementation 3: Mathematical Pattern (Cycle-Based) ⭐
```python
def convert(s: str, numRows: int) -> str:
    if numRows == 1:
        return s
    
    # Create cycle pattern
    pattern = list(range(numRows)) + list(range(numRows - 2, 0, -1))
    rows = [""] * numRows
    
    for i, char in enumerate(s):
        rows[pattern[i % len(pattern)]] += char
    
    return "".join(rows)
```

### Implementation 4: Using Lists Instead of Strings
```python
def convert(s: str, numRows: int) -> str:
    if numRows == 1 or len(s) <= numRows:
        return s
    
    rows = [[] for _ in range(numRows)]
    current_row = 0
    direction = 1
    
    for char in s:
        rows[current_row].append(char)
        
        if current_row == 0:
            direction = 1
        elif current_row == numRows - 1:
            direction = -1
        
        current_row += direction
    
    return "".join("".join(row) for row in rows)
```

### Implementation 5: 2D Array Approach
```python
def convert(s: str, numRows: int) -> str:
    if numRows == 1 or len(s) <= numRows:
        return s
    
    cycle_len = 2 * numRows - 2
    num_cycles = (len(s) + cycle_len - 1) // cycle_len
    num_cols = num_cycles * (numRows - 1)
    
    grid = [['' for _ in range(num_cols)] for _ in range(numRows)]
    
    row, col = 0, 0
    going_down = True
    
    for char in s:
        grid[row][col] = char
        
        if going_down:
            if row == numRows - 1:
                going_down = False
                row -= 1
                col += 1
            else:
                row += 1
        else:
            if row == 0:
                going_down = True
                row += 1
            else:
                row -= 1
                col += 1
    
    result = []
    for r in range(numRows):
        for c in range(num_cols):
            if grid[r][c]:
                result.append(grid[r][c])
    
    return "".join(result)
```

---

## Optimization Techniques

### 1. Early Exit for Edge Cases
```python
if numRows == 1 or len(s) <= numRows:
    return s
```

### 2. Use Lists Instead of String Concatenation
```python
# Faster for large strings
rows = [[] for _ in range(numRows)]
rows[current_row].append(char)
```

### 3. Pre-calculate Pattern
```python
# Calculate once, reuse
pattern = list(range(numRows)) + list(range(numRows - 2, 0, -1))
```

### 4. Generator Expression for Final Join
```python
return "".join("".join(row) for row in rows)
```

---

## Related Problems

| Problem | Similarity | Key Difference |
|---------|-----------|----------------|
| **Spiral Matrix** | Directional movement | 2D traversal in spiral |
| **Diagonal Traverse** | Direction changes | Diagonal instead of vertical |
| **String Compression** | String manipulation | Different pattern |
| **Valid Parentheses** | Pattern matching | Stack-based |

---

## Day 42 Summary

### Problems Solved: 1
1. ✅ ZigZag Conversion

### Key Patterns Learned:
1. **Directional Simulation** - Using flags to track movement direction
2. **Cycle Pattern Recognition** - Identifying repeating patterns
3. **Row-by-Row Building** - Constructing result by grouping elements

### Techniques Mastered:
- Direction flag management (going_down)
- Boundary detection and direction reversal
- Mathematical pattern discovery (cycle-based)
- Efficient string building with join

### Complexity Insights:
- All approaches: O(n) time
- Row simulation: O(n) space (optimal)
- 2D array: O(n × m) space (less efficient)
- Pattern-based: O(n) space + O(numRows) for pattern

### When to Use This Pattern:
- Problems with directional movement
- Zigzag or spiral patterns
- String rearrangement based on position
- Simulating physical movement in grid

---

## Quick Reference

### Direction Management Template
```python
current_position = start
direction = initial_direction

for item in items:
    process(item, current_position)
    
    # Check boundaries
    if at_boundary():
        direction = reverse_direction()
    
    current_position += direction
```

### Cycle Pattern Template
```python
# Create repeating pattern
pattern = create_pattern()

for i, item in enumerate(items):
    position = pattern[i % len(pattern)]
    process(item, position)
```

### Time Complexity Analysis
```
For string of length n:
- Single pass: O(n)
- String building: O(n) with join, O(n²) with +=
- Space: O(n) for storing result

Total: O(n) time, O(n) space
```
