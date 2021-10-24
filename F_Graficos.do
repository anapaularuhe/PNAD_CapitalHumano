*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Ana Paula Nothen Ruhe
* Outubro/2021
*******************************************************************************

* PREPARAÇÃO ******************************************************************
* Garantindo que não há variáveis prévias na memória:
clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
global dirpath = "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"
*global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
*global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 


* ESTRATÉGIAS *****************************************************************
* - Lidando com horas efetivas nulas: 4 estratégias (A, B, C e D)
*   A. Baseline: observações com horas efetivas nulas irão gerar missing values (são ignoradas nas regressões de salário efetivo, mas não habitual)
*   B. Indivíduos com horas efetivas nulas serão removidos das estimações (terão missing values) de salário efetivo e de salário habitual
*   C. Imputação: usaremos as horas habituais para os indivíduos com horas efetivas nulas para o cálculo do salário-hora
*   D. Usaremos horas efetivas = 1 para quem teve horas efetivas = 0




*******************************************************************************
* F. GRÁFICOS  
*******************************************************************************
  use "$dirdata/F_IQT.dta", clear
 
 * Efetivo  
   twoway (line IQT_efetA T) (line IQT_efetB T) (line IQT_efetC T) (line IQT_efetD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Efetivo, replace)
   twoway (line IQT_efetA_2012t2 T) (line IQT_efetB_2012t2 T) (line IQT_efetC_2012t2 T) (line IQT_efetD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Efetivo2012, replace)
   
 * Habitual
   twoway (line IQT_habA T) (line IQT_habB T) (line IQT_habC T) (line IQT_habD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Habitual, replace)
   twoway (line IQT_habA_2012t2 T) (line IQT_habB_2012t2 T) (line IQT_habC_2012t2 T) (line IQT_habD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Habitual2012, replace)
 
 
 * Por estratégia:
   * A
     twoway (line IQT_efetA T) (line IQT_habA T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_A, replace)
	 twoway (line IQT_efetA_2012t2 T) (line IQT_habA_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_A2012, replace)
   
   * B
     twoway (line IQT_efetB T) (line IQT_habB T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_B, replace)
	 twoway (line IQT_efetB_2012t2 T) (line IQT_habB_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_B2012, replace)
   
   * C
     twoway (line IQT_efetC T) (line IQT_habC T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C, replace)
	 twoway (line IQT_efetC_2012t2 T) (line IQT_habC_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C2012, replace)
   
   * D
     twoway (line IQT_efetD T) (line IQT_habD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_D, replace)
	 twoway (line IQT_efetD_2012t2 T) (line IQT_habD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_D2012, replace)
	 
