<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Opcion Ubicacion
    case 100: {

        var rqIntHabilitado = Parametro("Habilitado", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)

        var sqlUbi = "EXEC SPR_Ubicacion "
              + "@Opcion = 100 "
            + ", @Are_ID = " + ( (rqIntAre_ID > -1) ? rqIntAre_ID : "NULL" ) 
            + ", @Ubi_Habilitado = " + ( (rqIntHabilitado > -1 ) ? rqIntHabilitado : "NULL" ) 
         
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

    //Opciones de Cliente
    case 101: {

        var sqlCli = "EXEC SPR_Cliente "
            + "@Opcion = 100 "
        
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

    //Nombre Listado
    case 110: {

        var rqIntInm_ID = Parametro("Inm_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqIntRac_ID = Parametro("Rac_ID", -1)

        var rqStrTitulo = Parametro("Titulo", "Ubicaciones")
        var rqIntAlto = Parametro("Alto", 300)

        var sqlUbiNom = "EXEC SPR_Ubicacion "
              + "@Opcion = 1000 /* Busqeda Genearal */ "
            + ", @Inm_ID = " + ( (rqIntInm_ID > -1) ? rqIntInm_ID : "NULL" )  
            + ", @Are_ID = " + ( (rqIntAre_ID > -1) ? rqIntAre_ID : "NULL" )  
            + ", @Rac_ID = " + ( (rqIntRac_ID > -1) ? rqIntRac_ID : "NULL" )  
        
        var rsUbiNom = AbreTabla(sqlUbiNom, 1 ,cxnTipo)
%>
        <div class="ibox">
            <div class="ibox-title">
                <h5><%= rqStrTitulo %></h5>
            </div>
            <div class="ibox-content">
                <table class="table table-striped border border-primary">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>
                                <i class="fa fa-map-marker fa-lg"></i> Ubicaci&oacute;n
                            </th>
                        </tr>
                    </thead>
                    <tbody>
<%  
            if( !(rsUbiNom.EOF) ){
                
                var i = 0;
                while( !(rsUbiNom.EOF) ){
%>
                        <tr>
                            <td><%= ++i %></td>
                            <td><%= rsUbiNom("Ubi_Nombre").Value %></td>
                        </tr>
<%
                    rsUbiNom.MoveNext()
                }

            } else {
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-exclamation-circle fa-lg text-primary"></i> No hay registros
                            </td>
                        </tr>
<%
            }
            rsUbiNom.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
<%
        
    } break;

    //Serie Listado
    case 200: {

        var rqUbi_ID = Parametro("Ubi_ID", -1)

        var sqlSer = "EXEC SPR_Inventario "
              + "@Opcion = 1201 "
            + ", @Ubi_Id = " + rqUbi_ID + " "
        

        var rsSer = AbreTabla(sqlSer, 1, cxnTipo)
%>        
    <table class="table table-striped">
        <thead>
            <tr>
                <th>No.</th>
                <th>Serie</th>
            </tr>
        </thead>
        </tbody>
<% 
        var intMB = 0
        var i = 0
        while( !(rsSer.EOF) ){

            if( intMB != rsSer("Inv_MasterBox").Value ){
                i = 0
%>
            <tr>
                <td colspan="2">
                    <i class="fa fa-dropbox fa-lg"></i> MB: <%= rsSer("Inv_MasterBox").Value %>
                <td>
            </tr>
<%
            }
%>
            <tr>
                <td><%= ++i %></td>
                <td><%= rsSer("INV_Serie").Value %></td>
            </tr>

<%          intMB = rsSer("Inv_MasterBox").Value
            rsSer.MoveNext()
        }

        rsSer.Close()
%>
        </tbody>
    </table>
<%        
    } break;

    //Modal de Edicion
    case 190:{
%>        
        <div class="modal fade" id="mdlUbiEdicion" tabindex="-1" role="dialog" aria-labelledby="divMdlUbiEdicion" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divMdlUbiEdicion">
                            <i class="fa fa-map-marker"></i> Ubicaci&oacute;n 
                            <br />
                            <small>Edici&oacute;n de Ubicaci&oacute;n</small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="hidMdlUbiEdiUbi_ID" value="">

                        <div class="form-group row">
                            <label class="col-sm-12 control-label text-success"><i class="fa fa-id-card-o"></i> Datos Generales:</label>  
                        </div>
                        <div class="hr-line-solid"></div>

                        <div class="form-group row">
                            
                            <label class="col-sm-2 control-label">Inmueble: </label>
                            <label class="col-sm-4 control-label" id="lblMdlUbiEdiInmueble">
                                
                            </label>
                            
                            <label class="col-sm-2 control-label">Area:</label>    
                            <label class="col-sm-4 control-label" id="lblMdlUbiEdiArea">
                                
                            </label>
                            
                        </div>
                        <div class="form-group row">

                            <label class="col-sm-1 control-label" title="Nivel">Nivel:</label>    
                            <label class="col-sm-2 control-label" id="lblMdlUbiEdiNivel">
                                
                            </label>
                            
                            <label class="col-sm-1 control-label" title="Seccion">Secc:</label>  
                            <label class="col-sm-2 control-label" id="lblMdlUbiEdiSeccion">
                                
                            </label>

                            <label class="col-sm-1 control-label" title="Profundidad">Prof.:</label>  
                            <label class="col-sm-2 control-label" id="lblMdlUbiEdiProfundidad">
                                
                            </label>

                            <label class="col-sm-1 control-label" title="Ubicacion">Ubicaci&oacute;n:</label>  
                            <label class="col-sm-2 control-label" id="lblMdlUbiEdiUbicacion">
                                
                            </label>

                        </div>
                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Nombre:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpMdlUbiEdiNombre" placeholder="Nombre" class="form-control"
                                maxlength="50" autocomplete="off">
                            </div>

                            <label class="col-sm-3 control-label">
                                <input type="checkbox" id="chbMdlUbiEdiHabilitado" value="1" checked> Habilitado
                            </label>
                            
                        </div>

                        <div class="form-group row">
                             <label class="col-sm-12 control-label text-success"><i class="fa fa-cube"></i> Dimensiones:</label>  
                        </div>
                        <div class="hr-line-solid"></div>

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">Ancho:</label>    
                            <div class="col-sm-2">
                                <input type="number" id="inpMdlUbiEdiDimFrente" class="form-control" placeholder="Ancho" 
                                 step="1" min="1" max="100" autocomplete="off">
                            </div>

                            <label class="col-sm-1 control-label">Largo:</label>    
                            <div class="col-sm-2">
                                <input type="number" id="inpMdlUbiEdiDimLargo" class="form-control" placeholder="Largo" 
                                 step="1" min="1" max="100" autocomplete="off">
                            </div>

                            <label class="col-sm-1 control-label">Alto:</label>    
                            <div class="col-sm-2">
                                <input type="number" id="inpMdlUbiEdiDimAlto" class="form-control" placeholder="Alto" 
                                 step="1" min="1" max="100" autocomplete="off">
                            </div>

                            <label class="col-sm-3 control-label">
                                
                            </label>
                                
                        </div>

                        <div class="form-group row">
                             <label class="col-sm-12 control-label text-success"><i class="fa fa-cogs"></i> Propiedades:</label>  
                        </div>
                        <div class="hr-line-solid"></div>

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">ABC:</label>    
                            <div class="col-sm-2">
                                <select id="selMdlUbiEdiABC" class="form-control">
                                    <option value="" title="Seleccionar">SELECC.</option>
                                    <option value="1">A</option>
                                    <option value="2">B</option>
                                    <option value="3">C</option>
                                </select>
                            </div>

                            <label class="col-sm-1 control-label">Stock M&iacute;nimo:</label>    
                            <div class="col-sm-2">
                                <input type="number" id="inpMdlUbiEdiStockMinimo" class="form-control" placeholder="Stock M&iacute;nimo" 
                                    step="1" min="1" max="100" autocomplete="off">
                            </div>

                            <label class="col-sm-1 control-label">Stock M&aacute;ximo:</label>    
                            <div class="col-sm-2">
                                <input type="number" id="inpMdlUbiEdiStockMaximo" class="form-control" placeholder="Stock M&aacute;ximo" 
                                    step="1" min="1" max="100" autocomplete="off">
                            </div>

                            <label class="col-sm-3 control-label">
                                <input type="checkbox" id="chbMdlUbiEdiResurtidoAutomatico" value="1"> Resurtido Autom&aacute;tico
                            </label>

                        </div>    

                        <div class="form-group row">
                             <label class="col-sm-12 control-label text-success"><i class="fa fa-handshake-o"></i> Pertenencia:</label>  
                        </div>
                        <div class="hr-line-solid"></div>

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">Cliente:</label>    
                            <div class="col-sm-3">
                                <select id="selMdlUbiEdiCliente" class="form-control">

                                </select>
                            </div>

                            <label class="col-sm-1 control-label">Producto:</label>    
                            <div class="col-sm-7">
                                <select id="selMdlUbiEdiProducto" class="form-control">

                                </select>
                            </div> 

                        </div>

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">Estado:</label>    
                            <div class="col-sm-3">
                                <select id="selMdlUbiEdiEstado" class="form-control">

                                </select>
                            </div>

                            <label class="col-sm-1 control-label">Proveedor:</label>    
                            <div class="col-sm-3">
                                <select id="selMdlUbiEdiProveedor" class="form-control">

                                </select>
                            </div>

                            <label class="col-sm-4 control-label">
                                <input type="checkbox" id="chbMdlUbiEdiCuarentena" value="1"> Cuarentena
                            </label>

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Ubicacion.EdicionModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="Ubicacion.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;
    
 //Modal de Seleccion Avanzada
    case 290:{
%>        
        <div class="modal fade" id="mdlUbiSeleccionAvanzada" tabindex="-1" role="dialog" aria-labelledby="divUbiSeleccionAvanzada" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Ubicacion.SeleccionAvanzadaModalCerrar()">
                            <span aria-hidden="true">&times;</span>
                        </button>

                        <h2 class="modal-title" id="divUbiSeleccionAvanzada">
                            <i class="fa fa-file-text-o"></i> Ubicaci&oacute;n 
                            <br />
                            <small>Selecci&oacute;n avanzada de Ubicaci&oacute;n</small>
                        </h2>

                    </div>
                    <div class="modal-body">

                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">Nombre Ubicaci&oacute;n:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpmdlUbiSelAvaNombre" placeholder="Nombre" class="form-control"
                                    maxlength="50" autocomplete="off">
                                </div>

                                <label class="col-sm-2 control-label">Area:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selmdlUbiSelAvaUbicacionArea" class="form-control">

                                    </select>
                                </div>
                            
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-2 control-label">Rack:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selmdlUbiSelAvaUbicacionRack" class="form-control">

                                    </select>
                                </div>
                                
                                 <label class="col-sm-2 control-label">Tipo Rack:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selmdlUbiSelAvaTipoRack" class="form-control">

                                    </select>
                                </div>

                        </div>
                       
                        <div class="form-group row">
                            <div class="ibox">
                                <div class="ibox-title">
                                    <h5>Resultados</h5>
                                    <div class="ibox-tools">
                                        <button type="button" class="btn btn-success btn-sm" type="button" id="btnBuscar" onclick="Ubicacion.SeleccionAvanzadaModalBuscar()">
                                            <i class="fa fa-search"></i> Buscar
                                        </button>
                                    </div>
                                </div>
                                <div class="ibox-content" style="overflow-y: auto;max-height: 200px;">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Ubicaci&oacute;n</th>
                                                <th>SKUs</th>
                                                <th><th>
                                            </tr>
                                        </thead>
                                        <tbody id="divmdlUbiSelAvaListado"> 

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Ubicacion.SeleccionAvanzadaModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;


    //Listado de Ubicacion Avanzada
    case 291:{

        var rqIntInm_ID = Parametro("Inm_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqIntRac_ID = Parametro("Rac_ID", -1)
        var rqIntTRa_ID = Parametro("TRa_ID", -1)
        var strUbi_Nombre = Parametro("Ubi_Nombre", "")

        var sqlUbiSelAva = "EXEC SPR_Ubicacion "
              + "@Opcion = 1002 "
            + ", @Inm_ID = " + ( (rqIntInm_ID > -1) ? rqIntInm_ID : "NULL" ) + " "
            + ", @Are_ID = " + ( (rqIntAre_ID > -1) ? rqIntAre_ID : "NULL" ) + " "
            + ", @Rac_ID = " + ( (rqIntRac_ID > -1) ? rqIntRac_ID : "NULL" ) + " "
            + ", @Rac_TipoCG92 = " + ( (rqIntTRa_ID > -1) ? rqIntTRa_ID : "NULL" ) + " "
            + ", @Ubi_Nombre = '" + strUbi_Nombre + "' "

        var rsUbiSelAva = AbreTabla(sqlUbiSelAva, 1, cxnTipo)

        if( !(rsUbiSelAva.EOF) ){

            var i = 0
            while( !(rsUbiSelAva.EOF) ){
 %>
                        <tr>
                            <td><%= ++i %></td>
                            <td class="issue-info">
                                <a href="#"">
                                    <%= rsUbiSelAva("Ubi_nombre").Value %>
                                </a>
                                <small>
                                    Area: <strong><%= rsUbiSelAva("Are_nombre").Value %></strong>
                                    <br>
                                    Rack: <strong><%= rsUbiSelAva("Rac_nombre").Value %></strong>
                                    <br>
                                    Tipo de Rack: <strong><%= rsUbiSelAva("TRa_nombre").Value %></strong>
                                </small>
                            </td>
                            <td>
                                <%= (rsUbiSelAva("Ubi_Productos").Value).split("|").join("<br>") %>
                            </td>
                            <td>
                                <a href="#" class="btn btn-white btn-xs"
                                    onclick='Ubicacion.SeleccionAvanzadaSeleccionar({
                                            Ubi_ID: <%= rsUbiSelAva("Ubi_ID").Value %>
                                            , Ubi_Nombre: "<%= rsUbiSelAva("Ubi_Nombre").Value %>"
                                        })'>
                                    <i class="fa fa-check" title="Seleccionar"></i>
                                </a>
                            <td>
                        </tr>
<%                
                rsUbiSelAva.MoveNext()
            }

        } else {
%>
                        <tr>
                            <td colspan="3">
                                <i class="fa fa-exlamation-circle"></i> No hay registros
                            </td>
                        </tr>
<%      
        }

        rsUbiSelAva.Close()

    } break;

    //busqueda Principal
    case 1000: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)

        var sqlUbi = "EXEC SPR_Ubicacion "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" )  

        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsUbi, JSON.Tipo.RecordSet)

        rsUbi.Close()

        Response.Write(jsonRespuesta)

    } break;

    //Lateral Detalle Ubicacion
    case 1001: {
        var rqIntUbi_ID = Parametro("Ubi_ID", -1)

        var sqlUbiID = "EXEC SPR_Ubicacion "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ((rqIntUbi_ID > -1) ? rqIntUbi_ID : 0)  
        
        var rsUbiID = AbreTabla(sqlUbiID, 1, cxnTipo)
%>
    <div class="ibox">
<%
        if( !(rsUbiID.EOF) ){
%>
        <div class="ibox-title">
            <h2 class="text-success"><i class="fa fa-map-marker fa-lg"></i> <%= rsUbiID("Ubi_Nombre").Value %></H2>
        </div>
        <div class="ibox-content">
            <h3 class="text-danger"> <i class="fa fa-map-signs"></i> Localizaci&oacute;n</h3>
            <div class="hr-line-solid"></div>
            <div class="row">
                <div class="col-sm-12">
                    <span class="col-form-label">Inmueble</span>
                    <div class="font-bold">
                        <%= rsUbiID("Inm_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Area</span>
                    <div class="font-bold">
                        <%= rsUbiID("Are_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Rack</span>
                    <div class="font-bold">
                        <%= rsUbiID("Rac_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Nivel</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_Nivel").Value %>
                    </div>
                    <span class="col-form-label">Seccion</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_Seccion").Value %>
                    </div>
                    <span class="col-form-label">Profundidad</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_Profundidad").Value %>
                    </div>
                    <span class="col-form-label">Ubicaci&oacute;n</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_Frente").Value %>
                    </div>
                </div>
            </div>
            <h3 class="text-danger"> <i class="fa fa-cube"></i> Dimensiones</h3>
            <div class="hr-line-solid"></div>
            <div class="row">
                <div class="col-sm-12">
                    <span class="col-form-label">Ancho</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_DimFrente").Value %>
                    </div>
                    <span class="col-form-label">Largo</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_DimLargo").Value %>
                    </div>
                    <span class="col-form-label">Alto</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_DimAlto").Value %>
                    </div>
                </div>
            </div>
            <h3 class="text-danger"> <i class="fa fa-cogs"></i> Propiedades</h3>
            <div class="hr-line-solid"></div>
            <div class="row">
                <div class="col-sm-12">
                    <span class="col-form-label">Habilitado</span>
                    <div class="font-bold">
                        <% if( rsUbiID("Ubi_Habilitado").Value == 0){ %>
                            <i class="fa fa-times fa-lg text-danger"></i> Deshabilitado
                        <% } else { %>
                            <i class="fa fa-check fa-lg text-info"></i> Habilitado
                        <% } %>
                    </div>
                    <span class="col-form-label">Stock M&iacute;nimo</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_StockMinimo").Value %>
                    </div>
                    <span class="col-form-label">Stock M&aacute;ximo</span>
                    <div class="font-bold">
                        <%= rsUbiID("Ubi_StockMaximo").Value %>
                    </div>
                    <span class="col-form-label">Resurtido Autom&aacute;tico</span>
                    <div class="font-bold">
                        <% if( rsUbiID("Ubi_ResurtidoAutomatico").Value == 0){ %>
                            <i class="fa fa-times fa-lg text-danger"></i> No
                        <% } else { %>
                            <i class="fa fa-check fa-lg text-info"></i> Si
                        <% } %>
                    </div>
                </div>
            </div>

            <h3 class="text-danger"> <i class="fa fa-handshake-o"></i> Pertenencia</h3>
            <div class="hr-line-solid"></div>
            <div class="row">
                <div class="col-sm-12">
                    <span class="col-form-label">Cliente</span>
                    <div class="font-bold">
                        <%= rsUbiID("Cli_Nombre").Value  %>
                    </div>
                    <span class="col-form-label">Producto</span>
                    <div class="font-bold">
                        <%= rsUbiID("Pro_SKU").Value %> - <%= rsUbiID("Pro_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Estado</span>
                    <div class="font-bold">
                        <%= rsUbiID("Edo_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Proveedor</span>
                    <div class="font-bold">
                        <%= rsUbiID("Prov_Nombre").Value %>
                    </div>
                    <span class="col-form-label">Cuarentena</span>
                    <div class="font-bold">
                        <% if( rsUbiID("Ubi_EsCuarentena").Value == 0){ %>
                            <i class="fa fa-times fa-lg text-danger"></i> No
                        <% } else { %>
                            <i class="fa fa-check fa-lg text-info"></i> Si
                        <% } %>
                    </div>
                </div>
            </div>
<%
        } else {
%>
        <div class="ibox-content">
            <i class="fa fa-exclamation-circle-o"></i> No hay informaci&oacute;n
        </div>
<%
        }

        rsUbiID.Close()
%>
    </div>
<%
    } break;

    //Busqueda y listado Principal
    case 1100: {

        var rqIntInm_ID = Parametro("Inm_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqIntTRa_ID = Parametro("TRa_ID", -1)
        var rqIntRac_ID = Parametro("Rac_ID", -1)
        var rqStrUbi_Nombre = Parametro("Ubi_Nombre", "")

        var sqlUbiBus = "EXEC SPR_Ubicacion "
              + "@Opcion = 1000 "
            + ", @Inm_ID = " + ( (rqIntInm_ID > -1) ? rqIntInm_ID : "NULL" )  
            + ", @Are_ID = " + ( (rqIntAre_ID > -1) ? rqIntAre_ID : "NULL" )  
            + ", @Rac_TipoCG92 = " + ( (rqIntTRa_ID > -1) ? rqIntTRa_ID : "NULL" )  
            + ", @Rac_ID = " + ( (rqIntRac_ID > -1) ? rqIntRac_ID : "NULL" )  
            + ", @Ubi_Nombre = " + ( (rqStrUbi_Nombre.length > 0) ? "'" + rqStrUbi_Nombre + "'" : "NULL" )  

        var rsUbiBus = AbreTabla(sqlUbiBus, 1, cxnTipo)
%>
    <div class="ibox-title">
        <h5>Resultados</h5>
    </div>
    <div class="ibox-content">
        <div class="row"> 
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th class="col-sm-1">Inmueble</th>
                        <th class="col-sm-1">Area</th>
                        <th class="col-sm-1" title="Tipo de Rack">T. de Rack</th>
                        <th class="col-sm-1">Rack</th>
                        <th class="col-sm-3 text-nowrap" title="">Ubicaci&oacute;n</th>
                        <th class="col-sm-3 text-nowrap"></th>
                    </tr>
                </thead>
                <tbody>
<%      
        while( !(rsUbiBus.EOF) ){

            var bolEsHab = ( parseInt(rsUbiBus("Ubi_Habilitado").Value) == 1 )
%>
                    <tr>
                        <td class="col-sm-1"><%= rsUbiBus("Inm_Nombre").Value %></td>
                        <td class="col-sm-1"><%= rsUbiBus("Are_Nombre").Value %></td> 
                        <td class="col-sm-1"><%= rsUbiBus("TRa_Nombre").Value %></td>
                        <td class="col-sm-1"><%= rsUbiBus("Rac_Nombre").Value %></td>
                        <td class="col-sm-3 issue-info">
                            <a href="#">
                                <%= rsUbiBus("Ubi_Nombre").Value %>
                            </a>
                            <small>
                                Dimesion: 
                                <strong>
                                    <%= rsUbiBus("Ubi_DimFrente").Value %> x <%= rsUbiBus("Ubi_DimLargo").Value %> x <%= rsUbiBus("Ubi_DimAlto").Value %> cm.
                                </strong>
                                <br>
                                Localizacion: Nivel: <strong><%= rsUbiBus("Ubi_Nivel").Value %></strong>, Seccion: <strong><%= rsUbiBus("Ubi_Seccion").Value %></strong>, Profundidad: <strong><%= rsUbiBus("Ubi_Profundidad").Value %></strong>, Posicion: <strong><%= rsUbiBus("Ubi_Frente").Value %></strong>
                            </small>
                        </td>
                        <td class="col-sm-3 text-nowrap">
                            <a title="<%= ( (bolEsHab) ? "Habilitado" : "Deshabilitado") %>"
                            onclick='Ubicacion.Habilitar({Objeto: $(this), Ubi_ID: <%= rsUbiBus("Ubi_ID").Value %>, Habilitado: <%= rsUbiBus("Ubi_Habilitado").Value %>});'>
                                <i class="fa <%= ( (bolEsHab) ? "fa-toggle-on" : "fa-toggle-off") %> fa-lg"></i>
                            </a>

                            <a href="#" class="btn btn-white btn-sm" title="Editar Ubicaci&oacute;n" onclick='Ubicacion.Editar({Ubi_ID: <%= rsUbiBus("Ubi_ID").Value %>})'>
                                <i class="fa fa-pencil-square-o"></i>
                            </a>

                            <a href="#" class="btn btn-white btn-sm" title="Ver Detalle" onclick='Ubicacion.DetalleVer({Ubi_ID: <%= rsUbiBus("Ubi_ID").Value %>})'>
                                <i class="fa fa-file-text-o"></i>
                            </a>
                        </td>
                    </tr>
<%      
            rsUbiBus.MoveNext()
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
        rsUbiBus.Close()

    } break;

    //Listado Totales
    case 1200: {

        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqIntTRa_ID = Parametro("TRa_ID", -1)
        var rqIntRac_ID = Parametro("Rac_ID", -1)
        var rqStrPro_SKU = Parametro("Pro_SKU", "")
        var rqStrUbi_Nombre = Parametro("Ubi_Nombre", "")
        var rqStrPT_LPN = Parametro("PT_LPN", "")
            
        var sqlUbi = "EXEC SPR_Ubicacion "
              + "@Opcion = 1001 "
            + ", @Cli_ID = " + ((rqIntCli_ID > 0) ? rqIntCli_ID : "NULL")  
            + ", @Are_ID = " + ((rqIntAre_ID > 0) ? rqIntAre_ID : "NULL")  
            + ", @TRa_ID = " + ((rqIntTRa_ID > 0) ? rqIntTRa_ID : "NULL")  
            + ", @Rac_ID = " + ((rqIntRac_ID > 0) ? rqIntRac_ID : "NULL")  
            + ", @PRO_SKU = " + ((rqStrPro_SKU.length > 0) ? "'" + rqStrPro_SKU + "'" : "NULL")  
            + ", @Ubi_Nombre = " + ((rqStrUbi_Nombre.length > 0) ? "'" + rqStrUbi_Nombre + "'" : "NULL")  
            + ", @PT_LPN = " + ((rqStrPT_LPN.length > 0) ? "'" + rqStrPT_LPN + "'" : "NULL")  

        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>#</th>
                <th class="col-sm-2">Cliente</th>
                <th class="col-sm-3">LPN</th>
                <th class="col-sm-2">Producto</th>
                <th class="col-sm-1" title="Cantidad Producto">Cant. Pro.</th>
                <th class="col-sm-2"></th>
            </tr>
        </thead>
        <tbody>
<%
        var j = 0;
        var Ubi_Nombre = ""

        while( !(rsUbi.EOF) ){
            
            bolPertenencia = ( rsUbi("PCli_Nombre").Value != "" || rsUbi("PPro_Nombre").Value != "" || rsUbi("PProv_Nombre").Value || rsUbi("PEdo_Nombre").Value )
            bolSal = false

            bolEsAuditada = ( rsUbi("Ubi_EsAuditada").Value == 1 )

            if( Ubi_Nombre != rsUbi("Ubi_Nombre").Value ){
%>
            <tr class="text-success ">
                <td><%= ++j %></td>
                <td class="text-nowrap"> 
                    <strong><i class="fa fa-map-marker"></i> 
                    <%= rsUbi("Ubi_Nombre").Value %></strong> <%= (rsUbi("Ubi_Etiqueta").Value > 0) ? "(" + rsUbi("Ubi_Etiqueta").Value + ")" : "" %>
                    <a class="btn btn-white btn-sm" onclick='Ubicacion.ImprimirCodigoBarras({Ubi_ID: <%= rsUbi("Ubi_ID").Value %>})'> 
                        <i class="fa fa-print" title="Codigo de Barras"></i>
                    </a> 
                    <br>
                    
<%              if( bolEsAuditada ){
%>
                    &nbsp;<i class="fa fa-exclamation-circle fa-lg text-danger" title="Ubicación Auditada"></i>
<%              }
%>
                </td>
                <td>
<%              
                if( bolPertenencia ){
%>
                    Ubicaci&oacute;n Pertenece a:
<%
                }
%>
                </td>
                <td colspan="3">
<%
                if( rsUbi("PCli_Nombre").Value != ""){
                    bolSal = true
%>
                    Cliente: <strong><%= rsUbi("PCli_Nombre").Value %></strong>
<%
                }

                if( rsUbi("PPro_Nombre").Value != ""){
                    Response.Write( (bolSal) ? "<br>" : "" )
                    bolSal = true
%>
                    Producto: <strong>(<%= rsUbi("PPro_SKU").Value %>) - <%= rsUbi("PPro_Nombre").Value %></strong>
<%
                }

                if( rsUbi("PProV_Nombre").Value != ""){
                    Response.Write( (bolSal) ? "<br>" : "" )
                    bolSal = true
%>
                    Proveedor: <strong><%= rsUbi("PProV_Nombre").Value %></strong>
<%
                }

                if( rsUbi("PEdo_Nombre").Value != ""){
                    Response.Write( (bolSal) ? "<br>" : "" )
                    bolSal = true
%>
                    Estado: <strong><%= rsUbi("PEdo_Nombre").Value %></strong>
<%
                }

%>
                </td>
            </tr>
<%
            }

            if( parseInt(rsUbi("PT_ID").Value) > 0 ){
%>
            <tr>
                <td></td>
                <td><%= rsUbi("Cli_Nombre").Value %></td>
                <td><%= rsUbi("PT_LPN").Value %></td>
                <td class="issue-info">
                    <a href="#">
                        <%= rsUbi("Pro_SKU").Value %>
                    </a>
                    <small>
                        <%= rsUbi("Pro_Nombre").Value %>
                    </small>
                </td>
                <td><%= rsUbi("PT_Cantidad_Actual").Value %></td>
                <td class="text-nowrap">
                    
                    
                    <a class="btn btn-white btn-sm" title="Ver Series" onclick='Ubicacion.InventarioSeriesActualListadoCargar({Ubi_ID: <%= rsUbi("Ubi_ID").Value %>, PT_ID: <%= rsUbi("PT_ID").Value %>})''>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    
                    <a class="btn btn-white btn-sm" title="Imprimir LPN" onclick='Ubicacion.PalletLPNImprimir({PT_ID: <%= rsUbi("PT_ID").Value %>})'>
                        <i class="fa fa-print"></i> LPN
                    </a>

                    <a class="btn btn-white btn-sm" title="Exportar Series" onclick='Ubicacion.Exportar({PT_ID: <%= rsUbi("PT_ID").Value %>});'>
                        <i class="fa fa-file-excel-o"></i> Exportar
                    </a>

                </td>
            </tr>
<%          
            } else {
%>
            <tr>
                <td colspan="6">
                    Disponible
                </td>
            </tr> 
<%
            }

            Ubi_Nombre = rsUbi("Ubi_Nombre").Value
            Response.Flush()
            rsUbi.MoveNext()
        }

        rsUbi.Close()
%>
        </tbody>
    </table>
<%
       
    } break;

    case 1300: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)

        var sqlExp = "EXEC SPR_Inventario "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1 ) ? rqIntUbi_ID : "NULL" )  
            + ", @Are_ID = " + ( (rqIntAre_ID > -1 ) ? rqIntAre_ID : "NULL" )  
            + ", @PT_ID = " + ( (rqIntPT_ID > -1 ) ? rqIntPT_ID : "NULL" )  

        var rsExp = AbreTabla(sqlExp, 1, cxnTipo)

        var jsonRespuesta = '['

        var bolInicio = true

        while( !(rsExp.EOF) ){
            
            jsonRespuesta += ( bolInicio ) ? '' : ','
            jsonRespuesta += '{'
                      + '"Ubicacion": "' + rsExp("Ubi_Nombre").Value + '"'
                    + ', "SKU": "' + rsExp("Pro_SKU").Value + '"'
                    + ', "Descripcion": "' + rsExp("Pro_Nombre").Value + '"'
                    + ', "LPN": "' + rsExp("PT_LPN").Value + '"'
                    + ', "MasterBox": "' + rsExp("Inv_MasterBox").Value + '"'
                    + ', "Serie": "' + rsExp("Inv_Serie").Value + '"'
                +'}'    

            bolInicio = false

            Response.Flush()
            rsExp.MoveNext()
        }

        jsonRespuesta += ']'

        rsExp.Close()

        Response.Write(jsonRespuesta)

    } break;

    case 3000:{

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqStrUbi_Nombre = Parametro("Ubi_Nombre", -1)
        var rqDblUbi_DimFrente = Parametro("Ubi_DimFrente", 0)
        var rqDblUbi_DimLargo = Parametro("Ubi_DimLargo", 0)
        var rqDblUbi_DimAlto = Parametro("Ubi_DimAlto", 0)
        var rqBolUbi_Habilitado = Parametro("Ubi_Habilitado", 0)

        var rqStrABC = Parametro("Ubi_ABC", 0)
        var rqIntStockMinimo = Parametro("Ubi_StockMinimo", 0)
        var rqIntStockMaximo = Parametro("Ubi_StockMaximo", 0)
        var rqBolResurtidoAutomatico = Parametro("Ubi_ResurtidoAutomatico", 0)

        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntPro_ID = Parametro("Pro_ID", -1)

        var rqIntEdo_ID = Parametro("Edo_ID", -1) 
        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqBolEsCuarentena = Parametro("EsCuarentena", 0)

        var intErrorNumero = 0
        var strErrorDescripcion = ""
        var intUbi_ID = -1

        var jsonRespuesta = '{}'

        var sqlUbi = "EXEC SPR_Ubicacion "
              + "@Opcion = 3000 "
            + ", @Ubi_ID = " + ( ( rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" )  
            + ", @Ubi_Nombre = " + ( (rqStrUbi_Nombre.length > 0) ? "'" + rqStrUbi_Nombre + "'" : "NULL" )  
            + ", @Ubi_DimFrente = " + ( (rqDblUbi_DimFrente > -1) ? rqDblUbi_DimFrente: "NULL" )  
            + ", @Ubi_DimLargo = " + ( (rqDblUbi_DimLargo > -1) ? rqDblUbi_DimLargo: "NULL" )  
            + ", @Ubi_DimAlto = " + ( (rqDblUbi_DimAlto > -1) ? rqDblUbi_DimAlto: "NULL" )  
            + ", @Ubi_Habilitado = " + ( (rqBolUbi_Habilitado > -1) ? rqBolUbi_Habilitado : "NULL" )  

            + ", @Ubi_ABC = " + rqStrABC  
            + ", @Ubi_StockMinimo = " + rqIntStockMinimo  
            + ", @Ubi_StockMaximo = " + rqIntStockMaximo   
            + ", @Ubi_ResurtidoAutomatico = " + rqBolResurtidoAutomatico  

            + ", @Cli_ID = " + rqIntCli_ID  
            + ", @Pro_ID = " + rqIntPro_ID  
            + ", @Edo_ID = " + rqIntEdo_ID  
            + ", @Prov_ID = " + rqIntProv_ID  
            + ", @Ubi_EsCuarentena = " + rqBolEsCuarentena  

        var rsUbi = AbreTabla(sqlUbi, 1 ,cxnTipo)

        if( !(rsUbi.EOF) ){
            intErrorNumero = rsUbi("ErrorNumero").Value
            strErrorDescripcion = rsUbi("ErrorDescripcion").Value
            intUbi_ID = rsUbi("Ubi_ID").Value 
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se guardo el Rack"
        }

        rsUbi.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Ubicacion": {'
                    + '"Ubi_ID": "' + intUbi_ID + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
    case 3001:{

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqBolUbi_Habilitado = Parametro("Ubi_Habilitado", 0)        

        var intErrorNumero = 0
        var strErrorDescripcion = ""
        var intUbi_ID = -1

        var jsonRespuesta = '{}'

        var sqlUbi = "EXEC SPR_Ubicacion "
              + "@Opcion = 3001 "
            + ", @Ubi_ID = " + ( ( rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @Ubi_Habilitado = " + ( (rqBolUbi_Habilitado > -1) ? rqBolUbi_Habilitado : "NULL" ) + " "

        var rsUbi = AbreTabla(sqlUbi, 1 ,cxnTipo)

        if( !(rsUbi.EOF) ){
            intErrorNumero = rsUbi("ErrorNumero").Value
            strErrorDescripcion = rsUbi("ErrorDescripcion").Value
            intUbi_ID = rsUbi("Ubi_ID").Value 
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se guardo el Rack"
        }

        rsUbi.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Ubicacion": {'
                    + '"Ubi_ID": "' + intUbi_ID + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)
    }
}
%>
