__precompile__()

module Includes

export @include_once

mtimes = Dict{String,Float64}()

macro include_once(file::String)
    mt = mtime(file);
    if mt > get!(mtimes, file, 0)
        mtimes[file] = mt
        return :( include($file) )
    elseif mt == 0
        error("File $file does not exist")
    else
        return
    end
end

end