using Blink

# Function for summing the elements of a matrix
function matrix_addition(matrix)
    row_sum = []
    sum = 0

    # Summing by rows
    for row in eachrow(matrix)
        sum = 0
        for elem in row
            sum += elem 
        end
        push!(row_sum, sum)
    end

    # Summing by columns and diagonals
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

# Create a Blink window
w = Window()

# HTML content with matrix input and result display
html_content = """
<!DOCTYPE html>
<html>
<head>
    <title>Matrix Addition</title>
</head>
<body>
    <h1>Matrix Addition</h1>
    <p>Enter the matrix (values separated by commas, rows by new lines):</p>
    <textarea id="matrixInput" rows="6" cols="40"></textarea><br><br>
    <button id="calculateButton">Calculate</button>
    <h2>Results</h2>
    <p id="rowSum"></p>
    <p id="colSum"></p>
    <p id="mainDiagSum"></p>
    <p id="secondaryDiagSum"></p>

    <script>
        document.getElementById('calculateButton').addEventListener('click', calculate);

        function calculate() {
            // Get input from the text field
            var matrixText = document.getElementById('matrixInput').value;

            // Convert text to matrix
            var matrix = matrixText.split('\\n').map(function(row) {
                return row.split(',').map(Number);
            });

            // Call the Julia function via JavaScript
            window.julia_call('matrix_addition', matrix).then(function(res) {
                // Display results in HTML elements
                document.getElementById('rowSum').innerText = "Row sums: " + res[0];
                document.getElementById('colSum').innerText = "Column sums: " + res[1];
                document.getElementById('mainDiagSum').innerText = "Main diagonal sum: " + res[2];
                document.getElementById('secondaryDiagSum').innerText = "Secondary diagonal sum: " + res[3];
            }).catch(function(err) {
                console.error("Error:", err);
            });
        }
    </script>
</body>
</html>
"""

# Load the HTML content into the Blink window
body!(w, html_content)

# Enable communication with the Julia function
@js w """
    window.julia_call = function(func_name, matrix) {
        return new Promise((resolve, reject) => {
            try {
                window.jlcall(func_name, matrix).then(result => {
                    resolve(result);
                }).catch(e => {
                    reject(e);
                });
            } catch (e) {
                reject(e);
            }
        });
    }
"""

# Open the Blink window
w