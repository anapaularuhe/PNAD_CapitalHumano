> Projeto Capital Humano e Produtividade
> FGV IBRE - Núcleo de Mercado de Trabalho e Produtividade
> Estimação IQT
> 2021
> ---------------------------------------------------------


> ROTINA: IQT.do 
  - LogIQT.log

> A. IMPORTAÇÃO DADOS, DEFLATORES E SELEÇÃO DE VARIÁVEIS
  * Inputs:
   - Bases trimestrais brutas em .dta (importadas pelo Paulo)
   - deflator_PNADC_2021_trimestral_070809.xls   | Deflatores brutos da PNAD, em .xls

  * Outputs:
   - A_Deflator.dta                              | Deflatores da PNAD em .dta
   - A_PNADC_20122021.dta                        | Base para todo o período, com deflatores, apenas para as variáveis de interesse, com labels e renomeações. 


> ---------------------------------------------------------

> B. RESTRIÇÃO DA AMOSTRA: POPULAÇÃO OCUPADA
  * Inputs:
   - A_PNADC_20122021.dta                        

  * Outputs:
   - B_Caracteristicas_PO.xls                     | Tabelas em .xls com características da amostra
   - B_PNADC_POamostra.dta                        | Base limpa, restrita à amostra de interesse


> ---------------------------------------------------------

> C. ESTIMAÇÃO IQT
  * Inputs:
   - B_PNADC_POamostra.dta

  * Outputs:
   - C_BaseEstimacao.dta                          | Base final com salários preditos, pesos ponderados por horas e componentes do IQT 
   - C_IQT.dta                                    | Base com os IQTs calculados
   - C_IQT.xlsx                                   | Arquivo excel com os IQTs calculados

   - C_Horas.dta                                  | Base com a série histórica da quantidade de horas trabalhadas por grupo de educação
   - C_Horas.xlsx                                 | Arquivo excel com a série histórica da quantidade de horas trabalhadas por grupo de educação
   - C_Horas - Trabalhada.xlsx                    | Arquivo excel com as tabelas e gráficos
   
   - C_Regressões/Efetivo_i.ster                  | Arquivo que armazena as regressões - Salário Efetivo - Sem controles
   - C_Regressões/Efetivo_ii.ster                 | Arquivo que armazena as regressões - Salário Efetivo - Cor
   - C_Regressões/Efetivo_iii.ster                | Arquivo que armazena as regressões - Salário Efetivo - Setor Público
   - C_Regressões/Efetivo_iv.ster                 | Arquivo que armazena as regressões - Salário Efetivo - Informal

   - C_Regressões/Habitual_i.ster                 | Arquivo que armazena as regressões - Salário Habitual - Sem controles
   - C_Regressões/Habitual_ii.ster                | Arquivo que armazena as regressões - Salário Habitual - Cor
   - C_Regressões/Habitual_iii.ster               | Arquivo que armazena as regressões - Salário Habitual - Setor Público
   - C_Regressões/Habitual_iv.ster                | Arquivo que armazena as regressões - Salário Habitual - Informal


> ---------------------------------------------------------

> D. RETORNOS EDUCAÇÃO: TABELAS E BASE DTA
  * Inputs:
   - C_BaseEstimacao.dta

  * Outputs:
  Para cada período/trimestre t =  1, ..., Tmax
   - D_Tabelas/Efetivo_t.doc                      | Tabela com os coeficientes da regressão em Word - Salário Efetivo
   - D_Tabelas/Efetivo_t.tex                      | Tabela com os coeficientes da regressão em Latex - Salário Efetivo
   - D_Tabelas/Habitual_t.doc                     | Tabela com os coeficientes da regressão em Word - Salário Habitual
   - D_Tabelas/Habitual_t.tex                     | Tabela com os coeficientes da regressão em Latex - Salário Habitual
  

   - D_Coeficientes/Efetivo_i                     | Base .dta dos coeficientes estimados - Salário Efetivo - Sem controles 
   - D_Coeficientes/Efetivo_ii                    | Base .dta dos coeficientes estimados - Salário Efetivo - Cor
   - D_Coeficientes/Efetivo_iii                   | Base .dta dos coeficientes estimados - Salário Efetivo - Setor público
   - D_Coeficientes/Efetivo_iv                    | Base .dta dos coeficientes estimados - Salário Efetivo - Informal

   - D_Coeficientes_Efetivo                       | Base .dta consolidada dos coeficientes estimados - Salário Efetivo 


   - D_Coeficientes/Habitual_i                    | Base .dta dos coeficientes estimados - Salário Habitual - Sem controles 
   - D_Coeficientes/Habitual_ii                   | Base .dta dos coeficientes estimados - Salário Habitual - Cor
   - D_Coeficientes/Habitual_iii                  | Base .dta dos coeficientes estimados - Salário Habitual - Setor público
   - D_Coeficientes/Habitual_iv                   | Base .dta dos coeficientes estimados - Salário Habitual - Informal

   - D_Coeficientes_Habitual                      | Base .dta consolidada dos coeficientes estimados - Salário Habitual 


   - D_CoeficientesEducação.xlsx                  | Planilha excel com os coeficientes estimados do retorno à educação, para todos os controles e os dois tipos de rendimentos


> ---------------------------------------------------------

> E. GRÁFICOS
  * Inputs:
   - C_IQT.dta

  * Outputs:
   - Gráficos em .png


> ---------------------------------------------------------
> ---------------------------------------------------------

> ROTINA: IQT Preço.do 

  * Inputs:
   - C_BaseEstimacao.dta                          

  * Outputs:
   - BaseIQTPreço.dta                           | Base final com salários preditos, pesos ponderados por horas e componentes do IQT (Preço e Quantidade)
   - IQTPreço.dta                               | Base com os IQTs (Preço e Quantidade) calculados
   - IQTPreço.xlsx                              | Arquivo excel com os IQTs (Preço e Quantidade) calculados
