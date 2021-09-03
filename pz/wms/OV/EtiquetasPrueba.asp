<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var Cort_ID = Parametro("Cort_ID",-1)
	
	var sSQLOV = "SELECT *, (SELECT Top 1 CUSTOMER_NAME FROM Izzi_Orden_Venta p WHERE p.OV_ID = t.OV_ID ) CUSTOMER_NAME "
		sSQLOV += ",(SELECT Top 1 SHIPPING_ADDRESS FROM Izzi_Orden_Venta p WHERE p.OV_ID = t.OV_ID ) SHIPPING_ADDRESS "
		sSQLOV += "FROM Orden_Venta t WHERE OV_Folio in ("
		sSQLOV += " 'SO-000001101', "
		sSQLOV += " 'SO-000001070', "
		sSQLOV += " 'SO-000000990', "
		sSQLOV += " 'SO-000000987', "
		sSQLOV += " 'SO-000001060', "
		sSQLOV += " 'SO-000001127', "
		sSQLOV += " 'SO-000001029', "
		sSQLOV += " 'SO-000001150', "
		sSQLOV += " 'SO-000001024', "
		sSQLOV += " 'SO-000001056', "
		sSQLOV += " 'SO-000001147', "
		sSQLOV += " 'SO-000001248', "
		sSQLOV += " 'SO-000001054', "
		sSQLOV += " 'SO-000001050', "
		sSQLOV += " 'SO-000001043', "
		sSQLOV += " 'SO-000001161', "
		sSQLOV += " 'SO-000001119', "
		sSQLOV += " 'SO-000001022', "
		sSQLOV += " 'SO-000001131', "
		sSQLOV += " 'SO-000001276', "
		sSQLOV += " 'SO-000001129', "
		sSQLOV += " 'SO-000001139', "
		sSQLOV += " 'SO-000001064', "
		sSQLOV += " 'SO-000001026', "
		sSQLOV += " 'SO-000001287', "
		sSQLOV += " 'SO-000001130', "
		sSQLOV += " 'SO-000001106', "
		sSQLOV += " 'SO-000001052', "
		sSQLOV += " 'SO-000000991', "
		sSQLOV += " 'SO-000001312', "
		sSQLOV += " 'SO-000001212', "
		sSQLOV += " 'SO-000001290', "
		sSQLOV += " 'SO-000001003', "
		sSQLOV += " 'SO-000001126', "
		sSQLOV += " 'SO-000001148', "
		sSQLOV += " 'SO-000001219', "
		sSQLOV += " 'SO-000001134', "
		sSQLOV += " 'SO-000001114', "
		sSQLOV += " 'SO-000001153', "
		sSQLOV += " 'SO-000001156', "
		sSQLOV += " 'SO-000001090', "
		sSQLOV += " 'SO-000001194', "
		sSQLOV += " 'SO-000001118', "
		sSQLOV += " 'SO-000001135', "
		sSQLOV += " 'SO-000001072', "
		sSQLOV += " 'SO-000001231', "
		sSQLOV += " 'SO-000001105', "
		sSQLOV += " 'SO-000001066', "
		sSQLOV += " 'SO-000001063', "
		sSQLOV += " 'SO-000001102', "
		sSQLOV += " 'SO-000001137', "
		sSQLOV += " 'SO-000001308', "
		sSQLOV += " 'SO-000001097', "
		sSQLOV += " 'SO-000001154', "
		sSQLOV += " 'SO-000001047', "
		sSQLOV += " 'SO-000001225', "
		sSQLOV += " 'SO-000001081', "
		sSQLOV += " 'SO-000001230', "
		sSQLOV += " 'SO-000001200', "
		sSQLOV += " 'SO-000001002', "
		sSQLOV += " 'SO-000001025', "
		sSQLOV += " 'SO-000001241', "
		sSQLOV += " 'SO-000001113', "
		sSQLOV += " 'SO-000001222', "
		sSQLOV += " 'SO-000001205', "
		sSQLOV += " 'SO-000001136', "
		sSQLOV += " 'SO-000001157', "
		sSQLOV += " 'SO-000001221', "
		sSQLOV += " 'SO-000001030', "
		sSQLOV += " 'SO-000001103', "
		sSQLOV += " 'SO-000001044', "
		sSQLOV += " 'SO-000001307', "
		sSQLOV += " 'SO-000001247', "
		sSQLOV += " 'SO-000001310', "
		sSQLOV += " 'SO-000001146', "
		sSQLOV += " 'SO-000001020', "
		sSQLOV += " 'SO-000001143', "
		sSQLOV += " 'SO-000001238', "
		sSQLOV += " 'SO-000001239', "
		sSQLOV += " 'SO-000001123', "
		sSQLOV += " 'SO-000001098', "
		sSQLOV += " 'SO-000001018', "
		sSQLOV += " 'SO-000000989', "
		sSQLOV += " 'SO-000001092', "
		sSQLOV += " 'SO-000001121', "
		sSQLOV += " 'SO-000001075', "
		sSQLOV += " 'SO-000001217', "
		sSQLOV += " 'SO-000001100', "
		sSQLOV += " 'SO-000001229', "
		sSQLOV += " 'SO-000001164', "
		sSQLOV += " 'SO-000001218', "
		sSQLOV += " 'SO-000001167', "
		sSQLOV += " 'SO-000001088', "
		sSQLOV += " 'SO-000001128', "
		sSQLOV += " 'SO-000001309', "
		sSQLOV += " 'SO-000001184', "
		sSQLOV += " 'SO-000001038', "
		sSQLOV += " 'SO-000001116', "
		sSQLOV += " 'SO-000001117', "
		sSQLOV += " 'SO-000001010', "
		sSQLOV += " 'SO-000001019', "
		sSQLOV += " 'SO-000001078', "
		sSQLOV += " 'SO-000001074', "
		sSQLOV += " 'SO-000001166', "
		sSQLOV += " 'SO-000001080', "
		sSQLOV += " 'SO-000001009', "
		sSQLOV += " 'SO-000000993', "
		sSQLOV += " 'SO-000001099', "
		sSQLOV += " 'SO-000001017', "
		sSQLOV += " 'SO-000000996', "
		sSQLOV += " 'SO-000001023', "
		sSQLOV += " 'SO-000001111', "
		sSQLOV += " 'SO-000001065', "
		sSQLOV += " 'SO-000001036', "
		sSQLOV += " 'SO-000000999', "
		sSQLOV += " 'SO-000001028', "
		sSQLOV += " 'SO-000001141', "
		sSQLOV += " 'SO-000000998', "
		sSQLOV += " 'SO-000001087', "
		sSQLOV += " 'SO-000001094', "
		sSQLOV += " 'SO-000001091', "
		sSQLOV += " 'SO-000001077', "
		sSQLOV += " 'SO-000001165', "
		sSQLOV += " 'SO-000001076', "
		sSQLOV += " 'SO-000001108', "
		sSQLOV += " 'SO-000001049', "
		sSQLOV += " 'SO-000001042', "
		sSQLOV += " 'SO-000001110', "
		sSQLOV += " 'SO-000001067', "
		sSQLOV += " 'SO-000001058', "
		sSQLOV += " 'SO-000001039', "
		sSQLOV += " 'SO-000001095', "
		sSQLOV += " 'SO-000001004', "
		sSQLOV += " 'SO-000001046', "
		sSQLOV += " 'SO-000001033', "
		sSQLOV += " 'SO-000001133', "
		sSQLOV += " 'SO-000001220', "
		sSQLOV += " 'SO-000001109', "
		sSQLOV += " 'SO-000001162' "
		sSQLOV += " )"
		
		sSQLOV += "AND OV_Test = 0"
				
%>
<html >
<head>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
	
	
</head>
<%
	var rsArt = AbreTabla(sSQLOV,1,0)
     while (!rsArt.EOF){
%>			
						<svg class="barcode"
                          jsbarcode-value="<%=rsArt.Fields.Item("OV_Folio")%>"
						  jsbarcode-width="2"
						  >
                        </svg>
<%
	rsArt.MoveNext() 
	}
rsArt.Close()   
%>	

</html>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >

JsBarcode(".barcode").init();
	

</script>    



        