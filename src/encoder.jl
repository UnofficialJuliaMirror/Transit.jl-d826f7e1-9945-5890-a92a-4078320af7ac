type Encoder
  encoderFunctions
  encodesToString
  emitter::Emitter

  Encoder(io) = new(Dict{DataType,Function}(), Dict{DataType,Bool}(), Emitter(io))
end

function add_encoder(e::Encoder, t::DataType, f::Function, encodes_to_string::Bool)
  e.encoderFunctions[t] = f
  e.encodesToString[t] = encodes_to_string
end

function encode(e::Encoder, x::Any, as_key::Bool)
  if haskey(e.encoderFunctions, typeof(x))
    e.encoderFunctions[typeof(x)](e, x, as_key)
  else
    encodeValue(e, x, as_key)
  end
end

