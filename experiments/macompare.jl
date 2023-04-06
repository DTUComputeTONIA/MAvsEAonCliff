using Pidoh
using LaTeXStrings
using DataFrames
using Statistics, DataFrames
using Plots;


function makeexperiment()
    instances::Array{Instance,1} = []
    algorithms::Array{AbstractAlgorithm,1} = []

    for n in [50,100,150]
        for d in [3]
            for m in 8:4:32
                algo_num = 7
                append!(algorithms, [
                    ea1p1(mutation=UniformlyIndependentMutation(1/n),
                    stop=FixedBudget(10^10),name=L"(1+1)EA, p=1/n"),
                    ea1p1(mutation=UniformlyIndependentMutation(ceil(d+1)/n),
                    stop=FixedBudget(10^10),name=L"(1+1)EA, p=\lceil d+1\rceil /n"),
                    ea1p1(mutation=HeavyTailedMutation(1.5, n),
                    stop=FixedBudget(10^10), name=L"Fast-(1+1)EA, \beta=1.5"),
                    ea1p1SD(R=n^2,stop=FixedBudget(10^10), thresholds = threshold_gen(SDCounter, n, n^2), name=L"SD-(1+1)EA"),
                    SimulatedAnnealing(FixedCooling(20), name=L"MA, \alpha=20"),
                    SimulatedAnnealing(FixedCooling(30), name=L"MA, \alpha=30"),
                    SimulatedAnnealing(FixedCooling(40), name=L"MA, \alpha=40"),
                ])
            append!(instances, [Instance(generator = RandBitStringIP(n), CliffTwoParameters(n, m, d)) for _ in 1:algo_num])
            end
        end
    end

    return Experiment("macompare", algorithms, instances, repeat = 100)
end

experiment = makeexperiment()

res = run(experiment)

data = runtimes(experiment)

theme(:vibrant)
show(data, allcols=true)

categories = :algorithm
xdata = :ProblemParam_m
ydata = :runtime
ndata = 150
sort!(data, :AlgorithmParams_cooling_temperature, rev=false)


marker_list = [:circle, :star5, :diamond, :utriangle, :pentagon, :heptagon, :star4, :star6, :star7, :star8, :vline, :hline, :+, :x]
cnt = 1
plt = plot()
for cat in keys(groupby(data, categories))
    println(cat[1])
    filtered_data = filter(row -> row[categories] == cat[1] && !ismissing(row[:ProblemParam_n]) && row[:ProblemParam_n] == ndata, data)
    aggregated_data = combine(groupby(filtered_data, xdata), ydata => mean)
    sort!(aggregated_data, 2, rev=true)
    algorithm_label = cat[1]
    if startswith(algorithm_label, "\$SD")
        algorithm_label = LaTeXString("SD-(1+1)EA")
        icolor = theme_palette(:tab10).colors.colors[5]
    elseif startswith(algorithm_label, "\$Fast")
        algorithm_label = L"Fast-(1+1)EA, $\beta=1.5$"
        icolor = theme_palette(:tab10).colors.colors[6]
    elseif startswith(algorithm_label, "\$(1+1)EA, p=1/n\$")
        algorithm_label = L"(1+1)EA, $p=1/n$"
        icolor = theme_palette(:tab10).colors.colors[1]
    elseif startswith(algorithm_label, "\$(1+1)EA, p=\\lceil")
        algorithm_label = L"(1+1)EA, $p=\lceil d+1 \rceil/n$"
        icolor = theme_palette(:tab10).colors.colors[7]
    elseif startswith(algorithm_label, "\$MA, \\alpha=20")
        algorithm_label = L"MA, $\alpha=20$"
        icolor = theme_palette(:tab10).colors.colors[4]
    elseif startswith(algorithm_label, "\$MA, \\alpha=30")
        algorithm_label = L"MA, $\alpha=30$"
        icolor = theme_palette(:tab10).colors.colors[8]
    elseif startswith(algorithm_label, "\$MA, \\alpha=40")
        algorithm_label = L"MA, $\alpha=40$"
        icolor = theme_palette(:tab10).colors.colors[9]
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
        markershape = marker_list[cnt],
        markerstrokewidth = 0,
        linealpha = 0.5,
        size = (350, 320),
        label = algorithm_label,
        xlabel = string(xdata),
        ylabel = string(ydata),
        yscale = :log10,
        legend_position=:topright,
        # foreground_color_legend = nothing,
        color = icolor,
        background_color_legend = RGBA(1,1,1,0.7),
        xticks = 8:8:32,
        yticks = [10^5, 10^7, 10^9],
        xlims = (7.7, 32.2)
    )
    cnt = cnt+1
end
plt
plot!(plt, xlabel = L"m")

savefig(plt, "compare150.pdf")
