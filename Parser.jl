include("Token.jl")
include("TokenType.jl")

struct Parser
    tokens::AbstractVector{Token}
    current::Int
end

function expression(parser::Parser)
    equality()
end

function equality(parser::Parser)
    expr = comparison(parser)

    while match(parser, BANG_EQUAL, EQUAL_EQUAL)
        operator = previous(parser)
        right = comparison(parser)
        expr = Binary(expr, operator, right)
    end

    expr
end

function match(parser::Parser, types...)
    for type in types 
        if check(type)
end

function check(parser::Parser) end
function advance(parser::Parser) end
function is_at_end(parser::Parser) end
function peek(parser::Parser) end
function previous(parser::Parser) end
function comparison(parser::Parser) end
function term(parser::Parser) end
function factor(parser::Parser) end
function unary(parser::Parser) end
function primary(parser::Parser) end