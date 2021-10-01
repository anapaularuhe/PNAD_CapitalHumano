# PNADC NO R ------------------------------------
# FGV IBRE - Instituto Brasileiro de Economia
# Núcleo de Mercado de Trabalho
# Ana Paula Nothen Ruhe

# Documentação CRAN: https://cran.r-project.org/web/packages/PNADcIBGE/PNADcIBGE.pdf
# Tutorial: https://rpubs.com/gabriel-assuncao-ibge/pnadc

# > PREPARAÇÃO ----------------------------------
setwd("C:/Users/ana.ruhe/Documents/R")           # Definindo o diretório 
rm(list = ls())                                  # Equivalente do R a clear all (limpar variáveis amarzenadas na memória)


# Pacotes
  library(PNADcIBGE)                             # Necessário para importar os dados da PNAD  
  library(survey)                                # Necessário para lidar com pesquisas amostrais
  library(dplyr)                                 # Pacote de manipulação de dados
  library(haven)                                 # Pacote que permite lidar com formato .dta
 


# Importando dados:
  pnad2021.2 = get_pnadc(2021, quarter = 2)      # Microdados 2º trimestre de 2021; formato "survey"
  pnad2021.2.df = pnad2021.2$variables           # Data frame

  
# Deflatores associados aos microdados:  
  deflator2021.2 = data.frame("Ano" = pnad2021.2$variables$Ano, "Trimestre" = pnad2021.2$variables$Trimestre, "UF" = pnad2021.2$variables$UF, "Efetivo" = pnad2021.2$variables$Efetivo, "Habitual" = pnad2021.2$variables$Habitual)
  
# Salvando em .dta:  
  write_dta(deflator2021.2, "deflator2021.2.dta")
  