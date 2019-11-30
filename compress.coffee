
fs		= require 'fs'
path	= require 'path'
CSON	= require 'cson'


walk = (dir) ->

	unless fs.existsSync(dir) then	return []

	fs.readdirSync(dir).map (f) ->

		p = path.join(dir, f)
		stat = fs.statSync(p)

		if stat.isDirectory() then return {
				name: f
				type: 'directory'
				path:  "./" + p
				items: walk(p)
			}

		extention = f.match(/\w+$/)[0]
		name = if extention?
			f.substring 0, f.length - extention.length - 1
		else f

		return {
			name: name
			type: 'file'
			extention : extention
			path: "./" + p
			size: stat.size
		}
items = walk '.'

load = (obj, items) ->
	for item in items
		if item.type == "directory"
			obj[item.name] = arguments.callee {}, item.items
			continue

		switch item.extention
			when 'json', 'cson'
				# console.log item.path
				obj[item.name] = CSON.load item.path
		# else if item.type == 'file'
	return obj

data = load {}, items

# console.log JSON.stringify items, null, 4
console.log JSON.stringify data, null, 4
