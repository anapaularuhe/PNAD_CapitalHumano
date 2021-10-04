# PNADC NO R ------------------------------------
# FGV IBRE - Instituto Brasileiro de Economia
# Núcleo de Mercado de Trabalho
# Ana Paula Nothen Ruhe

# Documentação CRAN: https://cran.r-project.org/web/packages/PNADcIBGE/PNADcIBGE.pdf
# Tutorial: https://rpubs.com/gabriel-assuncao-ibge/pnadc

# > PREPARAÇÃO ----------------------------------
setwd("C:/Users/ana.ruhe/Documents/Capital_Humano") # Definindo o diretório 
rm(list = ls())                                     # Equivalente do R a clear all (limpar variáveis amarzenadas na memória)


# Pacotes
library(PNADcIBGE)       # Necessário para importar os dados da PNAD  
library(survey)          # Necessário para lidar com pesquisas amostrais
library(dplyr)           # Pacote de manipulação de dados
library(haven)           # Pacote que permite lidar com formato .dta


# > SALVANDO DEFLATORES -----------------------------------
# Criamos data frame vazio para começar o loop:  
  deflator = data.frame("Ano" = 0, "Trimestre" = 0, "UF" = 0, "Efetivo" = 0, "Habitual" = 0)

# Loop para os anos 2012-2020:
  # 1. Importamos a PNAD de cada trimestre com a função get_pnad
  # 2. Salvamos o deflator na variável temporária def
  # 3. Fazemos o "append" de def com o dataframe que já tem os períodos anteriores
  # 4. Passamos para o período seguinte  

  for (t in 2012:2020){
    for (i in 1:4){
      pnad = get_pnadc(year = t, quarter = i)
      def = data.frame("Ano" = pnad$variables$Ano, "Trimestre" = pnad$variables$Trimestre, "UF" = pnad$variables$UF, "Efetivo" = pnad$variables$Efetivo, "Habitual" = pnad$variables$Habitual)
      
      deflator = rbind(deflator,def)
    }
  }

# Removendo variáveis temporárias:
  rm(pnad,def,i,t)
  
# Removendo primeira linha de zeros:
  deflator = dplyr::filter(deflator, Ano != 0)
  
  
# Para o ano de 2021:
  pnad2021.1 = get_pnadc(2021, quarter = 1)      # Microdados 1º trimestre de 2021; formato "survey"
  pnad2021.2 = get_pnadc(2021, quarter = 2)      # Microdados 2º trimestre de 2021; formato "survey"

  deflator2021.1 = data.frame("Ano" = pnad2021.1$variables$Ano, "Trimestre" = pnad2021.1$variables$Trimestre, "UF" = pnad2021.1$variables$UF, "Efetivo" = pnad2021.1$variables$Efetivo, "Habitual" = pnad2021.1$variables$Habitual)
  deflator2021.2 = data.frame("Ano" = pnad2021.2$variables$Ano, "Trimestre" = pnad2021.2$variables$Trimestre, "UF" = pnad2021.2$variables$UF, "Efetivo" = pnad2021.2$variables$Efetivo, "Habitual" = pnad2021.2$variables$Habitual)
 
   
# Append:  
  deflator = rbind(deflator, deflator2021.1)
  deflator = rbind(deflator, deflator2021.2)
  
  
# Removendo variáveis temporárias:
  rm(pnad2021.1,pnad2021.2,deflator2021.1,deflator2021.2)  


# Salvando em .dta
  write_dta(deflator, "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados/Deflatores.dta")
