module Transit
  using JSON

  type Decoder
    handlers::Map{AbstractString,Function}
  end

  function decode(io::IO, verbose=false)
    from_json = JSON.parse(io)
  end


end
