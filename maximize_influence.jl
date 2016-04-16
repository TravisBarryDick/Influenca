function maximize_influence(s::SimulationState, k; N=20000)
    nodes = Array(Int, 0)
    for iter in 1:k
        best_score = 0.0
        best_node = 0
        for i in 1:num_nodes(s.g)
            if i in nodes
                continue
            end
            push!(nodes, i)
            score = evaluate_influence!(s, nodes, N=N)
            pop!(nodes)
            if score > best_score
                best_score = score
                best_node = i
            end
        end
        println("Adding node $best_node (Influence = $best_score).")
        push!(nodes, best_node)
    end
    return nodes
end
