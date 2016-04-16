"Returns the `k` nodes of highest degree in the graph `g`."
function degree_heuristic(g::Graph, k)
    degrees = [degree(g, i) for i in 1:num_nodes(g)]
    return sortperm(degrees, rev=true)[1:k]
end
