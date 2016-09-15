__precompile__()
module CurryPipe
export @curry

startswith(iter, el) = (length(iter) > 0) && (first(iter) == el)

is_pipe_call(expr::Expr) = (expr.head == :call) && startswith(expr.args, :|> )
is_pipe_call(x) = false

is_fun_call(x) = false
is_fun_call(expr::Expr) = (expr.head == :call) && !(is_pipe_call(expr))

curry(x) = x
function curry(expr::Expr)
    expr = copy(expr)
    if is_pipe_call(expr)
        @assert length(expr.args) == 3
        _, h, t = expr.args
        if is_fun_call(t)
            push!(t.args, curry(h))  # curry h
            return t
        else
            return Expr(:call, t, curry(h))  # curry h
        end
    end
    expr
end

macro curry(expr)
    expr |> curry |> esc
end

end # module
