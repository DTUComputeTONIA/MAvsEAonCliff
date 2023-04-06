# How Well Does the Metropolis Algorithm Cope With Local Optima?
This is the source code repository for the project accompanying the paper *"How Well Does the Metropolis Algorithm Cope With Local Optima?"* by - **Benjamin Doerr**, **Taha El Ghazi El Houssaini**, **Amirhossein Rajabi** ,**Carsten Witt**, published in The Genetic and Evolutionary Computation Conference 2023 *(GECCO 2023)* is going to be held in Lisbon, Portugal from July 15-19, 2023.

## Abstract
> The Metropolis algorithm (MA) is a classic stochastic local search heuristic. It avoids getting stuck in local optima by occasionally accepting inferior solutions. To better and in a rigorous manner understand this ability, we conduct a mathematical runtime analysis of the MA on the CLIFF benchmark. Apart from one local optimum, cliff functions are monotonically increasing towards the global optimum. Consequently, to optimize a cliff function, the MA only once needs to accept an inferior solution. Despite seemingly being an ideal benchmark for the MA to profit from its main working principle, our mathematical runtime analysis shows that this hope does not come true. Even with the optimal temperature (the only parameter of the MA), the MA optimizes most cliff functions less efficiently than simple elitist evolutionary algorithms (EAs), which can only leave the local optimum by generating a superior solution possibly far away. This result suggests that our understanding of why the MA is often very successful in practice is not yet complete. Our work also suggests to equip the MA with global mutation operators, an idea supported by our preliminary experiments.

## Project Structure
- `experiments`: Folder containing experiments codes.
- `src`: Folder containing the source code of the project core.
- `test`: Folder containing test files for the project.
- `Project.toml`: Julia project configuration file.
- `Manifest.toml`: Julia project manifest file.
- `compare150.csv` and `mutations20.csv`: CSV files containing the results of two experiments.

## Usage
1. Clone the repository to your local machine.
2. Make sure you have Julia installed on your machine.
3. run the Julia codes in the folder `experiments` to reproduce the experiments or analyze the results.


## Citation
If you use this code or project in your research, please cite the accompanying paper:
```
@inproceedings{doerr2023metropolis,
  title={How Well Does the Metropolis Algorithm Cope With Local Optima?},
  author={Doerr, Benjamin and El Ghazi El Houssaini, Taha and Rajabi, Amirhossein and Witt, Carsten},
  booktitle={Proceedings of the Genetic and Evolutionary Computation Conference},
  year={2023},
  organization={ACM}
}
```


