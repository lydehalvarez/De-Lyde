<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var cxnTipo = 0

    var rqIntPT_ID = Parametro("PT_ID", -1)
    var rqIntTPT_ID = Parametro("TPT_ID", 1)	
    
    var strCliente = ""
    var dateFecha = ""
    var strSKU = ""
    var strASN = ""
    var strCita = ""
    var strProducto = ""
    var strCantidad = ""
    var strLPN = ""
    var strUbicacion = ""
    var strLote = ""
    var strFolio = ""
    var strResponsable = ""

    var urlBaseTemplate = "/Template/inspina/"
    
    var sqlLpn = "SELECT Cli.Cli_Nombre AS Cliente "
            + ", CONVERT(DATE, GETDATE()) AS Fecha "
            + ", Pro.Pro_SKU AS SKU "
            + ", ISNULL((select ASN_FolioCliente "
                     +   " from asn a, Pallet p "
                     +  " where a.ASN_ID = p.Asn_ID and p.Pt_ID = PT.Pt_ID),'-') AS ASN "
            + ", ISNULL((select IR_Folio "
                     +   " from Inventario_Recepcion ir, Pallet p "
                     +  " where ir.IR_ID = p.IR_ID  and p.Pt_ID = PT.Pt_ID),'-') AS Cita "   
            + ", Pro.Pro_Nombre AS Producto "
            + ", (Select count (*) FROM Inventario i WHERE i.Pt_ID = PT.Pt_ID) AS Cantidad "
            + ", PT.PT_LPN AS LPN "
            + ", Ubi.Ubi_Nombre AS Ubicacion "
            + ", ISNULL(Lot.Lot_Folio, '-') AS Lote "
            + ", '-' AS Folio "
            + ", ISNULL(dbo.fn_Usuario_DameNombreUsuario(PT.Pt_Usuario),'-') AS Responsable "
        + " FROM Pallet PT "
            + " LEFT JOIN Cliente Cli "
                + " ON PT.Cli_ID = Cli.Cli_ID "
            + " LEFT JOIN Producto Pro "
                + " ON PT.Pro_ID = Pro.Pro_ID "
            + " LEFT JOIN Ubicacion Ubi "
                + " ON PT.Ubi_ID = Ubi.UBi_ID "
            + " LEFT JOIN Inventario_Lote Lot " 
                + " ON PT.Lot_ID = Lot.Lot_ID "
        + " WHERE PT.PT_ID = " + rqIntPT_ID
   
   
    var rsLPN = AbreTabla(sqlLpn, 1, cxnTipo)

    if( !(rsLPN.EOF) ){
        strCliente = rsLPN("Cliente").Value
        dateFecha = rsLPN("Fecha").Value
        strSKU = rsLPN("SKU").Value
        strASN = rsLPN("ASN").Value
        strCita = rsLPN("Cita").Value
        strProducto = rsLPN("Producto").Value
        strCantidad = rsLPN("Cantidad").Value
        strLPN = rsLPN("LPN").Value
        strUbicacion = rsLPN("Ubicacion").Value
        strLote = rsLPN("Lote").Value
        strFolio = rsLPN("Folio").Value
        strResponsable = rsLPN("Responsable").Value
    }

    rsLPN.Close()
%>



<link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">

<script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/JsBarcode/JsBarcode.all.min.js" charset="utf-8" ></script>

<script type="application/javascript">
    $(document).ready(function(e) {

        JsBarcode("#barcode", "<%= strLPN %>", {
            width: 3,
            align:"center",
            height: 100,
            fontSize: 1,
            displayValue: false,
            font:"fantasy"
        });
        JsBarcode("#cbUbicacion", "<%= strUbicacion %>", {
            width: 3,
            height: 80,
            fontSize: 1,
            displayValue: false,
            font:"fantasy"
        });

        window.print();    
    });
</script>

<style media="print">
    @page {  size: auto;   /* auto is the initial value */ }
    .page-break  { display:block; page-break-before:always; }
    table, tr, td, h1, h2, h3, h4{ font-weight: bold !important; }
</style>

<center>
    <table border="1" cellpadding="1" cellspacing="1" style="text-align:center; width: 1000px;" class>
        <tr>
            <td rowspan="2" colspan="2" style="width: 20%;">
                <img src="http://wms.lyde.com.mx/Img/wms/Logo005.png" title="Lyde" style="width: 100px; height: 100px;"/>
            </td>
            <td bgcolor="silver" colspan="6" style="width: 60%;">
                <strong>Cliente</strong>
            </td>
            <td bgcolor="silver" colspan="2" style="width: 20%;">
                <strong>Fecha</strong>
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <h1><strong><%= strCliente %></strong></h1>
            </td>
            <td colspan="2">
               <h3><strong><%= dateFecha %></strong></h3>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="4" style="width: 40%;">
                <strong>SKU</strong>
            </td>
            <td bgcolor="silver" colspan="3" style="width: 30%;">
                <strong>ASN</strong>
            </td>
            <td bgcolor="silver" colspan="3" style="width: 30%;">
                <strong>CITA</strong>
            </td>
        </tr>
        <tr>
            <td  colspan="4">
                <h1><strong><%= strSKU %></strong></h1>
            </td>
            <td  colspan="3">
                <h2><strong><%= strASN %></strong></h2>
            </td>
            <td  colspan="3">
                <h2><strong><%= strCita %></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="10" style="width: 100%;">
                <strong>Modelo</strong>
            </td>
        </tr>
        <tr>
            <td  colspan="10">
                <h2><strong><%= strProducto %></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="2" style="width: 20%;">
               <strong>Cantidad</strong>
            </td>
            <td bgcolor="silver"  colspan="8" style="width: 80%;">
                <strong>LPN</strong>
            </td>
        </tr>
        <tr>
            <td rowspan="2" colspan="2">
            <h1><strong><%= strCantidad %></strong></h1>
            </td>
            <td  colspan="8">
                <strong><svg id="barcode">

                </svg></strong>
            </td>
        </tr>
        <tr>
            <td  colspan="8">
                <h2><strong><%= strLPN %></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver"  colspan="10" style="width: 100%;">
                <strong>Ubicacion</strong>
            </td>
        </tr>
        <tr>
            <td  colspan="10">
                <strong><svg id="cbUbicacion">

                </svg></strong>
            </td>
        </tr>
        <tr>
            <td  colspan="10">
                <h2><strong><%= strUbicacion %></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="3" style="width: 30%;">
                <strong>Lote</strong>
            </td>
            <td bgcolor="silver"  colspan="3" style="width: 30%;">
                <strong>Folio Documento</strong>
            </td>
            <td bgcolor="silver"  colspan="4" style="width: 40%;">
               <strong>Ingresado por:</strong>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <h3><strong><%= strLote %></strong></h3>
            </td>
            <td colspan="3">
                <h3><strong><%= strFolio %></strong></h3>
            </td>
            <td colspan="4">
                <h3><strong><%= strResponsable %></strong></h3>
            </td>
        </tr>
    </table>
</center>
