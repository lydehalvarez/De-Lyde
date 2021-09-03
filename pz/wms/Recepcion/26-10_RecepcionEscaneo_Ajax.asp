       <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
  
<%
 	var Tarea = Parametro("Tarea", -1)
    var IDUsuario = Parametro("IDUsuario",-1) 
	
 	var Cli_ID = Parametro("Cli_ID", -1)
 	var CliOC_ID = Parametro("CliOC_ID", -1)
 	var CliEnt_ID = Parametro("CliEnt_ID", -1)
 	var TA_ID = Parametro("TA_ID", -1)
 	var OC_ID = Parametro("OC_ID", -1)
 	var Prov_ID = Parametro("Prov_ID", -1)
 	var Pt_ID = Parametro("Pt_ID", -1)
 	var Pro_ID = Parametro("Pro_ID", -1)
 	var IR_ID = Parametro("IR_ID", -1)
	var Pallet =  parseInt(Parametro("Pallet",-1))
 	var Serie = Parametro("Serie", -1)
 	var MB = Parametro("MB", -1)
 	var Cantidad_MB = Parametro("Cantidad_MB", -1)
	var Respuesta = ""
	var result = 0
	var message = ""

 switch (parseInt(Tarea)) {

	case 1:
%>	
<table class="table">
    <thead>
        <th>Pallet</th>
        <th>SKU</th>
        <th>Modelo</th>
        <th>LPN</th>
        <th>Cantidad a entrega</th>
        <th>Cantidad escaneada</th>
         <th>Masterbox Actual</th>
        <th>Acciones</th>
    </thead>
    <tbody>
<%    
	 var sSQLTr  = "SELECT *, "
		sSQLTr  += " p.Pro_SKU  SKU"
		sSQLTr  += " , a.Pt_Modelo  as Modelo"
		sSQLTr  += " , (SELECT Col_nombre FROM Cat_Color WHERE Col_ID = p.Col_ID) Color"
		sSQLTr  += "  FROM Recepcion_Pallet a, Producto p "
		sSQLTr  += " WHERE Pt_ID = "+Pt_ID
		sSQLTr  += " AND a.Pro_ID = p.Pro_ID "
	 
	 var rsPt = AbreTabla(sSQLTr,1,0) 
	
	if(!rsPt.EOF){
	  var Pt_Pallet = rsPt.Fields.Item("Pt_Pallet").Value
	  var SKU = rsPt.Fields.Item("SKU").Value
	  var Pt_LPN = rsPt.Fields.Item("Pt_LPN").Value
	  var Pt_Cantidad = rsPt.Fields.Item("Pt_Cantidad").Value
	  var Modelo = rsPt.Fields.Item("Modelo").Value
	  var Color = rsPt.Fields.Item("Color").Value
	  
		var Cantidad  = "SELECT COUNT(*) Cantidad "
			Cantidad  += " FROM Recepcion_Series  "
			Cantidad  += " WHERE Pt_ID = "+Pt_ID
		
		var rsCan = AbreTabla(Cantidad,1,0) 
		if(!rsCan.EOF){
			var Cantidad = rsCan.Fields.Item("Cantidad").Value
		}
			var sSQL = "SELECT ISNULL(MAX(Ser_MB),0) AS MBActual FROM Recepcion_Series WHERE Pt_ID=" + Pt_ID //+ " AND MB_Usuario="+ IDUsuario
			var rsMB = AbreTabla(sSQL,1,0) 
			if(!rsMB.EOF){
			//	if(rsMB.Fields.Item("MBActual").Value==0){
//			var sSQL = "SELECT ISNULL(MAX(Ser_MB),0) AS MBActual FROM Recepcion_Series WHERE Pt_ID=" + Pt_ID 
//			var rsMB2 = AbreTabla(sSQL,1,0) 
//			if(!rsMB2.EOF){
//			 MB = rsMB.Fields.Item("MBActual").Value
//			}
//				}
			 MB = rsMB.Fields.Item("MBActual").Value
		//	}else{
//			
			}
			
		   var SeriesMB  = "SELECT COUNT(*) SeriesMB "
				SeriesMB  += " FROM Recepcion_Series  "
				SeriesMB  += " WHERE Ser_MB ="+MB+" AND Pt_ID = "+Pt_ID
	
		var rsCan = AbreTabla(SeriesMB,1,0) 
		if(!rsCan.EOF){
			SeriesMB = rsCan.Fields.Item("SeriesMB").Value
		}
					var sSQLTr  = "SELECT MB_Cantidad, MB_Usuario FROM Recepcion_Masterbox WHERE MB_Numero = "+MB
		      			  sSQLTr += " AND Pt_ID = "+Pt_ID

		   var rsCan = AbreTabla(sSQLTr,1,0) 
		   	if(!rsCan.EOF){
			var MB_Cantidad = rsCan.Fields.Item("MB_Cantidad").Value
			var MB_Usuario = rsCan.Fields.Item("MB_Usuario").Value

			}else{
				var MB_Cantidad = 0
			}
		%>
	
	        <tr>
            <td><%=Pt_Pallet%></td>
            <td><%=SKU%></td>
            <td><%=Modelo%></td>
            <td><%=Pt_LPN%></td>
                <input type="hidden" id="Pt_LPN" value="<%=Pt_LPN%>"/>
           	 <td><%=Pt_Cantidad%></td>
           		 <input type="hidden" id="total" value="<%=Pt_Cantidad%>"/>
            <td id="escaneadasValor"><%=Cantidad%></td>
           		<input type="hidden" id="escaneadas" value="<%=Cantidad%>"/>
            <td id="MBValor"><%=MB%></td>
    	       <input type="hidden" class="form-control MBActual" id="MBActual" value="<%=MB%>"/>
            <td>
           	<%	
			if((SeriesMB == MB_Cantidad || Cantidad==0) || IDUsuario != MB_Usuario){		
			%>
         	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="" type="text" autocomplete="off" value="" onkeydown=
            "FunctionRecepcion.InsertSerie(event);"/>
           	<input class="form-control inputMB"  id="inputMB" style="width:50%" placeholder="No. Articulos" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnMB" id= "BtnMB" onclick="FunctionMB.InsertMB()">
			A&ntilde;adir masterbox</button>
           	<button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal"onclick=				
            "FunctionUbic.InsertUbic()">Asignar ubicacion</button>
         	<input class="form-control Pallet"  id= "inputPallet" style="display:none;width:200%" placeholder="Escanea el proximo pallet" type="text" autocomplete="off" value="" 			
            onkeydown="FunctionRecepcion.NuevoPallet();"/>

            <%
			}else{
				%>
            <input class="form-control inputMB" id="inputMB" style="display:none;width:50%" placeholder="Cantidad de articulos" type="text" autocomplete="off" value="" />
			<button type="button" class="btn btn-primary BtnMB" style="display:none;" id= "BtnMB"  onclick="FunctionMB.InsertMB()">
			A&ntilde;adir masterbox</button>
           	<input class="form-control Serie" id= "Serie" placeholder="Ingresar Serie" type="text" autocomplete="off" value="" onkeydown="FunctionRecepcion.InsertSerie(event);" />
        	<button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal"onclick=		
            "FunctionUbic.InsertUbic()">Asignar ubicacion</button>
           	<input class="form-control Pallet"  id= "inputPallet" style="display:none;width:200%" placeholder="Escanea el proximo pallet" type="text" autocomplete="off" value="" 
            onkeydown="FunctionRecepcion.NuevoPallet();"/>

            <%	
			}
			
			%>
            </td>
		</tr>
    <%		  
		  }
%>    
    
    
    
    </tbody>
</table>  
    
<%		
	break;
	case 2:
	
	//	caracteres
//		cambio de masterbox
//		terminacion de escaneo de pallet para ubicar en rack
	var sSQLTr  = "SELECT TPro_ID FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
		  
		   var Tipo = rsTPro.Fields.Item("TPro_ID").Value
		if(Tipo != 2){
			var NoCar = 15
		}
		if(Tipo == 2){
			var NoCar = 15
		}
		var caracteres = Serie.length
	if(caracteres >= NoCar && caracteres < 21){
		var Existencia = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+Serie+"'",-1,0) 
		if(Existencia > -1){
			result = 0
			message = "Lo sentimos la serie "+Serie+" ya existe"
			
		}else{
		
			var Ser_ID = SiguienteID("Ser_ID","Recepcion_Series","Pt_ID = "+Pt_ID,0)
		
			var sSQLTr = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr  += " VALUES("+Pt_ID+","+Ser_ID+","+MB+",'"+Serie+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
			
			if(Ejecuta(sSQLTr,0)){
				if(MB == 1){
					sSQLTr  = " SELECT a.CliOC_ID, a.Cli_ID, a.OC_ID, a.Prov_ID FROM Recepcion_Pallet a "
					sSQLTr  += " WHERE Pt_ID = "+Pt_ID
						var rsOC = AbreTabla(sSQLTr,1,0) 
					if(!rsOC.EOF){
					CliOC_ID =   rsOC.Fields.Item("CliOC_ID").Value
					Cli_ID =   rsOC.Fields.Item("Cli_ID").Value
					OC_ID =   rsOC.Fields.Item("OC_ID").Value
					Prov_ID =   rsOC.Fields.Item("Prov_ID").Value
						if(CliOC_ID > -1){
					sSQLTr = "UPDATE Cliente_OrdenCompra SET CliOC_EstatusCG52 = 14"
					sSQLTr  += " WHERE CliOC_ID = "+CliOC_ID+" AND Cli_ID = "+Cli_ID
					Ejecuta(sSQLTr, 0)
					}else{
						sSQLTr = "UPDATE Proveedor_OrdenCompra SET OC_EstatusCG52 = 14"
					sSQLTr  += " WHERE OC_ID = "+OC_ID+" AND Prov_ID = "+Prov_ID
					Ejecuta(sSQLTr, 0)
			}
				}
					}
	
				   var SeriesMB  = "SELECT COUNT(*) SeriesMB "
				SeriesMB  += " FROM Recepcion_Series  "
				SeriesMB  += " WHERE Ser_MB ="+MB+" AND Pt_ID = "+Pt_ID
		
		var rsCan = AbreTabla(SeriesMB,1,0) 
		if(!rsCan.EOF){
			SeriesMB = rsCan.Fields.Item("SeriesMB").Value
		}
			var sSQLTr  = "SELECT MB_Cantidad FROM Recepcion_Masterbox WHERE MB_Numero = "+MB
      			  sSQLTr += " AND Pt_ID = "+Pt_ID

		   var rsCan = AbreTabla(sSQLTr,1,0) 
		   	if(!rsCan.EOF){
			var MB_Cantidad = rsCan.Fields.Item("MB_Cantidad").Value
			}
			
			if(SeriesMB == MB_Cantidad){		
				var sSQLTr = "SELECT Ray_ID FROM Recepcion_Series WHERE Ser_MB ="+MB+" AND Pt_ID ="+Pt_ID+" AND Ray_ID > 0"
				var rsRayX = AbreTabla(sSQLTr,1,0) 
				if(!rsRayX.EOF){
				result = 2
				message = "Masterbox terminado"
				}else{
					sSQLTr = "UPDATE Recepcion_Masterbox SET MB_RayX = 1"
					sSQLTr  += " WHERE MB_Numero = "+MB
      			    sSQLTr += " AND Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
					sSQLTr = "UPDATE Recepcion_Pallet SET Pt_Incidencia = 1"
					sSQLTr  += " WHERE Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
				result = 4
				message = "Masterbox terminado. El masterbox no ha sido escaneado en rayos X"		
		
				}
			}else{
				result = 1
				message = "Serie "+Serie+" escaneada"
			}
			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
			

		}
	}else{
	message = "La serie "+Serie+" no cumple con el largo establecido de caracteres."
	result = 0
	}
		 var SeriesPt  = "SELECT COUNT(*) SeriesPt "
				SeriesPt  += " FROM Recepcion_Series  "
				SeriesPt  += " WHERE  Pt_ID = "+Pt_ID
	
		var rsCan = AbreTabla(SeriesPt,1,0) 
		if(!rsCan.EOF){
			SeriesPt = rsCan.Fields.Item("SeriesPt").Value
		}
		 var sSQLTr  = "SELECT Pt_Cantidad"
		sSQLTr  += " FROM Recepcion_Pallet a "
		sSQLTr  += " WHERE Pt_ID = "+Pt_ID
			 
	 var rsPt = AbreTabla(sSQLTr,1,0) 
	
	if(!rsPt.EOF){
	  var Pt_Cantidad = rsPt.Fields.Item("Pt_Cantidad").Value
	}
				if(SeriesPt == Pt_Cantidad){
					sSQLTr = "UPDATE Recepcion_Pallet SET Pt_PalletEscaneado = 1"
					sSQLTr  += " WHERE Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
				result = 3
				message = "Pallet terminado"	
				}
	Respuesta = '{"result":'+result+',"message":"'+message+'"}'
		
	break;
	case 3:
	var sSQL = "SELECT  ISNULL(MAX(MB_Numero),0) AS MB FROM Recepcion_Masterbox WHERE Pt_ID = "+ Pt_ID
	var rsNvoMB = AbreTabla(sSQL,1,0)
	if(!rsNvoMB.EOF){
	MB =rsNvoMB.Fields.Item("MB").Value+1
	}
			sSQLTr = "INSERT INTO Recepcion_Masterbox(Pt_ID, MB_Numero, MB_Cantidad, MB_Usuario)  "
			sSQLTr  += " VALUES("+Pt_ID+","+MB+","+Cantidad_MB+", "+IDUsuario+")"
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Masterbox a&ntilde;adido"

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
				Respuesta = '{"result":'+result+',"message":"'+message+'"}'

	break;
	 case 4:
var Pt_LPN = Parametro("Pt_LPN","")

 var sSQLTr="EXEC SPR_UbicarPallet  @Tipo=1,  @Inm_ID=1, @Are_ID=1,@Pt_LPN='"+Pt_LPN+"'"

 AbreTabla(sSQLTr,1,0) 
 
	var sSQL = "SELECT CONVERT(VARCHAR(17), getdate(), 111) AS Hoy, CONVERT(VARCHAR(8),  getdate(), 108) AS Hora FROM Inventario_Recepcion"
	var rsFecha = AbreTabla(sSQL,1,0)
	
	sSQLTr=" UPDATE Inventario_Recepcion SET IR_IngresoFecha = getdate() , IR_IngresoResultado=1, IR_IngresoUsuario = "+IDUsuario+" WHERE IR_ID ="+IR_ID
	Ejecuta(sSQLTr, 0)

  break;
 }
Response.Write(Respuesta)
%>
