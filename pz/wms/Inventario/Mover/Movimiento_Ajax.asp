<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
    var bIQ4Web = false   

    var Tarea = Parametro("Tarea",0)

    if(bIQ4Web){ Response.Write("Tarea: " + Tarea ) }  

    var iAreID = Parametro("Are_ID",-1)
    var iRacID = Parametro("Rac_ID",-1)

    var iTipoBusq = Parametro("TipoBusq",-1)
    var iUsuID = Parametro("Usu_ID",-1)
      
    //================Juego de series {start}===================  
    var iOpInvMovID = Parametro("OpInvMov_ID",-1)
    var sArrDBusq = Parametro("ArrSer","")
    var iOpInvMovDID = Parametro("OpInvMovD_ID",-1)
    var iOpInvMovDMB = Parametro("OpInvMovD_MB",-1)
    var Tipo  = Parametro("Tipo",-1)
    var Poner = Parametro("Poner",-1)
    var iPtID = Parametro("Pt_ID",-1)
    var iInvID = Parametro("Inv_ID",-1)
    
    //Response.Write("iTipoBusq: " + iTipoBusq + " | SeriesABuscar: " + sArrDBusq)
   
   //================Juego de series {end} ===================
   
   var sSKU = Parametro("Pt_SKU","")
   var sUbiNombre = Parametro("Ubi_Nombre","")
   
   var iUbi_ID = Parametro("Ubi_ID",-1)
   
    var jDatos = "{}"
    var jError = "{}"
    var jResultado = 0
    var sResultado = ""
    var iCargaObjeto = 0

    switch (parseInt(Tarea)) {

        case 0:
   
            Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
            bPuedeVerDebug = true
            bDebug = true
            bOcurrioError = true
            DespliegaAlPie()
            var sResultado = '{"result":-1,"message":"No entro a ninguna tarea","Tarea":' + Tarea + '}'

        break;  
   
        case 1:
                       //Response.Write(iRacID)                          
              try {

                var sEventos = "class='form-control input-sm cboSelect DestRac_ID'"
                var sCondRac = "Are_ID = " + iAreID + " AND Rac_Habilitado = 1"
                CargaCombo("DestRac_ID",sEventos,"Rac_ID","Rac_Nombre","Ubicacion_Rack",sCondRac,"Rac_Nombre",iRacID,0,"Seleccione","Editar")
                //CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo)
                Response.Write("<script type='text/javascript'>")
                    Response.Write("$('#DestRac_ID').select2();")
                Response.Write("</script>")
               
               iCargaObjeto = 1
   
              } 
              catch(err) {
                sResultado = "ERROR al cargar combo Rac"
              }
   
        break;
   
        case 2:
                                                 
              try {
   
                var sEventos = "class='form-control input-sm cboSelect DestUbi_ID'"
                var sCondUbi = "Are_ID = " + iAreID + " AND Rac_ID = " + iRacID + " AND Ubi_Habilitado = 1"
                CargaCombo("DestUbi_ID",sEventos,"Ubi_ID","Ubi_Nombre","Ubicacion",sCondUbi,"Ubi_Nombre",iUbi_ID,0,"Seleccione","Editar")
                //CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo)
                Response.Write("<script type='text/javascript'>")
                    Response.Write("$('#DestUbi_ID').select2();")
                Response.Write("</script>")   
   
                iCargaObjeto = 1

              } 
              catch(err) {
                sResultado = "ERROR al cargar combo Ubicacion"
              }
                                                 
        break;   
   
        case 3:
         
            var sResTmp = ""
            var sSQL_SP = ""
            var iOpInvMovID = -1
          
            try {
                
              var sSQL_SP = "EXEC SPR_Inventario_Movimiento "
                          + "@Opcion = 1 "
                          + ", @TipoBusqueda = " + iTipoBusq
                          + ", @UsuID = " + iUsuID
              
              var rsBus = AbreTabla(sSQL_SP,1,0)
              
              if(!rsBus.EOF){
                iOpInvMovID = rsBus.Fields.Item(0).Value    
              }
              rsBus.Close()

              jDatos = '{"ID":'+iOpInvMovID
                      + ',"message":"ID Obtenido correctamente"}'
                
              jResultado = 1  
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
                     + ',"message":"'+err.message+'"}'
              jResultado = 0
              
            }              
        break;
              
        case 4:
         
            var sResTmp = ""
            var sSQL_SP = ""
        
            try {
                
              var sSQL_SP = "EXEC SPR_Inventario_Movimiento "
                          + "@Opcion = 2 "
                          + ",@ArrDatos = '" + sArrDBusq + "'"
                          + ",@OpInvMovID = " + iOpInvMovID
              
              var rsObj = AbreTabla(sSQL_SP,1,0)
              
              if(!rsObj.EOF){
                jDatos = rsObj.Fields.Item(0).Value    
              }
              rsObj.Close()
                
              jResultado = 1
                
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
                     + ',"message":"'+err.message+'"}'
              
              jResultado = 0
              
            } 
              
        break;
   
        case 5:
   
            try {
          
              var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                  sSQL += "SET OpInvMovD_Seleccionado = 0 " 
                  sSQL += "WHERE OpInvMovD_Tipo = 4 "
                  sSQL += "AND OpInvMov_ID = " + iOpInvMovID
                  sSQL += " AND OpInvMovD_MB = " + iOpInvMovDMB
                  sSQL += " AND Inv_ID = " + iInvID
          
                  sSQL_SP = sSQL
              
                if(bIQ4Web) { 
                   sSQL_SP = sSQL  
                }

                Ejecuta(sSQL ,0)
                  
                jResultado = 1

                if (Poner == 1 ) {

                  var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                      sSQL += "SET OpInvMovD_Seleccionado = 1 " 
                      sSQL += "WHERE OpInvMovD_Tipo = 4 "
                      sSQL += "AND OpInvMov_ID = " + iOpInvMovID
                      sSQL += " AND OpInvMovD_MB = " + iOpInvMovDMB
                      sSQL += " AND Inv_ID = " + iInvID
                  
                      sSQL_SP = sSQL
                  
                  Ejecuta(sSQL ,0)
                  
                  jResultado = 2

                }
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
              + ',"message":"'+err.message+'"}'
              
              jResultado = 0
            }             
   
        break;

        case 6:
            //Selecciona toda la búsqueda
            try {

              var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                  sSQL += "SET OpInvMovD_Seleccionado = 0 " 
                  sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                  sSQL += " AND OpInvMovD_Tipo = 4"
                  sSQL_SP = sSQL
              
                if(bIQ4Web) { 
                   sSQL_SP = sSQL  
                }

                Ejecuta(sSQL ,0)
                  
                jResultado = 1

                if (Poner == 1 ) {

                  var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                      sSQL += "SET OpInvMovD_Seleccionado = 1 " 
                      sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                      sSQL += " AND OpInvMovD_Tipo = 4"
                      sSQL_SP = sSQL
                  
                  Ejecuta(sSQL ,0)
                  
                  jResultado = 2

                }
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
              + ',"message":"'+err.message+'"}'
              
              jResultado = 0
            }             
   
        break;              

        case 7:
            //Selecciona toda el pallet
            try {

              var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                  sSQL += "SET OpInvMovD_Seleccionado = 0 " 
                  sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                  sSQL += " AND Pt_ID = " + iPtID
                  sSQL += " AND OpInvMovD_Tipo = 4"
                  sSQL_SP = sSQL
              
                if(bIQ4Web) { 
                   sSQL_SP = sSQL  
                }

                Ejecuta(sSQL ,0)
                  
                jResultado = 1

                if (Poner == 1) {

                  var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                      sSQL += "SET OpInvMovD_Seleccionado = 1 " 
                      sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                      sSQL += " AND Pt_ID = " + iPtID
                      sSQL += " AND OpInvMovD_Tipo = 4"
                      sSQL_SP = sSQL
                  
                  Ejecuta(sSQL ,0)
                  
                  jResultado = 2

                }
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
              + ',"message":"'+err.message+'"}'
              
              jResultado = 0
            }             
   
        break;             

        case 8:
            //Selecciona todo el MasterBox Tarea:8,OpInvMov_ID:$("#OpInvMov_ID").val(),OpInvMovD_MB:iValor,Poner:Poner
            try {

              var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                  sSQL += "SET OpInvMovD_Seleccionado = 0 " 
                  sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                  sSQL += " AND Pt_ID = " + iPtID
                  sSQL += " AND OpInvMovD_MB = " + iOpInvMovDMB
                  sSQL += " AND OpInvMovD_Tipo = 4"
                  sSQL_SP = sSQL
              
                if(bIQ4Web) { 
                   Response.Write(sSQL) 
                   sSQL_SP = sSQL  
                }

                Ejecuta(sSQL ,0)
                  
                jResultado = 1

                if (Poner == 1 ) {

                  var sSQL = " UPDATE Operacion_Inventario_Movimiento_Detalle "
                      sSQL += "SET OpInvMovD_Seleccionado = 1 " 
                      sSQL += "WHERE OpInvMov_ID = " + iOpInvMovID
                      sSQL += " AND Pt_ID = " + iPtID
                      sSQL += " AND OpInvMovD_MB = " + iOpInvMovDMB
                      sSQL += " AND OpInvMovD_Tipo = 4"
                      sSQL_SP = sSQL
                  
                  Ejecuta(sSQL ,0)
                  
                  jResultado = 2

                }
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
              + ',"message":"'+err.message+'"}'
              
              jResultado = 0
            }             
   
        break;              
   

        case 9:

            var OpInvMov_ID = Parametro("Movimiento",-1)
            var Es_Total = Parametro("Es_Total",0)
            var PalletOrigen = Parametro("PalletOrigen",-1)
            var CantPallets = Parametro("CantPallets",0)
            var OpcionSeleccionada  = Parametro("Dcsn",-1)
            var PalletDestino = Parametro("PlltSel",-1)
            var Ubi_ID = Parametro("Ubi_ID",-1)
            var Pt_ID = 0
            var Pt_LPN = ''
            var Pt_Cantidad_Actual = 0
   
   
   
            try {

              var sSQL = "exec SPR_Inventario_Movimiento "
                       + "  @Opcion = 6 "
                       + ", @OpInvMovID = " + OpInvMov_ID
                       + ", @EsTotal = " + Parametro("Es_Total",0)
                       + ", @PtOrigen = " + Parametro("PalletOrigen",-1)
                       + ", @PalletsEnUbicacion = " + Parametro("CantPallets",0)
                       + ", @OptSelecionada = " + Parametro("Dcsn",0)
                       + ", @PtDestino = " + Parametro("PlltSel",-1)
                       + ", @UsuID = " + iUsuID
                       + ", @UbiID = " + Ubi_ID

   
   
              var rsMOV = AbreTabla(sSQL,1,0)
              
              if(!rsMOV.EOF){
                jDatos = rsMOV.Fields.Item(0).Value   
                Pt_ID = rsMOV.Fields.Item('Pt_ID').Value   
                Pt_LPN = rsMOV.Fields.Item('Pt_LPN').Value   
                Pt_Cantidad_Actual = rsMOV.Fields.Item('Pt_Cantidad_Actual').Value   
              }
              rsMOV.Close()
   
                  
              jDatos = '{"Pt_ID":'+ Pt_ID
                     + ',"Pt_LPN":"'+ Pt_LPN +'"'
                     + ',"Pt_Cantidad_Actual":'+ Pt_Cantidad_Actual
                     + ',"message":"Las series se movieron correctamente"}'
   
              if(bIQ4Web) { 
                 sSQL_SP = sSQL  
               }   
                   
              jResultado = 1 

                
            } 
            catch(err) {
              
              jError = '{"name":"'+err.name+'"'
              + ',"message":"'+err.message+'"}'
              
              jResultado = 0
            }             
   
        break;  
   
        case 10:   
          
            try {

              var sSQL  = "SELECT Ubi_ID, Ubi_Nombre "
                  sSQL += "FROM Ubicacion "
                  sSQL += "WHERE Ubi_ID IN ("
                  sSQL += " SELECT Ubi_ID"
                  sSQL += " FROM Pallet "
                  sSQL += " WHERE Pt_SKU = '" + sSKU + "'"
                  sSQL += " AND Are_ID IN (1,17,3,23) AND Pro_ID > -1 "
                  sSQL += " )"
                
              var rsRS = AbreTabla(sSQL,1,0)

              while (!rsRS.EOF){
                if(sResultado != "") { sResultado += "|" }

                sResultado += rsRS.Fields.Item("Ubi_ID").Value 
                sResultado += "," 
                sResultado += rsRS.Fields.Item("Ubi_Nombre").Value 

                rsRS.MoveNext() 
              }
              rsRS.Close()
                  
              if(sResultado == ""){
                sResultado = "Error"
              }

            } 
            catch(err) {
              sResultado = "Error"
            }
   
        break;
   
/*        case 11:   
          
            try {

              var sSQL  = "SELECT Ubi_ID, Ubi_Nombre "
                  sSQL += "FROM Ubicacion "
                  sSQL += "WHERE Ubi_Nombre = '"+ sUbiNombre + "'"
                
              var rsRS = AbreTabla(sSQL,1,0)

              while (!rsRS.EOF){
                if(sResultado != "") { sResultado += "|" }

                sResultado += rsRS.Fields.Item("Ubi_ID").Value 
                sResultado += "," 
                sResultado += rsRS.Fields.Item("Ubi_Nombre").Value 

                rsRS.MoveNext() 
              }
              rsRS.Close()
                  
              if(sResultado == ""){
                sResultado = "Error"
              }

            } 
            catch(err) {
              sResultado = "Error"
            }
   
        break; 
*/   
        
      case 11:   
        
             try {
   
                var sSQL_SP =  " SELECT u.Ubi_ID,u.Are_ID,u.Rac_ID,u.Ubi_Nombre "
                    sSQL_SP += " FROM Ubicacion u WHERE u.Ubi_Nombre = '"+ sUbiNombre + "'"
                    sSQL_SP += " AND u.Are_ID IN (SELECT ua.Are_ID FROM Ubicacion_Area ua WHERE ua.Are_TipoCG88 IN (1,3,6) AND ua.Are_Habilitado = 1)"

                var rsBusUbi = AbreTabla(sSQL_SP,1,0)

                if(!rsBusUbi.EOF){
   
                  iAreID = rsBusUbi.Fields.Item("Are_ID").Value 
                  iRacID = rsBusUbi.Fields.Item("Rac_ID").Value
                  iUbiID = rsBusUbi.Fields.Item("Ubi_ID").Value
                  sUbiNombre = rsBusUbi.Fields.Item("Ubi_Nombre").Value
   
                }
                rsBusUbi.Close()

                jDatos = '{"Are_ID":'+iAreID
                        + ',"Rac_ID":'+iRacID
                        + ',"Ubi_ID":'+iUbiID
                        + ',"Ubi_Nombre":"'+ sUbiNombre +'"'
                        + ',"message":"IDs Are_ID y Rac_ID, Ubi_ID, Ubi_Nombre obtenidos correctamente"}'

                   
              jResultado = 1 
   
              } catch(err) {
   
                jError = '{"name":"'+err.name+'"'
                + ',"message":"'+err.message+'"}'

                jResultado = 0
   
              }
             
        break;
   
        case 12:

          try {

            var sSQL_SP = "SELECT Are_ID, Rac_ID FROM Ubicacion WHERE Ubi_ID = " + iUbi_ID

            var rsBus = AbreTabla(sSQL_SP,1,0)

            if(!rsBus.EOF){
              iAreID = rsBus.Fields.Item(0).Value 
              iRacID = rsBus.Fields.Item(1).Value 
            }
            rsBus.Close()

            jDatos = '{"Are_ID":'+iAreID
                    + ',"Rac_ID":'+iRacID
                    + ',"message":"IDs Are_ID y Rac_ID obtenidos correctamente"}'

            jResultado = 1
              
          } 
          catch(err) {

            jError = '{"name":"'+err.name+'"'
                   + ',"message":"'+err.message+'"}'
            jResultado = 0

          }      
   
        break;
   
      }
                  
      //Resultado en forma general
   
      if(iCargaObjeto == 0) {
        if(sResultado == ""){

          var jsonTAG = '{'
              + '"Resultado":' + jResultado
              + ',"Datos":' + jDatos 
              + ',"Error":' + jError      
              + ',"Accion":' + Tarea
              + ',"Query":"' + sSQL_SP + '"'
            + '} '

          Response.Write(jsonTAG)
        } else {
          Response.Write(sResultado)  
        }
      }
   
   
   
%>
  
  
  
  
