# import Pkg; 
# Pkg.add("JuMP")
# Pkg.add("GLPK")

using JuMP
using GLPK

function assignment(C::Matrix{<:Real})
    # Broj radnika i mašina
    n, m = size(C)
    
    # Najveća dimenzija (koristi se za kvadratni model)
    d = max(n, m)
    
    # Kreiranje proširene matrice C_expanded
    C_expanded = zeros(d, d)
    for i in 1:n
        for j in 1:m
            C_expanded[i, j] = C[i, j]
        end
    end
    
    model = Model(GLPK.Optimizer)
    
    # Definicija binarnih varijabli x[i,j]
    @variable(model, x[i=1:d, j=1:d], Bin)
    
    # Funkcija cilja
    @objective(model, Min, sum(C_expanded[i,j] * x[i,j] for i in 1:d, j=1:d))
    
    # Ograničenje na radnike (redovi)
    @constraint(model, [i=1:d], sum(x[i,j] for j=1:d) == 1)
    # Ograničenje na mašine (kolone)
    @constraint(model, [j=1:d], sum(x[i,j] for i=1:d) == 1)
    
    optimize!(model)
    
    # Formiranje rješenja X samo za originalnu dimenziju n x m
    X = zeros(Int, n, m)
    for i in 1:n
        for j in 1:m
            if value(x[i,j]) > 0.5
                X[i,j] = 1
            end
        end
    end
    
    # Računanje optimalne vrijednosti troškova
    V = sum(C[i,j]*X[i,j] for i in 1:n, j in 1:m)
    
    return X, V
end

# Testni primjer 1:
C = [3 2 10; 5 8 12; 4 10 5; 7 15 10];
X,V=assignment(C);
println("Matrica rješenja X:")
println(X)
println("Optimalna cijena raspoređivanja: ", V)

# Testni primjer 2 - Tri radnika na četiri radna mjesta:
C = [3 2 5 4; 6 4 7 8; 1 6 3 7]
X,V=assignment(C);
println("Matrica rješenja X:")
println(X)
println("Optimalna cijena raspoređivanja: ", V)

# Testni primjer 3 - Pet izvršilaca i pet radnih mjesta:
C = [11 17 8 16 20; 9 7 12 6 15; 13 16 15 12 16; 21 24 17 28 26; 14 10 12 11 15]
X,V=assignment(C);
println("Matrica rješenja X:")
println(X)
println("Optimalna cijena raspoređivanja: ", V)

# Testni primjer 4 - Raspoređivanje diplomata:
C = [5 8 13 9 11 4 3 12 7; 8 11 12 7 10 6 5 11 9; 7 5 11 6 9 3 2 8 6; 12 9 8 9 10 5 4 10 8; 3 1 4 2 5 6 8 11 6; 12 6 9 6 10 8 7 13 15; 8 1 4 1 5 7 3 10 11; 14 5 8 5 9 12 10 13 11; 6 3 8 2 7 5 9 8 10]
X,V=assignment(C);
println("Matrica rješenja X:")
println(X)
println("Optimalna cijena raspoređivanja: ", V)
