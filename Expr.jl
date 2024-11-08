# Generated AST types

abstract type Expr end

struct Binary <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:51 =#
    left::Expr
    operator::Token
    right::Expr
end

struct Grouping <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:51 =#
    expressions::Expr
end

struct Literal <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:51 =#
    value::Any
end

struct Unary <: Expr
    #= d:\juox\juliLox\GenerateAST.jl:51 =#
    operator::Token
    right::Expr
end

