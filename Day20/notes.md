# Day 20: Doubly Linked List, LRU Cache & Binary Tree Depth

## Problem 1: Doubly Linked List Implementation

### Problem Logic
Implement a doubly linked list with bidirectional traversal capability. Each node has both `next` and `prev` pointers, allowing forward and backward navigation.

### Key Operations
1. **Insert at Beginning**: Add node before current head
2. **Insert at End**: Add node after last node
3. **Delete Node**: Remove node by value
4. **Display Forward**: Traverse using `next` pointers
5. **Display Backward**: Traverse using `prev` pointers

### Pseudocode
```
class DNode:
    data, next, prev

class DoublyLinkedList:
    head = None
    
    INSERT_AT_BEGINNING(data):
        new_node = DNode(data)
        if head exists:
            new_node.next = head
            head.prev = new_node
        head = new_node
    
    INSERT_AT_END(data):
        new_node = DNode(data)
        if head is None:
            head = new_node
            return
        
        current = head
        while current.next exists:
            current = current.next
        
        current.next = new_node
        new_node.prev = current
    
    DELETE_NODE(value):
        current = head
        while current exists:
            if current.data == value:
                if current.prev exists:
                    current.prev.next = current.next
                else:
                    head = current.next
                
                if current.next exists:
                    current.next.prev = current.prev
                return
            current = current.next
```

### Visual Flow
```
Insert at Beginning (data=0):
Before: 1 <-> 2 <-> 3
After:  0 <-> 1 <-> 2 <-> 3
        ↑
       head

Insert at End (data=4):
Before: 0 <-> 1 <-> 2 <-> 3
After:  0 <-> 1 <-> 2 <-> 3 <-> 4

Delete Node (value=2):
Before: 0 <-> 1 <-> 2 <-> 3 <-> 4
                ↓
        1.next = 3, 3.prev = 1
After:  0 <-> 1 <-> 3 <-> 4
```

### Critical Rules
1. **Always update BOTH pointers**: When inserting/deleting, update both `next` and `prev`
2. **Handle head separately**: Deleting head requires updating head pointer
3. **Check for None**: Always verify node exists before accessing `prev` or `next`
4. **Order matters**: Update pointers in correct sequence to avoid losing references

### Complexity
- **Time**: O(1) for insert at beginning, O(n) for insert at end/delete
- **Space**: O(1)

---

## Problem 2: LRU Cache ⭐

### Problem Logic
Design a Least Recently Used (LRU) cache that:
- Stores key-value pairs with fixed capacity
- Evicts least recently used item when capacity exceeded
- Both `get` and `put` operations must be O(1)

### Core Insight
**Combine HashMap + Doubly Linked List**:
- **HashMap**: O(1) key lookup (key → Node)
- **Doubly Linked List**: O(1) add/remove operations, maintains usage order
- **Order**: Most Recently Used (MRU) at head, Least Recently Used (LRU) at tail

### Pseudocode
```
class Node:
    key, value, prev, next

class LRUCache:
    capacity, cache (HashMap), head (dummy), tail (dummy)
    
    INIT(capacity):
        self.capacity = capacity
        self.cache = {}
        self.head = Node(0, 0)  # dummy
        self.tail = Node(0, 0)  # dummy
        head.next = tail
        tail.prev = head
    
    REMOVE(node):
        node.prev.next = node.next
        node.next.prev = node.prev
    
    ADD_TO_HEAD(node):
        node.next = head.next
        node.prev = head
        head.next.prev = node
        head.next = node
    
    GET(key):
        if key not in cache:
            return -1
        
        node = cache[key]
        REMOVE(node)
        ADD_TO_HEAD(node)  # Mark as recently used
        return node.value
    
    PUT(key, value):
        if key in cache:
            REMOVE(cache[key])
            delete cache[key]
        
        new_node = Node(key, value)
        cache[key] = new_node
        ADD_TO_HEAD(new_node)
        
        if len(cache) > capacity:
            lru_node = tail.prev
            REMOVE(lru_node)
            delete cache[lru_node.key]
```

### Visual Flow
```
Initial (capacity=2):
head <-> tail

put(1, 1):
head <-> [1:1] <-> tail
         (MRU)

put(2, 2):
head <-> [2:2] <-> [1:1] <-> tail
         (MRU)      (LRU)

get(1):  # Move 1 to head
head <-> [1:1] <-> [2:2] <-> tail
         (MRU)      (LRU)

put(3, 3):  # Evict LRU (key=2)
head <-> [3:3] <-> [1:1] <-> tail
         (MRU)      (LRU)

get(2):  # Returns -1 (evicted)
```

### Why Dummy Nodes?
```
Without dummy nodes:
- Need special handling for empty list
- Need to check if node is head/tail before removal

With dummy nodes:
- head.next always points to first real node (or tail)
- tail.prev always points to last real node (or head)
- No edge case handling needed
```

### Critical Operations
1. **get(key)**:
   - Lookup in HashMap: O(1)
   - Remove from current position: O(1)
   - Add to head (mark as MRU): O(1)

2. **put(key, value)**:
   - If exists: Remove old node
   - Create new node, add to HashMap
   - Add to head (mark as MRU)
   - If over capacity: Remove LRU (tail.prev)

### Complexity
- **Time**: O(1) for both get and put
- **Space**: O(capacity) for HashMap and Doubly Linked List

### Pattern Recognition
**When to use LRU Cache pattern**:
- Need O(1) access and eviction
- Track usage order
- Fixed capacity constraint
- Examples: Browser cache, database query cache, page replacement

---

## Problem 3: Maximum Depth of Binary Tree

### Problem Logic
Find the maximum depth (height) of a binary tree - the number of nodes along the longest path from root to farthest leaf.

### Core Insight
**Recursive Definition**: 
- Depth of tree = 1 + max(depth of left subtree, depth of right subtree)
- Base case: Empty tree has depth 0

### Pseudocode
```
MAX_DEPTH(root):
    if root is None:
        return 0
    
    left_depth = MAX_DEPTH(root.left)
    right_depth = MAX_DEPTH(root.right)
    
    return 1 + max(left_depth, right_depth)
```

### Visual Flow
```
Example: root = [3,9,20,null,null,15,7]

        3           depth = 1 + max(1, 2) = 3
       / \
      9   20        depth = 1 + max(0, 1) = 2
         /  \
        15   7      depth = 1 + max(0, 0) = 1

Recursion Tree:
maxDepth(3)
├── maxDepth(9) → 1
│   ├── maxDepth(null) → 0
│   └── maxDepth(null) → 0
└── maxDepth(20) → 2
    ├── maxDepth(15) → 1
    │   ├── maxDepth(null) → 0
    │   └── maxDepth(null) → 0
    └── maxDepth(7) → 1
        ├── maxDepth(null) → 0
        └── maxDepth(null) → 0
```

### Approach Comparison

| Approach | Method | Time | Space | Notes |
|----------|--------|------|-------|-------|
| **Recursive DFS** ⭐ | Post-order traversal | O(n) | O(h) | Cleanest, uses call stack |
| **Iterative BFS** | Level-order with queue | O(n) | O(w) | Counts levels |
| **Iterative DFS** | Stack with (node, depth) | O(n) | O(h) | Explicit stack |

**h** = height, **w** = max width

### Alternative: BFS Approach
```python
def maxDepth(root):
    if not root:
        return 0
    
    queue = [root]
    depth = 0
    
    while queue:
        depth += 1
        level_size = len(queue)
        
        for _ in range(level_size):
            node = queue.pop(0)
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return depth
```

### Complexity
- **Time**: O(n) - visit each node once
- **Space**: O(h) for recursion stack (h = height)
  - Best case (balanced): O(log n)
  - Worst case (skewed): O(n)

---

## Day 20 Summary

### Key Concepts
1. **Doubly Linked List**: Bidirectional traversal with `prev` and `next` pointers
2. **LRU Cache**: HashMap + Doubly Linked List for O(1) operations
3. **Tree Depth**: Recursive definition using max of subtree depths

### Pattern Recognition

| Problem | Data Structure | Key Technique | Time |
|---------|---------------|---------------|------|
| Doubly Linked List | DLL | Bidirectional pointers | O(n) |
| LRU Cache | HashMap + DLL | Dummy nodes, move to head | O(1) |
| Max Depth | Binary Tree | Recursive DFS | O(n) |

### Critical Insights
1. **Dummy Nodes**: Eliminate edge cases in linked list operations
2. **Hybrid Structures**: Combine data structures for optimal complexity (HashMap + DLL)
3. **Recursion**: Natural fit for tree problems with clear base case
4. **Order Maintenance**: Doubly linked list efficiently maintains usage order

### Common Mistakes
1. ❌ Forgetting to update both `prev` and `next` in doubly linked list
2. ❌ Not using dummy nodes in LRU cache (leads to edge case bugs)
3. ❌ Forgetting to remove from HashMap when evicting LRU node
4. ❌ Confusing depth (nodes) vs height (edges) in tree problems

### Master Checklist
- [ ] Can implement doubly linked list with all operations
- [ ] Understand why LRU needs HashMap + DLL combination
- [ ] Can explain dummy node benefits
- [ ] Can write recursive tree depth solution
- [ ] Know when to use DFS vs BFS for tree problems
