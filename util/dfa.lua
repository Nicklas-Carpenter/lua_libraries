local class 	= require("useful.class")
local  Class 	=  class.Class

local dfa = { }

local DFA_Node = Class {
	function new(self, is_accepting) 
		self._successors = { }
		self._predecessors = { }
		self.is_accepting = is_accepting
	end,
}

local DFA = class {
	function new(self, symbols)
