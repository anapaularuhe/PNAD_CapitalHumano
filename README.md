# PNAD_CapitalHumano
Arquivos referentes ao uso da PNAD Contínua no projeto sobre Capital Humano e Produtividade


> Projeto Capital Humano e Produtividade
> FGV IBRE - Núcleo de Mercado de Trabalho e Produtividade
> Estimação IQT
> 2021
> ---------------------------------------------------------


> ROTINA: IQT.do 
  - LogIQT.log

> A. IMPORTANDO DADOS E CONSTRUINDO BASE COMPLETA COM DEFLATORES
  * Inputs:
   - A0_PNADC2012_2021_bruta.dta                 | Base bruta da PNAD, em .dta
   - deflator_PNADC_2021_trimestral_040506.xls   | Deflatores brutos da PNAD, em .xls, com aba editada

  * Outputs:
   - A1_deflator_2t2021.dta                      | Deflatores da PNAD em .dta
   - A2_PNADC2012_2021_completa_deflatores.dta   | Base completa com deflatores 

  Obs: arquivos acima estão na pasta compactada A_Bases

> ---------------------------------------------------------

> B. SELEÇÃO DE VARIÁVEIS E ORGANIZAÇÃO DA BASE
  * Inputs:
   - A2_PNADC2012_2021_completa_deflatores.dta 

  * Outputs:
   - B_PNADC2012_2021_limpa.dta                   | Base restrita às variáveis de interesse, ainda sem seleção da amostra, com labels e renomeações.
  

> ---------------------------------------------------------

> C. RESTRIÇÃO DA AMOSTRA: POPULAÇÃO OCUPADA
  * Inputs:
   - B_PNADC2012_2021_limpa.dta

  * Outputs:
   - C_Caracteristicas_PO.xls                     | Tabelas em .xls com características da amostra
   - C_PNADC_POamostra.dta                        | Base limpa, restrita à amostra de interesse


> ---------------------------------------------------------

> D. ESTIMAÇÃO IQT
  * Inputs:
   - C_PNADC_POamostra.dta

  * Outputs:
   - D_BaseEstimacao.dta                          | Base final com salários preditos, pesos ponderados por horas e componentes do IQT 
   - D_IQT.dta                                    | Base com os IQTs calculados
   - D_IQT.xlsx                                   | Arquivo excel com os IQTs calculados
   
   - D_Regressões_Efetivo_i.ster                  | Arquivo que armazena as regressões - Salário Efetivo - Sem controles
   - D_Regressões_Efetivo_ii.ster                 | Arquivo que armazena as regressões - Salário Efetivo - Cor
   - D_Regressões_Efetivo_iii.ster                | Arquivo que armazena as regressões - Salário Efetivo - Setor Público
   - D_Regressões_Efetivo_iv.ster                 | Arquivo que armazena as regressões - Salário Efetivo - Informal

   - D_Regressões_Habitual_i.ster                 | Arquivo que armazena as regressões - Salário Habitual - Sem controles
   - D_Regressões_Habitual_ii.ster                | Arquivo que armazena as regressões - Salário Habitual - Cor
   - D_Regressões_Habitual_iii.ster               | Arquivo que armazena as regressões - Salário Habitual - Setor Público
   - D_Regressões_Habitual_iv.ster                | Arquivo que armazena as regressões - Salário Habitual - Informal


> ---------------------------------------------------------

> E. RETORNOS EDUCAÇÃO: TABELAS E BASE DTA
  * Inputs:
   - D_BaseEstimacao.dta

  * Outputs:
  Para cada período/trimestre t =  1, ..., Tmax
   - E_Tabelas/Efetivo_t.doc                      | Tabela com os coeficientes da regressão em Word - Salário Efetivo
   - E_Tabelas/Efetivo_t.tex                      | Tabela com os coeficientes da regressão em Latex - Salário Efetivo
   - E_Tabelas/Habitual_t.doc                     | Tabela com os coeficientes da regressão em Word - Salário Habitual
   - E_Tabelas/Habitual_t.tex                     | Tabela com os coeficientes da regressão em Latex - Salário Habitual
  

   - E_Coeficientes_Efetivo_i                     | Base .dta dos coeficientes estimados - Salário Efetivo - Sem controles 
   - E_Coeficientes_Efetivo_ii                    | Base .dta dos coeficientes estimados - Salário Efetivo - Cor
   - E_Coeficientes_Efetivo_iii                   | Base .dta dos coeficientes estimados - Salário Efetivo - Setor público
   - E_Coeficientes_Efetivo_iv                    | Base .dta dos coeficientes estimados - Salário Efetivo - Informal

   - E_Coeficientes_Efetivo                       | Base .dta consolidada dos coeficientes estimados - Salário Efetivo 


   - E_Coeficientes_Habitual_i                    | Base .dta dos coeficientes estimados - Salário Habitual - Sem controles 
   - E_Coeficientes_Habitual_ii                   | Base .dta dos coeficientes estimados - Salário Habitual - Cor
   - E_Coeficientes_Habitual_iii                  | Base .dta dos coeficientes estimados - Salário Habitual - Setor público
   - E_Coeficientes_Habitual_iv                   | Base .dta dos coeficientes estimados - Salário Habitual - Informal

   - E_Coeficientes_Habitual                      | Base .dta consolidada dos coeficientes estimados - Salário Habitual 



> ---------------------------------------------------------

> F. GRÁFICOS
  * Inputs:
   - D_BaseEstimacao.dta
  
  * Outputs:
   - Gráficos em .png
