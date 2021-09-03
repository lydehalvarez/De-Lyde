<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir
    //HA ID: 3  2020-SEP-07 Agregado de Boton de Liberacion de Recepcion
	//HA ID: 4	2021-MAR-16 Agregado de Validación de si es visible por transportista
    //HA ID: 6  2021-JUL-26 Agregado de Siniestro y selección de series para siniestro
    //HA ID: 7  2021-AGO-04 Siniestro: Cierre de Siniestro a la Transferencia
    //HA ID: 8  2021-AGO-24 Entrega Parcial: Agregado de Entrega Parcial a Evento y seleccion de Evento

    var urlBase = "/pz/wms/"
    var urlBaseTemplate = "/Template/inspina/";
    
    var sSQLTr = ""

   	var Cli_ID = Parametro("Cli_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
	var EsTransportista = Parametro("EsTransportista", 0) //HA ID: 4
   
    /* HA ID: 6 Se agrega Campos de Existencia de Siniestro INCIDENCIA de Tipo Siniestro Total o Parcial */
    /* HA ID: 8 Se agrega Campos de Existencia de Entrega Parcial INCIDENCIA de tipo Entrega Parcial */
   
    if(TA_ID == -1){
        Response.Write("<strong>Lo sentimos hubo un error al cargar la ficha, el &aacute;rea de sistemas lo esta resolviendo.</strong><br />")
        Response.Write("TA_ID_1 = "+ TA_ID)
        Response.End()
    } else {
	    sSQLTr  = "SELECT TA_ID,TA_TipoDeRutaCG94, TA_CodigoIdentificador, TA_End_Warehouse_ID "
                +  " , TA_FolioCliente, TA_Folio, Alm_Numero, Man_ID, Alm_Ruta, TA_Cancelada "
                +  " , (SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = t.TA_Start_Warehouse_ID ) as ALMACENORIGEN "
                +  " , (SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID) as Origen " 
                +  " , Alm_Nombre as Destino, ISNULL(Alm_Estado,'') as Estado "
                +  " , ISNULL((SELECT Alm_Numero FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID),'Sin numero') as Num_Origen "
                +  " , ISNULL(Alm_Numero,'Sin numero') as Num_Destino "
                +  " , (SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = t.Cli_ID) as Cliente "
                +  " , dbo.fn_CatGral_DameDato(65,t.TA_TipoTransferenciaCG65) as Tipo, TA_TipoTransferenciaCG65 "
                +  " , Alm_Nombre, ISNULL(Alm_Responsable,'') as Responsable, Alm_RespTelefono, Alm_Clave, Alm_Calle, Alm_Colonia"
                +  " , ISNULL(Alm_Delegacion,'') as Delegacion, ISNULL(Alm_Ciudad,'') as Ciudad "
                +  " , Alm_CP, Lot_ID, TA_Transportista, TA_Guia, TA_Transportista2, TA_Guia2 "
                +  " , Alm_RequierePermiso, Alm_HorarioIngreso, Alm_TipoAcceso, TA_Start_Warehouse_ID "
                +  " , TA_EstatusCG51,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as ESTATUS "
                +  " , TA_UbicacionTienda, TA_HorarioAtencion, TA_ArchivoID, TA_RemisionRecibida "
                +  " , Alm_CiudadC, Alm_HorarioLV, Alm_HorarioSabado, Alm_Domingo "
                +  " , CONVERT(NVARCHAR(10),TA_FechaRegistro,103) as FECHAREGISTRO "
                +  " , CONVERT(NVARCHAR(10),ISNULL(TA_FechaElaboracion,TA_FechaRegistro),103) as FECHAELABRACION "
                +  " , CONVERT(NVARCHAR(10),TA_FechaEntrega,103) as FECHAENTREGA "
                +  " , ISNULL(TA_Recibido, 0 ) AS TA_EsRecibido "
                +  " , t.Cli_ID as CLIID "
                +  " , t.TA_FacturaCliente "
                +  " , TA_Recibido,TA_RecibioUsuario "
                +  " , TA_RecibioUsuario "
                +  " , CONVERT(NVARCHAR(10),TA_RecibidoFecha,103) FechaReciboRecibio "
                +  " , CASE WHEN EXISTS( SELECT TOP 1 1 FROM Incidencia Ins "
                                      + " WHERE Ins.InsT_ID IN ( 39 /*Siniestro Total*/, 40 /*Siniestro Parcial*/ ) "
                                      +   " AND Ins.TA_ID = t.TA_ID ) "
                +         " THEN 1 ELSE 0 END AS TA_HaySiniestro "
                +  " , CASE WHEN EXISTS( SELECT TOP 1 1 FROM Incidencia Ins "
                                      + "WHERE Ins.InsT_ID IN ( 30 /* Entrega Parcial */ ) "
                                      +   " AND Ins.TA_ID = t.TA_ID ) "  
                +         " THEN 1 ELSE 0 END AS TA_HayEntregaParcial "
                +  " FROM TransferenciaAlmacen t, Almacen a "
                +  " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
                +  " AND t.TA_ID = " + TA_ID


            bHayParametros = false
            ParametroCargaDeSQL(sSQLTr,0)  
   
       }
   
       if(Cli_ID == -1){
           Cli_ID = Parametro("CLIID",-1)
       }
	   var 	TA_Folio = Parametro("TA_Folio","")
	   
       var TA_FolioRemision = ""
       var TA_FolioRuta = ""
       var TAF_FolioEntrada = ""
       var TAF_FolioCargo = ""
       var FechaFolioEntrada = ""
       var FechaFolioCargo = ""
   
   
		//var TA_FolioRuta = BuscaSoloUnDato("ISNULL(TA_FolioRuta,'')","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,"1",0) 
		//var TA_DeRemision = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
   
        var sSQLFolios  = "select top 1 TA_FolioRemision, ISNULL(TA_FolioRuta,-1) as Ruta, ISNULL(TAF_FolioEntrada,'') Entrada, ISNULL(TAF_FolioCargo,'') FolioCargo "
                 + ", CONVERT(NVARCHAR(20),TAF_FechaFolioEntrada,103) as FechaFolioEntrada "        
                 + ", CONVERT(NVARCHAR(20),TAF_FechaFolioCargo,103) as FechaFolioCargo "
                 + " from TransferenciaAlmacen_FoliosEKT "
                 + " where TA_ID = " + TA_ID
                 + " Order by TAF_ID desc "
           
     var rsFolios = AbreTabla(sSQLFolios,1,0)
     if(!rsFolios.EOF){
        TA_FolioRemision = rsFolios.Fields.Item("TA_FolioRemision").Value
        TA_FolioRuta = rsFolios.Fields.Item("Ruta").Value
        TAF_FolioEntrada = rsFolios.Fields.Item("Entrada").Value
        TAF_FolioCargo = rsFolios.Fields.Item("FolioCargo").Value
        FechaFolioEntrada = rsFolios.Fields.Item("FechaFolioEntrada").Value
        FechaFolioCargo = rsFolios.Fields.Item("FechaFolioCargo").Value
     }
     rsFolios.Close()  
   
    var Transportista = Parametro("TA_Transportista","")
    var Guia = Parametro("TA_Guia","")  
           
    if (Parametro("TA_Guia2","") != ""){
        Guia = Parametro("TA_Guia2","")  
        Transportista = Parametro("TA_Transportista2","")
    }   
    var ClaseEstatus = ""
    ClaseEstatus = "plain"
	var EstatusCG51 = Parametro("TA_EstatusCG51",-1)

    switch (parseInt(EstatusCG51)) {
        case 4:
             ClaseEstatus = "info"   
        break;    
        case 5:
            ClaseEstatus = "primary"
        break;     
        case 10:
            ClaseEstatus = "success"
        break;    
        case 11:
            ClaseEstatus = "warning"
        break;   
        case 16:
            ClaseEstatus = "danger"
        break;        
    }   
            
    var bolEsTransportista = ( EsTransportista == 1 )

    /* HA ID: 5 Se agrega validación de estatus si es siniestro */
    var bolHaySiniestro = ( Parametro("TA_HaySiniestro", 0) == 1 )
    /* HA ID: 8 Se agrega validación de estatus si es Entrega Parcial */
    var bolHayEntregaParcial = ( Parametro("TA_HayEntregaParcial", 0) == 1 )
%>

<style type="text/css">
 
.Caja-Flotando {
	position: fixed;
	right: 10px;
	top: 10px;
	width: 29%;
    overflow-y: scroll;
    height: -webkit-fill-available;
  }
 
</style>
    
<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">

<% /* HA ID: 6 INI Scripts para siniestros */ %>
<% /* HA ID: 8 INI Scripts para Entrega Parcial
                , se cambia cssMdlEveSiniestro por cssMdlEveComentario
                , bolEsSiniestro por bolSiComentario
    */ 
%>
<% /* HA ID: 8 Se cambia cssMdlEveSiniestro por cssMdlEveComentario */ %>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script type="text/javascript">

    var Evento = {
          url: "/pz/wms/TA/"
        , Modal: {
            Combo: {
                Seleccionar: function(){
                    var intTA_Estatus51 = $("#selMdlEveEnt_Est_ID").val();

                    <% /* HA ID: 8 Se agrega estatus Entrega Parcial y ee cambia cssMdlEveSiniestro por cssMdlEveComentario */ %>
                    if( intTA_Estatus51 == 18 || intTA_Estatus51 == 24 || intTA_Estatus51 == 20 ){
                        $(".cssMdlEveComentario").show();
                    } else {
                        $(".cssMdlEveComentario").hide();
                    }

                }
            }
            , Abrir: function(){
                $(".cssMdlEveComentario").hide();
                $("#mdlEvento").modal("show");

                Evento.Modal.Limpiar();
            }
            , Guardar: function(){
                var bolError = false;
                var arrError = [];

                var intTA_ID = $("#TA_ID").val();

                var intEnt_Est_ID = $("#selMdlEveEnt_Est_ID").val();
                var strEve_Comentario = $("#txaMdlEveComentario").val().trim();
                var intIDUsuario = $("#IDUsuario").val();

                <% /* HA ID: 8 Se cambia bolEsSiniestro por bolSiComentario */ %>
                var bolSiComentario = ( intEnt_Est_ID == 18 || intEnt_Est_ID == 24 || intEnt_Est_ID == 20);

                if(intTA_ID == ""){
                    bolError = true;
                    arrError.push("- Identificador de Transferencia no permitido");
                }

                if( intEnt_Est_ID == -1 ){
                    bolError = true;
                    arrError.push("- Seleccionar el tipo de Evento");
                }

                if( bolSiComentario && strEve_Comentario == "" ){
                    bolError = true;
                    arrError.push("- Agregar el Comentario");
                }

                if( bolError ){
                    Avisa("warning", "Evento - Guardar", "Verificar el formulario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                        url: Evento.url + "TA_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 19
                            , TA_ID: intTA_ID
                            , Ent_Est_ID: intEnt_Est_ID
                            , Eve_Comentario: strEve_Comentario
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0 ){
                                Avisa("success", "Evento - Guardar", res.Error.Descripcion);
                                $('#mdlEve').modal('hide');
                                RecargaEnSiMismo();
                            } else {
                                Avisa("warning", "Evento - Guardar", res.Error.Descripcion);
                            }
                        }
                        , error: function(){
                            Avisa("error", "Evento - Guardado", "Error de Peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();

                        }
                    });
                }
            }
            , Limpiar: function(){
                $("#selMdlEveEnt_Est_ID").val("-1");
                $("#txaMdlEveComentario").val("");
            }
        }
    }

    var Serie = {
          url: "/pz/wms/TA/"
        , Listado: {
              Visualizar: function( prmJson ){
                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parents("tr");
                var intTA_ID = $(objPadre).data("ta_id");
                var intTAA_ID = $(objPadre).data("taa_id");

                var bolError = false;
                var arrError = [];

                if( intTA_ID == "" || intTAA_ID == "" ){
                    bolError = true;
                    arrError.push("- Los identificadores del erticulo no son permitidos");
                } 

                if( bolError ){
                    Avisa("warning", "Transferencia - Series - Listar", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {
                    
                    $.ajax({
                          url: Serie.url + "TA_Series_Listado.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              TA_ID: intTA_ID
                            , TAA_ID: intTAA_ID
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){

                            var objTr = "<tr id='trSerLis_" + intTA_ID + "_" + intTAA_ID + "'>"
                                    + "<td colspan='6'>"
                                        + res
                                    + "</td>"
                                + "</tr>"

                            $(objTr).insertAfter( objPadre );
                            $("#btnSeriesVer", objPadre).hide();
                            $("#btnSeriesOcultar", objPadre).show();

                            //Serie.Listado.RegistrosContar({TA_ID: intTA_ID, TAA_ID: intTAA_ID});
                        }
                        , error: function(){
                            Avisa("error", "Transferencia - Series - Listar", "Error en la Peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                }
            }
            , Ocultar: function( prmJson ){

                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parents("tr");
                var intTA_ID = $(objPadre).data("ta_id");
                var intTAA_ID = $(objPadre).data("taa_id");

                Cargando.Iniciar();

                $("#trSerLis_" + intTA_ID + "_" + intTAA_ID + "").remove();

                $("#btnSeriesVer", objPadre).show();
                $("#btnSeriesOcultar", objPadre).hide();

                Cargando.Finalizar();
            }
            , RegistrosContar: function(prmJson){
                var intTA_ID = prmJson.TA_ID;
                var intTAA_ID = prmJson.TAA_ID;
                var objPadre = $("#trSerLis_" + intTA_ID + "_" + intTAA_ID + "")

                var intTotReg = $(".cssTASerLisReg", objPadre).length;

                $("#lblTASerLisTot", objPadre).text(intTotReg);
            }
        }
        , Siniestro: {
            Guardar: function( prmJson ){
                var objBase = prmJson.Objeto;            
                var objPadre = $(objBase).parents("tr");

                var bolError = false;
                var arrError = [];

                var intTA_ID = $(objPadre).data("ta_id");
                var intTAA_ID = $(objPadre).data("taa_id");
                var intTAS_ID = $(objPadre).data("tas_id");
                var intIDUsuario = $("#IDUsuario").val();
                var intTAS_EsSiniestro = parseInt(prmJson.Valor);

                if( intTA_ID == "" || intTAA_ID == "" || intTAS_ID == "" ){
                    bolError = true;
                    arrError.push("- Identificadores de serie no permitidos")
                }

                if( bolError ){
                    Avisa("warning", "Serie - Siniestro", "Verificar formulario<br>" + arrError.join("<br>"));
                } else {
                    
                    $.ajax({
                          url: Serie.url + "TA_Ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 22
                            , TA_ID: intTA_ID
                            , TAA_ID: intTAA_ID
                            , TAS_ID: intTAS_ID
                            , TAS_EsSiniestro: intTAS_EsSiniestro
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0 ){

                                Avisa("success","Serie - Siniestro", res.Error.Descripcion);

                                Serie.Siniestro.Boton.Visualizar({
                                      TA_ID: intTA_ID
                                    , TAA_ID: intTAA_ID
                                    , TAS_ID: intTAS_ID
                                    , TAS_EsSiniestro: intTAS_EsSiniestro
                                });

                                if( res.Registro.Recargar == 1 ){
                                    setTimeout(function(){ RecargaEnSiMismo() }, 250);
                                }

                            } else {
                                Avisa("warning", "Serie - Siniestro", res.Error.Descripcion);
                            }
                        }
                        , error: function(){
                            Avisa("error", "Serie - Siniestro", "error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });
                }
            }
            , Boton: {
                Visualizar: function(prmJson){
                    $(".cssTASerLisReg").each(function(){
                        if( $(this).data("ta_id") == prmJson.TA_ID && $(this).data("taa_id") == prmJson.TAA_ID && $(this).data("tas_id") == prmJson.TAS_ID ){
                            if( prmJson.TAS_EsSiniestro == 1 ){
                                $("#btnSinSi", $(this)).show();
                                $("#btnSinNo", $(this)).hide();
                            } else {
                                $("#btnSinSi", $(this)).hide();
                                $("#btnSinNo", $(this)).show();
                            }
                        }
                    })
                }
            }
        }
        <% /* HA ID: 8 INI Se agrega Objeto Entrega Parcial */ %>
        , EntregaParcial: {
            Guardar: function( prmJson ){
                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parents("tr");

                var bolError = false;
                var arrError = [];

                var intTA_ID = $(objPadre).data("ta_id");
                var intTAA_ID = $(objPadre).data("taa_id");
                var intTAS_ID = $(objPadre).data("tas_id");
                var intIDUsuario = $("#IDUsuario").val();
                var intTAS_EsEntregaParcial = parseInt(prmJson.Valor);

                if( intTA_ID == "" || intTAA_ID == "" || intTAS_ID == "" ){
                    bolError = true;
                    arrError.push("- Identificadores de serie no permitidos")
                }

                if( bolError ){
                    Avisa("warning", "Serie - Entrega Parcial - Guardar", "Verificar formulario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                          url: Serie.url + "TA_Ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 24
                            , TA_ID: intTA_ID
                            , TAA_ID: intTAA_ID
                            , TAS_ID: intTAS_ID
                            , TAS_EsEntregaParcial: intTAS_EsEntregaParcial
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0 ){

                                Avisa("success","Serie - Entrega Parcial - Guardar", res.Error.Descripcion);

                                Serie.EntregaParcial.Boton.Visualizar({
                                      TA_ID: intTA_ID
                                    , TAA_ID: intTAA_ID
                                    , TAS_ID: intTAS_ID
                                    , TAS_EsEntregaParcial: intTAS_EsEntregaParcial
                                });

                            } else {
                                Avisa("warning", "Serie - Entrega Parcial - Guardar", res.Error.Descripcion);
                            }
                        }
                        , error: function(){
                            Avisa("error", "Serie - Entrega Parcial - Guardar", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                }
            }

            , Boton: {
                Visualizar: function(prmJson){
                    $(".cssTASerLisReg").each(function(){
                        if( $(this).data("ta_id") == prmJson.TA_ID && $(this).data("taa_id") == prmJson.TAA_ID && $(this).data("tas_id") == prmJson.TAS_ID ){
                            if( prmJson.TAS_EsEntregaParcial == 1 ){
                                $("#btnEPaSi", $(this)).show();
                                $("#btnEPaNo", $(this)).hide();
                            } else {
                                $("#btnEPaSi", $(this)).hide();
                                $("#btnEPaNo", $(this)).show();
                            }
                        }
                    })
                }
            }
        }

        <% /* HA ID: 8 FIN */ %>
    }

<%  /* HA ID: 7 Cierre de Siniestro */ %>

    var Transferencia = {
        url: "/pz/wms/ta/"
        , Siniestro: {
            Cerrar: function( prmJson ){
               
                var bolError = false;
                var arrError = [];

                var intTA_ID = prmJson.TA_ID;
                var intIDUsuario = $("#IDUsuario").val();

                if( !(parseInt(intTA_ID) > -1 ) ){
                    bolError = true;
                    arrError.push("- Identificador de Transferencia no permitido");
                }

                if( bolError ){
                    Avisa("warning", "Transferencia - Siniestro - Cierre", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                        url: Transferencia.url + "TA_Ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 23
                            , TA_ID: intTA_ID
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function() {
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0){
                                Avisa("success", "Transferencia - Siniestro - Cierre", res.Error.Descripcion);
                                setTimeout(function(){ RecargaEnSiMismo() }, 250);
                            } else {
                                Avisa("warning", "Transferencia - Siniestro - Cierre", res.Error.Descripcion);
                            }
                        }
                        , error: function(){
                            Avisa("error", "Transferencia - Siniestro - Cierre", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                }
                
            }
        }

        <% /* HA ID: 8 INI Se agregar Cierre de Entrega Parcial */ %>
        , EntregaParcial: {
            Cerrar: function( prmJson ){
               
                var bolError = false;
                var arrError = [];

                var intTA_ID = prmJson.TA_ID;
                var intIDUsuario = $("#IDUsuario").val();

                if( !(parseInt(intTA_ID) > -1 ) ){
                    bolError = true;
                    arrError.push("- Identificador de Transferencia no permitido");
                }

                if( bolError ){
                    Avisa("warning", "Transferencia - Entrega Parcial - Cierre", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                        url: Transferencia.url + "TA_Ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 25
                            , TA_ID: intTA_ID
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function() {
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0){
                                Avisa("success", "Transferencia - Entrega Parcial - Cierre", res.Error.Descripcion);
                                setTimeout(function(){ RecargaEnSiMismo() }, 250);
                            } else {
                                Avisa("warning", "Transferencia - Entrega Parcial - Cierre", res.Error.Descripcion);
                            }
                        }
                        , error: function(){
                            Avisa("error", "Transferencia - Entrega Parcial - Cierre", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                }
                
            }
        }
        <% /* HA ID: 8 FIN */ %>
    }
<%  /* HA ID: 7 FIN  */ %>
</script>
<% /* HA ID: 5 FIN */ %>


    <div id="wrapper">
        <div class="row" id="TA_Contenido">
            <div class="col-sm-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                    <h2 class="pull-right copyID" title="<%=Parametro("TA_ID","")%>"><span class="textCopy"><%=TA_Folio%></span><p><small class="textCopy"><%=Parametro("TA_FolioCliente","")%></small></p></h2>
                                    <h2><span class="textCopy"><%=Parametro("Alm_Numero","")%></span>&nbsp;-&nbsp;<span class="textCopy"><%=Parametro("Alm_Nombre","")%></span></h2>
                                </div>
                            </div>
                            
                            <div class="col-lg-9">
                                <strong>Origen:&nbsp;&nbsp;</strong> <%=Parametro("Num_Origen","")%>&nbsp;-&nbsp;<%=Parametro("Origen","")%> 
                                <br>
                                <strong>Destino:</strong> <%=Parametro("Num_Destino","")%>&nbsp;-&nbsp;<%=Parametro("Destino","")%> 
                                 
                            </div>                            
                            
                            <div class="col-lg-3">
                                <div class="pull-right" style="line-height: 22px;"> Estatus: 
                                    <span class="label label-<%=ClaseEstatus%> textCopy"><%=Parametro("ESTATUS","")%></span>        
                                    <br> Tipo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <span class="label label-primary textCopy"><%=Parametro("Tipo","")%></span> 
                                </div>
                            </div>                            
                        </div>
                        <hr>        
                        <!-- div class="row">

                        </div  --> 
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
<%  
    var Man_ID = Parametro("Man_ID",-1)
    if(Man_ID > 1) { 
    var sSQLMan  = "select Man_Folio, Man_Operador, Man_Vehiculo, Man_Placas, Man_Usuario "
              //   + ", Prov_ID, ISNULL((select Prov_Nombre "
              //                       + " from Proveedor pv "
              //                      + " where pv.Prov_ID = ms.Prov_ID),'Sin Definir') as Transportista "
                 + ", Aer_ID, Man_Ruta "
                 + ", dbo.fn_CatGral_DameDato(94,Man_TipoDeRutaCG94) as TIPORUTA "
                 + ", Edo_ID, ISNULL((select Edo_Nombre " 
                                    + " from Cat_Estado edo "
                                   + " where edo.Edo_ID = ms.Edo_ID),'') as estado "
                 + ", Man_Borrador, Man_PeticionEnviada "
               //  + ", CASE Man_Borrador WHEN 1 THEN 'Borrador' ELSE 'Confirmado' END as ManEstatus "
              //  + ", CASE Man_PeticionEnviada WHEN 1 THEN 'Registrado con el transportista' "
             //                             + " ELSE 'No registrado' END as ManEstatus "
                 + ", CONVERT(NVARCHAR(20),Man_FechaConfirmado,103) as FechaConfirmado "        
                 + ", CONVERT(NVARCHAR(20),Man_FechaRegistro,103) as FechaRegistro "
                 + " from Manifiesto_Salida ms "
                 + " where Man_ID = " + Man_ID
    
     var rsMan = AbreTabla(sSQLMan,1,0)
            if(!rsMan.EOF){
                var Ruta = ""
                if (Parametro("Alm_Ruta",0) > 0){
                    Ruta = "R " + Parametro("Alm_Ruta",0)
                    }
                    
%> 
                <dt>&nbsp;</dt>
                <dd>&nbsp;</dd>  
                <dt>Manifiesto de salida: </dt>
                <dd class="textCopy"><%=rsMan.Fields.Item("Man_Folio").Value%></dd>  
                <dt>Manifiesto fecha</dt>
                <dd><%=rsMan.Fields.Item("FechaRegistro").Value%></dd>  
                <dt>Transportista:</dt>
                <dd class="textCopy"><%=Transportista%></dd>
                <dt>Gu&iacute;a:</dt>
                <dd class="textCopy"><%=Guia%></dd> 
                <dt>Ruta:</dt>
                <dd class="textCopy"><%=Ruta%></dd> 
                <dt>Tipo ruta:</dt>
                <dd class="textCopy"><%=rsMan.Fields.Item("TIPORUTA").Value %></dd>                 
                <dt>Estatus:</dt>              
<% if (rsMan.Fields.Item("Man_Borrador").Value == 1 ) { %>
                <dd>En Piso</dd>
<%    } else {  %>
                <dd>Man Cerrado</dd>                           
<%       if (rsMan.Fields.Item("Man_PeticionEnviada").Value == 1 ) { %>
                <dt>Confirmado:</dt>
                <dd><%=rsMan.Fields.Item("FechaConfirmado").Value%></dd>
 <%     } 
   }
            }
         rsMan.Close()   
                
        
        
    } else {
%>   
        <dt>&nbsp;</dt>
        <dd>&nbsp;</dd>
        <dt>Transportista:</dt>
        <dd class="textCopy"><%=Parametro("TA_Transportista","")%></dd>
        <dt>Gu&iacute;a:</dt>
        <dd class="textCopy"><%=Parametro("TA_Guia","")%></dd> 
        <!-- dt>Factura Cliente:</dt>
        <dd><% //Parametro("TA_FacturaCliente","")%></dd  -->  
<%                            
    }
	if(Cli_ID == 6){
%>
        <dt>&nbsp;</dt>
        <dd>&nbsp;</dd>
        <dt>Remisi&oacute;n:</dt>
        <dd class="textCopy"><%=TA_FolioRemision%></dd>
        <dt>Hoja de ruta/ Gu&iacute;a DHL:</dt>
        <dd class="textCopy"><%=TA_FolioRuta%></dd>
<%                            
	  if(TAF_FolioEntrada != ""){
%>                            
        <dt>Folio entrada:</dt>
        <dd class="textCopy"><%=TAF_FolioEntrada%></dd> 
        <dt>Fecha entrada:</dt>
        <dd class="textCopy"><%=FechaFolioEntrada%></dd> 
<%                            
      }
	  if(TAF_FolioCargo != ""){
%>                               
        <dt>Folio cargo:</dt>
        <dd class="textCopy"><%=TAF_FolioCargo%></dd>                        
        <dt>Fecha cargo:</dt>
        <dd class="textCopy"><%=FechaFolioCargo%></dd>                                                             
<%    }                         
    }
	
	if(Cli_ID == 2 && Parametro("TA_Recibido",0) == 1){
	
%>     
        <dt>&nbsp;</dt>
        <dd>&nbsp;</dd>
        <dt>Recibido:</dt>
        <dd class="textCopy">S&iacute;</dd>
        <dt>Usuario recibio:</dt>
        <dd class="textCopy"><%=BuscaSoloUnDato("Nombre","dbo.tuf_Usuario_Informacion("+Parametro("TA_RecibioUsuario",-1)+")","","",0) %></dd>
        <dt>Fecha recibido:</dt>
        <dd class="textCopy"><%=Parametro("FechaReciboRecibio","")%></dd>
<%                            
      }
%>                               
                                </dl>
                            </div>
                            <!--Datos del Proveedor-->
                            <div class="col-lg-7" id="cluster_info">
                             <dl class="dl-horizontal">
                             <dt>Direcci&oacute;n de entrega</dt>
                             </dl>   
                             <dl class="dl-horizontal">
                                    <dt>Calle:</dt>
                                    <dd><%=Parametro("Alm_Calle","")%></dd>
                                    <dt>Colonia:</dt>
                                    <dd><%=Parametro("Alm_Colonia","")%></dd>
                                    <dt>Delegaci&oacute;n/Municipio:</dt>
                                    <dd><%=Parametro("Delegacion","")%></dd>
                                    <dt>Ciudad:</dt>
                                    <dd><%=Parametro("Ciudad","")%></dd>
                                    <dt>Estado:</dt>
                                    <dd><%=Parametro("Estado","")%></dd>
                                    <dt>C&oacute;digo postal:</dt>
                                    <dd><%=Parametro("Alm_CP","")%></dd>
									<dt>Responsable:</dt>
                                    <dd><%=Parametro("Responsable","")%></dd>
									<dt>Tel&eacute;fono:</dt>
                                    <dd><%=Parametro("Alm_RespTelefono","")%></dd>
									<dt>Horario de atenci&oacute;n:</dt>
                                    <dd><%=Parametro("Alm_HorarioLV","")%></dd>
                                </dl>   
                            </div>
                        </div>
<%  //HA ID: 4 INI No es transportista
	if( !(bolEsTransportista) ){
		
		if( Cli_ID == 6  && EstatusCG51 != 11 ) { 
		
			if((EstatusCG51 > 5)  && (Parametro("TA_RemisionRecibida",0) == 0) ) {  
%>                                
                        <div class="row">
                            <div class="col-lg-12"> 
                                <div class="pull-right">
                                    <label> <input type="checkbox" class="i-checks" id="TA_RemisionRecibida"> 
                                        La nota de remisi&oacute;n firmada ya se carg&oacute; al sistema&nbsp;&nbsp;&nbsp;
                                    </label>
                                </div>
                            </div>       
                        </div> 
<%	
			}
			
		}
%>
                        <hr>                             
<%	//HA ID: 2 INI Se agregan botones de Impresión de Documentos
    //HA ID: 3 INI Se agregan botones de Liberacion de articulos de recepcion
%>
                        <div class="row">
                            <div class="col-lg-6"> 
								<%  
		if( Cli_ID == 6) {  
		
			if(TA_FolioRemision == -1){
%>
											  <input type="button" value="Intentar hoja de ruta" data-taid="<%=TA_ID%>"  class="btn btn-info btnSendHoja"/>
<%
			} else {
				
			    if( TA_FolioRuta != -1) {
%>                                
											  <input type="button" value="Reimprime Remision"  data-tipo="1" data-titulo="remision" data-folio="<%=Parametro("TA_Folio","")%>" class="btn btn-info btnRecuperaDoc"/>
											  <%
					if(Parametro("TA_TipoDeRutaCG94",-1) == 1){
%>
											  <input type="button" value="Reimprime Ruta" data-tipo="6" data-titulo="ruta" data-folio="<%=TA_FolioRuta%>" class="btn btn-success btnRecuperaDoc"/>
											  <%
					} else {
%>
											  <input type="button" value="Reimprime DHL" data-tipo="5" data-titulo="DHL" data-folio="<%=TA_FolioRuta%>" class="btn btn-success btnRecuperaDoc"/>
											  <%
					}
					
				} else {
%>
											  <input type="button" value="Reimprime Remision"  data-tipo="1" data-titulo="remision" data-folio="<%=Parametro("TA_Folio","")%>" class="btn btn-primary btnRecuperaDoc"/><br /><br />
											  <input type="button" value="Intentar hoja de ruta" data-taid="<%=TA_ID%>"  class="btn btn-info btnSendHoja"/>
<% 
				}
			}
			
			if(TAF_FolioEntrada != ""){
%>
											 <br /><br /><input type="button" value="Nota de entrada" data-titulo="entrada"  data-tipo="4" data-folio="<%=TAF_FolioEntrada%>" class="btn btn-success btnRecuperaDoc"/>
<%
			}										 
			
			if(TAF_FolioCargo != ""){
%>
											  <input type="button" value="Nota de cargo" data-titulo="cargo"  data-tipo="2" data-folio="<%=TAF_FolioCargo%>" class="btn btn-success btnRecuperaDoc"/>
<%
			}
		}
%>    
                            </div>
                            <div class="col-lg-6"> 
                                <div class="tooltip-demo pull-right">
<%  
		/* HA ID: 5 Se Agrega Condición de de Cancelación */
		if(EstatusCG51 < 5 && Parametro("Cli_ID",-1) != 6) {  
%>  
                                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#CancelaModal">
                                        <i class="fa fa-trash"></i> Cancelar
                                    </button>
<%  
        }
%>
                                    <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#mdlEve" onclick="Evento.Modal.Abrir()">
                                        <i class="fa fa-plus"></i> Evento
                                    </button>
                                    <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Orden();">
                                        <i class="fa fa-print"></i> Orden
                                    </button>
                                
                                    <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Albaran();">
                                        <i class="fa fa-print"></i> Albaran
                                    </button>
                                
                                <%  
                                   //DT: ROG 13/10/2020 - cuando vienen de tienda a CEDIS no se cambian a estatus de transferencia
                                   //                     estan llegando con estatus de pickeo o de empaque (izzi)
            
        
        //ROG: 19/08/2021                                      
		var Entregado = false                                            
            //Entregado es cuando la paqueteria entrega en el desrtino final la transferencia,  se modifica el EstatusCG51 
		var Recibido = false            
            //Recibido es cuando alguien de parte del cliente da el visto bueno de que recibio el embarque, se modifica TA_Recibido,TA_RecibioUsuario,TA_RecibidoFecha
        var TA_EsRecibido = Parametro("TA_EsRecibido",0)                                    
                                            
        //se requiere dos botones uno para cada evento
        //var TipoTransferencia = Parametro("TA_TipoTransferenciaCG65",2)      // 1) Ingreso al CEDIS,  2) Salida del CEDIS,  3) Sucursal a Sucursal


        if((EstatusCG51 >= 3) && (EstatusCG51 < 10) && (TA_EsRecibido == 0)){  //si no se ha entregado se habilita el boton de entregado                           
                    Recibido  = false
                    Entregado = true
        } else if( (EstatusCG51 == 10)  && (TA_EsRecibido == 0) ){   //si ya se entrego, devol, parcial etc se habilita el boton de recibido
                    Recibido  = true
                    Entregado = false
        }
 
			                                                                                                                            
		if(Recibido && !Entregado) {%>
                <a id="btnRecibido" class="btn btn-success" onclick="TA.Recibir();">
                    <i class="fa fa-download"></i> Recibido
                </a>                               
		<%}
		if(Entregado){%>
        		<br />
        		<br />
                <a id="btnEntregado"  class="btn bg-success" onclick="TA.Entregado();"><i class="fa fa-check"></i>&nbsp;Entregado</a>                               
		<%}%>
                               </div>
                        </div>
                    </div>

		<br />
                    
<%	
	} 
	
	
	//HA ID: 4 INI No es transportista
	if( !(bolEsTransportista) ){
%>
                        <div class="row">
                               
							<div class="row m-t-sm">
                                <div class="col-lg-12">
									<div class="panel blank-panel">
										<div class="panel-heading">
											<div class="panel-options">
												<ul class="nav nav-tabs">
													<li class="active"><a href="#tab-1" data-toggle="tab">Art&iacute;culos</a></li>
													<li class=""><a href="#tab-2" data-toggle="tab">Bit&aacute;cora</a></li>
													<li class=""><a href="#tab-3" data-toggle="tab">Hist&oacute;rico</a></li>
													<li class=""><a href="#tab-4" data-toggle="tab">Rastreo</a></li>
												</ul>
											</div>
										</div>

										<div class="panel-body">
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab-1">
													<div id="divArticulos"></div>
												</div>
												
												<div class="tab-pane" id="tab-2">
													
													<div id="divComentarios"></div> 
													
												</div>
												
												<div class="tab-pane" id="tab-3">
													
													<div id="divBitacora"></div>

												</div>
												
												<div class="tab-pane" id="tab-4">
													
													<div id="divRastreo"></div>
													
												</div>
												
											</div>
										</div>

									</div>
                                </div>
                            </div>
                        </div>  
<%
	} //HA ID: 4 FIN Existencia de Transportista
%>      
                    </div>
                </div>
            </div>
            <div class="col-sm-4" id="dvHistoria">
            	
                <div id="divHistLineTimeGrid"></div>
                <div id="loading">
                    <div class="spiner-example">
                        <div class="sk-spinner sk-spinner-three-bounce">
                            <div class="sk-bounce1"></div>
                            <div class="sk-bounce2"></div>
                            <div class="sk-bounce3"></div>
                        </div>
                    </div>
                </div>
                <div id="divSeries" style="margin-bottom: 100px;"></div>

            </div>
        </div>
    </div>
 
                                    
<div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="divModalComentario" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalComentario"><%= "Comentarios" %></h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalComentario" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <input type="hidden" id="comNodo" value="" />
            <div class="modal-body">
                <div class="form-group row">
                    <label for="comTitulo" class="col-sm-2 col-form-label">Titulo</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="comTitulo" placeholder="Titulo" maxlength="50">
                    </div>
                </div>
                <div class="form-group row">
					<label for="comComentario" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea id="comComentario" class="form-control" placeholder="Comentario" maxlength="150"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalComentario">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="Comentarios.Agregar();">
					<i class="fa fa-plus"></i> Agregar
				</button>
            </div>
		</div>
	</div>
</div>  
    
    
<div class="modal fade" id="modalIncidencia" tabindex="-1" role="dialog" aria-labelledby="divModalInicdencia" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="mdlIncTitulo">Seguimiento de incidencias</h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalIncidencia" aria-label="Close">
                  <span aria-hidden="true">&times;</span> Cerrar 
                </button>
            </div>
            <input type="hidden" id="Ins_ID" value="-1" />
            <input type="hidden" id="For_ID" value="-1" />   
            <div class="modal-body" id="mdlIncBody"></div>
            <div class="modal-body" id="mdlIncBodyComentarios"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalIncidencia">
                    <i class="fa fa-times"></i> <small>Cerrar</small>
				</button>
            </div>
		</div>
	</div>
</div>  


<div class="modal fade" id="CancelaModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Cancelaci&oacute;n</h4>
      </div>
      <div class="modal-body">
          <div class="form-group">
            <label class="control-label">Motivo de cancelaci&oacute;n</label>
            <textarea class="form-control" id="TA_MotivoCancelacion" placeholder="Escribe el motivo de la cancelaci&oacute;n"></textarea>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secundary" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-success btnCancela">OK</button>
      </div>
    </div>
  </div>
</div>   

<% /* HA ID: 6 INI Modificar el modal de Evento */ %>
<div class="modal fade" id="mdlEvento" tabindex="-1" role="dialog" aria-labelledby="divMdlEvento">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="divMdlEvento">Tipo de evento</h4>
            </div>
            <div class="modal-body">
                <div class="row form-group">
                    <label class="col-md-3 control-label">
                        Evento:
                    </label> 
                    <div class="col-md-6">
<% 
    /* HA ID: 6 Se agrega Opcion a visualización de Eventos */
    var strOpcSin = ( !(bolHaySiniestro) ) ? ",18,24" : "";
    /* HA ID: 8 Se agrega Opción a visualización de Eventos */
    var strOpcEnP = ( !(bolHayEntregaParcial) ) ? ",20" : ""
%>

<% CargaCombo("selMdlEveEnt_Est_ID","class='form-control' onclick='Evento.Modal.Combo.Seleccionar()'","Cat_ID","Cat_Nombre","Cat_Catalogo","Sec_ID = 51 AND Cat_ID in (22" + strOpcSin + "" + strOpcEnP + ")","Cat_Nombre","-1",0,"Seleccionar","")%>
                </div> 
            </div>

            <div class="row form-group cssMdlEveComentario">
                <label class="col-md-3 control-label">
                    Comentarios
                </label>
                <div class="col-sm-6">
                    <textarea id="txaMdlEveComentario" class="form-control" placeholder="Comentario" maxlength="255"></textarea>
                </div>
            </div>

        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-dismiss="modal">
                <i class="fa fa-times"></i> Cerrar
            </button>
            <button type="button" class="btn btn-success" onclick="Evento.Modal.Guardar();">
                <i class="fa fa-floppy-o"></i> Guardar
            </button>
        </div>
    
    </div>
  </div>
</div>
<% /* HA ID: 6 FIN */ %>

<div class="modal fade" id="ModalAutorizacion" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Autorizaci&oacute;n de supervisor</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-3"><strong>C&oacute;digo del supervisor</strong></label>
            <div class="col-md-6">
                <input type="password" class="form-control" id="Pass" value=""/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAutorizaSuper">Autorizar</button>
      </div>
    </div>
  </div>
</div>

    
<div class="modal fade" id="ModalManifiesto" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Manifiesto</h4>
      </div>
      <div class="modal-body"  id="mdlManifiestoBody">
          
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secundary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>    

<input type="hidden" id="titulo"/>
                            
<!-- iCheck -->
<script src="/Template/Inspina/js/plugins/PrintJs/print.min.js"></script>
<script src="/Template/Inspina/js/plugins/iCheck/icheck.min.js"></script>                                
<script type="text/javascript">

    var VerSeries = 0
	
	$('#loading').hide()
    
    $(document).ready(function() { 

        $('.btnAutoriza').click(function(e) {
            e.preventDefault();
            $('#Autoriza_TA').val($(this).data('taid'));
            $('#ModalAutorizacion').modal('show');
            $('#Pass').focus()
        });

        $('.btnAutorizaSuper').click(function(e) {
            e.preventDefault();
            var TA_ID = $('#Autoriza_TA').val();
            var request = {
                Tarea:10,
                TA_ID:TA_ID,
                Batman:$('#Pass').val(),
                IDUsuario:$('#IDUsuario').val()
            }
            TA.AutorizaImpresion(request)
        });

         $('.i-checks').iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green',
        });
        
        $('#TA_RemisionRecibida').on('ifChanged', function(event) {
            //alert('checked = ' + event.target.checked);
            //alert('value = ' + event.target.value);
            TA.ActualizaRemision();
//            $('input').iCheck('check'); — change input's state to checked
//            $('input').iCheck('uncheck'); — remove checked state
//            $('input').iCheck('toggle'); — toggle checked state
//            $('input').iCheck('disable'); — change input's state to disabled
//            $('input').iCheck('enable'); — remove disabled state
//            $('input').iCheck('indeterminate'); — change input's state to indeterminate
//            $('input').iCheck('determinate'); — remove indeterminate state
//            $('input').iCheck('update'); — apply input changes, which were done outside the plugin
//            $('input').iCheck('destroy'); — remove all traces of iCheck
        });

        if($("#Cli_ID").val() != <%=Cli_ID%>){
            $("#Cli_ID").val(<%=Cli_ID%>)
        }
        
        CargaProductos();
        CargaHistoricoLineTime();
        OrdenCompraRastreo();
        Comentarios.Cargar();
    });
	
    $(document).scroll(function(e) {

      if(VerSeries == 0) {    
          if ($(document).scrollTop() > 200) {
            $("#dvHistoria").addClass("Caja-Flotando");
          } else {
            $("#dvHistoria").removeClass("Caja-Flotando");
          }
      }
	  
	}); 
	
	$(".btnCancela").click(function(e) {
        e.preventDefault();
		TA.Cancela();
    });
    
    
    
	var urlBase="/pz/wms/Transferencia/";
	
	var TA = {
		Evento:function(){
			$.post("/pz/wms/TA/TA_Ajax.asp",{
                Tarea:19,
				TA_ID:$('#TA_ID').val(),
                TA_EstatusCG51:$('#TA_EstatusCG51').val(),
                IDUsuario:$('#IDUsuario').val()
			}, function(data){
				var response = JSON.parse(data);
				if(response.result == 1){
					Avisa("success","Aviso",response.message); 
					$('#mdlEve').modal('hide');
				}else{
					$('#TA_EstatusCG51').focus();
					Avisa("error","Error",response.message);
				}
			});
		},
		Cancela:function(){
			$.post("/pz/wms/TA/TA_Ajax.asp",{
				TA_ID:$("#TA_ID").val(),
				IDUsuario:$("#IDUsuario").val(),
				TA_MotivoCancelacion:$('#TA_MotivoCancelacion').val().trim(),
				Tarea:17
			}, function(data){
				var response = JSON.parse(data)
				if(response.result == 1){
					Avisa("success","Aviso","Transferencia cancelada");
					$("#CancelaModal").modal('hide'); 
				}else{
					Avisa("error","Error","Ocurrio un error");
				}
			});
		},Imprimir: {
			  Orden: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"SalidaAlmacenDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
			, Albaran: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"AlbaranDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
        }
        , Recibir: function(){

            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , dataType: "json"
                , data: {
                    Tarea: 13
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                        $("#btnRecibido").remove();
                        CargaHistoricoLineTime();
                    } else {
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        }
        , Entregado: function(){
			swal({
			  title: "Enviar a entrega exitosa",
			  text: "<strong>&iquest;Seguro que desea mover el pedido a entrega exitosa?</strong>",
			  type: "warning",
			  confirmButtonClass: "btn-success",
			  showCancelButton: true,
			  confirmButtonText: "Si!",
			  closeOnConfirm: true,
			  html: true
			},
			function(data){
				if(data){
					$.ajax({
						url: "/pz/wms/TA/TA_Ajax.asp"
						, method: "post"
						, dataType: "json"
						, data: {
							Tarea: 20
							, TA_ID: $("#TA_ID").val()
							, IDUsuario: $("#IDUsuario").val()
						}
						, success: function(res){
							if(res.result == 1){
								Avisa("success", "Transferencia", res.message);
								$("#btnEntregado").hide('slow',function(){
									RecargaEnSiMismo();
									});
							} else {
								Avisa("error", "Ups!", res.message);
							}
						}
					});
				}
			});		

        }
        , ActualizaRemision: function(){
            
            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , dataType: "json"
                , data: {
                    Tarea: 14
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                    } else {
                        // $("#TA_RemisionRecibida").iCheck('toggle');
                        //$("#TA_RemisionRecibida").parent().get( 0 ).removeClass("checked")
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        },
		AutorizaImpresion:function(request){
			$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
				var response = JSON.parse(data)
				if(response.result ==1){
					Avisa("success","Avisa","Impresi&oacute;n autorizada")	
					$('#ModalAutorizacion').modal('hide');
					$('#Pass').val("")
				}else{
					Avisa("error","Error",response.message)	
				}
			});
		}
        
	}
	
	function CargaProductos(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 
		$("#divArticulos").load("/pz/wms/TA/TA_FichaPicked.asp" + sDatos);
	}    
     
    function CargaHistoricoLineTime(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
            sDatos += "&Usu_ID="+$("#IDUsuario").val();
		$("#divHistLineTimeGrid").load("/pz/wms/TA/TA_Historico.asp" + sDatos);        
    }
    
    function OrdenCompraRastreo(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divRastreo").load("/pz/wms/TA/TA_Rastreo.asp" + sDatos);     
    }
    
    
var Manifiesto = {
	AbrirModal: function( Manid, ManDid ){   
        Manifiesto.CargaBody(Manid, ManDid);
         
		$('#ModalManifiesto').modal('show');
    }
	, CargaBody: function(Manid, ManDid){
        var sDatos = "?Man_ID=" + Manid
            sDatos += "&ManD_ID=" + ManDid;
            sDatos += "&TA_ID=" + $("#TA_ID").val();
 
		$("#mdlManifiestoBody").load("/pz/wms/TA/TA_Manifiestos.asp" + sDatos)
    } 
    , CerrarModal: function(){
		$("#ModalManifiesto").modal("hide");
	}
}
 
var Tra_Incidencia = {
	AbrirModal: function( Insid, forid ){   
		Tra_Incidencia.LimpiarModal();
        $("#Ins_ID").val(Insid);
		$("#For_ID").val(forid);
        Tra_Incidencia.CargaBody(Insid, forid);
         
		$('#modalIncidencia').modal('show');
		//$("#comNodo").val(Insid);
	}    
	, LimpiarModal: function(){
		$("#Ins_ID").val(-1);
		$("#For_ID").val(-1); 
	}
	, CerrarModal: function(){
		Tra_Incidencia.LimpiarModal();
		$("#modalIncidencia").modal("hide");
	}
	, CargaBody: function(Insid, forid){
        var sDatos = "?Ins_ID=" + Insid
            sDatos += "&SegGrupo=" + $("#SegGrupo").val();
            sDatos += "&Usu_ID=" + $("#IDUsuario").val();
        //&Reporta=35&Recibe=35&Lpp=1
		$("#mdlIncBody").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + sDatos)
        
        //datos demo cambiar por los buenos
        //sDatos += "&Reporta=35&Recibe=35&InsO_ID=1&Permiso=4"
        $("#mdlIncBodyComentarios").load("pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp" + sDatos)
        //http://wms.lyde.com.mx/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID=7&Reporta=35&Recibe=35&InsO_ID=1&Permiso=4
    }
    
}
 

var Comentarios = {
	Cargar: function(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divComentarios").load("/pz/wms/TA/TA_Comentario.asp" + sDatos); 
	}
	, VisualizarModal: function( prmIntComnId ){
		Comentarios.LimpiarModal();
        $('#ComentarioBody').empty()
        $('#ModalAutorizacion').modal('show');
        
         
		
		$("#comNodo").val(prmIntComnId);
	}

	, Agregar: function(){
		
		var intIdUsuario = $("#IDUsuario").val();
		var TA_ID = $("#TA_ID").val();
		var intComn_ID = $("#comNodo").val();
		var strTitulo = $("#comTitulo").val();
		var strComentario = $("#comComentario").val();
		
		var arrRes = [];
		var bolError = false;
		
		if( strTitulo == '' ){
			arrRes.push("Agregar el Titulo");
			bolError = true;
		}

		if( strComentario == '' ){
			arrRes.push("Agregar el Comentario");
			bolError = true;
		}
		
		if( bolError ){
			
			Avisa("warning", "Comentario", "Validar Formulario: <br>" + arrRes.join("<br>") );
			
		} else {
		
			$.ajax({
				  url: "/pz/wms/TA/TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType: "json"
				, data: {
					  Tarea: 15
					, IdUsuario: intIdUsuario
					, TA_ID: $("#TA_ID").val()
					, Comn_ID: intComn_ID
					, Titulo: strTitulo
					, Comentario: strComentario
				}
				, success: function(res){
					if( parseInt(res.Error) == 0 ){
						
						Avisa("success", "Comentario", "Se agreg&oacute; el comentario a la Transferencia");
						Comentarios.Cargar();
					} else {
						Avisa("warning", "Comentario", "NO se agreg&oacute; el comentario a la transferencia");
					}
                    Comentarios.CerrarModal();
				}
			})
		}
	}
	, LimpiarModal: function(){
		$("#comNodo").val("");
		$("#comTitulo").val("");
		$("#comComentario").val("");
	}
	, CerrarModal: function(){
		Comentarios.LimpiarModal();
		
		var bolSeAbrePorModal = parseInt($("#SeAbrePorModal").val());
 
		//if( bolSeAbrePorModal == 0 ){
			$("#modalComentario").modal("hide");
		//} else {
//			
//			$.post("/pz/wms/OV/OV_Ficha.asp"
//				, {TA_ID:$("#TA_ID").val()}
//				, function(data){
//					$("#modalBodySO").html(data);
//					$("#SeAbrePorModal").val(1);
//				}
//			);
//			
//		}
	}
}

$('.btnSendHoja').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
	TransferenciasFunciones.ReintenataHoja(TA_ID)
});

$('.btnRecuperaDoc').click(function(e) {
    e.preventDefault();
	var Folio = $(this).data('folio')
	var Tipo = $(this).data('tipo')
	var titulo = $(this).data('titulo')
	$('#titulo').val(titulo)
	TransferenciasFunciones.RecuperaHoja(Tipo,Folio)
});

var TransferenciasFunciones = {
	ImprimeGuia:function(guia,name) {
		printJS({
			printable: guia,
			type: 'pdf',
			documentTitle:"Example",
			base64: true
		})	
//		var winparams = 'dependent=yes,locationbar=no,scrollbars=yes,menubar=yes,'+
//		'resizable,screenX=50,screenY=50,width=850,height=1050';
//
//		var htmlPop = '<html><head>'
//						+'</head><body>'
//						+'<title>'+name+'</title>'
//						+'<embed width=100% height=100%'
//						+ ' type="application/pdf"'
//						+ ' src="data:application/pdf;base64,'
//						+ guia
//						+ '"></embed>'
//						+ "</body></html>"; 
//						
//		var printWindow = window.open ("", "_blank", winparams);
//		printWindow.document.write (htmlPop);
		//printWindow.print();
	},
	ReintenataHoja:function(TA_ID){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/recupera/hoja/ruta?TA_ID="+TA_ID,
			success: function(data){
				console.log(data) 
				if(data.data.result != -1){
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.data.data.folios != null){
						TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
					}
				}else{
					swal({
					  title: data.data.message,
					  text: "Elektra no gener&oacute; correctamente el documento",
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		
				}
			}
		});
	},
	RecuperaHoja:function(Tipo,Folio){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/ReimprimeSG?Folio="+Folio+"&Tipo="+Tipo,
			success: function(data){
				console.log(data) 
				if(data.data.result != -1){
					if(data.result == 1){
						if(data.data.pdf != null){
							Avisa("success","Aviso",$('#titulo').val()+" recibida");
							TransferenciasFunciones.ImprimeGuia(data.data.pdf,"Documento "+data.data.folioDocumento)
						}else{
							TransferenciasFunciones.Alerta("Error en documento","Elektra no gener&oacute; correctamente el documento","error")
						}
					}
				}else{
					TransferenciasFunciones.Alerta(data.message,"Elektra no gener&oacute; correctamente el documento","error")
				}
			}
		});
	},
	Alerta:function(titulo,descrip,tipo){
		swal({
		  title: titulo,
		  text: descrip,
		  type: tipo,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		});		
	}
}


    
</script>    
