include("Lexer.jl")
include("Parser.jl")

lexer = Lexer("3 + 4 / 2 - 6 + 7 / 9", Vector{Token}(), 1, 1, 1)
scan_tokens(lexer)
println(lexer.tokens)

parser = Parser(lexer.tokens, 1)
parse(parser)