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
** Servidor bif004 (Ana Paula):
   global dirpath = "A:/Ana Paula Ruhe/Capital Humano" 
   global dirdata = "A:/Ana Paula Ruhe/Capital Humano/Dados"
   
** Servidor RDPBI1VPR0002 (Ana Paula):   
   global dirpath = "B:/Ana Paula Ruhe/Capital Humano"
   global dirdata = "B:/Ana Paula Ruhe/Capital Humano/Dados"

** Janaina:    
   global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
   global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 
   
* Salvando log:   
  log using "LogIQT.log", replace
  
  
*******************************************************************************
* A. IMPORTANDO DADOS E CONSTRUINDO BASE COMPLETA COM DEFLATORES: 2012.2-2021.2 
*******************************************************************************
{
* Primeira importação: datazoom
/*
   datazoom_pnadcontinua, years( 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021) original("$dirpath\PNAD_Original") saving ("$dirdata") nid
  
  * Com os dados em .dta: criando base completa
	use "$dirdata/PNADC_trimestral_2012.dta"
	append using "$dirdata/PNADC_trimestral_2013.dta"
	append using "$dirdata/PNADC_trimestral_2014.dta"
	append using "$dirdata/PNADC_trimestral_2015.dta"
	append using "$dirdata/PNADC_trimestral_2016.dta"
	append using "$dirdata/PNADC_trimestral_2017.dta"
	append using "$dirdata/PNADC_trimestral_2018.dta"
	append using "$dirdata/PNADC_trimestral_2019.dta"
	append using "$dirdata/PNADC_trimestral_2020.dta"
	append using "$dirdata/PNADC_trimestral_2021.dta"

	save "$dirdata/A0_PNADC2012_2021_bruta.dta", replace
*/	
	
	
* Construindo base completa com deflatores 

  * Salvando deflatores em dta
	import excel "$dirdata\deflator_PNADC_2021_trimestral_040506.xls", sheet("deflatormod") firstrow clear
	destring Ano UF, replace 
	save  "$dirdata/A1_deflator_2t2021.dta" , replace
	 
  * Merge
	use "$dirdata/A0_PNADC2012_2021_bruta.dta", clear
	destring Trimestre, replace
    merge m:1 Ano UF Trimestre using "$dirdata/A1_deflator_2t2021.dta"
	drop _merge
	
  * Criando variável de Período 
    gen T = ((Ano - 2012)*4) + Trimestre
    label var T "Período sequencial"
    order T, after(Trimestre)
   
    * Label:
     tostring Ano, generate(Ano_string) 
	 tostring Trimestre, generate(Trimestre_string)
     gen Periodo = Ano_string + "-" + Trimestre_string
     labmask T, values(Periodo)
   
     drop Ano_string Trimestre_string Periodo
	 
   save "$dirdata/A2_PNADC2012_2021_completa_deflatores.dta", replace	
   
}


*******************************************************************************
* B. SELEÇÃO DE VARIÁVEIS E ORGANIZAÇÃO DA BASE
*******************************************************************************
{
/* Vamos manter as seguintes variáveis:
	Ano        | Ano
	Trimestre  | Trimestre
	UF         | UF
	V1027      | Peso trimestral com correção de não entrevista SEM PÓS ESTRATIFICAÇÃO pela projeção de população
	V1028      | Peso trimestral com correção de não entrevista COM PÓS ESTRATIFICAÇÃO pela projeção de população  
	V1029      | Projeção da população
	
	V2007      | Sexo
	V2009      | Idade
	V2010      | Cor ou raça
		
	VD3004	   | Nível de educação mais elevado alcançado (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	VD3005     | Anos de estudo                           (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	             * Obs: variável parcialmente categória; 16 = 16 anos ou mais 
	VD3006     | Grupos de anos de estudo                 (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente)
	
	VD4001     | Condição na força de trabalho
	VD4002     | Condição de ocupação
	VD4009     | Posição na ocupação 
	VD4010     | Atividade principal do setor
	VD4016     | Rendimento habitual mensal (trabalho principal)
	VD4017     | Rendimento efetivo mensal  (trabalho principal)
	VD4019     | Rendimento habitual mensal (todos os trabalhos)
	VD4020     | Rendimento efetivo mensal  (todos os trabalhos)
	VD4031     | Horas habitualmente trabalhadas por semana (todos os trabalhos)
	VD4032     | Horas efetivamente trabalhadas na semana   (trabalho principal)
	VD4035     | Horas efetivamente trabalhadas na semana   (todos os trabalhos)
	
	Efetivo    | Deflator com base nos redimentos efetivos
	Habitual   | Deflator com base nos rendimentos habituais	
	
*/

  use "$dirdata/A2_PNADC2012_2021_completa_deflatores.dta", clear
  keep Ano Trimestre T UF V1027 V1028 V1029 V2007 V2009 V2010 VD3004 VD3005 VD3006 VD4001 VD4002 VD4009 VD4010 VD4016 VD4017 VD4019 VD4020 VD4031 VD4032 VD4035 Efetivo Habitual

   
* Nomeando algumas variáveis de forma mais intuitiva:
  rename V1028 Peso
  rename V1029 Populacao
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor
  

* Definindo labels e criando dummies quando necessário 
** SEXO  
  mdesc Sexo
  drop if Sexo ==.  

  label define sexo 1 "Homem" 2 "Mulher" 
  label values Sexo sexo
  
  gen byte mulher = (Sexo==2)
  label var mulher "Dummy=1 se Mulher"
  
  order mulher, after(Sexo)
  
  
** COR
  tab T Cor
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indigena" 9 "Ignorado"  
  label values Cor cor_label 

	
** ESCOLARIDADE
  * VD3004: Nível de instrução
  label define VD3004_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "Fundamental incompleto ou equivalente" 3 "Fundamental completo ou equivalente" 4 "Médio incompleto ou equivalente" 5 "Médio completo ou equivalente" 6 "Superior incompleto ou equivalente" 7 "Superior completo" 
  label values VD3004 VD3004_label
   
   
  * VD3006: Grupo de anos de estudo (eliminamos observações com missing values)  
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  tab T VD3006 [iw=Peso] if VD4002==1
  * Obs: mais de 20% da pop ocupada (19.583.262) tem ensino superior 
  
  drop if VD3006 ==.
  gen byte educ1 = (VD3006==1)
  gen byte educ2 = (VD3006==2)
  gen byte educ3 = (VD3006==3)
  gen byte educ4 = (VD3006==4)
  gen byte educ5 = (VD3006==5)
  gen byte educ6 = (VD3006==6)
  
  label var educ1 "Dummy 0<= educacao < 1"
  label var educ2 "Dummy 1<= educacao <=4"
  label var educ3 "Dummy 5<= educacao <=8"
  label var educ4 "Dummy 9<= educacao <=11"
  label var educ5 "Dummy 12<= educacao <=15"
  label var educ6 "Dummy educacao >=16"
    
   
* TRABALHO  
  * VD4001: Condição na força de trabalho
  label define VD4001_label 1 "Na força de trabalho" 2 "Fora da força de trabalho"
  label values VD4001 VD4001_label

  
  * VD4002: Condição de ocupação
  label define VD4002_label 1 "Ocupado" 2 "Desocupado"
  label values VD4002 VD4002_label
  tab T VD4002 [iw=Peso] if VD4002==1
  
  
  * VD4009: Posição na ocupação 
  label define VD4009_label 1 "privado COM carteira" 2 "privado SEM carteira" 3 "doméstico COM carteira" 4 "doméstico SEM carteira" 5 "público COM carteira" 6 "público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "familiar auxiliar"
  label values VD4009 VD4009_label
  tab T VD4009 [iw=Peso] 
  
  gen byte publico = (VD4009>=05 & VD4009<=07) if VD4009!=.
  label var publico "Dummy = 1 se ocupado no setor publico"
  
  gen byte informal = (VD4009==02 | VD4009==04 | VD4009==06 | VD4009==10)
  label var informal "Dummy = 1 se ocupado no setor informal"
  
  order publico informal, after(VD4009)
      
   
  * VD4010: Setor de atividade
  /* Como os nomes são muito longos, vamos usar resumos:
   01	Agricultura, pecuária, produção florestal, pesca e aquicultura    | Agropecuária
   02	Indústria geral                                                   | Indústria
   03	Construção                                                        | Construção
   04	Comércio, reparação de veículos automotores e motocicletas        | Veículos
   05	Transporte, armazenagem e correio                                 | Transporte
   06	Alojamento e alimentação                                          | Alojamento e alimentação
   07	Informação, comunicação e atividades financeiras, imobiliárias,   | Serviços de informação 
           profissionais e administrativas
   08	Administração pública, defesa e seguridade social                 | Administração pública 
   09	Educação, saúde humana e serviços sociais                         | Educação e saúde  
   10	Outros Serviços                                                   | Outros serviços  
   11	Serviços domésticos                                               | Serviços domésticos
   12	Atividades mal definidas                                          | Atividades mal definidas
  */

  label define VD4010_label 1 "Agropecuária" 2 "Indústria" 3 "Construção" 4 "Veículos" 5 "Transporte" 6 "Alojamento e alimentação" 7 "Serviços de informação" 8 "Administração pública" 9 "Educação e saúde" 10 "Outros serviços" 11 "Serviços domésticos" 12 "Atividades mal definidas"
  label values VD4010 VD4010_label
     
  
* REGIÃO: Criando variável a partir das UF
/* Classificação das UF:
	11	Rondônia
	12	Acre
	13	Amazonas
	14	Roraima
	15	Pará
	16	Amapá
	17	Tocantins
	21	Maranhão
	22	Piauí
	23	Ceará
	24	Rio Grande do Norte
	25	Paraíba
	26	Pernambuco
	27	Alagoas
	28	Sergipe
	29	Bahia
	31	Minas Gerais
	32	Espírito Santo
	33	Rio de Janeiro
	35	São Paulo
	41	Paraná
	42	Santa Catarina
	43	Rio Grande do Sul
	50	Mato Grosso do Sul
	51	Mato Grosso
	52	Goiás
	53	Distrito Federal
*/
    gen Regiao=""
	label var Regiao "Região"
	replace Regiao="NO" if UF>=11 & UF<=17
	replace Regiao="NE" if UF>=21 & UF<=29
	replace Regiao="SE" if UF>=31 & UF<=35
	replace Regiao="SU" if UF>=41 & UF<=43
	replace Regiao="CO" if UF>=50 & UF<=53
    
	order Regiao, after(UF)
		
	
* EXPERIÊNCIA: não pode ter missing nas variáveis idade e escolaridade
  mdesc Idade
  drop if Idade == .
  gen Experiencia =.
  label var Experiencia "Experiencia"
  order Experiencia, after(VD3006)
  replace Experiencia = Idade - VD3005 - 6 if VD3005>=9
  replace Experiencia = Idade - 15 if VD3005<9
	
  * Corrigindo valores negativos (considerando pessoas ocupadas, mudança média de 2 mil observações por trimestre representando em média 130 mil pessoas):
  replace Experiencia= 0 if Experiencia<0 

  * Imputando 0 nos missings (considerando pessoas ocupadas, 0 observações perdidas):  
	replace Experiencia=0 if Experiencia ==. 
	
  * Potências de Experiência:
	gen Experiencia2 = Experiencia^2
	gen Experiencia3 = Experiencia^3
	gen Experiencia4 = Experiencia^4
	
	label var Experiencia2 "Experiência ao quadrado"
	label var Experiencia3 "Experiência ao cubo"
	label var Experiencia4 "Experiência elevada à 4 potência"

   
   save "$dirdata/B_PNADC2012_2021_limpa.dta", replace
}


*******************************************************************************
* C. RESTRIÇÃO DA AMOSTRA: POPULAÇÃO OCUPADA 
*******************************************************************************
{
  use "$dirdata/B_PNADC2012_2021_limpa.dta", clear

* 1. ANALISANDO INDIVÍDUOS DA PO COM MISSING VALUES EM VARIÁVEIS FUNDAMENTAIS:
  preserve
  keep if VD4002==1
	  
  mdesc VD4019 VD4020 VD4031 VD4035 
  
  * Entendendo qual o perfil dos que serão dropados
    gen cont=1
    tab T cont [iw=Peso] if (VD4019==. & VD4020==.)
    tab T Sexo [iw=Peso] if (VD4019==. & VD4020==.)
    tab T Cor [iw=Peso] if (VD4019==. & VD4020==.)
    tab T Regiao [iw=Peso] if (VD4019==. & VD4020==.)
    tab T VD3006 [iw=Peso] if (VD4019==. & VD4020==.)
   
  * Obs1: 355.856 trabalhadores auxiliares sem rendimentos e 34.940 conta própria sem rendimento, representando conjuntamente, em média, mais de 2,2 milhões da PO por trimestre
  * Obs2: Observações faltantes são as mesmas para os dois tipos de rendimento.
   
    drop if VD4019==. & VD4020==. 
    mdesc VD4019 VD4020 VD4031 VD4035
  
  * Conclusão: iremos dropar indivíduos com missing nos rendimentos 
  restore	 
  
  
* 2. CARACTERÍSTICAS DA PO SEM MISSING VALUES NOS RENDIMENTOS:
  keep if VD4002==1
  drop if VD4019==. & VD4020==. 
  
  * Ao longo do tempo:
    tabout T VD4002 [iw = Peso] using "$dirdata/C_Caracteristicas_PO.xls", cells(freq row) replace
      
  * Participação por cor e gênero:
    tabout T Sexo [iw = Peso] using "$dirdata/C_Caracteristicas_PO.xls", cells(freq row) append
    tabout T Cor  [iw = Peso] using "$dirdata/C_Caracteristicas_PO.xls", cells(freq row) append
   
  * Participação por região:
    tabout T Regiao  [iw = Peso] using "$dirdata/C_Caracteristicas_PO.xls",  cells(freq row) append
  
  * Participação por grupo de escolaridade:
    tabout T VD3006  [iw = Peso] using "$dirdata/C_Caracteristicas_PO.xls",  cells(freq row) append
 

* 3. CONSTRUINDO RENDIMENTOS REAIS E SALÁRIOS-HORA
 * 3.1: RENDIMENTO REAL  
  * Habitual (todos o trabalhos)	
    gen VD4019_real = VD4019*Habitual
	label var VD4019_real "Rendimento real habitual de todos os trabalhos"
	order VD4019_real, after(VD4019)
 
 
  * Efetivo (todos o trabalhos)
    gen VD4020_real = VD4020*Efetivo
    label var VD4020_real "Rendimento real efetivo de todos os trabalhos"
	order VD4020_real, after(VD4020)
 
 * 3.2 SALÁRIO HORA
  * Estratégia IPEA: drop observações com horas efetivas nulas
    drop if VD4035 == 0
  
  * Salário-hora Habitual Real (todos o trabalhos)
    gen sh_hab = VD4019_real/(VD4031*4)
	label var sh_hab "Rendimento real por hora habitual de todos os trabalhos"
    order VD4031 sh_hab, after(VD4019_real)
  
  
  * Salário-hora Efetivo Real (todos o trabalhos)
    gen sh_efet = VD4020_real/(VD4035*4)
	label var sh_efet "Rendimento real por hora efetivo de todos os trabalhos"
	order VD4035 sh_efet, after(VD4020_real)
	
 * 3.3 LOG DOS SALÁRIOS  
  * Habitual:
   gen logW_hab = ln(sh_hab)
   label var logW_hab "Log do rendimento real habitual por hora"
   
  * Efetivo:
  ** ATENÇÃO: existem observações com rendimento efetivo = 0. logW_efet = . para essas observações. 
    gen logW_efet = ln(sh_efet)
    label var logW_efet "Log do rendimento real efetivo por hora"
    
  
  save "$dirdata/C_PNADC_POamostra.dta", replace
}


*******************************************************************************
* D. ESTIMAÇÃO IQT
*******************************************************************************
{
 
* D.0: PREPARAÇÃO *************************************************************
{ 
  use "$dirdata/C_PNADC_POamostra.dta", clear
  
* Eliminar variáveis que não são necessárias para a estimação (reduzir uso de memória):
  drop UF Regiao V1027 Populacao Idade VD3004 VD3005 VD4001 VD4002 VD4009 VD4010 VD4016 VD4017 VD4019 VD4019_real VD4020 VD4020_real VD4032 Efetivo Habitual 
   
* Variáveis adicionalmente necessárias:
  egen Tmax = max(T)

 * Interação mulher x experiência:
   gen ExperMulher = Experiencia*mulher
   gen ExperMulher2 = Experiencia2*mulher
   gen ExperMulher3 = Experiencia3*mulher
   gen ExperMulher4 = Experiencia4*mulher

 * Para as tabelas, vamos renomear alguns labels:
   label var mulher "Mulher"
   label var educ2 "Estudo 1 a 4 anos"
   label var educ3 "Estudo 5 a 8 anos"
   label var educ4 "Estudo 9 a 11 anos"
   label var educ5 "Estudo 12 a 15 anos"
   label var educ6 "Estudo 16+ anos"
   label var Experiencia2 "Experiencia^2"
   label var Experiencia3 "Experiencia^3"
   label var Experiencia4 "Experiencia^4"
   label var ExperMulher "Exper x Mulher"
   label var ExperMulher2 "Exper^2 x Mulher"
   label var ExperMulher3 "Exper^3 x Mulher"
   label var ExperMulher4 "Exper^4 x Mulher"
   label var publico "Setor publico"
   label var informal "Informal"
   
 * Cor/raça ignorada:  2.093 observações em 8.249.275 (0,03 %)
   drop if Cor == 9
  
   gen PretoPardoIndig = 0
   replace PretoPardoIndig = 1 if (Cor==2 | Cor==4 | Cor== 5)
   label var PretoPardoIndig "Preto, Parto ou Indigena"
   
 save "$dirdata/D_BaseEstimacao.dta", replace   
 } 


* D.1: REGRESSÕES (RETORNOS EDUC E EXPER) + SALÁRIOS PREDITOS *****************
{
 use "$dirdata/D_BaseEstimacao.dta", clear
 
 ** ESTIMAÇÃO
 {
 * Regressões com peso da PNAD. Inclusão sequencial de controles (i a iv)
 
 forvalues t = 1/`=Tmax' {     
 * (i) Sem controles: 
  * Efetivo:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Efetivo_i", append
	predict RegLog_Ei_`t' if (T>=(`t'-1) & T<=(`t'+1)) 
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Habitual_i", append
	predict RegLog_Hi_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	
	
 * (ii) Cor: 
  * Efetivo:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Efetivo_ii", append
	gen RegLog_Eii_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1))	 
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Habitual_ii", append
	gen RegLog_Hii_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	
	 
 * (iii) Setor público: 
  * Efetivo:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Efetivo_iii", append
	gen RegLog_Eiii_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1))	 
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Habitual_iii", append
	gen RegLog_Hiii_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	  
	  
 * (iv) Setor informal: 
  * Efetivo:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Efetivo_iv", append
	gen RegLog_Eiv_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1))	 
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/D_Regressões_Habitual_iv", append
	gen RegLog_Hiv_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	  
  estimates drop _all
  }

  save "$dirdata/D_BaseEstimacao.dta", replace  
  } 


 ** SALÁRIOS PREDITOS
 {
  * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * (i) Sem controles
	  gen RegW_Ei_`t' = exp(RegLog_Ei_`t')	  
	  gen RegW_Hi_`t' = exp(RegLog_Hi_`t')	  
	  
   * (ii) Cor 
	  gen RegW_Eii_`t' = exp(RegLog_Eii_`t')	  
	  gen RegW_Hii_`t' = exp(RegLog_Hii_`t')	  
	  
   * (iii) Setor público 
	  gen RegW_Eiii_`t' = exp(RegLog_Eiii_`t')
	  gen RegW_Hiii_`t' = exp(RegLog_Hiii_`t')
	 
   * (iv) Informal
	  gen RegW_Eiv_`t' = exp(RegLog_Eiv_`t')	 
	  gen RegW_Hiv_`t' = exp(RegLog_Hiv_`t')	
	 
	 drop RegLog_Ei_`t' RegLog_Eii_`t' RegLog_Eiii_`t' RegLog_Eiv_`t' RegLog_Hi_`t' RegLog_Hii_`t' RegLog_Hiii_`t' RegLog_Hiv_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
* (i) Sem controles:  
   gen WEi_T = .
   gen WEi_Tante = .
   gen WEi_Tprox = .
   
   gen WHi_T = .
   gen WHi_Tante = .
   gen WHi_Tprox = .
   
* (ii) Cor:
   gen WEii_T = .
   gen WEii_Tante = .
   gen WEii_Tprox = .
   
   gen WHii_T = .
   gen WHii_Tante = .
   gen WHii_Tprox = .
   
* (iii) Setor publico: 
   gen WEiii_T = .
   gen WEiii_Tante = .
   gen WEiii_Tprox = .
   
   gen WHiii_T = .
   gen WHiii_Tante = .
   gen WHiii_Tprox = .
   
* (iv) Informal
   gen WEiv_T = .
   gen WEiv_Tante = .
   gen WEiv_Tprox = .
   
   gen WHiv_T = .
   gen WHiv_Tante = .
   gen WHiv_Tprox = .
   
   
   forvalues t = 1/`=Tmax' {
      replace WEi_T = RegW_Ei_`t' if T==`t'
	  replace WHi_T = RegW_Hi_`t' if T==`t'
	  
	  replace WEii_T = RegW_Eii_`t' if T==`t'
	  replace WHii_T = RegW_Hii_`t' if T==`t'
	  
	  replace WEiii_T = RegW_Eiii_`t' if T==`t'
	  replace WHiii_T = RegW_Hiii_`t' if T==`t'
	  
      replace WEiv_T = RegW_Eiv_`t' if T==`t'
	  replace WHiv_T = RegW_Hiv_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace WEi_Tante = RegW_Ei_`i' if T==`t'
	  if `t' > 1 replace WHi_Tante = RegW_Hi_`i' if T==`t'
	  
	  if `t' > 1 replace WEii_Tante = RegW_Eii_`i' if T==`t'
	  if `t' > 1 replace WHii_Tante = RegW_Hii_`i' if T==`t'
	  
	  if `t' > 1 replace WEiii_Tante = RegW_Eiii_`i' if T==`t'
	  if `t' > 1 replace WHiii_Tante = RegW_Hiii_`i' if T==`t'	  
	  
	  if `t' > 1 replace WEiv_Tante = RegW_Eiv_`i' if T==`t'
	  if `t' > 1 replace WHiv_Tante = RegW_Hiv_`i' if T==`t'	 
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WEi_Tprox = RegW_Ei_`j' if T==`t'
	  if `t' < `=Tmax' replace WHi_Tprox = RegW_Hi_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WEii_Tprox = RegW_Eii_`j' if T==`t'
	  if `t' < `=Tmax' replace WHii_Tprox = RegW_Hii_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WEiii_Tprox = RegW_Eiii_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiii_Tprox = RegW_Hiii_`j' if T==`t'	  
	  
	  if `t' < `=Tmax' replace WEiv_Tprox = RegW_Eiv_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiv_Tprox = RegW_Hiv_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_Ei_`t' RegW_Hi_`t' RegW_Eii_`t' RegW_Hii_`t' RegW_Eiii_`t' RegW_Hiii_`t' RegW_Eiv_`t' RegW_Hiv_`t' 
   }  
 
   save "$dirdata/D_BaseEstimacao.dta", replace
  }

} 
 

* D.2: PESOS ******************************************************************
{
 use "$dirdata/D_BaseEstimacao.dta", clear

 * EFETIVO:
   bysort T VD3006 Experiencia: egen HE = mean(VD4035)
   order HE, after(VD4035)
   label var HE "Horas efetivas médias por grupo de educação e experiência para cada trimestre"

  * Peso ajustado por hora:
   gen PEi = Peso*HE
   bysort T: egen PEt = sum(PEi)
   gen PE = PEi/PEt
   label var PE "Peso para cálculo do IQT de rendimento efetivo"
   
   order PE, after(Peso) 
   drop PEi PEt
   
   
 * HABITUAL:
   bysort T VD3006 Experiencia: egen HH = mean(VD4031)
   order HH, after(VD4031)
   label var HH "Horas habituais médias por grupo de educação e experiência para cada trimestre"

  * Peso ajustado por hora:
   gen PHi = Peso*HH
   bysort T: egen PHt = sum(PHi)
   gen PH = PHi/PHt
   label var PH "Peso para cálculo do IQT de rendimento habitual"
   
   order PH, after(PE) 
   drop PHi PHt

 save "$dirdata/D_BaseEstimacao.dta", replace
} 
 
 
* D.3: IQT ********************************************************************
{
 * IQT0
  * Efetivo:
   gen dIQT0_Ei = .        
   gen dIQT0_Eii = .        
   gen dIQT0_Eiii = .        
   gen dIQT0_Eiv = .          
   
  * Habitual: 
   gen dIQT0_Hi = .        
   gen dIQT0_Hii = .        
   gen dIQT0_Hiii = .        
   gen dIQT0_Hiv = .    


   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
	  gen nEi = PE*WEi_Tante if T==`t'
	  gen dEi = PE*WEi_T if T==(`t'-1)
	  gen nHi = PH*WHi_Tante if T==`t'
	  gen dHi = PH*WHi_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_Ei = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_Hi = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = PE*WEii_Tante if T==`t'
	  gen dEii = PE*WEii_T if T==(`t'-1)
	  gen nHii = PH*WHii_Tante if T==`t'
	  gen dHii = PH*WHii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT0_Eii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT0_Hii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = PE*WEiii_Tante if T==`t'
	  gen dEiii = PE*WEiii_T if T==(`t'-1)
	  gen nHiii = PH*WHiii_Tante if T==`t'
	  gen dHiii = PH*WHiii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT0_Eiii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT0_Hiii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = PE*WEiv_Tante if T==`t'
	  gen dEiv = PE*WEiv_T if T==(`t'-1)
	  gen nHiv = PH*WHiv_Tante if T==`t'
	  gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_Eiv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo C:
   gen dIQT1_Ei = .        
   gen dIQT1_Eii = .        
   gen dIQT1_Eiii = .        
   gen dIQT1_Eiv = .        
   
  * Habitual: 
   gen dIQT1_Hi = .        
   gen dIQT1_Hii = .        
   gen dIQT1_Hiii = .        
   gen dIQT1_Hiv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
	  gen nEi = PE*WEi_T if T==`t'
	  gen dEi = PE*WEi_Tprox if T==(`t'-1)
	  gen nHi = PH*WHi_T if T==`t'
	  gen dHi = PH*WHi_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_Ei = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_Hi = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = PE*WEii_T if T==`t'
	  gen dEii = PE*WEii_Tprox if T==(`t'-1)
	  gen nHii = PH*WHii_T if T==`t'
	  gen dHii = PH*WHii_Tprox if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT1_Eii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT1_Hii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = PE*WEiii_T if T==`t'
	  gen dEiii = PE*WEiii_Tprox if T==(`t'-1)
	  gen nHiii = PH*WHiii_T if T==`t'
	  gen dHiii = PH*WHiii_Tprox if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT1_Eiii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT1_Hiii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = PE*WEiv_T if T==`t'
	  gen dEiv = PE*WEiv_Tprox if T==(`t'-1)
	  gen nHiv = PH*WHiv_T if T==`t'
	  gen dHiv = PH*WHiv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_Eiv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_Ei = (dIQT0_Ei*dIQT1_Ei)^(1/2)
   gen dIQT_Hi = (dIQT0_Hi*dIQT1_Hi)^(1/2)
   
   gen dIQT_Eii = (dIQT0_Eii*dIQT1_Eii)^(1/2)
   gen dIQT_Hii = (dIQT0_Hii*dIQT1_Hii)^(1/2)
  
   gen dIQT_Eiii = (dIQT0_Eiii*dIQT1_Eiii)^(1/2)
   gen dIQT_Hiii = (dIQT0_Hiii*dIQT1_Hiii)^(1/2)  
  
   gen dIQT_Eiv = (dIQT0_Eiv*dIQT1_Eiv)^(1/2)
   gen dIQT_Hiv = (dIQT0_Hiv*dIQT1_Hiv)^(1/2)
   
 
 save "$dirdata/D_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQT_Ei dIQT_Eii dIQT_Eiii dIQT_Eiv dIQT_Hi dIQT_Hii dIQT_Hiii dIQT_Hiv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQT_Ei = 100 if T==2
     replace IQT_Ei = IQT_Ei[_n-1]*dIQT_Ei if _n > 2
     label var IQT_Ei "IQT Efetivo - Sem controles"

	 gen IQT_Hi = 100 if T==2
     replace IQT_Hi = IQT_Hi[_n-1]*dIQT_Hi if _n > 2
     label var IQT_Hi "IQT Habitual - Sem controles"
	 
	 
   * (ii) Cor
     gen IQT_Eii = 100 if T==2
     replace IQT_Eii = IQT_Eii[_n-1]*dIQT_Eii if _n > 2
     label var IQT_Eii "IQT Efetivo - Cor"
	 
	 gen IQT_Hii = 100 if T==2
     replace IQT_Hii = IQT_Hii[_n-1]*dIQT_Hii if _n > 2
     label var IQT_Hii "IQT Habitual - Cor"
   
   
   * (iii) Setor público
     gen IQT_Eiii = 100 if T==2
     replace IQT_Eiii = IQT_Eiii[_n-1]*dIQT_Eiii if _n > 2
     label var IQT_Eiii "IQT Efetivo - Setor público"
	 
	 gen IQT_Hiii = 100 if T==2
     replace IQT_Hiii = IQT_Hiii[_n-1]*dIQT_Hiii if _n > 2
     label var IQT_Hiii "IQT Habitual - Setor público" 
	 
	 
   * (iv) Informal
     gen IQT_Eiv = 100 if T==2
     replace IQT_Eiv = IQT_Eiv[_n-1]*dIQT_Eiv if _n > 2
     label var IQT_Eiv "IQT Efetivo - Informal"
	 
	 gen IQT_Hiv = 100 if T==2
     replace IQT_Hiv = IQT_Hiv[_n-1]*dIQT_Hiv if _n > 2
     label var IQT_Hiv "IQT Habitual - Informal" 
   
   save "$dirdata/D_IQT.dta", replace
   export excel T IQT_Ei IQT_Eii IQT_Eiii IQT_Eiv IQT_Hi IQT_Hii IQT_Hiii IQT_Hiv using "$dirdata\D_IQT.xlsx", firstrow(varlabels) replace

   restore
   }  
  
} 
 
}


*******************************************************************************
* E. RETORNOS EDUCAÇÃO: TABELAS E BASE DTA
*******************************************************************************
{
 use "$dirdata/D_BaseEstimacao.dta", clear
 
* E.1. EXPORTANDO TABELAS *****************************************************
{ 
 forvalues t = 1/`=Tmax' {     
 * (i) Sem controles: 
  * Efetivo:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Efetivo_`t'", replace ctitle("Sem controles") word tex(pretty) label
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Habitual_`t'", replace ctitle("Sem controles") word tex(pretty) label
	
	
 * (ii) Cor: 
  * Efetivo:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Efetivo_`t'", append ctitle("Cor") word tex(pretty) label
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Habitual_`t'", append ctitle("Cor") word tex(pretty) label

	 
 * (iii) Setor público: 
  * Efetivo:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Efetivo_`t'", append ctitle("Setor Publico") word tex(pretty) label
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Habitual_`t'", append ctitle("Setor Publico") word tex(pretty) label
		 
	  	  
 * (iv) Setor informal: 
  * Efetivo:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Efetivo_`t'", append ctitle("Informal") word tex(pretty) label
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	outreg2 using "$dirdata/E_Tabelas/Habitual_`t'", append ctitle("Informal") word tex(pretty) label
	 
 estimates drop _all 
 }
}

 
* E.2. SALVANDO COEFICIENTES: BASE DTA ****************************************
{
 ** Efetivo:
 { 
    statsby, by(T) saving("$dirdata/E_Coeficientes_Efetivo_i.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
	estimates drop _all
    
	statsby, by(T) saving("$dirdata/E_Coeficientes_Efetivo_ii.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig
	estimates drop _all
	
	statsby, by(T) saving("$dirdata/E_Coeficientes_Efetivo_iii.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico
    estimates drop _all
	
    statsby, by(T) saving("$dirdata/E_Coeficientes_Efetivo_iv.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal 
    estimates drop _all	
 }	
   
   
 ** Habitual:
 {
    statsby, by(T) saving("$dirdata/E_Coeficientes_Habitual_i.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
	estimates drop _all	
	
    statsby, by(T) saving("$dirdata/E_Coeficientes_Habitual_ii.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig
	estimates drop _all	
	
    statsby, by(T) saving("$dirdata/E_Coeficientes_Habitual_iii.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico  
	estimates drop _all	
	
    statsby, by(T) saving("$dirdata/E_Coeficientes_Habitual_iv.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal 
    estimates drop _all
 } 	
	
 ** CONSOLIDANDO BASE ÚNICA:
 {
  * Efetivo:
  {
    * Vamos fazer na ordem (iv)-(i) para que a base final fique ordenada (i)-(iv).
	* (iv)
    use "$dirdata/E_Coeficientes_Efetivo_iv.dta", clear
	
	* Renomeando variáveis e labels para diferenciar entre estratégias de controles:
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Informal"
	  rename `x' iv_`nome'
    }	
	save "$dirdata/E_Coeficientes_Efetivo", replace   
	
	
	* (iii)
	use "$dirdata/E_Coeficientes_Efetivo_iii.dta", clear 
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Setor publico"
	  rename `x' iii_`nome'
    }
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Efetivo"
	drop _merge
	save "$dirdata/E_Coeficientes_Efetivo", replace		
	
	
	* (ii)
	use "$dirdata/E_Coeficientes_Efetivo_ii.dta", clear 
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Cor"
	  rename `x' ii_`nome'
    }
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Efetivo"
	drop _merge
	save "$dirdata/E_Coeficientes_Efetivo", replace	
	
	
	* (i)
	use "$dirdata/E_Coeficientes_Efetivo_i.dta", clear
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Sem controles"
	  rename `x' i_`nome'
    }	
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Efetivo"
	drop _merge
	save "$dirdata/E_Coeficientes_Efetivo", replace
  } 
 
  * Habitual:
  {
    * Vamos fazer na ordem (iv)-(i) para que a base final fique ordenada (i)-(iv).
	* (iv)
    use "$dirdata/E_Coeficientes_Habitual_iv.dta", clear
	
	* Renomeando variáveis e labels para diferenciar entre estratégias de controles:
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Informal"
	  rename `x' iv_`nome'
    }	
	save "$dirdata/E_Coeficientes_Habitual", replace   
	
	
	* (iii)
	use "$dirdata/E_Coeficientes_Habitual_iii.dta", clear 
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Setor publico"
	  rename `x' iii_`nome'
    }
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Habitual"
	drop _merge
	save "$dirdata/E_Coeficientes_Habitual", replace		
	
	
	* (ii)
	use "$dirdata/E_Coeficientes_Habitual_ii.dta", clear 
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Cor"
	  rename `x' ii_`nome'
    }
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Habitual"
	drop _merge
	save "$dirdata/E_Coeficientes_Habitual", replace	
	
	
	* (i)
	use "$dirdata/E_Coeficientes_Habitual_i.dta", clear
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Sem controles"
	  rename `x' i_`nome'
    }	
	
	merge 1:1 T using "$dirdata/E_Coeficientes_Habitual"
	drop _merge
	save "$dirdata/E_Coeficientes_Habitual", replace
  } 
 
 }	
} 
}


*******************************************************************************
* F. GRÁFICOS
*******************************************************************************
{
 use "$dirdata/D_IQT.dta", clear

* F.1. POR CONTROLE ***********************************************************
{
** (i) Sem controles:
   twoway (line IQT_Hi T) (line IQT_Ei T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTi, replace) 
   *graph export "$dirpath/Gráficos/IQTi.png", width(10000) as(png) replace

** (ii) Cor:
   twoway (line IQT_Hii T) (line IQT_Eii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTii, replace) 
   *graph export "$dirpath/Gráficos/IQTii.png", width(10000) as(png) replace
  
** (iii) Setor público:
   twoway (line IQT_Hiii T) (line IQT_Eiii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTiii, replace) 
   *graph export "$dirpath/Gráficos/IQTiii.png", width(10000) as(png) replace
  
** (iv) Informal:
   twoway (line IQT_Hiv T) (line IQT_Eiv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTiv, replace) 
   *graph export "$dirpath/Gráficos/IQTiv.png", width(10000) as(png) replace
}
 
 
* F.2. COMPARANDO CONTROLES ***************************************************
{
** Efetivo:
   twoway (line IQT_Ei T) (line IQT_Eii T) (line IQT_Eiii T) (line IQT_Eiv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTEfetivo, replace) 
   *graph export "$dirpath/Gráficos/IQTEfetivo.png", width(10000) as(png) replace
   

** Habitual:
   twoway (line IQT_Hi T) (line IQT_Hii T) (line IQT_Hiii T) (line IQT_Hiv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTHabitual, replace) 
   *graph export "$dirpath/Gráficos/IQTHabitual.png", width(10000) as(png) replace   
}
}  

log close