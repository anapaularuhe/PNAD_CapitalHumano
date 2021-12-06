******************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Ana Paula Nothen Ruhe
* Outubro/2021
******************************************************

* OBS: NECESSÁRIO INSTALAR PACOTE mdesc:
* search mdesc

* PREPARAÇÃO *****************************************
* Garantindo que não há variáveis prévias na memória:
clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
cd "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"


* Salvando log:
log using "Rotina_amostra.log", replace



* DADOS **********************************************
  use "$dirdata/PNADC2012_2021_limpa.dta", clear
  
/* Lista das variáveis:
	Ano        | Ano
	Trimestre  | Trimestre
	UF         | UF
	V1027      | Peso trimestral com correção de não entrevista SEM PÓS ESTRATIFICAÇÃO pela projeção de população
	V1028      | Peso trimestral com correção de não entrevista COM PÓS ESTRATIFICAÇÃO pela projeção de população  
	V1029      | Projeção da população
	
	V2007      | Sexo
	V2009      | Idade
	V2010      | Cor ou raça
	
	V3003      | Qual o curso que frequenta (Até 2o tri 2015)
	V3003A     | Qual o curso que frequenta (A partir do 3o tri de 2015)
	V3009      | Qual o curso mais elevado que frequentou anteriormente (Até 2o tri 2015)
	V3009A     | Qual o curso mais elevado que frequentou anteriormente (A partir do 3o tri de 2015)
		
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
 
 
 
* RESTRIÇÃO DA AMOSTRA *******************************
* Removendo observações com missing values em variáveis fundamentais ou em categorias não desejadas:
* 1. Análise preliminar: quantidade de missing values por variável
  mdesc VD4002 VD4019 VD4020 VD4031 VD4035 
   
  * Olhando apenas para as observações na força de trabalho (VD4001=1):   
    preserve
    drop if VD4001!=1
    mdesc VD4002 VD4019 VD4020 VD4031 VD4035
  
    ** Vemos que população fora da FT corresponde a maior parte dos missing values para as variáveis de trabalho, como esperado. 
    ** Desocupados têm missing values para rendimento e horas. Olhando apenas para população ocupada, então:
       keep if VD4002==1
       mdesc  VD4019 VD4020 VD4031 VD4035
    ** Isso soluciona o problema de missing values para horas, mas não para rendimentos. Vamos voltar nesse grupo depois.
    restore	 
  
  
* 2. Queremos entender quais observações são eliminadas ao restringir a amostra à população ocupada.
  * Definimos dummy para ocupação que atribua 0 também a quem está fora da FT:
    gen byte ocup=(VD4002==1)
    label var ocup "Condição na População Ocupada"
    label define ocup_label 0 "Não ocupado" 1 "Ocupado"
    label values ocup ocup_label

** Características:	
  * Ao longo do tempo:
    tab Ano [iw = Peso] if ocup==0
    ** Não parece que estamos "penalizando" algum ano de forma mais intensa do que os demais.
   
  * Participação por cor e gênero:
    tab Sexo ocup [iw = Peso], row
    tab Cor ocup [iw = Peso], row
   
  * Idade
    tab ocup, sum(Idade)
   
  * Participação por região:
    tab Regiao ocup [iw = Peso], row
   
  * Participação por grupo de escolaridade:
    tab VD3006 ocup [iw = Peso], row

   
* 3. Mantemos apenas a população ocupada 
  keep if VD4002 == 1
  drop ocup
  
* 4. Missing values para rendimento de todos os trabalhos (habitual e efetivo)
  * Definimos dummy que atribui 1 para quem não tem informação de rendimento:
    gen byte rendNA=(VD4019==.)
    label var rendNA "Missing Value para Rendimento"
    label define rend_label 0 "Observado" 1 "Missing Value"
    label values rendNA rend_label
	
  * Conferimos que as observações faltantes são as mesmas para os dois tipos de rendimento:
    count if (VD4020==. & rendNA==0)
    count if (VD4020!=. & rendNA==1)
	
	tab rendNA
	
** Características:
  * Ao longo do tempo:
    tab Ano [iw = Peso] if rendNA==1
   
  * Participação por cor e gênero:
    tab Sexo rendNA [iw = Peso], row
    tab Cor rendNA [iw = Peso], row
   
  * Idade
    tab rendNA, sum(Idade)
   
  * Participação por região:
    tab Regiao rendNA [iw = Peso], row
   
  * Participação por grupo de escolaridade:
    tab VD3006 rendNA [iw = Peso], row
  
  
** Eliminamos as observações faltantes: 
  drop if VD4019 ==.
  drop if VD4020 ==. 
  
  drop rendNA

  save "$dirdata/PNADC_amostra.dta", replace
  
  
* DEFLACIONAMENTO ************************************
*** Calculando rendimentos (de todos os trabalhos) deflacionados  
    gen VD4019_real = VD4019*Habitual
    gen VD4020_real = VD4020*Efetivo
	
	label var VD4019_real "Rendimento real habitual de todos os trabalhos"
	label var VD4020_real "Rendimento real efetivo de todos os trabalhos"
  
    order VD4019_real, after(VD4019)
    order VD4020_real, after(VD4020)
	
	save "$dirdata/PNADC_amostra.dta", replace

	
/* Conferindo se funcionou: plotando as variáveis (descomentar) - média não representativa da população, apenas para ver o padrão geral.
 * Rendimento Habitual: 
   egen VD4019_medio = mean(VD4019), by(Ano)
   egen VD4019_real_medio = mean(VD4019_real), by(Ano)
   
   line VD4019_medio VD4019_real_medio Ano
   
 * Rendimento Efetivo: 
   egen VD4020_medio = mean(VD4020), by(Ano)
   egen VD4020_real_medio = mean(VD4020_real), by(Ano)
  
   line VD4020_medio VD4020_real_medio Ano
*/

*** Calculando salário por hora:
    gen VD4019_real_hora = VD4019_real/(4*VD4031)
	gen VD4020_real_hora = VD4020_real/(4*VD4035)
	replace VD4020_real_hora = VD4020_real/4 if VD4035==0
	
	order VD4019_real_hora, after(VD4019_real)
    order VD4020_real_hora, after(VD4020_real)
	
	save "$dirdata/PNADC_amostra.dta", replace


* CALCULANDO LOG DOS SALÁRIOS ************************
  gen logW_Habitual = ln(VD4019_real_hora)
  gen logW_Efetivo = ln(VD4020_real_hora)
  gen logW_Efetivo_0 = 0
  replace logW_Efetivo_0 = ln(VD4020_real_hora) if VD4020_real_hora > 0
  
  label var logW_Habitual "Log do rendimento real habitual de todos os trabalhos por hora"
  label var logW_Efetivo "Log do rendimento real efetivo de todos os trabalhos por hora"
  label var logW_Efetivo_0 "Log do rendimento real efetivo de todos os trabalhos por hora sem missing values"
  
  
  *** ATENÇÃO: existem observações com rendimento efetivo = 0. logW_Efetivo = . para essas observações. 
  *** A variável logW_Efetivo_0 atribui valor 0 ao log do salário dessas observações.
  
  order logW_Habitual, after(VD4019_real_hora)
  order logW_Efetivo logW_Efetivo_0, after(VD4020_real_hora)
  
  save "$dirdata/PNADC_amostra.dta", replace
  
** Analisando:
 * Definimos dummy que atribui 1 para quem tem salário efetivo nulo:
    gen byte Wnulo=(VD4020_real==0)
    label var Wnulo "Salário Efetivo Nulo"
    label define Wnulo_label 0 "W > 0" 1 "W = 0"
    label values Wnulo Wnulo_label
	
	tab Wnulo
	
  * Ao longo do tempo:
    tab Ano [iw = Peso] if Wnulo==1
   
  * Participação por cor e gênero:
    tab Sexo Wnulo [iw = Peso], row
    tab Cor Wnulo [iw = Peso], row
   
  * Idade
    tab Wnulo, sum(Idade)
   
  * Participação por região:
    tab Regiao Wnulo [iw = Peso], row
   
  * Participação por grupo de escolaridade:
    tab VD3006 Wnulo [iw = Peso], row
	
	drop Wnulo
	
	
* AMOSTRA FINAL **************************************
  describe
  tab Ano Trimestre
  
  log close

  
