module Transit

import JSON
import Base.getindex
import Base

using DataStructures
using URIParser
using Decimals

export parse, write,  # intended public use
       Decoder, Encoder, decode, encode  # used by tests

include("tagged_value.jl")
include("tsymbol.jl")
include("tset.jl")
include("turi.jl")
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
