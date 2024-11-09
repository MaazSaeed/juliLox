abstract type Expr end

struct Binary <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:36 =#
    left::Expr
    operator::Token
    right::Expr
end

struct Grouping <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:36 =#
    expressions::Expr
end

struct Literal <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:36 =#
    value::Any
end

struct Unary <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:36 =#
    operator::Token
    right::Expr
end

