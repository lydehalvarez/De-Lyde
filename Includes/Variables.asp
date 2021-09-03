<%
// Cantidad de Registros por pantalla
var RegPorVentana = 15 

//variables del grid
var iPagina = 1
var iRegPorVentana = 15

//var sVarSQL = "SELECT * FROM ConfiguracionSistema"
//var rsSQL = AbreTabla(sVarSQL,1,0)
//	if (!rsSQL.EOF){
//		RegPorVentana = rsSQL.Fields.Item("ConS_NumeroRegistros").Value
//	
//	}
//	rsSQL.Close

	if (RegPorVentana < 1){
		RegPorVentana = 15
	} 

%> 