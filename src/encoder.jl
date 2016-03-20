module Transit
  function encode(e::Emitter, s::AbstractString)
    println("string: ", s)
  end

  function encode(e::Emitter, i::Integer)
    println("number:", i)
  end

  function encode(e::Emitter, i::Rational)
    println("rational:", i)
  end

  function encode(e::Emitter, a::Array)
    println("array:  ", a)
    println("array:  ", a[1])
  end
end

