<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Extración de datos por ID
    case 2: {

        var rqIntIORS_ID = Parametro("IORS_ID", -1)

        var jsonRespuesta = '{}'

        var sqlIORS = "EXEC [dbo].[SPR_Inventario_OrdenSurtido] "
              + "@Opcion = 1000 "
            + ", @IORS_ID = " + rqIntIORS_ID + " "

        var rsIORS = AbreTabla(sqlIORS, 1, cxnTipo)

        if( !(rsIORS.EOF) ){

            jsonRespuesta = '{'
                  + '"IORS_ID": "' + rsIORS("IORS_ID").Value + '"'
                + ', "IORS_Folio": "' + rsIORS("IORS_Folio").Value + '"'
                + ', "IORS_CantidadSolicitada": "' + rsIORS("IORS_CantidadSolicitada").Value + '"'
                + ', "IORS_Prioridad": "' + rsIORS("IORS_Prioridad").Value + '"'
                + ', "UBI_ID": "' + rsIORS("UBI_ID").Value + '"'
            + '}'

        }

        rsIORS.Close()

        Response.Write(jsonRespuesta)
            
    } break;
    
    //Modal de Edicion
    case 50: {
%>
        <div class="modal fade" id="modalOrdenSurtidoEdicion" tabindex="-1" role="dialog" aria-labelledby="divModalOrdenSurtidoEdicion" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2 class="modal-title" id="divModalOrdenSurtidoEdicion">
                            <i class="fa fa-file-text-o"></i> Orden de Surtido 
                            <br />
                            <small>Orden de Surtido</small>
                        </h2>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="inpIORS_ID" value="">

                        <div class="form-group row">
                            <div class="form-group col-md-12 row">
                                <label class="col-sm-2 control-label">Producto SKU:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpProductoSKU" class="form-control"
                                    placeholder="SKU Producto" autocomplete="off">
                                </div>
                                <label class="col-sm-2 control-label">Cantidad:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpCantidad" class="form-control"
                                    placeholder="Cantidad" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">   
                            <div class="form-group col-md-12 row">
                                <label class="col-sm-2 control-label">Ubicacion de Destino:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selUbicacionDestino" class="form-control">

                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">Prioridad:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="checkbox" id="chbPrioridad" value="1">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenSurtido.ModalEdicionCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="OrdenSurtido.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

<%
    } break;

    //Modal de Surtido de orden de Surtido
    case 55: {
%>
        <div class="modal fade" id="modalOrdenSurtidoSurtido" tabindex="-1" role="dialog" aria-labelledby="divModalOrdenSurtidoSurtido" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2 class="modal-title" id="divModalOrdenSurtidoSurtido">
                            <i class="fa fa-file-text-o"></i> Orden de Surtido 
                            <br />
                            <small>Seleccionar las series a surtir</small>
                        </h2>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="inpSurtirIORS_ID" value="">

                        <div class="form-group row">
                            <div class="form-group col-md-12 row">
                                <label class="col-sm-2 control-label">Serie:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpSurtidoSerie" class="form-control"
                                    placeholder="No. Serie" autocomplete="off">
                                </div>
                                <div class="col-sm-2 m-b-xs">
                                    <button type="button" class="btn btn-primary">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                                <label class="col-sm-2 control-label">Total Encontrado</label>    
                                <label class="col-sm-2 control-label" id="labelTotalEncontradoSerie"></label>
                            </div>
                        </div>

                        <div class="form-group row">   
                            <div class="form-group col-md-12 row">
                                <label> 
                                    <input type="radio" value="1" id="optSerie" 
                                     name="optSerieBuscar" onclick="Inventario.SeriesTotalBuscar();" > 
                                </label>
                                <label> 
                                    <input type="radio" value="2" id="optMX" 
                                     name="optSerieBuscar" onclick="Inventario.SeriesTotalBuscar();"> 
                                </label>
                                <label> 
                                    <input type="radio" value="3" id="optPallet" 
                                     name="optSerieBuscar" onclick="Inventario.SeriesTotalBuscar();"> 
                                </label>
                            </div>
                        </div>

                        <div class="form-group row">   
                            <div class="form-group col-md-12 col">
                                <label class="col-sm-12 control-label">Solicitado</label>    
                                <label class="col-sm-12 control-label text-primary" id="labelTotalSolicitado">0</label>
                            </div>
                            <div class="form-group col-md-12 col">
                                <label class="col-sm-12 control-label">Apartado</label>    
                                <label class="col-sm-12 control-label text-warning" id="labelTotalApartado">0</label>
                            </div>
                            <div class="form-group col-md-12 col">
                                <label class="col-sm-12 control-label">Faltante</label>    
                                <label class="col-sm-12 control-label text-success" id="labelTotalFaltante">0</label>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="form-group col-md-12 row">
                                <label class="col-sm-2 control-label">Serie:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpSerie" class="form-control"
                                    placeholder="No. Serie" autocomplete="off">
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenSurtido.ModalEdicionCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="OrdenSurtido.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

<%
    } break;

    //Opciones de Cliente
    case 100: {

        var sqlCli = "EXEC SPR_Cliente "
            + "@Opcion = 1000 "
        
        var rsCli = AbreTabla(sqlCli, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsCli.EOF)){
%>
            <option value="<%= rsCli("Cli_ID").Value %>">
                <%= rsCli("Cli_Nombre").Value %>
            </option>
<%
            rsCli.MoveNext()
        }
        rsCli.Close()
        
    } break;

    //Opcion Ubicacion
    case 200: {

        var sqlUbi = "EXEC SPR_Ubicacion "
            + "@Opcion = 1000 "
        
        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbi.EOF) ){
%>
            <option value="<%= rsUbi("Ubi_ID").Value %>">
                <%= rsUbi("Ubi_Nombre").Value %>
            </option> 
<%            
            rsUbi.MoveNext()
        }

        rsUbi.Close();

    } break;

     //Opcion Estatus
    case 900: {

        var rqIntSec_ID = Parametro("Sec_ID", -1)

        var sqlUbi = "EXEC SPR_Cat_Catalogo "
              + "@Opcion = 1000 "
            + ", @SEC_ID = " + ((rqIntSec_ID > -1) ? rqIntSec_ID : "NULL" ) + " "
        
        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbi.EOF) ){
%>
            <option value="<%= rsUbi("Cat_ID").Value %>">
                <%= rsUbi("Cat_Nombre").Value %>
            </option>
<%            
            rsUbi.MoveNext()
        }

        rsUbi.Close();

    } break;


    // Listado de Ordenes de Surtido
    case 1000: {
        
        var rqIntCli_ID = Parametro("Cli_ID" , -1)
        var rqStrPro_SKU = Parametro("Pro_SKU", "")
        var rqStrUbi_ID = Parametro("Ubi_ID", -1)
        var rqStrEst_ID = Parametro("Est_ID", -1)

        var sqlOrdSur = "EXEC SPR_Inventario_OrdenSurtido "
              + "@Opcion = 1000 "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID: "NULL") + " "
            + ", @Pro_SKU = " + ( (rqStrPro_SKU != "") ? + "'" + rqStrPro_SKU + "'" : "NULL") + " "
            + ", @Ubi_ID = " + ( (rqStrUbi_ID > -1) ? rqStrUbi_ID : "NULL" ) + " "
            + ", @Est_ID = " + ( (rqStrEst_ID > -1) ? rqStrEst_ID : "NULL" ) + " "

        var rsOrdSur = AbreTabla(sqlOrdSur, 1, cxnTipo)
%>
    <table class="table table-striped">
        <thead>
            <tr>
                <th class="col-sm-1">
                    <input type="checkbox" id="chbSeleccionarTodos" onclick="OrdenSurtidoCorte.Seleccionar();">
                </th>
                <th class="col-sm-1">Estatus</th>
                <th class="col-sm-2">Folio</th>
                <th class="col-sm-3">Ubicaci&oacuten Destino</th>
                <th class="col-sm-1">Cliente</th>
                <th class="col-sm-1">Cant. Solicitada</th>
                <th class="col-sm-1">Cant. Surtida</th>
                <th class="col-sm-2"></th>
            </tr>
        </thead>
        <tbody>
<%
        while( !(rsOrdSur.EOF) ){
%>
            <tr>
                <td class="col-sm-1">
<%
    if( parseInt(rsOrdSur("IORS_EstatusCG80").Value) == 1 ){
%>                
                    <input type="checkbox" class="clsOrdenSurtido" value="<%= rsOrdSur("IORS_ID").Value %>" >
<%
    }
%>                    
                </td>
                <td class="col-sm-1"><%= rsOrdSur("CAT_Nombre").Value %></td>
                <td class="col-sm-2"><%= rsOrdSur("IORS_Folio").Value %></td>
                <td class="col-sm-3 issue-info">
                    <a href="#">
<%
    if( parseInt(rsOrdSur("IORS_Prioridad").Value) == 1 ){
%>
                        <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%>                        
                        <%= rsOrdSur("Ubi_Nombre").Value %>
                    </a>
                    <small>
                        <strong><%= rsOrdSur("Pro_SKU").Value %></strong> - <%= rsOrdSur("Pro_Nombre").Value %>
                    </small>
                </td>
                <td class="col-sm-1"><%= rsOrdSur("Cli_Nombre").Value %></td>
                <td class="col-sm-1"><%= rsOrdSur("IORS_CantidadSolicitada").Value %></td>
                <td class="col-sm-1"><%= rsOrdSur("IORS_CantidadEntregada").Value %></td>
                <td class="col-sm-2 text-nowrap">
<%
    if( parseInt(rsOrdSur("IORS_EstatusCG80").Value) == 2 || parseInt(rsOrdSur("IORS_EstatusCG80").Value) == 3 ){
%>                 
                    <a class="btn btn-white btn-sm" title="Ver Series" style="cursor: pointer;" onclick='RecepcionSeries.ListadoCargar(<%= rsOrdSur("Ubi_ID").Value %>);'>
                        <i class="fa fa-file-text-o"></i>
                    </a>
<%
    }
    if( parseInt(rsOrdSur("IORS_EstatusCG80").Value) == 1 ){
%>                    
                    <a class="btn btn-white btn-sm" title="Editar" style="cursor: pointer;" onclick='OrdenSurtido.Editar(<%= rsOrdSur("IORS_ID").Value %>);'>
                        <i class="fa fa-pencil-square-o"></i>
                    </a>
<%
    }
%>
                </td>
            </tr>
<%          
            rsOrdSur.MoveNext()
        }

        rsOrdSur.Close()
%>
        </tbody>
    </table>
<%
    } break;

     // Listado de Ordenes de Surtido
    case 1001: {
        
        var sqlOrdSur = "EXEC SPR_Inventario_OrdenSurtido "
              + "@Opcion = 1000 "

        var rsOrdSur = AbreTabla(sqlOrdSur, 1, cxnTipo)
%>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Estatus</th>
                <th>Folio</th>
                <th>Ubicacion</th>
                <th>Cliente</th>
                <th>Cantidad Solicitada</th>
                <th>Cantidad Entregada</th>
            </tr>
        </thead>
        <tbody>
<%
        while( !(rsOrdSur.EOF) ){
%>
            <tr>
                <td><%= rsOrdSur("CAT_Nombre").Value %></td>
                <td><%= rsOrdSur("IORS_Folio").Value %></td>
                <td class="project-title">
                    <a href="#">
<%
    if( parseInt(rsOrdSur("IORS_Prioridad").Value) == 1 ){
%>
                        <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%> 
                        <%= rsOrdSur("Ubi_Nombre").Value %>
                    </a>
                    <small>
                        <strong><%= rsOrdSur("Pro_SKU").Value %><strong> - <%= rsOrdSur("Pro_Nombre").Value %>
                    </small>
                </td>
                <td><%= rsOrdSur("Cli_Nombre").Value %></td>
                <td><%= rsOrdSur("IORS_CantidadSolicitada").Value %></td>
                <td><%= rsOrdSur("IORS_CantidadEntregada").Value %></td>
            </tr>
<%          
            rsOrdSur.MoveNext()
        }

        rsOrdSur.Close()
%>
        </tbody>
    </table>
<%
    } break;

    // Listado de Ordenes de Surtido
    case 1501: {
        
        var sqlOrdSur = "EXEC SPR_Inventario_OrdenSurtidoCorte "
              + "@Opcion = 1000 "

        var rsOrdSur = AbreTabla(sqlOrdSur, 1, cxnTipo)
%>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Estatus</th>
                <th>Folio</th>
                <th>Ubicacion</th>
                <th>Cliente</th>
                <th>Cantidad Solicitada</th>
                <th>Cantidad Entregada</th>
            </tr>
        </thead>
        <tbody>
<%
        while( !(rsOrdSur.EOF) ){
%>
            <tr>
                <td><%= rsOrdSur("CAT_Nombre").Value %></td>
                <td><%= rsOrdSur("IORS_Folio").Value %></td>
                <td class="project-title">
                    <a href="#">
<%
    if( parseInt(rsOrdSur("IORS_Prioridad").Value) == 1 ){
%>
                        <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%> 
                        <%= rsOrdSur("Ubi_Nombre").Value %>
                    </a>
                    <small>
                        <strong><%= rsOrdSur("Pro_SKU").Value %><strong> - <%= rsOrdSur("Pro_Nombre").Value %>
                    </small>
                </td>
                <td><%= rsOrdSur("Cli_Nombre").Value %></td>
                <td><%= rsOrdSur("IORS_CantidadSolicitada").Value %></td>
                <td><%= rsOrdSur("IORS_CantidadEntregada").Value %></td>
            </tr>
<%          
            rsOrdSur.MoveNext()
        }

        rsOrdSur.Close()
%>
        </tbody>
    </table>
<%
    } break;

    //Guardado de Orden de Surtido
    case 2000: {

        var rqIntIORS_ID = Parametro("IORS_ID", -1)
        var rqStrProductoSKU = Parametro("ProductoSKU", "")
        var rqIntCantidad = Parametro("Cantidad", 0)
        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPrioridad = Parametro("Prioridad", 0)
        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlIORS = "EXEC SPR_Inventario_OrdenSurtido "
              + "@Opcion = " + ( ( parseInt(rqIntIORS_ID) > -1) ? 3000 : 2000 ) + " "
            + ", @IORS_ID = " + rqIntIORS_ID + " "
            + ", @Pro_SKU = '" + rqStrProductoSKU + "' "
            + ", @Ubi_ID = " + rqIntUbi_ID + " "
            + ", @IORS_CantidadSolicitada = " + rqIntCantidad +  " "
            + ", @IORS_Prioridad = " + rqIntPrioridad + " "
            + ", @IORS_IdUsuario = " + rqIntIDUsuario + " "
            + ", @Est_ID = 1 "

        var rsIORS = AbreTabla(sqlIORS, 1, cxnTipo)

        if( !(rsIORS.EOF) ){
            intErrorNumero = rsIORS("ErrorNumero").Value;
            strErrorDescripcion = rsIORS("ErrorDescripcion").Value;
        }

        rsIORS.Close()

        if( intErrorNumero == 0){
            strErrorDescripcion = "Se guardo la Orden de surtido"
        }

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Cracion de Corte de Resurtido
    case 2100: {

        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        var rqStrIORS_IDs = Parametro("IORS_IDs", "")

        var arrIORS_IDs = rqStrIORS_IDs.split(",");
        var intCantidad = arrIORS_IDs.length

        var intIOSC_ID = 0

        var intErrorNumero = 0
        var strErrorDescripcion = 0

        var strOrdSurEnProceso = ""
        var jsonRespuesta = "{}"

        var sqlOrdSurCte = "EXEC SPR_Inventario_OrdenSurtidoCorte "
                  + "@Opcion = 2000 /*Insercion*/ "
                + ", @IOSC_IDUsuario = " + rqIntIDUsuario + " "
                + ", @IOSC_CantidadOrdenesSurtir = " + intCantidad + " "

        var rsORdSurCte = AbreTabla(sqlOrdSurCte, 1, cxnTipo)

        if( !(rsORdSurCte.EOF) ){

            intIOSC_ID = rsORdSurCte("IOSC_ID").Value
            strErrorDescripcion = rsORdSurCte("ErrorDescripcion").Value
            intErrorNumero = rsORdSurCte("ErrorNumero").Value

        }

        rsORdSurCte.Close()

        //Validacion de Cambio de Creacion de corte
        if( parseInt(intErrorNumero) == 0 ){

            //Actualización de Estatus de la Orden de Surtido y asignacion de corte
            for(var i = 0; i < intCantidad; i++){

                var sqlOrdSur = "EXEC SPR_Inventario_OrdenSurtido "
                    + "  @Opcion = 3000 "
                    + ", @IORS_ID = " + arrIORS_IDs[i] + " "
                    + ", @IOSC_ID = " + intIOSC_ID + " "
                    + ", @Est_ID = 2 /* En Proceso */ "

                var rsOrdSur = AbreTabla(sqlOrdSur, 1, cxnTipo)

                if( !(rsOrdSur.EOF) ){
                    strErrorDescripcion = rsOrdSur("ErrorDescripcion").Value
                    intErrorNumero = rsOrdSur("ErrorNumero").Value
                }
                
                rsOrdSur.Close()                
            }
        }

        //Extración de informacion de los Ordenes de Surtido "En Proceso"
        if( parseInt(intErrorNumero) == 0 ){

            var sqlOrdSurSel = "EXEC SPR_Inventario_OrdenSurtido "
                + "  @Opcion = 1000 "
                + ", @IOSC_ID = " + intIOSC_ID + " "

            var rsOrdSurSel = AbreTabla(sqlOrdSurSel, 1, cxnTipo)

            var j = 0;

            while( !(rsOrdSurSel.EOF) ){
                j++;

                strOrdSurEnProceso += rsOrdSurSel("IORS_Folio").Value + "<br>"

                rsOrdSurSel.MoveNext()
            }
            rsOrdSurSel.Close()

            strErrorDescripcion = "Folios En Proceso de Surtir: <br> " + strOrdSurEnProceso
        }

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
}
%>