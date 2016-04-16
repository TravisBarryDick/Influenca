function prakash_fig6dot2()
    g = Graph(16)
    for i in [1, 5, 9, 13]
        for j in i+1:i+3
            add_edge!(g, i, j)
        end
    end
    add_edge!(g, 1, 15)
    add_edge!(g, 5, 14)
    add_edge!(g, 9, 16)
    return g
end
