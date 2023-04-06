using Pidoh
using LaTeXStrings
using DataFrames
using Statistics, DataFrames
using Plots;


function makeexperiment()
    instances::Array{Instance,1} = []
    algorithms::Array{AbstractAlgorithm,1} = []

    for n in [100]
        for d in [3]
            for m in 8:4:32
                for α in [20,30,40,60]
                    algo_num = 4
                    append!(algorithms, [
                        ea1p1(mutation=UniformlyIndependentMutation(1/n),
                        stop=FixedBudget(10^10),name=L"(1+1)EA, p=1/n"),

                        SimulatedAnnealing(FixedCooling(α), name=L"MA"),
                        SimulatedAnnealing(FixedCooling(α), mutation=UniformlyIndependentMutation(1/n), name=L"$MA$ with standard bit mutation"),
                        SimulatedAnnealing(FixedCooling(α), mutation=HeavyTailedMutation(1.5, n), name=L"$MA$ with heavy-tailed mutation, $\beta=1.5$"),
                    ])
                append!(instances, [Instance(generator = RandBitStringIP(n), CliffTwoParameters(n, m, d)) for _ in 1:algo_num])
                end
            end
        end
    end
    return Experiment("mutationsbetter", algorithms, instances, repeat = 100)
end

experiment = makeexperiment()

res = run(experiment)

data = runtimes(experiment)


theme(:vibrant)

show(data, allcols=true)
categories = :AlgorithmParams_name
xdata = :ProblemParam_m
ydata = :runtime
alphadata = 20   #[40,60,80]
sort!(data, :AlgorithmParams_name, rev=false)

marker_list = [:star4,:circle,  :star6, :ltriangle, :utriangle, :vline, :hline, :+, :x]
cnt = 1
plt = plot()
for cat in keys(groupby(data, categories))
    filtered_data = filter(row -> row[categories] == cat[1] && 
    (ismissing(row[:AlgorithmParams_cooling_temperature]) || row[:AlgorithmParams_cooling_temperature] == alphadata)
    , data)
    aggregated_data = combine(groupby(filtered_data, xdata), ydata => mean)

    algorithm_label = cat[1]
    if startswith(algorithm_label, "\$(1+1)EA, p=1/n\$")
        algorithm_label = L"(1+1)EA, $p=1/n$"
        icolor = theme_palette(:tab10).colors.colors[1]
    elseif startswith(algorithm_label, "\$MA\$ with heavy")
            algorithm_label = L"MA with heavy-tailed mutation, $\beta=1.5$"
            icolor = theme_palette(:tab10).colors.colors[2]
    elseif startswith(algorithm_label, "\$MA\$ with standard")
            algorithm_label = LaTeXString("MA with standard bit mutation")
            icolor = theme_palette(:tab10).colors.colors[3]
    elseif startswith(algorithm_label, "\$MA\$")
        algorithm_label = LaTeXString("MA")
        icolor = theme_palette(:tab10).colors.colors[4]
    end

    plot!(
        plt,
        aggregated_data[!,1],
        aggregated_data[!,2],
        fillalpha = 0.5,
        dpi = 500,
        fontfamily="Computer Modern",
        linewidth = 2,
        markersize = 4,
        linealpha = 0.5,
        size = (350, 320),
        label = algorithm_label,
        markershape = marker_list[cnt],
        xlabel = string(xdata),
        ylabel = string(ydata),
        yscale = :log10,
        legend_position=:topright,
        background_color_legend = RGBA(1,1,1,0.7),
        xticks = 8:8:32,
        color = icolor
    )
    cnt = cnt + 1
end
plt
plot!(plt, xlabel = L"m")

savefig(plt, "mutations20.pdf")

