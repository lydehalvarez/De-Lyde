<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
	var Tarea = 1
	 
	var Pro_ID = Parametro("Pro_ID",-1)   
    var Pro_Cantidad = Parametro("Pro_Cantidad",-1)
    var Pro_ProdRelacionado = Parametro("Pro_ProdRelacionado",-1)

	


 	var sResultado = ""
   
	switch (parseInt(Tarea)) {

		//Insert Servicio_Folio
   		case 1:
		try {
   				var sCondSer = "Pro_ID = " + Pro_ID
   				var iExisteFol = BuscaSoloUnDato("COUNT(*)","Producto_Relacion ",sCondSer + " AND  Pro_ProdRelacionado ="+ Pro_ProdRelacionado +" AND Pro_Cantidad = "+Pro_Cantidad,-1,0)
 
				if(iExisteFol == 0) {
					
				
			   var sINS  = " INSERT INTO Producto_Relacion (Pro_ID, Pro_ProdRelacionado, Pro_Cantidad)"
						sINS += " VALUES ("+Pro_ID+","+Pro_ProdRelacionado+","+Pro_Cantidad+")"
  Response.Write("" + sINS)

						Ejecuta(sINS,0)

						sResultado = "Relacion registrada correctamente"		
					
				}
   
				// Existe el registro
				if(iExisteFol > 0) {
				
					var sDELETE  = " Delete FROM Producto_Relacion"
						sDELETE += " WHERE Pro_ID = " + Pro_ID + ""
						sDELETE += " , AND Pro_ProdRelacionado = " + Pro_ProdRelacionado + ""
											
						Ejecuta(sDELETE,0)

						sResultado = "Relacion eliminada correctamente"				
				
				}				
				
		} 
		catch(err) {
			sResultado = 0 + "|" + -1
		}		
   		break;
	
	
	}
	Response.Write(sResultado)
   
%>

