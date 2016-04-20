module Influenca

include("graph_utils.jl")
export Graph, load_graph, num_nodes, num_edges, neighbors, degree, add_node!
export add_edge!, spadj

include("simulation.jl")
export SimulationState, reset!, infect!, immunize!, simulate!
export evaluate_immunization!, evaluate_immunization
export evaluate_influence!, evaluate_influence

include("net_shield.jl")
export net_shield, eigenvalue_reduction

include("maximize_influence.jl")
export maximize_influence

include("maximize_influence_CELF.jl")
export maximize_influence_CELF

include("maximize_influence_CWY.jl")
export maximize_influence_CWY

include("heuristics.jl")
export degree_heuristic, random_heuristic, acquaintance_heuristic

include("example_graphs.jl")
export prakash_fig6dot2

end
