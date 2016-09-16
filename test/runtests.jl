using CurryPipe
using Base.Test
import CurryPipe: startswith, is_pipe_call, is_fun_call, curry


@testset "startswith" begin
    @test startswith([1,2], 1)
    @test !startswith([1,2], 2)
    @test !startswith([], 1)
end

@testset "is_pipe_call" begin
    @test is_pipe_call( :(x |> f) )
    @test is_pipe_call( :(x |> f(34) |> g(z,y)) )
    @test !is_pipe_call( :(f(x)) )
    @test !is_pipe_call(:x)
end

@testset "is_fun_call" begin
    @test !is_fun_call( :(x |> f) )
    @test is_fun_call( :(g(z,y)) )
    @test is_fun_call( :(f(x)) )
    @test !is_fun_call( :((1,2)))
end

@testset "curry" begin
    @test :(x |> f)            |> curry == :(f(x))
    @test :(x |> f |> g)       |> curry == :(g(f(x)))
    @test :x                   |> curry == :x
    @test :(3)                 |> curry == :(3)
    @test :(x |> g(y))         |> curry == :(g(y,x))
    @test :( f(x) |> g(y, z))  |> curry == :(g(y,z,f(x)))
    @test :(3 |> sin |> +(2))  |> curry == :(2 + sin(3))

    @testset "curry _" begin
        @test :(x |> f(_, y)) |> curry == :(f(x,y))
        @test :(x |> f(a, _, _) |> g(_, z)) |> curry == :(g(f(a,x,x),z))
    end
end

@testset "@curry, @c" begin
    @test macroexpand(:(@curry x |> f(y) |> g(z))) == :(g(z,f(y,x)))
    @test 5 == @curry 2 |> +(3)
    @test (2+1) * (2+1) == @c 2 |> _ + 1 |> _ * _
end
