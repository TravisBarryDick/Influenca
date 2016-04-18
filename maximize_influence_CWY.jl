using Base.Collections

typealias EdgeMask Vector{Vector{Bool}}

init_mask(g::Graph) = [Array(Bool, degree(g,i)) for i in 1:num_nodes(g)]

function randomize!(m::EdgeMask, β)
    for i in eachindex(m)
        for j in eachindex(m[i])
            m[i][j] = rand() < β
        end
    end
end

function connected_components!(g::Graph, m::EdgeMask, cc_id, cc_size,
                               visited, node_stack)
    for i in 1:num_nodes(g)
        cc_id[i] = i
        cc_size[i] = 0
        visited[i] = false
    end
    # Find the connected components by doing a sequence of DFS searches
    for i in 1:num_nodes(g)
        if !visited[i] # We haven't already added this point to another cc
            push!(node_stack, i)
            while !isempty(node_stack)
                j = pop!(node_stack)
                if !visited[j]
                    visited[j] = true
                    cc_id[j] = i
                    cc_size[i] += 1
                    for k_ix in 1:degree(g, j)
                        k = neighbors(g, j)[k_ix]
                        if !visited[k] && m[j][k_ix]
                            push!(node_stack, k)
                        end
                    end
                end
            end
        end
    end
end

function maximize_influence_CWY(g::Graph, β, k; N::Int = 20000)
    # Pre-allocate some arrays
    cc_id = Array(Int, num_nodes(g))
    cc_size = Array(Int, num_nodes(g))
    visited = Array(Bool, num_nodes(g))
    node_stack = Array(Int, 0)
    m = init_mask(g)
    node_score = zeros(Float64, num_nodes(g))
    # The algorithm:
    S = Array(Int, 0)
    while length(S) < k
        fill!(node_score, 0)
        for run in 1:N
            # Find the connected components of a random subgraph
            randomize!(m, β)
            connected_components!(g, m, cc_id, cc_size, visited, node_stack)
            # Zero out contributions of connected components covered by S
            for s in S
                cc_size[cc_id[s]] = 0
            end
            # Add to the scores of each node
            for i in 1:num_nodes(g)
                node_score[i] += cc_size[cc_id[i]]
            end
        end
        best_node = indmax(node_score)
        best_score = maximum(node_score) / N
        println("Adding node $best_node, score=$best_score")
        push!(S, best_node)
    end
    return S
end
