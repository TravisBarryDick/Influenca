# Influenca

This Julia package accopanies the report "(No) Good Social Networking", Travis Dick's final project for CMPUT 15-826. It contains code for loading social networks from file, and implementations of 5 algorithms for influence maximization and opimtal immunization on those social networks.

# Installation

To install this package, add the base directory to your julia `LOAD_PATH` variable. This can be done by adding a line like `push!(LOAD_PATH, "~/Influenca")` to your `.juliarc.jl` file.

# Basic usage

There are 5 main functions provided by this package:

- `G = load_graph(path)`, which loads a graph from the file pointed to by `path`. It is assumed that each line of the file contains two integers `i` and `j` separated by white space, which indicates that there is an undirected edge between nodes `i` and `j`.
- `S = maximize_influence_CELF(G::Graph, β, k)` runs the greedy hill-climbing algorithm of Kempe et al. (2003) and outputs a set `S` of nodes that approximately maximizes the influence function for the independent cascade model on the graph `G`.
- `S = net_shield(G::Graph, k)` runs the NetShield algorithm of Prakash (2012) to find the set of nodes `S` that approximately maximize the shield-value score. Removing these nodes from the graph approximately minimizes the first eigenvalue of the adjacency matrix.
- `evaluate_influence(G, β, S; N=20000)` runs `N` simulations of the independent cascade model with infections starting in `S` and returns the average number of infected nodes when the simulation terminates.
- `evaluate_immunization(G, β, S; m = 10, N = 20000)` runs `N` simulations of the independent cascade model starting from `m` randomly chosen infections on the graph `G` after removing the nodes in `S`.

There are additional functions provided by the library which are documented in
the source code.
