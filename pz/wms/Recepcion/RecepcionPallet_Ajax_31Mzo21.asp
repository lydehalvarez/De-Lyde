<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var Pt_ID =  Parametro("Pt_ID",-1)
	var Pt_SKU =  Parametro("Pt_SKU","")
	var Pt_Modelo = Parametro("Pt_Modelo","")
	var Pt_Color = Parametro("Pt_Color","")
	var Pt_Cantidad = Parametro("Pt_Cantidad",-1)
	var Pt_LPN = Parametro("Pt_LPN","")
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

	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
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
		 sSQL += " Pt_Color,Pt_Cantidad,Pt_LPN, Pt_LPNCliente, Pt_Linea, ASN_ID, Pt_Ubicacion, Ubi_ID, Pt_MB)  VALUES ("+Pt_Pallet+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +"," +TA_ID+", " +Cli_ID+", " +IR_ID+ ","+Pro_ID+", '"+Pt_SKU+"', '"+Pt_Modelo+ "','" +Pt_Color+"', "+Pt_Cantidad+",'"+Pt_LPN2+"', '"+Pt_LPN+"', "+Pt_Linea+", "+ASN+", '"+Pt_Ubicacion+"', "+Ubi_ID+", "+Cantidad_MB+")"
						Ejecuta(sSQL, 0)
						if(Digitos > 1){
						    sSQL = "UPDATE  Producto SET  Pro_SerieDigitos = "+Digitos+" WHERE Pro_ID = " + Pro_ID 
							  Ejecuta(sSQL,0)
	
						}
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
			
			var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU, Pro_EsSerializado  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
				var sChecked =""
			if(rsPro.Fields.Item("Pro_EsSerializado").Value == 0){
			 sChecked = "checked='checked'"
			}
				%>
                <label class="control-label" id= "Pt_SKU"><strong><%=rsPro.Fields.Item("Pro_SKU").Value%></strong></label>
          	     <input type="checkbox"  class="i-checks ChkSerial" <%=sChecked%> onclick="javascript:ActualizaSerial(<%=rsPro.Fields.Item("Pro_ID").Value%>)" > No serializado
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_Nombre").Value%>" id="Pt_Modelo"/>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_ID").Value%>" id="Pro_ID"/>

               <%
		
		break; 
		 case 3:
		 		var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
			var Pro_ID = rsPro.Fields.Item("Pro_ID").Value
			
		 	var sSQL = "SELECT Pro_SerieAlfanumerico FROM Producto WHERE Pro_ID="+Pro_ID
							var rsPro = AbreTabla(sSQL,1,0)
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
	break;
	  case 6:
		    sSQL = "UPDATE Producto SET Pro_EsSerializado= "+Inserializar+" WHERE Pro_ID = " + Pro_ID 
			  Ejecuta(sSQL,0)
	break;
	}

%>
<script>

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