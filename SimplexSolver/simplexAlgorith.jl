# For the examples listed below, you must comment out examples that are not 
# being tested to ensure that the test case gives the correct result.
using LinearAlgebra

function solve_simplex(A, b, c)
    m, n = size(A)
    tableau = vcat(hcat(zeros(1,1), hcat(c', zeros(1, m))), hcat(b, A, I(m)))

    while (true)
        pivot_col = findmax(tableau[1, 2:end])[2] + 1
        if all(tableau[2:end, pivot_col] .<= 0)
            error("The solution is unbounded. The algorithm terminates.")
        end

        if all(tableau[1, 2:end] .<= 0)
            break
        end

        ratios = tableau[2:end, 1] ./ tableau[2:end, pivot_col]
        ratios[tableau[2:end, pivot_col] .<= 0] .= Inf
        pivot_row = findmin(ratios)[2] + 1

        pivot_element = tableau[pivot_row, pivot_col]
        tableau[pivot_row, :] ./= pivot_element
        for i in 1:size(tableau, 1)
            if i != pivot_row
                tableau[i, :] .-= tableau[i, pivot_col] * tableau[pivot_row, :]
            end
        end
    end
    x = tableau[2:end, 1]
    z = -tableau[1, 1]
    return z, x
end

# Using the simplex algorithm, solve the linear programming problem 
#  arg max Z = 3 x1 + x2 
#  subject to 
#  0.1 x1 + 0.2 x2 <= 60 
#  0.5 x1 + 0.3 x2 <= 150 
#  x1 >= 0, x2 >= 0 

A = [0.5 0.3; 0.1 0.2]
b = [150; 60]
c = [3; 1]
Z, x = solve_simplex(A, b, c)

println("Optimal value for Z: ", Z)
println("Optimal solution x: ", x)

# Example: To produce two products, P1 and P2, three raw materials, S1, S2, and S3, are used. 
# The following table shows the usage of each raw material per kilogram of product P1 or per liter of product P2, 
# as well as the available quantities (stocks) of each raw material in storage, and the selling prices of products 
# P1 and P2 per unit produced (per kilogram or liter). 

#          |     Products      | 
# Raw Mat. | P1      | P2      |   Stocks 
# S1       | 30 l/kg | 16 l/l  | 22,800 l
# S2       | 14 kg/kg| 19 kg/l | 14,100 kg
# S3       | 11 pcs/kg| 26 pcs/l| 15,900 pcs
# Prices   | 800 $/kg| 1,000 $/l|

# In addition, it is estimated that due to limited market capacity, 
# no more than 550 liters of product P2 should be produced in the observed period. 

# arg max Z = 800 x1 + 1000 x2 
# subject to 
#  30 x1 + 16 x2 <= 22800 
#  14 x1 + 19 x2 <= 14100 
#  11 x1 + 26 x2 <= 15950 
#                   x2 <= 550 
#  x1 >= 0, x2 >= 0 

A = [30 16; 14 19; 11 26; 0 1]
b = [22800, 14100, 15950, 550]
c = [800, 1000]

Z, x = solve_simplex(A, b, c)

println("Optimal value for Z: ", Z)
println("Optimal solution x: ", x)

# arg min Z = –3 x1 + 80 x2 – 2 x3 + 24 x4 
# subject to 
#   (1/4) x1 –   8 x2 –          x3 + 9 x4 <= 0 
#   (1/2) x1 – 12 x2 – (1/2) x3 + 3 x4 <= 0 
#   x3           <= 1 
#   x1 >= 0,  x2 >= 0,  x3 >= 0,  x4 >= 0 

A = [1/4 -8 -1 9; 1/2 -12 -1/2 3; 0 0 1 0]
b = [0, 0, 1]
c = [-3, 80, -2, 24]

Z, x = solve_simplex(A, b, c)

println("Optimal value for Z: ", Z)
println("Optimal solution x: ", x)

# arg max Z(x) = 3 x1 + 2 x2 
# subject to 
#  0.5 x1 + 0.3 x2 <= 150 
#  0.1 x1 + 0.2 x2 <= 60 
#  x1 >= 0, x2 >= 0 

A = [0.5 0.3; 0.1 0.2]
b = [150, 60]
c = [3, 2]

Z, x = solve_simplex(A, b, c)

println("Optimal value for Z: ", Z)
println("Optimal solution x: ", x)
