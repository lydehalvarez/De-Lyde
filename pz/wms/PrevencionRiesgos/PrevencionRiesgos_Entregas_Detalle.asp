<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-29 Prevencion de Riesgos - Entregas - Detalle: Creación de Archivo

var cxnTipo = 0;

var rqIntTA_ID = Parametro("TA_ID", -1);
var rqIntOV_ID = Parametro("OV_ID", -1);

var Entrega = {
        Estatus: {
            Transito: 5
            , PrimerIntento: 6
            , SegundoIntento: 7
            , TercerIntento: 8
            , FallaEntrega: 9
            , EntregaExitosa: 10
            , AvisoDevolucion: 22
        }
    }

var intCli_ID = "";
var strEnt_Folio = "";
var strEnt_FolioCliente = "";

var intEnt_Est_ID = "";
var strEnt_Est_Nombre = "";

var strEnt_Tpo_Nombre = "";

var dateEnt_FechaEntrega = "";
var dateEnt_FechaElaboracion = "";
var dateEnt_FechaRegistro = "";

var strEnt_Origen_Numero = "";
var strEnt_Origen_Nombre = "";

var strEnt_Destino_Numero = "";
var strEnt_Destino_Nombre = "";
var strEnt_Destino_Calle = "";
var strEnt_Destino_Colonia = "";
var strEnt_Destino_Delegacion = "";
var strEnt_Destino_Cidudad = "";
var strEnt_Destino_Estado = "";
var strEnt_Destino_CP = "";
var strEnt_Destino_Responsable = "";
var strEnt_Destino_Telefono = "";
var strEnt_Destino_Horario = "";

var strEnt_Guia = "";
var strEnt_Ruta = "";
var strEnt_Tpo_Ruta = "";

var strProv_Nombre = "";
var dateMan_FechaConfirmado = "";
var strMan_Folio = "";
var strMan_FechaRegistro = "";

var strEnt_Remision = "";
var strEnt_FolioRuta = "";

if( rqIntTA_ID > -1 || rqIntOV_ID > -1 ){

    var sqlPreRieEntDet = "EXEC SPR_PrevencionRiesgos "
        + "@Opcion = 1100 "
        + ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "  
        + ", @OV_ID = " + ( (rqIntOV_ID > -1) ? rqIntOV_ID : "NULL" ) + " " 
        
    var rsPreRieEntDet = AbreTabla(sqlPreRieEntDet, 1, cxnTipo)

    if( !(rsPreRieEntDet.EOF) ){

        intCli_ID = rsPreRieEntDet("Cli_ID").Value;

        strEnt_Folio = rsPreRieEntDet("Ent_Folio").Value;
        strEnt_FolioCliente = rsPreRieEntDet("Ent_FolioCliente").Value;
        
        intEnt_Est_ID = rsPreRieEntDet("Ent_Est_ID").Value;
        strEnt_Est_Nombre = rsPreRieEntDet("Ent_Est_Nombre").Value;

        strEnt_Tpo_Nombre = rsPreRieEntDet("Ent_Tpo_Nombre").Value;

        dateEnt_FechaEntrega = rsPreRieEntDet("Ent_FechaEntrega").Value;
        dateEnt_FechaElaboracion = rsPreRieEntDet("Ent_FechaElaboracion").Value;
        dateEnt_FechaRegistro = rsPreRieEntDet("Ent_FechaRegistro").Value;

        strEnt_Origen_Numero = rsPreRieEntDet("Ent_Origen_Numero").Value;
        strEnt_Origen_Nombre = rsPreRieEntDet("Ent_Origen_Nombre").Value;

        strEnt_Destino_Numero = rsPreRieEntDet("Ent_Destino_Numero").Value;
        strEnt_Destino_Nombre = rsPreRieEntDet("Ent_Destino_Nombre").Value;

        strEnt_Destino_Calle = rsPreRieEntDet("Ent_Destino_Calle").Value;
        strEnt_Destino_Colonia = rsPreRieEntDet("Ent_Destino_Colonia").Value;
        strEnt_Destino_Delegacion = rsPreRieEntDet("Ent_Destino_Delegacion").Value;
        strEnt_Destino_Cidudad = rsPreRieEntDet("Ent_Destino_Ciudad").Value;
        strEnt_Destino_Estado = rsPreRieEntDet("Ent_Destino_Estado").Value;
        strEnt_Destino_CP = rsPreRieEntDet("Ent_Destino_CP").Value;

        strEnt_Destino_Responsable = rsPreRieEntDet("Ent_Destino_Responsable").Value;
        strEnt_Destino_Telefono = rsPreRieEntDet("Ent_Destino_Telefono").Value;
        strEnt_Destino_Horario = rsPreRieEntDet("Ent_Destino_Horario").Value;

        strProv_Nombre = rsPreRieEntDet("Prov_Nombre").Value;
        strEnt_Guia = rsPreRieEntDet("Ent_Guia").Value;
        strEnt_Ruta = rsPreRieEntDet("Ent_Ruta").Value;
        strEnt_Tpo_Ruta = rsPreRieEntDet("Ent_Tpo_Ruta").Value;
        dateMan_FechaConfirmado = rsPreRieEntDet("Man_FechaConfirmado").Value;
        strMan_Folio = rsPreRieEntDet("Man_Folio").Value;
        strMan_FechaRegistro = rsPreRieEntDet("Man_FechaRegistro").Value;

        //strEnt_Remision = rsPreRieEntDet("Ent_Remision").Value;
        //strEnt_FolioRuta = rsPreRieEntDet("Ent_FolioRuta").Value;
    }

    rsPreRieEntDet.Close()

}

var strlabel = "";

switch( parseInt(intEnt_Est_ID) ){
    case Entrega.Estatus.Transito: { 
        strlabel = "info" 
    } break;
    case Entrega.Estatus.PrimerIntento: 
    case Entrega.Estatus.SegundoIntento: 
    case Entrega.Estatus.TercerIntento: { 
        strlabel = "warning" 
    } break; 
    case Entrega.Estatus.EntregaExitosa: { 
        strlabel = "success" 
    } break;
    case Entrega.Estatus.FallaEntrega: 
    case Entrega.Estatus.AvisoDevolucion: { 
        strlabel = "danger" 
    } break;
}

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

    <script type="text/javascript">
<%
if( rqIntTA_ID > -1){
%>
        $(document).ready(function(){
            CargaHistoricoLineTime();

            if ($(document).scrollTop() > 200) {
                $("#dvHistoria").addClass("Caja-Flotando");
            } else {
                $("#dvHistoria").removeClass("Caja-Flotando");
            }
        });

        function CargaHistoricoLineTime(){
            var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
                sDatos += "&Usu_ID="+$("#IDUsuario").val();
            $("#divHistLineTimeGrid").load("/pz/wms/TA/TA_Historico.asp" + sDatos);        
        }
        
<%
}
%>
        var Entrega = {
            url: "/pz/wms/PrevencionRiesgos/"
            , Impresion: {
                Cargar: function( prmJson ){

                    var intTA_ID = (prmJson.TA_ID != undefined) ? prmJson.TA_ID : -1;
                    var intOV_ID = (prmJson.OV_ID != undefined) ? prmJson.OV_ID : -1;

                    var strPrm = "";
                    if( intTA_ID > -1 ){
                        strPrm += "TA_ID=" + intTA_ID;
                    }

                    if( intOV_ID > -1){
                        strPrm = "OV_ID=" + intOV_ID;
                    }
                    var urlImp = Entrega.url + "PrevencionRiesgos_Entregas_Detalle_Impresion.asp?" + strPrm

                    window.open(urlImp);
                }
            }
        }
        
    </script>

    <div id="wrapper">
        <div class="row">
            <div class="col-sm-8">

                <input type="hidden" id="TA_ID" name="TA_ID" value="<%= rqIntTA_ID %>">
                <input type="hidden" id="OV_ID" name="OV_ID" value="<%= rqIntOV_ID %>">

                <div class="ibox">
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                    <h2 class="pull-right copyID">
                                        <span class="textCopy"><%= strEnt_Folio %></span>
                                        <p>
                                        <small class="textCopy"><%= strEnt_FolioCliente %></small>
                                        </p>
                                    </h2>
                                    <h2>
                                        <span class="textCopy"><%= strEnt_Destino_Numero %></span> - <span class="textCopy"><%= strEnt_Destino_Nombre %></span>
                                    </h2>
                                </div>
                            </div>
                            
                            <div class="col-lg-9">
                                <strong>Origen:&nbsp;&nbsp;</strong> <%= strEnt_Origen_Numero %> - <%= strEnt_Origen_Nombre %> 
                                <br>
                                <strong>Destino:</strong> <%= strEnt_Destino_Numero %> - <%= strEnt_Destino_Nombre %> 
                            </div>                            
                            
                            <div class="col-lg-3">
                                <div class="pull-right" style="line-height: 22px;"> Estatus: 
                                    <span class="label label-<%= strlabel %> textCopy"><%= strEnt_Est_Nombre %></span>        
                                    <br> Tipo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <span class="label label-primary textCopy"><%= strEnt_Tpo_Nombre %></span> 
                                </div>
                            </div>                            
                        </div>
                        <hr> 

                        <div class="row">
                            <div class="col-lg-5">
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Fecha entrega:</dt>
                                        <dd><%= dateEnt_FechaEntrega %></dd>
                                    <dt>Fecha de elaboraci&oacute;n:</dt>
                                        <dd><%= dateEnt_FechaElaboracion %></dd>
                                    <dt>Fecha de registro:</dt>
                                        <dd><%= dateEnt_FechaRegistro %></dd>
                                    <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd>  
                                    <dt>Manifiesto de salida: </dt>
                                        <dd class="textCopy"><%= strMan_Folio %></dd>  
                                    <dt>Manifiesto fecha</dt>
                                        <dd><%= strMan_FechaRegistro %></dd>  
                                    <dt>Transportista:</dt>
                                        <dd class="textCopy"><%= strProv_Nombre %></dd>
                                    <dt>Gu&iacute;a:</dt>
                                        <dd class="textCopy"><%= strEnt_Guia %></dd> 
                                    <dt>Ruta:</dt>
                                        <dd class="textCopy"><%= strEnt_Ruta %></dd> 
                                    <dt>Tipo ruta:</dt>
                                        <dd class="textCopy"><%= strEnt_Tpo_Ruta %></dd>                 
                                    <dt>Estatus:</dt>
                                        <dd>Man Cerrado</dd>                           
                                    <dt>Confirmado:</dt>
                                        <dd><%= dateMan_FechaConfirmado %></dd>
                                    <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd> 
<%                            
    if(intCli_ID == 6 && 1 != 1){
%>
                                    <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd>
                                    <dt>Remisi&oacute;n:</dt>
                                        <dd class="textCopy"><%= strEnt_Remision %></dd>
                                    <dt>Hoja de ruta/ Gu&iacute;a DHL:</dt>
                                        <dd class="textCopy"><%= strEnt_FolioRuta %></dd>
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
                                        <dd><%= strEnt_Destino_Calle %></dd>
                                    <dt>Colonia:</dt>
                                        <dd><%= strEnt_Destino_Colonia %></dd>
                                    <dt>Delegaci&oacute;n/Municipio:</dt>
                                        <dd><%= strEnt_Destino_Delegacion %></dd>
                                    <dt>Ciudad:</dt>
                                        <dd><%= strEnt_Destino_Cidudad %></dd>
                                    <dt>Estado:</dt>
                                        <dd><%= strEnt_Destino_Estado %></dd>
                                    <dt>C&oacute;digo postal:</dt>
                                        <dd><%= strEnt_Destino_CP %></dd>
									<dt>Responsable:</dt>
                                        <dd><%= strEnt_Destino_Responsable %></dd>
									<dt>Tel&eacute;fono:</dt>
                                        <dd><%= strEnt_Destino_Telefono %></dd>
									<dt>Horario de atenci&oacute;n:</dt>
                                        <dd><%= strEnt_Destino_Horario %></dd>
                                </dl>   
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Productos -->
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Productos</h5>
                        <div class="ibox-tools">
                            <button type="button" class="btn btn-white" onclick="Entrega.Impresion.Cargar({TA_ID: <%= rqIntTA_ID %>, OV_ID: <%= rqIntOV_ID %>})">
                                <i class="fa fa-print"></i> Imprimir
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
<%
    var strPreRieEntLis = "SPR_PrevencionRiesgos "
          + "@Opcion = 1200 "
        + ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "  
        + ", @OV_ID = " + ( (rqIntOV_ID > -1) ? rqIntOV_ID : "NULL" ) + " " 

    var rsPreRieEntLis = AbreTabla(strPreRieEntLis, 1, cxnTipo)
%>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>SKU</th>
                                    <th>Nombre</th>
                                    <th>Cantidad</th>
                                    <th>Precio</th>
                                </tr>
                            </thead>
                            <tbody>
<%
    var dblTotal = 0.0;

    while( !(rsPreRieEntLis.EOF) ){
        dblTotal += rsPreRieEntLis("EntPro_Pro_Precio").Value
%>
                                <tr>
                                    <td class="text-center"><%= rsPreRieEntLis("EntPro_ID").Value %></td>
                                    <td><%= rsPreRieEntLis("EntPro_Pro_SKU").Value %></td>
                                    <td><%= rsPreRieEntLis("EntPro_Pro_Nombre").Value %></td>
                                    <td class="text-center"><%= rsPreRieEntLis("Ent_Pro_CantidadEnviada").Value %></td>
                                    <td class="text-right"><%= formato_numero(rsPreRieEntLis("EntPro_Pro_Precio").Value, 2) %></td>
                                </tr>
<%
        rsPreRieEntLis.MoveNext()
    }
%>
                            </tbody>
                            <tfoot>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th class="text-right">
                                    Total
                                </th>
                                <th class="text-right">
                                    <%= formato_numero(dblTotal, 2) %>
                                </th>
                            </tfoot>
                        </table>
<%
    rsPreRieEntLis.Close();
%>
                    </div>
                </div>

            </div>

            <div class="col-sm-4" id="dvHistoria"> 

                <div id="divHistLineTimeGrid"></div>

            </div>

        </div>
    </div>
    