# Assignment Problem Solver

This repository contains a Julia implementation for solving the assignment problem using row and column reduction techniques. The main function `rasporedi` finds the initial solution for the assignment problem, which is primarily a minimization problem.

## Functions

### `smanji_redove!(M)`

Reduces each row of the matrix `M` by subtracting the minimum element of each row from all elements in that row.

### `smanji_kolone!(M)`

Reduces each column of the matrix `M` by subtracting the minimum element of each column from all elements in that column.

### `rasporedi(M)`

Solves the assignment problem for the given cost matrix `M`. The function performs the following steps:
1. Reduces the rows of the matrix.
2. Reduces the columns of the matrix.
3. Assigns unique zeros in rows and columns to form the assignment matrix.
4. Calculates the optimal assignment cost.

#### Parameters:
- `M`: A matrix representing the cost of assigning workers to machines.

#### Returns:
- `raspored`: A matrix representing the optimal assignment.
- `Z`: The optimal assignment cost.

## Example Usage

```julia
# Example 1
M = [80 20 23; 31 40 12; 61 1 1]

raspored, Z = rasporedi(M)
println("Matrica raspored:")
println(raspored)
println("\nVrijednost funkcije cilja Z: ", Z)

# Example 2
M = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65]

raspored, Z = rasporedi(M)
println("Matrica raspored:")
display(raspored)
println("\nVrijednost funkcije cilja Z: ", Z)
