# Implementation of the Assignment Problem Optimized

## Introduction
The assignment function has been implemented to solve the problem of assigning workers to machines using the JuMP and GLPK packages in the Julia language. The function supports both balanced and unbalanced assignment problems.

## Implementation

### Initialization and Expansion of the Cost Matrix:
- The function receives a matrix `C` which represents the costs of assigning workers to machines.
- The number of workers `n` and the number of machines `m` are determined.
- If the matrix is not square, it is expanded to a square matrix `C_expanded` of dimension `d x d`, where `d` is the maximum dimension between `n` and `m`. The expansion is done by adding zeros in the new rows or columns.

### Creating the Model:
- An optimization model is created using the GLPK solver.
- Binary variables `x[i,j]` are defined to represent the assignment of worker `i` to machine `j`.

### Defining the Objective Function:
- The objective function is the minimization of the total assignment costs, achieved by summing the products of costs `C_expanded[i,j]` and variables `x[i,j]`.

### Adding Constraints:
- Each worker must be assigned to exactly one machine.
- Each machine must receive exactly one worker.

### Optimization:
- The model is optimized using the GLPK solver.

### Forming the Solution:
- A solution matrix `X` of dimensions `n x m` is created, which contains the optimal assignment of workers to machines.
- The values of variables `x[i,j]` are used to fill the matrix `X`.

### Calculating the Optimal Cost:
- The optimal assignment cost `V` is calculated as the sum of the products of costs `C[i,j]` and variables `X[i,j]`.

## Conclusion
The assignment function successfully solves the worker-to-machine assignment problem, supporting both balanced and unbalanced problems. The implementation uses the JuMP and GLPK packages to formulate and solve the optimization problem.

## Usage Example

Examples are provided in code from line 54.
