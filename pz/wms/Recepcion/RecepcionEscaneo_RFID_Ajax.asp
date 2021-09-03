       <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
  
<%
 	var Tarea = Parametro("Tarea", -1)
    var IDUsuario = Parametro("IDUsuario",-1) 
	var Cli_ID = Parametro("Cli_ID", -1)
 	var Pro_ID = Parametro("Pro_ID", -1)
 	var ProM_ID = Parametro("ProM_ID", -1)
 	var Rollo = Parametro("Rollo", -1)
 	var EPC = Parametro("Serie", -1)
 	var Cantidad_Rollo = Parametro("Cantidad_Rollo", -1)

 switch (parseInt(Tarea)) {

	case 1:
	
	if(Pt_ID > -1){

	
%>	
<table class="table">
    <thead>
        <th>Folio</th>
        <th>SKU</th>
        <th>Producto</th>
        <th>Movimiento</th>
        <th>Cantidad</th>
    </thead>
    <tbody>
<%    
sSQL =" SELECT m.*, c.Cat_Nombre, p.Pro_Nombre, p.Pro_SKU FROM Producto_Movimiento m "
		+	" INNER JOIN Producto p ON p.Pro_ID = m.Pro_ID INNER JOIN Cat_Catalogo c ON c.Cat_ID=m.ProM_TipoCG170"
sSQL += " WHERE ProM_ID = "+ProM_ID+"  AND c.Sec_ID  = 170"
var rsMovimiento = AbreTabla(sSQL, 1, 0)

			  var Folio = rsMovimiento.Fields.Item("ProM_ID").Value
			  var Producto = rsMovimiento.Fields.Item("Pro_Nombre").Value 
			  var Pro_SKU = rsMovimiento.Fields.Item("Pro_SKU").Value 
			  var ProM_Cantidad = rsMovimiento.Fields.Item("ProM_Cantidad").Value 
			  var Movimiento = rsMovimiento.Fields.Item("Cat_Nombre").Value 
			  var FechaRegistro = rsMovimiento.Fields.Item("ProM_FechaRegistro").Value 
	  
		
			var sSQL = "SELECT ISNULL(MAX(ProMR_Rollo),0) AS RolloActual FROM Producto_Movimiento_Rollos WHERE ProM_ID=" + ProM_ID //+ " AND MB_Usuario="+ IDUsuario
			var rsRol = AbreTabla(sSQL,1,0) 
			if(!rsRol.EOF){
			//	if(rsMB.Fields.Item("MBActual").Value==0){
//			var sSQL = "SELECT ISNULL(MAX(Ser_MB),0) AS MBActual FROM Recepcion_Series WHERE Pt_ID=" + Pt_ID 
//			var rsMB2 = AbreTabla(sSQL,1,0) 
//			if(!rsMB2.EOF){
//			 MB = rsMB.Fields.Item("MBActual").Value
//			}
//				}
			 var Rollo = rsMB.Fields.Item("RolloActual").Value
		//	}else{
//			
var Cantidad  = "SELECT COUNT(*) Cantidad "
			Cantidad  += " FROM Producto_Movimento  "
			Cantidad  += " WHERE  ProM_ID = "+ProM_ID
		
		var rsCan = AbreTabla(Cantidad,1,0) 
		if(!rsCan.EOF){
			var Cantidad = rsCan.Fields.Item("Cantidad").Value
		}
			}
			
		   var SeriesRol  = "SELECT COUNT(*) SeriesRol "
				SeriesRol  += " FROM Producto_Movimiento_Series  "
				SeriesRol  += " WHERE ProMS_Rollo ="+Rollo+" AND ProM_ID = "+ProM_ID
	
		var rsCan = AbreTabla(SeriesRol,1,0) 
		if(!rsCan.EOF){
			SeriesRol = rsCan.Fields.Item("SeriesRol").Value
		}
					var sSQLTr  = "SELECT ProMR_Cantidad, ProMR_Usuario FROM Producto_Movimiento_Rollos WHERE ProMR_Rollo = "+Rollo
		      			  sSQLTr += " AND  ProM_ID = "+ProM_ID

		   var rsCan = AbreTabla(sSQLTr,1,0) 
		   	if(!rsCan.EOF){
			var Rol_Cantidad = rsCan.Fields.Item("ProMR_Cantidad").Value
			var Rol_Usuario = rsCan.Fields.Item("ProMR_Usuario").Value

			}else{
				var Rol_Cantidad = 0
			}
//			var sSQLTr  = "SELECT TPro_ID, Pro_SerieDigitos FROM Producto"
//      			  sSQLTr += " WHERE Pro_ID = " + Pro_ID
//		   var rsTPro = AbreTabla(sSQLTr,1,0) 

		   var Digitos =23
		%>
	
	        <tr>
            <td><%=ProM_ID%></td>
            <td><%=Pro_SKU%></td>
            <td><%=Producto%></td>
            <td><%=Movimiento%></td>
            <td><%=ProM_Cantidad%></td>
                <input type="hidden" id="ProM_ID" value="<%=ProM_ID%>"/>
           		 <input type="hidden" id="total" value="<%=ProM_Cantidad%>"/>
                 <td> <select id="cboRol" onchange="FunctionRecepcion.ReanudarRol()">
                <option value="" ></option>
                <%
				var sSQL = "SELECT ProMR_Rollo FROM Producto_Movimiento_Rollos WHERE Pt_ID = "+Pt_ID
           		
			var rsRol = AbreTabla(sSQL,1,0)
			while (!rsRol.EOF){
			var Num_Rollo =  rsRol.Fields.Item("ProMR_Rollo").Value 

			%>
           <option value="<%=Num_Rollo%>"><%=Num_Rollo%></option>
           <%	
			 rsRol.MoveNext() 
				}
			rsRol.Close()   	
			%>
                    </select>
                    </td>
            <td id="escaneadasValor"><%=SeriesRol%></td>
           		<input type="hidden" id="escaneadas" value="<%=SeriesRol%>"/>
            <td id="RolValor"><%=Rollo%></td>
    	       <input type="hidden" class="form-control RolActual" id="RolActual" value="<%=Rollo%>"/>
            <td>
           	<%	
			if((SeriesRol == Rol_Cantidad || Cantidad==0)){		
			%>
         	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="escanea el EPC" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie(event);"/>
           	<input class="form-control inputRol"  id="inputRol" style="display:none;width:56%" placeholder="cantidad" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnRol" id= "BtnRol"  style="display:none" onclick="FunctionRollo.InsertRollo()">
			A&ntilde;adir Rollo</button>
<!--            <button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal"onclick=				
            "FunctionUbic.InsertUbic()">Asignar ubicacion vacia</button>
-->        
        	<button type="button" class="btn btn-primary BtnMuestraUbic" style="display:none;" id= "BtnMuestraUbic" data-toggle="modal" data-target="#myModal" onclick=		
            "Ubicacion.SeleccionAvanzadaAbrir({Selector: 'inpUbiID', Etiqueta: 'lblUbiNombre'});">Asignar ubicacion manual</button>
  		
        	<select id="Pt_Ubicacion" class="form-control agenda" style="display:none;">
                <option value="" ></option>
         
                <%
				var sSQL = "SELECT top (30) Pt_Ubicacion, Ubi_ID, Pt_Cantidad FROM Recepcion_Pallet  WHERE Pt_Ubicacion is not NULL ORDER BY Pt_ID "
           		
			var rsUbi = AbreTabla(sSQL,1,0)
			while (!rsUbi.EOF){
			var Etiqueta =  rsUbi.Fields.Item("Pt_Ubicacion").Value 
			var Cantidad =  rsUbi.Fields.Item("Pt_Cantidad").Value 

			%>
           <option value="<%=Etiqueta%>"><%=Etiqueta%> cantidad: <%=Cantidad%></option>
           <%	
			 rsUbi.MoveNext() 
				}
			rsUbi.Close()   	
			%>
                    </select>
                    <button type="button" class="btn btn-primary BtnUbicM" style="display:none;" id= "BtnUbicM" data-toggle="modal" data-target="#myModal" onclick=	 "FunctionUbic.InsertUbicManual()">Guardar ubicacion</button>
          <!--  ""-->
            
             <input class="form-control inpUbiID" id="inpUbiID" style="display:none;width:55%" placeholder="" type="text" autocomplete="off" value="" />
            <label id= "lblUbiNombre" type="text" autocomplete="off" value="" />
            <%
			}else{
				%>
           	<input class="form-control inputRol"  id="inputRol" style="display:none;width:56%" placeholder="cantidad" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnRol" id= "BtnRol"  style="display:none" onclick="FunctionRollo.InsertRollo()">
			A&ntilde;adir Rollo</button>
           	<input class="form-control Serie" id= "Serie" placeholder="Ingresar Serie" type="text" autocomplete="off" value="" maxlength="<%=Digitos%>" onkeydown="FunctionRecepcion.InsertSerie(event);" />
        	<button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal" onclick=		
            "FunctionUbic.InsertUbic()">Asignar ubicacion vacia</button>
        	<button type="button" class="btn btn-primary BtnMuestraUbic" style="display:none;" id= "BtnMuestraUbic" data-toggle="modal" data-target="#myModal" onclick=		
           "Ubicacion.SeleccionAvanzadaAbrir({Selector: 'inpUbiID', Etiqueta: 'lblUbiNombre'});">Asignar ubicacion manual</button>
		 	<select id="Pt_Ubicacion" class="form-control agenda" style="display:none;">
           <option value="" ></option>

                <%
			//	var sSQL = "SELECT top (10) Ubi_Nombre, u.Ubi_ID, Pt_Cantidad FROM Ubicacion u INNER JOIN Pallet p ON u.Ubi_ID = p.Ubi_ID WHERE Ubi_Habilitado = 1 "
			//					+"AND ARE_ID = 1 and Pt_Cantidad is not null order by Pt_Cantidad "

				var sSQL = "SELECT top (30) Pt_Ubicacion, Ubi_ID, Pt_Cantidad FROM Recepcion_Pallet  WHERE Pt_Ubicacion is not NULL ORDER BY Pt_ID "

			var rsUbi = AbreTabla(sSQL,1,0)
			while (!rsUbi.EOF){
			var Etiqueta =  rsUbi.Fields.Item("Pt_Ubicacion").Value 
			var Cantidad =  rsUbi.Fields.Item("Pt_Cantidad").Value 

			%>
           <option value="<%=Etiqueta%>"><%=Etiqueta%> cantidad: <%=Cantidad%></option>
           <%	
			 rsUbi.MoveNext() 
				}
			rsUbi.Close()   	
			%>
                    </select>
                    <br />
            <input class="form-control inpUbiID" id="inpUbiID" style="display:none;width:55%" placeholder="cantidad" type="text" autocomplete="off" value="" />
            <label id= "lblUbiNombre" type="text" autocomplete="off" value="" />
                    	<button type="button" class="btn btn-primary BtnUbicM" style="display:none;" id= "BtnUbicM" data-toggle="modal" data-target="#myModal" onclick=		
            "FunctionUbic.InsertUbicManual()">Guardar ubicacion</button>
            
            
           	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="escanea el EPC" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie(event);"/>



            <%	
			}
			
			%>
                      	       <input type="hidden" class="form-control Alfanum" id="Alfanum" value="<%=Pro_Alfanum%>"/>

            </td>
		</tr>
    <%		  
		  }
%>    
    
    
    
    </tbody>
</table>  
  <div  id = "divRollo"> </div>
<%		
	}
%>
	        <input class="form-control Folio"  id= "inputFolio" style="width:30%" placeholder="Escanea el proximo folio" type="text" autocomplete="off" value="" 
            onkeydown="FunctionPallet.CargaFolio(event);"/>

<%
	break;
	
	case 2:

		Serie = Serie.replace("-","")
		Serie = Serie.replace("/","")
		Serie = Serie.replace("'","")
		Serie = Serie.replace("'","")
		var caracteres = Serie.length
	if(caracteres == 16){
		var Existencia = BuscaSoloUnDato("ProM_ID","Producto_Movimiento_Series","ProMS_EPC = '"+Serie+"'",-1,0) 
		if(Existencia > -1){
			result = 0
			message = "Error: el EPC "+Serie+" ya fue escaneado anteriormente"
			
		}else{
		

			var sSQLTr = "INSERT INTO Producto_Movimiento_Series(Pro_ID, Cli_ID, ProM_ID, ProMS_Rollo, ProMS_EPC)  "
			sSQLTr  += " VALUES("+Pro_ID+","+Cli_ID+","+ProM_ID+","+Rollo+",'"+EPC+"')"
			
			if(Ejecuta(sSQLTr,0)){
			
			   var SeriesMB  = "SELECT COUNT(*) SeriesRollo "
				SeriesMB  += " FROM Producto_Movimiento_Series  "
				SeriesMB  += " WHERE ProMS_Rollo ="+Rollo+" AND ProM_ID = "+ProM_ID
		
		var rsCan = AbreTabla(SeriesMB,1,0) 
		if(!rsCan.EOF){
			SeriesRollo = rsCan.Fields.Item("SeriesRollo").Value
		}
			var sSQLTr  = "SELECT Rollo_Cantidad FROM Producto_Movimiento_Rollos WHERE ProMR_Rollo= "+Rollo
      			  sSQLTr += " AND ProM_ID = "+ProM_ID

		   var rsCan = AbreTabla(sSQLTr,1,0) 
		   	if(!rsCan.EOF){
			var Rollo_Cantidad = rsCan.Fields.Item("Rollo_Cantidad").Value
			}
			
			if(SeriesRollo == Rollo_Cantidad){		

				result = 2
				message = "Rollo terminado"

			}else{
				result = 1
				message = "EPC "+Serie+" escaneado"
			}
			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
			

		}
	}else{
	message = "El EPC"+Serie+" no cumple con el largo establecido de caracteres."
	result = 5
	}
	var SeriesR  = "SELECT COUNT(*) SeriesR "
				SeriesR  += " FROM Producto_Movimiento_Series  "
				SeriesR  += " WHERE  Pro_ID = "+Pt_ID
	
		var rsCan = AbreTabla(SeriesR,1,0) 
		if(!rsCan.EOF){
			SeriesR = rsCan.Fields.Item("SeriesR").Value
		}
		 var sSQLTr  = "SELECT Rollo_Cantidad FROM Producto_Movimiento_Rollos WHERE ProM_ID = "+ProM_ID
			 
	 var rsPt = AbreTabla(sSQLTr,1,0) 
	
	if(!rsPt.EOF){
	  var Rollo_Cantidad = rsPt.Fields.Item("Rollo_Cantidad").Value
	}
				if(SeriesPt == Pt_Cantidad){
					sSQLTr = "UPDATE Producto_Movimiento_Rollos SET ProMR_Terminado = 1"
					sSQLTr  += " WHERE ProM_ID = "+ProM_ID
				Ejecuta(sSQLTr, 0)
					if(result != 0){
						result = 3
						message = "Rollo terminado"	
					}
				}	
	Respuesta = '{"result":'+result+',"message":"'+message+'"}'
		
	break;
	case 3:
	
	var sSQL = "SELECT  ISNULL(MAX(ProMR_Rollo),0) AS Rollo FROM Producto_Movimiento_Rollos WHERE Pt_ID = "+ Pt_ID
	var rsNvoRollo = AbreTabla(sSQL,1,0)
	if(!rsNvoRollo.EOF){
	Rollo =rsNvoRollo.Fields.Item("Rollo").Value+1
	}
	
if(Cantidad_Rollo > -1 || TriDim > -1){
			
			sSQLTr = "INSERT INTO Producto_Movimiento_Rollos(ProM_ID, ProMR_Rollo, ProMR_Cantidad)  "
			sSQLTr  += " VALUES("+ProM_ID+","+Rollo+","+ProMR_Cantidad+")"
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Rollo a&ntilde;adido"

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
}else{
	result = 0
	message = "Ingresar la cantidad de etiquetas del rollo"
}

			
		  	
				Respuesta = '{"result":'+result+',"message":"'+message+'", "Rollo":'+Rollo+'}'

	break;
	 case 4:
var ProM_ID = Parametro("ProM_ID","")
var Destino = 1
/*%>if(CliOC_ID>-1){
var sSQL = "SELECT CliEnt_AreaDestinoCG88 FROM Cliente_OrdenCompra_Entrega WHERE IR_ID="+IR_ID
var rsDestino = AbreTabla(sSQL,1,0) 
Destino = rsDestino.Fields.Item("CliEnt_AreaDestinoCG88").Value
}<%*/
 var sSQLTr="EXEC SPR_Ubicar  @Tipo=1,  @Inm_ID=1, @Are_ID="+Destino+", @ProM_ID='"+ProM_ID+"'"

 //AbreTabla(sSQLTr,1,0) 
 
	var sSQL = "SELECT CONVERT(VARCHAR(17), getdate(), 111) AS Hoy, CONVERT(VARCHAR(8),  getdate(), 108) AS Hora FROM Inventario_Recepcion"
//	var rsFecha = AbreTabla(sSQL,1,0)
	


 break;
  

case 5:
//		  var SeriesPt  = "SELECT COUNT(*) SeriesPt "
//				SeriesPt  += " FROM Recepcion_Series  "
//				SeriesPt  += " WHERE  Pt_ID = "+Pt_ID
//	
//		var rsCan = AbreTabla(SeriesPt,1,0) 
//		if(!rsCan.EOF){
//			SeriesPt = rsCan.Fields.Item("SeriesPt").Value
//		}
//		 var sSQLTr  = "SELECT Pt_Cantidad"
//		sSQLTr  += " FROM Recepcion_Pallet a "
//		sSQLTr  += " WHERE Pt_ID = "+Pt_ID
//			 
//	 var rsPt = AbreTabla(sSQLTr,1,0) 
//	
//	if(!rsPt.EOF){
//	  var Pt_Cantidad = rsPt.Fields.Item("Pt_Cantidad").Value
//	}
//				if(SeriesPt == Pt_Cantidad){
//					sSQLTr = "UPDATE Recepcion_Pallet SET Pt_PalletEscaneado = 1"
//					sSQLTr  += " WHERE Pt_ID = "+Pt_ID
//				Ejecuta(sSQLTr, 0)
//					if(result != 0){
//						result = 2
//						message = "Pallet terminado"	
//						 if (!rsRayX.EOF || !rsMBSerie.EOF){
//						 }else{
//							result = 4
//							message = "Masterbox terminado. <br /> No ha sido escaneado en rayos X"		
// 
//						 }
//					}
//				}
//				Respuesta = '{"result":'+result+',"message":"'+message+'", "MB":'+MB+'}'

	break;
	 case 6:
	sSQL = "SELECT Ubi_ID FROM Ubicacion WHERE Ubi_Nombre = '"+ Pt_Ubicacion + "'"
	Response.Write(sSQL)
						var rsUbi = AbreTabla(sSQL,1,0)
						var Ubi_ID = rsUbi.Fields.Item("Ubi_ID").Value

 var sSQLTr="UPDATE Producto_Movimiento SET  Ubi_ID = "+Ubi_ID+" WHERE ProM_ID="+ProM_ID

	Ejecuta(sSQLTr, 0)
 
 break;
  	case 7:	
			
	   var SeriesMB  = "SELECT COUNT(*) SeriesRol "
				SeriesMB  += " FROM Producto_Movimiento_Series  "
				SeriesMB  += " WHERE ProMS_Rollo ="+Rollo+" AND ProM_ID = "+ProM_ID
	
		var rsCan = AbreTabla(SeriesMB,1,0) 
		if(!rsCan.EOF){
			SeriesRol = rsCan.Fields.Item("SeriesRol").Value
		}
			
				%>
                <label  id="EscaneadasRollo"><%=SeriesRol%></label>

               <%
		
		break; 

 }
Response.Write(Respuesta)
%><%/*%>
<script type="text/javascript">

</script><%*/%>