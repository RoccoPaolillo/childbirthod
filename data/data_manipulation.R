library(dplyr)
library(readxl)

setwd("C:/Users/rocpa/OneDrive/Documenti/GitHub/childbirthod/data/")

ricoveriparti2023 <- read.csv("ricoveri_parti_2023.csv",sep=",")

# consultori
cons2019 <- read.csv("elenco_consultori_2019.csv",sep=";")
cons2019 <- cons2019 %>% mutate(Comune = trimws(Comune))  %>%
  mutate(Codice.struttura = trimws(Codice.struttura))
table(cons2019$Codice.struttura)[table(cons2019$Codice.struttura) > 1]

cons2019[cons2019$Codice.struttura == "10012D" & cons2019$Comune == "CAMAIORE", ]$Codice.struttura <- "10012DCA"
cons2019[cons2019$Codice.struttura == "02002D" & cons2019$Comune == "LAMPORECCHIO", ]$Codice.struttura <- "02002DLA"
cons2019[cons2019$Codice.struttura == "21012D" & cons2019$Comune == "SCANDICCI", ]$Codice.struttura <- "21012DSC"
cons2019[cons2019$Codice.struttura == "22212D" & cons2019$Comune == "CASTELFRANCO DI SOTTO", ]$Codice.struttura <- "22212DCS"
cons2019[cons2019$Codice.struttura == "31012D" & cons2019$Comune == "REGGELLO", ]$Codice.struttura <- "31012DRE"

cons2019_used <- cons2019 %>% select(Codice.Comune,Codice.struttura)

# write.csv(cons2019_used,"elenco_consultori_2019_used.csv",row.names = F)

# filtered consultori

cons2019used188 <- read.csv("elenco_consultori_2019_used.csv",sep=",")
cons2019_48 <- read_excel("elenco_consultori_2019_XLS.xlsx") %>% filter(main == "X")

cons2019_48[cons2019_48$`Codice struttura` == "10012D" & cons2019_48$Comune == "CAMAIORE", ]$`Codice struttura` <- "10012DCA"
cons2019_48[cons2019_48$`Codice struttura` == "02002D" & cons2019_48$Comune == "LAMPORECCHIO", ]$`Codice struttura` <- "02002DLA"
cons2019_48[cons2019_48$`Codice struttura` == "21012D" & cons2019_48$Comune == "SCANDICCI", ]$`Codice struttura`<- "21012DSC"
cons2019_48[cons2019_48$`Codice struttura` == "22212D" & cons2019_48$Comune == "CASTELFRANCO DI SOTTO", ]$`Codice struttura` <- "22212DCS"
cons2019_48[cons2019_48$`Codice struttura` == "31012D" & cons2019_48$Comune == "REGGELLO", ]$`Codice struttura` <- "31012DRE"

cons2019filtered <- cons2019used188 %>% filter(Codice.struttura %in% cons2019_48$`Codice struttura`)

write.csv(cons2019filtered,"elenco_consultori_2019FILTERED_used.csv",row.names = F)

# 
osp <- read_excel("accessi_parto_ospedali.xlsx")
osp <- osp[,-6]
# write.csv(osp,"accessi_parto_ospedali_used.csv",row.names = F)

osp <- osp %>% group_by(presidio) %>% mutate(totparti = sum(parti))

# matrice distanze

distcounsel <- read.csv("matrice_distanze_consultori.csv",sep="," , check.names = FALSE) 
names(distcounsel)[1] <- "womencom"
# to test: first element is municipality woman, second is municipality counselcenter
distcounsel[distcounsel$womencom == "47005","45010"]

disthospital <- read.csv("matrice_distanze_ospedali.csv",sep="," , check.names = FALSE) 
names(disthospital)[1] <- "womencom"
# to test: first element is municipality woman, second is municipality hospital
disthospital[disthospital$womencom == "51041","49014"]

# test that distcounsel already contains disthospital

unique(levels(as.factor(names(disthospital)  %in% names(distcounsel))))
unique(levels(as.factor(names(distcounsel)  %in% names(disthospital))))

cols_to_exclude <- c("womencom")

numeric_data <- distcounsel[ , !(names(distcounsel) %in% cols_to_exclude)]

global_min <- min(as.matrix(numeric_data), na.rm = TRUE)
global_max <- max(as.matrix(numeric_data), na.rm = TRUE)

normalize_global <- function(x) {
  if (is.numeric(x)) (x - global_min) / (global_max - global_min) else x
}

df_normalized <- distcounsel
df_normalized[ , !(names(distcounsel) %in% cols_to_exclude)] <- lapply(
  distcounsel[ , !(names(distcounsel) %in% cols_to_exclude)],
  normalize_global
)

write.csv(df_normalized, file = "normalized_distance.csv",row.names = F)
df_normalized <- read.csv("normalized_distance.csv",sep =",", check.names = FALSE)


# editing figures

library(magick)
setwd("C:/Users/rocpa/OneDrive/Documenti/GitHub/childbirthod/")

img <- image_read("landscape.jpeg")

# Write it as an EPS file
image_write(img, path = "landscape.eps", format = "eps")


