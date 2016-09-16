__precompile__()
module CurryPipe
export @curry, @c

const _ = :_

startswith(iter, el) = (length(iter) > 0) && (first(iter) == el)

is_pipe_call(expr::Expr) = (expr.head == :call) && startswith(expr.args, :|> )
is_pipe_call(x) = false

is_fun_call(x) = false
is_fun_call(expr::Expr) = (expr.head == :call) && !(is_pipe_call(expr))

function replace!(arr, old_el, new_el)
    for i in eachindex(arr)
        if arr[i] == old_el
            arr[i] = new_el
        end
    end
    arr
end

function curry_pipe_call(expr)
    @assert length(expr.args) == 3
    waste, h, t = expr.args
    ch = curry(h)
    if is_fun_call(t)
        if (_ in t.args)
            replace!(t.args, _, ch)
        else
            push!(t.args, ch)
        end
        return t
    else
        return Expr(:call, t, ch)
    end
end

curry(x) = x
function curry(expr::Expr)
    expr = copy(expr)
    if is_pipe_call(expr)
        return curry_pipe_call(expr)
    end
    expr
end

macro curry(expr)
    expr |> curry |> esc
end

macro c(expr)
    expr |> curry |> esc
end

end # module
