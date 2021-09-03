<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Tarea = Parametro("Tarea", -1)
	var Prom_ID = Parametro("Prom_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var Prom_Articulo_Pro_ID = Parametro("Promo_Pro_ID", -1)
	var Prom_Obsequio_Pro_ID = Parametro("Regalo_Pro_ID", -1)
	var Prom_Cantidad = Parametro("Prom_Cantidad", -1)
	var IDUsuario = Parametro("IDUsuario", -1)
	
	var result = -1
	var message = ""
	var sResultado = ""


switch(parseInt(Tarea)){

	case 1: 
			 var sSQL = " INSERT INTO Cliente_PromocionArticulo(Cli_ID, Prom_ID, Prom_Articulo_Pro_ID, Prom_Obsequio_Pro_ID, Prom_Cantidad,Prom_Usuario)"+
						" VALUES (" + Cli_ID + "," + Prom_ID + "," + Prom_Articulo_Pro_ID + ", " + Prom_Obsequio_Pro_ID + "," + Prom_Cantidad + ","+IDUsuario+")"
							
			//Response.Write(sSQL)		
			if(Ejecuta(sSQL,0)){
				result = 1
				message = "El registro se ha guardado correctamente"
			}else{
				result = -1
				message = "Error al insertar en la base de datos"
			}
			
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
			
	 break;
	 case 2: 
	 	sResultado = CargaCombo("Regalo_Pro_ID","class='form-control combman'","Pro_ID","Pro_SKU + ' - '+Pro_Nombre","Producto","Cli_ID = "+ Cli_ID,"Pro_ID","Edita",0,"Selecciona")	 
	 break;
	
}
	Response.Write(sResultado)

%>