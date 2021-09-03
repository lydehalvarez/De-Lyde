<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 2 2021-JUN-04 Estatus de Tienda: Se agrega Redireccionamiento de Ventana de estatus de tienda.
// HA ID: 3 2021-JUN-15 Paginación: Se agrega paginación fragmentada.

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
                <div class="ibox-tools">
                    <button class="btn btn-white btn-sm" type="button" id="btnLimpiar">
                        <i class="fa fa-trash-o"></i> Limpiar
                    </button>
                    <button class="btn btn-success btn-sm" type="button" id="btnBuscar">
                        <i class="fa fa-search"></i> Buscar
                    </button>
                </div>
            </div>
            <div class="ibox-content">
              
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
                        
<%
                    var sEventos = "class='form-control combman'"
                    var sCondicion = "Alm_Ruta not in (0) AND Alm_Ruta is not null"
                
                    CargaCombo( "cboRuta",sEventos,"DISTINCT Alm_Ruta","'R '+CAST(Alm_Ruta as nvarchar)","Almacen",sCondicion,"Alm_Ruta","Editar",0
                               ,"--Seleccionar--")

/*%>                            <select id="cboRuta" class="form-control agenda">
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
<%*/%>                        </div>
                       
                    
                </div>
            </div>     
                            
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                <label class="col-sm-2 control-label">Estado:</label>
                    <div class="col-sm-4 m-b-xs" >
				<%
                    var sEventos = "class='form-control combman'"
//                    var sCondicion = " Edo_ID in ( Select Distinct Edo_ID "
//                                + " from TransferenciaAlmacen t, Almacen a "
//                                + " where t.TA_End_Warehouse_ID = a.Alm_ID "
//                                + " AND t.TA_EstatusCG51 = 4 )"
                
                    CargaCombo( "CboEdo_ID",sEventos,"Edo_ID","Edo_Nombre","Cat_Estado","","Edo_Nombre","Editar",0
                               ,"--Seleccionar--")
                %>
                         
                </div>
                
                        <label class="col-sm-2 control-label">Aeropuerto:</label>
                        <div class="col-sm-4 m-b-xs" id="dvAeroptos">
						<%
                             
                            var sEventos = "class='form-control combman'"
//                            var sCondicion = " Edo_ID = -1 "
//                                        + " or Edo_ID in ( Select Distinct Edo_ID "
//                                        + " from TransferenciaAlmacen t, Almacen a "
//                                        + " where t.TA_End_Warehouse_ID = a.Alm_ID "
//                                        + " AND t.TA_EstatusCG51 = 4 )"
                           
                            CargaCombo("CboAer_ID",sEventos,"Aer_ID","Aer_NombreAG","Cat_Aeropuerto","","Aer_ID","Editar",0,"--Seleccionar--")
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

<% // HA ID: 3 Se actualiza boton con nuevo método búsqueda
%>
    $("#btnBuscar").on("click", function(){
        Almacen.Buscar.ListadoBuscar();
    })

    $("#btnLimpiar").on("click", function(){
        Almacen.Buscar.FiltrosLimpiar();
    });
    /*  
	$("#btnBuscar").click(function(event) {
		AlmacenFunciones.CargaGrid();
	});
	*/ 
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

<% // HA ID: 3 Se cancela método de Carga de Grid por nuevo proceso de paginación
%>
var AlmacenFunciones = {
        CargaFicha:function(almid){
            $("#Alm_ID").val(almid)
            CambiaSiguienteVentana()
		}
        /*,
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
        */
}
<% 

    // HA ID: 2 INI Se agrega función de redireccionamiento de Ventana a Estatus de Tienda.
    // HA ID: 3 INI Se agrega script de paginación
%>

var Almacen = {
      url: "/pz/wms/Almacen/"
    , Buscar: {
          RegistrosPagina: 50
        , Filtros: {
              Almacen: ""
            , Numero: ""
            , Cliente: -1
            , TipoTienda: -1
            , TipoRuta: -1
            , Ruta: -1
            , Estado: -1
            , Aeropuerto: -1
        }
        , FiltrosLimpiar: function(){

            $("#Alm_Nombre").val("");
            $('#CboCli_ID').val("-1");
            $('#CboAer_ID').val("-1");
            $('.numTienda').val("");
            $('#CboTTienda_ID').val("-1");
            $('#cboRuta').val("-1");
            $('#CboEdo_ID').val("-1");
            $('#CboTRuta_ID').val("-1");

            $("#select2-CboCli_ID-container").text("--Seleccionar--");
            $("#select2-CboAer_ID-container").text("--Seleccionar--");
            $("#select2-CboTTienda_ID-container").text("--Seleccionar--");
           
            $("#select2-cboRuta-container").text("--Seleccionar--");
            $("#select2-CboEdo_ID-container").text("--Seleccionar--");
            $("#select2-CboTRuta_ID-container").text("--Seleccionar--");

            with(Almacen.Buscar.Filtros){
                Almacen = "";
                Numero = "";
                Cliente = -1;
                TipoTienda = -1;
                TipoRuta = -1;
                Ruta = -1;
                Estado = -1;
                Aeropuerto = -1;
            }
        }
        , ListadoBuscar: function(){

            with(Almacen.Buscar.Filtros){
                Almacen = $("#Alm_Nombre").val();
                Numero = $('.numTienda').val();
                Cliente = $('#CboCli_ID').val();
                TipoTienda = $('#CboTTienda_ID').val();
                TipoRuta = $('#CboTRuta_ID').val();
                Ruta = $('#cboRuta').val();
                Estado = $('#CboEdo_ID').val();
                Aeropuerto = $('#CboAer_ID').val();
            }

            Almacen.Buscar.ListadoCargar( true );
        }
        , ListadoCargar: function( prmBolIniBus ){
            var intReg =  $(".cssRegAlm").length;
            var intSigReg = ( prmBolIniBus ) ? 0: intReg;
            var intRegPags = $("#inpRegPag").val();

            var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? Almacen.Buscar.RegistrosPagina : intRegPags;

            $(".dvCargando").show('slow');

            $.ajax({
                url: Almacen.url + "Busqueda_Almacen_Grid.asp"
                , method: "post"
                , async: true
                , data: {
                      Lpp: 1  //este parametro limpia el cache
                    , Alm_Nombre: Almacen.Buscar.Filtros.Almacen
                    , Cli_ID: Almacen.Buscar.Filtros.Cliente 
                    , Aer_ID: Almacen.Buscar.Filtros.Aeropuerto
                    , Numero: Almacen.Buscar.Filtros.Numero
                    , T_Tienda: Almacen.Buscar.Filtros.TipoTienda
                    , Ruta: Almacen.Buscar.Filtros.Ruta
                    , Edo_ID: Almacen.Buscar.Filtros.Estado
                    , T_Ruta: Almacen.Buscar.Filtros.TipoRuta
                    , Tarea: 1
                    , SiguienteRegistro: intSigReg
                    , RegistrosPagina: intRegPag
                }
                , success: function( res ){

                    if( prmBolIniBus ){
                        $("#dvTabla").html( res );
                    } else {
                        $("#tbReg").append( $("#tbReg tr", res) );
                    }

                    var objMas = "";

                    if( $(".cssRegAlm", res).length != 0 ){

                        objMas = "<div class='row'>"
                                + "<div class='col-sm-8'>"
                                    + "<button type='button' class='btn btn-white btn-block' onClick='Almacen.Buscar.ListadoCargar()'>"
                                        + "<i class='fa fa-arrow-down'></i> Ver mas"
                                    + "</button>" 
                                + "</div>"
                                + "<div class='col-sm-3 input-group'>"
                                    + "<input type='number' id='inpRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='1' value='50' maxlength='3' >"
                                    + "<span class='input-group-addon'> Reg/Pag </span>"
                                + "</div>"
                            + "</div>"

                    } else if( prmBolIniBus ){
                        objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                    }

                    $(".dvCargando").hide('slow');
                    $("#tfReg").html(objMas);
                    
                    Almacen.Buscar.ListadoRegistrosContar();
                    
                }
                , error: function(){
                    Avisa("error", "Almacen - Buscar", "Error en la peticion");
                    $(".dvCargando").hide('slow');
                }
            });

        }
        , ListadoRegistrosContar: function(){
            var intTotReg = $(".cssRegAlm").length;
            $("#lblTotReg").text(intTotReg);
        }
		
    } 
    , Estatus: {
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

<%  // HA ID: 3 FIN
    // HA ID: 2 FIN
%>
  
</script>




