# Day 18 - Stack Fundamentals

## Problem 1: Valid Parentheses

### Problem Statement
**Input:** `s = "()[]{}"`
**Output:** `true`

**Input:** `s = "([)]"`
**Output:** `false`

**Rules:**
1. Open brackets must be closed by same type
2. Open brackets must be closed in correct order
3. Every close bracket has corresponding open bracket

---

### Problem Logic

**Key Insight:** Stack is perfect for matching pairs - Last Opened, First Closed (LIFO)

**Approach:**
- Push opening brackets onto stack
- When closing bracket found, check if it matches top of stack
- If matches, pop; if not, invalid
- At end, stack should be empty

**Why Stack?**
- Natural LIFO behavior matches bracket pairing
- Most recent opening must match first closing
- Example: `([])` - `(` opens, `[` opens, `]` closes `[`, `)` closes `(`

---

### Solution Patterns

#### Pattern 1: Stack with HashMap (Optimal) ⭐

**Pseudocode:**
```
FUNCTION isValid(s):
    CREATE mapping = {')':'(', '}':'{', ']':'['}
    CREATE stack = []
    
    FOR each char in s:
        IF char is closing bracket:
            IF stack is empty OR top doesn't match:
                RETURN False
            POP from stack
        ELSE:  // opening bracket
            PUSH char to stack
    
    RETURN stack is empty
```

**Code:**
```python
def isValid(s):
    mapping = {')': '(', '}': '{', ']': '['}
    stack = []
    
    for char in s:
        if char in mapping:  # Closing bracket
            if not stack or mapping[char] != stack.pop():
                return False
        else:  # Opening bracket
            stack.append(char)
    
    return not stack  # True if empty
```

**Complexity:**
- Time: O(n) - single pass
- Space: O(n) - worst case all opening brackets

---

### Flow Diagram

```
Input: "([{}])"

Step 1: char='('
        Stack: ['(']
        Action: Push opening bracket

Step 2: char='['
        Stack: ['(', '[']
        Action: Push opening bracket

Step 3: char='{'
        Stack: ['(', '[', '{']
        Action: Push opening bracket

Step 4: char='}'
        Stack top: '{', matches!
        Stack: ['(', '[']
        Action: Pop

Step 5: char=']'
        Stack top: '[', matches!
        Stack: ['(']
        Action: Pop

Step 6: char=')'
        Stack top: '(', matches!
        Stack: []
        Action: Pop

Final: Stack empty → Valid!
```

---

### Visual Explanation

```
"( [ { } ] )"
 ↓
Push '('
Stack: ['(']

 ↓
Push '['
Stack: ['(', '[']

 ↓
Push '{'
Stack: ['(', '[', '{']

 ↓
'}' matches '{' → Pop
Stack: ['(', '[']

 ↓
']' matches '[' → Pop
Stack: ['(']

 ↓
')' matches '(' → Pop
Stack: []

Empty stack = Valid ✓
```

---

## Problem 2: Min Stack

### Problem Statement
Design a stack supporting push, pop, top, and **getMin** in O(1) time

**Operations:**
- `push(val)` - Push element
- `pop()` - Remove top element
- `top()` - Get top element
- `getMin()` - Get minimum element (O(1)!)

---

### Problem Logic

**Key Insight:** Use auxiliary stack to track minimum at each level

**Challenge:** How to get min in O(1) without scanning entire stack?

**Solution:** Maintain parallel "min stack" that stores minimum value at each level

**Why Two Stacks?**
- Main stack: stores all values
- Min stack: stores minimum value up to that point
- Both stacks stay synchronized

---

### Solution Patterns

#### Pattern 1: Two Stacks (Optimal) ⭐

**Pseudocode:**
```
CLASS MinStack:
    INITIALIZE:
        stack = []
        minStack = []
    
    FUNCTION push(val):
        ADD val to stack
        IF minStack empty OR val <= minStack.top:
            ADD val to minStack
        ELSE:
            ADD minStack.top to minStack (repeat current min)
    
    FUNCTION pop():
        REMOVE from stack
        REMOVE from minStack
    
    FUNCTION top():
        RETURN stack.top
    
    FUNCTION getMin():
        RETURN minStack.top
```

**Code:**
```python
class MinStack:
    def __init__(self):
        self.stack = []
        self.minStack = []
    
    def push(self, val):
        self.stack.append(val)
        
        # Update min stack
        if not self.minStack or val <= self.minStack[-1]:
            self.minStack.append(val)
        else:
            self.minStack.append(self.minStack[-1])
    
    def pop(self):
        if not self.stack:
            return
        self.minStack.pop()
        return self.stack.pop()
    
    def top(self):
        return self.stack[-1] if self.stack else None
    
    def getMin(self):
        return self.minStack[-1] if self.minStack else None
```

**Complexity:**
- Time: O(1) for all operations
- Space: O(n) - two stacks

---

#### Pattern 2: Single Stack with Tuples

**Code:**
```python
class MinStack:
    def __init__(self):
        self.stack = []  # Store (value, current_min)
    
    def push(self, val):
        if not self.stack:
            self.stack.append((val, val))
        else:
            current_min = min(val, self.stack[-1][1])
            self.stack.append((val, current_min))
    
    def pop(self):
        if self.stack:
            self.stack.pop()
    
    def top(self):
        return self.stack[-1][0] if self.stack else None
    
    def getMin(self):
        return self.stack[-1][1] if self.stack else None
```

**Complexity:**
- Time: O(1) for all operations
- Space: O(n) - single stack with tuples

---

### Flow Diagram (Two Stacks)

```
Operation: push(-2)
Stack:    [-2]
MinStack: [-2]
Min: -2

Operation: push(0)
Stack:    [-2, 0]
MinStack: [-2, -2]  (0 > -2, so repeat -2)
Min: -2

Operation: push(-3)
Stack:    [-2, 0, -3]
MinStack: [-2, -2, -3]  (-3 < -2, new min!)
Min: -3

Operation: getMin()
Return: -3 (top of minStack)

Operation: pop()
Stack:    [-2, 0]
MinStack: [-2, -2]
Min: -2

Operation: top()
Return: 0 (top of stack)

Operation: getMin()
Return: -2 (top of minStack)
```

---

### Visual Explanation

```
Push -2:
stack:    [-2]
minStack: [-2]  (first element, so it's min)

Push 0:
stack:    [-2, 0]
minStack: [-2, -2]  (0 > -2, keep -2 as min)

Push -3:
stack:    [-2, 0, -3]
minStack: [-2, -2, -3]  (-3 < -2, new min!)

getMin() → -3 (top of minStack)

Pop:
stack:    [-2, 0]
minStack: [-2, -2]  (both stacks pop together)

getMin() → -2 (top of minStack)
```

---

## Problem 3: Evaluate Reverse Polish Notation

### Problem Statement
**Input:** `tokens = ["2","1","+","3","*"]`
**Output:** `9`
**Explanation:** `((2 + 1) * 3) = 9`

**RPN Format:** Operands come before operators
- Infix: `(2 + 1) * 3`
- RPN: `2 1 + 3 *`

---

### Problem Logic

**Key Insight:** Stack naturally evaluates RPN - operands accumulate, operators consume

**How RPN Works:**
1. Read left to right
2. If number: push to stack
3. If operator: pop two operands, apply operator, push result
4. Final stack has one element: the answer

**Why Stack?**
- Operators always apply to most recent operands
- LIFO matches evaluation order
- No need for parentheses or precedence rules

---

### Solution Patterns

#### Pattern 1: Stack Evaluation (Optimal) ⭐

**Pseudocode:**
```
FUNCTION evalRPN(tokens):
    CREATE stack = []
    
    FOR each token in tokens:
        IF token is operator:
            POP b from stack
            POP a from stack
            COMPUTE result = a operator b
            PUSH result to stack
        ELSE:  // token is number
            PUSH int(token) to stack
    
    RETURN stack.top
```

**Code:**
```python
def evalRPN(tokens):
    stack = []
    
    for token in tokens:
        if token in '+-*/':
            b = stack.pop()
            a = stack.pop()
            
            if token == '+':
                stack.append(a + b)
            elif token == '-':
                stack.append(a - b)
            elif token == '*':
                stack.append(a * b)
            elif token == '/':
                # Truncate toward zero
                stack.append(int(a / b))
        else:
            stack.append(int(token))
    
    return stack[-1]
```

**Complexity:**
- Time: O(n) - single pass
- Space: O(n) - stack size

---

#### Pattern 2: Using Operator Dictionary

**Code:**
```python
def evalRPN(tokens):
    import operator
    
    ops = {
        '+': operator.add,
        '-': operator.sub,
        '*': operator.mul,
        '/': lambda x, y: int(x / y)
    }
    
    stack = []
    
    for token in tokens:
        if token in ops:
            b = stack.pop()
            a = stack.pop()
            stack.append(ops[token](a, b))
        else:
            stack.append(int(token))
    
    return stack[0]
```

**Complexity:**
- Time: O(n)
- Space: O(n)

---

### Flow Diagram

```
Input: ["2", "1", "+", "3", "*"]

Step 1: token="2"
        Stack: [2]
        Action: Push number

Step 2: token="1"
        Stack: [2, 1]
        Action: Push number

Step 3: token="+"
        Pop: b=1, a=2
        Compute: 2 + 1 = 3
        Stack: [3]
        Action: Push result

Step 4: token="3"
        Stack: [3, 3]
        Action: Push number

Step 5: token="*"
        Pop: b=3, a=3
        Compute: 3 * 3 = 9
        Stack: [9]
        Action: Push result

Final: Return 9
```

---

### Visual Explanation

```
Expression: 2 1 + 3 *
Infix: ((2 + 1) * 3)

Process:
2       → Stack: [2]
1       → Stack: [2, 1]
+       → Pop 1, 2 → 2+1=3 → Stack: [3]
3       → Stack: [3, 3]
*       → Pop 3, 3 → 3*3=9 → Stack: [9]

Result: 9
```

---

## Comparison Table

### Valid Parentheses

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Stack + HashMap | O(n) | O(n) | **Optimal** ⭐ |
| Counter (wrong) | O(n) | O(1) | Doesn't work! |

### Min Stack

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Two Stacks | O(1) all ops | O(n) | **Optimal** ⭐ |
| Stack + Tuples | O(1) all ops | O(n) | Cleaner code |
| Scan for min | O(n) getMin | O(n) | Not optimal |

### Reverse Polish Notation

| Approach | Time | Space | Best For |
|----------|------|-------|----------|
| Stack | O(n) | O(n) | **Optimal** ⭐ |
| Recursion | O(n) | O(n) | Complex |

---

## Key Patterns Summary

### Pattern 1: Matching Pairs (Parentheses)
**Use for:** Balanced brackets, nested structures
**Template:**
```python
stack = []
for char in s:
    if is_opening(char):
        stack.append(char)
    else:  # closing
        if not stack or not matches(stack[-1], char):
            return False
        stack.pop()
return not stack
```

### Pattern 2: Auxiliary Stack (Min Stack)
**Use for:** Tracking additional property (min, max, etc.)
**Template:**
```python
class SpecialStack:
    def __init__(self):
        self.stack = []
        self.auxStack = []
    
    def push(self, val):
        self.stack.append(val)
        # Update aux based on condition
        self.auxStack.append(compute_aux(val))
```

### Pattern 3: Expression Evaluation (RPN)
**Use for:** Postfix expressions, calculators
**Template:**
```python
stack = []
for token in tokens:
    if is_operator(token):
        b, a = stack.pop(), stack.pop()
        stack.append(apply(a, token, b))
    else:
        stack.append(int(token))
return stack[0]
```

---

## Common Mistakes

### Valid Parentheses:
1. **Not checking empty stack** before pop
2. **Forgetting to check stack empty at end**
3. **Wrong mapping direction** (should map closing → opening)

### Min Stack:
1. **Not synchronizing stacks** - both must push/pop together
2. **Comparing with wrong value** - use `<=` not `<` for duplicates
3. **Forgetting to repeat min** when new value is larger

### RPN:
1. **Wrong operand order** - `a = stack.pop()` then `b = stack.pop()` is backwards!
2. **Integer division** - must truncate toward zero: `int(a/b)`
3. **Not handling negative numbers** - check if token starts with `-` and is digit

---

## Edge Cases

### Valid Parentheses:
```python
""           → True   # Empty string
"("          → False  # Unclosed
")"          → False  # No opening
"()"         → True   # Simple valid
"([)]"       → False  # Wrong order
"([])"       → True   # Nested valid
```

### Min Stack:
```python
push(-2), push(0), push(-3)
getMin() → -3
pop()
getMin() → -2  # Min updates correctly

push(5), push(5), push(5)
getMin() → 5  # Handles duplicates
```

### RPN:
```python
["2","1","+"]           → 3
["4","13","5","/","+"]  → 6
["10","6","9","3","+","-11","*","/","*","17","+","5","+"] → 22
["-1","2","+"]          → 1  # Negative numbers
```

---

## Stack Operations Cheat Sheet

```python
# Python List as Stack
stack = []

# Push
stack.append(x)

# Pop
x = stack.pop()

# Peek/Top
x = stack[-1]

# Is Empty
if not stack:

# Size
len(stack)
```

---

## Quick Reference

### Valid Parentheses:
```
1. Create mapping: closing → opening
2. For each char:
   - If closing: check match and pop
   - If opening: push
3. Return stack is empty
```

### Min Stack:
```
1. Maintain two stacks
2. Push: update both stacks
3. Pop: pop from both
4. getMin: return minStack.top
```

### RPN:
```
1. For each token:
   - If number: push
   - If operator: pop 2, compute, push result
2. Return final stack value
```

---

## When to Use Stack?

```
Use Stack when:
✓ Need to match pairs (parentheses)
✓ Need to reverse order (LIFO)
✓ Need to track nested structures
✓ Evaluating expressions (RPN, infix)
✓ Backtracking problems
✓ Undo/Redo functionality

Don't use Stack when:
✗ Need random access
✗ Need to search middle elements
✗ FIFO behavior needed (use queue)
```

---

## Key Takeaways

1. **Stack = LIFO** - Last In, First Out
2. **Perfect for matching** - parentheses, brackets, tags
3. **Auxiliary stack** enables O(1) queries (min, max)
4. **RPN naturally uses stack** - no precedence needed
5. **Always check empty** before pop/peek
6. **Python list** works great as stack
7. **Space complexity** usually O(n) for stack problems

---

## Practice Variations

**Parentheses:**
- Generate valid parentheses
- Longest valid parentheses
- Remove invalid parentheses

**Min Stack:**
- Max stack
- Stack with increment operation
- Implement queue using stacks

**RPN:**
- Basic calculator
- Basic calculator II
- Expression evaluation with parentheses
