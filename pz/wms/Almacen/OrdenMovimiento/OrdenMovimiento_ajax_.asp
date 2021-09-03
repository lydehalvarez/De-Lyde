<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Orden Movimiento: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Extraer Registros
    case 10: {

        rqIntIOM_ID = Parametro("IOM_ID", -1)

        var sqlExtID = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 1000 "
            + ", @IOM_ID = " + ( (rqIntIOM_ID > -1) ? rqIntIOM_ID : "NULL" ) + "  "
        
        var rsExtID = AbreTabla(sqlExtID, 1, cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsExtID, JSON.Tipo.RecordSet)

        rsExtID.close()

        Response.Write(jsonRespuesta)

    } break;

    //Modal de Nuevo y Edicion - Por Estatus
    case 600: {
%>
        <div class="modal fade" id="mdlIOMPorEstEdicion" tabindex="-1" role="dialog" aria-labelledby="divMdlIOMPorEstEdicion" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                         onclick="OrdenMovimientoPorEstatus.EdicionModalCerrar();"> 
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divMdlIOMPorEstEdicion">
                            <i class="fa fa-file-text-o"></i> Orden de Movimiento - Por Estatus
                            <br />
                            <small>Orden de Movimiento que cambia el estatus del Articulo</small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="hidMdlIOMPorEstIOM_ID" value="">
                        <div class="form-group row">
                            
                            <label class="col-sm-2 control-label">Estatus Articulo:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <select id="selMdlIOMPorEstEstatusArticulo" class="form-control">

                                </select>
                            </div>
                            <label class="col-sm-6 control-label">
                                <input type="checkbox" id="chbMdlIOMPorEstPrioridad" value="1"> Prioridad
                            </label>   
                        
                        </div>

                        <div class="form-group row">
                        
                            <label class="col-sm-2 control-label">Cliente:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="hidden" id="hidMdlIOMPorEstCli_ID" value=""> 
                                <label id="lblMdlIOMPorEstCli_Nombre" class="label-form-control">

                                </label>
                            </div>

                            <label class="col-sm-2 control-label">Producto:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="hidden" id="hidMdlIOMPorEstPro_ID" value=""> 
                                <label id="lblMdlIOMPorEstPro_Nombre" class="label-form-control">

                                </label>
                            </div>
                            
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-3 control-label">
                                    Tipo de Seleccion:
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="radMdlIOMPorEstTipoSelecionSerie" value="1"> Serie
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="radMdlIOMPorEstTipoSelecionSerie" value="2"> MasterBox
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="radMdlIOMPorEstTipoSelecionSerie" value="3"> Pallet
                                </label>
                                
                            
                        </div>
                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">No. Serie:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpMdlIOMPorEstSerie" class="form-control"
                                    placeholder="No. Serie" autocomplete="off" maxlength="30" onkeyUp="return false;">
                                </div>
                                <div class="form-group col-md-6 row"> 
                                    <button type="button" class="btn btn-primary btn-seg" onclick="OrdenMovimientoPorEstatus.SerieUbicacionListadoCargar()">
                                        <i class="fa fa-search"></i> Buscar
                                    </button>
                                </div>
                            
                        </div>
                        <div class="form-group col-md-12 row">
                            <div class="col-md-6 row">
                                <div id="divMdlIOMPorEstSeriesUbicacionSeleccion">

                                </div>
                            </div>
                            <div class="form-group col-md-2 row">
                            </div>
                            <div class="col-md-6 row">
                                <div id="divMdlIOMPorEstSeriesMovimientoSeleccion">

                                </div>
                            </div>
                            
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenMovimientoPorEstatus.EdicionModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="OrdenMovimientoPorEstatus.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;

    // modal Orden Movimiento de Termino - por Estatus
    case 610: {
 %>
        <div class="modal fade" id="modalOrdenMovimientoTerminar" tabindex="-1" role="dialog" aria-labelledby="divModalOrdenMovimientoTerminar" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                         onclick="OrdenMovimientoPorEstatus.TerminarModalCerrar();"> 
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divModalOrdenMovimientoTerminar">
                            <i class="fa fa-file-text-o"></i> Orden de Movimiento 
                            <br />
                            <small>Orden de Movimiento Terminar Surtido</small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="hidIOM_ID" value="">
                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">Articulo:</label>    
                                <label class="col-sm-4 control-label" id="modalOrdenMovimientoArticulo">

                                </label>    
                                <label class="col-sm-2 control-label">Cant. Sol.:</label>    
                                <label class="col-sm-4 control-label" id="modalOrdenMovimientoCantidadSolicitada">
                                    
                                </label> 
                            
                        </div>

                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">Cantidad Surtida:</label>    
                                <div class="col-sm-4 m-b-xs">
                                   <label id="labelCli_Nombre" class="label-form-control">


                                    </label>
                                </div>

                                <label class="col-sm-2 control-label">Producto:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpSerie" class="form-control"
                                     placeholder="No. Serie" autocomplete="off" maxlength="30">
                                </div>
                                
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-3 control-label">
                                    Tipo de Seleccion:
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="TipoSelecionSerie" value="1"> Serie
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="TipoSelecionSerie" value="2"> MasterBox
                                </label>
                                <label class="col-sm-3 control-label">
                                    <input type="radio" name="TipoSelecionSerie" value="3"> Pallet
                                </label>
                                
                            
                        </div>
                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">No. Serie:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpSerie" class="form-control"
                                    placeholder="No. Serie" autocomplete="off" maxlength="30" onkeyUp="return false;">
                                </div>
                                <div class="form-group col-md-6 row"> 
                                    <button type="button" class="btn btn-primary btn-seg" onclick="OrdenMovimientoPorEstatus.SerieUbicacionListadoCargar()">
                                        <i class="fa fa-search"></i> Buscar
                                    </button>
                                </div>
                            
                        </div>
                        <div class="form-group col-md-12 row">
                            <div class="col-md-6 row">
                                <div id="divSeriesUbicacionSeleccion">

                                </div>
                            </div>
                            <div class="form-group col-md-2 row">
                            </div>
                            <div class="col-md-6 row" id="divSeriesMovimientoSeleccion">
                                <div id="divSeriesMovimientoSeleccion">

                                </div>
                            </div>
                            
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenMovimientoPorEstatus.EdicionModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="OrdenMovimientoPorEstatus.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%       
    } break;

    //Listado Ordenes de Movimiento - Panel
    case 1000: {

        var sqlPanLis = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 1000 /* Busqueda por Tipo */ "
            + ", @IOM_Est_IDs = '2,3,4,5'"

        var rsPanLis = AbreTabla(sqlPanLis, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th></th>
                        <th class="col-sm-1">Estatus</th>
                        <th class="col-sm-2">Folio</th>
                        <th class="col-sm-2">Tipo Orden</th>
                        <th class="col-sm-2">Cliente</th>
                        <th class="col-sm-3">Ubicacion</th>
                        <th class="col-sm-1" title="Cantidad Solicitada">Cant. Sol.</th>
                        <th class="col-sm-1" title="Cantidad Entregada">Cant. Ent.</th>
                    </tr>
                </thead>
                <tbody>
<%
        while( !(rsPanLis.EOF)){
%>
                    <tr>
                        <td>
<%
    if( parseInt(rsPanLis("IOM_Prioridad").Value) == 1 ){
%>
                            <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%>
                        </td>
                        <td class="col-sm-1 text-nowrap">
<%                        
    var strEstatusColor = ""

    switch( parseInt(rsPanLis("IOM_EstatusCG80").Value) ){
        //Nueva
        case 1:	{ strEstatusColor = "label-outline-danger" } break;

        //Pendiente
        case 2:	{ strEstatusColor = "label-warning" } break;

        //En Proceso
        case 3: { strEstatusColor = "label-success" } break;

        //Surtida
        case 4:	{ strEstatusColor = "label-primary" } break;

        //Cancelada
        case 5:	{ strEstatusColor = "label-danger" } break;
    }
%> 
                            <i class="fa fa-clock-o" title="<%= rsPanLis("IOMH_FechaRegistro").Value %>"></i> 
                            <span class="label <%= strEstatusColor %>">
                                <%= rsPanLis("EST_Nombre").Value %>
                            </span>
                        </td>
                        
                        <td class="col-sm-2 text-nowrap"><%= rsPanLis("IOM_Folio").Value %></td>
                        <td class="col-sm-2 text-nowrap"><%= rsPanLis("TOM_Nombre").Value %></td>
                        <td class="col-sm-2"><%= rsPanLis("Cli_Nombre").Value %></td>
                        <td class="issue-info col-sm-3">
                            <a href="#">
                                <%= rsPanLis("Ubi_Nombre").Value %>
                            </a>
                            <small>
                                <strong><%= rsPanLis("Pro_SKU").Value %></strong> - <%= rsPanLis("Pro_Nombre").Value %>
                            </small>
                        </td>
                        
                        <td class="col-sm-1"><%= rsPanLis("IOM_CantidadSolicitada").Value %></td>
                        <td class="col-sm-1"><%= rsPanLis("IOM_CantidadEntregada").Value %></td>
                    </tr>
            
<%
            rsPanLis.MoveNext()
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
        rsPanLis.Close()

    } break;

    //Listado de Ordenes de Movimiento - por Estatus
    case 1002: {

        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntEst_ID = Parametro("Est_ID", -1)
        var rqStrPro_SKU = Parametro("Pro_SKU", "")
        var rqIntUbi_ID_Destino = Parametro("Ubi_ID_Destino", -1)

        var sqlPorEstLis = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 1000 /* Busqueda */ "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL") +  " "
            + ", @Ubi_ID_Destino = " + ( (rqIntUbi_ID_Destino > -1) ? rqIntUbi_ID_Destino : "NULL") +  " "
            + ", @Pro_SKU = " + ( (rqStrPro_SKU.length > 0) ? "'" + rqStrPro_SKU + "'" : "NULL") + " "
            + ", @IOM_EST_IDs = " + ( (rqIntEst_ID > -1) ? + "'" + rqIntEst_ID + "'" : "NULL") + " "
            + ", @IOM_TipoCG86 = 2 /* Por Estatus */ "

        var rsPorEstLis = AbreTabla(sqlPorEstLis, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="chbSeleccionarTodos" onclick="OrdenMovimientoCorte.Seleccionar();">
                        </th>
                        <th></th>
                        <th class="col-sm-1">Estatus</th>
                        <th class="col-sm-1">Folio</th>
                        <th class="col-sm-3">Ubicacion</th>
                        <th class="col-sm-1">Cliente</th>
                        <th class="col-sm-1" title="Cantidad Solicitada">Cant. Sol.</th>
                        <th class="col-sm-1" title="Cantidad Entregada">Cant. Ent.</th>
                        <th class="col-sm-2"></th>
                    </tr>
                </thead>
                <tbody>
<%
        while( !(rsPorEstLis.EOF)){
%>
                    <tr>
                        <td>
<%
    // 1: Nuevo
    if( parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 2 ){
%>
    
                            <input type="checkbox" class="clsOrdenMovimiento" id="chbIOMID_<%= rsPorEstLis("IOM_ID").Value %>" value="<%= rsPorEstLis("IOM_ID").Value %>" >
<%
    }                        
%>
                        </td>
                        <td>
<%
    if( parseInt(rsPorEstLis("IOM_Prioridad").Value) == 1 ){
%>
                            <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%>
                        </td>
                        <td class="issue-info col-sm-1 text-nowrap">
<%                        
    var strEstatusColor = ""

    switch( parseInt(rsPorEstLis("IOM_EstatusCG80").Value) ){
        //Nueva
        case 1:	{ strEstatusColor = "label-outline-danger" } break;

        //Pendiente
        case 2:	{ strEstatusColor = "label-warning" } break;

        //En Proceso
        case 3: { strEstatusColor = "label-success" } break;

        //Surtida
        case 4:	{ strEstatusColor = "label-primary" } break;

        //Cancelada
        case 5:	{ strEstatusColor = "label-danger" } break;
    }
%> 
                            <i class="fa fa-clock-o" title="<%= rsPorEstLis("IOMH_FechaRegistro").Value %>"></i> 
                            <span class="label <%= strEstatusColor %>">
                                <%= rsPorEstLis("EST_Nombre").Value %>
                            </span>
                        </td>
                        <td class="col-sm-1 text-nowrap"><%= rsPorEstLis("IOM_Folio").Value %></td>
                        <td class="issue-info col-sm-1">
                            <a href="#">
                                <%= rsPorEstLis("Ubi_Nombre").Value %>
                            </a>
                            <small>
                                <strong><%= rsPorEstLis("Pro_SKU").Value %></strong> - <%= rsPorEstLis("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td class="col-sm-1"><%= rsPorEstLis("Cli_Nombre").Value %></td>
                        <td class="col-sm-1"><%= rsPorEstLis("IOM_CantidadSolicitada").Value %></td>
                        <td class="col-sm-1"><%= rsPorEstLis("IOM_CantidadEntregada").Value %></td>
                        <td class="text-nowrap col-sm-2">
<%
    // 1: Nuevo
    if( parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 1 ){
%>
                            <a class="btn btn-danger btn-sm" title="Eliminar" style="cursor: pointer;" onclick='OrdenMovimientoPorEstatus.Eliminar({IOM_ID: <%= rsPorEstLis("IOM_ID").Value %>});'>
                                <i class="fa fa-trash-o"></i>
                            </a>
<%
    }

    // 1: Nuevo, 2: Pendiente
    if( parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 1 || parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 2 ){
%>
                            <a class="btn btn-info btn-sm" title="Editar" style="cursor: pointer;" onclick='OrdenMovimientoPorEstatus.Editar({IOM_ID: <%= rsPorEstLis("IOM_ID").Value %>});'>
                                <i class="fa fa-pencil-square-o"></i>
                            </a>
<%
    }

    // 3: En proceso, 4: Terminado
    if( parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 3 || parseInt(rsPorEstLis("IOM_EstatusCG80").Value) == 4 ){
%>                 
                            <a class="btn btn-white btn-sm" title="Ver Series" style="cursor: pointer;" onclick='Inventario.SeriesListadoUbicacionCargar(<%= rsPorEstLis("LOT_ID").Value %>);'>
                                <i class="fa fa-file-text-o"></i>
                            </a>
<%
    }
%>
                        </td>
                    </tr>
            
<%
            rsPorEstLis.MoveNext()
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
        rsPorEstLis.Close()

    } break;

    //Insertar Orden de Movimiento
    case 2000:{

        rqIntIOM_ID = Parametro("IOM_ID", -1)
        rqIntCli_ID = Parametro("Cli_ID", -1)
        rqIntPro_ID = Parametro("Pro_ID", -1)
        rqIntCantidadSolicitada = Parametro("CantidadSolicitada", -1)
        rqIntEstatusCG20 = Parametro("EstatusArticulo", -1)
        rqIntTipoCG86 = Parametro("Tipo", -1)
        rqIntPrioridad = Parametro("Prioridad", -1)
        rqIntUbi_ID_Destino = Parametro("UBI_ID_Destino", -1)
        rqIDUsuario = Parametro("IDUsuario", -1)
        rqIntEstatus = Parametro("Estatus", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = "Se guardo la Orden de Movimiento"

        var intIOM_ID = -1

        var jsonRespuesta  = '{}'

        var sqlInsIOM = "EXEC SPR_Inventario_OrdenMovimiento "
	          + "@Opcion = " + (( rqIntIOM_ID > -1 ) ? 3000 : 2000) + " "
            + ", @IOM_ID = " + (( rqIntIOM_ID > -1 ) ? rqIntIOM_ID : "NULL")  + " "
            + ", @Cli_ID = " + (( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL")  + " "
            + ", @Pro_ID = " + (( rqIntPro_ID > -1 ) ? rqIntPro_ID : "NULL")  + " "
            + ", @IOM_CantidadSolicitada = " + ((rqIntCantidadSolicitada > 0) ? rqIntCantidadSolicitada : "NULL") +  " "
            + ", @INV_EstatusCG20 = " + ((rqIntEstatusCG20 > -1) ? rqIntEstatusCG20 : "NULL" ) + " "
            + ", @IOM_TipoCG86 = " + ((rqIntTipoCG86 > -1) ? rqIntTipoCG86 : "NULL" ) + " "
            + ", @IOM_Prioridad = " + ((rqIntPrioridad > -1) ? rqIntPrioridad : "NULL" ) + " "
            + ", @UBI_ID_Destino = " + ((rqIntUbi_ID_Destino > -1) ? rqIntUbi_ID_Destino : "NULL" ) +  " "
            + ", @IOM_IDUsuario = " + ((rqIDUsuario > -1) ? rqIDUsuario : "NULL" ) +  " "
            + ", @IOM_EstatusCG80 = " + ((rqIntEstatus > -1) ? rqIntEstatus : "NULL" ) +  " "

       // Response.Write(sqlInsIOM)
        
        var rsInsIOM = AbreTabla(sqlInsIOM, 1, cxnTipo)

        if ( !(rsInsIOM.EOF) ){
            intErrorNumero = rsInsIOM("ErrorNumero").Value
            strErrorDescripcion = rsInsIOM("ErrorDescripcion").Value
            intIOM_ID = rsInsIOM("IOM_ID").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se guardo la Orden de Movimiento"
        }

        rsInsIOM.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      +'"Numero": "' + intErrorNumero + '"'
                    +', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "OrdenMovimiento": {'
                    +'"IOM_ID": "' + intIOM_ID + '" '
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Actualizar Orden de Movimiento
    case 3000:{

        rqIntIOM_ID = Parametro("IOM_ID", -1)
        rqIntCli_ID = Parametro("Cli_ID", -1)
        rqIntPro_ID = Parametro("Pro_ID", -1)
        rqIntCantidadSolicitada = Parametro("CantidadSolicitada", -1)
        rqIntEstatusCG20 = Parametro("EstatusArticulo", -1)
        rqIntTipoCG86 = Parametro("Tipo", -1)
        rqIntPrioridad = Parametro("Prioridad", -1)
        rqIntUbi_ID_Destino = Parametro("UBI_ID_Destino", -1)
        rqIDUsuario = Parametro("IDUsuario", -1)
        rqIntEstatus = Parametro("Estatus", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = "Se guardo la Orden de Movimiento"

        var intIOM_ID = -1

        var jsonRespuesta  = '{}'

        var sqlInsIOM = "EXEC SPR_Inventario_OrdenMovimiento "
	          + "@Opcion = 3000 "
            + ", @IOM_ID = " + (( rqIntIOM_ID > -1 ) ? rqIntIOM_ID : "NULL") + " "
            + ", @Cli_ID = " + (( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL") + " "
            + ", @Pro_ID = " + (( rqIntPro_ID > -1 ) ? rqIntPro_ID : "NULL") + " "
            + ", @IOM_CantidadSolicitada = " + ((rqIntCantidadSolicitada > 0) ? rqIntCantidadSolicitada : "NULL") + " "
            + ", @INV_EstatusCG20 = " + ((rqIntEstatusCG20 > -1) ? rqIntEstatusCG20 : "NULL" ) + " "
            + ", @IOM_TipoCG86 = " + ((rqIntTipoCG86 > -1) ? rqIntTipoCG86 : "NULL" ) + " "
            + ", @IOM_Prioridad = " + ((rqIntPrioridad > -1) ? rqIntPrioridad : "NULL" ) + " "
            + ", @UBI_ID_Destino = " + ((rqIntUbi_ID_Destino > -1) ? rqIntUbi_ID_Destino : "NULL" ) + " "
            + ", @IOM_IDUsuario = " + ((rqIDUsuario > -1) ? rqIDUsuario : "NULL" ) + " "
            + ", @IOM_EstatusCG80 = " + ((rqIntEstatus > -1) ? rqIntEstatus : "NULL" ) + " "
        
        var rsInsIOM = AbreTabla(sqlInsIOM, 1, cxnTipo)

        if ( !(rsInsIOM.EOF) ){
            intErrorNumero = rsInsIOM("ErrorNumero").Value
            strErrorDescripcion = rsInsIOM("ErrorDescripcion").Value
            intIOM_ID = rsInsIOM("IOM_ID").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se guardo la Orden de Movimiento"
        }

        rsInsIOM.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      +'"Numero": "' + intErrorNumero + '"'
                    +', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "OrdenMovimiento": {'
                    +'"IOM_ID": "' + intIOM_ID + '" '
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    case 3200:{

        var rqIntIOM_ID = Parametro("IOM_ID", -1)
        var rqStrINV_IDs = Parametro("INV_IDs", "")
        var rqBolEsAgregarIOM = Parametro("EsAgregarIOM", 0)

        var intErrorNumero = 0
        var strErrorDescripcion = ''
        
        var bolError = false;

        var jsonRespuesta = '{}'

        var sqlInsSer = "EXEC SPR_Inventario "
              + "@Opcion = 3200 /*Agregado de Registros */"
            + ", @IOM_ID = " + rqIntIOM_ID + " "
            + ", @INV_IDs = '" + rqStrINV_IDs + "' "
            + ", @EsAgregarIOM = " + rqBolEsAgregarIOM + " "

        //Response.Write(sqlInsSer)

        var rsInsSer = AbreTabla(sqlInsSer, 1, cxnTipo)

        if(!(rsInsSer.EOF)){
            intErrorNumero = rsInsSer("ErrorNumero").Value
        } else {
            intErrorNumero = 1
        }

        if( parseInt(intErrorNumero) > 0){
            bolError = true
        }

        rsInsSer.Close()

        if(bolError){
            intErrorNumero = 0
            strErrorDescripcion = "Se guardaron algunas series"
        } else {
            intErrorNumero = 0
            strErrorDescripcion = "Se guardaron todas las series"
        }
        
        jsonRespuesta = '{'
                + '"Error": {'
                      +'"Numero": "' + intErrorNumero + '"'
                    +', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break

    // Eliminacion Fisica de la orden de movimiento
    case 4000:{
        var rqIntIOM_ID = Parametro("IOM_ID", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = "Se guardo la Orden de Movimiento"

        var intIOM_ID = -1

        var jsonRespuesta  = '{}'

        var sqlDelIOM = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 4000 "
            + ", @IOM_ID = " + rqIntIOM_ID + " "
        
        var rsDelIOM = AbreTabla(sqlDelIOM, 1, cxnTipo)

        if( !(rsDelIOM.EOF)){
            intErrorNumero = rsDelIOM("ErrorNumero").Value
            strErrorDescripcion = rsDelIOM("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se elimino la Orden de Movimiento"
        }

        rsDelIOM.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      +'"Numero": "' + intErrorNumero + '"'
                    +', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "OrdenMovimiento": {'
                    +'"IOM_ID": "' + intIOM_ID + '" '
                +'}'
            + '}'

        Response.Write(jsonRespuesta)
    }
}
%>