#' Simulates a pokemon battle where the attacker uses the same move until the
#' defender is KO'd, option to simulate many at once by specifying 'n'
#'
#' This function uses damage_calc() to simulate how many turns it takes for
#' the attacker to KO the defender using a specific move
#'
#' @param attacker The name of the attacking Pokémon
#' @param defender The name of the defending Pokémon
#' @param attacker_level The level of the attacking Pokémon (manual input)
#' @param defender_level The level of the defending Pokémon (manual input)
#' @param power The base power of the move (manual input)
#' @param n Number of simulations to run (default is 1)
#' @param print Whether to print the results automatically (default is TRUE).
#' Set to FALSE when running a large number of simulations to avoid console clutter
#'
#' @return A list containing turn counts damage logs and HP logs
#' @export

simulate_battle <- function(attacker, defender, attacker_level, defender_level, power, n = 1, print = TRUE) {
  # Check for the 'pokemon' package
  if (!requireNamespace("pokemon")) {
    stop("The 'pokemon' package is required but not installed")
  }

  # Load the pokemon dataset
  data("pokemon", package = "pokemon")

  # Lowercase all letters of attacker and defender name to automatically match
  # the 'pokemon' package dataset
  attacker <- tolower(attacker)
  defender <- tolower(defender)

  # Defense against negative level input
  if (attacker_level <= 0 || defender_level <= 0) {
    stop("Both attacker and defender levels must be positive integers")
  }

  # Get defender's base HP and calculate actual HP based on level
  defender_stats <- subset(pokemon, pokemon == defender)
  if (nrow(defender_stats) == 0) stop("Defender not found in 'pokemon' dataset")

  base_hp <- defender_stats$hp
  max_hp <- floor((2 * base_hp * defender_level) / 100) + defender_level + 10

  # Log how many turns have passed and the damage done
  turn_results <- numeric(n)
  damage_results <- vector("list", n)
  hp_results <- vector("list", n)

  # Loop through and simulate the battle 'n' times
  for (i in 1:n) {
    total_damage <- 0
    turn_count <- 0
    damage_log <- c()
    hp_log <- c()

    # Keep attacking until the defender's HP reaches 0 or below (Pokemon is KO'd)
    while (total_damage < max_hp) {
      dmg <- damage_calc(attacker, defender, attacker_level, power)
      total_damage <- total_damage + dmg
      turn_count <- turn_count + 1
      damage_log <- c(damage_log, dmg)
      current_hp <- max(0, max_hp - total_damage)
      hp_log <- c(hp_log, current_hp)
    }

    # Store the number of turns, the damage done, and the defender HP for each turn
    turn_results[i] <- turn_count
    damage_results[[i]] <- damage_log
    hp_results[[i]] <- hp_log
  }

  results <- (list(turns = turn_results, damage_logs = damage_results, starting_defender_hp = max_hp, hp_logs = hp_results))

  # Automatically print results unless user disables it such as for high 'n' values
  if (print) {
    print(results)
  }

  invisible(results)
}


