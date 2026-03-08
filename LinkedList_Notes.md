# Linked List - Complete Notes

## 1. What is a Linked List?

A **Linked List** is a linear data structure where elements are stored in nodes. Unlike arrays, elements are not stored in contiguous memory locations. Each node contains:
- **Data**: The value stored
- **Pointer/Reference**: Address to the next node

### Memory Representation
```
Array:     [10][20][30][40]  (Contiguous memory)
           1000 1004 1008 1012

Linked List: [10|●]-->[20|●]-->[30|●]-->[40|NULL]
             2000     5004     3008     7012
```

---

## 2. Deep Dive into Logic

### Node Structure
Each node is an object with two properties:
```python
class Node:
    def __init__(self, data):
        self.data = data      # Stores the value
        self.next = None      # Points to next node (initially None)
```

### How Linking Works
```
head -> [5|next] -> [10|next] -> [15|None]
        Node1       Node2         Node3

Node1.next = address of Node2
Node2.next = address of Node3
Node3.next = None (end of list)
```

### Why Pointers?
- Pointers connect nodes scattered in memory
- Allows dynamic growth without reallocation
- Enables O(1) insertion/deletion at known positions

---

## 3. Types of Linked Lists

### 3.1 Singly Linked List
Each node points to the next node only.
```
head -> [1|●] -> [2|●] -> [3|●] -> None
```

### 3.2 Doubly Linked List
Each node has pointers to both next and previous nodes.
```
None <- [●|1|●] <-> [●|2|●] <-> [●|3|●] -> None
        prev data next
```

### 3.3 Circular Linked List
Last node points back to the first node.
```
head -> [1|●] -> [2|●] -> [3|●]
         ↑__________________|
```

### 3.4 Circular Doubly Linked List
Combination of doubly and circular.
```
     ┌─────────────────────────┐
     ↓                         |
    [●|1|●] <-> [●|2|●] <-> [●|3|●]
     ↑_________________________|
```

---

## 4. Linked List Implementation (Python)

### 4.1 Singly Linked List - Complete Implementation

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    # Insert at beginning - O(1)
    def insert_at_beginning(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
    
    # Insert at end - O(n)
    def insert_at_end(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
    
    # Insert at position - O(n)
    def insert_at_position(self, data, position):
        if position == 0:
            self.insert_at_beginning(data)
            return
        new_node = Node(data)
        current = self.head
        for _ in range(position - 1):
            if not current:
                return
            current = current.next
        new_node.next = current.next
        current.next = new_node
    
    # Delete from beginning - O(1)
    def delete_from_beginning(self):
        if not self.head:
            return
        self.head = self.head.next
    
    # Delete from end - O(n)
    def delete_from_end(self):
        if not self.head:
            return
        if not self.head.next:
            self.head = None
            return
        current = self.head
        while current.next.next:
            current = current.next
        current.next = None
    
    # Delete by value - O(n)
    def delete_by_value(self, value):
        if not self.head:
            return
        if self.head.data == value:
            self.head = self.head.next
            return
        current = self.head
        while current.next:
            if current.next.data == value:
                current.next = current.next.next
                return
            current = current.next
    
    # Search - O(n)
    def search(self, value):
        current = self.head
        position = 0
        while current:
            if current.data == value:
                return position
            current = current.next
            position += 1
        return -1
    
    # Get length - O(n)
    def length(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count
    
    # Display - O(n)
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        print(" -> ".join(elements) + " -> None")
    
    # Reverse - O(n)
    def reverse(self):
        prev = None
        current = self.head
        while current:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
        self.head = prev
    
    # Get middle element - O(n)
    def get_middle(self):
        slow = fast = self.head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
        return slow.data if slow else None
    
    # Detect cycle - O(n)
    def has_cycle(self):
        slow = fast = self.head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            if slow == fast:
                return True
        return False
```

### 4.2 Doubly Linked List Implementation

```python
class DNode:
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None

class DoublyLinkedList:
    def __init__(self):
        self.head = None
    
    def insert_at_beginning(self, data):
        new_node = DNode(data)
        if self.head:
            new_node.next = self.head
            self.head.prev = new_node
        self.head = new_node
    
    def insert_at_end(self, data):
        new_node = DNode(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
        new_node.prev = current
    
    def delete_node(self, value):
        current = self.head
        while current:
            if current.data == value:
                if current.prev:
                    current.prev.next = current.next
                else:
                    self.head = current.next
                if current.next:
                    current.next.prev = current.prev
                return
            current = current.next
    
    def display_forward(self):
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        print(" <-> ".join(elements))
    
    def display_backward(self):
        if not self.head:
            return
        current = self.head
        while current.next:
            current = current.next
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.prev
        print(" <-> ".join(elements))
```

---

## 5. Time & Space Complexity

| Operation | Array | Linked List |
|-----------|-------|-------------|
| Access | O(1) | O(n) |
| Search | O(n) | O(n) |
| Insert at beginning | O(n) | O(1) |
| Insert at end | O(1) | O(n) without tail, O(1) with tail |
| Insert at middle | O(n) | O(n) |
| Delete at beginning | O(n) | O(1) |
| Delete at end | O(1) | O(n) |
| Delete at middle | O(n) | O(n) |

**Space Complexity**: O(n) for n nodes + extra space for pointers

---

## 6. Common Linked List Patterns

### Pattern 1: Two Pointer Technique (Fast & Slow)

**Use Cases**: Find middle, detect cycle, find nth node from end

```python
# Find middle element
def find_middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow

# Detect cycle (Floyd's Algorithm)
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

# Find nth node from end
def nth_from_end(head, n):
    fast = slow = head
    for _ in range(n):
        if not fast:
            return None
        fast = fast.next
    while fast:
        slow = slow.next
        fast = fast.next
    return slow
```

### Pattern 2: Reversal Pattern

**Use Cases**: Reverse list, reverse in groups, palindrome check

```python
# Reverse entire list
def reverse_list(head):
    prev = None
    current = head
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    return prev

# Reverse in groups of k
def reverse_k_group(head, k):
    current = head
    count = 0
    while current and count < k:
        current = current.next
        count += 1
    if count < k:
        return head
    
    prev = None
    current = head
    for _ in range(k):
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    
    head.next = reverse_k_group(current, k)
    return prev

# Check palindrome
def is_palindrome(head):
    # Find middle
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    # Reverse second half
    prev = None
    while slow:
        next_node = slow.next
        slow.next = prev
        prev = slow
        slow = next_node
    
    # Compare
    left, right = head, prev
    while right:
        if left.data != right.data:
            return False
        left = left.next
        right = right.next
    return True
```

### Pattern 3: Merge Pattern

**Use Cases**: Merge sorted lists, merge k sorted lists

```python
# Merge two sorted lists
def merge_two_sorted(l1, l2):
    dummy = Node(0)
    current = dummy
    
    while l1 and l2:
        if l1.data < l2.data:
            current.next = l1
            l1 = l1.next
        else:
            current.next = l2
            l2 = l2.next
        current = current.next
    
    current.next = l1 or l2
    return dummy.next

# Merge k sorted lists (using divide and conquer)
def merge_k_sorted(lists):
    if not lists:
        return None
    if len(lists) == 1:
        return lists[0]
    
    mid = len(lists) // 2
    left = merge_k_sorted(lists[:mid])
    right = merge_k_sorted(lists[mid:])
    return merge_two_sorted(left, right)
```

### Pattern 4: In-place Modification

**Use Cases**: Remove duplicates, remove nth node, partition list

```python
# Remove duplicates from sorted list
def remove_duplicates(head):
    current = head
    while current and current.next:
        if current.data == current.next.data:
            current.next = current.next.next
        else:
            current = current.next
    return head

# Remove nth node from end
def remove_nth_from_end(head, n):
    dummy = Node(0)
    dummy.next = head
    fast = slow = dummy
    
    for _ in range(n + 1):
        fast = fast.next
    
    while fast:
        slow = slow.next
        fast = fast.next
    
    slow.next = slow.next.next
    return dummy.next

# Partition list around value x
def partition(head, x):
    before_head = before = Node(0)
    after_head = after = Node(0)
    
    while head:
        if head.data < x:
            before.next = head
            before = before.next
        else:
            after.next = head
            after = after.next
        head = head.next
    
    after.next = None
    before.next = after_head.next
    return before_head.next
```

### Pattern 5: Cycle Detection & Removal

**Use Cases**: Detect cycle, find cycle start, remove cycle

```python
# Find cycle start point
def detect_cycle_start(head):
    slow = fast = head
    
    # Detect cycle
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break
    else:
        return None
    
    # Find start
    slow = head
    while slow != fast:
        slow = slow.next
        fast = fast.next
    return slow

# Remove cycle
def remove_cycle(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break
    else:
        return
    
    slow = head
    while slow.next != fast.next:
        slow = slow.next
        fast = fast.next
    fast.next = None
```

### Pattern 6: Intersection Pattern

**Use Cases**: Find intersection point of two lists

```python
# Find intersection point
def get_intersection(head1, head2):
    if not head1 or not head2:
        return None
    
    # Get lengths
    len1 = len2 = 0
    temp1, temp2 = head1, head2
    while temp1:
        len1 += 1
        temp1 = temp1.next
    while temp2:
        len2 += 1
        temp2 = temp2.next
    
    # Align both lists
    diff = abs(len1 - len2)
    if len1 > len2:
        for _ in range(diff):
            head1 = head1.next
    else:
        for _ in range(diff):
            head2 = head2.next
    
    # Find intersection
    while head1 and head2:
        if head1 == head2:
            return head1
        head1 = head1.next
        head2 = head2.next
    return None
```

### Pattern 7: Sorting Pattern

**Use Cases**: Sort linked list, insertion sort

```python
# Merge sort for linked list
def merge_sort(head):
    if not head or not head.next:
        return head
    
    # Find middle
    slow = fast = head
    prev = None
    while fast and fast.next:
        prev = slow
        slow = slow.next
        fast = fast.next.next
    prev.next = None
    
    # Recursively sort
    left = merge_sort(head)
    right = merge_sort(slow)
    
    return merge_two_sorted(left, right)

# Insertion sort
def insertion_sort(head):
    sorted_head = None
    current = head
    
    while current:
        next_node = current.next
        sorted_head = sorted_insert(sorted_head, current)
        current = next_node
    return sorted_head

def sorted_insert(head, node):
    if not head or head.data >= node.data:
        node.next = head
        return node
    
    current = head
    while current.next and current.next.data < node.data:
        current = current.next
    
    node.next = current.next
    current.next = node
    return head
```

### Pattern 8: Reordering Pattern

**Use Cases**: Reorder list, odd-even list, rotate list

```python
# Reorder list: L0→L1→...→Ln-1→Ln to L0→Ln→L1→Ln-1→...
def reorder_list(head):
    if not head or not head.next:
        return
    
    # Find middle
    slow = fast = head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next
    
    # Reverse second half
    second = slow.next
    slow.next = None
    prev = None
    while second:
        next_node = second.next
        second.next = prev
        prev = second
        second = next_node
    
    # Merge
    first, second = head, prev
    while second:
        temp1, temp2 = first.next, second.next
        first.next = second
        second.next = temp1
        first, second = temp1, temp2

# Odd-even list
def odd_even_list(head):
    if not head:
        return None
    
    odd = head
    even = head.next
    even_head = even
    
    while even and even.next:
        odd.next = even.next
        odd = odd.next
        even.next = odd.next
        even = even.next
    
    odd.next = even_head
    return head

# Rotate list right by k places
def rotate_right(head, k):
    if not head or not head.next or k == 0:
        return head
    
    # Get length
    length = 1
    tail = head
    while tail.next:
        tail = tail.next
        length += 1
    
    k = k % length
    if k == 0:
        return head
    
    # Find new tail
    new_tail = head
    for _ in range(length - k - 1):
        new_tail = new_tail.next
    
    new_head = new_tail.next
    new_tail.next = None
    tail.next = head
    return new_head
```

---

## 7. Common Problems & Solutions

### Problem 1: Reverse Linked List
```python
def reverse(head):
    prev = None
    current = head
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    return prev
```

### Problem 2: Detect Cycle
```python
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False
```

### Problem 3: Find Middle Element
```python
def find_middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow
```

### Problem 4: Remove Duplicates
```python
def remove_duplicates(head):
    current = head
    while current and current.next:
        if current.data == current.next.data:
            current.next = current.next.next
        else:
            current = current.next
    return head
```

### Problem 5: Add Two Numbers (as Linked Lists)
```python
def add_two_numbers(l1, l2):
    dummy = Node(0)
    current = dummy
    carry = 0
    
    while l1 or l2 or carry:
        val1 = l1.data if l1 else 0
        val2 = l2.data if l2 else 0
        
        total = val1 + val2 + carry
        carry = total // 10
        current.next = Node(total % 10)
        current = current.next
        
        if l1: l1 = l1.next
        if l2: l2 = l2.next
    
    return dummy.next
```

---

## 8. Advantages & Disadvantages

### Advantages
1. **Dynamic Size**: Grows/shrinks at runtime
2. **Efficient Insertion/Deletion**: O(1) at known positions
3. **No Memory Waste**: Allocates only needed memory
4. **Easy Implementation**: Of stacks, queues, graphs

### Disadvantages
1. **No Random Access**: Must traverse from head
2. **Extra Memory**: For storing pointers
3. **Not Cache Friendly**: Scattered memory locations
4. **Reverse Traversal**: Difficult in singly linked list

---

## 9. When to Use Linked Lists

✅ **Use When:**
- Frequent insertions/deletions
- Unknown size at compile time
- Implementing stacks, queues, graphs
- Memory fragmentation is an issue

❌ **Avoid When:**
- Need random access
- Memory is limited (pointer overhead)
- Cache performance is critical
- Frequent search operations

---

## 10. Real-World Applications

1. **Browser History**: Back/forward navigation (doubly linked list)
2. **Music Player**: Previous/next song (circular linked list)
3. **Image Viewer**: Previous/next image
4. **Undo/Redo**: In text editors
5. **Hash Tables**: Chaining for collision resolution
6. **Operating Systems**: Process scheduling, memory management
7. **Blockchain**: Each block points to previous block

---

## 11. Practice Problems

### Easy
- Reverse a linked list
- Find middle element
- Detect cycle
- Remove duplicates from sorted list
- Merge two sorted lists

### Medium
- Add two numbers
- Remove nth node from end
- Reorder list
- Odd-even linked list
- Partition list
- Rotate list
- Copy list with random pointer

### Hard
- Reverse nodes in k-group
- Merge k sorted lists
- LRU Cache implementation
- Flatten multilevel doubly linked list

---

## 12. Tips & Tricks

1. **Use Dummy Node**: Simplifies edge cases in insertion/deletion
2. **Two Pointer**: Solves many problems efficiently
3. **Draw Diagrams**: Visualize pointer changes
4. **Handle Edge Cases**: Empty list, single node, two nodes
5. **Recursive vs Iterative**: Choose based on problem
6. **Space Optimization**: Modify in-place when possible

---

## Summary

Linked lists are fundamental data structures that trade random access for efficient insertions/deletions. Master the patterns (two-pointer, reversal, merge) to solve most linked list problems efficiently. Practice drawing pointer diagrams to visualize operations clearly.
