# Uncomment the following lines when running for the first time:
# using Pkg
# Pkg.add("Blink")

using Blink
using Base64

# Define a function for matrix addition and subtraction
function add_subtract_matrices(matrix1::Matrix{Float64}, matrix2::Matrix{Float64})
    if size(matrix1) != size(matrix2)
        return "Error: Matrices must be the same size."
    end
    return (matrix1 + matrix2, matrix1 - matrix2)
end

# Create a Blink window
w = Window()

# Define the HTML content
html_content = """
<!DOCTYPE html>
<html>
<head>
    <title>Matrix Addition and Subtraction</title>
</head>
<body>
    <h1>Matrix Addition and Subtraction</h1>
    <label for="matrix1">Matrix 1 (enter rows separated by commas, and elements separated by spaces):</label><br>
    <textarea id="matrix1" rows="4" cols="50"></textarea><br><br>
    <label for="matrix2">Matrix 2 (enter rows separated by commas, and elements separated by spaces):</label><br>
    <textarea id="matrix2" rows="4" cols="50"></textarea><br><br>
    <button id="calculateButton">Calculate</button>
    <h2>Results</h2>
    <p id="result"></p>

    <script>
        document.getElementById('calculateButton').addEventListener('click', calculate);
        function calculate() {
            console.log("Calculate button was pressed");
            var matrix1 = document.getElementById('matrix1').value.trim().split(',').map(row => row.trim().split(' ').map(Number));
            var matrix2 = document.getElementById('matrix2').value.trim().split(',').map(row => row.trim().split(' ').map(Number));
            if (matrix1.some(row => row.some(isNaN)) || matrix2.some(row => row.some(isNaN))) {
                document.getElementById('result').innerText = "Error: Please enter valid numbers for the matrices.";
                return;
            }
            if (matrix1.length !== matrix2.length || matrix1[0].length !== matrix2[0].length) {
                document.getElementById('result').innerText = "Error: Matrices must be the same size.";
                return;
            }
            var sum = matrix1.map((row, i) => row.map((val, j) => val + matrix2[i][j]));
            var difference = matrix1.map((row, i) => row.map((val, j) => val - matrix2[i][j]));
            document.getElementById('result').innerText = "Sum: " + JSON.stringify(sum) + ", Difference: " + JSON.stringify(difference);
        }
    </script>
</body>
</html>
"""

# Load the HTML content into the Blink window
body!(w, html_content)

# Enable communication with the Julia function
@js w """
    window.julia = {
        add_subtract_matrices: function(matrix1, matrix2) {
            return new Promise((resolve, reject) => {
                try {
                    window.jlcall('add_subtract_matrices', matrix1, matrix2).then(result => {
                        console.log("Result from Julia function:", result);
                        resolve(result);
                    }).catch(e => {
                        console.error("Error in Julia function:", e);
                        reject(e);
                    });
                } catch (e) {
                    console.error("Caught exception:", e);
                    reject(e);
                }
            });
        }
    }
"""

# Open the Blink window
w