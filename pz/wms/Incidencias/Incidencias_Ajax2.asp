<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 2 2021-AGO-06 Surtido: Creación de archivo
// HA ID: 3 2021-AGO-24 Entrega Parcial: Cambio de Estatus que tienen las Transferencias

var Tarea = Parametro("Tarea",-1)
    var InsO_ID = Parametro("InsO_ID",-1)
	var ID_Unico = Parametro("ID_Unico",-1)
	var InsO_ID = Parametro("InsO_ID",-1)
	var Ins_ID = Parametro("Ins_ID",-1) 
    var Chkdo = Parametro("Chkdo",0)
	var InsCm_Observacion = decodeURIComponent(Parametro("InsCm_Observacion",""))
	var sResultado = ""
    var InsT_Padre = Parametro("InsT_Padre",0)
	var InsT_Nombre = decodeURIComponent(Parametro("InsT_Nombre",""))
	var InsT_Descripcion = decodeURIComponent(Parametro("InsT_Descripcion",""))
	var InsT_PrioridadCG33 = Parametro("InsT_PrioridadCG33",1)
	var InsT_SeveridadCG32 = Parametro("InsT_SeveridadCG32",1)
	var InsT_EstrellasCG33 = Parametro("InsT_EstrellasCG33",0)
	var InsT_PrioridadABC = Parametro("InsT_PrioridadABC",1)
	var InsT_Orden = Parametro("InsT_Orden",1)
    var InsT_MoScoWCG24 = Parametro("InsT_MoScoWCG24",4)
	var InsT_TallaCG25 = Parametro("InsT_TallaCG25",0)
	var InsT_SLAAtencion = Parametro("InsT_SLAAtencion",-1)
	var InsT_SLAResolucion = Parametro("InsT_SLAResolucion",-1)
    var InsT_Problema_For_ID = Parametro("InsT_Problema_For_ID",-1)
    var InsT_Comentarios_For_ID = Parametro("InsT_Comentarios_For_ID",-1)
	var InsT_TipoCG28 = Parametro("InsT_TipoCG28",4)
	var InsT_TipoMedicionCG29 = Parametro("InsT_TipoMedicionCG29",-1)
	var Ins_Titulo = decodeURIComponent(Parametro("Ins_Titulo",""))
	var Ins_Asunto = decodeURIComponent(Parametro("Ins_Asunto",""))
	var Ins_Descripcion = decodeURIComponent(Parametro("Ins_Descripcion",""))
	var Ins_Problema = decodeURIComponent(Parametro("Ins_Problema",""))
	var Ins_Causa = decodeURIComponent(Parametro("Ins_Causa",""))
	var Ins_Ventana = decodeURIComponent(Parametro("Ins_Ventana",""))
	var Ins_Accion = decodeURIComponent(Parametro("Ins_Accion",""))
	var Ins_MensajeError = decodeURIComponent(Parametro("Ins_MensajeError",""))
    var TA_ID = Parametro("TA_ID",-1)
    var TA_Folio = Parametro("TA_Folio","")
    var OC_ID = Parametro("OC_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var OV_Folio = Parametro("OV_Folio","")
    var Cli_ID = Parametro("Cli_ID",-1)
    var CCgo_ID = Parametro("CCgo_ID",-1)
    var Prov_ID = Parametro("Prov_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
	var Tag_ID = Parametro("Tag_ID",-1)
    var Man_ID = Parametro("Man_ID",-1)
    var ManD_ID = Parametro("ManD_ID",-1)
    var Inv_ID = Parametro("Inv_ID",-1)
    var Pro_ID = Parametro("Pro_ID",-1)
    var ProC_ID = Parametro("ProC_ID",-1)
    var Lot_ID = Parametro("Lot_ID",-1)
    var Alm_ID = Parametro("Alm_ID",-1)
    var For_ID = Parametro("For_ID",-1)
	var Alm_Numero = Parametro("Alm_Numero","")
	var Ins_Usu_Reporta = Parametro("Ins_Usu_Reporta",-1)
    var Ins_Usu_Recibe = Parametro("Ins_Usu_Recibe",-1)
    var Ins_Tarea_FechaAtendida = Parametro("Ins_Tarea_FechaAtendida","")
    var Ins_Tarea_FechaLIberada = Parametro("Ins_Tarea_FechaLIberada","")
    var Ins_FechaInicio_Tarea = Parametro("Ins_FechaInicio_Tarea","")
    var Ins_FechaEntrega_Tarea = Parametro("Ins_FechaEntrega_Tarea","")
    var Ins_Usu_Escalado = Parametro("Ins_Usu_Escalado",-1)
    var Ins_EstatusCG27 = Parametro("Estatus",2)
    var InsT_ID = Parametro("InsT_ID",-1)
    var InsCm_ID = Parametro("InsCm_ID",-1)
    var InsCm_Padre = Parametro("InsCm_Padre",0)
    var InsT_ID = Parametro("InsT_ID",-1)
    var Ins_Prioridad = Parametro("Ins_Prioridad",-1)
    var Ins_Severidad = Parametro("Ins_Severidad",-1)
    var Tag_Nombre = Parametro("Tag_Nombre","")
    var Tag_Descripcion = Parametro("Tag_Descripcion","")
    var Tag_Origen = Parametro("Tag_Origen",-1)
    var Tag_Publica = Parametro("Tag_Publica",-1)
    var IDUsuario = Parametro("Usuario", -1)  
	var Asignado = Parametro("Asignado", -1)  
	var Ins_GrupoID = Parametro("Ins_GrupoID", -1)
	var Ins_TipoInvolucradoCG26 = Parametro("Ins_TipoInvolucradoCG26", -1)
	var T_Involucrado = Parametro("T_Involucrado", -1)
	var Involucrado = Parametro("Involucrado", -1)
	var Subtarea = Parametro("Subtarea",-1)
    var Ins_Padre = Parametro("Ins_ID",0)
    var Shipping = Parametro("Shipping","")
	var SKUSob = Parametro("SKUSob",-1)
    var SKU1 = Parametro("SKU1","")
    var SKU2 = Parametro("SKU2","")
    var SKU3 = Parametro("SKU3","")
    var SKU4 = Parametro("SKU4","")
    var SKU5 = Parametro("SKU5","")
	var SKUCambiado = Parametro("SKUCambiado",-1)
	var ChkSKU = Parametro("ChkSKU",-1)
    var FechaAviso = Parametro("FechaAviso","")

	var result = 0;

switch( parseInt( Tarea ) ){

    //Guardado de incidencia tipo Faltante SKU
    case 17: {

		/* HA ID: 2 INI Se agrgan variables de control */

		var intErrorNumero = 0
		var intErrorDescripcion = "";

		var jsonRespuesta = '{}'

		var TipoIncidencia = {
			EntregaParcial: 30
			, SiniestroParcial: 40
			, SiniestroTotal: 39
		}

		var Transferencia = {
			Estatus: {
				EntregaParcial: 20
				, SiniestroParcial: 24
				, SiniestroTotal: 18
			}
		}
		
		var arrInsCam = [
			TipoIncidencia.EntregaParcial
			, TipoIncidencia.SiniestroParcial
			, TipoIncidencia.SiniestroTotal
		];

		var rqIntTA_EstatusCG51 = -1;
		var sqlTraUpdBan = "";
		var sqlTraSerUpdBan = "";

		/* HA ID: 2 FIN */

		if(TA_Folio !=""){

			sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
			
			var rsTA = AbreTabla(sSQL,1,0)
			
			if(!rsTA.EOF){
				TA_ID = rsTA.Fields.Item("TA_ID").Value
			}else{
				intErrorNumero = 1
				strErrorDescripcion = "Folio de Transferencia no permitido"
			}
        }

		var Alm_ID = -1
		var Alm_Nombre = ""

		if(Alm_Numero !=""){

			sSQL = "SELECT Alm_ID, Alm_Nombre FROM Almacen a "
				//+ "INNER JOIN TransferenciaAlmacen t ON  t.TA_End_Warehouse_ID = a.Alm_ID "
				+" WHERE Alm_Numero = '" + Alm_Numero + "'" //AND t.TA_ID ="+ TA_ID "

			var rsAlm = AbreTabla(sSQL,1,0)
			
			//Response.Write(sSQL)
			
			if(!rsAlm.EOF){
				Alm_ID = rsAlm.Fields.Item("Alm_ID").Value
				Alm_Nombre = rsAlm.Fields.Item("Alm_Nombre").Value
			}else{
				intErrorNumero = 1
				strErrorDescripcion ="Almacen no encontrado"
			}
        }
		
		if((Alm_ID >-1 && TA_ID >-1)||(Shipping != "" && TA_ID >-1)||(SKUSob >-1)||(SKUCambiado > -1)||(TA_ID >-1 && Ins_Titulo!="")||(FechaAviso != "" && TA_ID >-1)){


			if(TA_ID >-1 && Ins_Titulo!=""){
				var Titulo = Ins_Titulo
				var Asunto = Ins_Titulo + " - " + TA_Folio
			}

			if(Alm_ID>-1){
				var Titulo = "Entrega cruzada"
				var Asunto = "Entrega en tienda "+Alm_Numero+" - " +Alm_Nombre+ " - "+ TA_Folio
			}

			if(Shipping != ""){
				var Titulo = "Shipping"
				var Asunto = "Shipping Nota de Cargo  - "+ TA_Folio
			}

			if(FechaAviso != ""){
				var Titulo = "Costo Logistico"
				var Asunto = "Costo Logistico - " +TA_Folio
				
				sSQL = "SELECT CONVERT(VARCHAR, CONVERT(DATETIME, '"+FechaAviso+"'), 20) as fecha_aviso"
				var rsFechaAviso = AbreTabla(sSQL,1,0)
				FechaAviso = rsFechaAviso.Fields.Item("fecha_aviso").Value
			}

			if(SKUSob > -1){
				var Titulo = "Diferencia en remision"
				var Asunto = "SKU Sobrante - "+TA_Folio 
			}

			if(SKUCambiado > -1){
				var Titulo = "Diferencia en remision"
				var Asunto = "SKU Cambiado - "+TA_Folio 
			}

			if(InsT_ID==29){
				var Asunto = "SKU Faltante  - "+TA_Folio
			}

			switch( parseInt(InsT_ID) ){
				case 27: { Asunto = "SKU Cambiado - " + TA_Folio } break;
				case 29: { Asunto = "SKU Faltante - " + TA_Folio } break;
				case 30: { Asunto = "Entrega Parcial - " + TA_Folio } break;
				case 40: { Asunto = "Siniestro Pacial - " + TA_Folio } break;
				case 39: { Asunto = "Siniestro Total - " + TA_Folio } break;
			}
					
			var Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
								
			if(Ins_FechaInicio_Tarea != "" && Ins_FechaEntrega_Tarea != "" && (Ins_Padre ==20||Ins_Padre==19)){
				Ins_FechaInicio_Tarea=CambiaFormatoFecha(Ins_FechaInicio_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
				Ins_FechaEntrega_Tarea=CambiaFormatoFecha(Ins_FechaEntrega_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
			}

			var sSQL = " INSERT INTO Incidencia (Ins_ID, Ins_Padre, Ins_Titulo, Ins_Asunto, Ins_Descripcion,TA_ID"
					+ ", Prov_ID, Alm_ID, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, "
					+ "  Ins_Usu_Escalado, Ins_EstatusCG27, InsT_ID, InsO_ID, InsCm_ID, Ins_Prioridad, Ins_Severidad, Ins_FechaInicio_Tarea,Ins_FechaEntrega_Tarea, Ins_FechaAvisoCosto) " 
			+ " VALUES (" + Ins_ID + "," + Ins_Padre + ",'"+Titulo+"','"+Asunto+"','" + Ins_Descripcion 
					+ "'," + TA_ID + "," + Prov_ID+ "," + Alm_ID+ ","	+ Ins_Usu_Reporta + "," + Ins_Usu_Recibe + "," + Prov_ID
					+ "," + Ins_Usu_Escalado + "," + Ins_EstatusCG27 + "," + InsT_ID + "," + InsO_ID + "," + InsCm_ID + "," + Ins_Prioridad
					+ "," + Ins_Severidad + ", '"+Ins_FechaInicio_Tarea+"', '"+ Ins_FechaEntrega_Tarea +"', '"+FechaAviso+"')"					
					//Response.Write(sSQL)


		/* HA ID: 2 INI Eliminacion(Comentado) de codigo de control */
		/*
			if(Ejecuta(sSQL,0)){
				result = 1
			}else{
				result = 2
			}
			sResultado =result
		*/
		
			/* HA ID: 2 INI Se actualizan variables de control */

			try{

				if(Ejecuta(sSQL,0)){
					intErrorNumero = 0
					strErrorDescripcion = "Se Registro la Incidencia"

					/* HA ID: 2 INI Se Agrega cambio de Estatus en la Transferencia */

					if( arrInsCam.indexOf( parseInt(InsT_ID) ) > -1 ){

						switch( parseInt(InsT_ID) ){
							case TipoIncidencia.EntregaParcial: {
								rqIntTA_EstatusCG51 = Transferencia.Estatus.EntregaParcial
								sqlTraUpdBan = ", TA_EntregaParcialSeleccionCerrado = 1 "
								sqlTraSerUpdBan = "SET TAS_EsEntregaParcial = 1, TAS_Ins_ID_EntregaParcial = " + Ins_ID + " "
							} break;
							case TipoIncidencia.SiniestroParcial: {
								rqIntTA_EstatusCG51 = Transferencia.Estatus.SiniestroParcial
								sqlTraUpdBan = ", TA_SiniestroSeleccionCerrado = 1 "
								sqlTraSerUpdBan = "SET TAS_EsSiniestro = 1, TAS_Ins_ID_Siniestro = " + Ins_ID + " "
							} break;
							case TipoIncidencia.SiniestroTotal: {
								rqIntTA_EstatusCG51 = Transferencia.Estatus.SiniestroTotal
								sqlTraUpdBan = ", TA_SiniestroSeleccionCerrado = 1 "
								sqlTraSerUpdBan = "SET TAS_EsSiniestro = 1, TAS_Ins_ID_Siniestro = " + Ins_ID + " "
							} break;
						}

						var sqlTraUpd = "UPDATE TransferenciaAlmacen "
							+ "SET TA_EstatusCG51 = " + rqIntTA_EstatusCG51 + " "
								+ "" + sqlTraUpdBan + " "
							+ "WHERE TA_ID = " + TA_ID + " "

						//Response.Write( sqlTraUpd);

						try{

							if( Ejecuta(sqlTraUpd, 0) ){
								intErrorNumero = 0
								strErrorDescripcion += ", Se actualizo la transferencia"
							}else{
								intErrorNumero = 2
								strErrorDescripcion += ", No se actualizo la transferencia"
							}

						} catch(e){
							intErrorNumero = 1
							strErrorDescripcion += ", Error en la actualizacion de la transferencia"
						}

						
						if( InsT_ID == TipoIncidencia.SiniestroTotal ){

							//Si es entrega Total se actualizan todas las series
							var sqlTraSer =  "UPDATE TransferenciaAlmacen_Articulo_Picking "
								+ "" + sqlTraSerUpdBan + " "
								+ "WHERE TA_ID = " + TA_ID + " "

							var sqlInsSer = "INSERT INTO Incidencia_SKU ( "
									+ "Ins_ID, Pro_ID, Inv_ID, TA_ID, InsS_IDUsuario_Ultimo, InsS_Fecha_Ultimo "
								+ " ) "
								+ "SELECT " + Ins_ID + ", Pro_ID, Inv_ID, TA_ID, " + Ins_Usu_Reporta + ", GETDATE() "
								+ "FROM TransferenciaAlmacen_Articulo_Picking "
								+ "WHERE TA_ID = " + TA_ID + " "


							try{

								if( Ejecuta(sqlTraSer, 0) ){
									intErrorNumero = 0
									strErrorDescripcion += ", Se actualizo los articulos de la transferencia"
								}else{
									intErrorNumero = 2
									strErrorDescripcion += ", No se actualizo los articulos de la transferencia"
								}

								if( Ejecuta(sqlInsSer, 0) ){
									intErrorNumero = 0
									strErrorDescripcion += ", Se actualizo los articulos de la incidencia"
								}else{
									intErrorNumero = 2
									strErrorDescripcion += ", No se actualizo los articulos de la incidencia"
								}


							} catch(e){
								intErrorNumero = 1
								strErrorDescripcion += ", Error en la actualizacion de la transferencia e incidencia Series"
							}
						}

					}

					/* HA ID: 2 FIN */


				}else{
					intErrorNumero = 2
					strErrorDescripcion = "Insercion de Incidencia no permitida"
				}

			} catch(e){
				intErrorNumero = 1
				strErrorDescripcion = "Error en la inserción de la Incidencia"
			}

			/* HA ID: 2 FIN */

		} else {
			/* HA ID: 2 INI Se actualizan variables de control */

			intErrorNumero = 3
			strErrorDescripcion = "Campos no permitidos"

			/* HA ID: 2 FIN */
		}

		/* HA ID: 2 INI configuracion de Respuesta */
		jsonRespuesta = '{'
				+ '"Error": {'
					+ '"Numero": "' + intErrorNumero + '"'
				+ ', "Descripcion": "' + strErrorDescripcion + '"'
			+ '}'
			+ ', "Registro": {'
					+ '"TA_ID": "' + TA_ID + '"'
				+ ', "Ins_ID": "' + Ins_ID + '"'
			+ '}'
		+ '}'

		Response.Write(jsonRespuesta);

		/* HA ID: 2 FIN */

    } break;

	case 26: {

		/* HA ID: 2 INI Se agrgan variables de control */

		var intErrorNumero = 0
		var intErrorDescripcion = "";

		var jsonRespuesta = '{}'

		/* HA ID: 2 FIN */

		var Asunto= "Ins_Asunto"
		if(TA_Folio !=""){

			sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
			var rsTA = AbreTabla(sSQL,1,0)

			if(!rsTA.EOF){
				TA_ID = rsTA.Fields.Item("TA_ID").Value
			}else{
				sResultado = 0
			}

			sSQL = "SELECT TA_ID FROM Incidencia WHERE Ins_ID ="+Ins_ID
				var rsTA = AbreTabla(sSQL,1,0)
				TA_ID_Inc = rsTA.Fields.Item("TA_ID").Value

			if(TA_ID!=TA_ID_Inc){
				sSQL = "DELETE FROM Incidencia_SKU WHERE Ins_ID="+Ins_ID+ " AND TA_ID="+TA_ID_Inc
				Ejecuta(sSQL,0)
			}

		}

		var Alm_ID = -1
		var Alm_Nombre = ""
				
		if(Alm_Numero !=""){

			sSQL = "SELECT Alm_ID, Alm_Nombre FROM Almacen a "
						//+ "INNER JOIN TransferenciaAlmacen t ON  t.TA_End_Warehouse_ID = a.Alm_ID "
						+" WHERE Alm_Numero = '" + Alm_Numero + "'" //AND t.TA_ID ="+ TA_ID "
			var rsAlm = AbreTabla(sSQL,1,0)

			//Response.Write(sSQL)
			if(!rsAlm.EOF){
				Alm_ID = rsAlm.Fields.Item("Alm_ID").Value
				Alm_Nombre = rsAlm.Fields.Item("Alm_Nombre").Value
			}else{
				sResultado = 0
			}
		}

		if(SKUCambiado > -1){
			var Asunto = "SKU Cambiado - "+TA_Folio 
		}

		if(SKUSob > -1){
			var Asunto = "SKU Sobrante - "+TA_Folio 
		}

		if(InsT_ID==29){
			var Asunto = "SKU Faltante - "+TA_Folio 
		}

		if(InsT_ID==30){
			var Asunto = "Entrega Parcial - "+TA_Folio 
		}

		if(Shipping != ""){
			var Titulo = "Shipping"
			var Asunto = "Shipping Nota de Cargo  - "+ TA_Folio
		}

		if(InsT_ID==38){
			var Asunto = "Costo logistico - "+TA_Folio 
		}

		if(Alm_ID>-1){
					var Asunto = "Entrega en tienda "+Alm_Numero+" - " +Alm_Nombre+ " - "+ TA_Folio
		}

		sSQL="UPDATE Incidencia SET "
			+ "Ins_Usu_Recibe = "+Ins_Usu_Recibe

		if(InsT_ID != 39 && InsT_ID != 40){
				sSQL += ", Ins_Asunto ='"+Asunto+"'"
		}

		sSQL += ", Ins_Descripcion= '"+Ins_Descripcion+"'"

		if(Alm_ID>-1){
			sSQL += ", Alm_ID="+Alm_ID
		}

		if(TA_ID>-1){
			sSQL += ", TA_ID="+TA_ID
		}

		if(InsT_ID==38){
			sSQL += ", Ins_FechaAvisoCosto = '"+ FechaAviso + "'"
		}

		if(InsT_ID == 39||InsT_ID==40){
				sSQL += ", Ins_Asunto= '"+Ins_Asunto+"'"
				sSQL += ", Ins_Titulo= '"+Ins_Titulo+"'"
				sSQL += ", Ins_Causa= '"+Ins_Causa+"'"
				sSQL += ", Ins_Problema= '"+Ins_Problema+"'"
		
		}

		sSQL += " WHERE Ins_ID = "+Ins_ID

		/* HA ID: 2 INI Eliminacion(Se Comenta) de codigo de control */
		/*
		//Response.Write(sSQL)
		if(Ejecuta(sSQL,0)){
			result = 1
		}else{
			result = 0
		}

		*/

		/* HA ID: 2 INI Se actualizan variables de control */

		try{

			if(Ejecuta(sSQL,0)){
				intErrorNumero = 0
				strErrorDescripcion = "Se Actualiza la Incidencia"
			}else{
				intErrorNumero = 2
				strErrorDescripcion = "Numero de folio No encontrado"
			}

		} catch(e){
			intErrorNumero = 1
			strErrorDescripcion = "Error en la inserción de la Incidencia"
		}

		/* HA ID: 2 FIN */
	
		if(SKU1 !=""){

			sSQL = "DELETE FROM Incidencia_SKU WHERE Ins_ID ="+Ins_ID
			Ejecuta(sSQL,0)

			sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU1 + "'"	
			var rsPro = AbreTabla(sSQL,1,0)

			if(!rsPro.EOF){

				Pro_ID = rsPro.Fields.Item("Pro_ID").Value

				var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
				sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ ","+Pro_ID+")"					
			
			/* HA ID: 2 INI Eliminacion(Comentado) de Codigo y sustitución de valores de Respuesta */	

				if(Ejecuta(sSQL,0)){

					intErrorNumero = 0
					strErrorDescripcion = "Se Actualiza el SKU"

				}else{

					intErrorNumero = 1
					strErrorDescripcion = "NO Se Actualiza el SKU"

				}

			} else {

				intErrorNumero = 2
				strErrorDescripcion = "NO Existe el SKU"
				
			}

					/* HA ID: 2 FIN */
		}
			
		if(SKU2 !=""){

			sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU2 + "'"	
			var rsPro = AbreTabla(sSQL,1,0)

			if(!rsPro.EOF){

				Pro_ID2 = rsPro.Fields.Item("Pro_ID").Value
				var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
				sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID2+")"		

			/* HA ID: 2 INI Eliminacion(Comentado) de Codigo y sustitución de valores de Respuesta */	
					
				if(Ejecuta(sSQL,0)){

					intErrorNumero = 0
					strErrorDescripcion = "Se Actualiza el SKU"
		
				}else{

					intErrorNumero = 1
					strErrorDescripcion = "NO Se Actualiza el SKU"

				}

			}else{

				intErrorNumero = 2
				strErrorDescripcion = "NO Existe el SKU"
				
			}

			/* HA ID: 2 FIN */
		}

		if(SKU3 !=""){

			sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU3 + "'"	
			var rsPro = AbreTabla(sSQL,1,0)
					
			if(!rsPro.EOF){

				Pro_ID3 = rsPro.Fields.Item("Pro_ID").Value
				var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
				sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID3+")"					
        
			/* HA ID: 2 INI Eliminacion(Comentado) de Codigo y sustitución de valores de Respuesta */	
			

				if(Ejecuta(sSQL,0)){

					intErrorNumero = 0
					strErrorDescripcion = "Se Actualiza el SKU"
		
				}else{

					intErrorNumero = 1
					strErrorDescripcion = "NO Se Actualiza el SKU"

				}

			} else {

				intErrorNumero = 2
				strErrorDescripcion = "NO Existe el SKU"
				
			}

			/* HA ID: 2 FIN */
		}
			
		if(SKU4 !=""){

			sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU4 + "'"	
			var rsPro = AbreTabla(sSQL,1,0)
				
			if(!rsPro.EOF){

				Pro_ID4 = rsPro.Fields.Item("Pro_ID").Value
				var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
				sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID4+")"					
        
				/* HA ID: 2 INI Eliminacion(Comentado) de Codigo y sustitución de valores de Respuesta */	

				if(Ejecuta(sSQL,0)){

					intErrorNumero = 0
					strErrorDescripcion = "Se Actualiza el SKU"
		
				}else{

					intErrorNumero = 1
					strErrorDescripcion = "NO Se Actualiza el SKU"

				}

			} else {

				intErrorNumero = 2
				strErrorDescripcion = "NO Existe el SKU"
				
			}

			/* HA ID: 2 FIN */
		}
			
		if(SKU5 !="" ){

			sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU5 + "'"	
			var rsPro = AbreTabla(sSQL,1,0)
					
			if(!rsPro.EOF){

				Pro_ID5 = rsPro.Fields.Item("Pro_ID").Value
					var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
				sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID5+")"					
        
				/* HA ID: 2 INI Eliminacion de Codigo y sustitución de Respuesta */	
				
				if(Ejecuta(sSQL,0)){

					intErrorNumero = 0
					strErrorDescripcion = "Se Actualiza el SKU"
		
				}else{

					intErrorNumero = 1
					strErrorDescripcion = "NO Se Actualiza el SKU"

				}

			} else {

				intErrorNumero = 2
				strErrorDescripcion = "NO Existe el SKU"
				
			}

			/* HA ID: 2 FIN */
		}

		//Response.Write(sSQL)
		sResultado =result

		/* HA ID: 2 INI configuracion de Respuesta */
		jsonRespuesta = '{'
				+ '"Error": {'
					+ '"Numero": "' + intErrorNumero + '"'
				+ ', "Descripcion": "' + strErrorDescripcion + '"'
			+ '}'
			+ ', "Registro": {'
					+ '"TA_ID": "' + TA_ID + '"'
				+ ', "Ins_ID": "' + Ins_ID + '"'
			+ '}'
		+ '}'

		Response.Write(jsonRespuesta);

		/* HA ID: 2 FIN */
		
	} break;

} 

//Response.Write(sResultado)

%>