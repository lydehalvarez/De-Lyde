<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Ser_Serie = Parametro("Serie","") 
	var IDUsuario = Parametro("IDUsuario",-1) 

 	var sResultado = ""

var TA_ID = Parametro("TA_ID",-1) 
var CliOC_ID = Parametro("CliOC_ID",-1)
var Cli_ID = Parametro("Cli_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Pro_ID = Parametro("Pro_ID",-1)



var sSQL = "SELECT Pro_SKU From Producto WHERE Pro_ID = "+ Pro_ID
var rsSKU = AbreTabla(sSQL,1,0)
   if( !(rsSKU.EOF) ){
   
        var SKU = rsSKU.Fields.Item("Pro_SKU").Value
	
        if(CliOC_ID > -1){
            
           // var sCondicion =  " Cli_ID = " + Cli_ID
//                sCondicion += " and CliOC_ID = " + CliOC_ID
//            var CInv_ID = SiguienteID("CInv_ID","Cliente_Inventario",sCondicion,0)
            
            var sSQLTr = "INSERT INTO Cliente_Inventario (Cli_ID, CliOC_ID, CInv_NumeroSerie,"
                sSQLTr += " Inv_EstatusCG22, Pro_ID, CInv_SKU)  " 
                sSQLTr += " values(" + Cli_ID + "," + CliOC_ID + ",'" + Ser_Serie + "'"
                sSQLTr += ", 1, " + Pro_ID + ", '" + SKU + "')"
        }
       
        if(OC_ID > -1){
           var sSQLTr = "INSERT INTO Proveedor_Inventario (Prov_ID, OC_ID, OCP_ID, PInv_NumeroSerie, "
                sSQLTr += " Inv_EstatusCG22,Pro_ID, PInv_SKU)  "
                sSQLTr  += "values("+Prov_ID+"," +OC_ID +",1,'"+Ser_Serie+"', 1,  "+Pro_ID+", '"+SKU+"')"

        }
       
        if(TA_ID > -1){
             var sSQLTr = "TA_ID = "+TA_ID
        }
        
       Ejecuta(sSQLTr, 0) 

       sResultado =  1 //sSQLTr
			
   }
   rsSKU.CLose()
		
   Response.Write(sResultado)

%>
