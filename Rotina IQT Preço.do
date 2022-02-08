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
** Servidor RDPBI1VPR0002 (Ana Paula):   
   global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\2_IQT Preço"
   global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\1_IQT\Dados"

** Janaina:    
   global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
   global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 
   
   
*******************************************************************************
* 1. IQT PREÇO
*******************************************************************************
{
 use "$dirdata/C_BaseEstimacao.dta", clear

 * IQT0
  * Efetivo:
   gen dIQTP0_Ei = .        
   gen dIQTP0_Eii = .        
   gen dIQTP0_Eiii = .        
   gen dIQTP0_Eiv = .          
   
  * Habitual: 
   gen dIQTP0_Hi = .        
   gen dIQTP0_Hii = .        
   gen dIQTP0_Hiii = .        
   gen dIQTP0_Hiv = .    


   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
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
	
	
   * (ii) Cor:
	  gen nEii = PE*WEii_Tprox if T==(`t'-1)
	  gen dEii = PE*WEii_T if T==(`t'-1)
	  gen nHii = PH*WHii_Tprox if T==(`t'-1)
	  gen dHii = PH*WHii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQTP0_Eii = sum_nEii/sum_dEii if T==`t'
	  replace dIQTP0_Hii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = PE*WEiii_Tprox if T==(`t'-1)
	  gen dEiii = PE*WEiii_T if T==(`t'-1)
	  gen nHiii = PH*WHiii_Tprox if T==(`t'-1)
	  gen dHiii = PH*WHiii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQTP0_Eiii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQTP0_Hiii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
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
   gen dIQTP1_Eii = .        
   gen dIQTP1_Eiii = .        
   gen dIQTP1_Eiv = .        
   
  * Habitual: 
   gen dIQTP1_Hi = .        
   gen dIQTP1_Hii = .        
   gen dIQTP1_Hiii = .        
   gen dIQTP1_Hiv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
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
	
	
   * (ii) Cor:
	  gen nEii = PE*WEii_T if T==`t'
	  gen dEii = PE*WEii_Tante if T==`t'
	  gen nHii = PH*WHii_T if T==`t'
	  gen dHii = PH*WHii_Tante if T==`t'
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQTP1_Eii = sum_nEii/sum_dEii if T==`t'
	  replace dIQTP1_Hii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = PE*WEiii_T if T==`t'
	  gen dEiii = PE*WEiii_Tante if T==`t'
	  gen nHiii = PH*WHiii_T if T==`t'
	  gen dHiii = PH*WHiii_Tante if T==`t'
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQTP1_Eiii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQTP1_Hiii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
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
   
   gen dIQTP_Eii = (dIQTP0_Eii*dIQTP1_Eii)^(1/2)
   gen dIQTP_Hii = (dIQTP0_Hii*dIQTP1_Hii)^(1/2)
  
   gen dIQTP_Eiii = (dIQTP0_Eiii*dIQTP1_Eiii)^(1/2)
   gen dIQTP_Hiii = (dIQTP0_Hiii*dIQTP1_Hiii)^(1/2)  
  
   gen dIQTP_Eiv = (dIQTP0_Eiv*dIQTP1_Eiv)^(1/2)
   gen dIQTP_Hiv = (dIQTP0_Hiv*dIQTP1_Hiv)^(1/2)
   
 
 compress
 save "$dirpath/BaseIQTPreço.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQTP_Ei dIQTP_Eii dIQTP_Eiii dIQTP_Eiv dIQTP_Hi dIQTP_Hii dIQTP_Hiii dIQTP_Hiv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQTP_Ei = 100 if T==2
     replace IQTP_Ei = IQTP_Ei[_n-1]*dIQTP_Ei if _n > 2
     label var IQTP_Ei "IQT Preço - Efetivo - Sem controles"

	 gen IQTP_Hi = 100 if T==2
     replace IQTP_Hi = IQTP_Hi[_n-1]*dIQTP_Hi if _n > 2
     label var IQTP_Hi "IQT Preço - Habitual - Sem controles"
	 
	 
   * (ii) Cor
     gen IQTP_Eii = 100 if T==2
     replace IQTP_Eii = IQTP_Eii[_n-1]*dIQTP_Eii if _n > 2
     label var IQTP_Eii "IQT Preço - Efetivo - Cor"
	 
	 gen IQTP_Hii = 100 if T==2
     replace IQTP_Hii = IQTP_Hii[_n-1]*dIQTP_Hii if _n > 2
     label var IQTP_Hii "IQT Preço - Habitual - Cor"
   
   
   * (iii) Setor público
     gen IQTP_Eiii = 100 if T==2
     replace IQTP_Eiii = IQTP_Eiii[_n-1]*dIQTP_Eiii if _n > 2
     label var IQTP_Eiii "IQT Preço - Efetivo - Setor público"
	 
	 gen IQTP_Hiii = 100 if T==2
     replace IQTP_Hiii = IQTP_Hiii[_n-1]*dIQTP_Hiii if _n > 2
     label var IQTP_Hiii "IQT Preço - Habitual - Setor público" 
	 
	 
   * (iv) Informal
     gen IQTP_Eiv = 100 if T==2
     replace IQTP_Eiv = IQTP_Eiv[_n-1]*dIQTP_Eiv if _n > 2
     label var IQTP_Eiv "IQT Preço - Efetivo - Informal"
	 
	 gen IQTP_Hiv = 100 if T==2
     replace IQTP_Hiv = IQTP_Hiv[_n-1]*dIQTP_Hiv if _n > 2
     label var IQTP_Hiv "IQT Preço - Habitual - Informal" 
	 
   
   merge 1:1 T using "$dirdata/C_IQT.dta"
   drop _merge
   
   save "$dirpath/IQTPreço.dta", replace
   export excel T IQT_Ei IQT_Eii IQT_Eiii IQT_Eiv IQTP_Ei IQTP_Eii IQTP_Eiii IQTP_Eiv  using "$dirpath\IQTPreço.xlsx", sheet("Efetivo") firstrow(varlabels) replace   
   export excel T IQT_Hi IQT_Hii IQT_Hiii IQT_Hiv IQTP_Hi IQTP_Hii IQTP_Hiii IQTP_Hiv using "$dirpath\IQTPreço.xlsx", sheet ("Habitual", modify) firstrow(varlabels)

   restore
   }  
  
} 
 
 
*******************************************************************************
* 2. IQT VALOR
*******************************************************************************
{
 use "$dirpath/BaseIQTPreço.dta", clear

 * IQT Valor: dIQT_V = dIQT_P x dIQT_Q
  * Efetivo:
   gen dIQTV_Ei = .        
   gen dIQTV_Eii = .        
   gen dIQTV_Eiii = .        
   gen dIQTV_Eiv = .          
   
  * Habitual: 
   gen dIQTV_Hi = .        
   gen dIQTV_Hii = .        
   gen dIQTV_Hiii = .        
   gen dIQTV_Hiv = .    


   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
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
	
	
   * (ii) Cor:
	  gen nEii = PE*WEii_T if T==`t'
	  gen dEii = PE*WEii_T if T==(`t'-1)
	  gen nHii = PH*WHii_T if T==`t'
	  gen dHii = PH*WHii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQTV_Eii = sum_nEii/sum_dEii if T==`t'
	  replace dIQTV_Hii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = PE*WEiii_T if T==`t'
	  gen dEiii = PE*WEiii_T if T==(`t'-1)
	  gen nHiii = PH*WHiii_T if T==`t'
	  gen dHiii = PH*WHiii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQTV_Eiii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQTV_Hiii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
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
   }
 
 compress
 save "$dirpath/BaseIQTPreço.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQTV_Ei dIQTV_Eii dIQTV_Eiii dIQTV_Eiv dIQTV_Hi dIQTV_Hii dIQTV_Hiii dIQTV_Hiv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQTV_Ei = 100 if T==2
     replace IQTV_Ei = IQTV_Ei[_n-1]*dIQTV_Ei if _n > 2
     label var IQTV_Ei "IQT Valor - Efetivo - Sem controles"

	 gen IQTV_Hi = 100 if T==2
     replace IQTV_Hi = IQTV_Hi[_n-1]*dIQTV_Hi if _n > 2
     label var IQTV_Hi "IQT Valor - Habitual - Sem controles"
	 
	 
   * (ii) Cor
     gen IQTV_Eii = 100 if T==2
     replace IQTV_Eii = IQTV_Eii[_n-1]*dIQTV_Eii if _n > 2
     label var IQTV_Eii "IQT Valor - Efetivo - Cor"
	 
	 gen IQTV_Hii = 100 if T==2
     replace IQTV_Hii = IQTV_Hii[_n-1]*dIQTV_Hii if _n > 2
     label var IQTV_Hii "IQT Valor - Habitual - Cor"
   
   
   * (iii) Setor público
     gen IQTV_Eiii = 100 if T==2
     replace IQTV_Eiii = IQTV_Eiii[_n-1]*dIQTV_Eiii if _n > 2
     label var IQTV_Eiii "IQT Valor - Efetivo - Setor público"
	 
	 gen IQTV_Hiii = 100 if T==2
     replace IQTV_Hiii = IQTV_Hiii[_n-1]*dIQTV_Hiii if _n > 2
     label var IQTV_Hiii "IQT Valor - Habitual - Setor público" 
	 
	 
   * (iv) Informal
     gen IQTV_Eiv = 100 if T==2
     replace IQTV_Eiv = IQTV_Eiv[_n-1]*dIQTV_Eiv if _n > 2
     label var IQTV_Eiv "IQT Valor - Efetivo - Informal"
	 
	 gen IQTV_Hiv = 100 if T==2
     replace IQTV_Hiv = IQTV_Hiv[_n-1]*dIQTV_Hiv if _n > 2
     label var IQTV_Hiv "IQT Valor - Habitual - Informal" 
	 
   
   merge 1:1 T using "$dirpath/IQTPreço.dta"
   drop _merge
   
   save "$dirpath/IQTPreço.dta", replace
   export excel T IQT_Ei IQT_Eii IQT_Eiii IQT_Eiv IQTP_Ei IQTP_Eii IQTP_Eiii IQTP_Eiv IQTV_Ei IQTV_Eii IQTV_Eiii IQTV_Eiv  using "$dirpath/IQTPreço.xlsx", sheet("Efetivo") firstrow(varlabels) replace   
   export excel T IQT_Hi IQT_Hii IQT_Hiii IQT_Hiv IQTP_Hi IQTP_Hii IQTP_Hiii IQTP_Hiv IQTV_Hi IQTV_Hii IQTV_Hiii IQTV_Hiv using "$dirpath/IQTPreço.xlsx", sheet ("Habitual", modify) firstrow(varlabels)

   restore
   }  
  
} 
 
  
 
 
 