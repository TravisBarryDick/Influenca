@enum NodeState Susceptible Infected Recovered

type SimulationState
    # Problem parameters
    g::Graph
    β::Float64
    δ::Float64
    # Simulation state
    s::Vector{NodeState} # vector of node states
    infected::Vector{Int} # list of infected nodes
    _infected::Vector{Int}
    recovered::Vector{Int} # List of recovered nodes
    iteration::Int
end

"""
Constructs a `SimulationState` for SIR virus propagation model on the graph `g`.
"""
function SimulationState(g::Graph, β, δ)
    s = [Susceptible for i in 1:num_nodes(g)]
    infected = Array(Int, 0)
    _infected = Array(Int, 0)
    recovered = Array(Int, 0)
    return SimulationState(g, β, δ, s, infected, _infected, recovered, 0)
end

"""
Returns all nodes to the `Susceptible` state. For large networks this is
preferable to creating a new `SimulationState`, since it avoids reallocating
the vector of states (and the cost is only linear in the number of infected and
recovered nodes, rather than the size of the network).
"""
function reset!(s::SimulationState)
    while !isempty(s.recovered)
        s.s[pop!(s.recovered)] = Susceptible
    end
    while !isempty(s.infected)
        s.s[pop!(s.infected)] = Susceptible
    end
    s.iteration = 0
    nothing
end

"Sets node `i` to be `Infected` if it was originally `Susceptible`."
function infect!(s::SimulationState, i)
    if s.s[i] == Susceptible
        s.s[i] = Recovered
        push!(s.infected, i)
    end
    nothing
end

"Sets node `i` to be `Recovered` if it was originally `Susceptible`."
function immunize!(s::SimulationState, i)
    if s.s[i] == Susceptible
        s.s[i] = Recovered
        push!(s.recovered, i)
    end
    nothing
end

"""
Simulates the spread of disease through the social until there are no infected
nodes. Starts from th provided `SimulationState`.
"""
function simulate!(s::SimulationState; approximate=false)
    while !isempty(s.infected)
        s._infected, s.infected = s.infected, s._infected # swap!
        while !isempty(s._infected)
            i = pop!(s._infected)
            for j in neighbors(s.g, i)
                if s.s[j] == Susceptible && rand() < s.β
                    s.s[j] = Infected
                    push!(s.infected, j)
                end
            end
            if rand() < s.δ
                s.s[i] = Recovered
                push!(s.recovered, i)
            else
                push!(s.infected, i)
            end
        end
        s.iteration += 1
    end
    return s
end

"""
Simulates `N` propagations of the virus starting from `m` randomly chosen
infected nodes after putting the nodes in `I` into the recovered state. Returns
the average number of infected nodes per simulation.
"""
function evaluate_immunization!(s::SimulationState, I; N::Int=20000, m::Int=10)
    total = 0.0
    for iter in 1:N
        reset!(s)
        for i in I
            immunize!(s, i)
        end
        for i in 1:m
            infect!(s, ceil(Int, rand() * num_nodes(s.g)))
        end
        simulate!(s)
        total += length(s.recovered) - length(I)
    end
    return total/N
end

"""
Simulates `N` propagations of the virus starting with the nodes in `I` being
infected. Returns the average number of infected nodes per simulation.
"""
function evaluate_influence!(s::SimulationState, I; N::Int=20000)
    total = 0.0
    for iter in 1:N
        reset!(s)
        for i in I
            infect!(s, i)
        end
        simulate!(s)
        total += length(s.recovered)
    end
    return total/N
end