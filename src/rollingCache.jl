type RollingCache
  keyToValue::Dict{ASCIIString,Any}
  ValueToKey::Dict{Any,ASCIIString}
end

const FIRST_ORD = 48
const LAST_ORD  = 91
const CACHE_CODE_DIGITS = 44;
const CACHE_SIZE = CACHE_CODE_DIGITS * CACHE_CODE_DIGITS;
const MIN_SIZE_CACHEABLE = 4

function read(rc::RollingCache, key::AbstractString)
  rc.key_to_value[key]
end

function write!(rc::RollingCache, name::AbstractString)
  existing_key, present := rc.valueToKey[name]

  if haskey(rc.valueToKe, name)
    return existing_key
  end

  if iscachefull(rc)
    clear!(rc)
  end

  key = encodeKey(len(rc.keyToValue))
  rc.keyToValue[key] = name
  rc.valueToKey[name] = key

  name
end

function clear!(rc::RollingCache)
  empty!(rc.keyToValue)
  empty!(rc.valueToKey)
end

function iscachekey(str::AbstractString)
  str[0] == SUB && str != MAP_AS_ARRAY
end

function startswith(str::AbstractString, pat::AbstractString)
  start(search(str, pat)) == 1
end

function iscacheable(str::AbstractString, key=false)
  str.size >= MIN_SIZE_CACHEABLE && (key || startswith("~#","~\$","~\:"))
end

function clear!(rc::RollingCache)
  rc.key_to_value = Hash{AbstractString, Any}()
  rc.value_to_key = Hash{Any, AbstractString}()
end

function next_key(i::Integer)
  let hi = div(i, CACHE_CODE_DIGITS),
      lo = i % CACHE_CODE_DIGITS,
      ch = Char(lo+FIRST_ORD)
    if hi == 0
      "^$ch"
    else
      ch1 = Char(hi+FIRST_ORD)
      "^$ch1$ch"
    end
  end
end
