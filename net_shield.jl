function net_shield(g::Graph, k)
    A = spadj(g)
    λs, us = eigs(A, nev=1, which=:LR)
    λ = λs[1]
    u = us[:,1]
    if u[1] < 0
        u *= -1
    end

    S = Array(Int, 0)
    for iter in 1:k
        best_score = -Inf
        best_node = 0
        for i in 1:num_nodes(g)
            if i in S
                continue
            end
            score = 2*λ*u[i]*u[i]
            for j in neighbors(g, i)
                if j in S
                    score -= 2*u[i]*u[j]
                end
            end
            if score > best_score
                best_score = score
                best_node = i
            end
        end
        push!(S, best_node)
    end
    return S
end
