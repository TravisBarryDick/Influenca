"A basic graph type that stores an adjacency list for each node."
type Graph
    num_nodes::Int
    num_edges::Int
    adj::Vector{Vector{Int}} # adjacency lists for each node
end

"Constructs a graph with `n` nodes and no edges."
Graph(n) = Graph(n, 0, [Array(Int, 0) for i in 1:n])

"""
Loads a graph from the file pointed to by `path`. Each line is assumed to be of
the form `a[delim]b`, and indicates that there is an edge between nodes a and b.
The nodes are relabeled in the order that they are observed to be contiguous
numbers between `1` and `n`.
"""
function load_graph(path, delimeter = ' ')
    new_ids = Dict{Int, Int}()
    g = Graph(0)
    function get_id(ix)
        if haskey(new_ids, ix)
            return new_ids[ix]
        else
            id = add_node!(g)
            new_ids[ix] = id
            return id
        end
    end
    edges = readdlm(path, delimeter, Int)
    for i in 1:size(edges, 1)
        add_edge!(g, get_id(edges[i,1]), get_id(edges[i,2]))
    end
    return g
end

"Returns the number of nodes in graph `g`."
num_nodes(g::Graph) = g.num_nodes

"Returns the number of edges in graph `g`."
num_edges(g::Graph) = g.num_edges

"Returns a vector of neighbors for node `i` in graph `g`."
neighbors(g::Graph, i) = g.adj[i]

"Returns the degree of node `i` in graph `g`."
degree(g::Graph, i) = length(neighbors(g,i))

"Adds a new node to graph `g`. Returns the id of the new node."
function add_node!(g::Graph)
    g.num_nodes += 1
    push!(g.adj, Array(Int, 0))
    return g.num_nodes
end

"Adds an (undirected) edge between nodes `i` and `j` in the graph `g`."
function add_edge!(g::Graph, i, j)
    g.num_edges += 1
    push!(g.adj[i], j)
    push!(g.adj[j], i)
    nothing
end

"Returns a sparse adjacency matrix for the graph `g`."
function spadj(g::Graph)
    E = zeros(Int, 2*num_edges(g), 2)
    E_ix = 1;
    for i in 1:num_nodes(g)
        for j in neighbors(g, i)
            E[E_ix, 1] = i
            E[E_ix, 2] = j
            E_ix += 1
        end
    end
    return sparse(E[:,1], E[:,2], ones(2*num_edges(g)), num_nodes(g), num_nodes(g))
end
