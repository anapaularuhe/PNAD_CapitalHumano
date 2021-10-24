> Projeto Capital Humano e Produtividade
> FGV IBRE - N�cleo de Mercado de Trabalho e Produtividade
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

  Obs: arquivos acima est�o na pasta compactada A_Bases

> ---------------------------------------------------------

> B. LIMPANDO BASE
  * Mesma rotina
  * Inputs:
   - A2_PNADC2012_2021_completa_deflatores.dta 
  * Outputs:
   - B_PNADC2012_2021_limpa.dta                   | Base restrita �s vari�veis de interesse, ainda sem sele��o da amostra
  

> ---------------------------------------------------------

> C. SELECIONANDO AMOSTRA: POPULA��O OCUPADA
  * Mesma rotina
  * Inputs:
   - B_PNADC2012_2021_limpa.dta
  * Outputs:
   - C_amostra_PO_BR.xls                          | Tabelas em .xls com caracter�sticas da amostra
   - C_PNADC_POamostra.dta                        | Base limpa, restrita � amostra de interesse
   - A_Limpeza_amostra.log                        | Log da rotina


> ---------------------------------------------------------

> D. ESTIMA��ES E IQT - SAL�RIO EFETIVO
  * D_Rotina_estimacao_IQT
  * Inputs:
   - C_PNADC_POamostra.dta
  * Outputs:
   - DA1_Estimacoes.ster                          | Arquivo que armazena as regress�es - Sal�rio Efetivo - Estrat�gia A
   - DA2_Coeficientes_unico.dta                   | Base com os coeficientes da regress�o �nica - Sal�rio Efetivo - Estrat�gia A
   - DA2_Coeficientes_genero.dta                  | Base com os coeficientes das regress�es separadas por g�nero - Sal�rio Efetivo - Estrat�gia A

   - DC1_Estimacoes.ster                          | Arquivo que armazena as regress�es - Sal�rio Efetivo - Estrat�gia C
   - DC2_Coeficientes_unico.dta                   | Base com os coeficientes da regress�o �nica - Sal�rio Efetivo - Estrat�gia C
   - DC2_Coeficientes_genero.dta                  | Base com os coeficientes das regress�es separadas por g�nero - Sal�rio Efetivo - Estrat�gia C

   - DD1_Estimacoes.ster                          | Arquivo que armazena as regress�es - Sal�rio Efetivo - Estrat�gia D
   - DD2_Coeficientes_unico.dta                   | Base com os coeficientes da regress�o �nica - Sal�rio Efetivo - Estrat�gia D
   - DD2_Coeficientes_genero.dta                  | Base com os coeficientes das regress�es separadas por g�nero - Sal�rio Efetivo - Estrat�gia D
      
   - D0_BaseEstimacao.dta                         | Base final com sal�rios preditos e pesos ponderados por horas - Sal�rio Efetivo  
   - D_IQT_Efetivo.dta                            | Base com os IQTs calculados para as quatro estrat�gias - Sal�rio Efetivo

   (obs: as estima��es A e B s�o equivalentes para o rendimento efetivo, de modo que estimamos as regress�es apenas uma vez, para o caso A).


> ---------------------------------------------------------

> E. ESTIMA��ES E IQT - SAL�RIO HABITUAL
  * Mesma rotina
  * Inputs:
   - C_PNADC_POamostra.dta
  * Outputs:
   - EA1_Estimacoes.ster                          | Arquivo que armazena as regress�es - Sal�rio Habitual - Estrat�gia A
   - EA2_Coeficientes_unico.dta                   | Base com os coeficientes da regress�o �nica - Sal�rio Habitual - Estrat�gia A
   - EA2_Coeficientes_genero.dta                  | Base com os coeficientes das regress�es separadas por g�nero - Sal�rio Habitual - Estrat�gia A

   - EB1_Estimacoes.ster                          | Arquivo que armazena as regress�es - Sal�rio Habitual - Estrat�gia B
   - EB2_Coeficientes_unico.dta                   | Base com os coeficientes da regress�o �nica - Sal�rio Habitual - Estrat�gia B
   - EB2_Coeficientes_genero.dta                  | Base com os coeficientes das regress�es separadas por g�nero - Sal�rio Habitual - Estrat�gia B
      
   - E0_BaseEstimacao.dta                         | Base final com sal�rios preditos e pesos ponderados por horas - Sal�rio Habitual  
   - E_IQT_Habitual.dta                           | Base com os IQTs calculados para as quatro estrat�gias - Sal�rio Habitual

   (obs: as estima��es A, C e D s�o equivalentes para o rendimento habitual, de modo que estimamos as regress�es apenas uma vez, para o caso A).

   - F_IQT.dta                                    | Base com os IQT: habitual e efetivo, todas estrat�gias      


> ---------------------------------------------------------

> F. GR�FICOS
  * Rotina: F_Graficos (c�pia da �ltima parte da rotina anterior)
  * Input:
   - F_IQT
  * Outputs: gr�ficos em .png               
  