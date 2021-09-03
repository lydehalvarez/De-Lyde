
<%
var RutaExtra = ""
var RaizSitio = Request.ServerVariables("APPL_PHYSICAL_PATH")
//------------------------
var DCFiscal = "RFC" // "NIT" 
var FM = "$"
var TipoMoneda = "Pesos"
var Impuesto = .16
var EsteArchivo = Request.ServerVariables("PATH_INFO")

//*******Tipo de Ventanas *******

var DiasDeMes = new Array(0)
	DiasDeMes = [31,0,31,30,31,30,31,31,30,31,30,31]

var NombreDeMes = new Array 
	NombreDeMes = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]





%> 
