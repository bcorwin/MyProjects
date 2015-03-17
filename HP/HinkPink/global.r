load("HP Files.rdata")
source("hp.r")

hps <- data.frame(name = c("No syllable restraint",
                           "Hink-Pink (1 syllable)",
                           "Hinky-Pinky (2 syllables)",
                           "Hinkity-Pinkity (3 syllables)"),
                  scnt = c(NA, seq(1,3)),
                  stringsAsFactors = FALSE)

syllCnts <- data.frame(name = c("No syllable restraint",
                                "1 syllable",
                                "2 syllables",
                                "3 syllables",
                                "Unknown"
                                ),
                       scnt = c(NA, seq(1,3), -1),
                       stringsAsFactors = FALSE)