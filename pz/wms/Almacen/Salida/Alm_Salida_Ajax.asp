<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%

var Tarea = Parametro("Tarea",0)
var Folio = Parametro("Folio","")
var EsOV = Parametro("EsOV",-1)
var Guia = Parametro("OV_TRACKING_NUMBER","")
var Transportista = Parametro("OV_TRACKING_COM","")

var IDUsuario = Parametro("IDUsuario",-1)
var OV_ID = Parametro("OV_ID",-1)

 
var sResultado = ""
var result = ""
var message = "" 
var data = ""

switch (parseInt(Tarea)) {
		case 1:	
		var sSQL = ""
			try { 
				var ID = -1
				var EsOV = 1
				ID = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Folio = '"+Folio+"'",-1,0)
				 
				if(ID == -1){
					EsOV = 0
					ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+Folio+"'",-1,0)
				}
				
				if(EsOV == 1){
					sSQL = "SELECT OV_ID as ID,ISNULL(OV_CP,'') AS CP,OV_EstatusCG51 Estatus, Cli_ID as Cliente "
					sSQL += " FROM Orden_Venta " 
					sSQL += " WHERE OV_ID = " + ID
				}else{
					sSQL = "SELECT TA_ID as ID,TA_EstatusCG51 Estatus,Cli_ID as Cliente "
					sSQL += ", (SELECT ISNULL(Alm_CP,'') FROM Almacen WHERE Alm_ID = TA_End_Warehouse_ID) as CP " 
					sSQL += " FROM TransferenciaAlmacen " 
					sSQL += " WHERE TA_ID = " + ID
				}
				 
			    var rsACT = AbreTabla(sSQL,1,0)
				
				if (!rsACT.EOF){
					var ID  = rsACT.Fields.Item("ID").Value
					var CP  = rsACT.Fields.Item("CP").Value
					var Estatus  = rsACT.Fields.Item("Estatus").Value
					var Cliente  = rsACT.Fields.Item("Cliente").Value
					
					if(CP != ""){
						if(Estatus == 3){
						var Destino = BuscaSoloUnDato("ProvCP_EnviaASucursal","Proveedor_CPSucursal","cast(ProvCP_CP as int) = cast('"+CP+"' as int) ","N/A",0)
							result = 1
							message = "Registro encontrado"
							data = '{"ID":'+ID+',"Destino":"'+Destino+'","EsOV":'+EsOV+',"Cliente":'+Cliente+'}'
						}else{
							result = -1
							message = "Lo sentimos se debe de poner en packing para cargar una gu&iacute;a nueva"
						}
					}else{
						result = -1
						message = "Error en CP"
					}
			    }else{
					result = -1
					message = "Registro no encontrado"
					data = '{"ID":"Folio no encontrado"}'
				}
				
			} catch(err) {
					result = -2
					message = "Error en el try"
			}
			sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'	
		break;
		case 2:	
			try {  
				var GuiaAsignada = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_ID = "+OV_ID+" AND OV_TRACKING_NUMBER = '"+Guia+"'",-1,0) 
								
				if(GuiaAsignada == -1){
				var UpSQL = "UPDATE Orden_Venta "
					UpSQL += " SET OV_TRACKING_NUMBER = '"+Guia+"'" 
					UpSQL += " ,OV_TRACKING_COM = '"+Transportista+"'" 
					UpSQL += " ,OV_UsuarioCambioEstatus = " +IDUsuario
					UpSQL += " WHERE OV_ID = " + OV_ID

					Ejecuta(UpSQL,0)
					
					result = 1
					message = "Registro colocado "+Folio
				}else{
					result = -1
					message = "Lo sentimos esa guia ya fue cargada a este folio"
				}
				
			} catch(err) {
					result = -1
					message = "Error en servidor "+Folio
			}
			sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'	
		break;
		case 3:	
			try {  
				var TA_ID = Parametro("TA_ID",-1)
				
				
				var GuiaAsignada = BuscaSoloUnDato("TA_Guia","TransferenciaAlmacen","TA_ID = "+TA_ID,"",0) 
								
				if(GuiaAsignada == ""){
				
					var UpSQL = "UPDATE TransferenciaAlmacen "
						UpSQL += " SET TA_Guia = '"+Guia+"'" 
						UpSQL += " ,TA_Transportista = '"+Transportista+"'" 
						UpSQL += " ,TA_EstatucCG51 = 4 " 
						UpSQL += " WHERE TA_ID = " + TA_ID
	
					Ejecuta(UpSQL,0)
					
					result = 1
					message = "Ahora la gu&iacute;a esta en transito"

				}
			} catch(err) {
					result = -1
					message = "Error en servidor TA_ID = "+TA_ID
			}
			sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'	
		break;
		case 4:
			var accionTipo = 0
			var IDOV = -1
			var IDTA = -1
			
				if(EsOV == 1){ 
				    sSQLACT = "SELECT OV_ID as ID "
					sSQLACT += " FROM Orden_Venta " 
					sSQLACT += " WHERE OV_Folio = '" +Folio+"'"
					
					var rsACT = AbreTabla(sSQLACT,1,0)
					
					if (!rsACT.EOF){
						var IDOV = rsACT.Fields.Item("ID").Value
					}
					
					accionTipo = 11
				}else{
				    sSQLACT = "SELECT TA_ID as ID "
					sSQLACT += " FROM TransferenciaAlmacen " 
					sSQLACT += " WHERE TA_Folio = '"+Folio+"'"
					
					var rsACT = AbreTabla(sSQLACT,1,0)
					
					accionTipo = 10
					
					if (!rsACT.EOF){
						var IDTA  = rsACT.Fields.Item("ID").Value
					}
				}
				
				
				
			var sigAcc = "dbo.fn_Accion_DameSiguienteID(1,"+accionTipo+")"

			var sInsertTarea = "INSERT INTO ACCION (Acc_Familia, Acc_Tipo, Acc_ID, OV_ID,TA_ID) "
				sInsertTarea += " VALUES ( 1, "+accionTipo+", "+sigAcc+", "+IDOV+","+IDTA+")"
				
				Ejecuta(sInsertTarea,0)

			
		break;
		case 5:
			%>
             <div class="form-group divGuias">
                <label class="control-label col-md-3">Pedido SO</label>
                <div class="col-md-4">
                    <input class="form-control FolioDHL" data-ov="1" style="color: black;"  placeholder="Ingrese el folio" type="text" value=""/><br>
                    <small id="MensajeDHL"></small>
                </div>
                <div class="col-md-4">
                    <input class="btn btn-success" type="button" value="Impirmir gu&iacute;a"/>
                </div>
            </div>
            <script type="application/javascript">
				$('.FolioDHL').on('keypress',function(e) {
					if(e.which == 13) {	
					var Folio =  FuncionGuia.FolioBienEscrito($(this).val())
				
					$(this).prop('disabled',true)
						if(Folio != ""){ 
							DHLEjecutor.GetPedidoID(Folio,$(this))
						}else{
							var sTipo = "error";   
							var sMensaje = "Sin dato";
							Avisa(sTipo,"Aviso",sMensaje);			
						}
					}
				});
			</script>
            <%
			
		break;
		case 6:
			var Folio = Parametro("Folio",-1)

			var ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+Folio+"'",-1,0)
			var Estatus = BuscaSoloUnDato("TA_EstatusCG51","TransferenciaAlmacen","TA_Folio = '"+Folio+"'",-1,0)
			message = "Es transferencia"
			
			if(ID == -1){
				ID = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Folio = '"+Folio+"'",-1,0)
				Estatus = BuscaSoloUnDato("OV_EstatusCG51","Orden_Venta","OV_Folio = '"+Folio+"'",-1,0)
				message = "Es orden de venta"
			}
			if(Estatus < 5){
				result = 1
				data = ID
			}else{
				result = -1
				message = "Se debe de mandar a Packing"
			}

			sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'	
		break;
		case 7:
			var Folio = Parametro("Folio",-1)
			try {  
				
				var EsOV = 0
				var BuscaFolio = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+Folio+"'",-1,0) 
						
				if(BuscaFolio == -1){
					
					BuscaFolio = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Folio = '"+Folio+"'",-1,0)
					EsOV = 1
				}
				
				if(BuscaFolio > -1){		
					if(EsOV == 0){
					
						var UpSQL = "UPDATE TransferenciaAlmacen "
							UpSQL += " SET TA_EstatusCG51 = 4 " 
							UpSQL += " , TA_UltimoUsuarioModifico =  " +IDUsuario
							UpSQL += " WHERE TA_ID = " + BuscaFolio
							
						BuscaFolioInterno = BuscaSoloUnDato("TA_Guia","TransferenciaAlmacen","TA_ID = "+BuscaFolio,-1,0)

						data = '"'+BuscaFolioInterno+'"'
		
						Ejecuta(UpSQL,0)
						
						result = 1
						message = "Ahora la gu&iacute;a esta en transito"
	
					}else{
						var UpSQL = "UPDATE Orden_Venta "
							UpSQL += " SET OV_EstatusCG51 = 4 " 
							UpSQL += " WHERE OV_ID = " + BuscaFolio
							
						BuscaFolioInterno = BuscaSoloUnDato("OV_TRACKING_NUMBER","Orden_Venta","OV_ID = "+BuscaFolio,-1,0)

						data = BuscaFolioInterno
						Ejecuta(UpSQL,0)
						
						result = 1
						message = "Registro colocado"
					}
				}else{
						result = -1
						message = "Folio no encontrado"
				}
			} catch(err) {
					result = -1
					message = "Error en servidor TA_ID = "+TA_ID
			}

			sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'	
		break;
}
Response.Write(sResultado)
%>