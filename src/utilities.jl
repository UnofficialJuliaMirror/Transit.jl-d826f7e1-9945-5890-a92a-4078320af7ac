function startswith(str::AbstractString, pats...)
    for pat in pats
        if start(search(str, pat)) == 1
            return true
        end
    end
    false
end

function constantly(value)
    function(_...)
        value
    end
end

function tolist(a::AbstractArray)
  l = list()
  for item in a
    l = cons(item, l)
  end
  reverse(l)
end

