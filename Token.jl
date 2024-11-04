include("TokenType.jl")

struct Token
    type::TokenType
    lexeme::String
    literal::Any
    line::Int64
end

function to_string(token::Token)
    string(token.type, " ", token.lexeme, " ", token.literal)
end
