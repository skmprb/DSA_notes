# Day 63: Validate Binary Search Tree - Detailed Notes

## Problem Statement

**LeetCode #98 - Validate Binary Search Tree (Medium)**

Given the root of a binary tree, determine if it is a valid binary search tree (BST).

**A valid BST is defined as follows:**
- The **left** subtree of a node contains only nodes with keys **strictly less than** the node's key
- The **right** subtree of a node contains only nodes with keys **strictly greater than** the node's key
- Both the left and right subtrees must also be binary search trees

**Examples:**

```
Example 1:
Input: root = [2,1,3]
Output: true

Tree Structure:
    2
   / \
  1   3

Explanation: 
- 1 < 2 ✓
- 3 > 2 ✓
- Valid BST

Example 2:
Input: root = [5,1,4,null,null,3,6]
Output: false

Tree Structure:
    5
   / \
  1   4
     / \
    3   6

Explanation:
- Root's value is 5
- Right child is 4 (4 < 5) ✗
- Invalid BST

Example 3:
Input: root = [5,4,6,null,null,3,7]
Output: false

Tree Structure:
    5
   / \
  4   6
     / \
    3   7

Explanation:
- 6 > 5 ✓
- But 3 < 5 ✗ (3 is in right subtree of 5)
- Invalid BST
```

**Constraints:**
- The number of nodes in the tree is in the range [1, 10^4]
- -2^31 ≤ Node.val ≤ 2^31 - 1

---

## Problem Logic & Reasoning

### Understanding BST Properties

**What Makes a Valid BST?**

```
BST Property:
For every node N:
  - ALL nodes in left subtree < N
  - ALL nodes in right subtree > N
  - This applies recursively to all subtrees

Key Word: ALL (not just immediate children)
```

**Visual Example:**

```
Valid BST:
       10
      /  \
     5    15
    / \   / \
   2   7 12  20

Check node 10:
  Left subtree: {2, 5, 7} - all < 10 ✓
  Right subtree: {12, 15, 20} - all > 10 ✓

Check node 5:
  Left subtree: {2} - all < 5 ✓
  Right subtree: {7} - all > 5 ✓

Valid BST ✓
```

```
Invalid BST:
       10
      /  \
     5    15
    / \   / \
   2   7 12  8

Check node 10:
  Left subtree: {2, 5, 7} - all < 10 ✓
  Right subtree: {8, 12, 15} - 8 < 10 ✗

Node 8 is in right subtree but less than root!
Invalid BST ✗
```

### The Trap: Only Checking Immediate Children

**Common Mistake:**

```python
# Wrong approach
def isValidBST(root):
    if not root:
        return True
    
    # Only checking immediate children
    if root.left and root.left.val >= root.val:
        return False
    if root.right and root.right.val <= root.val:
        return False
    
    return isValidBST(root.left) and isValidBST(root.right)
```

**Why This Fails:**

```
Example:
       5
      / \
     1   4
        / \
       3   6

Check root 5:
  1 < 5 ✓
  4 < 5 ✗ (immediate check fails)

But even if we fix this:
       5
      / \
     1   6
        / \
       3   7

Check root 5:
  1 < 5 ✓
  6 > 5 ✓

Check node 6:
  3 < 6 ✓
  7 > 6 ✓

All immediate checks pass!
But 3 < 5, and 3 is in right subtree of 5 ✗

This approach misses the global constraint!
```

### The Key Insight: Range Constraints

**Correct Approach:**

Every node must satisfy a **range constraint**:
- Root: can be any value (-∞, +∞)
- Left child: must be in range (parent's min, parent's value)
- Right child: must be in range (parent's value, parent's max)

**Visual Flow:**

```
       10
      /  \
     5    15
    / \   / \
   2   7 12  20

Node 10: range (-∞, +∞)
  10 in range? ✓

Node 5: range (-∞, 10)
  5 in range? ✓

Node 15: range (10, +∞)
  15 in range? ✓

Node 2: range (-∞, 5)
  2 in range? ✓

Node 7: range (5, 10)
  7 in range? ✓

Node 12: range (10, 15)
  12 in range? ✓

Node 20: range (15, +∞)
  20 in range? ✓

All nodes satisfy range constraints ✓
```

### Core Challenge

**The Problem:**
1. Need to validate BST property globally, not just locally
2. Each node has implicit min/max constraints from ancestors
3. Must track these constraints as we traverse
4. Constraints tighten as we go deeper

**The Solution:**
- Pass min and max bounds down the tree
- Update bounds based on which direction we go
- Check if current node violates bounds
- Recursively validate subtrees with updated bounds

---

## Approach 1: Recursive with Range Validation ⭐⭐⭐

### Strategy

Use DFS with range constraints:
1. Start with root having range (-∞, +∞)
2. For each node, check if value is within valid range
3. Recursively validate left subtree with updated max bound
4. Recursively validate right subtree with updated min bound
5. Return true only if all nodes satisfy constraints

### Visual Flow

**Example: root = [5,1,4,null,null,3,6]**

```
Tree Structure:
    5
   / \
  1   4
     / \
    3   6

Step-by-Step Validation:

Step 1: Validate node 5
  Range: (-∞, +∞)
  Is -∞ < 5 < +∞? ✓
  
  Go left with range (-∞, 5)
  Go right with range (5, +∞)

Step 2: Validate node 1
  Range: (-∞, 5)
  Is -∞ < 1 < 5? ✓
  
  No children, return True

Step 3: Validate node 4
  Range: (5, +∞)
  Is 5 < 4 < +∞? ✗
  
  4 is NOT greater than 5!
  Return False

Result: False ✗
```

**Example: root = [10,5,15,null,null,6,20]**

```
Tree Structure:
       10
      /  \
     5    15
         / \
        6   20

Step-by-Step Validation:

Step 1: Validate node 10
  Range: (-∞, +∞)
  Is -∞ < 10 < +∞? ✓
  
  Go left with range (-∞, 10)
  Go right with range (10, +∞)

Step 2: Validate node 5
  Range: (-∞, 10)
  Is -∞ < 5 < 10? ✓
  
  No children, return True

Step 3: Validate node 15
  Range: (10, +∞)
  Is 10 < 15 < +∞? ✓
  
  Go left with range (10, 15)
  Go right with range (15, +∞)

Step 4: Validate node 6
  Range: (10, 15)
  Is 10 < 6 < 15? ✗
  
  6 is NOT greater than 10!
  Return False

Result: False ✗
```

**Example: Valid BST**

```
Tree Structure:
       10
      /  \
     5    15
    / \   / \
   2   7 12  20

Validation Trace:

validate(10, -∞, +∞)
  -∞ < 10 < +∞ ✓
  
  validate(5, -∞, 10)
    -∞ < 5 < 10 ✓
    
    validate(2, -∞, 5)
      -∞ < 2 < 5 ✓
      return True
    
    validate(7, 5, 10)
      5 < 7 < 10 ✓
      return True
    
    return True
  
  validate(15, 10, +∞)
    10 < 15 < +∞ ✓
    
    validate(12, 10, 15)
      10 < 12 < 15 ✓
      return True
    
    validate(20, 15, +∞)
      15 < 20 < +∞ ✓
      return True
    
    return True
  
  return True

Result: True ✓
```

### Algorithm Logic

**Recursive Function Signature:**
```python
def isValid(node, min_val, max_val):
    """
    Check if subtree rooted at node is valid BST
    
    Args:
        node: Current tree node
        min_val: Minimum allowed value (exclusive)
        max_val: Maximum allowed value (exclusive)
    
    Returns:
        True if valid BST, False otherwise
    """
```

**Base Case:**
```python
if not node:
    return True  # Empty tree is valid BST
```

**Validation Check:**
```python
if not (min_val < node.val < max_val):
    return False  # Current node violates range
```

**Recursive Cases:**
```python
# Left subtree: all values must be < node.val
left_valid = isValid(node.left, min_val, node.val)

# Right subtree: all values must be > node.val
right_valid = isValid(node.right, node.val, max_val)

return left_valid and right_valid
```

### Detailed Walkthrough

**Example: root = [5,3,7,2,4,6,8]**

```
Tree Structure:
       5
      / \
     3   7
    / \ / \
   2  4 6  8

Call Stack Trace:

Call 1: isValid(5, -∞, +∞)
  Check: -∞ < 5 < +∞ ✓
  
  Call 2: isValid(3, -∞, 5)
    Check: -∞ < 3 < 5 ✓
    
    Call 3: isValid(2, -∞, 3)
      Check: -∞ < 2 < 3 ✓
      
      Call 4: isValid(None, -∞, 2)
        return True
      
      Call 5: isValid(None, 2, 3)
        return True
      
      return True
    
    Call 6: isValid(4, 3, 5)
      Check: 3 < 4 < 5 ✓
      
      Call 7: isValid(None, 3, 4)
        return True
      
      Call 8: isValid(None, 4, 5)
        return True
      
      return True
    
    return True
  
  Call 9: isValid(7, 5, +∞)
    Check: 5 < 7 < +∞ ✓
    
    Call 10: isValid(6, 5, 7)
      Check: 5 < 6 < 7 ✓
      
      Call 11: isValid(None, 5, 6)
        return True
      
      Call 12: isValid(None, 6, 7)
        return True
      
      return True
    
    Call 13: isValid(8, 7, +∞)
      Check: 7 < 8 < +∞ ✓
      
      Call 14: isValid(None, 7, 8)
        return True
      
      Call 15: isValid(None, 8, +∞)
        return True
      
      return True
    
    return True
  
  return True

Final Result: True ✓
```

### Complete Implementation

```python
from typing import Optional

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        """
        Validate if binary tree is a valid BST
        
        Args:
            root: Root of binary tree
        
        Returns:
            True if valid BST, False otherwise
        """
        def isValid(node, min_val=float('-inf'), max_val=float('inf')):
            """
            Helper function to validate BST with range constraints
            
            Args:
                node: Current node
                min_val: Minimum allowed value (exclusive)
                max_val: Maximum allowed value (exclusive)
            
            Returns:
                True if subtree is valid BST
            """
            # Base case: empty tree is valid
            if not node:
                return True
            
            # Check if current node violates range constraint
            if not (min_val < node.val < max_val):
                return False
            
            # Recursively validate left and right subtrees
            # Left subtree: all values must be in range (min_val, node.val)
            # Right subtree: all values must be in range (node.val, max_val)
            return (isValid(node.left, min_val, node.val) and
                    isValid(node.right, node.val, max_val))
        
        return isValid(root)
```

### Alternative Implementation

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        return self._validate(root, float('-inf'), float('inf'))
    
    def _validate(self, node, minimum, maximum):
        """Separate helper method for clarity"""
        if not node:
            return True
        
        # Check current node
        if node.val <= minimum or node.val >= maximum:
            return False
        
        # Validate subtrees
        left_valid = self._validate(node.left, minimum, node.val)
        right_valid = self._validate(node.right, node.val, maximum)
        
        return left_valid and right_valid
```

### Why This Works

**1. Range Propagation:**
```
As we traverse down:
- Left child inherits parent's min, gets parent's value as max
- Right child inherits parent's max, gets parent's value as min

This ensures global BST property:
       10 (range: -∞, +∞)
      /  \
     5    15
  (-∞,10) (10,+∞)
    / \    / \
   2   7  12  20
(-∞,5)(5,10)(10,15)(15,+∞)

Each node's range reflects ALL ancestor constraints
```

**2. The Strict Inequality:**
```python
if not (min_val < node.val < max_val):
    return False
```

**Why strict (<, >) not (≤, ≥)?**
- BST requires STRICTLY less/greater
- No duplicate values allowed in standard BST
- If node.val == min_val or node.val == max_val, it's invalid

**3. Short-Circuit Evaluation:**
```python
return (isValid(node.left, min_val, node.val) and
        isValid(node.right, node.val, max_val))
```

**Why this is efficient:**
- If left subtree is invalid, right subtree is not checked
- Fails fast on first violation
- Saves unnecessary recursive calls

**4. Base Case Simplicity:**
```python
if not node:
    return True
```

**Why empty tree is valid:**
- Empty tree satisfies BST property vacuously
- No nodes to violate constraints
- Allows clean recursion without null checks

### Complexity Analysis

**Time Complexity: O(n)**
- n = number of nodes in the tree
- Visit each node exactly once
- Each visit: O(1) operations (comparison, recursive calls)
- Total: O(n)

**Space Complexity: O(h)**
- h = height of the tree
- Recursion call stack depth = height
- Each call: O(1) space (parameters, local variables)
- Best case (balanced tree): O(log n)
- Worst case (skewed tree): O(n)

**Space Breakdown:**
```
Balanced Tree:
       10
      /  \
     5    15
    / \   / \
   2   7 12  20

Height = 3
Max call stack depth = 3
Space = O(log n)

Skewed Tree:
   1
    \
     2
      \
       3
        \
         4

Height = 4
Max call stack depth = 4
Space = O(n)
```

### Critical Insights

**1. Why float('-inf') and float('inf'):**
```python
min_val = float('-inf')
max_val = float('inf')
```

**Reasoning:**
- Node values can be any integer in range [-2^31, 2^31-1]
- Need bounds that are outside this range
- float('-inf') < any integer
- float('inf') > any integer
- Ensures root node always passes initial check

**2. Order of Recursive Calls Doesn't Matter:**
```python
# Both are equivalent
return (isValid(node.left, ...) and isValid(node.right, ...))
return (isValid(node.right, ...) and isValid(node.left, ...))
```

**Why:**
- Both subtrees must be valid
- AND operation is commutative
- Short-circuit happens on first False regardless

**3. The Range Tightens:**
```
As we go deeper, the valid range gets narrower:

Level 0: (-∞, +∞)          [full range]
Level 1: (-∞, 10) or (10, +∞)  [half range]
Level 2: (-∞, 5) or (5, 10) or (10, 15) or (15, +∞)  [quarter range]

This reflects the increasing constraints from ancestors
```

**4. Single Comparison Checks Both Bounds:**
```python
if not (min_val < node.val < max_val):
    return False

# Equivalent to:
if node.val <= min_val or node.val >= max_val:
    return False

# First form is more concise and readable
```

---

*Continue to next 500 lines...*

### Common Mistakes

❌ **Mistake 1: Only checking immediate children**
```python
# Wrong
def isValidBST(root):
    if not root:
        return True
    if root.left and root.left.val >= root.val:
        return False
    if root.right and root.right.val <= root.val:
        return False
    return isValidBST(root.left) and isValidBST(root.right)
```

✓ **Correct:**
```python
def isValidBST(root):
    def isValid(node, min_val, max_val):
        if not node:
            return True
        if not (min_val < node.val < max_val):
            return False
        return (isValid(node.left, min_val, node.val) and
                isValid(node.right, node.val, max_val))
    return isValid(root, float('-inf'), float('inf'))
```

❌ **Mistake 2: Using ≤ and ≥ instead of < and >**
```python
# Wrong: allows duplicates
if min_val <= node.val <= max_val:
    # Process node
```

✓ **Correct:**
```python
if min_val < node.val < max_val:
    # Process node
```

❌ **Mistake 3: Not using infinity for initial bounds**
```python
# Wrong: what if root value is None or at boundary?
def isValidBST(root):
    return isValid(root, None, None)
```

✓ **Correct:**
```python
def isValidBST(root):
    return isValid(root, float('-inf'), float('inf'))
```

❌ **Mistake 4: Updating wrong bound**
```python
# Wrong: both calls use node.val as min
return (isValid(node.left, node.val, max_val) and
        isValid(node.right, node.val, max_val))
```

✓ **Correct:**
```python
return (isValid(node.left, min_val, node.val) and
        isValid(node.right, node.val, max_val))
```

### Edge Cases

**1. Empty Tree:**
```python
root = None
Output: True

Execution:
  isValid(None, -∞, +∞)
    return True
```

**2. Single Node:**
```python
root = TreeNode(5)
Output: True

Execution:
  isValid(5, -∞, +∞)
    -∞ < 5 < +∞ ✓
    isValid(None, -∞, 5) → True
    isValid(None, 5, +∞) → True
    return True
```

**3. Two Nodes (Valid):**
```python
    5
   /
  3

Output: True

Execution:
  isValid(5, -∞, +∞)
    -∞ < 5 < +∞ ✓
    isValid(3, -∞, 5)
      -∞ < 3 < 5 ✓
      return True
    return True
```

**4. Two Nodes (Invalid):**
```python
    5
   /
  7

Output: False

Execution:
  isValid(5, -∞, +∞)
    -∞ < 5 < +∞ ✓
    isValid(7, -∞, 5)
      -∞ < 7 < 5 ✗
      return False
    return False
```

**5. Boundary Values:**
```python
    0
   / \
 -1   1

Output: True

All values within integer range
```

**6. Duplicate Values:**
```python
    5
   / \
  5   5

Output: False

5 is not strictly less than 5
5 is not strictly greater than 5
```

---

## Approach 2: Inorder Traversal ⭐⭐⭐

### Strategy

Use the property that **inorder traversal of a BST produces a sorted sequence**:
1. Perform inorder traversal (left → root → right)
2. Track the previous node value
3. Check if current value > previous value
4. If any value ≤ previous, it's invalid

### Key Insight

**BST Property:**
```
Inorder traversal of valid BST = sorted ascending sequence

Valid BST:
       5
      / \
     3   7
    / \
   2   4

Inorder: 2 → 3 → 4 → 5 → 7
Sorted? Yes ✓

Invalid BST:
       5
      / \
     3   7
    / \
   2   6

Inorder: 2 → 3 → 6 → 5 → 7
Sorted? No (6 > 5) ✗
```

### Visual Flow

**Example: root = [5,3,7,2,4,6,8]**

```
Tree Structure:
       5
      / \
     3   7
    / \ / \
   2  4 6  8

Inorder Traversal:

Step 1: Visit 2
  prev = None
  current = 2
  None < 2 ✓
  prev = 2

Step 2: Visit 3
  prev = 2
  current = 3
  2 < 3 ✓
  prev = 3

Step 3: Visit 4
  prev = 3
  current = 4
  3 < 4 ✓
  prev = 4

Step 4: Visit 5
  prev = 4
  current = 5
  4 < 5 ✓
  prev = 5

Step 5: Visit 6
  prev = 5
  current = 6
  5 < 6 ✓
  prev = 6

Step 6: Visit 7
  prev = 6
  current = 7
  6 < 7 ✓
  prev = 7

Step 7: Visit 8
  prev = 7
  current = 8
  7 < 8 ✓
  prev = 8

All comparisons pass ✓
Result: True
```

**Example: Invalid BST**

```
Tree Structure:
       5
      / \
     3   7
    / \
   2   6

Inorder Traversal:

Step 1: Visit 2
  prev = None
  current = 2
  prev = 2

Step 2: Visit 3
  prev = 2
  current = 3
  2 < 3 ✓
  prev = 3

Step 3: Visit 6
  prev = 3
  current = 6
  3 < 6 ✓
  prev = 6

Step 4: Visit 5
  prev = 6
  current = 5
  6 < 5 ✗
  
  Return False immediately

Result: False ✗
```

### Algorithm Logic

**Approach 1: Recursive with Previous Tracking**

```python
def isValidBST(root):
    prev = [None]  # Use list to allow modification in nested function
    
    def inorder(node):
        if not node:
            return True
        
        # Visit left subtree
        if not inorder(node.left):
            return False
        
        # Check current node
        if prev[0] is not None and node.val <= prev[0]:
            return False
        prev[0] = node.val
        
        # Visit right subtree
        return inorder(node.right)
    
    return inorder(root)
```

**Approach 2: Iterative with Stack**

```python
def isValidBST(root):
    stack = []
    prev = None
    current = root
    
    while stack or current:
        # Go to leftmost node
        while current:
            stack.append(current)
            current = current.left
        
        # Process node
        current = stack.pop()
        
        # Check if sorted
        if prev is not None and current.val <= prev:
            return False
        prev = current.val
        
        # Go to right subtree
        current = current.right
    
    return True
```

**Approach 3: Store All Values Then Check**

```python
def isValidBST(root):
    values = []
    
    def inorder(node):
        if not node:
            return
        inorder(node.left)
        values.append(node.val)
        inorder(node.right)
    
    inorder(root)
    
    # Check if sorted
    for i in range(1, len(values)):
        if values[i] <= values[i-1]:
            return False
    
    return True
```

### Complete Implementation (Recursive)

```python
from typing import Optional

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        """
        Validate BST using inorder traversal
        
        Inorder traversal of BST produces sorted sequence
        Check if each value is strictly greater than previous
        """
        self.prev = None  # Track previous node value
        
        def inorder(node):
            """Inorder traversal with validation"""
            if not node:
                return True
            
            # Visit left subtree
            if not inorder(node.left):
                return False
            
            # Check current node against previous
            if self.prev is not None and node.val <= self.prev:
                return False
            
            # Update previous value
            self.prev = node.val
            
            # Visit right subtree
            return inorder(node.right)
        
        return inorder(root)
```

### Complete Implementation (Iterative)

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        """
        Validate BST using iterative inorder traversal
        """
        stack = []
        prev = None
        current = root
        
        while stack or current:
            # Traverse to leftmost node
            while current:
                stack.append(current)
                current = current.left
            
            # Process current node
            current = stack.pop()
            
            # Validate: current should be > previous
            if prev is not None and current.val <= prev:
                return False
            
            # Update previous
            prev = current.val
            
            # Move to right subtree
            current = current.right
        
        return True
```

### Why This Works

**1. Inorder Property:**
```
For any BST:
  Inorder traversal visits nodes in ascending order
  
Proof:
  - Visit left subtree first (all values < root)
  - Visit root
  - Visit right subtree last (all values > root)
  - Recursively applies to all subtrees
  
Therefore:
  If inorder produces sorted sequence → Valid BST
  If inorder produces unsorted sequence → Invalid BST
```

**2. Early Termination:**
```python
if not inorder(node.left):
    return False
```

**Why this is efficient:**
- Stop as soon as we find violation
- Don't need to traverse entire tree
- Fails fast on first invalid node

**3. Previous Value Tracking:**
```python
if self.prev is not None and node.val <= self.prev:
    return False
self.prev = node.val
```

**Why this works:**
- In inorder, we visit nodes in sorted order
- Each node should be > previous node
- If not, BST property is violated

**4. None Check for First Node:**
```python
if self.prev is not None and node.val <= self.prev:
```

**Why check for None:**
- First node has no previous value
- Can't compare with None
- Skip check for first node

### Complexity Analysis

**Time Complexity: O(n)**
- n = number of nodes
- Visit each node exactly once in inorder traversal
- Each visit: O(1) operations
- Total: O(n)

**Space Complexity:**
- **Recursive:** O(h) - recursion stack
- **Iterative:** O(h) - explicit stack
- **Store all values:** O(n) - values array
- h = height of tree
- Best case: O(log n) for balanced tree
- Worst case: O(n) for skewed tree

### Critical Insights

**1. Why Inorder Specifically:**
```
Preorder: Root → Left → Right
  Doesn't produce sorted sequence

Postorder: Left → Right → Root
  Doesn't produce sorted sequence

Inorder: Left → Root → Right
  Produces sorted sequence for BST ✓
```

**2. Strict Inequality:**
```python
if current.val <= prev:  # Not just <
    return False
```

**Why ≤ not just <:**
- BST doesn't allow duplicates
- If current == prev, it's invalid
- Must be strictly increasing

**3. Using self.prev vs Parameter:**
```python
# Using instance variable
self.prev = None

def inorder(node):
    if self.prev is not None and node.val <= self.prev:
        return False
    self.prev = node.val

# vs using parameter (more complex)
def inorder(node, prev):
    # Need to return both result and new prev
    # More complex to handle
```

**4. Iterative vs Recursive:**
```
Recursive:
  + Cleaner code
  + Easier to understand
  - Recursion overhead
  - Stack overflow risk

Iterative:
  + No recursion overhead
  + No stack overflow
  - More complex code
  - Need explicit stack
```

### Common Mistakes

❌ **Mistake 1: Not handling first node**
```python
# Wrong: crashes on first node
if node.val <= self.prev:
    return False
```

✓ **Correct:**
```python
if self.prev is not None and node.val <= self.prev:
    return False
```

❌ **Mistake 2: Using < instead of ≤**
```python
# Wrong: allows duplicates
if node.val < self.prev:
    return False
```

✓ **Correct:**
```python
if node.val <= self.prev:
    return False
```

❌ **Mistake 3: Wrong traversal order**
```python
# Wrong: preorder traversal
def traverse(node):
    if not node:
        return True
    # Check current first (wrong order)
    if self.prev is not None and node.val <= self.prev:
        return False
    self.prev = node.val
    return traverse(node.left) and traverse(node.right)
```

✓ **Correct:**
```python
def inorder(node):
    if not node:
        return True
    # Left first, then current, then right
    if not inorder(node.left):
        return False
    if self.prev is not None and node.val <= self.prev:
        return False
    self.prev = node.val
    return inorder(node.right)
```

❌ **Mistake 4: Forgetting to update prev**
```python
# Wrong: prev never updates
if self.prev is not None and node.val <= self.prev:
    return False
# Missing: self.prev = node.val
```

✓ **Correct:**
```python
if self.prev is not None and node.val <= self.prev:
    return False
self.prev = node.val  # Update!
```

### Edge Cases

**1. Empty Tree:**
```python
root = None
Output: True

Inorder: (empty)
Sorted? Yes (vacuously true)
```

**2. Single Node:**
```python
root = TreeNode(5)
Output: True

Inorder: 5
Sorted? Yes
```

**3. All Same Values:**
```python
    5
   / \
  5   5

Inorder: 5, 5, 5
Sorted? No (not strictly increasing)
Output: False
```

**4. Negative Values:**
```python
     0
    / \
  -5   5

Inorder: -5, 0, 5
Sorted? Yes
Output: True
```

**5. Large Tree:**
```python
         10
        /  \
       5    15
      / \   / \
     2   7 12  20

Inorder: 2, 5, 7, 10, 12, 15, 20
Sorted? Yes
Output: True
```

---

## Approach Comparison

### Range Validation vs Inorder Traversal

| Aspect | Range Validation | Inorder Traversal |
|--------|------------------|-------------------|
| **Time** | O(n) | O(n) |
| **Space** | O(h) | O(h) recursive, O(n) if storing |
| **Code** | Shorter | Slightly longer |
| **Intuition** | Less intuitive | More intuitive |
| **Early Exit** | Yes | Yes |
| **Clarity** | Direct validation | Indirect (via sorting) |

### Detailed Comparison

**Range Validation:**
```python
Pros:
+ Direct validation of BST property
+ Shorter code
+ Clear logic (check bounds)
+ No need to track previous value

Cons:
- Less intuitive (why pass bounds?)
- Harder to explain
- Need to understand range propagation

Best for:
- Interviews (shows understanding)
- When clarity of BST property is important
- When you want direct validation
```

**Inorder Traversal:**
```python
Pros:
+ More intuitive (check if sorted)
+ Leverages BST property
+ Easy to explain
+ Can be iterative (no recursion)

Cons:
- Indirect validation
- Need to track previous value
- Slightly more code
- Need to understand inorder traversal

Best for:
- When you know inorder property
- When iterative solution is preferred
- When explaining to beginners
```

### Space Complexity Deep Dive

**Range Validation:**
```
Space = O(h) for recursion stack

Balanced tree:
       10
      /  \
     5    15
    / \   / \
   2   7 12  20

Max depth = 3
Space = O(log n)

Skewed tree:
   1
    \
     2
      \
       3
        \
         4

Max depth = 4
Space = O(n)
```

**Inorder Traversal (Recursive):**
```
Space = O(h) for recursion stack

Same as range validation
```

**Inorder Traversal (Iterative):**
```
Space = O(h) for explicit stack

Same space complexity
But no recursion overhead
```

**Inorder with Storage:**
```
Space = O(n) for values array + O(h) for stack

Worst space complexity
Not recommended
```

### When to Use Each Approach

**Use Range Validation When:**
- ✓ Want direct BST validation
- ✓ Prefer shorter code
- ✓ In interviews (shows understanding)
- ✓ Need to explain BST property clearly

**Use Inorder Traversal When:**
- ✓ More comfortable with inorder
- ✓ Want iterative solution
- ✓ Explaining to beginners
- ✓ Leveraging sorted property

**Interview Recommendation:**
```
1. Start with Range Validation
   - Shows understanding of BST property
   - More direct approach
   - Cleaner code

2. Mention Inorder Alternative
   - "Could also use inorder traversal"
   - "Check if sequence is sorted"
   - Shows breadth of knowledge

3. Discuss Trade-offs
   - Both O(n) time
   - Both O(h) space
   - Range validation more direct
```

---

*Continue to next section...*

## Alternative Approaches

### Approach 3: Morris Traversal (O(1) Space)

**Idea:** Inorder traversal without recursion or stack

```python
def isValidBST(self, root: Optional[TreeNode]) -> bool:
    """
    Morris traversal for O(1) space complexity
    """
    prev = None
    current = root
    
    while current:
        if not current.left:
            # No left child, process current
            if prev is not None and current.val <= prev:
                return False
            prev = current.val
            current = current.right
        else:
            # Find inorder predecessor
            predecessor = current.left
            while predecessor.right and predecessor.right != current:
                predecessor = predecessor.right
            
            if not predecessor.right:
                # Create thread
                predecessor.right = current
                current = current.left
            else:
                # Remove thread
                predecessor.right = None
                if prev is not None and current.val <= prev:
                    return False
                prev = current.val
                current = current.right
    
    return True
```

**Pros:**
- O(1) space (no stack or recursion)
- Still O(n) time

**Cons:**
- Complex code
- Modifies tree temporarily
- Hard to understand
- Not recommended for interviews

### Approach 4: Level Order with Range

**Idea:** BFS with range validation

```python
from collections import deque

def isValidBST(self, root: Optional[TreeNode]) -> bool:
    """
    BFS with range validation
    """
    if not root:
        return True
    
    queue = deque([(root, float('-inf'), float('inf'))])
    
    while queue:
        node, min_val, max_val = queue.popleft()
        
        if not (min_val < node.val < max_val):
            return False
        
        if node.left:
            queue.append((node.left, min_val, node.val))
        if node.right:
            queue.append((node.right, node.val, max_val))
    
    return True
```

**Pros:**
- Iterative (no recursion)
- Clear logic
- Level by level validation

**Cons:**
- More space (queue can be O(n))
- More complex than DFS
- No real advantage over DFS

---

## Pattern Recognition

### When to Recognize This Pattern

**Problem Characteristics:**
```
✓ Binary tree validation
✓ Check structural property
✓ Need to validate global constraint
✓ Local checks are insufficient
✓ Ancestor information matters
```

**Key Indicators:**
- "Validate binary search tree"
- "Check if BST is valid"
- "Verify BST property"
- "Is this a valid BST?"
- "All nodes in left < root < all nodes in right"

### Similar Problems

**1. Validate Binary Tree (General)**
```
Problem: Check if tree structure is valid

Solution: Check basic properties
  - No cycles
  - Each node has at most 2 children
  - Parent-child relationships correct

Simpler than BST validation
```

**2. Kth Smallest Element in BST (LeetCode #230)**
```
Problem: Find kth smallest element in BST

Solution: Inorder traversal
  - Inorder gives sorted sequence
  - Return kth element

Uses same inorder property as BST validation
```

**3. Recover Binary Search Tree (LeetCode #99)**
```
Problem: Two nodes swapped, fix the BST

Solution: Inorder traversal
  - Find two nodes that break sorted order
  - Swap them back

Extends BST validation concept
```

**4. Convert Sorted Array to BST (LeetCode #108)**
```
Problem: Build balanced BST from sorted array

Solution: Recursive middle element
  - Middle element becomes root
  - Left half → left subtree
  - Right half → right subtree

Inverse of BST validation
```

**5. Lowest Common Ancestor of BST (LeetCode #235)**
```
Problem: Find LCA in BST

Solution: Use BST property
  - If both nodes < root, go left
  - If both nodes > root, go right
  - Otherwise, root is LCA

Leverages BST ordering property
```

**6. Serialize and Deserialize BST (LeetCode #449)**
```
Problem: Convert BST to string and back

Solution: Preorder traversal
  - Use BST property to reconstruct
  - No need for null markers

Uses BST property for reconstruction
```

### Pattern Template

**Generic BST Validation Template:**

```python
def validateBST(root):
    """
    Template for BST validation problems
    """
    # Approach 1: Range validation
    def validate_range(node, min_val, max_val):
        if not node:
            return True
        
        if not (min_val < node.val < max_val):
            return False
        
        return (validate_range(node.left, min_val, node.val) and
                validate_range(node.right, node.val, max_val))
    
    return validate_range(root, float('-inf'), float('inf'))
    
    # Approach 2: Inorder traversal
    prev = [None]
    
    def validate_inorder(node):
        if not node:
            return True
        
        if not validate_inorder(node.left):
            return False
        
        if prev[0] is not None and node.val <= prev[0]:
            return False
        prev[0] = node.val
        
        return validate_inorder(node.right)
    
    return validate_inorder(root)
```

**BST Property Checking Template:**

```python
def checkBSTProperty(root):
    """
    Generic template for checking BST properties
    """
    def helper(node, min_val, max_val):
        if not node:
            return True  # or appropriate base case
        
        # Check current node property
        if not (min_val < node.val < max_val):
            return False
        
        # Recursively check subtrees with updated bounds
        left_valid = helper(node.left, min_val, node.val)
        right_valid = helper(node.right, node.val, max_val)
        
        return left_valid and right_valid
    
    return helper(root, float('-inf'), float('inf'))
```

---

## Related Concepts

### 1. Binary Search Tree Properties

**Definition:**
```
BST is a binary tree where:
  - Left subtree contains only nodes < root
  - Right subtree contains only nodes > root
  - Both subtrees are also BSTs
  - No duplicate values (standard definition)
```

**Key Properties:**
```
1. Inorder traversal produces sorted sequence
2. Search operation is O(log n) for balanced BST
3. Min value is leftmost node
4. Max value is rightmost node
5. Successor is next node in inorder
6. Predecessor is previous node in inorder
```

### 2. Tree Traversal Methods

**Inorder (Left → Root → Right):**
```python
def inorder(node):
    if not node:
        return
    inorder(node.left)
    process(node)
    inorder(node.right)

# For BST: produces sorted sequence
```

**Preorder (Root → Left → Right):**
```python
def preorder(node):
    if not node:
        return
    process(node)
    preorder(node.left)
    preorder(node.right)

# For BST: useful for serialization
```

**Postorder (Left → Right → Root):**
```python
def postorder(node):
    if not node:
        return
    postorder(node.left)
    postorder(node.right)
    process(node)

# For BST: useful for deletion
```

### 3. Range Constraint Propagation

**How Constraints Propagate:**
```
       10 (range: -∞, +∞)
      /  \
     5    15
  (-∞,10) (10,+∞)
    / \    / \
   2   7  12  20
(-∞,5)(5,10)(10,15)(15,+∞)

Pattern:
  Left child: (parent_min, parent_val)
  Right child: (parent_val, parent_max)
```

**Why This Works:**
```
For node N with range (min, max):
  - N must be in range (min, max)
  - All left descendants must be < N
  - All right descendants must be > N
  
By propagating ranges:
  - Left child gets max = N.val
  - Right child gets min = N.val
  - Ensures global BST property
```

### 4. Recursion vs Iteration

**Recursive Approach:**
```python
Pros:
+ Clean code
+ Natural for trees
+ Easy to understand

Cons:
- Stack overflow risk
- Recursion overhead
- Harder to debug

When to use:
- Tree problems
- Divide and conquer
- When depth is reasonable
```

**Iterative Approach:**
```python
Pros:
+ No stack overflow
+ More control
+ Can be more efficient

Cons:
- More complex code
- Need explicit stack
- Harder to write

When to use:
- Deep trees
- Need to avoid recursion
- Performance critical
```

---

## Common Mistakes & How to Avoid

### Mistake 1: Only Checking Immediate Children

**Wrong Understanding:**
```
"Just check if left child < root and right child > root"
```

**Why It's Wrong:**
```
Example:
       10
      /  \
     5    15
         / \
        6   20

Immediate checks:
  5 < 10 ✓
  15 > 10 ✓
  6 < 15 ✓
  20 > 15 ✓

All pass! But 6 < 10, and 6 is in right subtree of 10 ✗
```

**How to Avoid:**
- Remember: ALL nodes in left < root
- Remember: ALL nodes in right > root
- Use range constraints
- Test with deeper trees

### Mistake 2: Allowing Duplicates

**Wrong:**
```python
if node.val < max_val and node.val > min_val:
    # Process
```

**Why It's Wrong:**
```
Standard BST doesn't allow duplicates
If node.val == max_val or node.val == min_val, it's invalid
```

**How to Avoid:**
- Use strict inequalities (< and >)
- Remember: no duplicates in BST
- Test with duplicate values

### Mistake 3: Not Using Infinity

**Wrong:**
```python
def isValidBST(root):
    return validate(root, None, None)
```

**Why It's Wrong:**
```
What if root value is None?
What if root value is at integer boundary?
Can't compare with None properly
```

**How to Avoid:**
- Use float('-inf') and float('inf')
- These are outside integer range
- Ensures root always passes initial check

### Mistake 4: Wrong Bound Updates

**Wrong:**
```python
# Both use node.val as min
validate(node.left, node.val, max_val)
validate(node.right, node.val, max_val)
```

**Why It's Wrong:**
```
Left child should inherit parent's min
Right child should inherit parent's max
Wrong bounds lead to incorrect validation
```

**How to Avoid:**
- Left: (min, node.val)
- Right: (node.val, max)
- Draw diagram to visualize
- Test with examples

### Mistake 5: Inorder Without Prev Check

**Wrong:**
```python
if node.val <= self.prev:  # Crashes on first node
    return False
```

**Why It's Wrong:**
```
First node has no previous value
self.prev is None initially
Can't compare integer with None
```

**How to Avoid:**
- Check if prev is not None first
- Handle first node specially
- Initialize prev properly

---

## Optimization Techniques

### 1. Early Termination

**Already Optimal:**
```python
# Both approaches already terminate early
if not (min_val < node.val < max_val):
    return False  # Stop immediately

if not inorder(node.left):
    return False  # Stop if left invalid
```

### 2. Iterative to Avoid Recursion

**For Deep Trees:**
```python
# Use iterative inorder or BFS
# Avoids stack overflow
# More control over execution
```

### 3. Space Optimization

**Morris Traversal:**
```python
# O(1) space instead of O(h)
# But complex and not recommended
# Only for extreme space constraints
```

### 4. Caching Results

**Not Applicable:**
```
Each node checked once
No repeated subproblems
Caching doesn't help
```

---

## Test Cases & Edge Cases

### Comprehensive Test Suite

```python
def test_isValidBST():
    sol = Solution()
    
    # Test 1: Empty tree
    root = None
    assert sol.isValidBST(root) == True
    print("✓ Test 1: Empty tree")
    
    # Test 2: Single node
    root = TreeNode(5)
    assert sol.isValidBST(root) == True
    print("✓ Test 2: Single node")
    
    # Test 3: Valid BST
    root = TreeNode(5)
    root.left = TreeNode(3)
    root.right = TreeNode(7)
    root.left.left = TreeNode(2)
    root.left.right = TreeNode(4)
    root.right.right = TreeNode(8)
    assert sol.isValidBST(root) == True
    print("✓ Test 3: Valid BST")
    
    # Test 4: Invalid - left child greater
    root = TreeNode(5)
    root.left = TreeNode(6)
    root.right = TreeNode(7)
    assert sol.isValidBST(root) == False
    print("✓ Test 4: Invalid left child")
    
    # Test 5: Invalid - right child smaller
    root = TreeNode(5)
    root.left = TreeNode(3)
    root.right = TreeNode(4)
    assert sol.isValidBST(root) == False
    print("✓ Test 5: Invalid right child")
    
    # Test 6: Invalid - deep violation
    root = TreeNode(10)
    root.left = TreeNode(5)
    root.right = TreeNode(15)
    root.right.left = TreeNode(6)
    root.right.right = TreeNode(20)
    assert sol.isValidBST(root) == False
    print("✓ Test 6: Deep violation")
    
    # Test 7: Duplicate values
    root = TreeNode(5)
    root.left = TreeNode(5)
    assert sol.isValidBST(root) == False
    print("✓ Test 7: Duplicate values")
    
    # Test 8: Negative values
    root = TreeNode(0)
    root.left = TreeNode(-5)
    root.right = TreeNode(5)
    assert sol.isValidBST(root) == True
    print("✓ Test 8: Negative values")
    
    # Test 9: Left subtree only
    root = TreeNode(5)
    root.left = TreeNode(3)
    root.left.left = TreeNode(1)
    assert sol.isValidBST(root) == True
    print("✓ Test 9: Left subtree only")
    
    # Test 10: Right subtree only
    root = TreeNode(5)
    root.right = TreeNode(7)
    root.right.right = TreeNode(9)
    assert sol.isValidBST(root) == True
    print("✓ Test 10: Right subtree only")
    
    # Test 11: Large valid BST
    root = TreeNode(10)
    root.left = TreeNode(5)
    root.right = TreeNode(15)
    root.left.left = TreeNode(2)
    root.left.right = TreeNode(7)
    root.right.left = TreeNode(12)
    root.right.right = TreeNode(20)
    assert sol.isValidBST(root) == True
    print("✓ Test 11: Large valid BST")
    
    # Test 12: Boundary values
    root = TreeNode(2147483647)
    root.left = TreeNode(-2147483648)
    assert sol.isValidBST(root) == True
    print("✓ Test 12: Boundary values")
    
    print("\nAll tests passed! ✓")

# Run tests
test_isValidBST()
```

### Edge Case Categories

**1. Empty/Minimal Trees:**
```python
# Empty
root = None
Output: True

# Single node
root = TreeNode(5)
Output: True

# Two nodes (valid)
root = TreeNode(5)
root.left = TreeNode(3)
Output: True

# Two nodes (invalid)
root = TreeNode(5)
root.left = TreeNode(7)
Output: False
```

**2. Duplicate Values:**
```python
# Left duplicate
    5
   /
  5
Output: False

# Right duplicate
  5
   \
    5
Output: False

# Both duplicates
    5
   / \
  5   5
Output: False
```

**3. Deep Violations:**
```python
# Violation in grandchild
       10
      /  \
     5    15
         / \
        6   20
Output: False (6 < 10)

# Violation in great-grandchild
         20
        /  \
       10   30
      /  \
     5    15
    /
   12
Output: False (12 > 10 but in left subtree)
```

**4. Boundary Values:**
```python
# Max int
root = TreeNode(2147483647)
Output: True

# Min int
root = TreeNode(-2147483648)
Output: True

# Both
    0
   / \
 -2^31 2^31-1
Output: True
```

**5. Skewed Trees:**
```python
# All left
   5
  /
 4
/
3
Output: True

# All right
1
 \
  2
   \
    3
Output: True
```

---

## Day 63 Summary

### Problem: Validate Binary Search Tree

**Difficulty:** Medium 🟡

**Core Concept:** Tree validation with global constraints

**Key Insights:**
1. BST property is **global**, not just local
2. ALL nodes in left subtree < root < ALL nodes in right subtree
3. Two main approaches: **Range validation** and **Inorder traversal**
4. Range validation: Pass min/max bounds down the tree
5. Inorder traversal: Check if sequence is sorted

**Two Main Approaches:**

| Approach | Time | Space | Difficulty | Best For |
|----------|------|-------|------------|----------|
| Range Validation | O(n) | O(h) | ⭐⭐⭐ | Direct validation, interviews |
| Inorder Traversal | O(n) | O(h) | ⭐⭐⭐ | Intuitive, leverages BST property |

**Pattern Recognition:**
- Binary tree validation
- Global constraint checking
- Range constraint propagation
- Inorder traversal property

**Related Problems:**
- Kth Smallest Element in BST (LeetCode #230)
- Recover Binary Search Tree (LeetCode #99)
- Convert Sorted Array to BST (LeetCode #108)
- Lowest Common Ancestor of BST (LeetCode #235)
- Serialize and Deserialize BST (LeetCode #449)

**Common Mistakes:**
1. Only checking immediate children
2. Allowing duplicates (using ≤ instead of <)
3. Not using infinity for initial bounds
4. Wrong bound updates in recursion
5. Not handling first node in inorder

**Key Takeaways:**
- ⭐ BST property must hold for ALL nodes, not just immediate children
- ⭐ Range validation: propagate min/max bounds down tree
- ⭐ Inorder traversal of BST produces sorted sequence
- ⭐ Use strict inequalities (< and >) to disallow duplicates
- ⭐ Both approaches are O(n) time, O(h) space

**Interview Tips:**
1. Start with range validation (more direct)
2. Explain why checking immediate children fails
3. Show example of deep violation
4. Mention inorder alternative
5. Discuss trade-offs between approaches
6. Test with edge cases (empty, duplicates, deep violations)

**Time Spent:** Understanding BST property (10 min) + Range validation (15 min) + Inorder approach (15 min) + Testing (10 min) = ~50 min

**Difficulty Rating:** 6/10
- Concept is tricky (global vs local)
- Multiple approaches available
- Easy to make mistakes
- But straightforward once understood

---

## Quick Reference

### Range Validation Template

```python
def isValidBST(self, root: Optional[TreeNode]) -> bool:
    def validate(node, min_val, max_val):
        if not node:
            return True
        
        if not (min_val < node.val < max_val):
            return False
        
        return (validate(node.left, min_val, node.val) and
                validate(node.right, node.val, max_val))
    
    return validate(root, float('-inf'), float('inf'))
```

### Inorder Traversal Template (Recursive)

```python
def isValidBST(self, root: Optional[TreeNode]) -> bool:
    self.prev = None
    
    def inorder(node):
        if not node:
            return True
        
        if not inorder(node.left):
            return False
        
        if self.prev is not None and node.val <= self.prev:
            return False
        self.prev = node.val
        
        return inorder(node.right)
    
    return inorder(root)
```

### Inorder Traversal Template (Iterative)

```python
def isValidBST(self, root: Optional[TreeNode]) -> bool:
    stack = []
    prev = None
    current = root
    
    while stack or current:
        while current:
            stack.append(current)
            current = current.left
        
        current = stack.pop()
        
        if prev is not None and current.val <= prev:
            return False
        prev = current.val
        
        current = current.right
    
    return True
```

### Key Patterns

**Range Propagation:**
```python
# Left child: inherit min, use parent as max
validate(node.left, min_val, node.val)

# Right child: use parent as min, inherit max
validate(node.right, node.val, max_val)
```

**Inorder Check:**
```python
# Check if strictly increasing
if prev is not None and current.val <= prev:
    return False
prev = current.val
```

### Complexity Cheat Sheet

```
Both Approaches:
  Time: O(n) - visit each node once
  Space: O(h) - recursion/stack depth

Where:
  n = number of nodes
  h = height of tree

Best case: O(log n) space (balanced tree)
Worst case: O(n) space (skewed tree)
```

### Decision Tree

```
Choose Range Validation when:
  ✓ Want direct BST validation
  ✓ Prefer shorter code
  ✓ In interviews
  ✓ Need to explain BST property

Choose Inorder Traversal when:
  ✓ More comfortable with inorder
  ✓ Want iterative solution
  ✓ Leveraging sorted property
  ✓ Explaining to beginners
```

---

**End of Day 63 Notes**

*Master this problem and you'll understand:*
- *BST validation with global constraints*
- *Range constraint propagation*
- *Inorder traversal properties*
- *Recursive vs iterative tree traversal*
- *Common pitfalls in tree validation*
