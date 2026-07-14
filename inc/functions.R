# Funktion zur Berechnung des Standardfehlers
fm_se <- function(x) {
  x <- x[!is.na(x)]
  n = length(x)
  sd(x) / sqrt(n)
}

# Funktion zur Berechnung der Schiefe
fm_skewness <-  function(x, n = length(x)) {
  x <- x[!is.na(x)]
  df <- data.frame(x = x, mean_x = mean(x))
  df <- df |> mutate(
    nu = (x - mean_x)^3, # für numerator = Zähler
    de = (x - mean_x)^2) # für denominator = Nenner
  numerator = sum(df$nu)/n # Ausdruck ist Zähler der Berechnung 
  denominator = (sum(df$de)/n) ^ (3/2) # Ausdruck ist Nenner der Berechnung 
  numerator/denominator # Ergebnis ausgeben
}

# Funktion zur Berechnung des Kurtosis
fm_kurtosis <- function(x, n = length(x)) {
  x <- x[!is.na(x)]
  df <- data.frame(x = x, mean_x = mean(x))
  df <- df |> mutate(
    nu = (x - mean_x)^4, # für numerator = Zähler
    de = (x - mean_x)^2) # für denominator = Nenner
  numerator = sum(df$nu)/n # Ausdruck ist Zähler der Berechnung 
  denominator = (sum(df$de)/n) ^ 2 # Ausdruck ist Nenner der Berechnung 
  numerator/denominator # Ergebnis ausgeben
}