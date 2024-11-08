module astgenerator
using MacroTools

export @generateast  # Make visible outside module

abstract type Expr end

# Output the file to the current directory
file_path = joinpath(pwd(), "Expr.jl") 

macro generateast(exprs)
    expressions = []
    
    open(file_path, "w") do file
        write(file, "abstract type Expr end\n\n")
    end
    
    for expr in expressions
        expr_and_fields = strip.(split(expr, ":"))
        
        type = expr_and_fields[1]
        fields = expr_and_fields[2]

        # Split fields into pairs
        fields = strip.(split(fields, ","))
        
        field_pairs = [
                        quote 
                            field_name = split(f, " ")[2]
                            field_type = split(f, " ")[1]

                            :($(Symbol(field_name))::($(Symbol(field_type))))
                        end

                        for f in fields]

        type_expr = :(
            struct $(Symbol(type)) <: Expr
                $(field_pairs...)
            end
        )

        # Convert to string
        gen_code = string(type_expr)

        # Append to the file
        open(file_path, "a") do file
            write(file, gen_code * "\n\n")
        end

        println("Generated $type node! Appended to: $file_path")
    end
    
    nothing
end

end

using .astgenerator

@generateast [
                "Binary : Expr left, Token operator, Expr right",
                "Grouping : Expr expressions",
                "Literal : Any value",
                "Unary : Token operator, Expr right"
             ]