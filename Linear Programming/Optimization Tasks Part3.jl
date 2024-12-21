# arg max Z = 22x1 + 18x2 + 21x3
# p.o.
# 2/100 x1 + 5 / 100 x2 + 3 / 100 x3 <= 126
# 17x1 + 17x2 + 17x3 <= 54674
# x1 >= 0, x2 >= 0, x3 >= 0
using GLPK, JuMP

m = Model(GLPK.Optimizer);

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 22*x1 + 18*x2 + 21*x3)

@constraint(m, constraint1, 2/100*x1 + 5/100*x2 + 3/100*x3 <= 126)
@constraint(m, constraint2, 17*x1 + 17*x2 + 17*x3 <= 54674)

print(m)
optimize!(m)

termination_status(m)

value(x1), value(x2), value(x3), objective_value(m)
# => (x1 = 3216.1176470588234, x2 = 0.0, x3 = 0.0, Z = 70754.58823529411)


# arg min Z = 0.45x1 + 0.54x2
# p.o.
# 0.35 x1 + 0.15 x2  <= 11.9
# 0.45x1 + 0.55x2 = 3.01
# 0.58 x1 + 0.45 x2  >= 3.01
# x1 >= 0, x2 >= 0

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 0.45*x1 + 0.54*x2)

@constraint(m, constraint1, 0.35*x1 + 0.15*x2 <= 11.9)
@constraint(m, constraint2, 0.45*x1 + 0.55*x2 == 3.01)
@constraint(m, constraint3, 0.58*x1 + 0.45*x2 >= 3.01)

print(m)  
optimize!(m)

termination_status(m)

value(x1), value(x2), objective_value(m)

println("x1 = ", value(x1), ", x2 = ", value(x2), ", Z = ", objective_value(m))
println("Vrijednosti ogranicenja: ", value(constraint1), ", ", value(constraint2), ", ", value(constraint3))

# arg max Z = 800 x1 + 1000 x2 
 
#  p. o. 
 
#  30 x1 + 16 x2 <= 22800 
#  14 x1 + 19 x2 <= 14100 
#  11 x1 + 26 x2 <= 15950 
#                   x2 <= 550 
  
#  x1 >= 0, x2 >= 0 

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 800*x1 + 1000*x2)
@constraint(m, constraint1, 30*x1 + 16*x2 <= 22800)
@constraint(m, constraint2, 14*x1 + 19*x2 <= 14100)
@constraint(m, constraint3, 11*x1 + 26*x2 <= 15950)
@constraint(m, constraint4, x2 <= 550)

print(m)
optimize!(m)

termination_status(m)

value(x1), value(x2), objective_value(m)
