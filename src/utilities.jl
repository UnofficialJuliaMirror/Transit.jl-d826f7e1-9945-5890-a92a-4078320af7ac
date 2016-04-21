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
