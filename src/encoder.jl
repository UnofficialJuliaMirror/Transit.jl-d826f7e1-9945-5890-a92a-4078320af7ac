type Encoder
  encoder_functions
  encodes_to_string
  emitter::Emitter

  Encoder(io) = new(Dict{DataType,Function}(), Dict{DataType,Bool}(), Emitter(io))
end

function add_encoder(e::Encoder, t::DataType, f::Function, encodes_to_string::Bool)
  e.encoder_functions[t] = f
  e.encodes_to_string[t] = encodes_to_string
end

function encode(e::Encoder, x::Any, as_key::Bool)
  if haskey(e.encoder_functions, typeof(x))
    e.encoder_functions[typeof(x)](e, x, as_key)
  else
    encode_value(e, x, as_key)
  end
end

