import Base: peek

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

    push!(lexer.tokens, Token(EOF, "", nothing, lexer.line))
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
        '!' => add_token(lexer, match(lexer, '=') ? BANG_EQUAL : BANG)
        '=' => add_token(lexer, match(lexer, '=') ? EQUAL_EQUAL : EQUAL)
        '<' => add_token(lexer, match(lexer, '=') ? LESS_EQUAL : LESS)
        '>' => add_token(lexer, match(lexer, '=') ? GREATER_EQUAL : GREATER)
        '/' =>  if match(lexer, '/')
                 while peek(lexer) != '\n' && !is_at_end(lexer)
                    advance!(lexer)
                 end
                else 
                    add_token(lexer, SLASH)
                end
        ' ' => nothing
        '\r' => nothing
        '\t' => nothing
        '\n' => let 
                lexer.line += 1; 
                nothing;
            end
        '"' => string(lexer)

        _   => error("Unexpected character on line.")
    end
end

function peek(lexer::Lexer)
    if is_at_end(lexer) return '\0' end
    lexer.source[lexer.current]
end

function match(lexer::Lexer, expected::Char)
    if is_at_end(lexer) return false end
    if lexer.source[lexer.current] != expected
         return false
     end

    advance!(lexer) # Consume the character
    return true
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
    text = lexer.source[lexer.start : lexer.current - 1]
    push!(lexer.tokens, Token(type, text, literal, lexer.line))
end

function string(lexer::Lexer)
    while peek(lexer) != '"' && !is_at_end(lexer)
        if peek(lexer) == '\n'
            lexer.line += 1
        end
        advance!(lexer)
    end

    if is_at_end(lexer)
        error("Unterminated string.")
        return
    end

    advance!(lexer) # Consume the closing pair '"'

    value = lexer.source[lexer.start + 1 : lexer.current - 2]
    
    add_token(lexer, STRING, value) 
end

# Create an instance of Lexer with an empty tokens array
L = Lexer(" \"well well well\" ", Vector{Token}(), 1, 1, 1)

# Scan tokens
scan_tokens(L)

# Print the tokens found
println(L.tokens)
