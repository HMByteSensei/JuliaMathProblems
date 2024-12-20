function najkraci_put(M)
    n = size(M, 1)
    dist = fill(Inf, n)  # Distances
    pred = fill(-1, n)   # Predecessors
    dist[1] = 0          # The starting node has distance 0
    pred[1] = 1          # The starting node is its own predecessor (based on the test example)

    # Relaxation of all edges n-1 times
    for _ in 1:n-1
        for u in 1:n
            for v in 1:n
                if M[u, v] != 0
                    # If the new path is shorter or equal, but we prefer intermediate paths
                    if dist[u] + M[u, v] < dist[v] || 
                       (dist[u] + M[u, v] == dist[v] && pred[v] != u)
                        dist[v] = dist[u] + M[u, v]
                        pred[v] = u
                    end
                end
            end
        end
    end

    # Creating the result
    result_matrix = []
    for v in 1:n
        push!(result_matrix, [v, dist[v], pred[v]])
    end

    return hcat(result_matrix...)'  # Convert to matrix as shown in the example
end

# Testing
M = [0 1 3 0 0 0; 0 0 2 3 0 0; 0 0 0 -4 9 0; 0 0 0 0 1 2; 0 0 0 0 0 2; 0 0 0 0 0 0]
putevi = najkraci_put(M)
println(putevi)
