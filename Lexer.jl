using Match
include("TokenType.jl")
include("Token.jl")

mutable struct Lexer
    source::String       # Source code
    tokens::Vector{Token} # To be filled with tokens
    start::Int64
    current::Int64
    line::Int64
end

function scan_tokens(lexer::Lexer)
    while !is_at_end(lexer)
        lexer.start = lexer.current
        scan_token(lexer)
    end
end

function scan_token(lexer::Lexer)
    ch = advance!(lexer)

    @match ch begin
        '(' => add_token(lexer, LEFT_PAREN)
        ')' => add_token(lexer, RIGHT_PAREN)
        '{' => add_token(lexer, LEFT_BRACE)
        '}' => add_token(lexer, RIGHT_BRACE)
        ',' => add_token(lexer, COMMA)
        '.' => add_token(lexer, DOT)
        '-' => add_token(lexer, MINUS)
        '+' => add_token(lexer, PLUS)
        ';' => add_token(lexer, SEMICOLON)
        '*' => add_token(lexer, STAR)
        _   => nothing 
    end
end

function advance!(lexer::Lexer)
    ch = lexer.source[lexer.current]
    lexer.current += 1
    return ch
end

function is_at_end(lexer::Lexer)
    return lexer.current > length(lexer.source)
end

function add_token(lexer::Lexer, type::TokenType)
    add_token(lexer, type, nothing)
end

function add_token(lexer::Lexer, type::TokenType, literal::Any)
    text = lexer.source[lexer.start:lexer.current - 1]
    push!(lexer.tokens, Token(type, text, literal, lexer.line))
end

# Create an instance of Lexer with an empty tokens array
L = Lexer("(){}*+-;.", Vector{Token}(), 1, 1, 1)

# Scan tokens
scan_tokens(L)

# Print the tokens found
println(L.tokens)
