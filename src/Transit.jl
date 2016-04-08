module Transit
  import JSON

  using DataStructures
  using URIParser

  export Encoder, encode, parse, decode

  include("tagged_value.jl")
  include("tsymbol.jl")
  include("link.jl")
  include("constants.jl")
  include("cache.jl")
  include("decoder.jl")
  include("utilities.jl")
  include("emitter.jl")
  include("encoder.jl")
  include("writer.jl")
  include("reader.jl")
end
