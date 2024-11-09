#import Pkg; Pkg.add("Revise")

module astgenerator
using MacroTools
using Revise

export @generateast # Make visible outside module

# Output file path
file_path = joinpath(pwd(), "Expr.jl")

macro generateast(exprs)
    open(file_path, "w") do file
        write(file, "abstract type Expr end\n\n")
    end

    # Loop over each entry in `exprs`
    for expr in exprs.args
        # Parse each element of the expression list
        expr_str = String(expr)

        expr_and_fields = strip.(split(expr_str, ":"))
        type = expr_and_fields[1]
        fields_str = expr_and_fields[2]

        # Split fields into pairs
        fields = strip.(split(fields_str, ","))

        field_pairs = [
            :( $(Symbol(split(field, " ")[2]))::$(Symbol(split(field, " ")[1])) )
            for field in fields
        ]

        type_expr = :(
            struct $(Symbol(type)) <: Expr
                $(field_pairs...)
            end
        )

        # Write each node to the file
        open(file_path, "a") do file
            write(file, replace(string(type_expr), r"#=.*=#" => "") * "\n\n")
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
