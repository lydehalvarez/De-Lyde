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
	var LPN = Parametro("Pt_LPN","0")
 	var Pro_ID = Parametro("Pro_ID", -1)
 	var IR_ID = Parametro("IR_ID", -1)
	var Pallet =  parseInt(Parametro("Pallet",-1))
 	var Serie = Parametro("Serie", -1)
	var serie1 = Parametro("serie1", -1)
	var serie2 = Parametro("serie2", -1)
	var serie3 = Parametro("serie3", -1)
	var serie4 = Parametro("serie4", -1)
	var serie5 = Parametro("serie5", -1)
	var serie6 = Parametro("serie6", -1)
	var serie7 = Parametro("serie7", -1)
	var serie8 = Parametro("serie8", -1)
	var serie9 = Parametro("serie9", -1)
	var serie10 = Parametro("serie10", -1)
	var TriDim = Parametro("TriDim", -1)
 	var MB = Parametro("MB", -1)
 	var RFID = Parametro("RFID", "")
	var MB_Serie = Parametro("MB_Serie", "")
 	var Cantidad_MB = Parametro("Cantidad_MB", -1)
	var Pt_Ubicacion = Parametro("Pt_Ubicacion", -1)
	var Respuesta = ""
	var result = 0
	var message = ""

 switch (parseInt(Tarea)) {

	case 1:
	
	if(Pt_ID > -1){

	
%>	
		<button type="button" class="btn btn-primary Btn3D" id= "Btn3D"  onclick="FunctionMB.Mostrar3D()">
			A&ntilde;adir masterbox 3D
            </button>
<table class="table">
    <thead>
        <th>Pallet</th>
        <th>SKU</th>
        <th>Modelo</th>
        <th>LPN</th>
        <th>Cantidad pallet</th>
          <th>Reanudar masterbox</th>
        <th>Cantidad escaneada</th>
         <th>Masterbox Actual</th>
        <th>Acciones</th>
    </thead>
    <tbody>
<%    
	 var sSQLTr  = "SELECT *, "
		sSQLTr  += " p.Pro_SKU  SKU, Pro_RFIDCG160"
		sSQLTr  += " , a.Pt_Modelo  as Modelo, Pro_SerieAlfanumerico, a.Pro_ID, Pro_EsSerializado"
		sSQLTr  += " , (SELECT Col_nombre FROM Cat_Color WHERE Col_ID = p.Col_ID) Color"
		sSQLTr  += "  FROM Recepcion_Pallet a, Producto p "
		sSQLTr  += " WHERE Pt_ID = "+Pt_ID
		sSQLTr  += " AND a.Pro_ID = p.Pro_ID  "
	 
	 var rsPt = AbreTabla(sSQLTr,1,0) 
	
	if(!rsPt.EOF){
	  var Pt_Pallet = rsPt.Fields.Item("Pt_Pallet").Value
	  var SKU = rsPt.Fields.Item("SKU").Value
	  var Pro_ID = rsPt.Fields.Item("Pro_ID").Value
	  var Pt_LPN = rsPt.Fields.Item("Pt_LPN").Value
	  var Pt_Cantidad = rsPt.Fields.Item("Pt_Cantidad").Value
	  var Modelo = rsPt.Fields.Item("Modelo").Value
	  var Color = rsPt.Fields.Item("Color").Value
	  var Pro_Alfanum = rsPt.Fields.Item("Pro_SerieAlfanumerico").Value
	  
		
			var sSQL = "SELECT ISNULL(MAX(MB_Numero),0) AS MBActual FROM Recepcion_Masterbox WHERE Pt_ID=" + Pt_ID //+ " AND MB_Usuario="+ IDUsuario
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
var Cantidad  = "SELECT COUNT(*) Cantidad "
			Cantidad  += " FROM Recepcion_Series  "
			Cantidad  += " WHERE  Pt_ID = "+Pt_ID
		
		var rsCan = AbreTabla(Cantidad,1,0) 
		if(!rsCan.EOF){
			var Cantidad = rsCan.Fields.Item("Cantidad").Value
		}
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
			var sSQLTr  = "SELECT TPro_ID, Pro_SerieDigitos, Pro_PrefijoRFID FROM Producto"
      			  sSQLTr += " WHERE Pro_ID = " + Pro_ID
		   var rsTPro = AbreTabla(sSQLTr,1,0) 

		   var Digitos = rsTPro.Fields.Item("Pro_SerieDigitos").Value
		   var Prefijo = rsTPro.Fields.Item("Pro_PrefijoRFID").Value

   		 //  var DigitosRFID = rsTPro.Fields.Item("Pro_RFID_Digitos").Value

		%>
	
	        <tr>
            <td><%=Pt_Pallet%></td>
            <td><%=SKU%></td>
            <td><%=Modelo%></td>
            <td><%=Pt_LPN%></td>
                <input type="hidden" id="Pt_LPN" value="<%=Pt_LPN%>"/>
           	 <td><%=Pt_Cantidad%></td>
           		 <input type="hidden" id="total" value="<%=Pt_Cantidad%>"/>
                 <td> <select id="cboMB" onchange="FunctionRecepcion.ReanudarMB()">
                <option value="" ></option>
                <%
				var sSQL = "SELECT MB_Numero FROM Recepcion_Masterbox WHERE Pt_ID = "+Pt_ID
           		
			var rsMB = AbreTabla(sSQL,1,0)
			while (!rsMB.EOF){
			var Masterbox =  rsMB.Fields.Item("MB_Numero").Value 

			%>
           <option value="<%=Masterbox%>"><%=Masterbox%></option>
           <%	
			 rsMB.MoveNext() 
				}
			rsMB.Close()   	
			%>
                    </select>
                    </td>
            <td id="escaneadasValor"><%=SeriesMB%></td>
           		<input type="hidden" id="escaneadas" value="<%=SeriesMB%>"/>
            <td id="MBValor"><%=MB%></td>
    	       <input type="hidden" class="form-control MBActual" id="MBActual" value="<%=MB%>"/>
            <td>
           	<%	
			if((SeriesMB == MB_Cantidad || Cantidad==0)){		
			%>
        
           	<input class="form-control inputMB"  id="inputMB" style="display:none;width:56%" placeholder="cantidad" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnMB" id= "BtnMB"  style="display:none" onclick="FunctionMB.InsertMB()">
			A&ntilde;adir masterbox</button>
   		 	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="escanea la serie" type="text" autocomplete="off" value="" <%/*%>maxlength="<%=Digitos%>"<%*/%> onkeydown= "FunctionRecepcion.InsertSerie(event);"/>
            	<input class="form-control Serie3D"  id= "Serie3D" style="display:none;width:100%" placeholder="escanea la serie 3D" type="text" autocomplete="off" value=""onkeydown= "FunctionRecepcion.InsertSerie3D(event);"/>
            <button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal"onclick=				
            "FunctionUbic.InsertUbic()">Asignar ubicacion vacia</button>
           	<input class="form-control inputMBSerie"  id="inputMBSerie" style="display:none;width:55%" placeholder="etiqueta MB" type="text" autocomplete="off" value="" onkeydown			="FunctionRecepcion.InsertMBSerie(event);"/>
        
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
          
           	<input class="form-control inputMB"  id="inputMB" style="display:none;width:56%" placeholder="cantidad" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnMB" id= "BtnMB"  style="display:none" onclick="FunctionMB.InsertMB()">
			A&ntilde;adir masterbox</button>
           	<input class="form-control Serie" id= "Serie" placeholder="Ingresar Serie" type="text" autocomplete="off" value="" <%/*%>maxlength="<%=Digitos%>" <%*/%>onkeydown="FunctionRecepcion.InsertSerie(event);" />		
            	<input class="form-control Serie3D"  id= "Serie3D" style="display:none;width:100%" placeholder="escanea la serie 3D" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie3D(event);"/>

        	<button type="button" class="btn btn-primary BtnUbic" style="display:none;" id= "BtnUbic" data-toggle="modal" data-target="#myModal" onclick=		
            "FunctionUbic.InsertUbic()">Asignar ubicacion vacia</button>
     	<input class="form-control inputMBSerie"  id="inputMBSerie" style="display:none;width:55%" placeholder="etiqueta MB" type="text" autocomplete="off" value="" onkeydown="FunctionRecepcion.InsertMBSerie(event);"/>
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
            
            
           	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="escanea la serie" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie(event);"/>
            			<input class="form-control Serie3D"  id= "Serie3D" style="display:none;width:100%" placeholder="escanea la serie 3D" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie3D(event);"/>



            <%	
			}
			if(rsPt.Fields.Item("Pro_RFIDCG160").Value>0){
			%>
                       	<input class="form-control RFID"  id= "RFID" style="display:none;width:100%" placeholder="escanea el RFID" maxlength="23" type="text" autocomplete="off" value="" onkeydown= "FunctionRecepcion.InsertSerie(event);"/>

            <%	
			}
			%>
                      	       <input type="hidden" class="form-control Alfanum" id="Alfanum" value="<%=Pro_Alfanum%>"/>
                      	       <input type="hidden" class="form-control Pro_RFIDCG160" id="Pro_RFIDCG160" value="<%=rsPt.Fields.Item("Pro_RFIDCG160").Value%>"/>
                      	       <input type="hidden" class="form-control PrefijoRFID" id="PrefijoRFID" value="<%=Prefijo%>"/>
                      	       <input type="hidden" class="form-control Digitos" id="Digitos" value="<%=Digitos%>"/>
                      	       <input type="hidden" class="form-control RFIDOpc" id="RFIDOpc" value="1"/>
                      	       <input type="hidden" class="form-control" id="Pro_Serializado" value="<%=rsPt.Fields.Item("Pro_EsSerializado").Value%>"/>

            </td>
		</tr>
    <%		  
		  }
%>    
    
    
    
    </tbody>
</table>  
  <div  id = "divMB"> </div>
<%		
	}
%>
	        <input class="form-control Pallet"  id= "inputLPN" style="width:30%" placeholder="Escanea el proximo pallet" type="text" autocomplete="off" value="" 
            onkeydown="FunctionPallet.CargaPallet(event);"/>

<%
	break;
	case 2:
	
	//	caracteres
//		cambio de masterbox
//		terminacion de escaneo de pallet para ubicar en rack
	var sSQLTr  = "SELECT TPro_ID, Pro_SerieDigitos, Pro_RFIDCG160 FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
		   var rsDig = AbreTabla(sSQLTr,1,0) 

		   var Digitos = rsTPro.Fields.Item("Pro_SerieDigitos").Value
		   var Tipo = rsTPro.Fields.Item("TPro_ID").Value
   		   var Pro_RFIDCG160 = rsTPro.Fields.Item("Pro_RFIDCG160").Value
			
			var NoCar = Digitos
	
		Serie = Serie.replace("-","")
		Serie = Serie.replace("/","")
		Serie = Serie.replace("'","")
		Serie = Serie.replace("'","")
		var caracteres = Serie.length
		if(caracteres == NoCar){
		//if(caracteres < 18 && caracteres > 13){
		var ExistenciaRFID = -1
		var Existencia = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+Serie+"'",-1,0) 
		if(RFID!=""){
			ExistenciaRFID = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_RFID = '"+RFID+"'",-1,0) 
		}
		if(Existencia > -1||ExistenciaRFID>-1){
			result = 0
			if(Existencia > -1){
			message = "Error: la serie "+Serie+" ya fue escaneada anteriormente"
			}
			if(ExistenciaRFID>-1){
			message = "Error: el RFID "+RFID+" ya fue escaneada anteriormente"
			
		}
		}else{
		
			var Ser_ID = SiguienteID("Ser_ID","Recepcion_Series","Pt_ID = "+Pt_ID,0)
		
			var sSQLTr = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada, Ser_RFID)  "
			sSQLTr  += " VALUES("+Pt_ID+","+Ser_ID+","+MB+",'"+Serie+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1, '"+RFID+"')"
			
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

				result = 2
				message = "Masterbox terminado"

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
	result = 5
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
					if(result != 0){
						result = 3
						message = "Pallet terminado"	
					}
				}	
	Respuesta = '{"result":'+result+',"message":"'+message+'", "rfid":'+Pro_RFIDCG160+'}'
		
	break;
	case 3:
	
	var sSQL = "SELECT  ISNULL(MAX(MB_Numero),0) AS MB FROM Recepcion_Masterbox WHERE Pt_ID = "+ Pt_ID
	var rsNvoMB = AbreTabla(sSQL,1,0)
	if(!rsNvoMB.EOF){
	MB =rsNvoMB.Fields.Item("MB").Value+1
	}
	
if(Cantidad_MB > -1 || TriDim > -1){
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
			sSQLTr = "INSERT INTO Recepcion_Masterbox(Pt_ID, MB_Numero, MB_Cantidad, MB_Usuario)  "
			sSQLTr  += " VALUES("+Pt_ID+","+MB+","+Cantidad_MB+", "+IDUsuario+")"
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Masterbox a&ntilde;adido"

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
}else{
	result = 0
	message = "Ingresar la cantidad de articulos del masterbox"
}

			
		  	
				Respuesta = '{"result":'+result+',"message":"'+message+'", "MB":'+MB+'}'

	break;
	 case 4:
var Pt_LPN = Parametro("Pt_LPN","")
var Destino = 1
/*%>if(CliOC_ID>-1){
var sSQL = "SELECT CliEnt_AreaDestinoCG88 FROM Cliente_OrdenCompra_Entrega WHERE IR_ID="+IR_ID
var rsDestino = AbreTabla(sSQL,1,0) 
Destino = rsDestino.Fields.Item("CliEnt_AreaDestinoCG88").Value
}<%*/
 var sSQLTr="EXEC SPR_UbicarPallet  @Tipo=1,  @Inm_ID=1, @Are_ID="+Destino+", @Pt_LPN='"+Pt_LPN+"'"

 AbreTabla(sSQLTr,1,0) 
 
	var sSQL = "SELECT CONVERT(VARCHAR(17), getdate(), 111) AS Hoy, CONVERT(VARCHAR(8),  getdate(), 108) AS Hora FROM Inventario_Recepcion"
	var rsFecha = AbreTabla(sSQL,1,0)
	


 break;
  
  	case 5:

	var sSQL = "SELECT  ISNULL(MAX(MB_Numero),0) AS MB FROM Recepcion_Masterbox WHERE Pt_ID = "+ Pt_ID + " AND MB_Usuario ="+IDUsuario
	
	var rsNvoMB = AbreTabla(sSQL,1,0)
	if(!rsNvoMB.EOF){
	MB =rsNvoMB.Fields.Item("MB").Value
	}
  var sSQLTr  = "SELECT Pt_Digitos FROM Recepcion_Pallet"
        sSQLTr += " WHERE Pt_ID = " + Pt_ID

		   var rsDig = AbreTabla(sSQLTr,1,0) 
		   var Digitos =rsDig.Fields.Item("Pt_Digitos").Value

var caracteres = MB_Serie.length 

if(MB_Serie != "" && caracteres == Digitos){


			sSQLTr = "UPDATE Recepcion_Masterbox SET MB_Serie ='"+MB_Serie+"'"
			sSQLTr  += " WHERE Pt_ID = "+ Pt_ID +" AND MB_Numero = " + MB
		if(Ejecuta(sSQLTr,0)){
				var sSQLTr = "SELECT Ray_ID FROM Recepcion_Series WHERE Ser_MB ="+MB+" AND Pt_ID ="+Pt_ID+" AND Ray_ID > 0"
				var rsRayX = AbreTabla(sSQLTr,1,0) 
				var sSQLTr = "SELECT TOP (1) MB_Serie FROM Recepcion_Masterbox ORDER BY MB_ID DESC"
				var rsMBSerie = AbreTabla(sSQLTr,1,0) 
				var sSQLTr = "SELECT Ray_Serie FROM Recepcion_RayosX WHERE Ray_Serie ='"+ rsMBSerie.Fields.Item("MB_Serie").Value + "'"
				var rsMBSerie = AbreTabla(sSQLTr,1,0) 
				if(!rsRayX.EOF || !rsMBSerie.EOF){
				result = 1
				message = "Etiqueta escaneada"
				}else{
					sSQLTr = "UPDATE Recepcion_Masterbox SET MB_RayX = 1"
					sSQLTr += " WHERE MB_Numero = "+MB
      			    sSQLTr += " AND Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
					sSQLTr = "UPDATE Recepcion_Pallet SET Pt_Incidencia = 1"
					sSQLTr  += " WHERE Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
				result = 3
				message = "Masterbox terminado. <br /> No ha sido escaneado en rayos X"		
		
				}
			

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
}else{
				result = 0
				message = "El largo de caracteres no es correcto"

}
if(MB_Serie == ""){
	result = 0
	message = "No ha escaneado el codigo a relacionar"
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
					if(result != 0){
						result = 2
						message = "Pallet terminado"	
						 if (!rsRayX.EOF || !rsMBSerie.EOF){
						 }else{
							result = 4
							message = "Masterbox terminado. <br /> No ha sido escaneado en rayos X"		
 
						 }
					}
				}
				Respuesta = '{"result":'+result+',"message":"'+message+'", "MB":'+MB+'}'

	break;
	 case 6:
var Pt_LPN = Parametro("Pt_LPN","")
var Destino = 1
/*%>if(CliOC_ID>-1){
var sSQL = "SELECT CliEnt_AreaDestinoCG88 FROM Cliente_OrdenCompra_Entrega WHERE IR_ID="+IR_ID
var rsDestino = AbreTabla(sSQL,1,0) 
Destino = rsDestino.Fields.Item("CliEnt_AreaDestinoCG88").Value
}<%*/
	sSQL = "SELECT Ubi_ID FROM Ubicacion WHERE Ubi_Nombre = '"+ Pt_Ubicacion + "'"
	Response.Write(sSQL)
						var rsUbi = AbreTabla(sSQL,1,0)
						var Ubi_ID = rsUbi.Fields.Item("Ubi_ID").Value

 var sSQLTr="UPDATE Recepcion_Pallet SET Pt_Ubicacion = '"+Pt_Ubicacion+"' , Ubi_ID = "+Ubi_ID+" WHERE Pt_LPN='"+Pt_LPN+"'"

	Ejecuta(sSQLTr, 0)
 
 break;
 	case 7:	
			
	   var SeriesMB  = "SELECT COUNT(*) SeriesMB "
				SeriesMB  += " FROM Recepcion_Series  "
				SeriesMB  += " WHERE Ser_MB ="+MB+" AND Pt_ID = "+Pt_ID
	
		var rsCan = AbreTabla(SeriesMB,1,0) 
		if(!rsCan.EOF){
			SeriesMB = rsCan.Fields.Item("SeriesMB").Value
		}
			
				%>
                <label  id="EscaneadasMB"><%=SeriesMB%></label>

               <%
		
		break; 
		
	case 8:
		if(serie10 > -1){
		var Existencia1 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie1+"'",-1,0) 
		var Existencia2 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie2+"'",-1,0) 
		var Existencia3 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie3+"'",-1,0) 
		var Existencia4 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie4+"'",-1,0) 
		var Existencia5 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie5+"'",-1,0) 
		var Existencia6 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie6+"'",-1,0) 
		var Existencia7 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie7+"'",-1,0) 
		var Existencia8 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie8+"'",-1,0) 
		var Existencia9 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie9+"'",-1,0) 
		var Existencia10 = BuscaSoloUnDato("Ser_ID","Recepcion_Series","Ser_Serie = '"+serie10+"'",-1,0) 

		if(Existencia1 > -1){
			result = 0
			message += "Error: la serie "+serie1+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia2 > -1){
			result = 0
			message += "Error: la serie "+serie2+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia3 > -1){
			result = 0
			message += "Error: la serie "+serie3+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia4 > -1){
			result = 0
			message += "Error: la serie "+serie4+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia5 > -1){
			result = 0
			message += "Error: la serie "+serie5+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia6 > -1){
			result = 0
			message += "Error: la serie "+serie6+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia7 > -1){
			result = 0
			message += "Error: la serie "+serie7+" ya fue escaneada anteriormente </br>"
			
		}
		if(Existencia8 > -1){
			result = 0
			message += "Error: la serie "+serie8+" ya fue escaneada anteriormente </br>"
			
		}if(Existencia9 > -1){
			result = 0
			message += "Error: la serie "+serie9+" ya fue escaneada anteriormente </br>"
			
		}
		
		if(Existencia10 > -1){
			result = 0
			message += "Error: la serie "+serie10+" ya fue escaneada anteriormente </br>"
			
		}
			if((Existencia1 == -1) && (Existencia2 == -1) && (Existencia3 == -1) && (Existencia4 == -1) && (Existencia5 == -1) && (Existencia6 == -1) && (Existencia7 == -1) && (Existencia8 == -1) && (Existencia9 == -1) && (Existencia10 == -1)){
		
		
			var Ser_ID = SiguienteID("Ser_ID","Recepcion_Series","Pt_ID = "+Pt_ID,0)
		
			var sSQLTr1 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr1  += " VALUES("+Pt_ID+","+Ser_ID+","+MB+",'"+serie1+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
			
			var sSQLTr2 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr2  += " VALUES("+Pt_ID+","+Ser_ID+1+","+MB+",'"+serie2+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
			
			var sSQLTr3 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr3  += " VALUES("+Pt_ID+","+Ser_ID+2+","+MB+",'"+serie3+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
			
			var sSQLTr4 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr4  += " VALUES("+Pt_ID+","+Ser_ID+3+","+MB+",'"+serie4+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
			
			var sSQLTr5 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr5  += " VALUES("+Pt_ID+","+Ser_ID+4+","+MB+",'"+serie5+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
					
			var sSQLTr6 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr6  += " VALUES("+Pt_ID+","+Ser_ID+5+","+MB+",'"+serie6+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
					
			var sSQLTr7 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr7  += " VALUES("+Pt_ID+","+Ser_ID+6+","+MB+",'"+serie7+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
				
			var sSQLTr8 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr8  += " VALUES("+Pt_ID+","+Ser_ID+7+","+MB+",'"+serie8+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
					
			var sSQLTr9 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr9  += " VALUES("+Pt_ID+","+Ser_ID+8+","+MB+",'"+serie9+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
					
			var sSQLTr10 = "INSERT INTO Recepcion_Series(Pt_ID, Ser_ID, Ser_MB, Ser_Serie, Ser_Pallet, Pro_ID, CliEnt_ID, Ser_SerieEscaneada)  "
			sSQLTr10  += " VALUES("+Pt_ID+","+Ser_ID+9+","+MB+",'"+serie10+"',"+Pallet+","+Pro_ID+","+CliEnt_ID+",1)"
	
if(Ejecuta(sSQLTr1,0) && Ejecuta(sSQLTr2,0) && Ejecuta(sSQLTr3,0) && Ejecuta(sSQLTr4,0) && Ejecuta(sSQLTr5,0) && Ejecuta(sSQLTr6,0) && Ejecuta(sSQLTr7,0) && Ejecuta(sSQLTr8,0) && Ejecuta(sSQLTr9,0) && Ejecuta(sSQLTr10,0)){

	
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

				result = 2
				message = "Masterbox terminado"

			}else{
				result = 1
				message = "Series escaneadas"
			}
			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
			

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
					if(result != 0){
						result = 3
						message = "Pallet terminado"	
					}
				}	
		}else{
			result = 0
				message = "Error en etiqueta, favor de verificar"
		}
	Respuesta = '{"result":'+result+',"message":"'+message+'"}'
		

	break;
 }
Response.Write(Respuesta)
%><%/*%>
<script type="text/javascript">

</script><%*/%>