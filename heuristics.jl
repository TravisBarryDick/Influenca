"Returns the `k` nodes of highest degree in the graph `g`."
function degree_heuristic(g::Graph, k)
    degrees = [degree(g, i) for i in 1:num_nodes(g)]
    return sortperm(degrees, rev=true)[1:k]
end

"Returns a random subset of `k` nodes from the graph `g`."
random_heuristic(g::Graph, k) = randperm(num_nodes(g))[1:k]

function acquaintance_heuristic(g::Graph, k)
    return [rand(neighbors(g, rand(1:num_nodes(g)))) for i in 1:k]
end
