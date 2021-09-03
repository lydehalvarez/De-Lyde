<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var ProM_Cantidad = Parametro("ProM_Cantidad",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var IDUsuario = Parametro("IDUsuario", "")
	var Movimiento = Parametro("Movimiento", "")

	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
		 var sSQL = " INSERT INTO Producto_Movimiento (Pro_ID, Cli_ID, ProM_Cantidad, ProM_TipoCG170)  VALUES ("+Pro_ID+",6,"+ProM_Cantidad+","+Movimiento+")"

				Ejecuta(sSQL, 0)

		break;  
		case 2:	
			
			var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU"
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_ID = "+ Pro_ID
				
			var rsPro = AbreTabla(sSQL,1,0)
				%>
                <label class="control-label col-md-2" id= "Pt_SKU"><strong><%=rsPro.Fields.Item("Pro_SKU").Value%></strong></label>
 
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_Nombre").Value%>" id="Pt_Modelo"/>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_ID").Value%>" id="Pro_ID"/>

        <%
		break; 
	case 3:
		    sSQL = "DELETE FROM Producto_Movimiento WHERE ProM_ID = " + ProM_ID 
			  Ejecuta(sSQL,0)
			 sSQL = "DELETE FROM Producto_Movimiento_Series WHERE ProM_ID = " + ProM_ID
			  Ejecuta(sSQL,0)
	break;

	}

%>
