# Task 1

# Write a function that performs addition and subtraction of two passed arguments 
# and returns both results. Add a check for the number of arguments. 
# If an argument is not provided, assign it a value of 0. Since the arguments can
# be matrices, check their dimensions. If the dimensions do not match, return a 
# result of 0. It is necessary to verify the function's operation.

function add_subtract(x = 0, y = 0) 
    if(size(x) != size(y))
        return (0, 0)
    else 
        return (x + y, x - y)
    end
end

add_subtract([1; 2])
add_subtract([1; 2], [3; 4])
add_subtract([1; 2], [3; 4; 5])

# Task 2

# Write a function that performs the sum of all elements of the passed matrix, 
# as well as the sums of the elements by rows, columns, and diagonals, and 
# returns the corresponding sums. Solve the task without using predefined 
# functions. It is necessary to verify the function's operation.

function matrix_addition(matrix)
    row_sum = [];
    sum = 0;
    # using eachrow
    # calculating sum of each row
    for row in eachrow(matrix)
        sum = 0
        for elem in row
            sum += elem 
        end
        push!(row_sum, sum) 
    end

    # using nested loops
    # calculating sum of each col and each diagonal
    col_sum = zeros(size(matrix, 2))
    main_diag_sum = 0
    secondary_diag_sum = 0
    
    for i in 1:size(matrix, 1)
        for j in 1:size(matrix, 2)
            col_sum[j] += matrix[i, j]
            if size(matrix, 1) == size(matrix, 2)
                if i == j 
                    main_diag_sum += matrix[i,j]
                end
                if i + j == size(matrix, 1) + 1
                    secondary_diag_sum += matrix[i,j]
                end
            end
        end
    end
    return (row_sum, col_sum, main_diag_sum, secondary_diag_sum)
end

matrix_addition([1 2 3; 4 5 6; 7 8 9])

a = [5 2 9 4; 3 8 6 1; 7 4 2 9]
matrix_addition(a)

# Task 3

# Write a function that takes a string representing a command and plots the graph
# of an arbitrary function of one variable. It is necessary to use appropriate 
# meta commands to evaluate the string as an expression/command. The function 
# should account for a number of points in the interval to be 100, and the 
# function should be plotted over the interval [-5, 5].

function draw_fun(command::String)
    x = range(-5, 5, length=100)
    f = eval(Meta.parse(command))
    # y = f.(x)
    plot(x,f)
end

# or
# function draw_fun(s::String)
#     global x=LinRange(-5,5,100)
#     x=[x;];
#     y = eval(Meta.parse(s))
#     plot(x,y)
# end
draw_fun("x.^2")