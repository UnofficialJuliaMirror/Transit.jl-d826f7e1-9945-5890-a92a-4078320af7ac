type Decoder
  decoderFunctions

  Decoder() = new(Dict{ASCIIString,Function}())
end

function add_decoder(e::Decoder, tag::AbstractString, f::Function)
  e.decoderFunctions[tag] = f
end

function decode_value(e::Decoder, x::Any)

end

