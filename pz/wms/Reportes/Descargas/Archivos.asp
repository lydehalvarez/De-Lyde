<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

    var RepD_ID = Parametro ("RepD_ID",-1)
    var iRegistros = 0
	
	var sSQL = " SELECT RepD_Nombre, RepD_Descripcion "
		sSQL += " FROM ReportesDescarga "
		sSQL += " WHERE RepD_ID = " + RepD_ID
 
	var rsReporte = AbreTabla(sSQL,1,0)

	if (!rsReporte.EOF){
	    RepD_Nombre = rsReporte.Fields.Item("RepD_Nombre").Value
    }
    rsReporte.Close()
   
%> 
    <div class="row">

    <div class="col-lg-12">
    <div class="ibox float-e-margins">
    <div class="ibox-title">
        <h5><%=RepD_Nombre%> </h5>
    </div>
    <div class="ibox-content">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Fecha de generaci&oacute;n </th>
                    <th>Nombre del archivo </th>
                    <th>Tama&ntilde;o</th>
                    <th>Liga para compartir</th>
                </tr>
                </thead>
                <tbody>
<%
	var sSQL = " SELECT RepD_ID, RepDA_ID, RepDA_Nombre, RepDA_Descripcion"
        sSQL += ", CONVERT(NVARCHAR, RepDA_FechaGeneracion,103) AS FECHA "
        sSQL += ", CONVERT(NVARCHAR, RepDA_FechaGeneracion,108) AS HORA "
        sSQL += ", RepDA_FechaVencimiento "
        sSQL += ", RepDA_Tamano "
		sSQL += " FROM ReportesDescarga_Archivo "
		sSQL += " WHERE RepD_ID = " + RepD_ID
        sSQL += " Order by RepDA_FechaGeneracion desc "
 
	var rsRepArchivo = AbreTabla(sSQL,1,0)

	while (!rsRepArchivo.EOF){
       iRegistros++
%>
                <tr>
                    <td><%=iRegistros%></td>
                    <td><%=rsRepArchivo.Fields.Item("FECHA").Value%>
                        <br><%=rsRepArchivo.Fields.Item("HORA").Value%>
                    </td>
                    <td><a href="/media/wms/Reportes/<%=rsRepArchivo.Fields.Item('RepDA_Nombre').Value%>" 
                           download="<%=rsRepArchivo.Fields.Item('RepDA_Nombre').Value%>"><%=rsRepArchivo.Fields.Item("RepDA_Nombre").Value%></a>
                        <br><small><%=rsRepArchivo.Fields.Item("RepDA_Descripcion").Value%></small>
                    </td>
                    <td nowrap="nowrap"><%=formato((rsRepArchivo.Fields.Item("RepDA_Tamano").Value/1024),2)%> MB</td>
                    <td>https://wms.lyde.com.mx/media/wms/Reportes/<%=rsRepArchivo.Fields.Item("RepDA_Nombre").Value%>
                    </td>
                </tr>
    
<%
      rsRepArchivo.MoveNext() 
     }
   rsRepArchivo.Close() 
%>  
                </tbody>
            </table>
        </div>

    </div>
    </div>
    </div>

    </div>

