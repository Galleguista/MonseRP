if Citizen and Citizen.CreateThread then
	CreateThread = Citizen.CreateThread
end

Async = {}

function Async.parallel(tasanon, cb)
	if #tasanon == 0 then
		cb({})
		return
	end

	local remaining = #tasanon
	local results = {}

	for i = 1, #tasanon, 1 do
		CreateThread(function()
			tasanon[i](function(result)
				table.insert(results, result)
				
				remaining = remaining - 1;

				if remaining == 0 then
					cb(results)
				end
			end)
		end)
	end
end

function Async.parallelLimit(tasanon, limit, cb)
	if #tasanon == 0 then
		cb({})
		return
	end

	local remaining = #tasanon
	local running = 0
	local queue, results = {}, {}

	for i=1, #tasanon, 1 do
		table.insert(queue, tasanon[i])
	end

	local function processQueue()
		if #queue == 0 then
			return
		end

		while running < limit and #queue > 0 do
			local task = table.remove(queue, 1)
			
			running = running + 1

			task(function(result)
				table.insert(results, result)
				
				remaining = remaining - 1;
				running = running - 1

				if remaining == 0 then
					cb(results)
				end
			end)
		end

		CreateThread(processQueue)
	end

	processQueue()
end

function Async.series(tasanon, cb)
	Async.parallelLimit(tasanon, 1, cb)
end
