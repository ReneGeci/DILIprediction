# AUC and Cmax Fold Change

# Load required libraries

# set working directory to code directory
setwd("XXX/code + figures")


library(readxl)
library(openxlsx)


foldersPath <- c('../data/Simulation results/PBBA results/')
dirPathList <- list()
folders <- list.files(path = foldersPath)
for (folder in folders) {
  folderPath <- paste0(foldersPath, folder)
  dirPathList <- c(dirPathList, folderPath)
}


benchmarkPath <- '../data/Simulation results/PBBA_Conjugation_NoInhibition-HR.csv'
ResultsPath <- '../data/Simulation results/HT_PBBA_v5_Aleo_30days_InSilico.xlsx'

startTime <- 28800
#endTime <- 30240
endTime <- 72000

# Define the list of output variables
outputs <- c(
  "Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",                 
  "Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",         
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",  
  "Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                    
  "Organism.Liver.CDCA.Tissue..Liver...µmol.l.",                                                   
  "Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.G.CDCA.Tissue..Liver...µmol.l.",                                                 
  "Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.T.CDCA.Tissue..Liver...µmol.l.",
  
  "Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tBA.Tissue..Liver...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tConjBA.Tissue..Liver...µmol.l."
)

colNames <- c(
  'AUC PeripheralVenousBlood|Plasma|CDCA','Cmax PeripheralVenousBlood|Plasma|CDCA',
  'AUC PeripheralVenousBlood|PlasmaUnbound|CDCA','Cmax PeripheralVenousBlood|PlasmaUnbound|CDCA',
  'AUC PeripheralVenousBlood|Plasma|GCDCA','Cmax PeripheralVenousBlood|Plasma|GCDCA',
  'AUC PeripheralVenousBlood|PlasmaUnbound|GCDCA','Cmax PeripheralVenousBlood|PlasmaUnbound|GCDCA',
  'AUC PeripheralVenousBlood|Plasma|TCDCA','Cmax PeripheralVenousBlood|Plasma|TCDCA',
  'AUC PeripheralVenousBlood|PlasmaUnbound|TCDCA','Cmax PeripheralVenousBlood|PlasmaUnbound|TCDCA',
  'AUC Liver|Intracellular|CDCA', 'Cmax Liver|Intracellular|CDCA', 
  'AUC Liver|Intracellular|GCDCA', 'Cmax Liver|Intracellular|GCDCA', 
  'AUC Liver|Intracellular|TCDCA', 'Cmax Liver|Intracellular|TCDCA',
  'AUC Liver|IntracellularUnbound|CDCA', 'Cmax Liver|IntracellularUnbound|CDCA',
  'AUC Liver|Tissue|CDCA', 'Cmax Liver|Tissue|CDCA', 
  'AUC Liver|IntracellularUnbound|GCDCA', 'Cmax Liver|IntracellularUnbound|GCDCA',
  'AUC Liver|Tissue|GCDCA', 'Cmax Liver|Tissue|GCDCA',
  'AUC Liver|IntracellularUnbound|TCDCA', 'Cmax Liver|IntracellularUnbound|TCDCA',
  'AUC Liver|Tissue|TCDCA', 'Cmax Liver|Tissue|TCDCA',
  'AUC PeripheralVenousBlood|Plasma|tBA','Cmax PeripheralVenousBlood|Plasma|tBA',
  'AUC PeripheralVenousBlood|PlasmaUnbound|tBA','Cmax PeripheralVenousBlood|PlasmaUnbound|tBA',
  'AUC Liver|Intracellular|tBA', 'Cmax Liver|Intracellular|tBA',
  'AUC Liver|IntracellularUnbound|tBA', 'Cmax Liver|IntracellularUnbound|tBA',
  'AUC Liver|Tissue|tBA', 'Cmax Liver|Tissue|tBA',
  'AUC PeripheralVenousBlood|Plasma|tConjBA','Cmax PeripheralVenousBlood|Plasma|tConjBA',
  'AUC PeripheralVenousBlood|PlasmaUnbound|tConjBA','Cmax PeripheralVenousBlood|PlasmaUnbound|tConjBA',
  'AUC Liver|Intracellular|tConjBA', 'Cmax Liver|Intracellular|tConjBA',
  'AUC Liver|IntracellularUnbound|tConjBA', 'Cmax Liver|IntracellularUnbound|tConjBA',
  'AUC Liver|Tissue|tConjBA', 'Cmax Liver|Tissue|tConjBA')

totalBA <- function(df) {
  df$`Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.` <- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]    
  
  df$`Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +    
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  df$`Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] + 
    df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  df$`Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  df$`Organism.Liver.tBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."] 
  
  return(df)
}

totalConjBA <- function(df) {
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] + 
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  
  df$`Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  
  df$`Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +  
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  
  df$`Organism.Liver.tConjBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                                
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."]  
  return(df)
}

auc <- function(df, output, startTime, endTime) {
  aucSum <- 0
  time <- 'Time..min.'
  startIndex <- which(df$Time..min. == startTime)
  endIndex <- which(df$Time..min. == endTime)
  
  for (i in startIndex:(endIndex - 1)) {
    auc <- (df[i + 1, time] - df[i, time]) * (df[i + 1, output] + df[i, output]) / 2
    aucSum <- aucSum + auc
  }
  return(aucSum)
}

cmax <- function(df, output, startTime, endTime) {
  time <- 'Time..min.'
  startIndex <- which(df$Time..min. == startTime)
  endIndex <- which(df$Time..min. == endTime)
  
  cmax <- max(df[startIndex:endIndex, output])
  return(cmax)
}



benchmarkData <- function(benchmarkPath, outputs, startTime, endTime, colNames) {
  # Read benchmark data
  benchmark <- read.csv(benchmarkPath)
  
  #Empty List
  row <- list()
  
  # Total BA and Total Conj. BA
  benchmark <- totalBA(benchmark)
  benchmark <- totalConjBA(benchmark)
  
  #Calculate AUC - Cmax of benchmark
  
  for (output in outputs) {
    AUC <- auc(benchmark, output, startTime, endTime)
    Cmax <- cmax(benchmark, output, startTime, endTime)
    
    row <- c(row, AUC)
    row <- c(row, Cmax)
    
  }
  # Create an empty data frame to store benchmark data results
  base <- data.frame(matrix(ncol = 2*length(outputs), nrow = 0))
  
  
  
  # Append to the data frame
  base <- rbind(base, row)
  names(base) <- colNames
  
  return(base)
}


Data <- function(dirPathList, outputs, startTime, endTime, colNames) {
  # Create an empty data frame to store results
  results <- data.frame(matrix(ncol = 4*length(outputs) + 1, nrow = 0))
  
  
  for (filePath in dirPathList) {
    
    # Read CSV file
    df <- read.csv(filePath)
    
    # Total BA and Total Conj. BA
    df <- totalBA(df)
    df <- totalConjBA(df)
    
    
    #Empty list to save the data
    row <- list()
    
    # Loop through outputs and calculate AUC and Cmax
    
    for (output in outputs) {
      AUC <- auc(df, output, startTime, endTime)
      Cmax <- cmax(df, output, startTime, endTime)
      row <- c(row, AUC)
      row <- c(row, Cmax)
      
    }
    
    file <- basename(filePath)
    file <- strsplit(file, '.csv')[[1]][1]
    row <- c(row, file)
    # Append to the results data frame
    results <- rbind(results, row)
  }
  
  
  colNames <- c(colNames, 'File')
  names(results) <- colNames
  
  return(results)
}


foldChangeDF <- function(results, base, outputs, startTime, endTime, colNames, ResultsPath) {
  # Create an empty data frame to store results
  ratios <- data.frame(matrix(ncol = 2*length(outputs), nrow = 0))
  
  
  for (line in 1:nrow(results)) {
    #Empty List
    row <- list()
    for (col in colnames(base)){
      res <- results[line, col]
      benchmarkRes  <- base[1, col]  
      ratio <- res/benchmarkRes
      
      row <- c(row, ratio)
      
    }
    
    # Append to the results data frame
    ratios <- rbind(ratios, row)
  }
  
  names(ratios) <- colNames
  
  newDF <- cbind(results, ratios)
  
  # Save the results to a CSV file
  write.xlsx(newDF, ResultsPath, rowNames = FALSE)
}

foldChange <- function(benchmarkPath, dirPathList, outputs, startTime, endTime, colNames, ResultsPath) {
  base <- benchmarkData(benchmarkPath, outputs, startTime, endTime, colNames)
  results <- Data(dirPathList, outputs, startTime, endTime, colNames)
  foldChangeDF(results, base, outputs, startTime, endTime, colNames, ResultsPath)
}

foldChange(benchmarkPath, dirPathList, outputs, startTime, endTime, colNames, ResultsPath)

##############################################################################################
# Duration over a certain fold change 

# Load required libraries

library(readxl)
library(openxlsx)


foldersPath <- c('../data/Simulation results/PBBA results/')
dirPathList <- list()
folders <- list.files(path = foldersPath)
for (folder in folders) {
  folderPath <- paste0(foldersPath, folder)
  dirPathList <- c(dirPathList, folderPath)
}


benchmarkPath <- '../data/Simulation results/PBBA_Conjugation_NoInhibition-HR.csv'
ResultsPath <- '..data/Simulation results/HT_PBBA_v5_duration_over_2fold_24h_InSilico.xlsx'

startTime <- 28800
endTime <- 30240
#endTime <- 72000

foldChange <- 2

# Define the list of output variables
outputs <- c(
  "Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",                 
  "Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",         
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",  
  "Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                    
  "Organism.Liver.CDCA.Tissue..Liver...µmol.l.",                                                   
  "Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.G.CDCA.Tissue..Liver...µmol.l.",                                                 
  "Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.T.CDCA.Tissue..Liver...µmol.l.",
  
  "Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tBA.Tissue..Liver...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tConjBA.Tissue..Liver...µmol.l."
)

colNames <- c(
  'PeripheralVenousBlood|Plasma|CDCA',
  'PeripheralVenousBlood|PlasmaUnbound|CDCA',
  'PeripheralVenousBlood|Plasma|GCDCA',
  'PeripheralVenousBlood|PlasmaUnbound|GCDCA',
  'PeripheralVenousBlood|Plasma|TCDCA',
  'PeripheralVenousBlood|PlasmaUnbound|TCDCA',
  'Liver|Intracellular|CDCA',
  'Liver|Intracellular|GCDCA',
  'Liver|Intracellular|TCDCA',
  'Liver|IntracellularUnbound|CDCA',
  'Liver|Tissue|CDCA', 
  'Liver|IntracellularUnbound|GCDCA',
  'Liver|Tissue|GCDCA',
  'Liver|IntracellularUnbound|TCDCA',
  'Liver|Tissue|TCDCA',
  'PeripheralVenousBlood|Plasma|tBA',
  'PeripheralVenousBlood|PlasmaUnbound|tBA',
  'Liver|Intracellular|tBA',
  'Liver|IntracellularUnbound|tBA',
  'Liver|Tissue|tBA',
  'PeripheralVenousBlood|Plasma|tConjBA',
  'PeripheralVenousBlood|PlasmaUnbound|tConjBA',
  'Liver|Intracellular|tConjBA',
  'Liver|IntracellularUnbound|tConjBA',
  'Liver|Tissue|tConjBA')

totalBA <- function(df) {
  df$`Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.` <- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]    
  
  df$`Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +    
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  df$`Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] + 
    df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  df$`Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  df$`Organism.Liver.tBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."] 
  
  return(df)
}

totalConjBA <- function(df) {
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] + 
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  
  df$`Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  
  df$`Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +  
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  
  df$`Organism.Liver.tConjBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                                
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."]  
  return(df)
}

aboveThreshold <- function(df, df_benchmark, foldChange, output, startTime, endTime) {
  minSum <- 0
  time <- 'Time..min.'
  startIndex <- which(df$Time..min. == startTime)
  endIndex <- which(df$Time..min. == endTime)
  
  for (i in startIndex:(endIndex-1)) {
    if ((df[i , output] > (foldChange * df_benchmark[i, output])) && (df[i + 1 , output] > (foldChange * df_benchmark[i + 1, output]))){
      min <- (df[i + 1, time] - df[i, time])
      minSum <- minSum + min
    }
  }
  return(minSum)
}

Data <- function(dirPathList, benchmarkPath, foldChange, outputs, startTime, endTime, colNames) {
  # Create an empty data frame to store results
  results <- data.frame(matrix(ncol = length(outputs) + 1, nrow = 0))
  
  # Read benchmark data
  df_benchmark <- read.csv(benchmarkPath)
  
  df_benchmark <- totalBA(df_benchmark)
  df_benchmark <- totalConjBA(df_benchmark)
  
  for (filePath in dirPathList) {
    
    # Read CSV file
    df <- read.csv(filePath)
    
    # Total BA and Total Conj. BA
    df <- totalBA(df)
    df <- totalConjBA(df)
    
    
    #Empty list to save the data
    row <- list()
    
    # Loop through outputs and calculate duration above threshold
    
    for (output in outputs) {
      duration <- aboveThreshold(df, df_benchmark, foldChange, output, startTime, endTime)
      row <- c(row, duration)
      
    }
    
    file <- basename(filePath) 
    file <- strsplit(file, '.csv')[[1]][1]
    row <- c(row, file)
    # Append to the results data frame
    results <- rbind(results, row)
  }
  
  
  colNames <- c(colNames, 'File')
  names(results) <- colNames
  
  return(results)
}

newDF <- Data(dirPathList, benchmarkPath, foldChange, outputs, startTime, endTime, colNames)
write.xlsx(newDF, ResultsPath, rowNames = FALSE)

##########################################################################################################
# Duration over maximum concentration of baseline

# Load required libraries

library(readxl)
library(openxlsx)


foldersPath <- c('../data/Simulation results/PBBA results/')
dirPathList <- list()
folders <- list.files(path = foldersPath)
for (folder in folders) {
  folderPath <- paste0(foldersPath, folder)
  dirPathList <- c(dirPathList, folderPath)
}


benchmarkPath <- '../data/Simulation results/PBBA_Conjugation_NoInhibition-HR.csv'
ResultsPath <- '../data/Simulation results/PBBA results/HT_PBBA_v5_duration_over_1_1Cmax_24h_InSilico.xlsx'

startTime <- 28800
endTime <- 30240
#endTime <- 72000

foldChange <- 1.1

# Define the list of output variables
outputs <- c(
  "Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",                 
  "Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",         
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l.",               
  "Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",       
  "Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",  
  "Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                    
  "Organism.Liver.CDCA.Tissue..Liver...µmol.l.",                                                   
  "Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.G.CDCA.Tissue..Liver...µmol.l.",                                                 
  "Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l.",                                  
  "Organism.Liver.T.CDCA.Tissue..Liver...µmol.l.",
  
  "Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tBA.Tissue..Liver...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.",
  "Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.",
  "Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.",
  "Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.",
  "Organism.Liver.tConjBA.Tissue..Liver...µmol.l."
)

colNames <- c(
  'PeripheralVenousBlood|Plasma|CDCA',
  'PeripheralVenousBlood|PlasmaUnbound|CDCA',
  'PeripheralVenousBlood|Plasma|GCDCA',
  'PeripheralVenousBlood|PlasmaUnbound|GCDCA',
  'PeripheralVenousBlood|Plasma|TCDCA',
  'PeripheralVenousBlood|PlasmaUnbound|TCDCA',
  'Liver|Intracellular|CDCA',
  'Liver|Intracellular|GCDCA',
  'Liver|Intracellular|TCDCA',
  'Liver|IntracellularUnbound|CDCA',
  'Liver|Tissue|CDCA', 
  'Liver|IntracellularUnbound|GCDCA',
  'Liver|Tissue|GCDCA',
  'Liver|IntracellularUnbound|TCDCA',
  'Liver|Tissue|TCDCA',
  'PeripheralVenousBlood|Plasma|tBA',
  'PeripheralVenousBlood|PlasmaUnbound|tBA',
  'Liver|Intracellular|tBA',
  'Liver|IntracellularUnbound|tBA',
  'Liver|Tissue|tBA',
  'PeripheralVenousBlood|Plasma|tConjBA',
  'PeripheralVenousBlood|PlasmaUnbound|tConjBA',
  'Liver|Intracellular|tConjBA',
  'Liver|IntracellularUnbound|tConjBA',
  'Liver|Tissue|tConjBA')

totalBA <- function(df) {
  df$`Organism.PeripheralVenousBlood.tBA.Plasma..Peripheral.Venous.Blood...µmol.l.` <- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] +
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]    
  
  df$`Organism.PeripheralVenousBlood.tBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +    
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  df$`Organism.Liver.Intracellular.tBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] + 
    df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  df$`Organism.Liver.tBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  df$`Organism.Liver.tBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                              
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."] 
  
  return(df)
}

totalConjBA <- function(df) {
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."] + 
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma..Peripheral.Venous.Blood...µmol.l."]
  
  df$`Organism.PeripheralVenousBlood.tConjBA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l.`<- df[,"Organism.PeripheralVenousBlood.G.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."] +     
    df[,"Organism.PeripheralVenousBlood.T.CDCA.Plasma.Unbound..Peripheral.Venous.Blood...µmol.l."]       
  
  
  df$`Organism.Liver.Intracellular.tConjBA.Concentration.in.container..Liver..Intracellular...µmol.l.`<- df[,"Organism.Liver.Intracellular.G.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."] +
    df[,"Organism.Liver.Intracellular.T.CDCA.Concentration.in.container..Liver..Intracellular...µmol.l."]
  
  
  df$`Organism.Liver.tConjBA.Intracellular.Unbound..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Intracellular.Unbound..Liver...µmol.l."] +  
    df[,"Organism.Liver.T.CDCA.Intracellular.Unbound..Liver...µmol.l."] 
  
  
  df$`Organism.Liver.tConjBA.Tissue..Liver...µmol.l.`<- df[,"Organism.Liver.G.CDCA.Tissue..Liver...µmol.l."] +                                                
    df[,"Organism.Liver.T.CDCA.Tissue..Liver...µmol.l."]  
  return(df)
}

aboveThreshold <- function(df, df_benchmark, foldChange, output, startTime, endTime) {
  minSum <- 0
  time <- 'Time..min.'
  startIndex <- which(df$Time..min. == startTime)
  endIndex <- which(df$Time..min. == endTime)
  
  benchmarkMax <- max(df_benchmark[[output]])
  
  for (i in startIndex:(endIndex-1)) {
    if ((df[i , output] > (foldChange * benchmarkMax)) && (df[i + 1 , output] > (foldChange * benchmarkMax))){
      min <- (df[i + 1, time] - df[i, time])
      minSum <- minSum + min
    }
  }
  return(minSum)
}

Data <- function(dirPathList, benchmarkPath, foldChange, outputs, startTime, endTime, colNames) {
  # Create an empty data frame to store results
  results <- data.frame(matrix(ncol = length(outputs) + 1, nrow = 0))
  
  # Read benchmark data
  df_benchmark <- read.csv(benchmarkPath)
  
  df_benchmark <- totalBA(df_benchmark)
  df_benchmark <- totalConjBA(df_benchmark)
  
  for (filePath in dirPathList) {
    
    # Read CSV file
    df <- read.csv(filePath)
    
    # Total BA and Total Conj. BA
    df <- totalBA(df)
    df <- totalConjBA(df)
    
    
    #Empty list to save the data
    row <- list()
    
    # Loop through outputs and calculate duration above threshold
    
    for (output in outputs) {
      duration <- aboveThreshold(df, df_benchmark, foldChange, output, startTime, endTime)
      row <- c(row, duration)
      
    }
    
    file <- basename(filePath) 
    file <- strsplit(file, '.csv')[[1]][1]
    row <- c(row, file)
    # Append to the results data frame
    results <- rbind(results, row)
  }
  
  
  colNames <- c(colNames, 'File')
  names(results) <- colNames
  
  return(results)
}

newDF <- Data(dirPathList, benchmarkPath, foldChange, outputs, startTime, endTime, colNames)
write.xlsx(newDF, ResultsPath, rowNames = FALSE)