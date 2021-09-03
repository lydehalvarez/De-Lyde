<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){ 

    //Cambio de ubicacion
    case 1: {

        var rqStrLPNUbicacion = Parametro("LPNUbicacion", "")
        var rqStrLpn = Parametro("LPN", "")
        var rqIntCantidadReal = Parametro("CantidadReal", 0)
        var rqIntIDUSuario = Parametro("IDUsuario", -1)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        //Actualización de la ubicacion de los articulos que tienen en inventario el LPN solicitado

        var sqlLpnCam = "EXEC SPR_Temporal_CargaInicialCantidad "
              + "@Opcion = 1 "
            + ", @PT_LPN = '" + rqStrLpn + "' "
            + ", @PT_CantidadReal = " + rqIntCantidadReal + " "
            + ", @Ubi_Nombre = '" + rqStrLPNUbicacion + "' "
            + ", @IDUsuario = " + rqIntIDUSuario + " "

        var rsLpnCam = AbreTabla(sqlLpnCam, 1, cxnTipo)

        if( !(rsLpnCam.EOF) ){
            intErrorNumero = rsLpnCam("ErrorNumero").Value
            strErrorDescripcion = rsLpnCam("ErrorDescripcion").Value
        } else {
            intErrorNumero = 0
            strErrorDescripcion = "No se Realiz&oacute; el cambio"
        }
        
        rsLpnCam.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'}'
            +'}'

        Response.Write(jsonRespuesta)

    } break;

    //Poner en por buscar
    case 2:{

        var rqIntPT_ID = Parametro("PT_ID", -1)
        
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlPorBus = "EXEC SPR_Pallet "
              + "@Opcion = 3000 "
            + ", @PT_ID = " + rqIntPT_ID + " "
            + ", @Ubi_ID = -1 "
            + ", @PT_PorBuscar = 1 "

        var rsPorBus = AbreTabla(sqlPorBus, 1, cxnTipo)

        if( !(rsPorBus.EOF) ){
            intErrorNumero = rsPorBus("ErrorNumero").Value
            strErrorDescripcion = rsPorBus("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el pallet"
        }

        rsPorBus.close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

     //Listar Los lpns Encontrados
   // case 3: 
      //ROG 20/02/2021 
      // lo que estaba aqui fue movido al archivo Temporal_cargaInicial_Grid.asp
   // break;

    //Listado de Pallets Extraviados
//    case 4:{
      //ROG 20/02/2021
      // lo que estaba aqui fue movido al archivo Temporal_CargaInicial_PorBuscar.asp
//    } break;    

    case 5:{

        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqIntConteoFisico = Parametro("ConteoFisico", 0)

        var jsonRespuesta = ""

		var result = -1
		var message = "Algo salio mal, intente de nuevo"
		
			
		var sqlT5 = "EXEC PA_AjustaPalletInventario " + rqIntConteoFisico + " ," + rqIntPT_ID 


		try {
   
			Ejecuta(sqlT5, 0)
   
           //si, dos veces, no lo toques dejalo asi
            Ejecuta(sqlT5, 0)
   
   
		}
		catch(e) {
			result = 0
            message = "No se actualizo"
		}
		

        jsonRespuesta = '{"result": "1", "message": "Se actualizo el pallet"}'

        Response.Write(jsonRespuesta)

    } break;
    case 6:{

        var PT_ID = Parametro("PT_ID", -1)
        var Ubi_ID = Parametro("Ubi_ID", -1)
		
		var result = -1
		var message = "Algo salio mal, intente de nuevo"

        var sqlPTCon = "EXEC SPR_Inventario_CargaInicial_IntegrarNuevos "
            sqlPTCon += " @Entrante_Ubi_ID = "+Ubi_ID
            sqlPTCon += ",@Entrante_PT_ID = " + PT_ID 

        var rsRes = AbreTabla(sqlPTCon, 1, cxnTipo)

        if( !(rsRes.EOF) ){
            result = rsRes("result").Value
            message = rsRes("_message").Value
        } 
        rsRes.Close();

        jsonRespuesta = '{"result": "' + result + '", "message": "' + message + '"}'

        Response.Write(jsonRespuesta)

    } break;
    case 7:{
        var SKU = Parametro("SKU", -1)
        var Cli_ID = Parametro("Cli_ID", -1)
			CargaCombo("cPro_ID","class='form-control'","Pro_ID","Pro_SKU + ' - ' + Pro_Nombre","Producto","PRO_SKU LIKE '%"+SKU+"%'","Pro_SKU",-1,0,"Selecciona") 
    
	} break;
    //Poner en por buscar
    case 8:{

        var Pro_ID = Parametro("Pro_ID", -1)
        var Cli_ID = Parametro("Cli_ID", -1)
        var Ubi_ID = Parametro("Ubi_ID", -1)

        var result = 0
        var message = ""
        var Pt_ID = -1

        var jsonRespuesta = '{}'

        
       var sqlPorBus =  " EXEC SPR_Pallet "
                    + "  @Opcion = 3 "
                    + ", @Pro_ID = " + Pro_ID  
                    + ", @Cli_ID = " + Cli_ID  
                    + ", @Ubi_ID = " + Ubi_ID  
                    + ", @PT_Cantidad = 1 " 
                    + ", @PT_Cantidad_Actual = 1 " 
                    + ", @PT_Transicion = 1 "
                    + ", @EsProcedimiento = 1 "
 
        var rsPorBus = AbreTabla(sqlPorBus, 1, 0)
        if( !(rsPorBus.EOF) ){
            result = rsPorBus("result").Value
            message = rsPorBus("_message").Value
            Pt_ID = rsPorBus("Pt_ID").Value 
        } 
        rsPorBus.Close();

        jsonRespuesta = '{"result": "' + result + '", "message": "' + message + '","Pt_ID": "' + Pt_ID + '"}'

        Response.Write(jsonRespuesta)

    } break;
    case 9:{
        var sCondicion = "Ubi_Nombre = '" + Parametro("ubiNombre", "N/A") + "'"
        var Ubi_ID = BuscaSoloUnDato("Ubi_ID","Ubicacion",sCondicion,-1,0) 

        Response.Write(Ubi_ID)

    } break;
    case 11:{

        var PT_ID = Parametro("PT_ID", -1)
        
		var sqlPorBus =  " EXEC SPR_Auditoria_ValidaPallet " + PT_ID
 
		Ejecuta(sqlPorBus,0)
		
        var jsonRespuesta = '{"result": 1, "message": "Ejecucion exitosa "}'

        Response.Write(jsonRespuesta)

    } break;
	case 12:{

        var PT_ID = Parametro("PT_ID", -1)
        var Pro_ID = Parametro("Pro_ID", -1)
        var Cantidad = Parametro("Cantidad", -1)
        var Ubi_ID = Parametro("Ubi_ID", -1)
		
		var result = -1
		var message = "Algo salio mal, intente de nuevo"
		
		var sqlPorBus =  " [dbo].[SPR_Inventario_CargaInicial_NoSerializado] "+Pro_ID+","+Ubi_ID+","+Cantidad+","+PT_ID
 
		Ejecuta(sqlPorBus,0)
		

        var sqlPTCon = "EXEC SPR_Inventario_CargaInicial_IntegrarNuevos "
            sqlPTCon += " @Entrante_Ubi_ID = "+Ubi_ID
            sqlPTCon += ",@Entrante_PT_ID = " + PT_ID 

        var rsRes = AbreTabla(sqlPTCon, 1, cxnTipo)

        if( !(rsRes.EOF) ){
            result = rsRes("result").Value
            message = rsRes("_message").Value
        } 
        rsRes.Close();

        var jsonRespuesta = '{"result": "' + result + '", "message": "' + message + '"}'
		
        Response.Write(jsonRespuesta)

    } break;
	
	
	
    // carga de Series por Carga Inicial
    case 2010: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqStrSerie = Parametro("Serie", "")

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var intICIS_ID = -1
        var strInv_Serie = ""
        var intICIS_ErrorNumero = -1
        var strICIS_ErrorDescripcion = ""
        var intICIS_Total = -1

        var sqlSerie = "EXEC SPR_Inventario_CargaInicial_Series "
              + "@Opcion = 2010 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "
            + ", @INV_Serie = " + ( (rqStrSerie.length > 0) ? "'" + rqStrSerie + "'" : "NULL" ) + " "

        var rsSerie = AbreTabla(sqlSerie, 1, cxnTipo)

        if( !(rsSerie.EOF) ){
            intErrorNumero = rsSerie("ErrorNumero").Value
            strErrorDescripcion = rsSerie("ErrorDescripcion").Value

            intICIS_ID = rsSerie("ICIS_ID").Value
            strInv_Serie = rsSerie("INV_Serie").Value
            intICIS_ErrorNumero = rsSerie("ICIS_ErrorNumero").Value
            strICIS_ErrorDescripcion = rsSerie("ICIS_ErrorDEscripcion").Value
            intICIS_Total = rsSerie("Total").Value

        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el registro"
        }

        rsSerie.Close();

         jsonRespuesta = '{'
                  + '"Error": {'
                          + '"Numero": "' + intErrorNumero + '"'
                        + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"ICIS_ID": "' + intICIS_ID + '"'
                    + ', "Inv_Serie": "' + strInv_Serie + '"'
                    + ', "ICIS_ErrorNumero": "' + intICIS_ErrorNumero + '"'
                    + ', "ICIS_ErrorDescripcion": "' + strICIS_ErrorDescripcion + '"'
                    + ', "ICIS_Total": "' + intICIS_Total + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
    case 2020:{
        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var intICIS_Total = -1

        var sqlSerie = "EXEC SPR_Inventario_CargaInicial_Series "
              + "@Opcion = 2020 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "
           

        var rsSerie = AbreTabla(sqlSerie, 1, 0)

        if( !(rsSerie.EOF) ){
            intICIS_Total = rsSerie("Total").Value

        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se pudo hacer el conteo"
        }

        rsSerie.Close();

         jsonRespuesta = '{'
                  + '"Error": {'
                          + '"Numero": "' + intErrorNumero + '"'
                        + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                    + '"Total": "' + intICIS_Total + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)
            
    } break;
        

//    case 1100: {
      //ROG 20/02/2021
      // lo que estaba aqui fue movido al archivo Temporal_CargaInicial_Modal.asp
//    } break;
}
%>
