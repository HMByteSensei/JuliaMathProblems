# using Pkg
# Pkg.add("JuMP")
# Pkg.add("GLPK")

using JuMP
using GLPK

function min_path(W)
    n = size(W, 1)
    bigM = 1e6  # Veliki broj koji predstavlja "beskonačnost"
    model = Model(GLPK.Optimizer)

    # Zamjena Inf vrijednosti s bigM
    W = replace(W, Inf => bigM)

    # Definišemo varijable
    @variable(model, x[1:n, 1:n], Bin)

    # Definišemo ciljnu funkciju
    @objective(model, Min, sum(W[i, j] * x[i, j] for i in 1:n, j in 1:n))

    # Dodajemo ograničenja
    @constraint(model, sum(x[1, j] for j in 2:n) == 1)  # Početni čvor
    @constraint(model, sum(x[i, n] for i in 1:n-1) == 1)  # Završni čvor
    for k in 2:n-1
        @constraint(model, sum(x[i, k] for i in 1:n if i != k) == sum(x[k, j] for j in 1:n if j != k))
    end

    # Ograničenja za sprječavanje povratka na prethodne čvorove
    for i in 1:n
        for j in 1:n
            if i != j
                @constraint(model, x[i, j] + x[j, i] <= 1)
            end
        end
    end

    # Rješavamo model
    optimize!(model)

    # Provjeravamo status rješenja
    if termination_status(model) != MOI.OPTIMAL
        error("Optimalno rješenje nije pronađeno")
    end

    # Izvlačimo rješenje
    T = []
    for i in 1:n
        for j in 1:n
            if value(x[i, j]) > 0.5
                push!(T, [i, j])
            end
        end
    end

    V = objective_value(model)
    return T, V
end
# Radio Muhamed Husić
# Testiranje
W = [0 2 3 Inf 8 Inf Inf Inf; 2 0 4 Inf 9 Inf Inf Inf; 3 4 0 7 Inf Inf Inf Inf; Inf Inf 7 0 4 3 Inf Inf; 8 Inf Inf 4 0 5 5 Inf; Inf 9 Inf 3 5 0 7 6; Inf Inf Inf Inf 5 7 0 1; Inf Inf Inf Inf Inf 6 1 0]
T, V = min_path(W)
println("T =")
println(T)
println("V =")
println(V)
