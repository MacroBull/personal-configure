-- Conky Lua scripting example
--
-- In your conkyrc, use ${lua string_func} to call conky_string_func(), ${lua
-- int_func} to call conky_int_func(), and so forth.  You must load this script
-- in your conkyrc using 'lua_load <path>' before TEXT in order to call the
-- function.
--
do
	-- configuration
	-- local interval = 5 
	local time = os.time()
	local function elapse()
		local r = os.time() - time
		time = time + r
		return r
	end
	
	function read_i915_freq_info()
		local f = io.open("/sys/kernel/debug/dri/0/i915_frequency_info", "r")
		if f == nil then return nil end
		local r = {
			PM = f:read(),
			GT_PERF_STATUS = f:read(),
			rPStateR = f:read(),
			rPStateV = f:read(),
			rPStateL = f:read(),
			RPSTAT1 = f:read(),
			RPMODECTL = f:read(),
			RPINCLIMIT = f:read(),
			RPDECLIMIT = f:read(),
			RPNSWREQ = f:read(),
			CAGF = f:read(),
			ue = f:read(), 
			u = f:read(), 
			pu = f:read(), 
			de = f:read(), 
			d = f:read(),
			pd = f:read()
		}
		f:close()
		r.rPStateR = tonumber(string.sub(r.rPStateR, 23))
		r.rPStateV = tonumber(string.sub(r.rPStateV, 21))
		r.rPStateL = tonumber(string.sub(r.rPStateL, 23))
		r.RPNSWREQ = tonumber(string.sub(r.RPNSWREQ , 11,-4))
		r.CAGF = tonumber(string.sub(r.CAGF, 7,-4))
		r.ue = tonumber(string.sub(r.ue, 15,-3))
		r.u = tonumber(string.sub(r.u, 12,-3))
		r.pu = tonumber(string.sub(r.pu, 13,-3))
		r.de = tonumber(string.sub(r.de, 17,-3))
		r.d = tonumber(string.sub(r.d, 14,-3))
		r.pd = tonumber(string.sub(r.pd, 15,-3))
		return r
	end
	
	function read_i915_cur_freq_info()
		local f = io.open("/sys/class/drm/card0/gt_cur_freq_mhz", "r")
		if f == nil then return nil end
		r = tonumber(f:read())
		f:close()
		return r
	end
	
	local rc6_load = 0
	function read_i915_rc6_info()
		local rc6_load_new = 0
		local f = io.open("/sys/class/drm/card0/power/rc6p_residency_ms", "r")
		if f == nil then return nil end
		rc6_load_new = rc6_load_new + tonumber(f:read())
		f:close()
		f = io.open("/sys/class/drm/card0/power/rc6pp_residency_ms", "r")
		if f then 
			rc6_load_new = rc6_load_new + tonumber(f:read())
			f:close()
		end
		local r = rc6_load - rc6_load_new
		rc6_load = rc6_load_new
-- 		print(r)
		return r
	end
	
	function conky_gpu_freq_load()
-- 		return read_i915_freq_info().RPNSWREQ
-- 		info = read_i915_freq_info()
-- 		if info then return info.CAGF end
		info = read_i915_cur_freq_info()
		if info then return info end
		return -1
	end
	
	local gpu_rc6_load = 0
	function conky_gpu_rc6_load()
		local time = elapse()
		if time>0 then 
			info = read_i915_rc6_info()
			if info == nil then return -1 end
			gpu_rc6_load = 100 + math.floor(info / (time * 10))
			if gpu_rc6_load<0 then gpu_rc6_load = 0 end
		end
		return gpu_rc6_load
	end
	
	
	function conky_gpu_load()
		-- Use frequency
-- 		local freq = conky_gpu_freq_load()
-- 		if freq == -1 then freq = 1100 end
		-- Use RC6
		local rc6 = conky_gpu_rc6_load()
-- 		if rc6 == -1 then rc6 = 100 end
-- 		load = freq * rc6
-- 		print(freq, rc6, load)
-- 		return load
		return rc6
	end
	
end