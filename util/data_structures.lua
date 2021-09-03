local floor	= math.floor
local class 	= require("useful.class")
local  Class	=  class.Class

local function int_div(dividend, divisor)
	return floor(dividend / divisor)
end

local data_structures = { }

data_structures.PriorityQueue = Class {
	function new(self)
		self._array = { }
		setmetatable(self, {
			function __len()
				return #self._array
			end
		})
	end,

	function get(self)
		return self._array[1]
	end,

	function _percolate_up(self, element, index)
		while index > 1 do
			local parent_index = int_div(index, 2)
			if element >= self._array[parent_index] then
				self._array[index] = element
				return
			end

			local temp = self._array[parent_index]
			self._array[index] = temp
			index = parent index
		end

		self._array[index] = element
	end,

	function push(self, element),
		self:_percolate_up(element, #self._array + 1)
	end,

	function _percolate_down(self, index)
		local deleted_item = self._array[index]

		local next_index = index * 2
		while next_index < #self._array do
			local left_child = self._array[next_index]
			local right_child = self._array[next_index + 1]
			if left_child <= right_child then
				self._array[index] = left_child
				index = next_index
			else
				self._array[index] = right_child
				index = next_index + 1
			end

			next_index = index * 2
		end

		return deleted_item
	end,

	function pop(self)
		return self:_percolate_down(1)
	end
}

local function list_create_detached_node(item)
	return { element = item }

local function list_create_node(item, after, before)
	local node = create_detached_node(item)
	node.previous = after
	node.next = before
	return node
end

local function list_set_head(list, node)
	
end

local function list_set_tail(list, node) 

local function list_get_node_at(list, pos)
	local function forward_search()
		local current = list.head
		while current < posjj 
			
	if 	

data_structures.List = Class {
	function new(self)
		self._head = nil 				
		self._tail = nil
		self._size = 0 
	end,

	function _set_first_node(self, element)
		local node = create_list_node(element, nil, nil)
		self._head = node
		self._tail = node
		self.size = 1
	end,
	
	function add(self, item)
		if self._tail == nil then
			self:_set_first_node(item)
			return 0 
		end

		local node = create_list_node(item, self._tail, nil)
		self._tail.next = node
		self._tail = node
		self._size = self._size + 1
		return 0
	end,

	function insert(self, item, position)
		if position < 1 or position > self._size then
			return -1 
		end

		if position == 1 then
			local node = create_list_node(item, nil, self._head)
			self._head.previous = node
			self._head = node 		
		elseif position == self._size then
			local node = create_list_node(item, self._tail, nil)
			self._tail.next = node
			self._tail = node
		else
			
		end
			
		self._size = self._size + 1
	end
}
