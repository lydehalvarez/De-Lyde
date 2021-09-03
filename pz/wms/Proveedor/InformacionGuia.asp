<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
                                        // Ejemplos
  var bIQDebug = false                  //TA   OV  DOCTOS.
  var iProvID = Parametro("Prov_ID",-1) //15   2      5
  var iProGID = Parametro("ProG_ID",-1) //5253 2   6808
   
  if(bIQDebug){

    Response.Write("Prov_ID: " + iProvID + " | ProG_ID: " + iProGID + "<br>")  
    /*Response.Write("<br>QueryString: " + Request.QueryString() + "<br>")
    Response.Write("Form: " + Request.Form() + "<br>")*/
   
  } 
    
  var sCondEnte = " Prov_ID = " + iProvID + " AND ProG_ID = " + iProGID
  var iTAID = BuscaSoloUnDato("TA_ID","Proveedor_Guia",sCondEnte,-1,0) 
  var iOVID = BuscaSoloUnDato("OV_ID","Proveedor_Guia",sCondEnte,-1,0)
  var iCliID = -1    

  var iUsuID = Parametro("IDUsuario",0)
  var iEsTransportista = Parametro("EsTransportista", 1)   
    
  if(bIQDebug){
    Response.Write("TA_ID: " + iTAID + " | OV_ID: " + iOVID + "<br>")   
  }    

  
  if(iTAID > -1){ 

    var sSQLGuia  = "SELECT TOP 1 PG.Prov_ID, PG.ProG_ID, PG.ProG_NumeroGuia, PG.TA_ID, PG.OV_ID, TA.Cli_ID "
        sSQLGuia += ",(SELECT P.Prov_Nombre + ' - ' + P.Prov_RazonSocial FROM Proveedor P WHERE P.Prov_ID = PG.Prov_ID) AS NOMPROV "
        sSQLGuia += ",(SELECT CLI.Cli_Nombre FROM Cliente CLI WHERE CLI.Cli_ID = TA.Cli_ID) AS CLIENTE "
        sSQLGuia += ",TA.TA_RecibidoFecha "
        sSQLGuia += ",(SELECT MS.Man_Folio FROM Manifiesto_Salida MS WHERE MS.Man_ID = TA.Man_ID) AS FOLIOMANIFIESTO "
        sSQLGuia += ",(SELECT CONVERT(NVARCHAR(20),MS.Man_FechaConfirmado,22) FROM Manifiesto_Salida MS " 
        sSQLGuia += "     WHERE MS.Man_ID = TA.Man_ID) AS FECHACONFMANIFIESTO "
        sSQLGuia += ",CONVERT(VARCHAR, DATEADD(HH, "
        sSQLGuia += "                             (SELECT ISNULL(Alm.Alm_TiempoEntregaHrs, 0) FROM Almacen Alm "
        sSQLGuia += "                                WHERE Alm.Alm_ID = TA.TA_End_Warehouse_ID), "
        sSQLGuia += " (SELECT MS.Man_FechaRegistro FROM Manifiesto_Salida MS WHERE MS.Man_ID = TA.Man_ID)), 23) "
        sSQLGuia += ", PG.ProG_FechaEntrega "
        sSQLGuia += "FROM Proveedor_Guia PG, TransferenciaAlmacen TA "
        sSQLGuia += "WHERE PG.ProG_NumeroGuia = TA.TA_Guia "
        sSQLGuia += "AND PG.TA_ID = TA.TA_ID "
        sSQLGuia += "AND PG.Prov_ID = " + iProvID
        sSQLGuia += " AND PG.ProG_ID = " + iProGID
        //sSQLTra += " AND PG.ProG_NumeroGuia = 'LL-00-3099'    

        if(bIQDebug){ Response.Write("<br>SQLGuia: " + sSQLGuia) }

        bHayParametros = false
        ParametroCargaDeSQL(sSQLGuia,0)  
  
    var sSQLTra  = "SELECT TA_ID,TA_TipoDeRutaCG94, TA_CodigoIdentificador, TA_End_Warehouse_ID "
        sSQLTra += ",TA_FolioCliente, TA_Folio, Alm_Numero, Man_ID, Alm_Ruta, TA_Cancelada "
        sSQLTra += ",(SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = t.TA_Start_Warehouse_ID ) as ALMACENORIGEN "
        sSQLTra += ",(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID) as Origen " 
        sSQLTra += ",Alm_Nombre as Destino, ISNULL(Alm_Estado,'') as Estado "
        sSQLTra += ",ISNULL((SELECT Alm_Numero FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID),'Sin numero') as Num_Origen "
        sSQLTra += ",ISNULL(Alm_Numero,'Sin numero') as Num_Destino "
        sSQLTra += ",(SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = t.Cli_ID) as Cliente "
        sSQLTra += ",dbo.fn_CatGral_DameDato(65,t.TA_TipoTransferenciaCG65) as Tipo, TA_TipoTransferenciaCG65 "
        sSQLTra += ",Alm_Nombre, ISNULL(Alm_Responsable,'') as Responsable, Alm_RespTelefono, Alm_Clave, Alm_Calle, Alm_Colonia"
        sSQLTra += ",ISNULL(Alm_Delegacion,'') as Delegacion, ISNULL(Alm_Ciudad,'') as Ciudad "
        sSQLTra += ",Alm_CP, Lot_ID, TA_Transportista, TA_Guia, TA_Transportista2, TA_Guia2 "
        sSQLTra += ",Alm_RequierePermiso, Alm_HorarioIngreso, Alm_TipoAcceso, TA_Start_Warehouse_ID "
        sSQLTra += ",TA_EstatusCG51,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as ESTATUS "
        sSQLTra += ",TA_UbicacionTienda, TA_HorarioAtencion, TA_ArchivoID, TA_RemisionRecibida "
        sSQLTra += ",Alm_CiudadC, Alm_HorarioLV, Alm_HorarioSabado, Alm_Domingo "
        sSQLTra += ",CONVERT(NVARCHAR(20),TA_FechaRegistro,103) as FECHAREGISTRO "
        sSQLTra += ",CONVERT(NVARCHAR(20),TA_FechaElaboracion,103) as FECHAELABRACION "
        sSQLTra += ",CONVERT(NVARCHAR(20),TA_FechaEntrega,103) as FECHAENTREGA "
        sSQLTra += ",ISNULL(TA_Recibido, 0 ) AS TA_EsRecibido "
        sSQLTra += ",t.Cli_ID as CLIID "
        sSQLTra += ",t.TA_FacturaCliente, TA_ArchivoID "
        sSQLTra += ",TA_EnvioParcial, CONVERT(NVARCHAR(20),TA_EnvioParcialFecha,103) as TA_EnvioParcialFecha "
        sSQLTra += ",dbo.fn_Usuario_DameNombreUsuario( TA_EnvioParcialUsuario ) as UsuarioEP "
        sSQLTra += "FROM TransferenciaAlmacen t, Almacen a "
        sSQLTra += "WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        sSQLTra += "AND t.TA_ID = " + iTAID

        if(bIQDebug){ Response.Write("<br>SQLTrans: " + sSQLTra) }

        bHayParametros = false
        ParametroCargaDeSQL(sSQLTra,0)

        var TA_Folio = Parametro("TA_Folio","")

        var TA_FolioRemision = ""
        var TA_FolioRuta = ""
        var TAF_FolioEntrada = ""
        var TAF_FolioCargo = ""
        var FechaFolioEntrada = ""
        var FechaFolioCargo = ""
        var TAF_UsuarioFolioEntrada = ""   

        var sSQLFolios = "SELECT TOP 1 TA_FolioRemision, ISNULL(TA_FolioRuta,-1) as Ruta "
            sSQLFolios += ",ISNULL(TAF_FolioEntrada,'') Entrada, ISNULL(TAF_FolioCargo,'') FolioCargo "
            sSQLFolios += ",ISNULL((SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](TAF_UsuarioFolioEntrada) ),'Sin registros') UsuarioNE "
            sSQLFolios += ",CONVERT(NVARCHAR(20),TAF_FechaFolioEntrada,103) as FechaFolioEntrada "        
            sSQLFolios += ",CONVERT(NVARCHAR(20),TAF_FechaFolioCargo,103) as FechaFolioCargo "
            sSQLFolios += " FROM TransferenciaAlmacen_FoliosEKT "
            sSQLFolios += " WHERE TA_ID = " + iTAID
            sSQLFolios += " ORDER BY TAF_ID DESC "

            if(bIQDebug){ Response.Write("<br>SQLFolios: " + sSQLFolios) } 

        var rsFolios = AbreTabla(sSQLFolios,1,0)

        if(!rsFolios.EOF){

          TA_FolioRemision = rsFolios.Fields.Item("TA_FolioRemision").Value
          TA_FolioRuta = rsFolios.Fields.Item("Ruta").Value
          TAF_FolioEntrada = rsFolios.Fields.Item("Entrada").Value
          TAF_FolioCargo = rsFolios.Fields.Item("FolioCargo").Value
          FechaFolioEntrada = rsFolios.Fields.Item("FechaFolioEntrada").Value
          FechaFolioCargo = rsFolios.Fields.Item("FechaFolioCargo").Value
          TAF_UsuarioFolioEntrada = rsFolios.Fields.Item("UsuarioNE").Value

        }
        rsFolios.Close() 
        var Transportista = Parametro("TA_Transportista","")
        var Guia = Parametro("TA_Guia","")  

        if (Parametro("TA_Guia2","") != ""){
            Guia = Parametro("TA_Guia2","")  
            Transportista = Parametro("TA_Transportista2","")
        }

  }

  if(iOVID > -1){
  
    var intSisEdi = 19 //ojo con está variable
    var bolEsEdiSis = false
    var bolEsCan = false
    var bolEsRef = false

    /*var Cli_ID = Parametro("Cli_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var Usu_ID = Parametro("IDUsuario",0)
    var TA_ID = Parametro("TA_ID",-1)	
    var EsTransportista = Parametro("EsTransportista", 0)  */

    var sSQLGuia  = "SELECT TOP 1 PG.Prov_ID, PG.ProG_ID, PG.ProG_NumeroGuia, PG.TA_ID, PG.OV_ID, OV.Cli_ID "
        sSQLGuia += ",(SELECT P.Prov_Nombre + ' - ' + P.Prov_RazonSocial FROM Proveedor P WHERE P.Prov_ID = PG.Prov_ID) AS NOMPROV "
        sSQLGuia += ",(SELECT CLI.Cli_Nombre FROM Cliente CLI WHERE CLI.Cli_ID = OV.Cli_ID) AS CLIENTE "
        //sSQLGuia += ",TA.TA_RecibidoFecha "
        sSQLGuia += ",(SELECT MS.Man_Folio FROM Manifiesto_Salida MS WHERE MS.Man_ID = OV.Man_ID) AS FOLIOMANIFIESTO "
        /*sSQLGuia += ",(SELECT CONVERT(NVARCHAR(20),MS.Man_FechaConfirmado,22) FROM Manifiesto_Salida MS " 
        sSQLGuia += "     WHERE MS.Man_ID = TA.Man_ID) AS FECHACONFMANIFIESTO "
        sSQLGuia += ",CONVERT(VARCHAR, DATEADD(HH, "
        sSQLGuia += "                             (SELECT ISNULL(Alm.Alm_TiempoEntregaHrs, 0) FROM Almacen Alm "
        sSQLGuia += "                                WHERE Alm.Alm_ID = TA.TA_End_Warehouse_ID) "
        sSQLGuia += ",(SELECT MS.Man_FechaRegistro FROM Manifiesto_Salida MS WHERE MS.Man_ID = TA.Man_ID)), 23) "
        sSQLGuia += ", PG.ProG_FechaEntrega "*/
        sSQLGuia += "FROM Proveedor_Guia PG, Orden_Venta OV "
        sSQLGuia += "WHERE PG.ProG_NumeroGuia = OV.OV_TRACKING_NUMBER "
        sSQLGuia += "AND PG.OV_ID = OV.OV_ID "
        sSQLGuia += "AND PG.Prov_ID = " + iProvID
        sSQLGuia += " AND PG.ProG_ID = " + iProGID

   	    if(bIQDebug){ Response.Write("<br>sSQLGuia: " + sSQLGuia) }
      
        bHayParametros = false
        ParametroCargaDeSQL(sSQLGuia,0) 
	
    var sSQLOrdVta = "SELECT OV_ID "
        sSQLOrdVta += ",Cort_ID, OV_Test, OV_Folio, OV_Serie, OV_FechaVenta, CONVERT(NVARCHAR, OV_FechaVenta,103) AS FECHAVTA "
        sSQLOrdVta += ",CONVERT(NVARCHAR, OV_FechaElaboracion,103) AS FECHAELAB, OV_FechaElaboracion "
        sSQLOrdVta += ",OV_FechaRequerida, CONVERT(NVARCHAR, OV_FechaRequerida,103) AS FECHAREQ "
        sSQLOrdVta += ",OV_UsuIDSolicita, OV_Total, OV_Articulos, OV_CUSTOMER_SO, OV_CUSTOMER_NAME, OV_SHIPPING_ADDRESS " 
        sSQLOrdVta += ",OV_TRACKING_COM, OV_TRACKING_NUMBER, OV_STORE_LOC, OV_TEXTO, OV_STAT5, OV_EstatusID, OV_EstatusCG51 "
        sSQLOrdVta += ",dbo.fn_CatGral_DameDato(51,[OV_EstatusCG51]) AS ESTATUS "
        sSQLOrdVta += ",OV_TipoOVG47, Cli_ID, OV_ClienteOC_ID, OV_BPM_Pro_ID, OV_BPM_Flujo, OV_BPM_Estatus, OV_BPM_Cambio "
        sSQLOrdVta += ",OV_BPM_UsuID, OV_BPM_AlrID, OV_ImpresionPiking, OV_FechaRegistro, OV_Contenido, OV_Email, OV_Telefono " 
        sSQLOrdVta += ",OV_Calle, OV_NumeroExterior, OV_NumeroInterior, OV_CP, OV_Colonia, OV_Delegacion, OV_Ciudad, OV_Estado " 
        sSQLOrdVta += ",OV_Pais, OV_Terminales, OV_SIMS, OV_DirMrgErr, OV_Cancelada, OV_CancelacionFecha, OV_MotivoCancelacion "
        sSQLOrdVta += ",OV_ReferenciaDomicilio1, OV_ReferenciaDomicilio2, OV_ReferenciaTelefono, OV_ReferenciaPersona, OV_ComentarioGeneral "
        sSQLOrdVta += ",OV_Calle + ' ' + OV_NumeroExterior + ' ' + OV_NumeroInterior + ', ' + OV_Colonia + ', ' + OV_Delegacion + ' '"
        sSQLOrdVta += ", + OV_Ciudad + ', ' + OV_Estado + ', ' + OV_Pais + ', ' + OV_CP AS OV_DireccionOriginal " 
        sSQLOrdVta += ",(SELECT Nombre FROM dbo.tuf_Usuario_Informacion(OV_UsuarioCambioDireccion) ) AS OV_NombreUsuarioCambio " 
        sSQLOrdVta += ",ISNULL((SELECT TOP 1 CONVERT(NVARCHAR(50),OV_FechaCambio,103) FROM Orden_Venta_Historico_Direccion "
        sSQLOrdVta += " WHERE OV_ID = A.OV_ID ORDER BY OV_FechaCambio DESC ),'') AS OV_FechaModificada "
        sSQLOrdVta += ",dbo.fn_CatGral_DameDato(360,OV_EstatusCG360) AS FallidoMotivo "
        sSQLOrdVta += ",(SELECT Nombre FROM dbo.tuf_Usuario_Informacion(OV_FallidoUsuario)) AS OV_FallidoNombre " 
        sSQLOrdVta += ",CONVERT(NVARCHAR(30), OV_FallidoFecha, 103) AS OV_FallidoFecha "
        sSQLOrdVta += " FROM Orden_Venta A "
        sSQLOrdVta += " WHERE OV_ID = "+ iOVID  
       
   	    if(bIQDebug){ Response.Write("<br>SQLOrdVta: " + sSQLOrdVta) }
      
        bHayParametros = false
        ParametroCargaDeSQL(sSQLOrdVta,0)    

        if( parseInt(SistemaActual) == intSisEdi ){
          bolEsEdiSis = true
        }

        if( parseInt(Parametro("OV_Cancelada", 0)) == 1 ){
          bolEsCan = true
        }

        if( Parametro("OV_ReferenciaDomicilio1", "") != "" ){
          bolEsRef = true
        }

        //Se agrega Validacion 
        bolEsBotEditar = false
        bolEsBotFallido = false
        bolEsBotReIntento = false

        if( parseInt(Parametro("OV_EstatusCG51")) == 16 ){
          bolEsBotReIntento = true
        }

        if( parseInt(Parametro("OV_EstatusCG51")) < 9 || parseInt(Parametro("OV_EstatusCG51")) == 16 ){
          bolEsBotEditar = true
        }

        //Valida la existencia del estatus en los permitidos
        //Se agrega la validación de los diferentes estatus
        if( ExisteEnArreglo( parseInt(Parametro("OV_EstatusCG51")), [5, 6, 7, 8, 16] ) ){
          bolEsBotFallido = true
        }
  
  }
  
  //Es transportista        
  var bolEsTransportista = ( iEsTransportista == 1 )
  iCliID = Parametro("Cli_ID",-1)
  
  if(bIQDebug){ Response.Write("<br>Cli_ID: " + iCliID) }

%>  
<div class="wrapper wrapper-content">
	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
          <% if(iTAID > -1){ %>
          <div class="row">
            <div class="col-lg-12">
              <h2 class="pull-right"><b class="text-danger"><%=Parametro("ProG_NumeroGuia","")%></b><p><small><%//=Parametro("CLIENTE","")%></small></p></h2>
              <h2><%=Parametro("CLIENTE","")%></h2>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12"> 
              <strong>Manifiesto:&nbsp;&nbsp;</strong> <a class="text-navy"><b><%=Parametro("FOLIOMANIFIESTO","")%></b></a>
            </div>
          </div>
          <div class="row"><!-- Renglon separador -->
            <br>
						<div class="ibox-content"></div>
					</div>
          <div class="row"> 
            <div class="col-lg-5">
              <!--Datos de la Orden de compra-->
             <dl class="dl-horizontal">
              <dt>Fecha entrega:</dt>
              <dd><%=Parametro("FECHAENTREGA","")%></dd>
              <dt>Fecha de elaboraci&oacute;n:</dt>
              <dd><%=Parametro("FECHAELABRACION","")%></dd>
              <dt>Fecha de registro:</dt>
              <dd><%=Parametro("FECHAREGISTRO","")%></dd>
              <dt>Corte:</dt>
              <dd><%=Parametro("TA_ArchivoID","")%></dd>
              <%
                var Man_ID = Parametro("Man_ID",-1)

                  if(Man_ID > 1) {
                    
                  var sSQLMan = "SELECT Man_Folio, Man_Operador, Man_Vehiculo, Man_Placas, Man_Usuario "
                      sSQLMan += ",Aer_ID, Man_Ruta "
                      sSQLMan += ",dbo.fn_CatGral_DameDato(94,Man_TipoDeRutaCG94) AS TIPORUTA "
                      sSQLMan += ",Edo_ID, ISNULL((SELECT Edo_Nombre " 
                      sSQLMan += " FROM Cat_Estado edo "
                      sSQLMan += " WHERE edo.Edo_ID = ms.Edo_ID),'') AS estado "
                      sSQLMan += ",Man_Borrador, Man_PeticionEnviada "
                      sSQLMan += ", CONVERT(NVARCHAR(20),Man_FechaConfirmado,103) AS FechaConfirmado "        
                      sSQLMan += ", CONVERT(NVARCHAR(20),Man_FechaRegistro,103) AS FechaRegistro "
                      sSQLMan += " FROM Manifiesto_Salida ms "
                      sSQLMan += " WHERE Man_ID = " + Man_ID

                      if(bIQDebug){ Response.Write("<br>SQLMan: " + sSQLMan) }

                var rsMan = AbreTabla(sSQLMan,1,0)
                  if(!rsMan.EOF){
                    var Ruta = ""
                    if (Parametro("Alm_Ruta",0) > 0){
                      Ruta = "R " + Parametro("Alm_Ruta",0)
                    }

              %>
              <dt>&nbsp;</dt>
              <dd>&nbsp;</dd>
              <dt>Fecha de manifiesto:</dt>
              <dd><%=rsMan.Fields.Item("FechaRegistro").Value%></dd>
              <dt>Transportista:</dt>
              <dd class="textCopy"><%=Parametro("NOMPROV","")%></dd>
              <dt>Gu&iacute;a:</dt>
              <dd class="textCopy"><%=Guia%></dd>
              <dt>Ruta:</dt>
              <dd class="textCopy"><%=Ruta%></dd>
              <dt>Tipo ruta:</dt>
              <dd><%=rsMan.Fields.Item("TIPORUTA").Value %></dd>
              <dt>Estatus:</dt>
              <% if (rsMan.Fields.Item("Man_Borrador").Value == 1 ) { %>
              <dd>En Piso</dd>
              <% } else { %>
              <dd>Man Cerrado</dd>
              <%  if (rsMan.Fields.Item("Man_PeticionEnviada").Value == 1 ) { %>
              <dt>Confirmado:</dt>
              <dd><%=rsMan.Fields.Item("FechaConfirmado").Value%></dd>
              <%  } 
                 }
                  }
                rsMan.Close()   

                  } else {
              %>
              <dt>&nbsp;</dt>
              <dd>&nbsp;</dd>
              <dt>Transportista:</dt>
              <dd data-clipboard-text="<%=Parametro("TA_Transportista","")%>" class="textCopy"><%=Parametro("TA_Transportista","")%></dd>
              <dt>Gu&iacute;a:</dt>
              <dd><%=Parametro("ProG_NumeroGuia","")%></dd>
              <%                
                  }
                if(iCliID == 6){
              %>
              <dt>&nbsp;</dt>
              <dd>&nbsp;</dd>
              <dt>Remisi&oacute;n:</dt>
              <dd class="textCopy" data-clipboard-text="<%=TA_FolioRemision%>"><%=TA_FolioRemision%></dd>
              <dt>Hoja de ruta/ Gu&iacute;a DHL:</dt>
              <dd class="textCopy" data-clipboard-text="<%=TA_FolioRuta%>"><%=TA_FolioRuta%></dd>
              <% if(TAF_FolioEntrada != ""){ %>
              <dt>Folio entrada:</dt>
              <dd class="textCopy" data-clipboard-text="<%=TAF_FolioEntrada%>"><%=TAF_FolioEntrada%></dd>
              <dt>Fecha entrada:</dt>
              <dd class="textCopy" data-clipboard-text="<%=FechaFolioEntrada%>"><%=FechaFolioEntrada%></dd>
              <dt>Usuario nota de entrada:</dt>
              <dd class="textCopy" data-clipboard-text="<%=TAF_UsuarioFolioEntrada%>"><%=TAF_UsuarioFolioEntrada%></dd><%                
                 }
                 if(TAF_FolioCargo != ""){
              %>
              <dt>Folio cargo:</dt>
              <dd class="textCopy" data-clipboard-text="<%=TAF_FolioCargo%>"><%=TAF_FolioCargo%></dd>
              <dt>Fecha cargo:</dt>
              <dd class="textCopy" data-clipboard-text="<%=FechaFolioCargo%>"><%=FechaFolioCargo%></dd>
              <% }                         
                }%>
            </dl>
            </div>
            <!--Datos del Proveedor-->
            <div class="col-lg-7" id="cluster_info">
              <dl class="dl-horizontal">
                <dt><!--Direcci&oacute;n de entrega--></dt>
              </dl>
              <dl class="dl-horizontal">
                <dt><!--Calle:--></dt>
                <dd><%//=Parametro("Alm_Calle","")%></dd>
                <dt><!--Colonia:--></dt>
                <dd><%//=Parametro("Alm_Colonia","")%></dd>
                <dt><!--Delegaci&oacute;n/Municipio:--></dt>
                <dd><%//=Parametro("Delegacion","")%></dd>
                <dt><!--Ciudad:--></dt>
                <dd><%//=Parametro("Ciudad","")%></dd>
                <dt><!--Estado:--></dt>
                <dd><%//=Parametro("Estado","")%></dd>
                <dt><!--C&oacute;digo postal:--></dt>
                <dd><%//=Parametro("Alm_CP","")%></dd>
                <dt><!--Responsable:--></dt>
                <dd><%//=Parametro("Responsable","")%></dd>
                <dt><!--Tel&eacute;fono:--></dt>
                <dd><%//=Parametro("Alm_RespTelefono","")%></dd>
                <dt><!--Horario de atenci&oacute;n:--></dt>
                <dd><%//=Parametro("Alm_HorarioLV","")%></dd>
                <dt>&nbsp;</dt>
                <dd>&nbsp;</dd>
                <% /*
                if(Parametro("TA_EnvioParcial","")==0){
                  var EnvioParcial = "NO"
                } else {
                  var EnvioParcial = "SI" 
                } */
                %>
                <dt><!--Env&iacute;o Parcial:--></dt>
                <dd><%//=EnvioParcial%></dd>
                <%
                  //if(EnvioParcial=="SI"){
                %>
                <dt><!--Envi&oacute;:--></dt>
                <dd><%//=Parametro("UsuarioEP","")%></dd>
                <dt><!--Fecha env&iacute;o:--></dt>
                <dd><%//=Parametro("TA_EnvioParcialFecha","")%></dd><%
                  //}
                %>
              </dl>
            </div>
          </div>
          <% } if(iOVID > -1){ %>
          <div class="row">
            <div class="col-lg-12">
              <h2 class="pull-right"><b class="text-danger"><%=Parametro("ProG_NumeroGuia","")%></b><p><small><%//=Parametro("CLIENTE","")%></small></p></h2>
              <h2><%=Parametro("CLIENTE","")%></h2>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12"> 
              <strong>Manifiesto:&nbsp;&nbsp;</strong> <a class="text-navy"><b><%=Parametro("FOLIOMANIFIESTO","")%></b></a>
            </div>
          </div>
          <div class="row"><!-- Renglon separador -->
            <br>
						<div class="ibox-content"></div>
					</div>          
          <div class="row">
            <div class="col-md-12">
              <!--Datos de la Orden de compra-->
              <dl class="dl-horizontal">
                <dt>Fecha requerida:</dt>
                <dd><%=Parametro("FECHAREQ","")%></dd>
                <dt>Fecha de venta:</dt>
                <dd><%=Parametro("FECHAVTA","")%></dd>
                <dt>Fecha de elaboraci&oacute;n:</dt>
                <dd><%=Parametro("FECHAELAB","")%></dd>
                <dt>Transportista:</dt>
                <dd><%=Parametro("OV_TRACKING_COM","")%></dd>
                <dt>Gu&iacute;a:</dt>
                <dd><%=Parametro("OV_TRACKING_NUMBER","")%></dd>           
                <dt>Corte:</dt>
                <dd><%=Parametro("Cort_ID","")%></dd>                                        
              </dl>
            </div>          
          </div>
          <!--Aquí podría ir lo de la Dirección-->
          
          <% } %>
					<div class="row">
						<div class="ibox-content" id="dvGridTraOV"></div>
					</div>
				</div>
			</div>
		</div>
    <div class="col-lg-4" id="dvDetalle">
      <div id="divHistLineTimeGrid"></div>
    </div>                
  </div>            
	</div>
<!--/div-->
              
<script type="text/javascript">

    $(document).ready(function() { 
      
      //AsignaValorLlave();
      $('#Prov_ID').val(<%=iProvID%>);
      $('#ProG_ID').val(<%=iProGID%>);
      $('#TA_ID').val(<%=iTAID%>);                  
      $('#OV_ID').val(<%=iOVID%>);
        CargaGridTAOV();
      <% if(iTAID > -1) { %>
        CargaHistoricoLineTimeTA();
      <% } if(iOVID > -1) {%>
        CargaHistoricoLineTimeOV();
      <% } %>
      
    });

    var loading = '<div class="spiner-example">'+
            '<div class="sk-spinner sk-spinner-three-bounce">'+
              '<div class="sk-bounce1"></div>'+
              '<div class="sk-bounce2"></div>'+
              '<div class="sk-bounce3"></div>'+
            '</div>'+
          '</div>'+
          '<div>Cargando informaci&oacute;n, espere un momento...</div>'  
  
    function CargaGridTAOV(){

      var sDatos  = "?Prov_ID="+$("#Prov_ID").val();
          sDatos += "&ProG_ID="+$("#ProG_ID").val();
          
		      $('#dvGridTraOV').hide('slow');
          $("#dvGridTraOV").html(loading);
          if($('#TA_ID').val() > -1){
		        $("#dvGridTraOV").load("/pz/wms/Proveedor/InformacionGuiaTAGrid.asp" + sDatos);        
          } if($('#OV_ID').val() > -1){
            $("#dvGridTraOV").load("/pz/wms/Proveedor/InformacionGuiaOVGrid.asp" + sDatos);
          }
          $("#dvGridTraOV").show('slow');  
      
    }    
        
    
    function CargaHistoricoLineTimeTA(){
      //alert("CargaHistoricoLineTimeTA()");
		  var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
          sDatos += "&Usu_ID="+$("#IDUsuario").val();
          //alert(sDatos);
          $('#divHistLineTimeGrid').hide('slow');
          $("#divHistLineTimeGrid").html(loading);      
		      $("#divHistLineTimeGrid").load("/pz/wms/Proveedor/TA_Historico.asp" + sDatos);
          $("#divHistLineTimeGrid").show('slow');
    }                         

    function CargaHistoricoLineTimeOV(){
        
		  var sDatos  = "?OV_ID="+$("#OV_ID").val(); 
		      sDatos += "&Usu_ID="+$("#IDUsuario").val();
      
		      $('#divHistLineTimeGrid').hide('slow');
          $("#divHistLineTimeGrid").html(loading);
		      $("#divHistLineTimeGrid").load("/pz/wms/Proveedor/OV_FichaHistoricoGrid.asp" + sDatos);        
          $("#divHistLineTimeGrid").show('slow');
    }  
  

                         
</script>    
<%
// =============================================
// Author: JD
// Create date: 12/04/2021
// Description:	Caída de datos de la Guía seleccionada
// ----- Modify ------
// Author: 
// Modify date: dd/mm/aaaa
// Description:
// =============================================   
%>      