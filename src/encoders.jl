    function encode_value(e::Encoder, s::AbstractString, as_key::Bool)
        startswith(s, "~") ? emit(e.emitter, "~$s") : emit(e.emitter, s)
    end

    function encode_value(e::Encoder, s::Symbol, as_key::Bool)
        emit(e.emitter, "~:$s")
    end

    function encode_value(e::Encoder, ts::TSymbol, as_key::Bool)

        emit(e.emitter, "~\$$(ts.s)")
    end

    function encode_value(e::Encoder, b::Bool, as_key::Bool)
        emit(e.emitter, b ? "~?t" : "~?f")
    end

    function encode_value(e::Encoder, b::Char, as_key::Bool)
        emit(e.emitter, "~c$c")
    end

    function encode_value(e::Encoder, u::URI, as_key::Bool)
        s = string(u)
        emit(e.emitter, "~e$s")
    end
    
    function encode_value(e::Encoder, b::Void, as_key::Bool)
        emit_nil(e.emitter, as_key)
    end
    
    function encode_value(e::Encoder, i::Integer, as_key::Bool)
        if as_key
            emit(e.emitter, "~i$i")
        elseif (i < JSON_MAX_INT && i > JSON_MIN_INT)
            emit(e.emitter, i)
        else
            emit(e.emitter, "~i$i")
        end
    end

    function encode_special_float(emitter::Emitter, x::AbstractFloat)
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

    function encode_value(e::Encoder, x::BigFloat, as_key::Bool)
        if !encode_special_float(e.emitter, x)
            let s = string(x)
                emit(e.emitter, "~z$s")
            end
        end
    end

    function encode_value(e::Encoder, x::AbstractFloat, as_key::Bool)
        if !encode_special_float(e.emitter, x)
            if as_key
                 emit(e.emitter, "~f$x")
             else
                 emit_raw(e.emitter, string(x))
             end
        end
    end

    function encode_value(e::Encoder, r::Rational, as_key::Bool)
        emit_array_start(e.emitter)

        emit(e.emitter, "ratio")
        emit_array_sep(e.emitter)

        emit_array_start(e.emitter)
        encode(e, num(r), false)
        emit_array_sep(e.emitter)
        encode(e, den(r), false)
        emit_array_end(e.emitter)

        emit_array_end(e.emitter)
    end


    function encode_value(e::Encoder, a::AbstractArray, as_key::Bool)
        emit_array_start(e.emitter)

        for (i, x) in enumerate(a)
            emit_array_sep(e.emitter, i)
            encode(e, x, false)
        end

        emit_array_end(e.emitter)
    end

    function encode_value(e::Encoder, x::Any, as_key::Bool)
        println("Don't know what to do with:", x, " of type ", typeof(x), ".")
    end
