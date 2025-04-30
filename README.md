# PokemonDamage

This is an R package for simulating a simplified version of a pokemon attacking
modeled around Generation 1 mechanics

## Installation

This package can be installed directly from GitHub using the following

```r
# install.packages("devtools")
devtools::install_github("JSHansen1/PokemonDamage")
```

## Functions

This package includes two main functions:

`damage_calc()`: Calculates one instance of damage from an attacking Pokémon
to a defender, using simplified Gen 1 mechanics.

`simulate_battle()`: Simulates a full sequence where the attacker uses the same
move repeatedly until the defender is KO’d. Supports running multiple simulations
with the `n` argument.

## Example Usage

```r
library(PokemonDamage)

# Run one simulation
simulate_battle("Charizard", "Blastoise", attacker_level = 50, defender_level = 50, power = 100)

# Run many simulations quietly, without automatically printing to the console
simulate_battle("Charizard", "Blastoise", attacker_level = 50, defender_level = 50, power = 100, n = 100, print = FALSE)
```

## Design Notes

This package pulls base stats from the `{pokemon}` R package
STAB (Same-Type Attack Bonus) and type effectiveness are not included due to dataset limitations
(there are no moves, so we just choose a power for the attack instead)
Critical hits are based on the attacker’s Speed stat using a Gen 1 style formula
The damage formula includes the original Gen 1 random multiplier between 0.85 and 1
ou can simulate one battle or many using the `n` argument in `simulate_battle()`

## License

This package is licensed under the MIT License © Joshua Hansen
