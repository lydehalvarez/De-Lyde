<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <!-- link href="/Template/inspina/css/style.css" rel="stylesheet" -->
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<%

var Ins_ID = Parametro("Ins_ID",-1)
var Subtarea = Parametro("Subtarea",-1)
var Ins_ID_Asignados = ("Ins_ID_Asignados",0)

		
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica  GROUP BY IDUnica, Usu_Nombre " //    WHERE i.InsO_ID = 8
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica  GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno" //  WHERE i.InsO_ID = 8 
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
                        <div class="ibox-title">
                            <h3>Nueva Tarea</h3>
						</div>
 								<div class="form-group">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-5 m-b-xs">
                                        <select id="selAsignar" class="form-control">
                                            <option value="Selecciona">
                                            <%= "Selecciona" %>
                                            </option>
                                            <%
                                            while( !(rsAsignados.EOF)){
                                            %>
                                            <option value="<%= rsAsignados("IDUnica").Value %>">
                                            <%= rsAsignados("Nombre").Value %>
                                            </option>
                                            <%
                                            rsAsignados.MoveNext()
                                            }
                                            rsAsignados.Close()
                                        
                                            %>

                                        </select>

                                     </div>
                                       <button class="col-sm-4 btn btn-success btn-s btnAsignados" data-insid="<%=Ins_ID_Asignados%>"> + Asignados</button>

                                </div>                                    
   							 <div id="divAsignados">
                           	</div>
                      <div class="form-group">
                         <label class="control-label col-md-3"><strong>Tarea:</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Asunto" placeholder=""></input>
                       </div>
                </div>
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group">
                         <label class="control-label col-md-3"><strong>Descripci&oacute;n:</strong></label>
                       <div class="col-md-9">
                          <textarea class="form-control Descripcion" placeholder=""></textarea>
                       </div>
                </div>
                  
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">Periodo:</label>
                                    <div class="col-sm-4 m-b-xs" >
                                        <input class="form-control date-picker date" data-input-ids="inicio,fin" id="FechasTarea" 
                                                placeholder="dd/mm/aaaa" type="text" value="" 
                                                style="width: 200px;float: left;" /> 
                                            <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                                    </div>
                                   <div class="col-sm-5 m-b-xs" >
									<div>
                      </div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                       <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="FunctionInsert.InsertTarea(<%=Subtarea%>, <%=Ins_ID%>)">Guardar</button>
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
					  <div class="form-group" id="divValidaCampos">
                     </div>
                     
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<input id="Ins_ID" type="hidden" value="<%=Ins_ID%>" />

<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="application/javascript">

   $(document).ready(function(){
	
	  
        $('#FechasTarea').daterangepicker(
            {
               "showDropdowns": true,
               "firstDay": 7,	
               "startDate":moment().startOf('month'),
               "endDate": moment(),
               "autoApply": true,
               "format": "DD/MM/YYYY", 
               "ranges": {
                   'Hoy': [moment(), moment()],
                   //'Al dia de hoy': [moment().startOf('month'), moment()],
//                   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
//                   'Mes pasado': [moment().add(1, 'month').startOf('month')
//                               , moment().subtract(1, 'month').endOf('month')],
                   'Ma\361ana': [moment(), moment().add(1, 'days')],
                   'Proximos 3 Dias': [moment(), moment().add(2, 'days')],
                   'Proximos 5 Dias': [moment(), moment().add(4,'days')],
				   'Proximos 7 Dias': [moment(), moment().add(6, 'days')],
                   'Proximos 15 Dias': [moment(), moment().add(14, 'days')],
                   'Proximos 30 Dias':  [moment(), moment().add(29, 'days')],
               },			
               "locale": {
                   "format": "DD/MM/YYYY", 
                   "separator": " - ",
                   "applyLabel": "Aplicar",
                   "cancelLabel": "Cancelar",
                   "fromLabel": "Desde",
                   "toLabel": "Hasta",
                   "customRangeLabel": "Personalizado",
                   "weekLabel": "W",
                   "daysOfWeek": ["Do","Lu","Ma","Mi","Ju","Vi","Sa"],
                   "monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio"
                                   ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
                }}, 
                function(start, end, label) {
                   $("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                   $("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                    $("#FechasTarea").val($("#inicio").val() + " - " + $("#fin").val())
        });

        $('#InitialDate').daterangepicker(
            {
                "minDate": moment(),
                "maxDate": moment().add(1,'years'),
                "singleDatePicker": true,
                "showDropdowns": true,
                "autoApply": true,
                "minYear": parseInt(moment().format('YYYY'),2020),
                "maxYear": 1
                },
                function(start, end, label) {
                    $("#newAuditInitDate").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                    $("#InitialDate").val($("#newAuditInitDate").val())
            });
		
	 $('.btnCerrar').click(function(e) {
	  	$("#divNuevaTarea").hide('slow');
	  });
   });
        $('.btnAsignados').click(function(e) {
   				e.preventDefault()
				var insid=$(this).data('insid')
         
			        var dato = {
					 Ins_ID:insid,
 					 Ins_ID_Asignados:insid,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divAsignados").load("/pz/wms/Incidencias/Incidencia_Involucrados.asp"
                               , dato
                               , function(){
            });  
            });

</script>