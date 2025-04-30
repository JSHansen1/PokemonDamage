#' Calculate damage using the Gen 1 Pokémon formula (simplified)
#'
#' This function calculates how much damage one Pokémon does to another
#' using a simplified version of the original Generation 1 formula
#' It pulls base stats from the 'pokemon' package based on attacker and defender names
#' It does not include STAB or type effectiveness
#' Critical hits are based on the attacker's speed
#' Critical hits double the attacker's level for the damage calculation

#'
#' @param attacker The name of the attacking Pokémon
#' @param defender The name of the defending Pokémon
#' @param attacker_level The level of the attacking Pokémon (manual input)
#' @param power The base power of the move being used (manual input)
#'
#' @return The amount of damage dealt
#' @export

damage_calc <- function(attacker, defender, attacker_level, power) {
  # Check for the 'pokemon' package
  if (!requireNamespace("pokemon")) {
    stop("The 'pokemon' package is required but not installed")
  }

  # Load the dataset
  data("pokemon", package = "pokemon")

  # Lowercase all letters of attacker and defender name to automatically match
  # the 'pokemon' package dataset
  attacker <- tolower(attacker)
  defender <- tolower(defender)

  # Get attacker and defender stats, fails if name doesnt match 'pokemon' database
  attacker_stats <- subset(pokemon, pokemon == attacker)
  defender_stats <- subset(pokemon, pokemon == defender)

  if (nrow(attacker_stats) == 0) stop("Attacker not found in 'pokemon' dataset")
  if (nrow(defender_stats) == 0) stop("Defender not found in 'pokemon' dataset")

  attack <- attacker_stats$attack
  speed <- attacker_stats$speed
  defense <- defender_stats$defense

  # Random damage multiplier that exists in Gen 1
  rand <- runif(1, min = 0.85, max = 1.00)

  # Crit chance is based on speed stat
  crit_chance <- speed / 512
  is_crit <- runif(1) < crit_chance

  # If the move crits, it doubles the pokemon's level in the damage calculation
  # not double the damage like you might think
  effective_level <- if (is_crit) attacker_level * 2 else attacker_level

  # Simplified Gen 1 damage formula
  base <- (((2 * effective_level / 5 + 2) * power * attack / defense) / 50) + 2

  # Final damage after randomness modifiers, always rounded down
  damage <- floor(base * rand)

  return(damage)
}


