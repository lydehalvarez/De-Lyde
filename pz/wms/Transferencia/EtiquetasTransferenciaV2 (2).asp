<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var TA_ID = Parametro("TA_ID",-1)
	var Cajas = Parametro("Cajas",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	var Folio = ""
   
	var Transfer = "SELECT t.TA_ID, t.Cli_ID, Alm_Nombre as Destino, Alm_Numero, Tda_ID "
        Transfer += ",Alm_Responsable as Responsable, Alm_RespTelefono as Telefono, TA_Folio "
        Transfer += ",TA_FolioCliente , TA_End_Warehouse_ID "
        //datos del cliente
		Transfer += " ,(SELECT Cli_Nombre FROM Cliente ct WHERE ct.Cli_ID  = t.Cli_ID ) Cliente "
        //datos de la direccion
		Transfer += " , CASE  "
		Transfer +=     " WHEN ISNULL(Alm_DireccionCompleta,'') = '' THEN ISNULL((  "
		Transfer +=          " SELECT Alm_Calle + ', # ' + Alm_NumExt  "
		Transfer +=          " + CASE WHEN LEN(LTRIM(RTRIM(Alm_NumInt)))>0 THEN ' int ' + Alm_NumInt  "
		Transfer +=          "  ELSE '' END "
		Transfer +=          " + ' ' + Alm_Colonia + ' ' + Alm_Delegacion + ' ' + Alm_Ciudad + ' CP:' "
		Transfer +=          " + Alm_CP + ' ' + Alm_Estado "
        Transfer +=          " FROM Almacen ax  " 
		Transfer +=          " WHERE ax.Alm_ID = a.Alm_ID "
	    Transfer +=          "),'') "
	    Transfer +=     " WHEN ISNULL(Alm_DireccionCompleta,'') <> '' THEN Alm_DireccionCompleta  "
        Transfer +=     " END as Direccion "
        //datos del aeropuerto
        Transfer += " , CASE   "
        Transfer +=     " WHEN a.Aer_ID = -1 THEN '' "
        Transfer +=     " WHEN a.Aer_ID = 0 THEN 'DIRECTO' "
        Transfer +=     " WHEN a.Aer_ID > 0 THEN (select Aer_NombreAG FROM Cat_Aeropuerto  ap WHERE ap.Aer_ID = a.Aer_ID) "
        Transfer +=     " END AS Aeropuerto "
        Transfer +=     " ,a.Alm_Ruta as Ruta "
        Transfer +=     " ,TA_DocImpreso "
		
        Transfer +=     " ,a.Alm_Nombre Nombre "
        Transfer +=     " ,a.Tda_ID Numero "
        Transfer +=     " ,a.Alm_Calle Calle "
        Transfer +=     " ,a.Alm_NumExt Ext "
        Transfer +=     " ,a.Alm_NumInt Int "
        Transfer +=     " ,a.Alm_CP CP "
        Transfer +=     " ,a.Alm_Colonia Col"
        Transfer +=     " ,a.Alm_Delegacion Del "
        Transfer +=     " ,a.Alm_Ciudad Ciu "
        Transfer +=     " ,a.Alm_Estado Estado "
        Transfer +=     " ,a.Alm_Pais Pais"

        Transfer +=  " FROM TransferenciaAlmacen t , Almacen a "
        Transfer +=  " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        Transfer +=  " AND TA_ID = "+TA_ID
   

	var rsTra = AbreTabla(Transfer,1,0)
     if(!rsTra.EOF){
		 Folio = rsTra.Fields.Item("TA_Folio")
		 var TA_FolioCliente = rsTra.Fields.Item("TA_FolioCliente")
		 var TA_End_Warehouse_ID = rsTra.Fields.Item("TA_End_Warehouse_ID")
		 var Destino = rsTra.Fields.Item("Destino")
		 var Direccion = rsTra.Fields.Item("Direccion")
		 var Responsable = rsTra.Fields.Item("Responsable")
		 var Telefono = rsTra.Fields.Item("Telefono")
		 var Cliente = rsTra.Fields.Item("Cliente")
		 var Cli_ID = rsTra.Fields.Item("Cli_ID")
		 var Aeropuerto = rsTra.Fields.Item("Aeropuerto") 
		 var Ruta = rsTra.Fields.Item("Ruta") 
		 var TA_DocImpreso = rsTra.Fields.Item("TA_DocImpreso")
		 
		 
		 var Calle = rsTra.Fields.Item("Calle")
		 var Ext = rsTra.Fields.Item("Ext")
		 var Inte = rsTra.Fields.Item("Int")
		 var Col = rsTra.Fields.Item("Col")
		 var Del = rsTra.Fields.Item("Del")
		 var Ciu = rsTra.Fields.Item("Ciu")
		 var CP = rsTra.Fields.Item("CP")
		 var Estado = rsTra.Fields.Item("Estado")
		 var Pais = rsTra.Fields.Item("Pais")
		 var Tda_ID = rsTra.Fields.Item("Tda_ID")
		 var Tda_Nombre = Destino
		 
	 }
	 
	 
		 if(TA_DocImpreso == 0){
			 
			 var DocImpresoSQL = "UPDATE TransferenciaAlmacen "
			 	 DocImpresoSQL += " SET TA_DocImpreso = 1 "
			 	 DocImpresoSQL += " ,TA_DocImpresoUsu = " +IDUsuario
			 	 DocImpresoSQL += " WHERE TA_ID = "+TA_ID
				 
				 Ejecuta(DocImpresoSQL,0)
	 
			if(Aeropuerto != ""){
				Aeropuerto = "Aeropuerto -"+Aeropuerto
			} else{
				Aeropuerto = "&nbsp;"
			}
			if(Ruta != ""){
				Ruta = "Ruta -"+Ruta
			} else{
				Ruta = "&nbsp;"
			}
		 
%>	 

	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">
	<style type="text/css">
		@page {
		   size: 4in 6in;
		   margin: 5mm 5mm 5mm 5mm;
		}
		body, div, table, thead, tbody, tfoot, tr, th, td, p {
			font-family: 'Poppins', sans-serif;
			font-size: 16px
		}
		.Sangria{
			padding-left: 15px
		}
		.letrotas{
			font-size:22px	
		}
		@media all {
		   .saltopagina{
			  display: none;
		   }
		}
		   
		@media print{
		   .saltopagina{
			  display:block;
			  page-break-before:always;
		   }
		}
	</style>

    
<%	for(var i = 1;i<=Cajas;i++){			 %>
    
<div style="width: 5in;height: 7in">
        <table width="100%" cellspacing="0" border="0">
            <tr >
                <td valign=bottom colspan="5" style="font-size: large;">Orden de producci&oacute;n</td>
                <td width="10%" align="right" style="font-family:'Arial Black', Gadget, sans-serif;font-style:italic;" valign=bottom>Lyde</td>
            </tr>
            <tr>
                <td colspan="6" style="border-top: 1px solid #000000;padding-top:5px">De:</td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><strong>Karla Ortega  -  55 2569 6062</strong></td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6">Santa Cecilia 211</td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6">Col Santa Cecilia</td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6">TLANEPANTLA DE BAZ</td>
            </tr>
            <tr>
                <td colspan="3" class="Sangria" width="50%">Estado de Mexico</td>
                <td colspan="3" width="50%">CP: 54130</td>
            </tr>
            <tr>
                <td style="border-top: 1px solid #000000;padding-top:5px" colspan="6">Para:</td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><strong><%=Responsable%></strong></td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><%=Tda_Nombre%></td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><%=Calle%>, <%=Ext%>, <%=Inte%></td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><%=Del%></td>
            </tr>
            <tr>
                <td class="Sangria" colspan="6"><%=Ciu%></td>
            </tr>
            <tr >
                <td class="Sangria" width="50%" colspan="3"><%=Estado%></td>
                <td width="50%" colspan="3">CP: <%=CP%></td>
            </tr>
            <tr>
                <td style="border-top: 1px solid #000000;padding-top:5px;" width="50%" class="Sangria letrotas" colspan="3">Tienda - <%=Tda_ID%></td>
                <td style="border-top: 1px solid #000000;padding-top:5px;" width="50%" class="Sangria letrotas" colspan="3"><%=Ruta%></td>
            </tr>
            <tr>
                <td width="50%" class="Sangria letrotas" colspan="3">DO - <%=TA_FolioCliente%></td>
                <td width="50%" class="Sangria letrotas" colspan="3"><%=Aeropuerto%></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid;border-top: 1px solid;border-right: 1px solid;" class="Sangria letrotas">
                       Caja <%=i%> de <%=Cajas%>  
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6" align="center">
                        <canvas id="barcode"></canvas>  
                </td>
            </tr>
            <tr>
                <td colspan="6" style="text-align:center">
                   <p style="font-size:18px"><%=Folio%></p>    
                </td>
            </tr>
    </table>
</div>
	<%if(i != Cajas){%>
        <div class="saltopagina"></div>
    <%}%>
<%}%>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 2,
	  height: 70,
	  displayValue: false
	});
	
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800)
});	
	

</script>    

<%
		 }else{%>
			 <p style="font-size:xx-large;color:#F00">Lo sentimos ya fue impresa esta etiqueta del pedido <%=Folio%>.</p>
             <p style="font-size:xx-large;color:#F00">Solicita permiso al supervisor.</p>
	 <%}
%>	






        