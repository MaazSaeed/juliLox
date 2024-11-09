include("TokenType.jl")
include("Token.jl")
include("Expr.jl")

abstract type astPrinter end
struct prettyPrinting <: astPrinter end

accept(expr::Binary, visitor::astPrinter) = visitNode(visitor, expr)
accept(expr::Unary, visitor::astPrinter) = visitNode(visitor, expr)
accept(expr::Grouping, visitor::astPrinter) = visitNode(visitor, expr)
accept(expr::Literal, visitor::astPrinter) = visitNode(visitor, expr)

function parenthesize(name, exprs...)
    lisptified = "($(name)"
    for expr in exprs 
        lisptified *= " "
        lisptified *= accept(visitor, expr)
    end
    lisptified *= ")"
end

function visitNode(visitor::prettyPrinting, expr::Unary) 
    parenthesize(visitor, expr.operator.lexeme, expr.right)
end

function visitNode(visitor::prettyPrinting, expr::Literal)
    expr.value === nothing ? "nil" : "$(expr.value)"
end

function visitNode(visitor::prettyPrinting, expr::Grouping)
    parenthesize(visitor, "group", expr.expressions)
end

function visitNode(visitor::prettyPrinting, expr::Binary)
    parenthesize(visitor, expr.operator.lexeme, expr.left, expr.right)
end

function print(expr::Expr)
    accept(expr, prettyPrinting())
end

expr = Binary(
    Unary(
        Token(MINUS, "-", nothing, 1),
        Literal(123)
    ),
    Token(STAR, "*", nothing, 1),
    Grouping(
        Literal(45.67)
    )
)

print(expr)