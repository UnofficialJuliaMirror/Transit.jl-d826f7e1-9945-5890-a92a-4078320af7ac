module TestEncoder

using Base.Test
using Transit
using JSON

# Convert the value given to transit and then read
# back in the resulting JSON. Not a round trip, since
# we are just reading back in the raw JSON.
function square_trip(x)
    buf = IOBuffer()
    e = Encoder(buf)
    encode(e, x, false)
    s = takebuf_string(buf)
    #println(s)
    JSON.parse(s)
end

@test square_trip(1) == 1
@test square_trip(1.0) == 1.0
@test square_trip("hello") == "hello"
@test square_trip("~hello") == "~~hello"
@test square_trip(true) == "~?t"
@test square_trip(false) == "~?f"
@test square_trip(2//3) == Any["~ratio", Any[2, 3]]
@test square_trip([1,2,3]) == [1,2,3]
@test square_trip((1,2,"hello")) == Any["~list", Any[1,2,"hello"]]
#@test square_trip(Set([1,2,3])) == Any["~set", Any[1,2,3]]

@test square_trip([:hello, :hello, :hello]) == ["~:hello", "^0", "^0"]
@test square_trip([:aaaa, :bbbb, :aaaa, :bbbb]) == ["~:aaaa", "~:bbbb", "^0", "^1"]

symbols = [Transit.TSymbol("hello"), Transit.TSymbol("hello"), Transit.TSymbol("hello")]

@test square_trip(symbols) == ["~\$hello", "^0", "^0"]

@test square_trip([:aaaa, :bbbb, :aaaa, :bbbb]) == ["~:aaaa", "~:bbbb", "^0", "^1"]
end
