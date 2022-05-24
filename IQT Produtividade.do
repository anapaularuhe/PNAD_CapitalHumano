*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Estimação IQT
*******************************************************************************


* PREPARAÇÃO ******************************************************************
* Pacotes:
 *ssc install labutil
 *ssc install mdesc
 *ssc install tabout
 *ssc install outreg2

* Preparando memória: 
  clear all
  cls								
  set maxvar 30000
	
* Diretório:   
  global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT Produtividade"
  global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT\Dados"
  
* Salvando log:   
  log using "LogIQTProdutividade.log", replace  
  
   
*******************************************************************************
* 1. IQT PRODUTIVIDADE
*******************************************************************************
{
 use "$dirdata/B_BaseEstimacao.dta", clear

 * IQT0
  * Efetivo:
    gen dIQTP0_Ei = .        
    gen dIQTP0_Eiv = .          
   
  * Habitual: 
    gen dIQTP0_Hi = .        
    gen dIQTP0_Hiv = .    


   forvalues t = 2/`=Tmax'{
   * Sem controles: 
	 gen nEi = PE*WEi_Tprox if T==(`t'-1)
	 gen dEi = PE*WEi_T if T==(`t'-1)
	 gen nHi = PH*WHi_Tprox if T==(`t'-1)
	 gen dHi = PH*WHi_T if T==(`t'-1)
	  
	 egen sum_nEi = sum(nEi)
	 egen sum_dEi = sum(dEi)
	 egen sum_nHi = sum(nHi)
	 egen sum_dHi = sum(dHi)
	  
	 replace dIQTP0_Ei = sum_nEi/sum_dEi if T==`t'
	 replace dIQTP0_Hi = sum_nHi/sum_dHi if T==`t'  

	 drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
   * Com controles:
	 gen nEiv = PE*WEiv_Tprox if T==(`t'-1)
	 gen dEiv = PE*WEiv_T if T==(`t'-1)
	 gen nHiv = PH*WHiv_Tprox if T==(`t'-1)
	 gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	 egen sum_nEiv = sum(nEiv)
	 egen sum_dEiv = sum(dEiv)
	 egen sum_nHiv = sum(nHiv)
	 egen sum_dHiv = sum(dHiv)
	  
	 replace dIQTP0_Eiv = sum_nEiv/sum_dEiv if T==`t'
	 replace dIQTP0_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	 drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo:
    gen dIQTP1_Ei = .        
    gen dIQTP1_Eiv = .        
   
  * Habitual: 
    gen dIQTP1_Hi = .        
    gen dIQTP1_Hiv = . 
  
   forvalues t = 2/`=Tmax'{
   * Sem controles: 
	 gen nEi = PE*WEi_T if T==`t'
	 gen dEi = PE*WEi_Tante if T==`t'
	 gen nHi = PH*WHi_T if T==`t'
	 gen dHi = PH*WHi_Tante if T==`t'
	  
	 egen sum_nEi = sum(nEi)
	 egen sum_dEi = sum(dEi)
	 egen sum_nHi = sum(nHi)
	 egen sum_dHi = sum(dHi)
	  
	 replace dIQTP1_Ei = sum_nEi/sum_dEi if T==`t'
	 replace dIQTP1_Hi = sum_nHi/sum_dHi if T==`t'  

	 drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
   * Com controles:
	 gen nEiv = PE*WEiv_T if T==`t'
	 gen dEiv = PE*WEiv_Tante if T==`t'
	 gen nHiv = PH*WHiv_T if T==`t'
	 gen dHiv = PH*WHiv_Tante if T==`t'
	  
	 egen sum_nEiv = sum(nEiv)
	 egen sum_dEiv = sum(dEiv)
	 egen sum_nHiv = sum(nHiv)
	 egen sum_dHiv = sum(dHiv)
	  
	 replace dIQTP1_Eiv = sum_nEiv/sum_dEiv if T==`t'
	 replace dIQTP1_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	 drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQTP_Ei = (dIQTP0_Ei*dIQTP1_Ei)^(1/2)
   gen dIQTP_Hi = (dIQTP0_Hi*dIQTP1_Hi)^(1/2)
   
   gen dIQTP_Eiv = (dIQTP0_Eiv*dIQTP1_Eiv)^(1/2)
   gen dIQTP_Hiv = (dIQTP0_Hiv*dIQTP1_Hiv)^(1/2)
   
 compress
 save "$dirpath/BaseIQTProdutividade.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQTP_Ei dIQTP_Eiv dIQTP_Hi dIQTP_Hiv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * Sem controles
     gen IQTP_Ei = 100 if T==2
     replace IQTP_Ei = IQTP_Ei[_n-1]*dIQTP_Ei if _n > 2
     label var IQTP_Ei "IQT Produtividade - Efetivo - Sem controles"

	 gen IQTP_Hi = 100 if T==2
     replace IQTP_Hi = IQTP_Hi[_n-1]*dIQTP_Hi if _n > 2
     label var IQTP_Hi "IQT Produtividade - Habitual - Sem controles"
	 
   * Com controles
     gen IQTP_Eiv = 100 if T==2
     replace IQTP_Eiv = IQTP_Eiv[_n-1]*dIQTP_Eiv if _n > 2
     label var IQTP_Eiv "IQT Produtividade - Efetivo - Informal"
	 
	 gen IQTP_Hiv = 100 if T==2
     replace IQTP_Hiv = IQTP_Hiv[_n-1]*dIQTP_Hiv if _n > 2
     label var IQTP_Hiv "IQT Produtividade - Habitual - Informal" 
	 
   
   merge 1:1 T using "$dirdata/B_IQT.dta"
   drop _merge
   
   save "$dirpath\IQTProdutividade.dta", replace
   export excel T IQT_Ei IQT_Eiv IQTP_Ei IQTP_Eiv  using "$dirpath\IQTProdutividade.xlsx", sheet("Efetivo") firstrow(varlabels) replace   
   export excel T IQT_Hi IQT_Hiv IQTP_Hi IQTP_Hiv using "$dirpath\IQTProdutividade.xlsx", sheet ("Habitual", modify) firstrow(varlabels)
  restore
  }  
} 
 
 
*******************************************************************************
* 2. IQT VALOR
*******************************************************************************
{
 use "$dirpath/BaseIQTProdutividade.dta", clear

 * IQT Valor: dIQT_V = dIQT_P x dIQT_Q
  * Efetivo:
    gen dIQTV_Ei = .        
    gen dIQTV_Eiv = .    
	
	gen dIQTV_Ei_nominal = .        
    gen dIQTV_Eiv_nominal = . 
   
   
  * Habitual: 
    gen dIQTV_Hi = .        
    gen dIQTV_Hiv = .    
	
	gen dIQTV_Hi_nominal = .        
    gen dIQTV_Hiv_nominal = .   


   forvalues t = 2/`=Tmax'{
   * Sem controles: 
    * Rendimento real:
	  gen nEi = PE*WEi_T if T==`t'
	  gen dEi = PE*WEi_T if T==(`t'-1)
	  gen nHi = PH*WHi_T if T==`t'
	  gen dHi = PH*WHi_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQTV_Ei = sum_nEi/sum_dEi if T==`t'
	  replace dIQTV_Hi = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	  

    * Rendimento nominal:
	  gen nEi = PE*WEi_T_nominal if T==`t'
	  gen dEi = PE*WEi_T_nominal if T==(`t'-1)
	  gen nHi = PH*WHi_T_nominal if T==`t'
	  gen dHi = PH*WHi_T_nominal if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQTV_Ei_nominal = sum_nEi/sum_dEi if T==`t'
	  replace dIQTV_Hi_nominal = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi	  
	
	
   * Com controles:
    * Rendimento real:
	  gen nEiv = PE*WEiv_T if T==`t'
	  gen dEiv = PE*WEiv_T if T==(`t'-1)
	  gen nHiv = PH*WHiv_T if T==`t'
	  gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQTV_Eiv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQTV_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
	  
	  
    * Rendimento nominal:
	  gen nEiv = PE*WEiv_T_nominal if T==`t'
	  gen dEiv = PE*WEiv_T_nominal if T==(`t'-1)
	  gen nHiv = PH*WHiv_T_nominal if T==`t'
	  gen dHiv = PH*WHiv_T_nominal if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQTV_Eiv_nominal = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQTV_Hiv_nominal = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv	  
   }
 
 compress
 save "$dirpath/BaseIQTProdutividade.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQTV_Ei dIQTV_Eiv dIQTV_Hi dIQTV_Hiv dIQTV_Ei_nominal dIQTV_Eiv_nominal dIQTV_Hi_nominal dIQTV_Hiv_nominal
   duplicates drop
  
   * OBS: calcularemos apenas os IQT com 2012.2 = 100
   * Sem controles
     gen IQTV_Ei = 100 if T==2
     replace IQTV_Ei = IQTV_Ei[_n-1]*dIQTV_Ei if _n > 2
     label var IQTV_Ei "IQT Valor - Efetivo - Sem controles"

	 gen IQTV_Hi = 100 if T==2
     replace IQTV_Hi = IQTV_Hi[_n-1]*dIQTV_Hi if _n > 2
     label var IQTV_Hi "IQT Valor - Habitual - Sem controles"
	 
	 gen IQTV_Ei_nominal = 100 if T==2
     replace IQTV_Ei_nominal = IQTV_Ei_nominal[_n-1]*dIQTV_Ei_nominal if _n > 2
     label var IQTV_Ei_nominal "IQT Valor Nominal - Efetivo - Sem controles"

	 gen IQTV_Hi_nominal = 100 if T==2
     replace IQTV_Hi_nominal = IQTV_Hi_nominal[_n-1]*dIQTV_Hi_nominal if _n > 2
     label var IQTV_Hi_nominal "IQT Valor Nominal - Habitual - Sem controles"
	 
   
   * Com controles
     gen IQTV_Eiv = 100 if T==2
     replace IQTV_Eiv = IQTV_Eiv[_n-1]*dIQTV_Eiv if _n > 2
     label var IQTV_Eiv "IQT Valor - Efetivo - Informal"
	 
	 gen IQTV_Hiv = 100 if T==2
     replace IQTV_Hiv = IQTV_Hiv[_n-1]*dIQTV_Hiv if _n > 2
     label var IQTV_Hiv "IQT Valor - Habitual - Informal" 
	 
	 gen IQTV_Eiv_nominal = 100 if T==2
     replace IQTV_Eiv_nominal = IQTV_Eiv_nominal[_n-1]*dIQTV_Eiv_nominal if _n > 2
     label var IQTV_Eiv_nominal "IQT Valor Nominal - Efetivo - Informal"
	 
	 gen IQTV_Hiv_nominal = 100 if T==2
     replace IQTV_Hiv_nominal = IQTV_Hiv_nominal[_n-1]*dIQTV_Hiv_nominal if _n > 2
     label var IQTV_Hiv_nominal "IQT Valor Nominal - Habitual - Informal" 
	 
   
   merge 1:1 T using "$dirpath/IQTProdutividade.dta"
   drop _merge
   
   save "$dirpath/IQTProdutividade.dta", replace
   export excel T IQT_Ei IQT_Eiv IQTP_Ei IQTP_Eiv IQTV_Ei IQTV_Eiv IQTV_Ei_nominal IQTV_Eiv_nominal using "$dirpath/IQTProdutividade.xlsx", sheet("Efetivo") firstrow(varlabels) replace   
   export excel T IQT_Hi IQT_Hiv IQTP_Hi IQTP_Hiv IQTV_Hi IQTV_Hiv IQTV_Hi_nominal IQTV_Hiv_nominal using "$dirpath/IQTProdutividade.xlsx", sheet ("Habitual", modify) firstrow(varlabels)
   
  restore
  }   
} 
 
  
*******************************************************************************
* 3. GRÁFICOS
*******************************************************************************  
{
 use "$dirpath/IQTProdutividade.dta", clear

* 3.1 SEM CONTROLES ***********************************************************   
 {
 * Efetivo:
   twoway (line IQT_Ei T, lcolor(blue)) (line IQTP_Ei T, lcolor(orange)) (line IQTV_Ei T, lcolor(green)) (line IQTV_Ei_nominal T, lcolor(purple)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(80(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTValorEfetivoSem, replace) 
   *graph export "$dirpath/Gráficos/IQTValorEfetivoSem.png", width(10000) as(png) replace
   
 * Habitual:
   twoway (line IQT_Hi T, lcolor(blue)) (line IQTP_Hi T, lcolor(orange)) (line IQTV_Hi T, lcolor(green)) (line IQTV_Hi_nominal T, lcolor(purple)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(80(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTValorHabitualSem, replace) 
   *graph export "$dirpath/Gráficos/IQTValorHabitualSem.png", width(10000) as(png) replace 
 }

* 3.2 COM CONTROLES ***********************************************************   
 {
 * Efetivo:
   twoway (line IQT_Eiv T, lcolor(blue)) (line IQTP_Eiv T, lcolor(orange)) (line IQTV_Eiv T, lcolor(green)) (line IQTV_Eiv_nominal T, lcolor(purple)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(80(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTValorEfetivoCom, replace) 
   *graph export "$dirpath/Gráficos/IQTValorEfetivoCom.png", width(10000) as(png) replace
   
 * Habitual:
   twoway (line IQT_Hiv T, lcolor(blue)) (line IQTP_Hiv T, lcolor(orange)) (line IQTV_Hiv T, lcolor(green)) (line IQTV_Hiv_nominal T, lcolor(purple)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(80(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTValorHabitualCom, replace) 
   *graph export "$dirpath/Gráficos/IQTValorHabitualCom.png", width(10000) as(png) replace 
 } 
}  
 

log close 