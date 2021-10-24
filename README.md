# PNAD_CapitalHumano
Arquivos referentes ao uso da PNAD Contínua no projeto sobre Capital Humano e Produtividade


> Projeto Capital Humano e Produtividade
> FGV IBRE - Núcleo de Mercado de Trabalho e Produtividade
> Outubro de 2021
> ---------------------------------------------------------

> A. IMPORTANDO DADOS E CONTRUINDO BASE COM DEFLATORES
  * Rotina: A_Limpeza_amostra.do
  * Inputs:
   - A0_PNADC2012_2021_bruta.dta                 | Base bruta da PNAD, em .dta
   - deflator_PNADC_2021_trimestral_040506.xls   | Deflatores brutos da PNAD, em .xls, com aba editada
  * Outputs:
   - A1_deflator_2t2021.dta                      | Deflatores da PNAD em .dta
   - A2_PNADC2012_2021_completa_deflatores.dta   | Base completa com deflatores 

  Obs: arquivos acima estão na pasta compactada A_Bases

> ---------------------------------------------------------

> B. LIMPANDO BASE
  * Mesma rotina
  * Inputs:
   - A2_PNADC2012_2021_completa_deflatores.dta 
  * Outputs:
   - B_PNADC2012_2021_limpa.dta                   | Base restrita às variáveis de interesse, ainda sem seleção da amostra
  

> ---------------------------------------------------------

> C. SELECIONANDO AMOSTRA: POPULAÇÃO OCUPADA
  * Mesma rotina
  * Inputs:
   - B_PNADC2012_2021_limpa.dta
  * Outputs:
   - C_amostra_PO_BR.xls                          | Tabelas em .xls com características da amostra
   - C_PNADC_POamostra.dta                        | Base limpa, restrita à amostra de interesse
   - A_Limpeza_amostra.log                        | Log da rotina


> ---------------------------------------------------------

> D. ESTIMAÇÕES E IQT - SALÁRIO EFETIVO
  * D_Rotina_estimacao_IQT
  * Inputs:
   - C_PNADC_POamostra.dta
  * Outputs:
   - DA1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Efetivo - Estratégia A
   - DA2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Efetivo - Estratégia A
   - DA2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia A

   - DC1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Efetivo - Estratégia C
   - DC2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Efetivo - Estratégia C
   - DC2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia C

   - DD1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Efetivo - Estratégia D
   - DD2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Efetivo - Estratégia D
   - DD2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia D
      
   - D0_BaseEstimacao.dta                         | Base final com salários preditos e pesos ponderados por horas - Salário Efetivo  
   - D_IQT_Efetivo.dta                            | Base com os IQTs calculados para as quatro estratégias - Salário Efetivo

   (obs: as estimações A e B são equivalentes para o rendimento efetivo, de modo que estimamos as regressões apenas uma vez, para o caso A).


> ---------------------------------------------------------

> E. ESTIMAÇÕES E IQT - SALÁRIO HABITUAL
  * Mesma rotina
  * Inputs:
   - C_PNADC_POamostra.dta
  * Outputs:
   - EA1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Habitual - Estratégia A
   - EA2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Habitual - Estratégia A
   - EA2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Habitual - Estratégia A

   - EB1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Habitual - Estratégia B
   - EB2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Habitual - Estratégia B
   - EB2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Habitual - Estratégia B
      
   - E0_BaseEstimacao.dta                         | Base final com salários preditos e pesos ponderados por horas - Salário Habitual  
   - E_IQT_Habitual.dta                           | Base com os IQTs calculados para as quatro estratégias - Salário Habitual

   (obs: as estimações A, C e D são equivalentes para o rendimento habitual, de modo que estimamos as regressões apenas uma vez, para o caso A).

   - F_IQT.dta                                    | Base com os IQT: habitual e efetivo, todas estratégias      


> ---------------------------------------------------------

> F. GRÁFICOS
  * Rotina: F_Graficos (cópia da última parte da rotina anterior)
  * Input:
   - F_IQT
  * Outputs: gráficos em .png               
  
