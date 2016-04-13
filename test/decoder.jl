include("../src/Transit.jl")

using Base.Test
import Transit

function square_trip(inval)
  io = IOBuffer()
  JSON.print(io, inval)
  seek(io, 0)
  Transit.parse(io)
end


@test square_trip(["~~foo"]) == ["~foo"]
@test square_trip(["~#'","~~foo"]) == "~foo"

@test square_trip(["~#'",1]) == 1
@test square_trip(Dict{Any,Any}("~#'" => 1)) == 1

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
@test square_trip(["~ude305d54-75b4-431b-adb2-eb6b9e546014"]) == [Base.Random.UUID("de305d54-75b4-431b-adb2-eb6b9e546014")]
@test square_trip(["~'ok"]) == ["ok"]
@test square_trip(["~_"]) == [nothing]
#@test square_trip(["~m-6106017600000","~m0","~m946728000000","~m1396909037000"]) == TBD - what do you typically want?
