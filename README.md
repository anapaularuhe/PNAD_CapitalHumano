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
  * Rotina: D_Rotina_estimacao_IQT
  * Inputs:
   - C_PNADC_POamostra.dta

  * Outputs:
   - DA1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Efetivo - Estratégia A
   - DA2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Efetivo - Estratégia A
   - DA2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia A

   - DC1_Estimacoes.ster                          | Arquivo que armazena as regressões - Salário Efetivo - Estratégia C
   - DC2_Coeficientes_unico.dta                   | Base com os coeficientes da regressão única - Salário Efetivo - Estratégia C
   - DC2_Coeficientes_genero.dta                  | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia C

   - DC10_Estimacoes.ster                         | Arquivo que armazena as regressões - Salário Efetivo - Estratégia C - logW=0 se W=0 
   - DC20_Coeficientes_genero.dta                 | Base com os coeficientes das regressões separadas por gênero - Salário Efetivo - Estratégia C - logW=0 se W=0 

   - DC1_Estimacoes_peso.ster                     | Arquivo que armazena as regressões com peso - Salário Efetivo - Estratégia C 
   - DC2_Coeficientes_genero_peso.dta             | Base com os coeficientes das regressões com peso separadas por gênero - Salário Efetivo - Estratégia C

   - DC10_Estimacoes_peso.ster                    | Arquivo que armazena as regressões com peso- Salário Efetivo - Estratégia C - logW=0 se W=0 
   - DC20_Coeficientes_genero_peso.dta            | Base com os coeficientes das regressões com peso separadas por gênero - Salário Efetivo - Estratégia C - logW=0 se W=0 

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
 

> ---------------------------------------------------------

> G. ESTIMAÇÕES COM CONTROLES
  * Rotina: D_Rotina_estimacao_IQT
  * Inputs:
   - C_PNADC_POamostra.dta

  * Outputs: 
   - G0_BaseEstimacao.dta                         | Base final com salários preditos e pesos ponderados por horas - Regressões com controles
   - G_IQT_Controles.dta                          | Base com os IQT calculados com controles, habitual e efetivo, com e sem peso, estratégias C e C_alt
   
   - Regressões:
     . G1i_E_Estimacao.ster                       | Regressões Efetivo - Baseline (1) - Sem controles (i)
     . G1ii_E_Estimacao.ster                      | Regressões Efetivo - Baseline (1) - Cor (ii)
     . G1iii_E_Estimacao.ster                     | Regressões Efetivo - Baseline (1) - Setor público (iii)
     . G1vi_E_Estimacao.ster                      | Regressões Efetivo - Baseline (1) - Informal (iv)      

     . G2i_E_Estimacao.ster                       | Regressões Efetivo - log = 0 (2) - Sem controles (i)
     . G2ii_E_Estimacao.ster                      | Regressões Efetivo - log = 0 (2) - Cor (ii)
     . G2iii_E_Estimacao.ster                     | Regressões Efetivo - log = 0 (2) - Setor público (iii)
     . G2vi_E_Estimacao.ster                      | Regressões Efetivo - log = 0 (2) - Informal (iv)

     . G3i_E_Estimacao.ster                       | Regressões Efetivo - Reg com pesos (3) - Sem controles (i)
     . G3ii_E_Estimacao.ster                      | Regressões Efetivo - Reg com pesos (3) - Cor (ii)
     . G3iii_E_Estimacao.ster                     | Regressões Efetivo - Reg com pesos (3) - Setor público (iii)
     . G3vi_E_Estimacao.ster                      | Regressões Efetivo - Reg com pesos (3) - Informal (iv)

     . G4i_E_Estimacao.ster                       | Regressões Efetivo - Reg com pesos + log=0 (4) - Sem controles (i)
     . G4ii_E_Estimacao.ster                      | Regressões Efetivo - Reg com pesos + log=0 (4) - Cor (ii)
     . G4iii_E_Estimacao.ster                     | Regressões Efetivo - Reg com pesos + log=0 (4) - Setor público (iii)
     . G4vi_E_Estimacao.ster                      | Regressões Efetivo - Reg com pesos + log=0 (4) - Informal (iv)     

 
     . G1i_H_Estimacao.ster                       | Regressões Habitual - Baseline (1) - Sem controles (i)
     . G1ii_H_Estimacao.ster                      | Regressões Habitual - Baseline (1) - Cor (ii)
     . G1iii_H_Estimacao.ster                     | Regressões Habitual - Baseline (1) - Setor público (iii)
     . G1vi_H_Estimacao.ster                      | Regressões Habitual - Baseline (1) - Informal (iv)      

     . G2i_H_Estimacao.ster                       | Regressões Habitual - log = 0 (2) - Sem controles (i)
     . G2ii_H_Estimacao.ster                      | Regressões Habitual - log = 0 (2) - Cor (ii)
     . G2iii_H_Estimacao.ster                     | Regressões Habitual - log = 0 (2) - Setor público (iii)
     . G2vi_H_Estimacao.ster                      | Regressões Habitual - log = 0 (2) - Informal (iv)

     . G3i_H_Estimacao.ster                       | Regressões Habitual - Reg com pesos (3) - Sem controles (i)
     . G3ii_H_Estimacao.ster                      | Regressões Habitual - Reg com pesos (3) - Cor (ii)
     . G3iii_H_Estimacao.ster                     | Regressões Habitual - Reg com pesos (3) - Setor público (iii)
     . G3vi_H_Estimacao.ster                      | Regressões Habitual - Reg com pesos (3) - Informal (iv)

     . G4i_H_Estimacao.ster                       | Regressões Habitual - Reg com pesos + log=0 (4) - Sem controles (i)
     . G4ii_H_Estimacao.ster                      | Regressões Habitual - Reg com pesos + log=0 (4) - Cor (ii)
     . G4iii_H_Estimacao.ster                     | Regressões Habitual - Reg com pesos + log=0 (4) - Setor público (iii)
     . G4vi_H_Estimacao.ster                      | Regressões Habitual - Reg com pesos + log=0 (4) - Informal (iv)     


   - Tabelas: Para cada t em {1, ..., Tmax} - arquivos Word, Latex e .txt
     . G1_Tabela_Efetivo_t                        | Tabelas Efetivo - Baseline (1) - Trimestre t
     . G2_Tabela_Efetivo_t                        | Tabelas Efetivo - log = 0 (2) - Trimestre t
     . G3_Tabela_Efetivo_t                        | Tabelas Efetivo - Reg com pesos (3) - Trimestre t
     . G4_Tabela_Efetivo_t                        | Tabelas Efetivo - Reg com pesos + log=0 (4) - Trimestre t                 

     . G1_Tabela_Habitual_t                       | Tabelas Habitual - Baseline (1) - Trimestre t
     . G2_Tabela_Habitual_t                       | Tabelas Habitual - log = 0 (2) - Trimestre t
     . G3_Tabela_Habitual_t                       | Tabelas Habitual - Reg com pesos (3) - Trimestre t
     . G4_Tabela_Habitual_t                       | Tabelas Habitual - Reg com pesos + log=0 (4) - Trimestre t                 
   
