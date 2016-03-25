function startswith(str::AbstractString, pat::AbstractString)
  start(search(str, pat)) == 1
end

function constantly(value)
  function(_...)
    value
  end
end
