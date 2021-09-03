<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  

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
	var Pt_Ubicacion = Parametro("Pt_Ubicacion", -1)
	var Pt_Pallet = Parametro("Pt_Pallet", -1)
	var Pro_SKU = Parametro("Pro_SKU", "")
	var Cantidad_MB =  parseInt(Parametro("CliEnt_CantidadArticulos",-1))
var Cantidad_Pallet =  parseInt(Parametro("CliEnt_CantidadPallet",-1))

	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
				
					if(Cantidad_Pallet>0 && Cantidad_MB>0){
						if(CliOC_ID>-1){
				sSQL = "SELECT ASN_ID FROM Cliente_OrdenCompra_Entrega WHERE IR_ID = "+ IR_ID
						var rsASN = AbreTabla(sSQL,1,0)
						var ASN = rsASN.Fields.Item("ASN_ID").Value
						}else{
						var ASN = -1	
						}
							sSQL = "SELECT Ubi_ID FROM Ubicacion WHERE Ubi_Nombre = '"+ Pt_Ubicacion + "'"
						var rsUbi = AbreTabla(sSQL,1,0)
						if(rsUbi.EOF==false){
						var Ubi_ID = rsUbi.Fields.Item("Ubi_ID").Value
						}else{
						var Ubi_ID = 0	
						}
		 sSQL = " INSERT INTO Recepcion_Pallet (Pt_Pallet, OC_ID, Prov_ID,CliOC_ID,TA_ID, Cli_ID, IR_ID,  Pro_ID, Pt_SKU, Pt_Modelo, "
		 sSQL += " Pt_Color,Pt_Cantidad,Pt_LPN, Pt_LPNCliente, Pt_Ubicacion, Ubi_ID, ASN_ID)  VALUES ("+Pt_Pallet+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +"," +TA_ID+", " 
		sSQL += Cli_ID+", " +IR_ID+ ","+Pro_ID+", '"+Pt_SKU+"', '"+Pt_Modelo+ "','" +Pt_Color+"', "+Pt_Cantidad+",'"+Pt_LPN2+"', '"+Pt_LPN+"', '"+Pt_Ubicacion+"', "+Ubi_ID+", "+ASN+")"

						Ejecuta(sSQL, 0)
            sSQL = "UPDATE  Cliente_OrdenCompra_EntregaProducto SET	"									
						 + "CliEnt_CantidadArticulos="+Cantidad_MB+", CliEnt_CantidadPallet="+Cantidad_Pallet+" WHERE Cli_ID = " + Cli_ID + " AND CliOC_ID = "   
						 + CliOC_ID+"  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID 
						
						  Ejecuta(sSQL,0)
					}
	

		break;  
		case 2:	
			
			var sSQL = "SELECT  Pro_ID, Pro_Nombre, Pro_SKU  "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ Pro_SKU + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
			
				%>
                <label class="control-label" id= "Pt_SKU"><strong><%=rsPro.Fields.Item("Pro_SKU").Value%></strong></label>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_Nombre").Value%>" id="Pt_Modelo"/>
                <input type="hidden" value="<%=rsPro.Fields.Item("Pro_ID").Value%>" id="Pro_ID"/>

               <%
		
		break; 
		 
  
	}

%>
