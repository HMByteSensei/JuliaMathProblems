# Izvještaj o implementaciji funkcije za minimizaciju puta

## Opis implementacije
Implementirana je funkcija `min_path(W)` u programskom jeziku Julia koristeći biblioteku JuMP za matematičko programiranje i GLPK kao solver za optimizacijske probleme. Funkcija pronalazi minimalni put kroz graf predstavljen težinskom matricom `W`. 

### Glavne karakteristike implementacije:
1. **Preprocesiranje matrice težina**  
   - Sve beskonačne vrijednosti (`Inf`) u matrici `W` zamijenjene su velikim brojem `bigM` kako bi solver mogao raditi s matricom.

2. **Formulacija problema**  
   - Definirane su binarne varijable `x[i, j]` koje označavaju da li je put između čvorova `i` i `j` uključen.  
   - Ciljna funkcija minimizira ukupnu težinu uključenih puteva.  
   - Dodana su ograničenja za početni čvor, završni čvor, kontinuitet i sprječavanje kružnih puteva.

3. **Rješavanje problema**  
   - Problem se rješava pozivom funkcije `optimize!`, nakon čega se provjerava status rješenja.

4. **Ekstrakcija rješenja**  
   - Dobijeni putevi i njihova ukupna težina izvlače se iz optimiziranog modela i vraćaju kao rezultat.

---

## Rezultati testiranja
Funkcija je testirana na tri različita problema za koje su poznata rješenja. 

## Zaključak
Funkcija `min_path` uspješno pronalazi minimalni put kroz graf, kao što je demonstrirano na testnim problemima. Rezultati su tačni i u skladu s poznatim rješenjima.
