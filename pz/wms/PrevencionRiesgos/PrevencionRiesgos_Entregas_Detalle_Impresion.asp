<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-29 Prevencion de Riesgos - Entregas - Detalle: Creación de Archivo

var cxnTipo = 0;

var rqIntTA_ID = Parametro("TA_ID", "-1");
var rqIntOV_ID = Parametro("OV_ID", "-1");

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
var strEnt_Destino_Direccion = "";
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
    dateEnt_FechaRegistroCorta = dateEnt_FechaRegistro.substring(0,10);

    strEnt_Origen_Numero = rsPreRieEntDet("Ent_Origen_Numero").Value;
    strEnt_Origen_Nombre = rsPreRieEntDet("Ent_Origen_Nombre").Value;

    strEnt_Destino_Numero = rsPreRieEntDet("Ent_Destino_Numero").Value;
    strEnt_Destino_Nombre = rsPreRieEntDet("Ent_Destino_Nombre").Value;

    strEnt_Destino_Direccion = rsPreRieEntDet("Ent_Destino_Direccion").Value;
    
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

var strTpo_Documento = ""

if( rqIntTA_ID > -1 ){
    strTpo_Documento = "Transferencia"
}

if( rqIntOV_ID > -1 ){
    strTpo_Documento = "Orden Venta"
}
%>

<head>
    <title>Documento de Entrega</title>

    <style media="print">
        @page {
            size: auto;   /* auto is the initial value */
        }

        .page-break  { 
            display:block; page-break-before:always; 
        }

        .marca-de-agua {
            background-image: url("/Img/wms/Logo002.png");
            background-repeat: no-repeat;
            background-position: center;
            width: 100%;
            height: auto;
            margin: auto;
        }
        .marca-de-agua img {
            padding: 0;
            width: 100%;
            height: auto;
            opacity: 0.7;
        }
        
    </style>

    <style>
        table{
            width: 100% !important;
        }
        .text-right{
            text-align: right;
        }
        .text-left{
            text-align: left;
        }
        .text-center{
            text-align: center;
        }
    </style>

    <script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
    <script src="/Template/inspina/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        $(document).ready(function() {
            window.print();    
        });
       
    </script>
    
</head>
<body class="marca-de-agua text-center">

    <table>
        <tbody>
            <tr>
                <td style="width: 100px;" rowspan="2">
                    <img src="/Img/wms/Logo002.png" width="100" height="130" alt=""/>
                </td>
                <td class="text-center">
                    <h2>Log&iacute;stica y Distribuci&oacute;n Empresarial, S.A. de C.V.</h2>
                </td>
                <td class="text-center" rowspan>
                    <b><%= strEnt_Folio %></b>
                    <br>
                    <small><%= strEnt_FolioCliente %></small>
                </td>
            </tr>
            <tr>
                <td class="text-center">
                    <h3><%= strTpo_Documento %></h3>
                </td>
                <td class="text-center" rowspan>
                    <b><%= dateEnt_FechaRegistroCorta %></b>
                    <br>
                    <small>Fecha Registro</small>
                </td>
            </tr>
        </tbody>
    </table>
    <hr>
    <table>
        <tbody>
            <tr>
                <th class="text-left">
                    Origen
                </th>
                <td>
                    <%= strEnt_Origen_Numero %> - <%= strEnt_Origen_Nombre %>
                </td>
            <tr>
            <tr>
                <th class="text-left">
                    Destino
                </th>
                <td>
                    <%= strEnt_Destino_Numero %> - <%= strEnt_Destino_Nombre %>
                </td>
            </tr>
                <tr>
                <th class="text-left">
                    Direcci&oacute;n
                </th>
                <td>
                    <%= strEnt_Destino_Direccion %>
                </td>
            </tr>
            <tr>
                <th class="text-left">
                    Responsable
                </th>
                <td>
                    <%= strEnt_Destino_Responsable %>
                </td>
            </tr>
            <tr>
                <th class="text-left">
                    Tel&eacute;fono
                </th>
                <td>
                    <%= strEnt_Destino_Telefono %>
                </td>
            </tr>
        </tbody>
    </table>
    <hr>
<%
    var strPreRieEntLis = "SPR_PrevencionRiesgos "
          + "@Opcion = 1200 "
        + ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "  
        + ", @OV_ID = " + ( (rqIntOV_ID > -1) ? rqIntOV_ID : "NULL" ) + " " 

    var rsPreRieEntLis = AbreTabla(strPreRieEntLis, 1, cxnTipo)
%>
    <table border="1" cellpadding="5" cellspacing="0">
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
</body>