# Task 1:

# A glass manufacturing company produces high-quality glass products and plans to launch the production 
# of two new products. The products are made in three different sections, spending a certain amount of 
# time in each. The first product requires Section 1 and Section 3, taking 1 hour and 3 hours, respectively. 
# The second product requires 2 hours in Section 2 and the same amount of time in Section 3. Due to 
# the time these sections are occupied by other products, Section 1 has 4 available hours, Section 2 has 
# 12 available hours, and Section 3 has 18 available hours. All newly produced products can be sold, 
# with the first product priced at 3 KM and the second at 5 KM per unit. Determine the optimal production 
# plan to achieve maximum profit.

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 3*x1 + 5*x2)

@constraint(m, constraint1, x1 <= 4)
@constraint(m, constraint2, 2*x2 <= 12)
@constraint(m, constraint3, 3*x1 + 2*x2 <= 18)

print(m)
optimize!(m)
termination_status(m)

value(x1), value(x2), objective_value(m)

# Task 2:

# A factory producing exhaust systems and decorative fittings manufactures red, green, and blue fittings, 
# costing respectively $20, $70, and $20 per kilogram. To produce these three types of fittings, one kilogram 
# requires one, two, and one "kataklinger" respectively, with a total of 2000 kataklingers available. Additionally, 
# the production of each type of fitting requires 6 liters, 1 liter, and 2 liters of "kalamute" per kilogram, and the 
# process demands at least 2800 liters of kalamute. Moreover, market demands require that the combined 
# weight of red and green fittings be exactly 1000 kg more than the blue fittings.

m = Model(GLPK.Optimizer)

@variable(m, r >= 0)
@variable(m, g >= 0)
@variable(m, b >= 0)

@objective(m, Max, 20*r + 70*g + 20*b)

@constraint(m, constraint1, r + 2*g + b <= 2000)
@constraint(m, constraint2, 6*r + g + 2*b >= 2800)
@constraint(m, constraint3, r + g == b + 1000)

print(m)
optimize!(m)
termination_status(m)

value(r), value(g), value(b), objective_value(m)

# Task 3:

# A lathe operator produces products A and B with selling prices of 30 KM and 25 KM per unit, respectively. 
# The operator requests that the employer ensure at least 10 working hours per week. Product A requires 1 
# hour of machine work and 2 hours of manual labor per kilogram, while Product B requires 5 hours of machine 
# work and 1 hour of manual labor per kilogram. Additionally, it is known that the machine should not operate 
# for more than 25 hours per week. Find a production plan that meets all the given requirements, minimizing 
# the employer's cost.

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 30*x1 + 25*x2)
@constraint(m, constraint1, x1 + 5*x2 <= 25)
@constraint(m, constraint2, 2*x1 + x2 >= 10)

print(m)
optimize!(m)
termination_status(m)

value(x1), value(x2), objective_value(m)

# Task 4:

# Two types of vitamins V1 and V2 can be consumed through two types of tablets, T1 and T2, with prices 
# of 24 and 25 cents per tablet, respectively. A minimum daily intake of 17 units of vitamin V1 and 11 units 
# of vitamin V2 is required. Tablet T1 contains 1 unit of vitamin V1 and 4 units of vitamin V2. Tablet T2 contains 
# 5 units of vitamin V1 and 1 unit of vitamin V2. Determine the daily quantity of each tablet type required to 
# meet daily vitamin needs at minimal cost.

using JuMP, GLPK

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 24*x1 + 25*x2)

@constraint(m, constraint1, x1 + 5*x2 >= 17)
@constraint(m, constraint2, 4*x1 + x2 == 11)

print(m)

optimize!(m)
termination_status(m)

value(x1), value(x2), objective_value(m)
