using LinearAlgebra

function napravi_simplex_tabelu(A, b, c, csigns)
	brRedova = size(A, 1)
	A_next, b_next, c_next = A, b, c
	baza = zeros(brRedova, 1)
	c_next_M = zeros(1, size(c, 2))
	funkcija_M = 0
	artifitial = []

	for i in 1:brRedova

		# Slucaj b_i < 0 
		if (b_next[i] < 0)
			A_next[i, :] = -A_next[i, :]
			b_next[i] = -b_next[i]
			if csigns[i] == -1
				csigns[i] = 1
			elseif csigns[i] == 1
				csigns[i] = -1
			end
		end

		# Dodavanje izravnavajucih (surplas) promjenjivih
		if csigns[i] == -1
			novaCol = zeros(brRedova, 1)
			novaCol[i] = 1
			A_next = [A_next novaCol]
			c_next_M = [c_next_M 0]
			c_next = [c_next 0]
			baza[i] = size(c_next, 2)
		elseif csigns[i] == 1
			novaCol = zeros(brRedova, 1)
			novaCol[i] = -1
			A_next = [A_next novaCol]
			c_next_M = [c_next_M 0]
			c_next = [c_next 0]
		end
	end

	# Dodavanje vjestackih (artifitial) promjenjivih
	for i in 1:brRedova
		if csigns[i] == 1
			novaCol = zeros(brRedova, 1)
			novaCol[i] = 1
			A_next = [A_next novaCol]
			c_next_M = [c_next_M -1]
			c_next = [c_next 0]
			baza[i] = size(c_next, 2)
			c_next_M[:] .= c_next_M[:] .+ A_next[i, :]
			funkcija_M = funkcija_M .+ b_next[i]
			artifitial = [artifitial; size(c_next, 2)]
		elseif csigns[i] == 0
			novaCol = zeros(brRedova, 1)
			novaCol[i] = 1
			A_next = [A_next novaCol]
			c_next_M = [c_next_M -1]
			c_next = [c_next 0]
			baza[i] = size(c_next, 2)
			c_next_M[:] .= c_next_M[:] .+ A_next[i, :]
			funkcija_M = funkcija_M .+ b_next[i]
			artifitial = [artifitial; size(c_next, 2)]
		end
	end

	c_next = [0 c_next]
	c_next_M = [funkcija_M c_next_M]
	ST = [b_next A_next]
	ST = [ST; c_next_M; c_next]
	return ST, baza, artifitial
end

function rijesi_simplex(goal, A, b, c, csigns, vsigns)
	if size(b, 1) != size(A, 1) || size(c, 2) != size(A, 2)
		throw("Dimenzije ulaznih parametara nisu kompatibilne")
	end

	# Slucaj kada je znak varijable "=" ili "<="
	mapa_neog_promj = []
	for i in 1:lastindex(vsigns)
		if vsigns[i] == -1
			A[:, i] *= -1
			c[i] *= -1
		elseif vsigns[i] == 0
			c = [c -c[i]]
			A = [A -A[:, i]]
			push!(mapa_neog_promj, (i, size(A, 2)))

		end
	end

	(simplexTabela, vektorIndeksa, artifitial) = napravi_simplex_tabelu(A, b, c, csigns)
	if goal == "min"
		simplexTabela[end, :] *= -1
	else
		simplexTabela[end-1, 1] = abs(simplexTabela[end-1, 1])
	end

	# Pronalazak maksimalnog M i pronalazak po potrebi max reda koeficijenata
	red_max_koef = deepcopy(simplexTabela[end-1, :])
	popfirst!(red_max_koef)
	(cMax_M, indeksKolone_M) = findmax(red_max_koef)
	indeksKolone_M += 1

	indeksKolone = 0
	predzadnjiRed = simplexTabela[end-1, :]
	zadnjiRed = simplexTabela[end, :]
	cMax = -Inf
	for i in 2:lastindex(zadnjiRed)
		if zadnjiRed[i] > cMax && (predzadnjiRed[i] >= 0 || predzadnjiRed[i] == -0)
			cMax = zadnjiRed[i]
			indeksKolone = i
		end
	end

	while cMax > 0 || cMax_M > 0
		if cMax_M > 0
			kljucna_kolona = indeksKolone_M
		else
			kljucna_kolona = indeksKolone
		end

		tMax = Inf
		kljucni_red = -1
		for i in 1:size(simplexTabela, 1)-2
			if simplexTabela[i, kljucna_kolona] > 0
				tPrivremeno = simplexTabela[i, 1] / simplexTabela[i, kljucna_kolona]
				if (tPrivremeno < tMax || (tPrivremeno == tMax && rand() > 0.5))
					tMax = tPrivremeno
					kljucni_red = i
				end
			end
		end

		if tMax == Inf
			throw("Rjesenje je neograniceno");
		end
		vektorIndeksa[kljucni_red] = kljucna_kolona - 1

		pivotElement = simplexTabela[kljucni_red, kljucna_kolona]

		simplexTabela[kljucni_red, :] ./= pivotElement

		for i in 1:size(simplexTabela, 1)
			if i != kljucni_red
				faktor = simplexTabela[i, kljucna_kolona]
				for j in 1:size(simplexTabela, 2)
					simplexTabela[i, j] -= simplexTabela[kljucni_red, j] * faktor
				end
			end
		end

		red_max_koef = deepcopy(simplexTabela[end-1, :])
		popfirst!(red_max_koef)
		(cMax_M, indeksKolone_M) = findmax(red_max_koef)
		indeksKolone_M += 1

		if cMax_M <= 1e-8
			cMax_M = 0
		end

		if cMax_M <= 0
			predzadnjiRed = simplexTabela[end-1, :]
			zadnjiRed = simplexTabela[end, :]
			cMax = -Inf
			for i in 2:lastindex(zadnjiRed)
				if zadnjiRed[i] > cMax && (predzadnjiRed[i] >= 0 || predzadnjiRed[i] == -0)
					cMax = zadnjiRed[i]
					indeksKolone = i
				end
			end
		end
	end

	# Provjera da li je ostalo vjestackih promjenjivih
	for i in 1:lastindex(artifitial)
		if (Float64(artifitial[i]) in vektorIndeksa)
            throw("Dopustiva oblast ne postoji");
		end
	end
	x = zeros(1, size(b, 1) + size(c, 2))

	for i in 1:lastindex(vektorIndeksa)
		x[Int(round(vektorIndeksa[i]))] = simplexTabela[i, 1]
	end


	#Provjera jedinstvenosti
	jedinstveno = true
	for i in 2:(lastindex(simplexTabela[end, :])-lastindex(artifitial))
		if x[i-1] == 0 && simplexTabela[end, i] == 0
			jedinstveno = false
		end
	end

	jedinstvenoString = ""
	if jedinstveno == true
		jedinstvenoString = "Rjesenje je jedinstveno"
	else
		jedinstvenoString = "Rjesenje nije jedinstveno"
	end

	if !isempty(mapa_neog_promj)
		for i in 1:lastindex(mapa_neog_promj)
			prviEl = findall(y -> y == mapa_neog_promj[i][1], x)
			drugiEl = findall(y -> y == mapa_neog_promj[i][2], x)
			if !isempty(prviEl) && !isempty(drugiEl)

			elseif isempty(prviEl) && !isempty(drugiEl)
				x[mapa_neog_promj[i][1]] = -x[drugiEl]
				deleteat!(x, drugiEl[1])
			end
		end
	end

	# Provjera degenerisanosti rjesenja
	degenerirano = false
	for i in 1:(lastindex(simplexTabela[:, 1])-2)
		if simplexTabela[i, 1] == 0
			degenerirano = true
		end
	end

	degeneriranoString = ""
	if degenerirano == true
		degeneriranoString = "Rjesenje je degenerirano"
	else
		degeneriranoString = "Rjesenje nije degenerisano"
	end


	# Ispravka znaka na osnovu min/max
	if goal == "min"
		Z = simplexTabela[end, 1]
	else
		Z = -simplexTabela[end, 1]
	end
	return Z, x, jedinstvenoString, degeneriranoString
end

# Provjera uz zadatke s predavanja 3
# Zadatak 1 (strana 38)

b = [150, 60]
A = [[0.5 0.3]; [0.1 0.2]]
c = [3 1]
goal = "max"
csigns = [-1, -1]
vsigns = [1, 1]
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

# Zadatak 2 (strana 45)
b = [0, 0, 1]
A = [[0.25 -8 -1 9]; [0.5 -12 -0.5 3]; [0 0 1 0]]
c = [3 -80 2 -24]
csigns = [-1, -1, -1]
vsigns = [1, 1, 1, 1]
goal = "max"
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

# Zadatak 3 (str 57)
b = [1, 300, 0.3, 0.5]
A = [[1 1 1 1]; [250 150 400 200]; [0 0 0 1]; [0 1 1 0]]
c = [32 56 50 60]
csigns = [0, 1, -1, -1]
vsigns = [1, 1, 1, 1]
goal = "min"
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)
