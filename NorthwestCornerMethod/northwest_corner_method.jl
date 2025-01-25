function nadji_pocetno_SZU(C, I, O)
    # Dimenzije matrice troškova
    m, n = size(C)

    # Matrica početnog rješenja
    A = zeros(Int, m, n)

    # Kopije vektora I i O za praćenje preostalog kapaciteta
    I_rem = copy(I)
    O_rem = copy(O)

    # Inicijalizacija indeksa
    i, j = 1, 1

    # Iterativno popunjavanje matrice A
    while i <= m && j <= n
        # Određivanje količine koja se transportuje
        x = min(I_rem[i], O_rem[j])
        A[i, j] = x

        # Ažuriranje preostalih kapaciteta
        I_rem[i] -= x
        O_rem[j] -= x

        # Pomicanje indeksa
        if I_rem[i] == 0
            i += 1
        elseif O_rem[j] == 0
            j += 1
        end
    end

    # Računanje ukupnog troška
    T = sum(A .* C)

    return A, T
end

# Testiranje
C = [
    8 9 4 0;
    6 6 9 5;
    3 5 6 7
]

I = [100, 120, 140]
O = [90, 125, 80, 65]

A, T = nadji_pocetno_SZU(C, I, O)

println("Početna matrica rješenja A:")
println(A)
println("Ukupni troškovi transporta T:")
println(T)

# Test 2
C1 = [4 3 1; 2 5 8; 7 6 9]  
I1 = [30, 40, 20]            
O1 = [20, 50, 20]           

A1, T1 = nadji_pocetno_SZU(C1, I1, O1)
println("Test 2 - Početna matrica rješenja: \n", A1)
println("Test 2 - Optimalna vrijednost funkcije cilja: ", T1)

# Test 3
C2 = [3 2 1 4; 6 5 8 7; 4 3 6 5]  
I2 = [50, 60, 40]                  
O2 = [30, 50, 40, 30]           

A2, T2 = nadji_pocetno_SZU(C2, I2, O2)
println("Test 3 - Početna matrica rješenja: \n", A2)
println("Test 3 - Optimalna vrijednost funkcije cilja: ", T2)
