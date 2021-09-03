<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var TA_ID = Parametro("TA_ID",-1)
	var Cajas = Parametro("Cajas",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
   
	var Transfer = "SELECT t.TA_ID, t.Cli_ID, Alm_Nombre as Destino, Alm_Numero, Tda_ID "
        Transfer += ",Alm_Responsable as Responsable, Alm_RespTelefono as Telefono, TAC_Codigo,TAC_ID "
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

        Transfer +=  " FROM TransferenciaAlmacen t , Almacen a, TransferenciaAlmacen_Caja c "
        Transfer +=  " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        Transfer +=  " AND t.TA_ID = c.TA_ID "
        Transfer +=  " AND t.TA_ID =  "+TA_ID
		
		
 
%>	 
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">

	<script charset="utf-8" src="/Template/inspina/js/plugins/QRjs/qrcode.min.js"></script>
	<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
    
    <script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
    
    

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

    
<%	
 var Folio = ""
var rsTra = AbreTabla(Transfer,1,0)	
if(!rsTra.EOF){
	var CajasTotal = rsTra.RecordCount
	var Destino = rsTra.Fields.Item("Destino")
	var Direccion = rsTra.Fields.Item("Direccion")
	var Responsable = rsTra.Fields.Item("Responsable")
	var Telefono = rsTra.Fields.Item("Telefono")
	var Cliente = rsTra.Fields.Item("Cliente")
	var Cli_ID = rsTra.Fields.Item("Cli_ID")
	var Aeropuerto = rsTra.Fields.Item("Aeropuerto") 
	var Ruta = rsTra.Fields.Item("Ruta") 
	var TA_DocImpreso = rsTra.Fields.Item("TA_DocImpreso")
	var TA_FolioCliente = rsTra.Fields.Item("TA_FolioCliente")
	
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
	
	if(Aeropuerto != ""){
		Aeropuerto = "Aeropuerto -"+Aeropuerto
	} else{
		Aeropuerto = "&nbsp;"
	}
	if(Ruta != ""){
		Ruta = "Ruta - "+Ruta
	} else{
		Ruta = "&nbsp;"
	}
	var TAC_ID = -1

while(!rsTra.EOF){
	 
	 TAC_ID = rsTra.Fields.Item("TAC_ID")
	 Folio = rsTra.Fields.Item("TAC_Codigo")	
	 %>
    
<div style="width: 5in;height: 7in">
        <table width="100%" cellspacing="0" border="0">
            <tr >
                <td valign=bottom style="font-size: large;">Orden de producci&oacute;n</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td width="10%" align="right" style="font-family:'Arial Black', Gadget, sans-serif;font-style:italic;" valign=bottom>Lyde</td>
            </tr>
            <tr>
            	<td class="desc letrotas" colspan="6">
                    <hr/>
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                De:
                                Karla Ortega  -  55 2569 6062<br />
                                Santa Cecilia 211<br />
                                Col Santa Cecilia<br />
                                TLANEPANTLA DE BAZ<br />
                                Estado de Mexico
                            </div>
                        </div>
                    </div>
                    <hr/>
                    <div class="container-fluid">
                        <div class="row">
                        	<div class="col-md-12">
                            	<table width="100%">
                                	<tr>
                                    	<td>
											<%=Responsable%><br />
                                            <%=Tda_Nombre%><br />
                                            <%=Calle%>, <%=Ext%>, <%=Inte%><br />
                                            <%=Del%><br />
                                            <%=Ciu%><br />
                                            <%=Estado%><br />
                                            CP: <%=CP%>
                                        </td>
                                    	<td>
                                            <div id="qrcode"></div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <hr/>
                </td>
            </tr>
            <tr>
                <td style="border-top: 1px solid #000000;padding-top:5px;" width="50%" class="Sangria letrotas" colspan="6"><%=Ruta%></td>
            </tr>
            <tr>
                <td colspan="6 letrotas">
                	<hr/>
                    <div class="row">
                        <div class="col-md-12">
                            <table width="100%">
                                <tr>
                                    <td> Tienda - <%=Tda_ID%></td>
                                    <td>
                                        <svg class="barcode"
										  jsbarcode-width="2"
										  jsbarcode-height="35"
										  jsbarcode-value="<%=Tda_ID%>"
										  jsbarcode-displayValue="false">
										</svg>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%=Ruta%></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="50%" class="Sangria letrotas" colspan="3">DO - <%=TA_FolioCliente%></td>
                <td width="50%" class="Sangria letrotas" colspan="3"><%=Aeropuerto%></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid;border-top: 1px solid;border-right: 1px solid;" class="Sangria letrotas">
                       Caja <%=TAC_ID%> de <%=CajasTotal%>  
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6" align="center">
					<svg class="barcode"
                      jsbarcode-width="2"
                      jsbarcode-height="70"
                      jsbarcode-value="<%=Folio%>"
                      jsbarcode-displayValue="false">
                    </svg>  
                </td>
            </tr>
            <tr>
                <td colspan="6" style="text-align:center">
                   <p style="font-size:18px"><%=Folio%></p>    
                </td>
            </tr>
    </table>
</div>
	<%if(TAC_ID != CajasTotal){%>
        <div class="saltopagina"></div>
    <%}%>
<%
	rsTra.MoveNext() 
}
rsTra.Close()  
%>

<script charset="utf-8" >

	JsBarcode(".barcode").init();
	
	var qrcode = new QRCode("qrcode", {
		text: "SMy63aLpyJu8PepjIaMwYXOhh1f5Kh03antyaJsbW8HT5pqpcLw1EMdkdkyliRJWSMjpKZDGSAidmDXQUUycpGflXg+pUqDelkESUCLPO/XAqHxI3X6dfxwU9tKGrMIevz8g3Tcdual8VNS3v4r3n5Sio/4Fm79fSteGCJIVMm7LMqSML4a+mayG/wCfGUU0w15txN+pCHsiiyaIviXKsDMx3ob51YYT5x36VK1Uo98pCd4+exO/TXdsQWpyA1wC",
		width: 180,
		height: 180,
		colorDark : "#000000",
		colorLight : "#ffffff",
		correctLevel : QRCode.CorrectLevel.H
	});


//
//$(document).ready(function(e) {
//    window.print();
//setTimeout(function(){ 
//             window.close();
//  }, 800)
//});	
	

</script>    
<%
}else{%>

<h1>Lo sentimos, el pedido no tiene remisi&oacute;n</h1>
	
<%
}
%>




        




        