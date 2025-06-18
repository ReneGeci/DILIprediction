# set working directory to code directory
setwd("XXX/code + figures")


library(ospsuite)
library(readxl)

simFilePath <- "../model files/PBBA model.pkml" #simulation path
concPath <- '../data/Simulation results/In silico clearance' # HT-PBK results path
resPath <- '../data/Simulation results/PBBA results/'
KiPath <- '../data/Collected data/Drug Ki values.xlsx' #file with Ki values and compound IDs
model <- '_InSilicoHTPBK_D1' # HT-PBK Model
inputs <- c('Organism.PeripheralVenousBlood.average.compound.Plasma..Peripheral.Venous.Blood...µmol.l.')
outputNames <- c('plasma')
timeCol <-'Time..min.'
firstAdministrationTime <- 28800 #min

# Loading simulation
sim <- loadSimulation(simFilePath)

# List folders in directory
folders <- list.files(path = concPath)

# Read Excel with Ki values
KiValues <- read_excel(KiPath)

# file Name
for (folder in folders){

  i <- 1
  compNo <- strsplit(folder, "_")[[1]][1]
  fileName <- paste0(compNo, model, '.csv')
  concFilePath <- paste0(concPath, '/', fileName)
  data <- read.csv(concFilePath)
  for (input in inputs){
    conc <- data[ , input]
    time <- data[ , timeCol] + firstAdministrationTime
    conc <- c(0, conc)
    time <- c(0, time)
    
    tableParam <- getParameter("Organism|DrugConc", sim)
    tableParam$formula$setPoints(time, conc)
    
    Ki_BSEP <- KiValues$medianBSEPKiµM[KiValues$compoundID==compNo]
    
    if (is.na(Ki_BSEP) || is.nan(Ki_BSEP)) {
      next
    }
    
    Ki <- getParameter('Organism|Ki', sim)
    setParameterValues(Ki, Ki_BSEP)
    
    simulationResults <- runSimulations(simulations = sim)
    
    simulationResults <- simulationResults[[1]]
    exportResultsToCSV(results = simulationResults, filePath = paste0(resPath, compNo, '_', outputNames[[i]],'_InSilico','.csv'))
    i <- i + 1
  }
}
