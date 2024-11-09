include("Token.jl")
include("TokenType.jl")

struct Parser
    tokens::AbstractVector{Token}
end

function expression() end
function equality() end
function match() end
function check() end
function advance() end
function is_at_end() end
function peek() end
function previous() end
function comparison() end
function term() end
function factor() end
function unary() end
function primary() end