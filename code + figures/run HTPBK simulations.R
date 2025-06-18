# set working directory to code directory
setwd("XXX/code + figures")

inSilicoCLModelFilesPath = "../model files/In silico clearance"
inVivoCLModelFilesPath =  "../model files/In vivo clearance (if available)"
  

# make sure OSP suite and OSP Suite R package are installed
library(ospsuite)
library(tidyverse)
library(writexl)
library(readxl)

# execute HTPBK Simulations
for (file in list.files(inSilicoCLModelFilesPath)){
  
  sim = loadSimulation(paste0(inSilicoCLModelFilesPath, "/", file))
  
  simResults = runSimulation(sim)
  
  simResultsPath = paste0("../data/Simulation results/In silico clearance/", gsub("pkml", "csv", file))
  exportResultsToCSV(simResults, simResultsPath)
}


for (file in list.files(inVivoCLModelFilesPath)){
  
  sim = loadSimulation(paste0(inVivoCLModelFilesPath, "/", file))
  
  simResults = runSimulation(sim)
  
  simResultsPath = paste0("../data/Simulation results/In vivo clearance (if available)/", gsub("pkml", "csv", file))
  exportResultsToCSV(simResults, simResultsPath)
}



# extract Cmax values of each drug
inSilicoCLResultsPath = "../data/Simulation results/In silico clearance"
inVivoCLResultsPath =  "../data/Simulation results/In vivo clearance (if available)"




# In Silico
CmaxSummary = data.frame(compoundID = numeric(), type = character(),
                         firstCmax = numeric(), lastCmax = numeric(),
                         stringsAsFactors = F)

for (file in list.files(inSilicoCLResultsPath)){
  compoundID = as.numeric(str_extract(file, "^[0-9]+"))
  
  simResults = read.csv(paste0(inSilicoCLResultsPath, "/", file))
  
  firstPlasmaCmax = simResults  %>%
    filter(Time..min. <= (60*24*1))
  
  firstPlasmaCmax = max(firstPlasmaCmax$Organism.PeripheralVenousBlood.average.compound.Plasma..Peripheral.Venous.Blood...µmol.l.)
  lastPlasmaCmax = max(simResults$Organism.PeripheralVenousBlood.average.compound.Plasma..Peripheral.Venous.Blood...µmol.l.)
  
  newRow = data.frame(
    compoundID = compoundID,
    type = "InSilico",
    firstPlasmaCmax = firstPlasmaCmax,
    lastPlasmaCmax = lastPlasmaCmax,
    stringsAsFactors = FALSE
  )
  
  CmaxSummary =  rbind(CmaxSummary, newRow)
}
write_xlsx(CmaxSummary, paste0(inSilicoCLResultsPath, "/AllCmaxValuesMergedInSilico.xlsx"))




# In Vivo
CmaxSummary = data.frame(compoundID = numeric(), type = character(),
                         firstCmax = numeric(), lastCmax = numeric(),
                         stringsAsFactors = F)

for (file in list.files(inVivoCLResultsPath)){
  compoundID = as.numeric(str_extract(file, "^[0-9]+"))
  
  simResults = read.csv(paste0(inVivoCLResultsPath, "/", file))
  
  firstPlasmaCmax = simResults  %>%
    filter(Time..min. <= (60*24*1))
  
  firstPlasmaCmax = max(firstPlasmaCmax$Organism.PeripheralVenousBlood.average.compound.Plasma..Peripheral.Venous.Blood...µmol.l.)
  lastPlasmaCmax = max(simResults$Organism.PeripheralVenousBlood.average.compound.Plasma..Peripheral.Venous.Blood...µmol.l.)
  
  newRow = data.frame(
    compoundID = compoundID,
    type = "InVivo",
    firstPlasmaCmax = firstPlasmaCmax,
    lastPlasmaCmax = lastPlasmaCmax,
    stringsAsFactors = FALSE
  )
  
  CmaxSummary =  rbind(CmaxSummary, newRow)
}
write_xlsx(CmaxSummary, paste0(inVivoCLResultsPath, "/AllCmaxValuesMergedInVivo.xlsx"))


# finally, merge both into a single Cmax file
InVivoCLCmax = read_xlsx(paste0(inVivoCLResultsPath , "/AllCmaxValuesMergedInVivo.xlsx"))
InSilicoCLCmax = read_xlsx(paste0(inSilicoCLResultsPath, "/AllCmaxValuesMergedInSilico.xlsx"))


mergedDf = rbind(InVivoCLCmax, InSilicoCLCmax)
write_xlsx(mergedDf, path = "../data/Simulation results/AllCmaxValuesMerged.xlsx")
