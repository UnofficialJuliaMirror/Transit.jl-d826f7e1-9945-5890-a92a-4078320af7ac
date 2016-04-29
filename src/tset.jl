import Base.in
import Base.==
import Base.length
import Base.start
import Base.done
import Base.next
import Base.string
import Base.enumerate

immutable TSet
    dict::Dict{Array{Any},Any}

    TSet() = new(Dict{Array{Any},Any}())
    TSet(itr) = new([Any[x, typeof(x)] => x for x in itr])
end

in(x, s::TSet) = haskey(s.dict, Any[x, typeof(x)])
==(s::TSet, t::TSet) = ==(s.dict, t.dict)
length(s::TSet) = length(s.dict)
start(s::TSet) = start(s.dict)
done(s::TSet, state::Any) = done(s.dict, state)
next(s::TSet, x::Any) = next(s.dict, x)
enumerate(s::TSet) = enumerate(values(s.dict))
string(s::TSet) = "TSet($(join(map(string,(values(s.dict))), ",")))"
