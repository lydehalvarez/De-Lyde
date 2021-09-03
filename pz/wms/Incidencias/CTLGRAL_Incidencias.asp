<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
    <!-- link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet" -->
    <!-- link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet" -->
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <!-- link href="/Template/inspina/css/style.css" rel="stylesheet" -->
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
          <div class="ibox-title">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
              <!--a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-wrench"></i></a>
              <ul class="dropdown-menu dropdown-user">
                <li>
                  <a href="#">Config option 1</a>
                </li>
                <li>
                  <a href="#">Config option 2</a>
                </li>
              </ul><a class="close-link"><i class="fa fa-times"></i></a>
            </div-->
          </div>
          <div class="ibox-content">
		
</br>
<div class="col-sm-12 m-b-xs">    
	<div class="row">
			    <input type="checkbox"  class="i-checks ChkGrupos"onclick="javascript:MostrarGrupos()" > Ver grupos </input>&nbsp;
				<input type="checkbox"  class="i-checks ChkGruposAt"onclick="javascript:MostrarGruposAti()" > Ver grupos (Atendiendo) </input>&nbsp;
			    <input type="checkbox"  class="i-checks ChkGruposRe"onclick="javascript:MostrarGruposRep()" > Ver grupos (Reporta) </input>&nbsp;
				<input type="checkbox"  class="i-checks ChkProvAt"onclick="javascript:MostrarProvAti()" > Ver transportistas (Atendiendo) </input>&nbsp;
			    <input type="checkbox"  class="i-checks ChkProvRe"onclick="javascript:MostrarProvRep()" > Ver transportistas (Reporta)</input>

</div>
     <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
	</div>
     <div class="row">
             <label class="col-sm-2 control-label">Folio transferencia:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="TA_Folio" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
      </div>
            <div class="row"> 
                      
                    <!-- div class="row" -->
                    
                    <%
						
sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
		+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica "
//		if(InsO_ID>-1){
//		sSQL +=  " WHERE i.InsO_ID = "+InsO_ID
//		}
		sSQL +=" GROUP BY IDUnica, Usu_Nombre "
		sSQL +="UNION "
		sSQL +="SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		sSQL +="inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica "
	//	if(InsO_ID>-1){
//		sSQL +=" WHERE i.InsO_ID = "+InsO_ID
//		}
		sSQL +=" GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno"
		   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
      <label class="col-sm-2 control-label" id="lblVariable">Atendiendo:</label>    
                                    <div class="col-sm-4 m-b-xs">
              							<select id="Atiende" class="form-control">
                                            <option value="">
                                            <%= "--Seleccionar--" %>
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

                                    <%
										var sCondicion = ""
										CargaCombo("Gru_Atiende","class='form-control'","IncG_ID","IncG_Nombre","Incidencia_Grupo",sCondicion,"","Editar",0,"--Seleccionar--")
							
										CargaCombo("Gru_Todos","class='form-control'","IncG_ID","IncG_Nombre","Incidencia_Grupo",sCondicion,"","Editar",0,"--Seleccionar--")

										var sCondicion = "Prov_EsPaqueteria = 1"
										CargaCombo("Prov_Atiende","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"--Seleccionar--")

									%>
       
									</div>

  
                        <label class="col-sm-2 control-label">Ticket:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="Ins_ID" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div> 
                    </div>    
            <div class="row"> 
                       <label class="col-sm-2 control-label">Reporto:</label>    
                                    <div class="col-sm-4 m-b-xs">
              							<select id="Reporta" class="form-control">
                                            <option value="">
                                            <%= "--Seleccionar--" %>
                                            </option>
                                            <%
									   	    rsAsignados = AbreTabla(sSQL,1,0)
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
 <%
										var sCondicion = ""
										CargaCombo("Gru_Reporta","class='form-control'","IncG_ID","IncG_Nombre","Incidencia_Grupo",sCondicion,"","Editar",0,"--Seleccionar--")
										 sCondicion = "Prov_EsPaqueteria = 1"
										CargaCombo("Prov_Reporta","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"--Seleccionar--")
									%>
									</div>

                    <!-- div class="row" -->
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = " Sec_ID = 27 " 

    CargaCombo("Ins_EstatusCG27", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar")
%>
                        </div>
                   
                    </div>    
            
                <div class="row">

                    <!-- div class="col-sm-12 m-b-xs"  -->
                        <!-- div class="row" -->
					
                            <label class="col-sm-2 control-label">Fechas de solicitud:</label>
                            <div class="col-sm-4 m-b-xs" >
                                <input class="form-control date-picker date" id="FechaBusqueda" 
                                       placeholder="dd/mm/aaaa" type="text" value="" 
                                       style="width: 200px;float: left;" > 
                                   <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>

                            </div>
                            
                            <label class="col-sm-2 control-label">Origen:</label>
                            <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = "" 

    CargaCombo("InsO_ID", sEventos, "InsO_ID", "InsO_Nombre", "Incidencia_Originacion", sCondicion, "", -1, 0, "Todos", "Editar")
%>
                  <%/*%>          <label class="col-sm-2 control-label">Tipo:</label>
                            <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = "" 

    CargaCombo("InsT_ID", sEventos, "InsT_ID", "InsT_Nombre", "Incidencia_Tipo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar")
%><%*/%>
						</div>
                        <!-- /div  -->    
                    </div>
                <!-- /div  --> 
              
			<div class="row"  id= "divPadre"> 
                        <label class="control-label col-md-2"><strong>Tipo:</strong></label>
                         <div class="col-md-4">
<%
//						if(Procedencia ==""){

                            var sCondicion = "InsT_Padre = 0"
                            var campo = "InsT_Nombre"
                            
                            CargaCombo("InsT_Padre","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")
						
//						}else{
%>
<%/*%>                     <span class="text-left">  <label class="control-label col-md-9"><strong><%=Procedencia%></strong></label> </span>
<%*/%><%
//						}
%>
								<div class="col-md-6">
									
								</div>

					</div>
                </div>
						<div class ="row">
					 <label class="control-label col-md-2">	<a  class="text-muted btnRegresar"  onclick="javascript:CargaTipoInicial();  return false">
                          <h3><i class="fa fa-refresh"></i></h3></a></label>
						</div>
                    </div>
            </div>
				
<div class="row">
</div>
                    <div class="table-responsive" id="dvTablaIncidencias"></div>  
         
          
 
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>
              
    <!-- Mainly scripts -->
    <!-- script src="/Template/inspina/js/jquery-3.1.1.min.js"></script -->
    <!-- script src="/Template/inspina/js/bootstrap.min.js"></script -->
    <script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <!--  script src="/Template/inspina/js/inspinia.js"></script -->
    <script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>

    <!-- iCheck -->
    <!-- script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script -->

    <!-- Select2 -->
    <script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
          
    <!-- MENU -->
    <!-- script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script -->
        
        
    
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">
        
$(document).ready(function(){
     $('#Gru_Atiende').hide()
	 $('#Gru_Todos').hide()
     $('#Gru_Reporta').hide()
	 $('#Prov_Atiende').hide()
     $('#Prov_Reporta').hide()

     var Today= new Date();
    Today.setDate(Today.getDate() ); 
    
   $('.btnTipo').click(function(e){
       e.preventDefault()
       $('.btnTipo').removeClass("btn-success")
       $(this).addClass("btn-success")
     
   })
    
		 $('#InsT_Padre').change(function(e) {
            e.preventDefault()
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
			   	  sDatos += "&Tarea="+4
		$("#divPadre").load("/pz/wms/Incidencias/Incidencias_Formulario.asp?" + sDatos)
         });
    
   $('.cbo2').select2()
    
    $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
           // "setDate": Today,
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                
			   '7 Dias': [moment().subtract(6, 'days'), moment()],
               '15 Dias': [moment().subtract(15, 'days'), moment()],
			   '30 Dias': [moment().subtract(29, 'days'), moment()],
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
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
            })

   
    
   // CargaGridInicial()


      $("#btnBuscar").click(function(event) {

          
            $("#dvTablaIncidencias").empty()
		   $("#dvTablaIncidencias").html('Cargando...')
            var dato = {}
                dato['Lpp'] = 1  //este parametro limpia el cache
                dato['Ins_ID'] = $('#Ins_ID').val()
                dato['InsO_ID'] = $('#InsO_ID').val()
                dato['TA_Folio'] = $('#TA_Folio').val()
		  		dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()
                dato['Estatus'] = $('#Ins_EstatusCG27').val()
                dato['Atiende'] = $('#Atiende').val()
                dato['Reporta'] = $('#Reporta').val()
                dato['Gru_Atiende'] = $('#Gru_Atiende').val()
                dato['Gru_Todos'] = $('#Gru_Todos').val()
		  		dato['Prov_Atiende'] = $('#Prov_Atiende').val()
                dato['Prov_Reporta'] = $('#Prov_Reporta').val()
		  		dato['iqCli_ID'] = $('#iqCli_ID').val()
                dato['InsT_ID'] = $('.InsT_IDPadre').val()

		         $("#dvTablaIncidencias").load("/pz/wms/Incidencias/CTLGRAL_Incidencias_Grid.asp",dato);

	   });
    
});    
     function MostrarGruposAti(){
			   if($(".ChkGruposAt").is(':checked')){
  			     $(".ChkProvAt").prop("checked", false);  
  			     $(".ChkGrupos").prop("checked", false);  
				 $('#Atiende').hide('slow')
				 $('#Prov_Atiende').hide('slow')
  			     $('#Gru_Atiende').show('slow')
				 $('#Gru_Todos').hide('slow')
     		     $("#lblVariable").html('Atendiendo:')
				  }else{
				  $('#Gru_Atiende').hide('slow')
				  $('#Atiende').show('slow')
				 }
		 }
 function MostrarGruposRep(){
			   if($(".ChkGruposRe").is(':checked')){
  			     $(".ChkProvAt").prop("checked", false);  
 			     $(".ChkGrupos").prop("checked", false);  
				 $('#Reporta').hide('slow')
				 $('#Prov_Reporta').hide('slow')
  			     $('#Gru_Reporta').show('slow')
				 $('#Gru_Todos').hide('slow')
				 $("#lblVariable").html('Reporta:')
				  }else{
				  $('#Gru_Reporta').hide('slow')
				  $('#Reporta').show('slow')
				 }
		 }
    function MostrarProvAti(){
			   if($(".ChkProvAt").is(':checked')){
			     $(".ChkGruposAt").prop("checked", false);  
				 $('#Atiende').hide('slow')
 			     $('#Gru_Atiende').hide('slow')
				 $('#Prov_Atiende').show('slow')
				 $("#lblVariable").html('Atendiendo:')
				  }else{
				  $('#Prov_Atiende').hide('slow')
				  $('#Atiende').show('slow')
				 }
		 }
     function MostrarProvRep(){
			   if($(".ChkProvRe").is(':checked')){
   			     $(".ChkGruposRe").prop("checked", false);  
   				 $('#Reporta').hide('slow')
   			     $('#Gru_Reporta').hide('slow')
   				 $('#Prov_Reporta').show('slow')
				 $("#lblVariable").html('Reporta:')
				  }else{
				  $('#Prov_Reporta').hide('slow')
				  $('#Reporta').show('slow')
				 }
		 }
     function MostrarGrupos(){
			   if($(".ChkGrupos").is(':checked')){
  			     $(".ChkGruposAt").prop("checked", false);  
  			     $(".ChkGruposRe").prop("checked", false);  
				 $('#Atiende').hide('slow')
				 $('#Prov_Atiende').hide('slow')
   				 $('#Gru_Atiende').hide('slow')
  			     $('#Gru_Todos').show('slow')
				 $("#lblVariable").html('Grupo:')
				  }else{
				  $('#Gru_Todos').hide('slow')
				  $('#Atiende').show('slow')
  				  $("#lblVariable").html('Atendiendo')
				 }
		 }
    function CargaTipoInicial(){
   var dato = {}
         dato['Tarea'] = 25
		$("#divPadre").load("/pz/wms/Incidencias/Incidencias_Ajax.asp",dato);

    }
        
</script>



