using Base.Collections

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
        push!(nodes, best_node)
    end
    return nodes
end

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
