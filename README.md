# CurryPipe

Usage
```
julia> using CurryPipe
julia> @curry 1:10 |> filter(isodd, _) |> map(x -> x^2, _)
5-element Array{Int64,1}:
  1
  9
 25
 49
 81
```
If the `_` are the last arguments of a function, they can be omitted. Thus the above code
is equivalent to:
```
julia> @curry 1:10 |> filter(isodd) |> map(x -> x^2)
5-element Array{Int64,1}:
  1
  9
 25
 49
 81
```
Finally it is possible to abbreviate `@curry` with `@c`.
```
julia> @c 1:10 |> filter(isodd) |> map(x -> x^2)
5-element Array{Int64,1}:
  1
  9
 25
 49
 81
```
