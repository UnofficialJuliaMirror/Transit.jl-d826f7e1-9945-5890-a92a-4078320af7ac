module Transit
  import JSON
  import DataStructures.OrderedDict

  using URIParser

  export Encoder, encode, parse, decode

  include("tagged_value.jl")
  include("tsymbol.jl")
  include("link.jl")
  include("constants.jl")
  include("decoder.jl")
  include("utilities.jl")
  include("emitter.jl")
  include("encoder.jl")
  include("reader.jl")
  include("rollingCache.jl")
end
