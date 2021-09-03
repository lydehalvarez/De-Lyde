<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

 	var Cli_ID = Parametro("Cli_ID",-1)	
    var CliOC_ID = Parametro("CliOC_ID",-1)	  
    var OC_ID = Parametro("OC_ID",-1)	  
 	var TA_ID = Parametro("TA_ID",-1)	
	var Veh_ID = Parametro("Veh_ID",-1)	
	var Ser_ID = Parametro("Ser_ID",-1)
	var Emp_ID = Parametro("Emp_ID",-1)
 	var Prov_ID = Parametro("Prov_ID",-1)
 	var OV_ID = Parametro("OV_ID",-1)
			
  var iRegistros = 0
	var Doc_ID  = Parametro("Doc_ID",-1)	
	var ServicioForaneo  = Parametro("Ser_ServicioForaneo",0)	
	var Docs_ID = Parametro("Docs_ID",-1)	
	var Cargado = Parametro("Cargado",-1)
	var Validado = 0	
	var PK = ""
	var PKValor = ""	
	var ArchivoJS = ""
	
	var NivelVentana = ParametroDeVentana(SistemaActual, VentanaIndex, "Nivel de documentos a mostrar", 0)	
	    //1 = documentos de Clientes
		//2 = documentos de Proveedores
		//3 = documentos de Transferencia
		//4 = documentos de ordenes de compra de clientes
        //5 = deocumentos de ordenes de compra de proveedores
        //6 = deocumentos de ordenes de compra en admin
				
	var Doc_EsParaEmitir   = ParametroDeVentana(SistemaActual, VentanaIndex, "Es para emitir", 0)
    
	var bIQon4Web = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, IDUsuario,"Debug en Documentos",0)==1
   
   	if(bIQon4Web) { Response.Write("NivelVentana:==>&nbsp;" + NivelVentana + "<br>") }


if (NivelVentana == 1 ) {	

	ArchivoJS = "/pz/wms/Documentos/DocumentosCliente.js"
	PK = "Cli_ID"
	PKValor = Cli_ID
	
    var sSQLDocs  = " SELECT DOC.Doc_ID, DOC.Doc_Nombre, ISNULL(Tb2.Cli_ID,-1) AS Cli_ID"
        sSQLDocs += " ,ISNULL(Tb2.Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " ,Docs_Validado "
        sSQLDocs += " ,Tb2.Docs_Nombre, Tb2.Docs_Titulo, Tb2.Docs_RutaArchivo , Tb2.Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Tb2.Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento DOC "
        sSQLDocs += " LEFT OUTER JOIN Cliente_Documentos Tb2 "
        sSQLDocs += " ON DOC.Doc_ID = Tb2.Doc_ID "
        sSQLDocs += " AND Tb2.Cli_ID = " + Cli_ID
        sSQLDocs += " WHERE  DOC.Doc_Habilitado = 1 "
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND DOC.Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
        sSQLDocs += " AND DOC.Doc_NivelCliente = 1 "
        sSQLDocs += " ORDER BY DOC.Doc_Orden "	
}


if (NivelVentana == 2 ) {

	ArchivoJS = "/pz/wms/Documentos/DocumentosProveedor.js"
	PK = "Prov_ID"
	PKValor = Prov_ID
	
    var sSQLDocs  = " SELECT DOC.Doc_ID, DOC.Doc_Nombre, ISNULL(Tb2.Prov_ID,-1) AS Prov_ID"
        sSQLDocs += " ,ISNULL(Tb2.Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " ,Docs_Validado"
        sSQLDocs += " ,Tb2.Docs_Nombre, Tb2.Docs_Titulo, Tb2.Docs_RutaArchivo , Tb2.Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Tb2.Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento DOC "
        sSQLDocs += " LEFT OUTER JOIN Proveedor_Documentos Tb2 "
        sSQLDocs += " ON DOC.Doc_ID = Tb2.Doc_ID "
        sSQLDocs += " AND Tb2.Prov_ID = " + Prov_ID
        sSQLDocs += " WHERE  DOC.Doc_Habilitado = 1 "
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND DOC.Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
        sSQLDocs += " AND DOC.Doc_NivelProveedor = 1 "
        sSQLDocs += " ORDER BY DOC.Doc_Orden "
			
}	
    
if (NivelVentana == 3 ) {

	ArchivoJS = "/pz/wms/Documentos/DocumentosTransferencia.js"
	PK = "TA_ID"
	PKValor = TA_ID
	
    var sSQLDocs  = " SELECT DOC.Doc_ID, DOC.Doc_Nombre"
        sSQLDocs += " ,ISNULL(Tb2.Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " ,Docs_Validado"

        sSQLDocs += " ,Tb2.Docs_Nombre, Tb2.Docs_Titulo, Tb2.Docs_RutaArchivo , Tb2.Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Tb2.Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento DOC "
        sSQLDocs += " LEFT OUTER JOIN TransferenciaAlmacen_Documentos Tb2 "
        sSQLDocs += " ON DOC.Doc_ID = Tb2.Doc_ID "

        sSQLDocs += " AND Tb2.TA_ID = " + TA_ID                      
        sSQLDocs += " WHERE  DOC.Doc_Habilitado = 1 "
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND DOC.Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
        sSQLDocs += " AND DOC.Doc_NivelServicio = 1 "
        sSQLDocs += " ORDER BY DOC.Doc_Orden "	
			
}	

if (NivelVentana == 4 ) {
    
	ArchivoJS = "/pz/wms/Documentos/DocumentosClienteOC.js"
	PK = "Cli_ID"
	PKValor = Cli_ID + "," +CliOC_ID

	
    var sSQLDocs  = " SELECT DOC.Doc_ID, DOC.Doc_Nombre"
        sSQLDocs += " ,ISNULL(Tb2.Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " ,Docs_Validado"	
        sSQLDocs += " ,Tb2.Docs_Nombre, Tb2.Docs_Titulo, Tb2.Docs_RutaArchivo , Tb2.Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Tb2.Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento DOC "
        sSQLDocs += " LEFT OUTER JOIN Cliente_OrdenCompra_Documento Tb2 "
        sSQLDocs += " ON DOC.Doc_ID = Tb2.Doc_ID "
        sSQLDocs += " AND Tb2.Cli_ID = " + Cli_ID 
        sSQLDocs += " AND Tb2.CliOC_ID = " + CliOC_ID                      
        sSQLDocs += " WHERE  DOC.Doc_Habilitado = 1 "
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND DOC.Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
        sSQLDocs += " AND DOC.Doc_NivelClienteOrdenCompra = 1 "
        sSQLDocs += " ORDER BY DOC.Doc_Orden "	
			
}	

if (NivelVentana == 5 ) {
    
	ArchivoJS = "/pz/wms/Documentos/DocumentosProveedorOC.js"
	PK = "Prov_ID"
	PKValor = Prov_ID + "," +OC_ID

	
    var sSQLDocs  = " SELECT DOC.Doc_ID, DOC.Doc_Nombre"
        sSQLDocs += " ,ISNULL(Tb2.Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " ,Docs_Validado"	
        sSQLDocs += " ,Tb2.Docs_Nombre, Tb2.Docs_Titulo, Tb2.Docs_RutaArchivo , Tb2.Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),Tb2.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Tb2.Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento DOC "
        sSQLDocs += " LEFT OUTER JOIN Proveedor_OrdenCompra_Documento Tb2 "
        sSQLDocs += " ON DOC.Doc_ID = Tb2.Doc_ID "
        sSQLDocs += " AND Tb2.Prov_ID = " + Prov_ID 
        sSQLDocs += " AND Tb2.OC_ID = " + OC_ID                      
        sSQLDocs += " WHERE  DOC.Doc_Habilitado = 1 "
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND DOC.Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
        sSQLDocs += " AND DOC.Doc_NivelServicio = 1 "
        sSQLDocs += " AND DOC.Doc_NivelProveedor = 1 "  
        sSQLDocs += " ORDER BY DOC.Doc_Orden "	
			
}	
    
    
if (NivelVentana == 6 ) {
    
	ArchivoJS = "/pz/wms/Documentos/DocumentosAdminOC.js"
	PK = "OV_ID"
	PKValor = OV_ID

    var sSQLDocs  = " SELECT d.Doc_ID, d.Doc_Nombre"
        sSQLDocs += " , ISNULL(Docs_ID,-1) AS Docs_ID "
        sSQLDocs += " , Docs_Validado " 	
        sSQLDocs += " , Docs_Nombre, Docs_Titulo, Docs_RutaArchivo , Docs_FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),ovd.Docs_FechaRegistro, 103)),'') as FechaRegistro "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),ovd.Docs_FechaRegistro, 108)),'') as HoraRegistro "	
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),ovd.Docs_FechaModificacion, 103)),'') as FechaModificacion "
        sSQLDocs += " , ISNULL((CONVERT(NVARCHAR(20),ovd.Docs_FechaModificacion, 108)),'') as HoraModificacion "		
        sSQLDocs += " , (CASE ISNULL(Docs_FechaRegistro,-1) WHEN -1 THEN 0 ELSE 1 END) AS Cargado "
        sSQLDocs += " FROM Cat_Documento d "
        sSQLDocs += " LEFT JOIN Orden_Venta_Documentos ovd "
        sSQLDocs += " ON d.Doc_ID = ovd.Doc_ID "
        sSQLDocs += " AND ovd.OV_ID = " + OV_ID                      
        sSQLDocs += " WHERE Doc_Habilitado = 1 "
    
        if (Doc_EsParaEmitir < 2) {   //0 = no, 1 = si, 2 = ambos
            sSQLDocs += " AND Doc_EsParaEmitir = " + Doc_EsParaEmitir 
        }
            
        sSQLDocs += " AND Doc_NivelOrdenVenta = 1 "
        sSQLDocs += " AND Doc_NivelCliente = 0 "  
        sSQLDocs += " AND Doc_NivelProveedor = 0 "     
        sSQLDocs += " ORDER BY Doc_Orden "	
			
}	


	if(bIQon4Web) { Response.Write(sSQLDocs) }

	var rsSQLDocs = AbreTabla(sSQLDocs,1,0)

%>
<div id="DocsGrid">
<div class="wrapper wrapper-content  animated fadeInRight">
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox">
				<div class="ibox-title">
                	<h5>Librer&iacute;a de documentos cargados</h5>
              	</div>
                <div class="ibox-content">
            <div class="table-responsive">
		<table class="table table-hover issue-tracker">
			<thead>
            	<tr role="row">
                    <th class="center" width="55">Estatus</th>
                    <th width="404" class="left">Tipo / T&iacute;tulo / Nombre</th>
                    <th width="179" class="center">Fecha de ingreso</th>
                    <th width="208" class="center">Fecha de modificaci&oacute;n</th>
                    <th class="center">&nbsp;</th>
                </tr>
            </thead>
            <tbody>
<%	

while (!rsSQLDocs.EOF){
		iRegistros++

		Doc_ID = rsSQLDocs.Fields.Item("Doc_ID").Value
		Docs_ID = rsSQLDocs.Fields.Item("Docs_ID").Value		
		Cargado = rsSQLDocs.Fields.Item("Cargado").Value
		Docs_Validado = rsSQLDocs.Fields.Item("Docs_Validado").Value	
		
		if(Validado == 0) {
			Validado = "No"
		}
		if(Validado == 1) {
			Validado = "Validado"
		}
		if(Validado == 2) {
			Validado = "Rechazado"
		}					

		var Llaves = PKValor + "," + Doc_ID + "," + Docs_ID + "," + Cargado
		var Llaves2 = "" + PKValor + "," + Doc_ID + ",-1,0" 
	
%>
      <tr>
        <td><% if ( Docs_Validado == 0) { %>
                <span class="label label-warning">Sin validar</span>
                <% }
                if ( Docs_Validado == 1) { %>
                <span class="label label-primary">Validado</span>
                <% }
                if ( Docs_Validado == 2) { %>
                <span class="label label-danger">Error</span>
                <% }  %>
        </td>
        <td class="issue-info">
        <h4><%=rsSQLDocs.Fields.Item("Doc_Nombre").Value%></h4>
        <strong><%=rsSQLDocs.Fields.Item("Docs_Titulo").Value%></strong>
        <small>
        <%=rsSQLDocs.Fields.Item("Docs_Nombre").Value%>
        </small>
        </td>
        <td align="center" nowrap="nowrap">
         <%=rsSQLDocs.Fields.Item("FechaRegistro").Value%><br />
         <small>
        	<%=rsSQLDocs.Fields.Item("HoraRegistro").Value%>
         </small>
        </td>
        <td align="center"  nowrap="nowrap">
         <%=rsSQLDocs.Fields.Item("FechaModificacion").Value%><br />
         <small>
        	<%=rsSQLDocs.Fields.Item("HoraModificacion").Value%>
         </small>         
        </td>
        <td width="70" class="center" >
                 <a class="btn btn-white btn-sm" data-original-title="Nuevo" 
                    data-placement="top" href="javascript:LlamaDocumento(<%=Llaves2%>)" 
                    title="Agregar un documento nuevo"
                    style="font-style: italic"><i class="fa fa-plus"></i> Nuevo</a>
 <% if ( Cargado > 0) { %>        
                 <a class="btn btn-white btn-sm"data-original-title="Seleccionar" data-placement="top" 
                    href="javascript:LlamaDocumento(<%=Llaves%>)"><i class="fa fa-folder"></i> Seleccionar</a>
 <% } %>    
        </td>   
      </tr>

<%
        	rsSQLDocs.MoveNext() 
		}
        rsSQLDocs.Close()   %>
        </tbody>
    </table>
                  </div>
              </div>
                </div>
            </div>
        </div>
    </div>   
</div>
<div id="dvCargaDeInformacion"></div>
<script type="text/javascript" src="<%=ArchivoJS%>"></script>

<% if( Doc_ID > 0 && Docs_ID > 0 && Cargado > 0 ) { %>

<script type="text/javascript">
      
	  
	  // LlamaDocumento(<%=Ser_ID%>,<%=Doc_ID%>,<%=Docs_ID%>,<%=Cargado%>)

</script>
<% } %>



