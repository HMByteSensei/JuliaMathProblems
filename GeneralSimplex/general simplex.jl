using LinearAlgebra

function napravi_simplex_tabelu(A, b, c, csigns)
	brRedova = size(A, 1)
	A_next, b_next, c_next = A, b, c
	baza = zeros(brRedova, 1)
	c_next_M = zeros(1, size(c, 2))
	funkcija_M = 0
	artifitial, artif_jed = [], [];

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
			artif_jed = [artif_jed; size(c_next, 2)]
		end
	end

	c_next = [0 c_next]
	c_next_M = [funkcija_M c_next_M]
	ST = [b_next A_next]
	ST = [ST; c_next_M; c_next]
	return ST, baza, artifitial, artif_jed
end

function general_simplex(goal, c, A, b, csigns = missing, vsigns = missing)
	b=b'
    csigns=csigns'
    vsigns=vsigns'
    if ismissing(csigns)
        if goal == "min"
        csigns = ones(size(b,1))
        else
            csigns = -1*ones(size(b,1))
        end
    end

    if ismissing(vsigns)
        vsigns = ones(size(c,2))
    end
	brojPogresnih = count(i-> (i!=1 && i!=-1 && i!=0), csigns) + count(i-> (i!=1 && i!=-1 && i!=0), vsigns)
	if size(b, 1) != size(A, 1) || size(c, 2) != size(A, 2) ||
		(goal != "min" && goal != "max") || (size(csigns, 1) != size(b, 1)) ||
		(size(vsigns, 1) != size(c, 2) || brojPogresnih != 0)
		return (NaN, NaN, NaN, NaN, NaN, 5)
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

	(simplexTabela, vektorIndeksa, artifitial, art_jed) = napravi_simplex_tabelu(A, b, c, csigns)
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
			return (Inf, NaN, NaN, NaN, NaN, 3);
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
            return (NaN, NaN, NaN, NaN, NaN, 4);
		end
	end
	x = vec(zeros(1, size(simplexTabela, 2) - 1 - lastindex(artifitial)))

	for i in 1:lastindex(vektorIndeksa)
		x[Int(round(vektorIndeksa[i]))] = simplexTabela[i, 1]
	end

	dual_arr = simplexTabela[end, :]
    popfirst!(dual_arr)
    index_for_del = []
    if !isempty(mapa_neog_promj)
        for i in 1:lastindex(mapa_neog_promj)
            prviEl = mapa_neog_promj[i][1] in vektorIndeksa
            drugiEl = mapa_neog_promj[i][2] in vektorIndeksa
            if prviEl && drugiEl
                continue
            elseif !prviEl && drugiEl
                replace!(vektorIndeksa, mapa_neog_promj[i][2] => mapa_neog_promj[i][1])
                x[mapa_neog_promj[i][1]] = -x[mapa_neog_promj[i][2]]
            end
            push!(index_for_del, mapa_neog_promj[i][2])
        end
    end
	if !isempty(index_for_del)
        deleteat!(x, index_for_del)
        deleteat!(dual_arr, index_for_del)
    end
	#Provjera jedinstvenosti
	jedinstveno = true
    for i in 1:(lastindex(dual_arr)-lastindex(artifitial))
        if x[i] == 0 && dual_arr[i] == 0
            jedinstveno = false
        end
    end

	jedinstvenoString = ""
	if jedinstveno == true
		jedinstvenoString = "Rjesenje je jedinstveno"
	else
		jedinstvenoString = "Rjesenje nije jedinstveno"
	end

	# if !isempty(mapa_neog_promj)
	# 	for i in 1:lastindex(mapa_neog_promj)
	# 		prviEl = findall(y -> y == mapa_neog_promj[i][1], x)
	# 		drugiEl = findall(y -> y == mapa_neog_promj[i][2], x)
	# 		if !isempty(prviEl) && !isempty(drugiEl)

	# 		elseif isempty(prviEl) && !isempty(drugiEl)
	# 			x[mapa_neog_promj[i][1]] = -x[drugiEl]
	# 			deleteat!(x, drugiEl[1])
	# 		end
	# 	end
	# end

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
	YUkupno = zeros(size(x, 1))

	# Ispravka znaka na osnovu min/max
	YUkupno = zeros(size(x, 1))

    if goal === "min"
        Z = simplexTabela[end, 1]
    else
        Z = -simplexTabela[end, 1]
    end

    # Ocitavanje dualnih promjenjivih
    novi_znak = Int[]  
    for i in 1:lastindex(csigns) 
        if csigns[i] != 0
            push!(novi_znak, csigns[i])
        end
    end
    brojJednakihOgranicenjaVar = count(i -> (i == 0), vsigns)
    for i in 1:(lastindex(dual_arr)-lastindex(artifitial))
        if x[i] == 0 && i >= (size(c, 2) - brojJednakihOgranicenjaVar + 1)
            if goal == "max"
                if novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == -1
                    YUkupno[i] = -dual_arr[i]
                elseif novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == 1
                    YUkupno[i-(size(c, 2)-brojJednakihOgranicenjaVar)] = dual_arr[i]
                elseif novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == 0
                    YUkupno[i] = -dual_arr[i]
                end
            elseif goal == "min"
                if novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == -1
                    YUkupno[i] = dual_arr[i]
                elseif novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == 1
                    YUkupno[i] = -dual_arr[i]
                elseif novi_znak[i-(size(c, 2)-brojJednakihOgranicenjaVar)] == 0
                    YUkupno[i] = dual_arr[i]
                end
            end
        elseif x[i] == 0
            if goal == "max"
                YUkupno[i] = -dual_arr[i]
            elseif goal == "min"
                YUkupno[i] = -dual_arr[i]
            end
        end
    end

    Y = YUkupno[(size(c, 2)+1-brojJednakihOgranicenjaVar):size(x, 1)]
    Yd = YUkupno[1:(size(c, 2)-brojJednakihOgranicenjaVar)]
    X = x[1:(size(c, 2)-brojJednakihOgranicenjaVar)]
    Xd = x[(size(c, 2)+1-brojJednakihOgranicenjaVar):size(x, 1)]
    if !isempty(art_jed)
        for i in art_jed
            if goal == "max"
                Y = [Y; -dual_arr[i]]
                Xd = [Xd; 0]
            else
                Y = [Y; dual_arr[i]]
                Xd = [Xd; 0]
            end
        end
    end
    if degenerirano == true
        return (Z, X, Xd, Y, Yd, 1)
    elseif jedinstveno == false
        return (Z, X, Xd, Y, Yd, 2)
    end
    return (Z, X, Xd, Y, Yd, 0)
end

# Provjera uz testne primjere

# arg max Z = x + y
# p.o.
# x + y <= 2
# x + 2y >= 3
# -0.5x + 2y <= 1
# x >= 0, y >= 0

# Rezultat:
# Z = NaN status = 4 (dopustiva oblast ne postoji)
goal = "max";
c = [1 1];
A = [[1 1]; [1 2]; [-0.5 2]];
b = [2 3 1];
csigns = [-1 1 -1];
vsigns = [1 1];
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

# Provjera uz zadatke s predavanja 3
# Zadatak 1 (strana 38)
# Z = 900, X=(300, 0), Xd=(0, 30), Y=(6, 0), Yd=(0, 0.8), status = 0
b = [150 60]
A = [[0.5 0.3]; [0.1 0.2]]
c = [3 1]
csigns = [-1 -1]
vsigns = [1 1]
goal = "max"
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

# # Zadatak 2 (strana 45)
# Z = 5, X=(1, 0, 1, 0), Xd=(3/4, 0, 0), Y=(0, 6, 5), Yd=(0, 8, 0, 42), status = 0
b = [0 0 1]
A = [[0.25 -8 -1 9]; [0.5 -12 -0.5 3]; [0 0 1 0]]
c = [3 -80 2 -24]
goal = "max"
csigns = [-1 -1 -1]
vsigns = [1 1 1 1]
Z, X, Xd, Y, Yd, status = general_simplex(goal, c, A, b, csigns, vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)

# Zadatak 3 (str 57)
# Z = 38, X=(0.66, 0, 0.33, 0), Xd=(0, 0, 0.3, 0.16), Y=(2, 0.12, 0, 0), Yd=(0, 36, 0, 34), status = 0
b = [1 300 0.3 0.5]
A = [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0]
c = [32 56 50 60]
csigns = [0 1 -1 -1]
vsigns = [1 1 1 1]
goal = "min"
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#test1
#Z=3000;  X=(60 20) Xd(90 0 60 100 0 40); Y(0 30 0 0 10 0) Yd(0 0) status(0)
goal="max";
c=[40 30];
A=[3 1.5;1 1;2 1;3 4;1 0;0 1];
b=[300 80 200 360 60 60] 
csigns=[-1 -1 -1 -1 -1 -1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test2
#Z=12;  X=(12 0) Xd(14 4 0); Y(0 0 1) Yd(0 0.5); status(0)
goal="min";
c=[1 1.5];
A=[2 1; 1 1; 1 1];
b=[10 8 12] 
csigns=[1 1 1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
goal="min";
c=[32 56 50 60];
A=[1 1 1 1;250 150 400 200;0 0 0 1;0 1 1 0];
b=[1 300 0.3 0.5] 
csigns=[0 1 -1 -1] 
vsigns=[1  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
goal="max";
c=[1 300 -0.3 -0.5];
A=[1 250 0 0;1 150 0 -1;1 400 0 -1;1 200 -1 0];
b=[32  56  50  60] 
csigns=[-1 -1 -1 -1] 
vsigns=[0  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
goal="max";
c=[1 1];
A=[-2 1;-1 2];
b=[-1 4] 
csigns=[-1 1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
goal="max";
c=[1 2];
A=[1 1; 3 3];
b=[2 4] 
csigns=[1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
goal="max";
c=[4000 2000];
A=[3 3;2 1;1 0;0 1];
b=[12000 6000 2500 3000] 
csigns=[-1 -1 -1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
goal="max";
c=[3 9];
A=[1 4;1 2];
b=[8 4] 
csigns=[-1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)