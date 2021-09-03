<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-AGO-17 Incidencias - Series: Creación de archivo
// HA ID: 2 2021-AGO-24 Incidencias - Series - Entrega Parcial: Agregado de bandera en Transferencia Articulo Picking 

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Opcion Ubicacion
    case 5000: {

        var rqIntIns_ID = Parametro("Ins_ID", -1);
		var rqIntTA_ID = Parametro("TA_ID", -1);
		var rqStrSeries = Parametro("Series", "");
        var rqIntIDUsuario = Parametro("IDUsuario", -1);

		var arrSeries = rqStrSeries.split("|,|");

		var arrRegAct = [];
		var sqlInsSer = "";

		var intErrorNumero = 0;
		var strErrorDescripcion = "";

		var jsonRespuesta = '{}'

		/* Extracción de todas las series */
		var sqlInsSerExt = "SELECT Inv_ID "
			+ "FROM Incidencia_SKU "
			+ "WHERE Ins_ID = " + rqIntIns_ID + " "
				+ "AND TA_ID = " + rqIntTA_ID + " "

        var rsInsSerExt = AbreTabla(sqlInsSerExt, 1, 0)

		while( !(rsInsSerExt.EOF) ){

			var arrRegActReg = [
				  rsInsSerExt("Inv_ID").Value		/* Registro */
				, 0									/* Validador de Existencia */
			];

			arrRegAct.push( arrRegActReg );

			rsInsSerExt.MoveNext();
		}

		rsInsSerExt.Close()

		/* Actualización o Inserción de Registro */
		for( var i=0; i<arrSeries.length; i++ ){

			var arrReg = arrSeries[i].split("|");	/* Extracción de campos */

			var rqIntInv_ID = arrReg[0];			/* Campo de Inv_ID */
			var rqStrInv_Serie = arrReg[1];			/* Campo de Inv_Serie */

			var bolValExi = false;

			/* Validación de Existencia en registros extraidos */
			for( var j=0; j<arrRegAct.length; j++){

				if( arrRegAct[j][0] == rqIntInv_ID ){
					bolValExi = true;
					arrRegAct[j][1] = 1;		/*cambia el campo para validación de actualización futura*/
				}

			}

			/* Extracción de información de Inv_ID Base */
			var intBasPro_ID = -1;

			var sqlBasInv = "SELECT Pro_ID "
				+ "FROM Inventario "
				+ "WHERE Inv_ID = " + rqIntInv_ID + " "

			var rsBasInv = AbreTabla(sqlBasInv, 1, 0)

			if( !(rsBasInv.EOF) ){
				intBasPro_ID = rsBasInv("Pro_ID").Value
			}

			rsBasInv.Close()

			/* Extracción de Información de Inv_ID_Cambio */
			var intBasPro_ID_Cambio = -1
			var intBasInv_ID_Cambio = -1

			var sqlBasInvCam = "SELECT Inv_ID "
					+ ", Pro_ID "
				+ "FROM Inventario "
				+ "WHERE Inv_Serie = '" + rqStrInv_Serie + "' "

			var rsBasInvCam = AbreTabla(sqlBasInvCam, 1, 0)

			if( !(rsBasInvCam.EOF) ){
				intBasPro_ID_Cambio = rsBasInvCam("Pro_ID").Value;
				intBasInv_ID_Cambio = rsBasInvCam("Inv_ID").Value;
			}

			if( bolValExi ){

				sqlInsSer = "UPDATE ISK "
					+ "SET Inv_Serie_Cambio = " + ( ( rqStrInv_Serie != "" ) ? "'" + rqStrInv_Serie + "'" : "NULL" ) + " "
						+ ", Inv_ID_Cambio = " + ( ( rqStrInv_Serie != "" ) ? intBasInv_ID_Cambio : "NULL" ) + " "
						+ ", Pro_ID_Cambio = " + ( ( rqStrInv_Serie != "" ) ? intBasPro_ID_Cambio : "NULL" ) + " "
						+ ", Pro_ID = " + intBasPro_ID + " "
						+ ", InsS_IDUsuario_Ultimo = " + rqIntIDUsuario + " "
						+ ", InsS_Fecha_Ultimo = GETDATE() "
					+ "FROM Incidencia_SKU ISK "
					+ "WHERE Ins_ID = " + rqIntIns_ID + " "
						+ "AND TA_ID = " + rqIntTA_ID + " "
						+ "AND Inv_ID = " + rqIntInv_ID + " "


			} else {

				sqlInsSer = "INSERT INTO Incidencia_SKU ( "
						  + "Ins_ID "
						+ ", TA_ID "
						+ ", Pro_ID "
						+ ", Inv_ID "
						+ ", Pro_ID_Cambio "
						+ ", Inv_ID_Cambio"
						+ ", Inv_Serie_Cambio "
						+ ", InsS_IDUsuario_Ultimo "
						+ ", InsS_Fecha_Ultimo "
					+ ") "
					+ "VALUES ( "
							+ "" + rqIntIns_ID + " "
						+ ", " + rqIntTA_ID + " "
						+ ", " + intBasPro_ID + " "
						+ ", " + rqIntInv_ID + " "
						+ ", " + ( ( rqStrInv_Serie != "" ) ? intBasPro_ID_Cambio : "NULL" ) + " "
						+ ", " + ( ( rqStrInv_Serie != "" ) ? intBasInv_ID_Cambio : "NULL" ) + " "
						+ ", " + ( ( rqStrInv_Serie != "" ) ? "'" + rqStrInv_Serie + "'" : "NULL" ) + " "
						+ ", " + rqIntIDUsuario + " "
						+ ", GETDATE() "
					+ ") "

			}

			try{
				
				if( Ejecuta(sqlInsSer, 0) ){
					intErrorNumero = 0
					strErrorDescripcion = "Se actualizo las series seleccionadas" 
				} else {
					intErrorNumero = 1
					strErrorDescripcion = "No se actualizaron las series Seleccionadas"
				}

			} catch(e){
				intErrorNumero = 2
				strErrorDescripcion = "Error en la actualización de las Series Seleccionadas"
			}

			/* HA ID: 2 INI Actualización de bandera en Transferencia Artículos Picking */

			var intTA_EstatusCG51 = -1;
			var bolActTRA = false;
			var bolEsEntPar = false;
			var bolEsSinPar = false;
			
			//Extraccion de Estatus de la Transferencia
			var sqlTRA = "SELECT TA_EstatusCG51 "
				+ "FROM TransferenciaAlmacen TA "
				+ "WHERE TA_ID = " + rqIntTA_ID + " "

			var rsTRA = AbreTabla(sqlTRA, 1, 0)

			if( !(rsTRA.EOF) ){
				intTA_EstatusCG51 = rsTRA("TA_EstatusCG51").Value
			}

			rsTRA.Close()

			if( intTA_EstatusCG51 == 20 ){
				bolEsEntPar = true;
				bolActTRA = true;
			}

			if( intTA_EstatusCG51 == 24 ){
				bolEsSinPar = true;
				bolActTRA = true;
			}

			if( bolActTRA ) {

				//Actualización de TransferenciaAlmacen_Articulo_Picking
				var sqlActTRA = "UPDATE TAS "

				if( bolEsEntPar ){
					sqlActTRA += "SET TAS_EsEntregaParcial = 1 "
						+ ", TAS_Ins_ID_EntregaParcial = " + rqIntIns_ID + " "
				}

				if( bolEsSinPar ){
					sqlActTRA += "SET TAS_EsSiniestro = 1 "
						+ ", TAS_Ins_ID_Siniestro = " + rqIntIns_ID + " "
				}
					
				sqlActTRA += "FROM TransferenciaAlmacen_Articulo_Picking TAS "
					+ "WHERE TA_ID = " + rqIntTA_ID + " "
						+ "AND Inv_ID = " + rqIntInv_ID + " "

				try{
				
					if( Ejecuta(sqlActTRA, 0) ){
						intErrorNumero = 0
						strErrorDescripcion = "Se actualizo las series seleccionadas en la Transferencia" 
					} else {
						intErrorNumero = 1
						strErrorDescripcion = "No se actualizaron las series Seleccionadas en la Transferencia"
					}

				} catch(e){
					intErrorNumero = 2
					strErrorDescripcion = "Error en la actualización de las Series Seleccionadas en la Transferencia"
				}		

			}

			/* HA ID: 2 FIN  */
			
		}

		/* Extracción de Series no existentes en la validación */
		var arrSerNoExi = [];
		var bolEliExi = false;

		for( var i=0; i<arrRegAct.length; i++){
			if( arrRegAct[i][1] == 0 ){
				arrSerNoExi.push(arrRegAct[i][0]);
				bolEliExi = true;
			}
		}

		/* eliminación Series no existentes en validación */
		if( bolEliExi ){
			var strSerNoExi = arrSerNoExi.join(",");

			var sqlSerNoExi = "DELETE FROM Incidencia_SKU "
				+ "WHERE Ins_ID = " + rqIntIns_ID + " "
					+ "AND TA_ID = " + rqIntTA_ID + " "
					+ "AND Inv_ID IN ( " + strSerNoExi + " ) "

			try{
				
				if( Ejecuta(sqlSerNoExi, 0) ){
					intErrorNumero = 0
					strErrorDescripcion = "Se actualizo las series seleccionadas Total" 
				} else {
					intErrorNumero = 1
					strErrorDescripcion = "NO Se actualizo las series seleccionadas Total" 
				}

			} catch(e){
				intErrorNumero = 2
				strErrorDescripcion = "Error en la actualizacion de las Series Seleccionadas"
			}

			/* HA ID: 2 INI Actualización de bandera en Transferencia Artículos Picking */

			if( bolActTRA ) {

				//Actualización de TransferenciaAlmacen_Articulo_Picking
				sqlActTRA = "UPDATE TAS "

				if( bolEsEntPar ){
					sqlActTRA += "SET TAS_EsEntregaParcial = 0 "
						+ ", TAS_Ins_ID_EntregaParcial = -1 "
				}
				
				if( bolEsSinPar ){
					sqlActTRA += "SET TAS_EsSiniestro = 0 "
						+ ", TAS_Ins_ID_Siniestro = -1 "
				}
					
				sqlActTRA += "FROM TransferenciaAlmacen_Articulo_Picking TAS "
					+ "WHERE TA_ID = " + rqIntTA_ID + " "
						+ "AND Inv_ID IN ( " + strSerNoExi + " ) "

				try{
				
					if( Ejecuta(sqlActTRA, 0) ){
						intErrorNumero = 0
						strErrorDescripcion = "Se actualizo las series seleccionadas en la Transferencia" 
					} else {
						intErrorNumero = 1
						strErrorDescripcion = "No se actualizaron las series Seleccionadas en la Transferencia"
					}

				} catch(e){
					intErrorNumero = 2
					strErrorDescripcion = "Error en la actualización de las Series Seleccionadas en la Transferencia"
				}		

			}

			/* HA ID: 2 FIN  */
		}

		jsonRespuesta = '{'
				+ '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta);

    } break;

}
%>