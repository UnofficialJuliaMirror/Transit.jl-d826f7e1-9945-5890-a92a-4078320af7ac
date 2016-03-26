include("../src/Transit.jl")

using Base.Test
import Transit

function round_trip(inval)
  io = IOBuffer()
  JSON.print(io, inval) # temporary hack for json only testing, Transit.print?
  seek(io, 0)
  Transit.parse(io)
end



@test round_trip([1, 2, 3, 4]) == [1, 2, 3, 4]
