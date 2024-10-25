using Blink
using Plots

# Function to draw a plot
function draw_fun(command::String)
    x = range(-5, 5, length=100)
    f = eval(Meta.parse(command))
    y = f.(x)
    
    # Draw the plot and save it as an image
    plot(x, y, label=command, xlabel="x", ylabel="f(x)", title="Function Plot")
    savefig("function_plot.png")  # Save the plot image
end

# Create a Blink window
w = Window()

# HTML content with function input
html_content = """
<!DOCTYPE html>
<html>
<head>
    <title>Draw Function</title>
</head>
<body>
    <h1>Draw Function</h1>
    <p>Enter a function (e.g., x -> x^2 or sin(x)): </p>
    <input type="text" id="functionInput" placeholder="e.g., x -> x^2"><br><br>
    <button id="drawButton">Draw</button>
    <h2>Results</h2>
    <p id="resultMessage"></p>
    <a id="resultLink" href="#" style="display:none;" target="_blank">View Result</a>

    <script>
        document.getElementById('drawButton').addEventListener('click', draw);

        function draw() {
            // Get input from the text field
            var command = document.getElementById('functionInput').value;

            // Call the Julia function via JavaScript
            window.julia_call('draw_fun', command).then(function() {
                // Display the link to the plot image
                var link = document.getElementById('resultLink');
                link.href = 'function_plot.png';
                link.style.display = 'inline';
                link.innerText = 'Click here to view the function plot';
            }).catch(function(err) {
                console.error("Error:", err);
                document.getElementById('resultMessage').innerText = "Error drawing the function.";
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
    window.julia_call = function(func_name, command) {
        return new Promise((resolve, reject) => {
            try {
                window.jlcall(func_name, command).then(result => {
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