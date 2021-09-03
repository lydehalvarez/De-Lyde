<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var Pt_ID =  Parametro("Pt_ID",-1)
	var Pt_SKU =  Parametro("Pt_SKU","")
	var Pt_Modelo = Parametro("Pt_Modelo","")
	var Pt_Color = Parametro("Pt_Color","")
	var Pt_Cantidad = Parametro("Pt_Cantidad",-1)
	var Pt_CantidadEsperada = Parametro("Pt_CantidadEsperada",-1)
	var Pt_LPN = Parametro("Pt_LPN","")
	var Pt_LPNCliente = Parametro("Pt_LPNCliente","")
	var Pt_LPN2 = Parametro("Pt_LPN2","")
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var IR_ID = Parametro("IR_ID", -1)
	var Pt_Linea = Parametro("Pt_Linea", -1)
	var Pt_Ubicacion = Parametro("Pt_Ubicacion", "")
	var Pt_Pallet = Parametro("Pt_Pallet", -1)
	var Digitos = Parametro("Digitos", -1)
	var Pro_SKU = Parametro("Pro_SKU", "")
	var Alfnum = Parametro("Alfnum", -1)
	var Inserializar = Parametro("Inserializar", -1)
	var Cantidad_MB =  parseInt(Parametro("CliEnt_CantidadArticulos",-1))
	var Cantidad_Pallet =  parseInt(Parametro("CliEnt_CantidadPallet",-1))
 	var DigitosRFID = Parametro("DigitosRFID", -1)
	var Pro_Insumo = Parametro("Pro_Insumo", -1)
	var IDUsuario = Parametro("IDUsuario", -1)
	var Pro_ID_RFID = Parametro("Pro_ID_RFID",-1)
	var ProM_ID = Parametro("ProM_ID",-1)
	var RFID = Parametro("RFID",-1)
	var Pro_TipoProductoCG70 = Parametro("Pro_TipoProductoCG70",-1)
	
	var Ubi_Nombre = Parametro("Ubi_Nombre","")
	var Ubi_ID = Parametro("Ubi_ID",-1)
	var Pro_ID_RFID = Parametro("Pro_ID_RFID",-1)
	var CantidadPallets = Parametro("CantidadPallets",1)
	var Pt_PiezaXMB = Parametro("Pt_PiezaXMB",1)
	var Pt_MB = Parametro("Pt_MB",1)
	var Pt_EsCuarentena = Parametro("Pt_EsCuarentena",1)

	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
			
		if(Pro_TipoProductoCG70 >0){
			sSQL = "UPDATE Producto SET TPro_ID  = "+Pro_TipoProductoCG70+" WHERE  Pro_ID="+ Pro_ID
			Ejecuta(sSQL,0)
		}
		if(Pt_Ubicacion != ""){
						sSQL = "SELECT Ubi_ID FROM Ubicacion WHERE Ubi_Nombre = '"+ Pt_Ubicacion + "'"
	
						var rsUbi = AbreTabla(sSQL,1,0)
						var Ubi_ID = rsUbi.Fields.Item("Ubi_ID").Value
		}
		else
		{
		var Ubi_ID = -1	
		}
					if(Cantidad_Pallet>0 && Cantidad_MB>0){
						if(CliOC_ID>-1){
				sSQL = "SELECT ASN_ID FROM Cliente_OrdenCompra_Entrega WHERE IR_ID = "+ IR_ID
						var rsASN = AbreTabla(sSQL,1,0)
						var ASN = rsASN.Fields.Item("ASN_ID").Value
						}else{
						var ASN = -1	
						}
		 sSQL = " INSERT INTO Recepcion_Pallet (Pt_Pallet, OC_ID, Prov_ID,CliOC_ID,TA_ID, Cli_ID, IR_ID,  Pro_ID, Pt_SKU, Pt_Modelo, "
		 sSQL += " Pt_Color,Pt_Cantidad,Pt_CantidadEsperada, Pt_LPN, Pt_LPNCliente, Pt_Linea, ASN_ID, Pt_Ubicacion, Ubi_ID, Pt_MB, Pro_ID_RFID, ProM_ID)  VALUES ("+Pt_Pallet+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +"," +TA_ID+", " +Cli_ID+", " +IR_ID+ ","+Pro_ID+", '"+Pt_SKU+"', '"+Pt_Modelo+ "','" +Pt_Color+"', "+Pt_Cantidad+", "+Pt_CantidadEsperada+",'"+Pt_LPN2+"', '"+Pt_LPN+"', "+Pt_Linea+", "+ASN+", '"+Pt_Ubicacion+"', "+Ubi_ID+", "+Cantidad_MB+", "+Pro_ID_RFID+", "+ProM_ID+")"
						//Response.Write(sSQL)
						Ejecuta(sSQL, 0)
						
						if(Digitos > 1){
						    sSQL = "UPDATE  Producto SET  Pro_SerieDigitos = "+Digitos+" WHERE Pro_ID = " + Pro_ID 
							  Ejecuta(sSQL,0)
	
						}
			//				if(DigitosRFID > 1){
//								    sSQL = "UPDATE Producto SET Pro_RFID_Digitos= "+DigitosRFID+" , WHERE Pro_ID = " + Pro_ID 
//			  						Ejecuta(sSQL,0)
//							}
								    sSQL = "UPDATE Producto SET Pro_Surtido= Pro_Surtido + "+Pt_Cantidad+" WHERE Pro_ID =" + Pro_Insumo
			  						Ejecuta(sSQL,0)
									sSQL= "SELECT CONVERT(VARCHAR(17), getdate(), 111) AS Hoy,  CONVERT(VARCHAR(8),  getdate(), 108) AS Hora"
									var rsFecha =  AbreTabla(sSQL,1,0) 
									var ProM_Fecha = rsFecha.Fields.Item("Hoy").Value
									var ProM_Hora = rsFecha.Fields.Item("Hora").Value
							
								var sSQL="EXEC SPR_Producto_Movimiento @Opcion=2000, @Pro_ID="+Pro_ID+",  @Cli_ID="+Cli_ID+", @ProM_TipoCG170=2, "
												+	"@ProM_Fecha='"+ProM_Fecha+"  "+ ProM_Hora+"',"
									 				+" @ProM_Cantidad="+Pt_Cantidad+", @ProM_LPN= '"+Pt_LPN2+"', @ProM_IDUsuario="+IDUsuario+", @CliOC_ID="+CliOC_ID+" , "
													+" @CliEnt_ID="+CliEnt_ID
													//Response.Write(sSQL)
									// AbreTabla(sSQL,1,0) 
 
						if (Cli_ID > -1){
            			 sSQL = "UPDATE  Cliente_OrdenCompra_EntregaProducto SET	"									
						 + "CliEnt_CantidadArticulos="+Cantidad_MB+", CliEnt_CantidadPallet="+Cantidad_Pallet+" WHERE Cli_ID = " + Cli_ID + " AND CliOC_ID = "   
						 + CliOC_ID+"  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID 
						
						  Ejecuta(sSQL,0)
						}else{
						 sSQL = "UPDATE  Proveedor_OrdenCompra_Articulos SET	"									
						 + "OCP_CantidadMB="+Cantidad_MB+" WHERE Prov_ID = " + Prov_ID + " AND OC_ID = "   
						 + OC_ID+"  AND Pro_ID =" + Pro_ID 
						
						  Ejecuta(sSQL,0)
						}
					}
	

		break;  
		case 2:	
			
			var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU, Pro_EsSerializado,Pro_RFIDCG160, Pro_TipoProductoCG70  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
				var sChecked =""
			if(rsPro.Fields.Item("Pro_EsSerializado").Value == 0){
			 sChecked = "checked='checked'"
			}
						var RFID = rsPro.Fields.Item("Pro_RFIDCG160").Value

				%>
                <label class="control-label col-md-3" id= "Pt_SKU"><strong><%=rsPro.Fields.Item("Pro_SKU").Value%></strong></label>
                   <div class="col-md-6">
           	     		<input type="checkbox"  class="i-checks ChkSerial" <%=sChecked%> onclick="javascript:ActualizaSerial(<%=rsPro.Fields.Item("Pro_ID").Value%>)" > No serializado
					</div>
<%
   			var sChecked =""
			if(rsPro.Fields.Item("Pro_RFIDCG160").Value == 1){
			 sChecked = "checked='checked'"
			}
%>
                 <div class="col-md-3">
    	     		<input type="checkbox"  class="i-checks ChkRFID" <%=sChecked%> onclick="javascript:ActualizaRFID(<%=rsPro.Fields.Item("Pro_ID").Value%>)" >RFID
				</div>

    <%
		if(RFID>0){
		%>   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <label class="control-label col-md-3"><strong>Etiqueta RFID</strong></label>
                <div class="col-md-6">
                <select id="cboEtiqueta" class="form-control">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
    			<%
				
					var sSQL = "SELECT * FROM Producto  WHERE Pro_EsInsumo=1 AND TPro_ID= 15  AND Pro_Habilitado =1 AND Pro_Disponible > 0"
           // Response.Write(sSQL)
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
				</div>
<%
		}
		%>
          <%
			if(rsPro.Fields.Item("Pro_EsSerializado").Value == 0){
		%>   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <label class="control-label col-md-3"><strong>Folio etiquetas</strong></label>
                <div class="col-md-3">
                      <input class="form-control agenda col-md-3" id="ProM_ID" placeholder="" autocomplete="off" value=""/> 

				</div>
				 
<%
		}
				if(rsPro.Fields.Item("Pro_TipoProductoCG70").Value == 0){

		%>
			 <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
        <label class="control-label col-md-3"><strong>Tipo Producto</strong></label>
                <div class="col-md-3">
					<%
			    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    			var sCondicion = " Sec_ID = 70 " 

 CargaCombo("cbo_TipoProductoCG70", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", 0, 0, "Seleccionar", "Editar")
		%>
				</div>

<%
		}
%>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_Nombre").Value%>" id="Pt_Modelo"/>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_ID").Value%>" id="Pro_ID"/>

        <%
		break; 
		 case 3:
		 		var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU, Pro_SerieAlfanumerico  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
			var Pro_ID = rsPro.Fields.Item("Pro_ID").Value
			var sChecked =""
			if(rsPro.Fields.Item("Pro_SerieAlfaNumerico").Value == 1){
			 sChecked = "checked='checked'"
			}
%>
    	     <input type="checkbox"  class="i-checks ChkAlf" <%=sChecked%> onclick="javascript:ActualizaProd(<%=Pro_ID%>)" >IMEI alfanumerico
	<%
 break;

  case 4:
		    sSQL = "UPDATE Producto SET  Pro_SerieAlfanumerico = "+Alfnum+" WHERE Pro_ID = " + Pro_ID 
			  Ejecuta(sSQL,0)
	break;
	case 5:
		    sSQL = "DELETE FROM Recepcion_Pallet WHERE Pt_ID = " + Pt_ID 
			  Ejecuta(sSQL,0)
			 sSQL = "DELETE FROM Recepcion_Series WHERE Pt_ID = " + Pt_ID 
			  Ejecuta(sSQL,0)
	break;
	  case 6:
			if(Inserializar ==0){
			  sSQL = "UPDATE Producto SET Pro_EsSerializado= "+Inserializar+", Pro_RFIDCG160 = 0  WHERE Pro_ID = " + Pro_ID 
			  Ejecuta(sSQL,0)
			}else{
		    sSQL = "UPDATE Producto SET Pro_EsSerializado= "+Inserializar+" WHERE Pro_ID = " + Pro_ID 
			  Ejecuta(sSQL,0)
			}
	break;
 	  
	  case 7:
		 		var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU,  TPro_ID  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				var rsPro = AbreTabla(sSQL,1,0)
			
				if(rsPro.Fields.Item("TPro_ID").Value == 2){
					%>
                <label class="control-label col-md-3"><strong>Serie inicial</strong></label>
                <div class="col-md-3">
                
                    <input class="form-control agenda" id="Serie1" placeholder="" autocomplete="off" value=""/> 
       		    </div>
                
                <label class="control-label col-md-3"><strong>Serie final</strong></label>
                	<div class="col-md-3">
                <input class="form-control agenda" id="Serie2" placeholder="" autocomplete="off" value=""/> 
         
               </div>

                    <%
				}
	 break;

	case 8:
			 sSQL = "UPDATE  Cliente_OrdenCompra_EntregaProducto SET	"									
						 + "CliEnt_EntregaCancelada=1 WHERE Cli_ID = " + Cli_ID 
						 + " AND CliOC_ID = " + CliOC_ID+"  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID 
						Response.Write(sSQL)
					  Ejecuta(sSQL,0)	
	break;
	case 9:
		sSQL = "UPDATE Producto SET Pro_RFIDCG160= "+RFID+" WHERE Pro_ID = " + Pro_ID 
		Ejecuta(sSQL,0)
	break;
	case 10: // ROG Jr.- 13/07/2021 Agrega pallets 
	
		var result = -1
		var message = "Ocurri&oacute; un error"
		var data = null
		
		if(CantidadPallets >= 1 && CantidadPallets <= 25 ){
			for(var i = 0;i<CantidadPallets;i++){
				var Insert = " INSERT INTO Recepcion_Pallet (Pt_Pallet, OC_ID, Prov_ID ,CliOC_ID, TA_ID , Cli_ID, IR_ID, Pro_ID, Pt_SKU, Pt_Modelo, Pt_Color ,Pt_Cantidad,Pt_CantidadEsperada, Pt_LPN, Pt_LPNCliente, Pt_Linea ,ASN_ID, Pt_Ubicacion, Ubi_ID, Pt_MB, Pro_ID_RFID, ProM_ID,Pt_Usuario,Pt_PiezaXMB,Pt_EsCuarentena) "
							+ " SELECT (SELECT ISNULL(MAX(Pt_Pallet),0)+1 FROM Recepcion_Pallet WHERE IR_ID = c.IR_ID) as Pt_Pallet "
							+ ",c.OC_ID,c.Prov_ID,a.CliOC_ID,c.TA_ID "
							+ ",c.Cli_ID,c.IR_ID,d.Pro_ID "
							+ ",Pro_SKU as Pt_SKU "
							+ ",Pro_Nombre as Pt_Modelo "
							+ ",'"+Pt_Color+"' as Pt_Color "
							+ ","+Pt_Cantidad+" as Pt_Cantidad "
							+ ","+Pt_CantidadEsperada+" as Pt_CantidadEsperada "
							+ ",SUBSTRING(Cli_Nombre,1,3) +c.IR_Folio+'LPN'+ right('0000' + CONVERT(NVARCHAR(10),(SELECT ISNULL(MAX(Pt_Pallet),0)+1 FROM Recepcion_Pallet WHERE IR_ID = c.IR_ID)),4) Pt_LPN "
							+ ",'"+Pt_LPNCliente+"' as Pt_LPNCliente "
							+ ", -1 as Pt_Linea "
							+ ",f.ASN_ID "
							+ ",'"+Ubi_Nombre+"' as Pt_Ubicacion "
							+ ","+Ubi_ID+" as Ubi_ID "
							+ ","+Pt_MB+" as Pt_MB "
							+ ","+Pro_ID_RFID+" Pro_ID_RFID "
							+ ",-1 as ProM_ID "
							+ ","+IDUsuario+" as Pt_Usuario "
							+ ","+Pt_PiezaXMB+" as Pt_PiezaXMB "
							+ ","+Pt_EsCuarentena+" as Pt_EsCuarentena "
							+ " FROM Cliente_OrdenCompra_Entrega a, Cliente_OrdenCompra_EntregaProducto b, Inventario_Recepcion c "
							+ " ,Producto d, Cliente e, ASN f "
							+ " WHERE c.IR_ID = "+IR_ID
							+ " AND c.IR_ID = a.IR_ID "
							+ " AND c.IR_ID = f.IR_ID "
							+ " AND c.Cli_ID = e.Cli_ID " 
							+ " AND a.Cli_ID = b.Cli_ID  "
							+ " AND a.CliOC_ID = b.CliOC_ID  "
							+ " AND a.CliEnt_ID = b.CliEnt_ID  "
							+ " AND b.Pro_ID =  "+ Pro_ID
							+ " AND b.Pro_ID = d.Pro_ID "
				
					if(Ejecuta(Insert,0))
					{
						result = 1
						message = "Pallet agregado correctamente"	
						data = Insert 
						//data = null 
					}
			}
		}else{
			result = -1
			message = "Lo sentimos, no se permite crear menos de 1 de pallet y no m&aacute;s de 25 "	+CantidadPallets
			data = null
		}
		var respuesta = '{"result":'+result+',"message":"'+message+'","data":"'+data+'"}'
		Response.Write(respuesta)

	break;
	case 11: // ROG Jr.- 13/07/2021 Borrar Pallet
	
		var Pt_ID = Parametro("Pt_ID",-1)
				
		var result = -1
		var message = "Ocurri&oacute; un error"
		//var data = Insert
		if(Pt_ID > -1){
			
			var sSQL = "SELECT ISNULL(COUNT(*),0) Total  FROM Recepcion_Series WHERE Ser_SeIngreso = 1 AND Pt_ID = "+Pt_ID
			var rsPt = AbreTabla(sSQL,1,0)
			var Total = 0
			if(!rsPt.EOF){
				Total = rsPt.Fields.Item("Total").Value 
			}

			if(Total == 0){
				var BorraPallet_Contenido = "DELETE FROM Recepcion_Series WHERE Pt_ID = "+ Pt_ID
				
				if(Ejecuta(BorraPallet_Contenido,0)){
					
					var BorraPallet = "DELETE FROM Recepcion_Pallet WHERE Pt_ID = "+ Pt_ID
					if(Ejecuta(BorraPallet,0))
					{
						result = 1
						message = "Pallet eliminado correctamente!!"	
						data = null
					}
				}
			}else{
				result = -1
				message = "Lo sentimos, ya hay "+Total+" series ingresadas, no se puede eliminar el pallet"	
				data = null
			}
		}else{
			result = -1
			message = "Pallet no encontrado, verifica la info"	
		}

		var respuesta = '{"result":'+result+',"message":"'+message+'","data":"'+Insert+'"}'
		Response.Write(respuesta)

	break;
	case 12: // ROG Jr.- 16/07/2021 Editar Pallet
	
		var Pt_ID = Parametro("Pt_ID",-1)
				
		var result = -1
		var message = "Ocurri&oacute; un error"
		var data = "null"
		//var data = Insert
		if(Pt_ID > -1){
			var EditarPallet = "UPDATE Recepcion_Pallet "
							+ " SET Pt_Color = '"+Pt_Color+"'"
							+ " , Pt_LPNCliente = '"+Pt_LPNCliente+"'"
							+ " , Pt_MB = "+Pt_MB
							+ " , Pt_PiezaXMB = "+Pt_PiezaXMB
							+ " , Pt_Ubicacion = '"+Pt_Ubicacion+"'"
							+ " , Ubi_ID = "+Ubi_ID
							+ " , Pt_Cantidad = "+Pt_Cantidad
							+ " , Pt_CantidadEsperada = "+Pt_CantidadEsperada
							+ " , Pt_EsCuarentena = "+Pt_EsCuarentena
							+ " , Pro_ID_RFID = "+Pro_ID_RFID
							+ " WHERE Pt_ID = "+ Pt_ID
							
			if(Ejecuta(EditarPallet,0))
			{
				result = 1
				message = "Pallet actualizado correctamente!!"	
				//data = EditarPallet
				data = null
			}else{
				data = EditarPallet
			}
		}else{
			result = -1
			message = "Pallet no encontrado, verifica la info"	
		}

		var respuesta = '{"result":'+result+',"message":"'+message+'","data":"'+data+'"}'
		Response.Write(respuesta)

	break;

}

if(parseInt(Tarea) < 10){%>
<script>

 function ActualizaRFID(proid){
	  if($(".ChkRFID").is(':checked')){
	  	var RFID =1
	  }else{
	  	var RFID =0  
	  }
	// var ckd = (Checado==true) ? 1 : 0;
	
	$.post("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
		  , { Tarea:9,Pro_ID:proid,RFID:RFID}
		  , function () {
			var sMensaje = "El registro ha sido actualizado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
		}
		
		 function ActualizaProd(proid){
			   if($(".ChkAlf").is(':checked')){
	  var Alfnum =1
	  }else{
	  var Alfnum =0  
 }
	// var ckd = (Checado==true) ? 1 : 0;
	
	$.post("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
		  , { Tarea:4,Pro_ID:proid,Alfnum:Alfnum}
		  , function () {
			var sMensaje = "El registro ha sido actualizado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
		}
		 function ActualizaSerial(proid){
			   if($(".ChkSerial").is(':checked')){
	  var Inserializar =0
	  }else{
	  var Inserializar =1  
 }
	// var ckd = (Checado==true) ? 1 : 0;
	
	$.post("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
		  , { Tarea:6,Pro_ID:proid,Inserializar:Inserializar}
		  , function () {
			var sMensaje = "El producto ha sido actualizado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
		}

		</script>
 <%}%>