type Encoder
    encoder_functions
    encodes_to_string
    emitter::Emitter

    Encoder(io) = new(Dict{DataType,Function}(), Dict{DataType,Bool}(), Emitter(io))
end

function add_encoder(e::Encoder, t::DataType, f::Function, encodes_to_string::Bool)
    e.encoder_functions[t] = f
    e.encodes_to_string[t] = encodes_to_string
end

function encode(e::Encoder, x::Any, as_key::Bool)
    if haskey(e.encoder_functions, typeof(x))
        e.encoder_functions[typeof(x)](e, x, as_key)
    else
        encode_value(e, x, as_key)
    end
end

function encodes_to_string(e::Encoder, x::Any)
    let t = typeof(x)
        if haskey(e.encoder_functions, t)
            e.encodes_to_string[t](e, x)
        else
            encodes_to_string(e, x)
        end
    end
end

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

function encode_value(e::Encoder, u::Base.Random.UUID, as_key::Bool)
    s = string(u)
    emit(e.emitter, "~u$s")
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

function encode_value(e::Encoder, x::BigInt, as_key::Bool)
    let s = string(x)
      emit(e.emitter, "~n$s")
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

function encode_iterator(e::Encoder, iter)
    for (i, x) in iter
        emit_array_sep(e.emitter, i)
        encode(e, x, false)
    end
end

function encode_tagged_enumerable(e::Encoder, tag::AbstractString, iter)
    emit_array_start(e.emitter)
    emit_tag(e.emitter, tag)
    emit_array_sep(e.emitter)

    emit_array_start(e.emitter)
    encode_iterator(e, iter) 
    emit_array_end(e.emitter)
    emit_array_end(e.emitter)
end

function encode_value(e::Encoder, a::AbstractArray, as_key::Bool)
    emit_array_start(e.emitter)
    encode_iterator(e, enumerate(a))
    emit_array_end(e.emitter)
end

function encodes_to_string(e::Encoder, x::AbstractArray)
    false
end

function encode_value(e::Encoder, r::Rational, as_key::Bool)
    encode_tagged_enumerable(e, "ratio", enumerate([num(r), den(r)]))
end

function encodes_to_string(e::Encoder, x::Rational)
    false
end

function encode_value(e::Encoder, x::DateTime, as_key::Bool)
    let millis = trunc(Int64, Dates.datetime2unix(x)) * 1000
        emit(e.emitter, "~m$millis")
    end
end

function encode_value(e::Encoder, x::Date, as_key::Bool)
    encode_value(e, DateTime(x), as_key)
end

function encode_value(e::Encoder, x::Tuple, as_key::Bool)
    encode_tagged_enumerable(e, "list", enumerate(x))
end

function encodes_to_string(e::Encoder, x::Tuple)
    false
end

function encode_value(e::Encoder, x::Set, as_key::Bool)
    encode_tagged_enumerable(e, "set", enumerate(x))
end

function encodes_to_string(e::Encoder, x::Set)
    false
end

function encode_value(e::Encoder, x::Link, as_key::Bool)
    let a = [x.href, x.rel, x.name, x.prompt, x.render]
        encode_tagged_enumerable(e, "link", enumerate(a))
    end
end

function encodes_to_string(e::Encoder, x::Link)
    false
end

function encode_value(e::Encoder, x::TaggedValue, as_key::Bool)
    emit_array_start(e.emitter)
    emit_tag(e.emitter, x.tag)
    emit_array_sep(e.emitter)
    encode(e, x.value, false)
    emit_array_end(e.emitter)
end

function encodes_to_string(e::Encoder, x::TaggedValue)
    false
end

function has_stringable_keys(e::Encoder, x::Dict)
    for k in keys(x)
	if ! encodes_to_string(e, k)
            return false
        end
    end
    true
end

function encode_map(e::Encoder, tag::AbstractString, x::Dict, as_key::Bool)
    emit_array_start(e.emitter)
    emit_tag(e.emitter, tag)

    for (k, v) in x
        emit_array_sep(e.emitter)
        encode_value(e, k, true)
        emit_array_sep(e.emitter)
        encode_value(e, v, false)
    end
    emit_array_end(e.emitter)
end

function encode_value(e::Encoder, x::Dict, as_key::Bool)
    if has_stringable_keys(e, x)
        encode_map(e, "map", x, as_key)
    else
        encode_map(e,"cmap",  x, as_key)
    end
end

function encode_value(e::Encoder, x::Dict{AbstractString}, as_key::Bool)
    encode_map(e, "map", x, as_key)
end

function encode_value(e::Encoder, x::Dict{Symbol}, as_key::Bool)
    encode_map(e, "map", x, as_key)
end

function encodes_to_string(e::Encoder, x::Dict)
    false
end

# Default encoder raises exception.
function encode_value(e::Encoder, x::Any, as_key::Bool)
    throw(ArgumentError("Don't know how to encode: $x of type $(typeof(x))."))

end

# Default is to claim we do encode to string.
function encodes_to_string(e::Encoder, x::Any)
    true
end
