<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo
    case 100: {

        var rqIntHabilitado = Parametro("Habilitado", -1)

        var sqlUbiRac = "EXEC SPR_Ubicacion_Rack "
              + "@Opcion = 100 "
            + ", @Rac_Habilitado = " + ( (rqIntHabilitado > -1 ) ? rqIntHabilitado : "NULL" ) + " "

        var rsUbiRac = AbreTabla(sqlUbiRac, 1, cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbiRac.EOF) ){
%>
            <option value="<%= rsUbiRac("Rac_ID").Value %>">
                <%= rsUbiRac("Rac_Nombre").Value %>
            </option> 
<%            
            rsUbiRac.MoveNext()
        }

        rsUbiRac.Close();

    } break;

    //Modal de Edicion
    case 190:{
%>        
        <div class="modal fade" id="modalUbicacionRackEdicion" tabindex="-1" role="dialog" aria-labelledby="divUbicacionRackEdicion" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divUbicacionRackEdicion">
                            <i class="fa fa-file-text-o"></i> Rack 
                            <br />
                            <small>Edicion de Rack</small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="hidRac_ID" value="">
                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">Inmueble: </label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selUbicacionRackInmueble" class="form-control">

                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">Area:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selUbicacionRackArea" class="form-control">

                                    </select>
                                </div>
                            
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-2 control-label">Nombre:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <input type="text" id="inpUbicacionRackNombre" placeholder="Nombre" class="form-control"
                                    maxlength="50" autocomplete="off">
                                </div>
                                
                                <label class="col-sm-2 control-label">Prefijo:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackPrefijo" placeholder="Nombre" class="form-control"
                                    maxlength="50" autocomplete="off">
                                </div> 
                                <label class="col-sm-2 control-label"></label>    
                            
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-2 control-label">Niveles:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackNiveles" placeholder="Niveles" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div> 

                                <label class="col-sm-2 control-label">
                                    <i id="iUbicacionRackHayOcupados" class="fa fa-exclamation-circle fa-lg text-info" 
                                    title="Ya existen ubicaciones ocupadas y no puede actualizar la cantidad de ubicaciones"></i> 
                                </label>    

                                <label class="col-sm-2 control-label">Secciones:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackSecciones" placeholder="Secciones" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div>

                                <label class="col-sm-2 control-label"></label>    
                                
                        </div>
                        <div class="form-group row">

                                <label class="col-sm-2 control-label">Profundidad:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackProfundidad" placeholder="Profundidad" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div>

                                <label class="col-sm-2 control-label"></label>    

                                <label class="col-sm-2 control-label">Posiciones:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackPosiciones" placeholder="Posiciones" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div>   

                                <label class="col-sm-2 control-label"></label>    
                        
                        </div>
                       <div class="form-group row">

                                
                                <label class="col-sm-2 control-label">Ancho:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackAncho" placeholder="Ancho" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div> 
                                <label class="col-sm-2 control-label">Largo:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackLargo" placeholder="Largo" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div>
                                <label class="col-sm-2 control-label">Alto:</label>    
                                <div class="col-sm-2 m-b-xs">
                                    <input type="text" id="inpUbicacionRackAlto" placeholder="Alto" class="form-control"
                                    maxlength="5" autocomplete="off">
                                </div>
                                
                        </div>
                        
                        <div class="form-group row">
                            
                                <label class="col-sm-2 control-label">Tipo Rack:</label>    
                                <div class="col-sm-4 m-b-xs">
                                    <select id="selUbicacionRackTipo" class="form-control">

                                    </select>
                                </div>
                                <label class="col-sm-6 control-label">
                                    <input type="checkbox" id="chbUbicacionRackHabilitado" value="1" checked> Habilitado
                                </label>
                            
                        </div>
                        
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="UbicacionRack.EdicionModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="UbicacionRack.Guardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;

    //Extraer ID Informacion
    case 1000: {

        var rqIntRac_ID = Parametro("Rac_ID", -1)
        
        var jsonRespuesta = '{}'
        
        var sqlExtID = "EXEC SPR_Ubicacion_Rack "
              + "@Opcion = 1000 "
            + ", @Rac_ID = " + ((rqIntRac_ID > -1) ? rqIntRac_ID : "NULL") + " "

        var rsExtID = AbreTabla(sqlExtID, 1, cxnTipo)

        var jsonRespuesta = '{ "Registros": ['
				
        for( var i = 0; !(rsExtID.EOF); i++, rsExtID.MoveNext() ){

            jsonRespuesta += ( i > 0 ) ? ',' : '' 
                
            jsonRespuesta += '{'
            
            for( var j = 0; j < rsExtID.Fields.Count; j++ ){
                
                jsonRespuesta += ( j > 0 ) ? ',' : ''
                jsonRespuesta += '"' + rsExtID(j).Name + '": "' + rsExtID(j).Value + '"'
            }
        
            jsonRespuesta += '}'
              
        }
        
        jsonRespuesta += ']}'

        Response.Write(jsonRespuesta)

    } break;

    //Busqueda Listado de Rack
    case 1001: {

       var rqIntInm_ID = Parametro("Inm_ID", -1)
       var rqIntAre_ID = Parametro("Are_ID", -1)
       var rqIntTRa_ID = Parametro("TRa_ID", -1)
       var rqIntUbi_ID = Parametro("Ubi_ID", -1)

        var sqlUbiRac = "EXEC SPR_Ubicacion_Rack "
              + "@Opcion = 1001 "
            + ", @Are_ID = " + ((rqIntAre_ID > -1) ? rqIntAre_ID : "NULL") + " "
            + ", @Inm_ID = " + ((rqIntInm_ID > -1) ? rqIntInm_ID : "NULL") + " "
            + ", @Rac_TipoCG92 = " + ((rqIntTRa_ID > -1) ? rqIntTRa_ID : "NULL") + " "
            + ", @Ubi_ID = " + ((rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL") + " "

        var rsUbiRac = AbreTabla(sqlUbiRac, 1, cxnTipo)
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
                        <th class="col-sm-2" title="Tipo de Rack">T. de Rack</th>
                        <th class="col-sm-3">Rack</th>
                        <th class="col-sm-1" title="Cantidad de Ubicaciones">Cant. Ubi.</th>
                        <th class="col-sm-3 text-nowrap"></th>
                    </tr>
                </thead>
                <tbody> 
<%
        while( !(rsUbiRac.EOF)){
            
            var bolEsHab = ( parseInt(rsUbiRac("Rac_Habilitado").Value) == 1 )
%>
                    <tr>
                        <td class="col-sm-1"><%= rsUbiRac("Inm_Nombre").Value %></td>
                        <td class="col-sm-1"><%= rsUbiRac("Are_nombre").Value %></td>
                        <td class="col-sm-2"><%= rsUbiRac("CAT_Nombre").Value %></td>
                        <td class="issue-info col-sm-4">
                            <a href="#">
                                <%= rsUbiRac("Rac_Prefijo").Value %> - <%= rsUbiRac("Rac_Nombre").Value %>
                                <small>
                                    <%= rsUbiRac("Rac_Ancho").Value %> x <%= rsUbiRac("Rac_Largo").Value %> x <%= rsUbiRac("Rac_Alto").Value %> mts.
                                </small>
                            </a>
                            <small>
                                Secciones: <%= rsUbiRac("Rac_Secciones").Value %>
                                , Nivel: <%= rsUbiRac("Rac_Niveles").Value %>
                                <br> Profundidad: <%= rsUbiRac("Rac_PosicionesProfundidad").Value %>
                                , Ubicaciones: <%= rsUbiRac("Rac_PosicionesFrontales").Value %>
                            </small>
                        </td>
                        <td class="col-sm-1"><%= rsUbiRac("Rac_TotalPosiciones").Value %></td>
                        <td class="col-sm-3 text-nowrap">

                            <a title="<%= ( (bolEsHab) ? "Habilitado" : "Deshabilitado") %>"
                            onclick='UbicacionRack.Habilitar({Objeto: $(this), Rac_ID: <%= rsUbiRac("Rac_ID").Value %>, Habilitado: <%= rsUbiRac("Rac_Habilitado").Value %>});'>
                                <i class="fa <%= ( (bolEsHab) ? "fa-toggle-on" : "fa-toggle-off") %> fa-lg"></i>
                            </a>

                            <a href="#" class="btn btn-white btn-sm" title="Editar Rack" onclick='UbicacionRack.Editar({Rac_ID: <%= rsUbiRac("Rac_ID").Value %>})'>
                                <i class="fa fa-pencil-square-o"></i>
                            </a>

                            <a href="#" class="btn btn-white btn-sm" title="Ver Ubicaciones" onclick='UbicacionRack.UbicacionNombreListadoCargar({Rac_ID: <%= rsUbiRac("Rac_ID").Value %>})'>
                                <i class="fa fa-file-text-o"></i>
                            </a>
                        </td>
                    </tr>
<%            
            rsUbiRac.MoveNext()
        }
%>
                </tbody>
            </table>

        </div>
    </div>
<%
        rsUbiRac.Close()
   } break;

   //Actualizacion del Rack
    case 3000:{

        var rqIntRac_ID = Parametro("Rac_ID", -1)
        var rqIntInm_ID = Parametro("Inm_ID", -1)
        var rqIntAre_ID = Parametro("Are_ID", -1)
        var rqStrRac_Nombre = Parametro("Rac_Nombre", "")
        var rqStrRac_Prefijo = Parametro("Rac_Prefijo", "")
        var rqStrRac_Secciones = Parametro("Rac_Secciones", "")
        var rqIntRac_Niveles = Parametro("Rac_Niveles", -1)
        var rqIntRac_PosicionesProfundidad = Parametro("Rac_PosicionesProfundidad", -1)
        var rqIntRac_PosicionesFrontales = Parametro("Rac_PosicionesFrontales", -1)
        var rqIntRac_Ancho = Parametro("Rac_Ancho", -1)
        var rqIntRac_Largo = Parametro("Rac_Largo", -1)
        var rqIntRac_Alto = Parametro("Rac_Alto", -1)
        var rqIntRac_TipoCG92 = Parametro("Rac_TipoCG92", -1)
        var rqIntRac_Habilitado = Parametro("Rac_Habilitado", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""
        var intRac_ID = -1

        var jsonRac = '{}'

        var sqlRac = "EXEC SPR_Ubicacion_Rack "
              + "@Opcion = " + ( ( rqIntRac_ID > -1) ? 3000: 2000 ) + " "
            + ", @Rac_ID = " + ( ( rqIntRac_ID > -1) ? rqIntRac_ID : "NULL" ) + " "
            + ", @Inm_ID = " + ( ( rqIntInm_ID > -1) ? rqIntInm_ID : "NULL" ) + " "
            + ", @Are_ID = " + ( ( rqIntAre_ID > -1) ? rqIntAre_ID : "NULL" ) + " "
            + ", @Rac_Nombre = " + ( ( rqStrRac_Nombre.length > 0) ? "'" + rqStrRac_Nombre + "'" : "NULL" ) + " "
            + ", @Rac_Prefijo = " + ( ( rqStrRac_Prefijo.length > 0) ? "'" + rqStrRac_Prefijo + "'" : "NULL" ) + " "
            + ", @Rac_Secciones = " + ( ( rqStrRac_Secciones.length > 0) ? rqStrRac_Secciones : "NULL" ) + " "
            + ", @Rac_Niveles = " + ( ( rqIntRac_Niveles > -1) ? rqIntRac_Niveles : "NULL" ) + " "
            + ", @Rac_PosicionesProfundidad = " + ( ( rqIntRac_PosicionesProfundidad > -1) ? rqIntRac_PosicionesProfundidad : "NULL" ) + " "
            + ", @Rac_PosicionesFrontales = " + ( (rqIntRac_PosicionesFrontales > -1) ? rqIntRac_PosicionesFrontales : "NULL" ) + " "
            + ", @Rac_Ancho = " + ( (rqIntRac_Ancho > -1) ? rqIntRac_Ancho : "NULL" ) + " "
            + ", @Rac_Largo = " + ( (rqIntRac_Ancho > -1) ? rqIntRac_Ancho : "NULL" ) + " "
            + ", @Rac_Alto = " + ( (rqIntRac_Alto > -1) ? rqIntRac_Alto : "NULL" ) + " "
            + ", @Rac_TipoCG92 = " + ( (rqIntRac_TipoCG92 > -1) ? rqIntRac_TipoCG92 : "NULL" ) + " "
            + ", @Rac_Habilitado = " + ( (rqIntRac_Habilitado > -1) ? rqIntRac_Habilitado : "NULL" ) + " "

        var rsRac = AbreTabla(sqlRac, 1 ,cxnTipo)

        if( !(rsRac.EOF) ){
            intErrorNumero = rsRac("ErrorNumero").Value
            strErrorDescripcion = rsRac("ErrorDescripcion").Value
            intRac_ID = rsRac("Rac_ID").Value 
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se guardo el Rack"
        }

        rsRac.Close()

        jsonRac = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "UbicacionRack": {'
                    + '"Rac_ID": "' + intRac_ID + '"'
                +'}'
            + '}'

        Response.Write(jsonRac)

    } break;
}
%>