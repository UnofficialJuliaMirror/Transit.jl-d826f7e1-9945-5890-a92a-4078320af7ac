include("../src/Transit.jl")

using Base.Test
import Transit


function round_trip(x)
    buf = IOBuffer()
    e = Transit.Encoder(buf)
    Transit.encode(e, x, false)
    seek(buf, 0)
    Transit.parse(buf)
end

@test round_trip(["first!"]) == ["first!"]
