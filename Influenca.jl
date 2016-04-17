module Influenca

include("graph_utils.jl")
export Graph, load_graph, num_nodes, num_edges, neighbors, degree, add_node!
export add_edge!, spadj

include("simulation.jl")
export SimulationState, reset!, infect!, immunize!, simulate!
export evaluate_immunization!, evaluate_influence!

include("net_shield.jl")
export net_shield

include("maximize_influence.jl")
export maximize_influence, maximize_influence_CELF

include("degree_heuristic.jl")
export degree_heuristic

include("example_graphs.jl")
export prakash_fig6dot2

end
