mutable struct NoopCache
end

function write!(rc::RollingCache, name::AbstractString)
  name
end
