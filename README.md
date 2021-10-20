# PNAD_CapitalHumano
Arquivos referentes ao uso da PNAD Contínua no projeto sobre Capital Humano e Produtividade


--------------------------------------------------------------------------------------------
> Projeto Capital Humano e Produtividade
> FGV IBRE - Núcleo de Mercado de Trabalho e Produtividade
> Outubro de 2021
> ---------------------------------------------------------

> A. IMPORTANDO DADOS E CONTRUINDO BASE COM DEFLATORES
  * Rotina: A_Rotina_limpeza_amostra.do
  * Inputs:
   - A0_PNADC2012_2021_bruta.dta                 | Base bruta da PNAD, em .dta
   - deflator_PNADC_2021_trimestral_040506.xls   | Deflatores brutos da PNAD, em .xls, com aba editada
  * Outputs:
   - A1_deflator_2t2021.dta                      | Deflatores da PNAD em .dta
   - A2_PNADC2012_2021_completa_deflatores.dta   | Base completa com deflatores 


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

> D. SELECIONANDO AMOSTRA: POPULAÇÃO OCUPADA
  * D_Rotina_estimacao_IQT
  * Inputs:
   - C_PNADC_POamostra.dta
