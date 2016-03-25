  import JSON

  type Emitter
    io::IO
  end

  function emitRaw(e::Emitter, s::AbstractString)
    print(e.io, s)
  end

  function emit(e::Emitter, s::AbstractString)
    JSON.print(e.io, s)
  end

  function emit(e::Emitter, i::Integer)
    JSON.print(e.io, i)
  end

  # TBD: Can this just be emit(e, v::Void)
  # That is, are there any other instances of Void besides nothing?
  function emitNull(e::Emitter)
    JSON.print(e.io, nothing)
  end

  function emitArrayStart(e::Emitter)
    print(e.io, "[")
  end

  function emitArrayEnd(e::Emitter)
    println(e.io, "]")
  end

  function emitArraySep(e::Emitter, i=2)
    if i != 1
      print(e.io, ", ")
    end
  end
