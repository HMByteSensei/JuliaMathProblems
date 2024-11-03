# using Pkg

# Pkg.add("JuMP")
# Pkg.add("GLPK")

using JuMP, GLPK

# "Typical problems that can be represented by a linear programming model 
# include the optimal production problem and the optimal blending problem." - lecture notes

# Task 1:

# A company sells two types of ground coffee, K1 and K2. The expected profit is 3 monetary units (abbreviated m.u.) per kilogram for coffee K1 (i.e., 3 m.u./kg) and 2 m.u./kg for coffee K2. The roasting facility is available for 150 hours per week, and the grinding facility for 60 hours per week. The hours required for roasting and grinding per kilogram of product are given in the following table:
 
#           K1       K2 
# Roasting  0.5 h/kg 0.3 h/kg 
# Grinding  0.1 h/kg 0.2 h/kg 
 
# Formulate a mathematical model to determine how much coffee K1 and K2 should be produced to maximize the total profit.

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 3*x1 + 2*x2)

@constraint(m, constraint1, 0.5*x1 + 0.3*x2 <= 150)
@constraint(m, constraint2, 0.1*x1 + 0.2*x2 <= 60)

print(m)
optimize!(m) # perform optimization, i.e., the appropriate algorithm

termination_status(m) # optimization status (1 => optimal, 2 => unbounded, 3 => no solution, 4 => error)

value(x1), value(x2), objective_value(m) # optimal solution

3*value(x1) + 2*value(x2) # profit

# Task 2:

# A vitamin therapy needs to be provided containing four types of vitamins V1, V2, V3, and V4. Two types of vitamin syrups, S1 and S2, are available at prices of 40 m.u./g and 30 m.u./g respectively. The vitamin cocktail must contain at least 0.2 g, 0.3 g, 3 g, and 1.2 g of vitamins V1, V2, V3, and V4 respectively. The following table shows the composition of each vitamin in both types of syrups:
 
#    V1  V2 V3  V4 
# S1 10% 0% 50% 10% 
# S2 0% 10% 30% 20% 
 
# Formulate a mathematical model to determine how much of each syrup, S1 and S2, should be obtained to minimize the total cost.

# Solution:
# arg min Z(x) = 40 x1 + 30 x2 
# subject to 
#  0.1 x1              >= 0.2 
#               0.1 x2 >= 0.3 
#  0.5 x1 + 0.3 x2 >= 3 
#  0.1 x1 + 0.2 x2 >= 1.2 
#  x1 >= 0, x2 >= 0

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 40*x1 + 30*x2)

@constraint(m, constraint1, 0.1*x1 >= 0.2)
@constraint(m, constraint2, 0.1*x2 >= 0.3)
@constraint(m, constraint3, 0.5*x1 + 0.3*x2 >= 3)
@constraint(m, constraint4, 0.1*x1 + 0.2*x2 >= 1.2)

print(m)

optimize!(m)
termination_status(m)

value(x1), value(x2), objective_value(m)

# Task 3:

# The production of three types of detergents, D1, D2, and D3, is planned. An agreement has been made with the retail network to deliver exactly 100 kg of detergent, regardless of the type. The funds allocated for importing the necessary raw materials amount to $110. For producing one kilogram of detergents D1, D2, and D3, raw materials worth $2, $1.5, and $0.5 are required, respectively. It is also planned to employ workers with a total of at least 120 work hours, with 2 hours, 1 hour, and 1 hour respectively required per kilogram for D1, D2, and D3 production. The selling prices per kilogram for D1, D2, and D3 are respectively 10 KM, 5 KM, and 8 KM. Formulate a mathematical model to determine how much of each type of detergent should be produced to maximize the possible profit.

# Solution:
# arg max Z(x) = 10 x1 + 5 x2 + 8 x3 
# subject to 
#  x1 + x2 + x3 = 100 
#  2 x1 + 1.5 x2 + 0.5 x3 <= 110 
#  2 x1 + x2 + x3 >= 120 
 
#  x1 >= 0, x2 >= 0, x3 >= 0 
m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 10 * x1 + 5 * x2 + 8 * x3)

@constraint(m, constraint1, x1 + x2 + x3 == 100)
@constraint(m, constraint2, 2*x1 + 1.5*x2 + 0.5*x3 <= 110)
@constraint(m, constraint3, 2*x1 + x2 + x3 >= 120)

print(m)

optimize!(m)
termination_status(m)

value(x1), value(x2), value(x3), objective_value(m)

# Task 4:

# A cargo ship transports two types of cargo. Due to the nature of the cargo, the shipowner must pay a tax of 500 KM for each ton of the first type of cargo, while receiving an advance of 200 KM per ton for the second type of cargo. The cash available to the shipowner at the start of loading is 3000 KM, and there is no way to obtain more cash at the time of loading. The advance obtained from loading the second type of cargo can, of course, be used to pay the tax for the first type of cargo. Loading the first type of cargo takes half an hour per ton, while the second type takes 15 minutes per ton. The total time available for loading is at most 12 hours, and only one type of cargo can be loaded at a time. The transport profit for the first type of cargo is 2000 KM per ton, and 100 KM per ton for the second type (excluding the aforementioned advance). Formulate a mathematical model to determine how much of each type of cargo should be loaded to maximize profit.

# Solution

# arg max Z(x) = 2000 x1 + 100 x2 – 500 x1 + 200 x2 = 1500 x1 + 300 x2 
# p.o. 
# (1/2) x1 + (1/4) x2  12 
# 500 x1 – 200 x2  3000 
# x1  0, x2  0 

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 1500*x1 + 300*x2)

@constraint(m, constraint1, 0.5*x1 + 0.25*x2 <= 12)
@constraint(m, constraint2, 500*x1 - 200*x2 <= 3000)

print(m)
optimize!(m)
termination_status(m)

value(x1), value(x2), objective_value(m)
