<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var cxnTipo = 0
    var Aud_ID = Parametro("Aud_ID", -1)
    var PT_ID = Parametro("PT_ID", -1)
    var TPT_ID = Parametro("TPT_ID", 1)	
    
    var intAudU_Veces = 0
    var intAudU_CodigoBarras = 0
    var strPro_SKU = ""
    var strPro_Nombre = ""
    var strPT_LPN = ""
    var strUbi_Nombre = ""
    var strCli_Nombre = ""
    var intAudU_ConteoInterno = ""
    var dateFecha = ""

    var strUsu_Nombre = ""
    var strTPA_Nombre = ""

    var urlBaseTemplate = "/Template/inspina/"
    
    var sqlLpn = "SELECT Pro.Pro_SKU, Pro.Pro_Nombre, PT.PT_LPN, Ubi.Ubi_Nombre, Cli.Cli_Nombre"
						+ ", CONVERT(VARCHAR, GETDATE(), 103) AS Fecha"
						+ " FROM  Pallet PT"
						+ " LEFT JOIN Producto Pro"
						+ " ON PT.Pro_ID = Pro.Pro_ID"
						+ " LEFT JOIN Ubicacion Ubi"
						+ " ON PT.Ubi_ID = Ubi.Ubi_ID"
						+ " LEFT JOIN Cliente Cli"
						+ " ON PT.Cli_ID = Cli.Cli_ID"
						+ " WHERE  PT.PT_ID = " + PT_ID

    var rsAudPap = AbreTabla(sqlLpn, 1,0)

    var i = 0

    if( !(rsAudPap.EOF) ){

        strPro_SKU = rsAudPap("Pro_SKU").Value
        strPro_Nombre = rsAudPap("Pro_Nombre").Value
        strPT_LPN = rsAudPap("PT_LPN").Value
        strUbi_Nombre = rsAudPap("Ubi_Nombre").Value
        
        strCli_Nombre = rsAudPap("Cli_Nombre").Value
        dateFecha = rsAudPap("Fecha").Value


    }

    rsAudPap.Close()
%>



<link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">

<style media="print">
    @page {  size: auto;   /* auto is the initial value */ }
    .page-break  { display:block; page-break-before:always; }
    table, tr, td, h1, h2, h3, h4{ font-weight: bold !important; }
</style>
<style>

    .UbiSerie {
        width: 80%
    }
</style>

<center>
    <table border="1" cellpadding="2" cellspacing="2" style="text-align:center; width: 1000px;">
        <tr>
            <td rowspan="2">
                <img src="http://wms.lyde.com.mx/Img/wms/Logo005.png" title="Lyde" style="width: 100px; height: 100px;"/>
            </td>
            <td bgcolor="silver" colspan="8">
                <strong>Cliente</strong>
            </td>
            <td bgcolor="silver">
                <strong>Fecha</strong>
            </td>
        </tr>
        <tr>
            <td colspan="8">
                <h1><strong><%= strCli_Nombre %></strong></h1>
            </td>
            <td>
               <h3><strong><%= dateFecha %></strong></h3>
            </td>
        </tr>

        <tr>
            
            <td bgcolor="silver" colspan="2">
                <strong>Tipo Conteo</strong>
            </td>
            <td bgcolor="silver"  colspan="8">
                <strong>Ubicaci&oacute;n</strong>
            </td>
            
        </tr>
        <tr>
           
            <td  colspan="2">
                <h1><strong></strong></h1>
            </td>
        
           <td  colspan="8">
                <strong><svg id="cbUbicacion" class="UbiSerie">

                </svg></strong>
                <br>
                <%= strUbi_Nombre %> 
            </td>
        </tr>
        <tr>
            <td bgcolor="silver"  colspan="6">
                <strong>LPN</strong>
            </td>
            <td bgcolor="silver" colspan="4">
                <strong>SKU/Modelo</strong>
            </td>
        </tr>
        <tr>
            <td  colspan="6">
                <strong><svg id="cbLPN"  class="UbiSerie">

                </svg></strong>
                <br>
                <%= strPT_LPN %>
            </td>
      
            
             <td  colspan="4">
                <h4><strong>
                    <%= strPro_SKU %>
                    <br>
                    <%= strPro_Nombre %>
                </strong></h4>
            </td>
        </tr>

        <tr>
            <td bgcolor="silver" colspan="5">
                <strong>Auditor Interno</strong>
            </td>
            <td bgcolor="silver" colspan="5">
                <strong>Auditor Externo</strong>
            </td>
        </tr>
        <tr>        
            <td colspan="2" style="width: 20%; height: 80px;">
                
            </td>
    
            <td colspan="3" style="width: 20%; vertical-align: bottom; text-align: center;">
                
            </td>

            <td colspan="3" style="width: 20%;">
                
            </td>
    
            <td colspan="2" style="width: 20%; vertical-align: bottom; text-align: center;">
                
            </td>
        </tr>
        <tr>
            
            <td bgcolor="silver" colspan="2">
                <strong>Cantidad</strong>
            </td>
            <td bgcolor="silver" colspan="3">
                <strong>Nombre y Firma</strong>
            </td>
           
            <td bgcolor="silver" colspan="3">
                <strong>Cantidad</strong>
            </td>
            <td bgcolor="silver" colspan="2">
                <strong>Nombre y Firma</strong>
            </td>
        </tr>
    </table>
</center>
<br>
<script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/JsBarcode/JsBarcode.all.min.js" charset="utf-8" ></script>

<script type="application/javascript">
    $(document).ready(function(e) {

	
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800)
});	
	
		

        JsBarcode("#cbLPN", "<%= strPT_LPN %>", {
            width: 3,
            align:"center",
            height: 50,
            fontSize: 1,
            displayValue: false,
            font:"fantasy"
        });
        JsBarcode("#cbUbicacion", "<%= strUbi_Nombre %>", {
            width: 3,
            height: 50,
            fontSize: 1,
            displayValue: false,
            font:"fantasy"
        });
       


        //window.print();    
    });
</script>
