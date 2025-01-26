function smanji_redove!(M)
    for i in 1:size(M,1)
        mini = minimum(M[i, :])
        M[i, :] .-= mini
    end
    return M
end

function smanji_kolone!(M)
    for j in 1:size(M,2)
        mini = minimum(M[:, j])
        M[:, j] .-= mini
    end
    return M
end

function rasporedi(M)
    # Kopija originalne matrice
    original = copy(M)
    # Prebacivanje u realne brojeve
    M = Float64.(M)
    
    # 1. Redukcija po redovima
    smanji_redove!(M)
    # 2. Redukcija po kolonama
    smanji_kolone!(M)

    n = size(M,1)
    raspored = zeros(Int, n, n)

    # 3. Dok ima nula u M
    while count(==(0), M) > 0
        # Jedinstvena nula u redu
        for i in 1:n
            cols = findall(x -> x == 0, M[i, :])
            if length(cols) == 1
                j = cols[1]
                raspored[i, j] = 1
                M[i, :] .= Inf
                M[:, j] .= Inf
            end
        end
        
        # Jedinstvena nula u koloni
        for j in 1:n
            rows = findall(x -> x == 0, M[:, j])
            if length(rows) == 1
                i = rows[1]
                raspored[i, j] = 1
                M[i, :] .= Inf
                M[:, j] .= Inf
            end
        end
    end
    
    # 4. Izračunavanje vrijednosti cilja
    Z = sum(raspored .* original)
    return raspored, Z
end

# Primjer testiranja
# Prvi test
M = [80 20 23; 31 40 12; 61 1 1]

raspored, Z = rasporedi(M)
println("Matrica raspored:")
display(raspored)
println("\nVrijednost funkcije cilja Z: ", Z)

# Drugi test
M = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65]

raspored, Z = rasporedi(M)
println("Matrica raspored:")
display(raspored)
# println(raspored)
println("\nVrijednost funkcije cilja Z: ", Z)
