<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var cxnTipo = 0
    var Aud_ID = Parametro("Aud_ID", -1)
    var PT_ID = Parametro("PT_ID", -1)
    var vez = Parametro("vez", 1)	
    
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
    
    var sqlLpn = "SELECT a.AudU_CodigoBarras as Barra,b.[Pt_LPN] "
			+" ,(SELECT Ubi_Nombre FROM Ubicacion WHERE Ubi_ID = b.Ubi_ID) Ubicacion "
			+" ,Pro_Nombre "
			+" ,Pro_SKU "
			+" FROM Auditorias_Ubicacion a, Auditorias_Pallet b, Producto c "
			+" WHERE AudU_ArticulosConteoTotal = 0 "
			+" AND a.AudU_ConteoInterno = 1 "
			+" AND a.Aud_ID = " + Aud_ID
			+" AND a.AudU_Veces = " + vez
			+" AND a.PT_ID = b.PT_ID "
			+" AND b.Pro_ID = c.Pro_ID "
			+" AND a.Aud_ID = b.Aud_ID "
			+" AND a.PT_ID in ("+ PT_ID +") "
			+" ORDER BY a.PT_ID DESC "
   
    var rsAudPap = AbreTabla(sqlLpn, 1, cxnTipo)

    var i = 0

   %>



<link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">
    
</style>

    <table class="table table-bordered">
    	<thead>
        	<tr>
            	<th>Codigo</th>
            	<th width="30%">Ubicacion</th>
            	<th width="20%">Nombre</th>
            	<th>SKU</th>
            	<th>LPN</th>
            	<th>Conteo</th>
            	<th>Firma</th>
            </tr>
        
        
        </thead>
<%
	var Pro_SKU = ""
	var pro_Nombre = ""
	var Pt_LPN = ""
	var Ubi_Nombre = ""
	var PT_Cantidad_Actual = ""
	var Pro_Nombre = ""
	var ConteoExterno = ""
	
    while( !(rsAudPap.EOF) ){
		Pro_SKU = rsAudPap("Pro_SKU").Value
		Pro_Nombre = rsAudPap("Pro_Nombre").Value
		Ubi_Nombre = rsAudPap("Ubicacion").Value
		Pt_LPN = rsAudPap("Pt_LPN").Value
//		PT_Cantidad_Actual = rsAudPap("PT_Cantidad_Actual").Value
//		ConteoInterno = rsAudPap("ConteoInterno").Value
//		ConteoExterno = rsAudPap("ConteoExterno").Value
 %>   
        <tr>
			<td>
				<svg class="barcode"
                  jsbarcode-value="<%=rsAudPap("Barra").Value%>"
				  jsbarcode-height="25"
				  jsbarcode-width="3"
				  >
				  
                </svg>
            </td>
			<td><%=Ubi_Nombre%></td>
			<td><%=Pt_LPN%></td>
			<td><%=Pro_SKU%></td>
			<td><%=Pro_Nombre%></td>
<%/*%>			<td><%=PT_Cantidad_Actual%></td>
			<td><%=ConteoInterno%></td>
			<td><%=ConteoExterno%></td>
<%*/%>		
			<td></td>
			<td></td>
        </tr>
<%
       rsAudPap.MoveNext();     
       }

    rsAudPap.Close()
 %>   
    
<table>
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
	
JsBarcode(".barcode").init();
       


        //window.print();    
    });
</script>
