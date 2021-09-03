<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 2 2021-JUN-04 Estatus de Tienda: Se agrega Redireccionamiento de Ventana de estatus de tienda.

var TA_ID =""
%>

<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
   
<div id="wrapper">
  <div class="wrapper wrapper-content">    
    <div class="row">
      <div class="col-lg-12">
        
            <div class="ibox-title" id="dvFiltros" >
                     
             <h5>Filtros de b&uacute;squeda: </h5>
            </div>
            <div class="ibox-content">
              
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                        <div class="row">
                            <div class="col-sm-1 m-b-xs pull-right">  
                              <button class="btn btn-success btn-sm pull-right" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                         <label class="col-sm-2 control-label">Nombre Tienda:</label>
                         <div class="col-sm-4 m-b-xs">
                            <input class="form-control busTienda" id="Alm_Nombre" placeholder="Nombre de tienda" type="text" autocomplete="off" value="" />
                         </div>
                         <label class="col-sm-2 control-label">N&uacute;mero/ C&oacute;digo de tienda:</label>
                         <div class="col-sm-4 m-b-xs">
                            <input class="form-control numTienda" placeholder="Numero o codigo de tienda" type="text" autocomplete="off" value="" />
                         </div>
                    </div>    
                </div>
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                   
                        
                        <label class="col-sm-2 control-label">Cliente:</label>
                        <div class="col-sm-4 m-b-xs" >
							<% 
                                var sEventos = "class='form-control combman'"
                                var sCondicion = ""
                                CargaCombo("CboCli_ID", sEventos, "Cli_ID","Cli_Nombre","Cliente",sCondicion,"","Editar",0,"--Seleccionar--")
                            %>
                        </div>
                        <label class="col-sm-2 control-label">Tipo de Tienda:</label>
                        <div class="col-sm-4 m-b-xs">
							<%  
                                var sEventos = "class='form-control combman'"
                                ComboSeccion("CboTTienda_ID", sEventos, 84, -1, 0, "--Seleccionar--", "", "Editar")
                            %>
                        </div>
                    </div>    
                </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <label class="col-sm-2 control-label">Tipo de Ruta:</label>
                        <div class="col-sm-4 m-b-xs">
							<%  
                                var sEventos = "class='form-control combman'"
                                ComboSeccion("CboTRuta_ID", sEventos, 94, -1, 0, "--Seleccionar--", "", "Editar")
                            %>
                        </div>
                        <label class="col-sm-2 control-label">Ruta:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <select id="cboRuta" class="form-control agenda">
                                <option value="-1" >--Seleccionar--</option>
						<%  
                        
                            var sSQL = "SELECT  DISTINCT Alm_Ruta, ('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta	"
                                    + " FROM Almacen "
                                    + " WHERE Alm_Ruta > 0 "
                                    + " AND Alm_ID in ( SELECT TA_End_Warehouse_ID "
                                    +                   " FROM TransferenciaAlmacen "
                                    +                  " WHERE TA_EstatusCG51 = 4 ) "
                                    + " Order By Alm_Ruta "
                           
                            var rsRuta = AbreTabla(sSQL,1,0)
                                    
                            while (!rsRuta.EOF){
                        %>
                               <option value="<%=rsRuta.Fields.Item("Alm_Ruta").Value%>" >
                                       <%=rsRuta.Fields.Item("Ruta").Value%></option>
                        <%	
                                rsRuta.MoveNext() 
                                }
                            rsRuta.Close()   	
                        %>
                        	</select>
                        </div>
                       
                    
                </div>
            </div>     
                            
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                <label class="col-sm-2 control-label">Estado:</label>
                    <div class="col-sm-4 m-b-xs" >
				<%
                    var sEventos = "class='form-control combman'"
                    var sCondicion = " Edo_ID in ( Select Distinct Edo_ID "
                                + " from TransferenciaAlmacen t, Almacen a "
                                + " where t.TA_End_Warehouse_ID = a.Alm_ID "
                                + " AND t.TA_EstatusCG51 = 4 )"
                
                    CargaCombo( "CboEdo_ID",sEventos,"Edo_ID","Edo_Nombre","Cat_Estado",sCondicion,"","Editar",0
                               ,"--Seleccionar--")
                %>
                         
                </div>
                
                        <label class="col-sm-2 control-label">Aeropuerto:</label>
                        <div class="col-sm-4 m-b-xs" id="dvAeroptos">
						<%
                             
                            var sEventos = "class='form-control combman'"
                            var sCondicion = " Edo_ID = -1 "
                                        + " or Edo_ID in ( Select Distinct Edo_ID "
                                        + " from TransferenciaAlmacen t, Almacen a "
                                        + " where t.TA_End_Warehouse_ID = a.Alm_ID "
                                        + " AND t.TA_EstatusCG51 = 4 )"
                           
                            CargaCombo("CboAer_ID",sEventos,"Aer_ID","Aer_NombreAG","Cat_Aeropuerto",sCondicion,"","Editar",0,"--Seleccionar--")
                        %>
                        </div>
                    
                           </div>
            </div>
            <!--<div class="row">
                <div class="col-sm-12 m-b-xs">
                        <label class="col-sm-2 control-label">Rango fechas:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            
                        </div>
 
                </div>
            </div>-->

           <div class="dvCargando">
               <div class="spiner-example">
                <div class="sk-spinner sk-spinner-three-bounce">
                    <div class="sk-bounce1"></div>
                    <div class="sk-bounce2"></div>
                    <div class="sk-bounce3"></div>
                </div>
            </div>
           </div>
           <div class="table-responsive dvTabla" id="dvTabla"></div>  
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>


              
          
        
<input type="hidden" name="Alm_ID" id="Alm_ID" value="-1">
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />

<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="application/javascript">



		
$(document).ready(function(){
    
    $(".dvCargando").hide('slow')
   
	//$("#dvTabla").load("/pz/wms/Almacen/Busqueda_Almacen_Grid.asp");
   
    $(".combman").select2(); 

    $('#CboEdo_ID').change(function(e) {
        e.preventDefault()
        var dato = {
				Edo_ID:$('#CboEdo_ID').val(),
				Tarea:1
			}
		$("#dvAeroptos").load("/pz/wms/Almacen/Almacen_Ajax.asp", dato);
        
     });
	
    //$('#FechaBusqueda').daterangepicker({
//			"showDropdowns": true,
//			//"singleDatePicker": true,
//			"firstDay": 7,	
//			"startDate": moment().subtract(29, 'days'),
//			"endDate": moment(),
//            "autoApply": true,
//			"ranges": {
//			   'Al dia de hoy': [moment().startOf('month'), moment()],
//			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
//			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
//			                , moment().subtract(1, 'month').endOf('month')],		   
//			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
//			   '+- 7 Dias': [moment().subtract(6, 'days'), moment().add(7, 'days')],
//			   '+- 30 Dias': [moment().subtract(29, 'days'), moment().add(30, 'days')],
//			   'Siguientes 60 Dias': [moment().startOf('month'), moment().add(60, 'days')]
//			},			
//			"locale": {
//				"format": "DD/MM/YYYY", 
//				"separator": " - ",
//				"applyLabel": "Aplicar",
//				"cancelLabel": "Cancelar",
//				"fromLabel": "Desde",
//				"toLabel": "Hasta",
//				"customRangeLabel": "Personalizado",
//				"weekLabel": "W",
//				"daysOfWeek": ["Do","Lu","Ma","Mi","Ju","Vi","Sa"],
//				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio"
//				               ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
//			//"alwaysShowCalendars": true,	
//			}}, function(start, end, label) {
//				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
//				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
//                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
//            })
      
	$("#btnBuscar").click(function(event) {
		AlmacenFunciones.CargaGrid();
	});
	   
	$('.numTienda').on('keypress',function(e) {
		if(e.which == 13) {
			AlmacenFunciones.CargaGrid()
		}
	});

	$('.busTienda').on('keypress',function(e) {
		if(e.which == 13) {
			AlmacenFunciones.CargaGrid()
		}
	});

	
});    

var AlmacenFunciones = {
		CargaFicha:function(almid){
            $("#Alm_ID").val(almid)
            CambiaSiguienteVentana()
		},
		CargaGrid:function(){
			var Request = {
                Lpp:1,  //este parametro limpia el cache
                Alm_Nombre: $("#Alm_Nombre").val(),
				Cli_ID:$('#CboCli_ID').val(),
				Aer_ID:$('#CboAer_ID').val(),
				Numero:$('.numTienda').val(),
				T_Tienda:$('#CboTTienda_ID').val(),
				Ruta:$('#cboRuta').val(),
				Edo_ID:$('#CboEdo_ID').val(),
				T_Ruta:$('#CboTRuta_ID').val(),
				Tarea:1
			}			
			$("#dvTabla").load("/pz/wms/Almacen/Busqueda_Almacen_Grid.asp",Request,function(){
			$(".dvCargando").hide('slow')});
		}
}
  
<% // HA ID: 2 INI Se agrega función de redireccionamiento de Ventana a Estatus de Tienda.
%>

var Almacen = {
    Estatus: {
        Redireccionar: function(prmJson){
            var intAlm_ID = prmJson.Alm_ID;

            if( $("#Alm_ID").length == 0 ){
                
                var objAlm = "<input type='hidden' id='Alm_ID'>"

                $("#wrapper").append( objAlm );
            } 

            $("#Alm_ID").val(intAlm_ID);

            CambiaVentana(19, 2534);

        }
    }
}

<% // HA ID: 2 FIN
%>
  
</script>




