function parse(io::IO)
    d = Decoder()
    decode(d, JSON.parse(io))
end
