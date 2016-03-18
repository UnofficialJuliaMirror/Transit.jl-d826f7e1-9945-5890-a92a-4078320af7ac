type Encoder

end

function encode(e::Encoder, s::AbstractString)
  println("string: ", s)
end

function encode(e::Encoder, i::Integer)
  println("number:", i)
end

function encode(e::Encoder, i::Rational)
  println("rational:", i)
end

function encode(e::Encoder, a::Array)
  println("array:  ", a)
  println("array:  ", a[1])
end
