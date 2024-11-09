abstract type Expr end

struct Binary <: Expr
    
    left::Expr
    operator::Token
    right::Expr
end

struct Grouping <: Expr
    
    expressions::Expr
end

struct Literal <: Expr
    
    value::Any
end

struct Unary <: Expr
    
    operator::Token
    right::Expr
end

