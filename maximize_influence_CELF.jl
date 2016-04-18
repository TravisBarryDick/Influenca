function maximize_influence_CELF(state::SimulationState, k; N=20000)
    nodes = Array(Int, 0)
    current_influence = 0.0
    valid = zeros(Bool, num_nodes(state.g))
    q = PriorityQueue(Int, Float64, Base.Order.Reverse)
    for i in 1:num_nodes(state.g)
        enqueue!(q, i, Inf)
    end
    for iter in 1:k
        fill!(valid, false)
        while true
            s = dequeue!(q)
            if valid[s]
                push!(nodes, s)
                current_influence = evaluate_influence!(state, nodes, N=N)
                println("Adding $s new influence = $current_influence")
                break
            else
                push!(nodes, s)
                new_influence = evaluate_influence!(state, nodes, N=N)
                pop!(nodes)
                valid[s] = true
                enqueue!(q, s, new_influence - current_influence)
            end
        end
    end
    return nodes
end

function maximize_influence_CELF(g::Graph, β, k; N=20000)
    s = SimulationState(g, β)
    return maximize_influence_CELF(s, k, N=N)
end
