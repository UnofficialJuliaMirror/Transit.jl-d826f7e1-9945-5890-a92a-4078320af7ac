type Tag
  tag::AbstractString
  value::Any
end

type Decoder
  decoderFunctions

  Decoder() = new(Dict{ASCIIString,Function}())
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
      if typeof(decoded) == Tag
        return decode_value(e, decoded, node[2], cache, as_map_key)
      end
    end
  end

  [decode_value(e, x, cache, as_map_key) for x in node]
end


function decode_value(e::Decoder, node::OrderedDict)
end

function decode_value(e::Decoder, tag::Tag, value, cache, as_map_key=false)
end
