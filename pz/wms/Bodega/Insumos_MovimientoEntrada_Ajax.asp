<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var ProM_Cantidad = Parametro("ProM_Cantidad",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var IDUsuario = Parametro("IDUsuario", "")
	var Movimiento = Parametro("Movimiento", "")
	var ProM_ID = Parametro("ProM_ID",-1)
	var ProM_ID_Nvo = Parametro("ProM_ID_Nvo",-1)
	var Bod_ID = Parametro("Bod_ID",-1)

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
//		    sSQL = "DELETE FROM Producto_Movimiento WHERE ProM_ID = " + ProM_ID 
//			  Ejecuta(sSQL,0)
			 sSQL = "DELETE FROM Producto_Movimiento_Rollos WHERE ProM_ID = " + ProM_ID
			  Ejecuta(sSQL,0)
			 sSQL = "DELETE FROM Producto_Movimiento_Series WHERE ProM_ID = " + ProM_ID
			  Ejecuta(sSQL,0)
	break;
		
		case 4:
		  sSQL = "SELECT count(*) AS series FROM Producto_Movimiento_Series WHERE ProM_ID = " + ProM_ID
			var rsEtiq = AbreTabla(sSQL,1,0)
		  sSQL = "DELETE FROM Producto_Movimiento WHERE ProM_ID = " + ProM_ID 
		  Ejecuta(sSQL,0)
  		 sSQL = "UPDATE Producto_Movimiento SET ProM_Cantidad = ProM_Cantidad + "+rsEtiq.Fields.Item("series").Value+"  WHERE ProM_ID = " + ProM_ID_Nvo
		  Ejecuta(sSQL,0)
		 sSQL = "UPDATE Producto_Movimiento_Rollos SET ProM_ID = "+ProM_ID_Nvo+"  WHERE ProM_ID = " + ProM_ID
		  Ejecuta(sSQL,0)
		 sSQL = "UPDATE Producto_Movimiento_Series SET ProM_ID = "+ProM_ID_Nvo+" WHERE ProM_ID = " + ProM_ID
		  Ejecuta(sSQL,0)

		break;
		
		case 5:
		%>
<select id="cboProducto" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
		<%
				
			var sSQL = "SELECT b.Pro_ID, Pro_Nombre FROM Producto p"
							+" INNER JOIN Bodega_Producto b ON b.Pro_ID = p.Pro_ID"
							+" WHERE Bod_ID=" + Bod_ID
			Response.Write(sSQL)
			rsArt = AbreTabla(sSQL,1,0)
			while (!rsArt.EOF){
				var Pro_ID =  rsArt.Fields.Item("Pro_ID").Value 
				Pro_Nombre =  rsArt.Fields.Item("Pro_Nombre").Value 
			%>
                  <option value="<%=Pro_ID%>" ><%=Pro_Nombre%></option>
		  <%	
			 rsArt.MoveNext() 
				}
			rsArt.Close()   	
			%>
                    </select>
                    <%
		break;
	}

%>
