  import JSON

  type Emitter
    io::IO
  end

  function emit_raw(e::Emitter, s::AbstractString)
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
  function emit_null(e::Emitter)
    JSON.print(e.io, nothing)
  end

  function emit_array_start(e::Emitter)
    print(e.io, "[")
  end

  function emit_array_end(e::Emitter)
    println(e.io, "]")
  end

  function emit_array_sep(e::Emitter, i=2)
    if i != 1
      print(e.io, ", ")
    end
  end
