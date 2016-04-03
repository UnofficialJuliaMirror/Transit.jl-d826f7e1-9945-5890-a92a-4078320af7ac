include("../src/Transit.jl")

using Base.Test
import Transit

function square_trip(inval)
  io = IOBuffer()
  JSON.print(io, inval) # temporary hack for json only testing, Transit.print?
  seek(io, 0)
  Transit.parse(io)
end


@test square_trip([1, 2, 3, 4]) == [1, 2, 3, 4]
@test square_trip(["some", "funny", "words"]) == ["some", "funny", "words"]
@test square_trip([1, "and", 2, "we", Dict{Any,Any}("mix"=>"it up")]) == 
                 [1, "and", 2, "we", Dict{Any,Any}("mix"=>"it up")]
@test square_trip(Dict{Any,Any}("a" => 1, "b" => 2)) == Dict{Any,Any}("a" => 1, "b" => 2)
@test square_trip(Dict{Any,Any}("a" => 1)) == Dict{Any,Any}("a" => 1)
@test square_trip(Dict{Any,Any}("a" => Dict{Any,Any}("b" => 2))) ==
                 Dict{Any,Any}("a" => Dict{Any,Any}("b" => 2))
@test square_trip(["~:aaaa", "~:bbbb"]) == [:aaaa, :bbbb]
@test square_trip([Dict{Any,Any}("~:b" => "~i3"), "~i2"]) == [Dict{Any,Any}(:b => 3), 2]
@test square_trip(["~zINF", "~z-INF"]) == [Inf, -Inf]
@test isnan(square_trip(["~zNaN"])[1])
@test square_trip(["~f3.14"])[1] - 3.14 <= 0.000001

