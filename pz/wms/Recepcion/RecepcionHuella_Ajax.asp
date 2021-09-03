<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var Cli_ID =  Parametro("Cli_ID","-1")
	var Pro_ID =  Parametro("Pro_ID","-1")
	var Pro_Nombre = Parametro("Pro_Nombre","")
	var Pro_PesoBruto = Parametro("Pro_PesoBruto",-1)
	var Pro_PesoNeto = Parametro("Pro_PesoNeto", "")
	var Pro_DimAlto = Parametro("Pro_DimAlto", -1)
	var Pro_DimLargo =  utf8_decode(Parametro("Pro_DimLargo",""))
	var Pro_DimAncho =  utf8_decode(Parametro("Pro_DimAncho",""))
	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
			
		case 1:	
		var Pro_ID = -1
		if(Pro_ID == -1){
				try {
	
		Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto","",-1,0)
	
				var sSQL = " INSERT INTO Producto (Pro_ID,Pro_Nombre, Pro_Descripcion, Pro_PesoBruto, "
				sSQL += "  Pro_PesoNeto,Pro_DimAlto,Pro_DimLargo,Pro_DimAncho) "
				sSQL += " VALUES (" +Pro_ID +",'" +Pro_Nombre+"','" +Pro_Nombre+" "+Pro_PesoBruto+"',"
				sSQL += " " +Pro_PesoNeto+", "+Pro_DimAlto+","+Pro_DimLargo+","+Pro_DimAncho+")"
						
	
						Ejecuta(sSQL, 0)
		        Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto_Cliente","",-1,0)
				sSQL = " INSERT INTO Producto_Cliente (Pro_ID, Cli_ID,ProC_Nombre, ProC_Descripcion) "
				sSQL += " VALUES (" +Pro_ID +",'"+Cli_ID+"," +Pro_Nombre+"','" +Pro_Nombre+", "+Pro_PesoBruto+","
				sSQL += " " +Pro_PesoNeto+", "+Pro_DimAlto+","+Pro_DimLargo+","+Pro_DimAncho+")"
						
	
						Ejecuta(sSQL, 0)
						sResultado = 1
						
				} catch (err) {
					sResultado = -1
				}
			}
		break;   
		case 2:	
			
				%>
            
                     <table class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Unidad</th>
                                    <th>Cantidad</th>
                                    <th>Alto</th>
                                     <th>Largo</th>
                                    <th>Ancho</th>
                                    <th>Peso Bruto</th>
                                     <th>Peso Neto</th>
                             
                                </tr>
                            </thead>
                            <tbody>
                <%
				var sSQL = "SELECT p.Pro_ID, p.Pro_Nombre, r.Pro_Cantidad, p.Pro_DimAlto, p.Pro_DimLargo, p.Pro_DimAncho, p.Pro_PesoBruto,  "
				sSQL += "p.Pro_PesoNeto FROM  Producto_Relacion AS r  INNER JOIN Producto AS p ON p.Pro_ID = r.Pro_ProdRelacionado"
				sSQL += " WHERE r.Pro_ID =  " +Pro_ID
				
                    var rsHue = AbreTabla(sSQL,1,0)
    
	                    while (!rsHue.EOF){
						var Pro_ID = rsHue.Fields.Item("Pro_ID").Value 
						var Pro_Nombre = rsHue.Fields.Item("Pro_Nombre").Value 
                        var Pro_Cantidad = rsHue.Fields.Item("Pro_Cantidad").Value 
                        var Pro_DimAlto = rsHue.Fields.Item("Pro_DimAlto").Value 
                        var Pro_DimLargo = rsHue.Fields.Item("Pro_DimLargo").Value 
						var Pro_DimAncho = rsHue.Fields.Item("Pro_DimAncho").Value 
                        var Pro_PesoBruto = rsHue.Fields.Item("Pro_PesoBruto").Value 
                        var Pro_PesoNeto = rsHue.Fields.Item("Pro_PesoNeto").Value 
								                              
                %> 
                            <tr>
                                <td><%=Pro_Nombre%></td>
                                <td><%=Pro_Cantidad%></td>
                                <td><%=Pro_DimAlto%></td>
                                  <td><%=Pro_DimLargo%></td>
                                <td><%=Pro_DimAncho%></td>
                                <td><%=Pro_PesoBruto%></td>
                                <td><%=Pro_PesoNeto%></td>
                            </tr>
				<%	
						rsHue.MoveNext() 
					}
                rsHue.Close()   
                %>

                            
                            </tbody>
                        </table>
                        
                 
			<%
		break; 
		//DELETE Cita
		case 4:	
			if(IR_ID > -1){
				try {
	
					var sSQL = " DELETE FROM Inventario_Recepcion "
						sSQL +=" WHERE IR_ID = "+ IR_ID
	
						Ejecuta(sSQL, 0)
						
						sResultado = 1
						
				} catch (err) {
					sResultado = -1
				}
			}
		break;  
		case 5:	
		var Alm_ID = Parametro("Alm_ID",-1)
		if(Alm_ID > -1){
				%>
               <label class="control-label col-md-3"><strong>Puerta asignada</strong></label>
                <div class="col-md-3">
                    <%CargaCombo("IR_Puerta"," class='form-control agenda'","AlmP_ID","AlmP_Nombre","Almacen_Posicion","Alm_TipoCG88 = 5 AND Alm_ID = "+Alm_ID,"AlmP_Nombre",-1,0,"Selecciona","Editar")%>
                </div>
				<%
		}
		break; 
		 
  
	}
Response.Write(sResultado)
%>
