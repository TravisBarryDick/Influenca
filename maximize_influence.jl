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

function maximize_influence(g::Graph, β, k; N=20000)
    s = SimulationState(g, β)
    return maximize_influence(s, k, N=N)
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

function maximize_influence_CELF(g::Graph, β, k; N=20000)
    s = SimulationState(g, β)
    return maximize_influence_CELF(s, k, N=N)
end

function maximize_influence_CWY(g::Graph, β::Float64, k; N=20000)
    ccid = Array(Int, num_nodes(g))
    sizes = Array(Int, num_nodes(g))
    covered_by_S = Array(Bool, num_nodes(g))
    visited = Array(Bool, num_nodes(g))
    node_stack = Array(Int, 0)
    node_scores = Array(Float64, num_nodes(g))

    S = Array(Int, 0)
    for iter in 1:k
        fill!(node_scores, 0)
        for run in 1:N
            # Find the connected components after dropping each edge w.p. β
            ccs!(g, β, ccid, sizes, visited, node_stack)
            # Mark those connected components that intersect with the set S
            for s in S
                covered_by_S[ccid[s]] = true
            end
            # Update the scores for each vertex not in S
            for i in 1:num_nodes(g)
                if !covered_by_S[ccid[i]]
                    node_scores[i] += sizes[ccid[i]]
                end
            end
        end
        best_node = indmax(node_scores)
        best_score = maximum(node_scores) / N
        println("Adding node $best_node, score = $best_score")
        push!(S, best_node)
    end
    return S
end

function ccs!(g::Graph, β, ccid, sizes, visited, node_stack)
    for i in 1:num_nodes(g)
        visited[i] = false
        ccid[i] = i
        sizes[i] = 1
    end
    for i in 1:num_nodes(g)
        if visited[i]
            continue
        end
        push!(node_stack, i)
        while !isempty(node_stack)
            j = pop!(node_stack)
            if visited[j]
                continue
            end
            visited[j] = true
            for k_ix in 1:degree(g, j)
                k = neighbors(g,j)[k_ix]
                if !visited[k] && rand() < β
                    push!(node_stack, k)
                    ccid[k] = i
                    sizes[k] = 0
                    sizes[i] += 1
                end
            end
        end
    end
end
