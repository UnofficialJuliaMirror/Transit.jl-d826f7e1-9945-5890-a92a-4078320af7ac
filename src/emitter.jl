module Transit
  import JSON

  type Emitter
    io::IO
  end

  function emit(e::Emitter, s::AbstractString)
    JSON.print(e.io, s)
  end

  function emit(e::Emitter, i::Integer)
    JSON.print(e.io, i)
  end

  function emitNull(e::Emitter)
    JSON.print(e.io, nothing)
  end

  function emitArrayStart(e::Emitter)
    println(e.io, "[")
  end

  function emitArrayEnd(e::Emitter)
    println(e.io, "]")
  end

  function emitArraySep(e::Emitter)
    println(e.io, ", ")
  end

  function emitArrayElement(e::Emitter, el::Any, i::Integer=1)
	if index != 1
		emitArraySep(e)
	end
	emit(el)
  end
end
