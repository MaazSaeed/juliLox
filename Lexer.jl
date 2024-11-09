using Match
include("TokenType.jl")
include("Token.jl")

const RESERVED_WORDS = Dict(
    "and" => AND,
    "class" => CLASS,
    "else" => ELSE,
    "false" => FALSE,
    "for" => FOR,
    "fun" => FUN,
    "if" => IF,
    "nil" => NIL,
    "or" => OR,
    "print" => PRINT,
    "return" => RETURN,
    "super" => SUPER,
    "this" => THIS,
    "true" => TRUE,
    "var" => VAR,
    "while" => WHILE
)

mutable struct Lexer
    source::String
    tokens::Vector{Token}
    start::Int
    current::Int
    line::Int
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
        '/' => if match(lexer, '/')
                   while peek(lexer) != '\n' && !is_at_end(lexer)
                       advance!(lexer)
                   end
               else
                   add_token(lexer, SLASH)
               end
        ' ' => nothing
        '\r' => nothing
        '\t' => nothing
        '\n' => (lexer.line += 1; nothing)
        '"' => string(lexer)
        _   => if is_digit(ch)
                   number(lexer)
               elseif is_alpha(ch)
                   identifier(lexer)
               else
                   error("Unexpected character.")
               end
    end
end

function is_alpha(ch::Char)
    ch in 'a':'z' || ch in 'A':'Z' || ch == '_'
end

function identifier(lexer::Lexer)
    while is_alpha_numeric(peek(lexer))
        advance!(lexer)
    end
    text = lexer.source[lexer.start : lexer.current - 1]
    type = get(RESERVED_WORDS, text, IDENTIFIER) # IDENTIFIER as fallback if the given identifier is not in the RESERVED_WORDS
    add_token(lexer, type)
end

function is_alpha_numeric(ch::Char)
    is_alpha(ch) || is_digit(ch)
end

function is_digit(ch::Char)
    ch in '0':'9'
end

function number(lexer::Lexer)
    while is_digit(peek(lexer))
        advance!(lexer)
    end

    if peek(lexer) == '.' && is_digit(peek_next(lexer))
        advance!(lexer)
        while is_digit(peek(lexer))
            advance!(lexer)
        end
    end

    number_str = lexer.source[lexer.start : lexer.current - 1]
    add_token(lexer, NUMBER, Base.parse(Float64, number_str))
end

function peek_next(lexer::Lexer)
    if lexer.current + 1 > length(lexer.source)
        return '\0'
    end
    lexer.source[lexer.current + 1]
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
    advance!(lexer)
    true
end

function advance!(lexer::Lexer)
    ch = lexer.source[lexer.current]
    lexer.current += 1
    ch
end

function is_at_end(lexer::Lexer)
    lexer.current > length(lexer.source)
end

function add_token(lexer::Lexer, type::TokenType, literal::Any = nothing)
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
        #error("Unterminated string.")
        return
    end

    advance!(lexer)
    value = lexer.source[lexer.start + 1 : lexer.current - 2]
    add_token(lexer, STRING, value)
end
#=
# Create an instance of Lexer with an empty tokens array
L = Lexer("(3 * 2) / 6", Vector{Token}(), 1, 1, 1)

# Scan tokens
scan_tokens(L)

# Print the tokens found
println(L.tokens)
=#