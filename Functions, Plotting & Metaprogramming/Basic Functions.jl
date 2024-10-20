# Task 1
# a)
# Calculate the expression (3 * 456) / (23 + 31.54 + 26)
(3 * 456) / (23 + 31.54 + 26)

# b)
# Calculate sin(pi/7) multiplied by exp(0.3) and the complex number 2(2 + 0.9 * im)
sin(pi/7) * exp(0.3) * 2 * (2 + 0.9 * im)

# c)
# Calculate the expression sqrt(2) * log(10)
sqrt(2) * log(10)

# d)
# Calculate the expression (5 + 3 * im) / (1.2 + 4.5 * im)
(5 + 3 * im) / (1.2 + 4.5 * im)

# Task 2

# Calculate various expressions
a = (atan(5) + exp(5.6)) / 3
b = sin(pi/3)^(1/15)
c = (log(15) + 1) / 23
d = sin(pi/2) + cos(pi)

# a)
# Calculate (a + b) * c
(a + b) * c

# b)
# Calculate acos(b) * asin(c / 11)
acos(b) * asin(c / 11)

# c)
# Calculate (a - b)^4 / d
(a - b)^(4) / d

# d)
# Calculate c^(1/a) + (b * im) / (3 + 2 * im)
c^(1/a) + (b * im) / (3 + 2 * im)

# Task 3
using LinearAlgebra

# Create a matrix A with various expressions
A = [1 -4 * im sqrt(2); log(Complex(-1)) sin(pi/2) cos(pi/3); asin(0.5) acos(0.8) exp(0.8)]

# a)
# Calculate the transpose of matrix A
transpose(A)

# b)
# Calculate A + transpose(A)
A + transpose(A)

# c)
# Calculate the product A * transpose(A)
A * transpose(A)

# d)
# Calculate the determinant of matrix A
det(A)

# e)
# Calculate the inverse of matrix A
inv(A)
# or
A ^ (-1)

# Task 4

# a)
# Create a matrix of zeros with 8 rows and 9 columns
zeros(8, 9)

# b)
# Create a matrix of ones with 7 rows and 5 columns
ones(7, 5)

# c)
# Create an identity matrix of size 5 and add a matrix of zeros
I(5) + zeros(5, 5)

# d)
# Create a 4x9 matrix with random elements
rand(4, 9)

# Task 5
a = [2 7 6; 9 5 1; 4 3 8]

# a)
# Calculate the sum of each column in matrix a
sum(a, dims=1)

# b)
# Calculate the sum of each row in matrix a
sum(a, dims=2)

# c)
# Calculate the sum of the main diagonal of matrix a
sum(diag(a))
# or
tr(a)

# d)
# Rotate matrix a 90 degrees to the left and calculate the trace
rotl90(a)
tr(rotl90(a))

# Minimum and maximum in rows
minimum(a, dims=2)
maximum(a, dims=2)

# Minimum and maximum in columns
minimum(a, dims=1)
maximum(a, dims=1)

# Minimum and maximum in the main diagonal
minimum(diag(a))
maximum(diag(a))

# Minimum and maximum in the secondary diagonal
minimum(diag(rotl90(a)))
maximum(diag(rotl90(a)))

# Overall sum of all elements in matrix a
sum(a)

# Task 6
a = [1 2 3; 4 5 6; 7 8 9]
b = [1 1 1; 2 2 2; 3 3 3]

# a)
# Calculate the sine of each element in matrix a
c = sin.(a)

# b)
# Calculate the product of the sine of matrix a and the cosine of matrix b
c = sin.(a) * cos.(b)

# c)
# Calculate the cube root of matrix a
c = a ^ (1/3)

# d)
# Calculate the element-wise cube root of matrix a
c = a .^ (1/3)

# Task 7

# a)
# Create a vector from 0 to 99 and transpose it
[0:99;]'

# b)
# Create a vector from 0 to 0.99 with a step of 0.01 and transpose it
[0:0.01:0.99;]'

# c)
# Create a vector from 39 to 1, decreasing by 2
[39:-2:1;]

# Task 8
a = [7 * ones(4, 4) zeros(4, 4); 3 * ones(4, 8)]

# a)
# Add the identity matrix of size 8 to matrix a
b = I(8) + a

# b)
# Select every second row from matrix b
c = b[1:2:end, :]

# c)
# Select every second column from matrix b
d = b[:, 1:2:end]

# d)
# Select every second row and every second column from matrix b
d = b[1:2:end, 1:2:end]
