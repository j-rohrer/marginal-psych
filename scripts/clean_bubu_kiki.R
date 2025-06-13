# Code from Heyman et al.
library(dplyr)

temp = list.files(
  path = "data/example0/data",
  pattern = "*main.csv",
  full.names = TRUE
) #all filenames with data from the main experiment
dataMain = lapply(temp, read.csv, sep = ";")
dataMain = do.call(rbind, dataMain) #creates dataframe
ppInfo = read.csv("data/example0/data/InfoParticipants.csv", sep = ";") #reads in participant info file
dataMain = left_join(dataMain, ppInfo, by = c("pp" = "ppNumber")) #combines participant info with the rest of the data
tempControl = list.files(
  path = "data/example0/data",
  pattern = "*control.csv",
  full.names = TRUE
) #all filenames with data from the control experiment
dataControl = lapply(tempControl, read.csv, sep = ";")
dataControl = do.call(rbind, dataControl) #creates dataframe

# Applying some exclusion criteria
dataMain <- dataMain[dataMain$knowledge == "no", ] # only participants who do not know the effect
dataMain <- dataMain[dataMain$rt != 998, ] # remove timeouts
dataMain <- dataMain[dataMain$Accuracy == 0, ] # remove wrong responses
write.csv(dataMain, file = here("data/bubu_kiki_0.csv"), row.names = FALSE)
