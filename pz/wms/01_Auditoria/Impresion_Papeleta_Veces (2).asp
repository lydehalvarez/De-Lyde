<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var cxnTipo = 0
    var Aud_ID = Parametro("Aud_ID", -1)
    var PT_ID = Parametro("PT_ID", -1)
    var Vista = Parametro("Vista", 1)

    var vez = Parametro("vez", 1)   
   
    var Impreso = Parametro("Impreso", 0)	
    
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
    
    var sqlLpn = "SELECT AUU.AudU_Veces,AUU.PT_ID "
               + " , AUU.AudU_CodigoBarras " 
               + ", ISNULL(AUU.AudU_ArticulosConteoTotal, 0) AS AudU_ArticulosConteoTotal "
				+ ", Pro.Pro_SKU "
				+ ", Pro.Pro_Nombre "
				+ ", PT.PT_LPN "
				+ ", Ubi.Ubi_Nombre "
				+ ", Usu.Usu_Nombre "
			   + ", Cli.Cli_Nombre "
			   + " , ISNULL(AUU.AudU_ConteoInterno, 0) AS AudU_ConteoInterno "
			   + ", CONVERT(VARCHAR, GETDATE(), 103) AS Fecha "
			   + ", TPA.CAT_Nombre AS TPA_Nombre "
			   + " FROM Auditorias_Ubicacion AUU "
			   + " LEFT JOIN Auditorias_Pallet AUP "
			   + " ON AUU.Aud_ID = AUP.Aud_ID "
				+ "        AND AUU.PT_ID = AUP.PT_ID "
				+ "    LEFT JOIN Pallet PT  "
				+ "        ON AUU.PT_ID = PT.PT_ID  "
				+ "    LEFT JOIN Producto Pro  "
				 + "       ON PT.Pro_ID = Pro.Pro_ID  "
				+ "   INNER JOIN Ubicacion Ubi  "
				+ "     ON AUP.Ubi_ID = Ubi.Ubi_ID  "
			   + "  LEFT JOIN Auditorias_Auditores AUA  "
			   + "      ON AUU.AudU_AsignadoA = AUA.USU_ID  "
				 + "    AND AUU.Aud_ID = AUA.Aud_ID  "
				+ " LEFT JOIN Usuario USU  "
				   + "  ON AUA.Usu_ID = USU.Usu_ID  "
				+ " LEFT JOIN Cliente Cli  "
				+ "     ON PT.Cli_ID = Cli.Cli_ID  "
			  + "   LEFT JOIN CAT_Catalogo TPA  "
				+ "     ON AUU.AudU_TipoConteoCG142 = TPA.Cat_ID  "
				+ "     AND TPA.SEC_ID = 142  "
			+ " WHERE AUU.Aud_ID = "+Aud_ID+" AND AUU.AudU_Veces = " + vez
			+ " AND AUU.PT_ID IN (" + PT_ID + ") "
			+ " ORDER BY Ubi_Nombre DESC "


    var rsAudPap = AbreTabla(sqlLpn, 1, cxnTipo)
	
	var AudU_Impreso = BuscaSoloUnDato("MAX(AudU_Impreso) + 1","Auditorias_Ubicacion","Aud_ID = "+Aud_ID,-1,0)


    var i = 0

    while( !(rsAudPap.EOF) ){
   
        PT_ID = rsAudPap("PT_ID").Value
        intAudU_Veces = rsAudPap("AudU_Veces").Value
        intAudU_CodigoBarras = rsAudPap("AudU_CodigoBarras").Value
        strPro_SKU = rsAudPap("Pro_SKU").Value
        strPro_Nombre = rsAudPap("Pro_Nombre").Value
        strPT_LPN = rsAudPap("PT_LPN").Value
        strUbi_Nombre = rsAudPap("Ubi_Nombre").Value
        intAudU_ConteoInterno = rsAudPap("AudU_ConteoInterno").Value
        
        strCli_Nombre = rsAudPap("Cli_Nombre").Value
        dateFecha = rsAudPap("Fecha").Value

        strUsu_Nombre = rsAudPap("Usu_Nombre").Value            
        strTPA_Nombre = rsAudPap("TPA_Nombre").Value


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
    @media print {
        .page-break  { display: block; page-break-before: always; }
    }
    
</style>

<script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/JsBarcode/JsBarcode.all.min.js" charset="utf-8" ></script>
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
            <td bgcolor="silver">
                <strong>Papeleta</strong>
            </td>
            <td bgcolor="silver" colspan="1">
                <strong>Visita</strong>
            </td>
            <td bgcolor="silver" colspan="2">
                <strong>Tipo Conteo</strong>
            </td>
            <td bgcolor="silver"  colspan="6">
                <strong>Ubicaci&oacute;n</strong>
            </td>
            
        </tr>
        <tr>
            <td>
                <strong>
				<canvas  class="barcode"
                  jsbarcode-value="<%=intAudU_CodigoBarras%>"
				  jsbarcode-displayValue="false"
				  >
                </canvas >
                
                </strong><br />
				<%=intAudU_CodigoBarras%>
            </td>
            <td  colspan="1">
                <h1><strong><%= Vista %></strong></h1>
            </td>
            <td  colspan="2">
                <h4><strong><%= strTPA_Nombre %></strong></h4>
            </td>
           <td  colspan="6">
                <strong>
					<canvas  class="barcode"
                      jsbarcode-value="<%=strUbi_Nombre%>"
					  jsbarcode-displayValue="false"
					  ></canvas >
                
                </strong>
                <br>
                <%=strUbi_Nombre %> 
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
                <strong>
					<canvas  class="barcode"
                      jsbarcode-value="<%=strPT_LPN%>"
					  jsbarcode-displayValue="false"
					  >
                    </canvas >
                
                </strong>
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
    <div class="page-break"></div>
    
<%
		   if(Impreso == 0){
			   var ColocaImpreso = " UPDATE Auditorias_Ubicacion "
								+" SET AudU_FechaImpresion = GETDATE() "  
								+" , AudU_Impreso = "+AudU_Impreso
								+" WHERE Aud_ID = "+Aud_ID
								+" AND PT_ID = "+PT_ID
								+" AND AudU_Veces = "+vez
								
			   Ejecuta(ColocaImpreso,0)
		   }   
   
		   rsAudPap.MoveNext();
           /*
		   if(Impreso == 0){
			   var ColocaImpreso = " UPDATE Auditorias_Ubicacion "
								+" SET AudU_FechaImpresion = GETDATE() "  
								+" , AudU_Impreso = "+AudU_Impreso
								+" WHERE Aud_ID = "+Aud_ID
								+" AND PT_ID = "+PT_ID
								+" AND AudU_Veces = "+vez
								
			   Ejecuta(ColocaImpreso,0)
		   }*/
       }

    rsAudPap.Close()
 %>   
    
<br>

<script type="application/javascript">

JsBarcode(".barcode").init();

    $(document).ready(function(e) {
        window.print();
    setTimeout(function(){ 
        window.close();
      }, 800)
    });	
        //window.print();    
</script>
