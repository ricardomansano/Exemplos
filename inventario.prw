#include "TOTVS.CH"

// Defines do componente TLinearLayout
#define LAY_L2R 0 // LEFT TO RIGHT
#define LAY_R2L 1 // RIGHT TO LEFT
#define LAY_T2B 2 // TOP TO BOTTOM
#define LAY_B2T 3 // BOTTOM TO TOP
// Alinhamentos usado no metodo AddinLayout
#define ALIGN_LEFT     1
#define ALIGN_RIGHT    2
#define ALIGN_HCENTER  4
#define ALIGN_TOP      32
#define ALIGN_BOTTOM   64
#define ALIGN_VCENTER  128

// --------------------------------------------------------------------------------------------------------
// POC - INVENTARIO 
// --------------------------------------------------------------------------------------------------------
function u_inventario()
local color1 	:= "#009DC0" // Cor padrao Totvs
private cTable 	:= "PRODUTO"
private cIndex	:= "PRODUTO1"
private cDriver	:= "SQLITE_SYS"

openDatabase()

oWnd:= TWindow():New(0, 0, 500, 400, "Inventario", NIL, NIL, NIL, NIL, NIL, NIL, NIL,;
	CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

	// Componente faz acesso ao dispositivo movel
	// http://tdn.totvs.com/display/tec/TMobile
	private oMbl := TMobile():New(oWnd) 

	// Cria titulo
	// http://tdn.totvs.com/display/tec/TLinearLayout
	oHeaderLyt := tLinearLayout():New(oWnd, LAY_L2R, CONTROL_ALIGN_TOP, 0, 60)
	// http://tdn.totvs.com/display/tec/SetCSS
	oHeaderLyt:SetCSS("QFrame{ background-color: " +color1+ "; margin: 5px; }")
	oFont := TFont():New('Lucida Sans',,16,.T.)
	oHeaderSay := TSay():New(0,0,{||"<H1>INVENTARIO</H1>"},oHeaderLyt,,oFont,,,,.T.,CLR_WHITE,,0,0,,,,,,.T.)
	oHeaderLyt:addInLayout(oHeaderSay, ALIGN_VCENTER)
	
	// Cria frame central
	oBodyLyt := tLinearLayout():New(oWnd, LAY_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	// Cria o menu lateral
	oMenuPnl := tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oMenuLyt := tLinearLayout():New(oMenuPnl, LAY_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oMenuLyt:SetCSS("QFrame{ margin: 15px; } TButton{ background-color: " +color1+ "; color: #ffffff; text-align: left; margin-bottom: 7px; font-size: 34px; }" )
	oTButton1 := TButton():New( 0, 0, "Gera ENV", oMenuLyt,{|| geraEnv() }, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 0, 0, "BarCode" , oMenuLyt,{|| barCode() }, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3 := TButton():New( 0, 0, "Bipados" , oMenuLyt,{|| bipados() }, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton4 := TButton():New( 0, 0, "Zera" 	, oMenuLyt,{|| zera() }, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton5 := TButton():New( 0, 0, "Fechar"  , oMenuLyt,{|| __Quit()  }, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oMenuLyt:addInLayout(oTButton1)
	oMenuLyt:addInLayout(oTButton2)
	oMenuLyt:addInLayout(oTButton3)
	oMenuLyt:addInLayout(oTButton4)
	oMenuLyt:AddSpacer(5)
	oMenuLyt:addInLayout(oTButton5)
	oBodyLyt:addInLayout(oMenuPnl,,25)

	// Cria texto central
	oCenterPnl := tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oCenterLyt := tLinearLayout():New(oCenterPnl, LAY_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oCenterLyt:SetCSS("QFrame{ margin: 15px; background-color: #99D9EA}")
	cCenterTxt := "<h1>CONTEUDO</h1><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus pharetra turpis a tempor tempus. Vivamus sit amet eleifend ante, quis suscipit nulla. Morbi sollicitudin eleifend dapibus. Integer congue sapien quis augue dignissim sodales. Sed a sapien justo. Ut sodales nulla sed lacus sollicitudin, a dignissim magna convallis. Maecenas facilisis purus id aliquam tempus. Quisque tempus magna quis nunc ultrices, sit amet luctus ante facilisis."
	oCenterSay := TSay():New(0,0,{|| cCenterTxt },oCenterLyt,,oFont,,,,.T.,,,0,0,,,,,,.T.)
	oCenterLyt:addInLayout(oCenterSay)
	oBodyLyt:addInLayout(oCenterPnl,,50)

	// Cria o rodape
	oBottomLyt := tLinearLayout():New(oWnd, LAY_L2R, CONTROL_ALIGN_BOTTOM, 0, 40)
	oBottomLyt:SetCSS("QFrame{ background-color: " +color1+ "; color: #ffffff; margin: 5px; }")
	private oBottomSay := TSay():New(0,0,{||""},oBottomLyt,,oFont,,,,.T.,,,0,0,,,,,,.T.)
	oBottomSay:SetCss("TSay{ qproperty-alignment: AlignCenter; }")
	oBottomLyt:addInLayout(oBottomSay)

oWnd:Activate("MAXIMIZED")

closeDatabase()
return

// --------------------------------------------------------------------------------------------------------
// ABRE CONEXAO COM SQLITE
// --------------------------------------------------------------------------------------------------------
static function openDatabase()
	TCLink()
	DBUseArea(.F., cDriver, cTable, (cTable), .F., .F.)

	// Verifica existencia da tabela e indice
	if !TCCanOpen(cTable, cIndex)
		msgStop("Tabela e indice nao existe, favor gerar ambiente")
		return
	endif
	
	DbSetOrder(1) // BARCODE
return

// --------------------------------------------------------------------------------------------------------
// FECHA CONEXAO COM SQLITE
// --------------------------------------------------------------------------------------------------------
static function closeDatabase()
	DBCloseArea()
	TCUnlink()
return

// --------------------------------------------------------------------------------------------------------
// ZERA CONTAGEM
// --------------------------------------------------------------------------------------------------------
static function zera()
	TCSQLExec("BEGIN")
	TCSQLExec("UPDATE " +cTable+ " SET BIPS=0;" )
	TCSQLExec("COMMIT")
	msgAlert("Conferencia zerada")
return

// --------------------------------------------------------------------------------------------------------
// LE CODIGO DE BARRAS
// --------------------------------------------------------------------------------------------------------
static function barcode()
Local cBarCode, aBarResult, cMsg
Local finishScanner := .T.

	while finishScanner
	
		// Captura codigo de barra
		aBarResult:= oMbl:BarCode()
		cBarCode := aBarResult[1]
		
		// Acionando o botao "voltar" no dispositivo Android o barCode retornara vazio, saindo do loop
		if empty(cBarCode) 
			finishScanner := .F.
		elseif cBarCode == "Not Supported"
			finishScanner := .F.
			oBottomSay:setText("[" +cBarCode+ "]")
		else 
			if (cTable)->(DbSeek(cBarCode))
				cMsg := "[Localizado: " +cBarCode+ ": " +AllTrim((cTable)->DESCR)+ "]"
				
				// Incrementa conferencia
				(cTable)->( DBRLock() )
				(cTable)->BIPS 	+= 1
				(cTable)->( DBRUnlock() )
			else
				cMsg := "[NAO Localizado: " +cBarCode+ "]"
			endif
			
			oBottomSay:setText(cMsg) // Mostra ultimo na tela
			conout(cMsg) // Mostra todos no console
			
		endif		
	end
Return

// --------------------------------------------------------------------------------------------------------
// EXIBE LISTA DOS PRODUTOS CONFERIDOS
// --------------------------------------------------------------------------------------------------------
static function bipados()
local cTRB := 'TRB'

	cQuery := "SELECT * FROM " +cTable+ " WHERE BIPS > 0"
	dbUseArea(.T., cDriver, TCGenQry(,,cQuery),cTRB, .F., .T.)

	oBottomSay:setText("Total de itens bipados: " + cValTochar( TRB->(recCount()) ) + ", favor ver o console")

	conout("", "CONFERENCIA", "------------", "")
	while !(cTRB)->(eof())
		conout((cTRB)->BARCODE)
		conout((cTRB)->DESCR)
		conout((cTRB)->BIPS, "")
	(cTRB)->(DbSkip())
	end
	(cTRB)->(dbCloseArea())
return

// --------------------------------------------------------------------------------------------------------
// GERA LISTA DE PRODUTOS
// --------------------------------------------------------------------------------------------------------
static function geraEnv()
Local n, cBarCode, cDescr

	TCDelFile(cTable) // Deleta tabela anterior
	
	// Cria tabela e indice
	DBCreate(cTable, ;
	{;
		{"BARCODE", "C", 20, 0},;
		{"DESCR"  , "C", 40, 0},;
		{"BIPS"   , "N", 10, 0};
	}, cDriver)
	DBCreateIndex(cIndex, 'BARCODE', { || 'BARCODE' }) 
	
	// Reabre Database 	
	closeDatabase()
	openDatabase()
	
	for n := 1 to 20000

		// Forca um codigo de barras
		cBarCode := strZero(n, 13)
		cDescr	 := "PRODUTO " + cValToChar(cBarCode)
		if n == 10000
			cBarCode := "7891000006290"
			cDescr	 := "CAFE COM LEITE"
		endif

		(cTable)->( DBAppend( .F. ) )
		(cTable)->BARCODE 	:= cBarCode
		(cTable)->DESCR 	:= cDescr
		(cTable)->( DBCommit() )

		// Reduz refresh a cada 500 itens
		if mod(n, 500) == 0
			cMsg := "["+cValToChar(n)+"] " + (cTable)->DESCR
			conout(cMsg)
			oBottomSay:setText(cMsg)
			oBottomSay:refresh()
			processMessages()
			sleep(200)
		endif
		
	next

	DbSetOrder(1) // BARCODE

	// Informa qtd de registros inseridos
	cMsg := cValTochar("Ambiente gerado: " + cValToChar( (cTable)->(fCount())) ) +;
						" campos e " + cValTochar((cTable)->(recCount())) + " registros"
	oBottomSay:setText(cMsg)
return
