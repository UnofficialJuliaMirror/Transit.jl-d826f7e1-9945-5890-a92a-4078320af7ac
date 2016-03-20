module Transit
  import JSON

  export Encoder, encode

  include("encoder.jl")
  include("emitter.jl")
  include("rollingCache.jl")
end
