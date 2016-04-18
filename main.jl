#!/usr/bin/env julia

using Influenca, ArgParse, JLD

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--graph", "-g"
            help = "path to the graph file."
            arg_type = ASCIIString
            required = true
        "--beta", "-b"
            help = "Infection probability in the independent cascade model."
            arg_type = Float64
            required = true
        "--num_nodes", "-k"
            help = "Number of nodes to choose."
            arg_type = Int
            required = true
        "--algorithm", "-a"
            help = "one of {mi, mi_celf, mi_cwy, netshield}"
            arg_type = ASCIIString
            required = true
        "--num_simulations", "-N"
            help = "Number of simulations for influence maximization algorithms."
            arg_type = Int
            default = 20000
    end
    parsed_args = parse_args(ARGS, s)
    graph_path = parsed_args["graph"]
    k = parsed_args["num_nodes"]
    alg = parsed_args["algorithm"]
    β = parsed_args["beta"]
    N = parsed_args["num_simulations"]

    g = load_graph(graph_path)
    tic()
    if alg == "mi"
        result = maximize_influence(g, β, k, N=N)
    elseif alg == "mi_celf"
        result = maximize_influence_CELF(g, β, k, N=N)
    elseif alg == "mi_cwy"
        result = maximize_influence_CWY(g, β, k, N=N)
    elseif alg == "netshield"
        result = net_shield(g, k)
    end
    running_time = toq()

    output_file = "$(basename(graph_path))_$(alg)_beta=$(β)_N=$(N)_k=$(k).jld"
    save(output_file, "k", k, "alg", alg, "beta", β, "N", N, "running_time", running_time, "result", result)
end

main()
