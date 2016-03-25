    function encodeValue(e::Encoder, s::AbstractString, as_key::Bool)
        startswith(s, "~") ? emit(e.emitter, "~$s") : emit(e.emitter, s)
    end

    function encodeValue(e::Encoder, s::Symbol, as_key::Bool)
        emit(e.emitter, "~:$s")
    end

    function encodeValue(e::Encoder, ts::TSymbol, as_key::Bool)

        emit(e.emitter, "~\$$(ts.s)")
    end

    function encodeValue(e::Encoder, b::Bool, as_key::Bool)
        emit(e.emitter, b ? "~?t" : "~?f")
    end

    function encodeValue(e::Encoder, b::Char, as_key::Bool)
        emit(e.emitter, "~c$c")
    end

    function encodeValue(e::Encoder, u::URI, as_key::Bool)
        s = string(u)
        emit(e.emitter, "~e$s")
    end
    
    function encodeValue(e::Encoder, b::Void, as_key::Bool)
        emitNil(e.emitter, as_key)
    end
    
    function encodeValue(e::Encoder, i::Integer, as_key::Bool)
        if as_key
            emit(e.emitter, "~i$i")
        elseif (i < JSON_MAX_INT && i > JSON_MIN_INT)
            emit(e.emitter, i)
        else
            emit(e.emitter, "~i$i")
        end
    end

    function encodeSpecialFloat(emitter::Emitter, x::AbstractFloat)
        if isnan(x)
            emit(emitter, "~zNaN")
        elseif x == Inf
            emit(emitter, "~zINF")
        elseif x == -Inf
            emit(emitter, "~z-INF")
        else
            return false
        end
        return true
    end

    function encodeValue(e::Encoder, x::BigFloat, as_key::Bool)
        if !encodeSpecialFloat(e.emitter, x)
            let s = string(x)
                emit(e.emitter, "~z$s")
            end
        end
    end

    function encodeValue(e::Encoder, x::AbstractFloat, as_key::Bool)
        if !encodeSpecialFloat(e.emitter, x)
            if as_key
                 emit(e.emitter, "~f$x")
             else
                 emitRaw(e.emitter, string(x))
             end
        end
    end

    function encodeValue(e::Encoder, r::Rational, as_key::Bool)
        emitArrayStart(e.emitter)

        emit(e.emitter, "ratio")
        emitArraySep(e.emitter)

        emitArrayStart(e.emitter)
        encode(e, num(r), false)
        emitArraySep(e.emitter)
        encode(e, den(r), false)
        emitArrayEnd(e.emitter)

        emitArrayEnd(e.emitter)
    end


    function encodeValue(e::Encoder, a::AbstractArray, as_key::Bool)
        emitArrayStart(e.emitter)

        for (i, x) in enumerate(a)
            emitArraySep(e.emitter, i)
            encode(e, x, false)
        end

        emitArrayEnd(e.emitter)
    end

    function encodeValue(e::Encoder, x::Any, as_key::Bool)
        println("Don't know what to do with:", x, " of type ", typeof(x), ".")
    end
