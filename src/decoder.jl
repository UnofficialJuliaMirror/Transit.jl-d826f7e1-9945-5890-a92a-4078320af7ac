

type Tag
  tag::AbstractString
  value::Any
end

type Decoder
  decoderFunctions

  Decoder() = new(Dict{ASCIIString,Function}(
                     "_"  => (x -> Nothing),
                     ":"  => (x -> symbol(x)),
                     "\$" => (x -> TSymbol(x)),
                     "?"  => (x -> true ? x : false),
                     "i"  => (x -> Base.parse(Int64, x)),
                     "d"  => (x -> Base.parse(Float64, x)),
                     "f"  => (x -> Base.parse(BigFloat, x)),
                     "'"  => (x -> x),
                     "n"  => (x -> Base.parse(BigInt, x)),
                     "u"  => (x -> Base.Random.UUID(x)), # only string case so far
                     "t"  => (x -> Date(x, Dates.DateFormat("y-m-dTH:M:S.s"))),
                     "m"  => (x -> Base.Dates.UTInstant(Dates.Millisecond(Base.parse(x)))), # maybe not sufficient
                     "z"  => (x -> if (x == "NaN")
                                     NaN
                                   elseif (x == "INF")
                                     Inf
                                   elseif (x == "-INF")
                                     -Inf
                                   else
                                     throw(string("Don't know how to encode: ", x))
                                   end)
                ))
end

function getindex(d::Decoder, k::AbstractString)
    d.decoderFunctions[k]
end

function add_decoder(e::Decoder, tag::AbstractString, f::Function)
  e.decoderFunctions[tag] = f
end

function decode(e::Decoder, node::Any, cache=Nothing, as_map_key=false)
  #if cache == Nothing
  #  cache = RollingCache()
  #end
  decode_value(e, node, cache, as_map_key)
end


function decode_value(e::Decoder, node::Any, cache=Nothing, as_map_key=false)
    node
end

function decode_value(e::Decoder, node::Bool)
    node ? true : false # where we may have to add TTrue, TFalse for set issue
end

function decode_value(e::Decoder, node::Array{Any,1}, cache, as_map_key=false)
  if !isempty(node)
    if node[1] == MAP_AS_ARR
      returned_dict = Dict()
      for kv in node[2:end]
        key = decode_value(e, kv[1], cache, true)
        value = decode_value(e, kv[2], cache, as_map_key)
        returned_dict[key] = val
      end
      return returned_dict
    else
      decoded = decode_value(e, node[1], cache, as_map_key)
      if isa(decoded, Tag)
        return decode_value(e, decoded, node[2], cache, as_map_key)
      end
    end
  end

  [decode_value(e, x, cache, as_map_key) for x in node]
end


function decode_value(e::Decoder, hash::Dict, cache, as_map_key=false)
  if length(hash) != 1
    h = Dict{Any,Any}()
    for kv in hash
      key = decode_value(e, kv[1], cache, true)
      val = decode_value(e, kv[2], cache, false)
      h[key] = val
    end
    return h
  else
    for (k,v) in hash
      key = decode_value(e, k, cache, true)
      if isa(key, Tag)
        return decode_value(e, decoded, value, cache, as_map_key)
      end
      return Dict{Any,Any}(key => decode_value(e, v, cache, false))
    end
  end
end

function decode_value(e::Decoder, s::AbstractString, cache, as_map_key=false)
  # handle if cache key?
  # cache if cacheable
  if startswith(s, ESC)
    #2:2 is necessary to get str instead of char
    e[s[2:2]](s[3:end])
  else
    s
  end
end

function decode_value(e::Decoder, tag::Tag, value, cache, as_map_key=false)
end
