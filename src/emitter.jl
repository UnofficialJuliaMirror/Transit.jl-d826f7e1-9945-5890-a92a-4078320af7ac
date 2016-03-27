  import JSON

  type Emitter
    io::IO
  end

  function emit_raw(e::Emitter, s::AbstractString)
    print(e.io, s)
  end

  function emit_tag(e::Emitter, x::AbstractString)
    emit(e, "~$x")
  end

  function emit(e::Emitter, x::AbstractString)
    print(e.io, JSON.json(x))
  end

  function emit(e::Emitter, x::Integer)
    print(e.io, JSON.json(x))
  end

  function emit_null(e::Emitter)
    print(e.io, "null ")
  end

  function emit_array_start(e::Emitter)
    print(e.io, "[")
  end

  function emit_array_end(e::Emitter)
    print(e.io, "] ")
  end

  function emit_array_sep(e::Emitter, i=2)
    if i != 1
      print(e.io, ", ")
    end
  end
