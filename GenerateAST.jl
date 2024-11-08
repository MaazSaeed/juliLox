#import Pkg; Pkg.add("MacroTools");
module astgenerator
include("Token.jl")
include("TokenType.jl")

using MacroTools

abstract type Expr end

macro genexpr(type, fields...)
    field_pairs = [:($(field.args[1])::$(field.args[2])) for field in fields]
    
    expr = quote
        struct $(esc(type)) <: Expr
            $(field_pairs...)
        end
    end

    # For debugging purposes
    # @show expr 

    expr
end

@genexpr Binary left::Expr operator::Token right::Expr
end



