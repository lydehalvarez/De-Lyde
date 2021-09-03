<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ID = Parametro("TA_ID",-1)
   
   var TA_EstatusCG89 = 0
   
   var TA_Folio = ""
   var FechaElaboracion = ""
   var FechaEntrega = ""
   var TA_Responsable = ""
   var TA_End_Warehouse = ""
   var Alm_Calle = ""
   var Alm_Nombre = ""
   var Alm_HorarioLV = ""
   var Alm_Ubicacion = ""
   var TAA_ID = 0

   	var sSQL = "SELECT TA_CodigoIdentificador, TA_Start_Warehouse_ID, TA_Start_Warehouse "
		sSQL += " , TA_End_Warehouse_ID, TA_End_Warehouse, TA_FolioCliente, TA_Folio "
		sSQL += " ,  TA_EstatusCG89, TA_Responsable, TA_Celular, TA_Email, TA_TipoAcceso "
		sSQL += " , TA_UbicacionTienda, TA_HorarioAtencion "
  		sSQL += " , CONVERT(NVARCHAR(50),TA_FechaElaboracion,103) as FechaElaboracion "
		sSQL += " , CONVERT(NVARCHAR(50),TA_FechaEntrega,103) as FechaEntrega  "
		sSQL += " , Alm_Calle,Alm_DireccionCompleta, Alm_Nombre, Alm_HorarioLV, Alm_Ubicacion " 
		sSQL += " FROM TransferenciaAlmacen ta, Almacen a "
		sSQL += " WHERE a.Alm_ID = ta.TA_End_Warehouse_ID "
		sSQL += " AND ta.TA_ID = " + TA_ID
		
		
   
     
   
	var rsTA = AbreTabla(sSQL,1,0)
    if (!rsTA.EOF){
		TA_EstatusCG89 = rsTA.Fields.Item("TA_EstatusCG89").Value
   		TA_Folio = rsTA.Fields.Item("TA_Folio").Value
		FechaElaboracion = rsTA.Fields.Item("FechaElaboracion").Value
		FechaEntrega = rsTA.Fields.Item("FechaEntrega").Value
        TA_Responsable = rsTA.Fields.Item("TA_Responsable").Value
        TA_End_Warehouse = rsTA.Fields.Item("TA_End_Warehouse").Value
        Alm_Calle = rsTA.Fields.Item("Alm_DireccionCompleta").Value
        Alm_Nombre = rsTA.Fields.Item("Alm_Nombre").Value
        Alm_HorarioLV = rsTA.Fields.Item("Alm_HorarioLV").Value
        Alm_Ubicacion = rsTA.Fields.Item("Alm_Ubicacion").Value
		
	var sSQLT = "SELECT Alm_RespTelefono as Telefono_Origen "
		sSQLT += ", Alm_Responsable as Reponsable_Origen "  
   		sSQLT += ", Alm_Nombre as Sucursal_Origen "
        sSQLT += ", Alm_DireccionCompleta as Direccion_Origen "
		sSQLT += " FROM Almacen h "
		sSQLT += " WHERE Alm_ID = " + rsTA.Fields.Item("TA_Start_Warehouse_ID").Value

		bHayParametros = false
		ParametroCargaDeSQL(sSQLT,0)   
   
	var sSQLT = "SELECT Alm_Nombre as Sucursal_Destino "
		sSQLT += ", Alm_DireccionCompleta as Direccion_Destino "
		sSQLT += ", Alm_Responsable as Reponsable_Destino "
		sSQLT += ", Alm_RespTelefono as Telefono_Destino "
		sSQLT += " FROM Almacen h "
		sSQLT += " WHERE Alm_ID = " + rsTA.Fields.Item("TA_End_Warehouse_ID").Value
		
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLT,0)
		
	}
   	var sSQLF = "SELECT CONVERT(VARCHAR(20), GETDATE(), 103) AS  Fecha ,CONVERT(VARCHAR(5), GETDATE(), 108) AS  Hora "

	var rsFecha = AbreTabla(sSQLF,1,0)
     if(!rsFecha.EOF){
    	var fechaEla = rsFecha.Fields.Item("Fecha").Value + " - " + rsFecha.Fields.Item("Hora").Value
	 }
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">

@page {

size: 27.9cm 21.6cm landscape; /* US letter paper. */

}
.Series{
		font-size: 11px;
	}
/*@page :left {
 margin-left: 1.5cm;
 margin-right: 1cm;
margin-top: 1cm;
	margin-bottom:  1cm;
	}
@page :right {
 margin-left: 1.5cm;
 margin-right: 1cm; 
margin-top: 1.5cm;
	margin-bottom:  1cm;
}
*/		
</style> 
</head>
<title><%=Alm_Nombre%>&nbsp;<%=TA_Folio%></title>  
 
<body> 
<table width="871" border="0">
  <tbody>
    <tr>
      <td width="135" rowspan="5"><img src="/Img/wms/Logo005.png" width="132" height="150" alt=""/></td>
      <td width="114">&nbsp;</td>
      <td width="252">&nbsp;</td>
      <td colspan="2" align="right">TRANSFERENCIA</td>
      <td width="113" align="right"><%=TA_Folio%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="4" align="right">Log&iacute;stica y Distribuci&oacute;n Empresarial, S.A. de C.V. </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="60">&nbsp;</td>
      <td width="100">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Fecha</td>
      <td align="center"><%=fechaEla%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Fecha de entrega</td>
      <td align="center"><%=FechaEntrega%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

<div class="row">
	<div class="col-xs-6">
        <table class="table">
          <tr>
            <td>ORIGEN</td>
            <td><%=Parametro("Direccion_Origen","")%></td>
          </tr>
          </tr>
          <tr>
            <td>Nombre de sucursal</td>
            <td><%=Parametro("Sucursal_Origen","")%></td>
          </tr>
          <tr>
            <td>Responsable</td>
            <td><%=Parametro("Reponsable_Origen","")%></td>
          </tr>
          <tr>
            <td>Contacto</td>
            <td><%=Parametro("Telefono_Origen","")%></td>
          </tr>
        </table>
     </div>
	<div class="col-xs-6">
        <table class="table">
          <tr>
            <td>DESTINO</td>
            <td><%=Parametro("Direccion_Destino","")%></td>
          </tr>
          <tr>
            <td>Nombre de sucursal</td>
            <td><%=Parametro("Sucursal_Destino","")%></td>
          </tr>
          <tr>
            <td>Responsable</td>
            <td><%=Parametro("Reponsable_Destino","")%></td>
          </tr>
          <tr>
            <td>Contacto</td>
            <td><%=Parametro("Telefono_Destino","")%></td>
          </tr>
        </table>
    </div>
</div>
<%/*%>

<table  width="871" cellspacing="0" cellpadding="0">
  <col width="80" />
  <col width="73" />
  <col width="151" />
  <col width="107" />
  <col width="80" />
  <col width="121" />
  <col width="131" span="2" />
  <tr style="border-bottom-style: solid;border-bottom-width: 1px;">
    <td width="80">ORIGEN</td>
    <td width="73">&nbsp;</td>
    <td width="151">&nbsp;</td>
    <td width="107">&nbsp;</td>
    <td width="80">&nbsp;</td>
    <td colspan="2" width="252">Horario</td>
    <td width="131">Fecha entrega</td>
  </tr>
  <tr>
    <td colspan="3"><%=Parametro("Reponsable_Origen","")%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" width="252"><%=Parametro("TA_Responsable","")%></td>
    <td width="131"><%=Parametro("TA_Responsable","")%></td>
  </tr>
  <tr>
    <td width="80"><%=Parametro("TA_Responsable","")%></td>
    <td colspan="2"><%=Parametro("TA_Responsable","")%></td>
    <td><%=Parametro("TA_Responsable","")%></td>
    <td></td>
    <td width="121"></td>
    <td></td>
    <td style="border-bottom-style: solid;border-bottom-width: 1px;">TIENDA</td>
  </tr>
  <tr style="border-bottom-style: solid;border-bottom-width: 1px;">
    <td width="80">&nbsp;</td>
    <td colspan="5" width="532"><%=Parametro("TA_Responsable","")%></td>
    <td width="131">&nbsp;</td>
    <td width="131"><%=Parametro("TA_Responsable","")%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr style="border-bottom-style: solid;border-bottom-width: 1px;">
    <td width="80">DESTINO</td>
    <td width="73">&nbsp;</td>
    <td width="151">&nbsp;</td>
    <td width="107">&nbsp;</td>
    <td width="80">&nbsp;</td>
    <td colspan="2" width="252">Horario</td>
    <td width="131">Fecha entrega</td>
  </tr>
  <tr>
    <td colspan="3"><%=TA_Responsable%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" width="252"><%=Alm_HorarioLV %></td>
    <td width="131"><%=FechaEntrega%></td>
  </tr>
  <tr>
    <td width="80"><%=TA_End_Warehouse%></td>
    <td colspan="2"><%=Alm_Nombre %></td>
    <td><%=Alm_Ubicacion%></td>
    <td></td>
    <td width="121"></td>
    <td></td>
    <td style="border-bottom-style: solid;border-bottom-width: 1px;">TIENDA</td>
  </tr>
  <tr style="border-bottom-style: solid;border-bottom-width: 1px;">
    <td width="80">&nbsp;</td>
    <td colspan="5" width="532"><%=Alm_Calle%></td>
    <td width="131">&nbsp;</td>
    <td width="131"><%=TA_End_Warehouse%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<%*/%><table  width="871"  cellspacing="0" cellpadding="0" border="0">
  <col width="80" />
  <col width="73" />
  <col width="151" />
  <col width="107" />
  <col width="80" />
  <col width="121" />
  <col width="131" span="2" />
  <tr>
    <td width="80"></td>
    <td width="532"></td>
    <td width="151"></td>
    <td width="107"></td>
    <td width="80"></td>
    <td width="121"></td>
    <td width="131"></td>
    <td width="131"></td>
  </tr>
  <tr>
    <td colspan="2">ART&Iacute;CULOS</td>
    <td colspan="3"></td>
    <td width="121"></td>
    <td width="131"></td>
    <td width="131"></td>
  </tr>

  <col width="80" />
  <col width="73" />
  <col width="151" />
  <col width="107" />
  <col width="80" />
  <col width="121" />
  <col width="131"  />
  <tr style="    border-bottom-style: double;">
    <td >Partida</td>
    <td colspan="2">Descripci&oacute;n</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >SKU</td>
    <td >Cantidad</td>
  </tr>
<%
	var iRenglon = 0
   var Suma = 0
   	var sSQL = "SELECT TA_ID, TAA_ID, TAA_SKU, TAA_Cantidad "
		sSQL += " , Pro_Nombre, Pro_Descripcion "
		sSQL += " FROM TransferenciaAlmacen_Articulos t, Producto p "
		sSQL += " WHERE p.Pro_ID = t.Pro_ID  "
		sSQL += " and TA_ID =" + TA_ID
   
   
   
	var rsTAA = AbreTabla(sSQL,1,0)
     while (!rsTAA.EOF){
          iRenglon++
          Suma += rsTAA.Fields.Item("TAA_Cantidad").Value
          TAA_ID = rsTAA.Fields.Item("TAA_ID").Value
%>	
  <tr style="border-top-style: solid;border-top-width: 1px;">
    <td><%=iRenglon%></td>
    <td colspan="5" rowspan="2" style="padding-top:10px;"><%=rsTAA.Fields.Item("Pro_Nombre").Value%><br>
		<%=rsTAA.Fields.Item("Pro_Descripcion").Value%>
											   
	</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><%=rsTAA.Fields.Item("TAA_SKU").Value%></td>
    <td><%=rsTAA.Fields.Item("TAA_Cantidad").Value%>	</td>
  </tr>

<%
	var iSerie = 0
   var cSeries = 0
   var sSeries = ""
   	var sSQL = "SELECT TAS_Serie "
		sSQL += " FROM TransferenciaAlmacen_Articulo_Picking "
		sSQL += " WHERE TA_ID =" + TA_ID
		sSQL += " and TAA_ID =" + TAA_ID
   
	var rsTAS = AbreTabla(sSQL,1,0)
     while (!rsTAS.EOF){
          cSeries++
          iSerie++
   		  if(iSerie >1){
			sSeries += ", "
          }
		  if (cSeries >5 ){
			   cSeries = 1
%>
  <tr>
    <td>&nbsp;</td>
    <td colspan="7" class="Series">
<%
			   Response.Write(sSeries) 
			   sSeries = ""
%>
	</td>
  </tr>			
<%
		  }
	      sSeries += rsTAS.Fields.Item("TAS_Serie").Value
		rsTAS.MoveNext() 
		}
	rsTAS.Close()  
  if(sSeries != ""){
 %>
  <tr>
    <td>&nbsp;</td>
    <td colspan="7" class="Series">
<%
			   Response.Write(sSeries) 
			   sSeries = ""
%>
	</td>
  </tr>			
<%
    }
	rsTAA.MoveNext() 
	}
rsTAA.Close()   
%>	
</table>

<table cellspacing="0" cellpadding="0">
  <col width="80" />
  <col width="73" />
  <col width="151" />
  <col width="107" />
  <col width="80" />
  <col width="121" />
  <col width="131" span="2" />
  <tr>
    <td width="80">&nbsp;</td>
    <td width="73">&nbsp;</td>
    <td width="151">&nbsp;</td>
    <td width="107">&nbsp;</td>
    <td width="80">&nbsp;</td>
    <td width="121">&nbsp;</td>
    <td width="131">Piezas</td>
    <td width="131"><%=Suma%></td>
  </tr>
  <tr>
    <td width="80"></td>
    <td width="73"></td>
    <td width="151"></td>
    <td width="107"></td>
    <td width="80"></td>
    <td width="121"></td>
    <td width="131"></td>
    <td width="131"></td>
  </tr>
  <tr>
    <td colspan="5">CONTROL DE CALIDAD</td>
    
   
    <td width="121">&nbsp;</td>
    <td width="131">&nbsp;</td>
    <td width="131">&nbsp;</td>
  </tr>
  <tr>
    <td width="80">&nbsp;</td>
    <td width="73"><img width="20" height="19" src="/Img/wms/Chkbx.png" /></td>
    <td width="151">Entrega completa</td>
    <td width="107"></td>
    <td width="80"></td>
    <td width="121"></td>
    <td width="131"></td>
    <td width="131">&nbsp;</td>
  </tr>
  <tr>
    <td width="80">&nbsp;</td>
    <td width="73"><img width="20" height="19" src="/Img/wms/Chkbx.png" /></td>
    <td colspan="2">Producto en buen estado</td>
    <td width="80">&nbsp;</td>
    <td width="121">&nbsp;</td>
    <td width="131">&nbsp;</td>
    <td width="131">&nbsp;</td>
  </tr>
  <tr>
    <td width="80">&nbsp;</td>
    <td width="73"><img width="20" height="19" src="/Img/wms/Chkbx.png" /></td>
    <td width="151">Empaque adecuado</td>
    <td width="107"></td>
    <td width="80"></td>
    <td width="121">Revisado por</td>
    <td width="131"></td>
    <td width="131">&nbsp;</td>
  </tr>
  <tr>
    <td width="80">&nbsp;</td>
    <td width="73">&nbsp;</td>
    <td width="151">&nbsp;</td>
    <td width="107">&nbsp;</td>
    <td width="80">&nbsp;</td>
    <td width="121">&nbsp;</td>
    <td width="131">&nbsp;</td>
    <td width="131">&nbsp;</td>
  </tr>
</table>

</body>
	    <script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
    <script src="/Template/inspina/js/bootstrap.min.js"></script>

<script type="application/javascript">
$(document).ready(function(e) {
	window.print();    
});
</script>
</html>
