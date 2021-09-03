<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Acc_Familia = Parametro("Acc_Familia",-1)
	var Acc_Tipo = Parametro("Acc_Tipo",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	
	ParametroCambiaValor("IDUsuario",IDUsuario)
	var Alr_ID = Parametro("Alr_ID",-1)
	
	var iRenglon = 0

//Catalogo general 302
//1	Alerta por BPM           Es lanzada por alguna decisión tomada, despues de tomar la decisión
//2	Alerta por query         Es lanzada por alguna condicion que se cumpla, a la consulta y que cumpla
//3	Alerta por seguimiento   Es un consecutivo de seguimientos, al cumplir la fecha y hora  (calendario)

function ProcesaBuscadorDeParametros(sValor) {

	var sRespuesta = sValor
	var arrPrm    = new Array(0)
	var iPos = sRespuesta.indexOf("{");
	if (iPos > -1) {
		var Antes = sRespuesta.substr(0, iPos);
        var Despues = sRespuesta.substr(iPos  + 1, sRespuesta.length - iPos)
		var iPos2 = Despues.indexOf("}");
		var sParm = Despues.substr(0, iPos2);
		var Despues = Despues.substr(iPos2 + 1, Despues.length - iPos2)
		// resuelve el parametro
		var arrPrm = sParm.split(",")
		var sTmpPP = Parametro(arrPrm[0],arrPrm[1])
		sRespuesta = Antes + sTmpPP + Despues
		sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
	} 
	return sRespuesta
	
}


var sSQL = "SELECT *  "
	sSQL += " FROM Alertamientos "
	sSQL += " WHERE Alr_ID = " + Alr_ID

	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0)	
	
var PlantillaPantalla_ID = Parametro("PlantillaPantalla_ID",0)
var Alr_Letrero = Parametro("Alr_Letrero","")
var Alr_SiguienteVentana = Parametro("Alr_SiguienteVentana",0)
var Alr_SiguienteVentana2 = Parametro("Alr_SiguienteVentana2",0)
var Alr_Descripcion = Parametro("Alr_Descripcion","")
var TipoAlerta = Parametro("Alr_TipoCG302",2)

//Response.Write("<br>Alr_ID = " + Alr_ID + " IDUsuario = " + IDUsuario + " TipoAlerta = " + TipoAlerta)
//Response.Write(" PlantillaPantalla_ID = " + PlantillaPantalla_ID + " Alr_SiguienteVentana = " + Alr_SiguienteVentana)

%>

<div class="panel-body animated fadeInRight" id="Contenido">
	<div class="form-horizontal" >
		<div class="form-group">
		<h2><label class=" col-xs-12"><i class="fa fa-pencil-square teal"></i> <%=Alr_Letrero%></label></h2>
		</div>
        <div class="form-group"><%=Alr_Descripcion%></div>        
        <hr>
<% 

if( TipoAlerta == 2) { 
	if( PlantillaPantalla_ID == 0) { 
		//se ejecutara el query generico para la carga generica de tareas a realizar
		//se requiere que el query contenga dos campos y despues las llaves necesarias
		//el primer campo es el titulo, el segundo es la descripcion y a partir de alli son las llaves a utilizar
		
		//var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
//		if(Alr_QueryGrid != "") {
//			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)
//			var rsAvisos = AbreTabla(sSQL,1,0) 	
//			while (!rsAvisos.EOF){
//				
//				
//				
//				 
//				rsAvisos.MoveNext() 
//			}
//			rsAvisos.Close
//		
//		} else {
			Response.Write("Configure por favor el query del grid")	
//		}
    }  // fin del if PlantillaPantalla_ID == 0 
	if( PlantillaPantalla_ID == 1) { 
		
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				iRenglon++
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("OV_ID").Value	
				Llaves += "," + rsAvisos.Fields.Item("Cli_ID").Value	
				Llaves += "," + Parametro("Alr_SiguienteVentana",90)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" rowspan="4" scope="col">
		<div style="font-size: 50px;text-align: right;"><%= iRenglon %></div>
	</td>
    <td width="3%" scope="col">&nbsp;</td>
    <td width="13%" scope="col">Folio</td>
    <td colspan="3" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Cliente").Value%></td>
    </tr>
  <tr>
    <td nowrap="nowrap">&nbsp;</td>
    <td nowrap="nowrap">Cliente</td>
    <td width="43%">&nbsp;<%=rsAvisos.Fields.Item("Folio").Value%></td>
    <td width="8%">&nbsp;</td>
    <td width="22%"><a href="javascript:VerOrdenVenta(<%=Llaves%>)">ver Orden de Venta</a></td>

  </tr>
  <tr>
    <td valign="top" nowrap="nowrap">&nbsp;</td>
    <td valign="top" nowrap="nowrap">Guia</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("Guia").Value%></td>
    <td>&nbsp;
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Fecha de venta</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("FechaVenta").Value%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query del grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 1 
	if( PlantillaPantalla_ID == 3) { 
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Ser_ID").Value
				Llaves += "," + Parametro("Alr_SiguienteVentana",3000)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Folio</td>
    <td scope="col">&nbsp;<%=rsAvisos.Fields.Item("Ser_FolioInterno").Value%></td>
    <td scope="col">Tipo de servicio</td>
    <td scope="col"><%=rsAvisos.Fields.Item("TipoServicio").Value%></td>
    <td scope="col">&nbsp;</td>
    </tr>
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Cliente</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Cliente").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Almac&eacute;n </td>
    <td width="37%">&nbsp;<%=rsAvisos.Fields.Item("Almacen").Value%></td>
    <td width="10%">Fecha de carga</td>
    <td width="22%">&nbsp;<%=rsAvisos.Fields.Item("FechaCarga").Value%></td>    
    <td width="22%"><a href="javascript:IrAlServicio(<%=Llaves%>)">Ir al servicio</a></td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Veh&iacute;culo</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Vehiculo").Value%></td>
    <td>Fecha Registro</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("FechaRegistro").Value%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Operador&nbsp;&nbsp;</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Operador").Value%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query al grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 3 
	if( PlantillaPantalla_ID == 2) { 
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Prov_ID").Value
				Llaves += "," + Parametro("Alr_SiguienteVentana",3000)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="11%" scope="col">Proveedor</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Prov_RazonSocial").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Clave </td>
    <td width="30%">&nbsp;<%=rsAvisos.Fields.Item("Prov_Clave").Value%></td>
    <td width="25%">&nbsp;</td>
    <td width="7%">&nbsp;</td>    
    <td width="22%"><a href="javascript:VerDocumentos(<%=Llaves%>)">ver Documentos</a></td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query al grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 2 
	if( PlantillaPantalla_ID == 4) { 
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Prov_ID").Value
				Llaves += "," + Parametro("Alr_SiguienteVentana",3000)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="11%" scope="col">Proveedor</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Prov_RazonSocial").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Clave </td>
    <td width="30%">&nbsp;<%=rsAvisos.Fields.Item("Prov_Clave").Value%></td>
    <td width="25%">&nbsp;</td>
    <td width="7%">&nbsp;</td>    
    <td width="22%"><a href="javascript:ValidarBanco(<%=Llaves%>)">Validar informaci&oacute;n general</a></td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query al grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 4 
    if( PlantillaPantalla_ID == 5) { 
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Prov_ID").Value
				Llaves += "," + rsAvisos.Fields.Item("OC_ID").Value		
				Llaves += "," + Parametro("Alr_SiguienteVentana",90)	
%> 

<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="11%" scope="col">Proveedor</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Prov_RazonSocial").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Folio Orden de Compra</td>
    <td width="30%">&nbsp;<%=rsAvisos.Fields.Item("OC_Folio").Value%></td>
    <td width="25%">&nbsp;</td>
    <td width="7%">&nbsp;</td>    
    <td width="22%"><a href="javascript:VerOrdenCompra(<%=Llaves%>)">ver Orden de Compra</a></td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top" nowrap="nowrap">Descripci&oacute;n</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("OC_Descripcion").Value%></td>
    <td>&nbsp;</td>
    <td>&nbsp;
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query al grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 5
	if( PlantillaPantalla_ID == 6) { 
		var Alr_QueryGrid = Parametro("Alr_QueryGrid","")
		if(Alr_QueryGrid != "") {
			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Prov_ID").Value
				Llaves += "," + Parametro("Alr_SiguienteVentana",3000)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="11%" scope="col">Proveedor</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Prov_RazonSocial").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">RFC </td>
    <td width="30%">&nbsp;<%=rsAvisos.Fields.Item("Prov_RFC").Value%></td>
    <td width="25%">&nbsp;</td>
    <td width="7%">&nbsp;</td>    
    <td width="22%"><a href="javascript:ValidarBanco(<%=Llaves%>)">Ver proveedor</a></td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close
		
		} else {
			Response.Write("Configure por favor el query al grid")	
		}
    }  // fin del if PlantillaPantalla_ID == 6 
	if( PlantillaPantalla_ID == 7) {
		var nConsecutivo = 0 
		var Alr_QueryGrid = "select top 50 Ser_ID, Ser_FolioInterno, Tsv_ID "
			Alr_QueryGrid += ", (CONVERT(NVARCHAR(20),Ser_FechaCarga, 103) + ' ' + Ser_HoraCarga ) as FechaCarga "
			Alr_QueryGrid += ", (SELECT Tsv_Nombre FROM TipoServicio t where t.Tsv_ID = Servicio.Tsv_ID) as TipoServicio "
			Alr_QueryGrid += ", (SELECT Cli_RazonSocial FROM Cliente c where c.Cli_ID = Servicio.Cli_ID) as Cliente "
			Alr_QueryGrid += ", (SELECT Alm_Nombre FROM Almacen a where a.Cli_ID = Servicio.Cli_ID AND a.Alm_ID = Servicio.Alm_ID) as Almacen "
			Alr_QueryGrid += ", (SELECT Veh_NumeroEconomico + ' ' + Veh_Placas FROM Vehiculo v where v.Veh_ID = Servicio.Veh_ID) as Vehiculo "
			Alr_QueryGrid += ", (SELECT Ope_NombreCorto FROM Operador o where o.Ope_ID = Servicio.Ope_ID) as Operador "
			Alr_QueryGrid += ", (CONVERT(NVARCHAR(20),Ser_FechaRegistro, 103) + ' ' + CONVERT(NVARCHAR(20),Ser_FechaRegistro, 114)) as FechaRegistro "
			Alr_QueryGrid += ", Des_ID, Cli_ID, Alm_ID, TUni_ID, Veh_ID, Ope_ID, Ope_ID_Acomp, Ser_FechaRegistro "
			Alr_QueryGrid += " from Servicio "
			Alr_QueryGrid += " where Tsv_ID in (1,3) "
			Alr_QueryGrid += " and Ser_FolioControl is null "   
			Alr_QueryGrid += " and Ser_FechaEntrega is null "
			Alr_QueryGrid += " and Ser_Cancelado = 0 "
			Alr_QueryGrid += " and Cli_ID = 1 and Ser_FechaCarga >= '2019-01-01' and Ser_ServicioForaneo = 0 "
			Alr_QueryGrid += " order by Ser_FechaRegistro desc "

			Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
			var rsAvisos = AbreTabla(Alr_QueryGrid,1,0) 	
			while (!rsAvisos.EOF){
				nConsecutivo ++
				Llaves = Alr_ID
				Llaves += "," + rsAvisos.Fields.Item("Ser_ID").Value
				Llaves += "," + Parametro("Alr_SiguienteVentana",3000)	
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" rowspan="5" scope="col"><div style="font-size: 50px;text-align: right;"><%=nConsecutivo%></div></td>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Folio</td>
    <td scope="col">&nbsp;<%=rsAvisos.Fields.Item("Ser_FolioInterno").Value%></td>
    <td nowrap="nowrap" scope="col">Tipo de servicio&nbsp;</td>
    <td width="22%" scope="col">&nbsp;<%=rsAvisos.Fields.Item("TipoServicio").Value%></td>
    <td width="22%" scope="col"><a href="javascript:IrAlServicio(<%=Llaves%>)">Ir al servicio</a></td>
    </tr>
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Cliente</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Cliente").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Almac&eacute;n </td>
    <td width="37%">&nbsp;<%=rsAvisos.Fields.Item("Almacen").Value%></td>
    <td width="10%" nowrap="nowrap">Fecha de carga</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("FechaCarga").Value%></td>    
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Veh&iacute;culo</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Vehiculo").Value%></td>
    <td>Fecha Registro</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("FechaRegistro").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Operador&nbsp;&nbsp;</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Operador").Value%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close

    }  // fin del if PlantillaPantalla_ID == 7 
}  // fin del if TipoAlerta == 1 


if( TipoAlerta == 1) { 
	if( PlantillaPantalla_ID == 7) {
		var nConsecutivo = 0 

		var sSQL2 = "SELECT s.Alr_ID,S.ProF_ID,S.Pro_ID,S.ProS_RolQueRecibe, o.* "
			sSQL2 += " ,(SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = o.Cli_ID) as Cliente  "
			sSQL2 += " ,(SELECT Veh_NumeroEconomico + ' ' + Veh_Placas "
			sSQL2 +=      " FROM Vehiculo v where v.Veh_ID = o.Veh_ID) as Vehiculo  "
            sSQL2 += " ,(CONVERT(NVARCHAR(20),Ser_FechaCarga, 103) + ' '"
			sSQL2 +=   " + CONVERT(NVARCHAR(5),Ser_HoraCarga, 108)) as FechaCarga  "
            sSQL2 += " ,(CONVERT(NVARCHAR(20),Ser_FechaRegistro, 103) + ' '"
			sSQL2 +=   " + CONVERT(NVARCHAR(5),Ser_FechaRegistro, 108)) as FechaRegistro " 
            sSQL2 += " , (SELECT Ope_NombreCorto FROM Operador op where op.Ope_ID = o.Ope_ID) as Operador " 
            sSQL2 += " , (SELECT Tsv_Nombre FROM TipoServicio t where t.Tsv_ID = o.Tsv_ID) as TipoServicio "
            sSQL2 += " , (SELECT Loc_Nombre FROM Compania_Localidad a where a.Loc_ID = o.Loc_ID) as Almacen "
			sSQL2 += " FROM BPM_Proceso_Rol_Usuario ru, BPM_Seguimiento s, Alertamientos a, Orden_Servicio o "
			sSQL2 += " WHERE ru.Pro_ID = s.Pro_ID "
		    sSQL2 += " AND ru.ProR_ID = s.ProS_RolQueRecibe "
		    sSQL2 += " AND s.Alr_ID = a.Alr_ID AND s.Alr_ID = " + Alr_ID
		    sSQL2 += " AND ru.Usu_ID = dbo.fn_Usuario_DameIDUsuario("+ IDUsuario +") "
		    sSQL2 += " AND ru.Pro_ID > 0 "
		    sSQL2 += " AND ru.ProRU_Habilitado = 1 "
		    sSQL2 += " AND s.ProS_EstatusCG81 = 1 "
		    sSQL2 += " AND S.Ser_ID = o.Ser_ID "

			bHayParametros = false
			ParametroCargaDeSQL(sSQL2,0)	
	//Alr_QueryGrid = ProcesaBuscadorDeParametros(Alr_QueryGrid)	
	var rsAvisos = AbreTabla(sSQL2,1,0) 	
	while (!rsAvisos.EOF){
		nConsecutivo ++
		Llaves = Alr_ID
		Llaves += "," + rsAvisos.Fields.Item("Ser_ID").Value
		Llaves += "," + Parametro("Alr_SiguienteVentana",10852)	
		
%> 
   
  
<div class="form-group">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="5%" rowspan="5" scope="col"><div style="font-size: 50px;text-align: right;"><%=nConsecutivo%></div></td>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Folio</td>
    <td scope="col">&nbsp;<%=rsAvisos.Fields.Item("Ser_FolioInterno").Value%></td>
    <td nowrap="nowrap" scope="col">Tipo de servicio&nbsp;</td>
    <td width="22%" scope="col">&nbsp;<%=rsAvisos.Fields.Item("TipoServicio").Value%></td>
    <td width="22%" scope="col"><a href="javascript:IrAOServicio(<%=Llaves%>)">Ir al servicio</a></td>
    </tr>
  <tr>
    <td width="5%" scope="col">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="4%" scope="col">Cliente</td>
    <td colspan="4" scope="col">&nbsp;<%=rsAvisos.Fields.Item("Cliente").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Almac&eacute;n </td>
    <td width="37%">&nbsp;<%=rsAvisos.Fields.Item("Almacen").Value%></td>
    <td width="10%" nowrap="nowrap">Fecha de carga</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("FechaCarga").Value%></td>    
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Veh&iacute;culo</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Vehiculo").Value%></td>
    <td>Fecha Registro</td>
    <td colspan="2">&nbsp;<%=rsAvisos.Fields.Item("FechaRegistro").Value%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap="nowrap">Operador&nbsp;&nbsp;</td>
    <td>&nbsp;<%=rsAvisos.Fields.Item("Operador").Value%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div>
<hr>

<% 
				
				 
				rsAvisos.MoveNext() 
			}
			rsAvisos.Close

    }  // fin del if PlantillaPantalla_ID == 7 

}  // fin del if TipoAlerta == 2 

%>   
    </div>
</div>

<script type="text/javascript">

function TomaPropiedadSobreLaTarea(ar,ae){
	
//	$.post( "/pz/agt/Inicio/Avisos_Ajax.asp"
//		  , { Tarea:1,Alr_ID:ar,AlrE_ID:ae,ID_Unica:$("#IDUsuario").val()}
//	);
	
}

function EscribeLlavesBasicas(A,E) {
 
	  $("#Alr_ID").val(A)
	  $("#AlrE_ID").val(E)  	
}

function ValidaFactura(A,E,c,p,f,v){
  EscribeLlavesBasicas(A,E)
  TomaPropiedadSobreLaTarea(A,E)
  InsertaE('Cli_ID',c)
  InsertaE('Deu_ID',p)
  InsertaE('Fac_ID',f)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
 
}

function ValidaContrarecibo(A,E,c,p,f,CR,v){
  EscribeLlavesBasicas(A,E)
  TomaPropiedadSobreLaTarea(A,E)
  InsertaE('Cli_ID',c)
  InsertaE('Deu_ID',p)
  InsertaE('Fac_ID',f)
  InsertaE('Ctr_ID',CR)    
  
  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
 
}

function CorregirFactura(A,E,c,p,f,v){
  EscribeLlavesBasicas(A,E)
  TomaPropiedadSobreLaTarea(A,E)
  InsertaE('Cli_ID',c)
  InsertaE('Deu_ID',p)
  InsertaE('Fac_ID',f) 

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
 
}

function IrAOServicio(a,s,v){

  InsertaE('Alr_ID',a)
  InsertaE('Ser_ID',s)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}

function IrAlServicio(a,s,v){

  InsertaE('Alr_ID',a)
  InsertaE('Ser_ID',s)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}

function VerOrdenCompra(a,p,o,v){

  InsertaE('Alr_ID',a)
  InsertaE('Prov_ID',p)
  InsertaE('OC_ID',o)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}

function VerOrdenVenta(a,o,c,v){

  InsertaE('Alr_ID',a)
  InsertaE('OV_ID',o)
  InsertaE('Cli_ID',c)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}


function VerDocumentos(a,p,v){

  InsertaE('Alr_ID',a)
  InsertaE('Prov_ID',p)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}

function ValidarBanco(a,p,v){

  InsertaE('Alr_ID',a)
  InsertaE('Prov_ID',p)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
  
}


function VerFactura(A,E,c,p,f,v){
  EscribeLlavesBasicas(A,E)
  TomaPropiedadSobreLaTarea(A,E)
  InsertaE('Cli_ID',c)
  InsertaE('Deu_ID',p)
  InsertaE('Fac_ID',f)

  if(v>0) CambiaVentana($("#SistemaActual").val(),v);
}

function InsertaE(nombre,valor){
	if ( $("#" + nombre).length > 0 ) {
		$("#" + nombre).val(valor)		
	} else {
		$("#frmDatos").append( "<input type='hidden' name='" + nombre + "' id='" + nombre + "' value='" + valor + "' />" ); 
	}
}

</script>