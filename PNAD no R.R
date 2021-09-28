# PNADC NO R ------------------------------------
# FGV IBRE - Instituto Brasileiro de Economia
# Núcleo de Mercado de Trabalho
# Ana Paula Nothen Ruhe

# > PREPARAÇÃO ----------------------------------
setwd("C:/Users/ana.ruhe/Documents/R")           # Definindo o diretório 

# Pacotes
  library(PNADcIBGE)                             # Necessário para importar os dados da PNAD  
  library(survey)                                # Necessário para lidar com pesquisas amostrais
  library(tidyverse)                             # Pacote de manipulação de dados

# Importando dados:
  pnad2021.2 = get_pnadc(2021, quarter = 2)      # Microdados 2º trimestre de 2021; formato "survey"
  pnad2021.2$variables                           # Data frame
