local RunService = game:GetService("RunService")

local DataState: Module = {
	States = {},
	Protected = {}
}

type Module = {
	States: {[any]: ClassType}, 
	Protected: {[any]: any}
}

export type ClassType = typeof(setmetatable(
    {} :: {    
        Tag: string,
		Wrapped: table,
		DumpIfDeleted: boolean?
    },
    DataState
))

DataState.__index = DataState

function DataState.__newindex(table: ClassType, index: string, value: any)
	table.Wrapped[index] = value
end

function DataState.new(tag: any, dumpIfDeleted: boolean): ClassType
	local self: ClassType = {}

	self.Tag = tag
	self.Wrapped = {}
	self.DumpIfDeleted = if RunService:IsClient() then dumpIfDeleted else nil

	setmetatable(self, DataState)
	
	DataState.States[tag] = self

	return self
end

function DataState.Find(tag): ClassType
	return DataState.States[tag]
end

function DataState.Protect(newTable: table)
	table.insert(DataState.Protected, newTable)
end

function DataState.Unprotect(newTable: table)
	table.remove(DataState.Protect, table.find(newTable))
end

function DataState.DeleteAll()
	for _, state in pairs(DataState.States) do
		if state.Delete and not state.DumpIfDeleted then
			state:Delete()
		elseif state.Dump then
			state:Dump()
		end
	end
end

function DataState.AddTo(self: ClassType, key: string, object: any): any
	self.Wrapped[key] = object
end

function DataState.DumpOf(self: ClassType, key: string, object: any, parentTable: table)
	local objectType = typeof(object)

	if objectType == "table" and not table.find(DataState.Protected, object) and key ~= "Parent" and object ~= self then
		if object._DeletionProtocol then
			object:_DeletionProtocol()
		end
		setmetatable(object, nil)
		self:Dump(object)
	elseif objectType == "RBXScriptConnection" then
		object:Disconnect()
	elseif objectType == "task" then
		task.cancel(object)
	end

	self:_CleanKey(parentTable, key)
end

function DataState.Dump(self: ClassType, table: table)
	for key, object in pairs(table or self.Wrapped) do
		self:DumpOf(key, object, table)
	end

	if table then
		table = nil
	end
end

function DataState._CleanKey(self: ClassType, table, key)
	if table then
		table[key] = nil
	elseif self.Wrapped[key] then
		self.Wrapped[key] = nil
	end
end

function DataState.Delete(self: ClassType)
	self:Dump()
	setmetatable(self, nil)

	DataState.States[self.Tag] = nil

	self.Tag = nil
	self.Wrapped = nil
	self = nil
end

return DataState
