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
        if check(parser, type)
            advance(parser)
            return true
        end
    end

    false
end

function check(parser::Parser, type::TokenType) 
    if is_at_end(parser)
        return false
    end

    peek(parser).type == type
end

function advance(parser::Parser) 
    if !is_at_end(parser)
        parser.current += 1
    end

    previous(parser)
end


function is_at_end(parser::Parser)
    peek(parser).type == EOF 
end

function peek(parser::Parser) 
    parser.tokens[parser.current]
end


function previous(parser::Parser) 
    parser.tokens[parser.current - 1]
end

function comparison(parser::Parser) 
    expr = term(parser)

    while match(parser, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL)
        operator = previous(parser)
        right = term(parser)
        expr = Binary(expr, operator, right)
    end

    expr
end

function term(parser::Parser) 
    expr = factor(parser)

    while match(parser, MINUS, PLUS)
        operator = previous(parser)
        right = factor(parser)
        expr = Binary(epxr, operator, right)
    end

    expr 
end


function factor(parser::Parser) 
    expr = unary(parser)

    while match(parser, SLASH, STAR)
        operator = previous(parser)
        right = unary(parser)
        expr = Binary(expr, operator, right)
    end

    expr 
end

function unary(parser::Parser) 
    if match(parser, BANG, MINUS)
        operator = previous(parser)
        right = unary(parser)
        return Unary(operator, right)
    end

    primary(parser)
end

function primary(parser::Parser) 
    if match(parser, FALSE) return Literal(false) end
    if match(parser, TRUE) return Literal(true) end
    if match(parser, NIL) return Literal(nothing) end
    
    if match(parser, NUMEBR, STRING)
        return Literal(previous(parser).literal)
    end

    if match(parser, LEFT_PAREN)
        expr = expression(parser)
        consume(parser, RIGHT_PAREN, "Expect ')' after expression.")
        Grouping(expr)

        return expr
    end
end

function consume(parser::Parser, type::Token, msg::String) end