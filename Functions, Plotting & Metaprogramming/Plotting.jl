
using Plots  # Import the Plots library for plotting

# Task 1

# a)
# Create a range of 101 evenly spaced points between -π and π
x = range(-pi, pi, length=101)
# Calculate the sine of each point in x
y = sin.(x)
# Plot the sine function with specified attributes
plot(x, y, label="sin(x)", title="Sin function", xlabel="x", ylabel="y", linewidth=2, color=:blue)

# b)
# Create a range of 101 evenly spaced points between -π and π
x = range(-pi, pi, length=101)
# Calculate the cosine of each point in x
y = cos.(x)
# Plot the cosine function with specified attributes
plot(x, y, title="Cos function", label="cos(x)", xlabel="x", ylabel="y", linewidth=2, color=:blue)

# c)
# Create a range of 101 points between 1 and 10
x = range(1, 10, length=101)
# Calculate the sine of 1 divided by each point in x
y = sin.(1 ./ x)
# Plot the function sin(1/x) with specified attributes
plot(x, y, title="sin(1/x)", label="sin(1/x)", xlabel="x", ylabel="y", linewidth=2, color=:black)

# d)
# Calculate the cosine of 1 divided by each point in x
y1 = cos.(1 ./ x)
# Add the cosine function to the existing plot of sin(1/x)
plot!(x, y1, title="cos(1/x)", label="cos(1/x)", xlabel="x", ylabel="y", linewidth=2, color=:blue, line=:dot)

# e)
# Create a range of 101 evenly spaced points between -π and π
x = range(-pi, pi, length=101)
# Create a 2D array containing the sine and cosine values for each point in x
y = [sin.(x) cos.(x)]
# Plot both sine and cosine functions with different shapes and colors
plot(x, y, title="Sin and Cos functions", label=["sin(x)" "cos(x)"], xlabel="x", ylabel="y", shape=[:circle :star5], color=[:blue :red])

# Task 2
# Create a range from -8 to 8 with a step of 0.5 for x and y
x = (-8:0.5:8)
y = (-8:0.5:8)

# Define a function z that computes the sine of the square root of (x^2 + y^2)
z(x, y) = sin(sqrt(x^2 + y^2))

# Create a surface plot for the function z over the grid defined by x and y
surface(x, y, z, st=:surface)
