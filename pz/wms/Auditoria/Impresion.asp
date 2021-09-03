<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
/* HA ID: 2 2021-AGO-27 Auditoria Ubicacion: Orden de Impresion */
   
    var bDebIQ = false   
   
    var Aud_ID = Parametro("Aud_ID",-1)

    var iVistaActual = BuscaSoloUnDato("Aud_VisitaActual","Auditorias_Ciclicas","Aud_ID = " + Aud_ID,1,0)
    
    if(bDebIQ){ 
        Response.Write("Aud_ID: " + Aud_ID ) 
    }   
   
%>
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>    
<link href="/Template/inspina/css/animate.css" rel="stylesheet"/>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"/>
<!--#include file="./NuevaAuditoriaCiclica_Modal.asp" -->

<div id="wrapper">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>Filtros de b&uacute;squeda</h5>
                    <div class="ibox-tools"></div>
                    <div class="ibox-content">
                        <div class="form-horizontal">
                            <!--div class="form-group">
                                <label class="col-sm-2 control-label">Tipo conteo:</label>
                                <div class="col-sm-4">
                                    <% /*
                                        var sEventos = " class='input-sm form-control cbo2' style='width:200px'";
                                        var sCondicion = " Sec_ID = 142 ";
                                        CargaCombo("AudU_TipoConteoCG142", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Seleccione", "Editar");
                                       */
                                    %>
                                </div>
                                <label class="col-sm-2 control-label">Pasillo:</label>
                                    <% /*
                                        var sEventos = " class='input-sm form-control cbo2' style='width:200px'";
                                        var sCondicion = " Sec_ID = 142 ";
                                        CargaCombo("AudU_TipoConteoCG142", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Seleccione", "Editar");
                                       */
                                    %>                                    
                            </div-->
                            <div class="form-group">
                                <label class="col-sm-2 control-label">Auditor:</label>
                                <div class="col-sm-4">
                                    <% 
                                        var sEventos = " class='input-sm form-control cbo2' style='width:300px'"
                                        var sCondicion = "Usu_ID IN (SELECT Usu_ID FROM Auditorias_Auditores "
                                            sCondicion += " WHERE Aud_Habilitado = 1 AND Aud_ID = "+Aud_ID+") "
                                            sCondicion += " AND Usu_Habilitado = 1 "
                                        CargaCombo("cbAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario", sCondicion, "Usu_Nombre", -1, 0, "Todos", "Editar")
                                       
                                    %>
                                </div>
                                <label class="col-sm-2 control-label">Estatus:</label>
                                <div class="col-sm-4">    
                                <% 
                                    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                    var sCondicion = " Sec_ID = 147 ";
                                    CargaCombo("cbEstatus", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                %>
                                </div>   
                            </div>
                                        
                            <div class="form-group">
                                <label class="col-sm-2 control-label">Ubicaci&oacute;n:</label>
                                <div class="col-sm-4">
                                    <% 
                                    var sEventos = " class='input-sm form-control cbo2' style='width:300px'"
                                    var sCondicion = "Ubi_ID IN (SELECT APAL.Ubi_ID FROM Auditorias_Pallet APAL "
                                        sCondicion += " WHERE APAL.Pt_ID IN (SELECT AUBI.Pt_ID FROM Auditorias_Ubicacion AUBI "
                                        sCondicion += "     WHERE AUBI.Aud_ID = APAL.Aud_ID AND AUBI.Pt_ID = APAL.Pt_ID  "
                                        sCondicion += " AND APAL.Aud_ID = " + Aud_ID + "))"
                                   
                                        CargaCombo("cbUbicacion", sEventos, "Ubi_ID", "Ubi_Nombre", "Ubicacion UBIP", sCondicion, "Inm_ID, Are_ID, Rac_ID, Ubi_Nivel, Ubi_Seccion, Ubi_Profundidad", -1, 0, "Todos", "Editar")
                                       
                                    %>
                                </div>
                                <label class="col-sm-2 control-label">SKU:</label>
                                <div class="col-sm-4">    
                                    <select name="cbSku" id="cbSku" class='input-sm form-control cbo2' style='width:200px'>
                                        <% 
                                            
                                            var sEventos = " class='input-sm form-control cbo2' style='width:200px'"
                                            var sCondicion = ""

                                            var sAll = "Todos"
                                           
                                                if (sAll != "") {
                                                    sElemento = "<option value='-1'"
                                                    if (Parametro("cbAudUVeces",-1) == -1) { sElemento += " selected " }
                                                    sElemento += ">"+sAll+"</option>"

                                                    Response.Write(sElemento)
                                                }                                               
                                           
                                            var sSQLSKU = "SELECT ISNULL(Pt_Sku,'') FROM (SELECT DISTINCT(Pt_SKU) "
                                                sSQLSKU += "FROM Auditorias_Pallet AI WHERE AI.Aud_ID ="+Aud_ID+") "
                                                sSQLSKU += "Auditorias_Pallet "
                                                //Response.Write(sSQLSKU)
                                                //Response.End()
                                           	 var sArmaCbo = ""
                                             var sSelec = Parametro("cbSku",-1)
                                             
                                             var rssku = AbreTabla(sSQLSKU,1,0)
                                                  
                                             while (!rssku.EOF){
                                                 sArmaCbo = "<option value='"+ rssku.Fields.Item(0).Value + "'"

                                                 if (sSelec == rssku.Fields.Item(0).Value) {
                                                     sArmaCbo += " selected "
                                                 }
                                                 sArmaCbo += ">" + rssku.Fields.Item(0).Value + "</option>"

                                                 Response.Write(sArmaCbo)

                                                 rssku.MoveNext()
                                             }
                                           
                                             rssku.Close()  
                                             
                                         %>
                                        </select>
                                </div>   
                            </div>
                                    
                                    
                            <div class="form-group">
                                <label class="col-sm-2 control-label">Conteo:</label>
                                <div class="col-sm-4">
                                    <select name="cbAudUVeces" id="cbAudUVeces" class='input-sm form-control cbo2' style='width:200px'>
                                        <% 
											 var ij = 1
											 for(var i=1;i<=iVistaActual;i++){
                                                 sArmaCbo = "<option value='"+ i + "'"

                                                 if (iVistaActual == i) {
                                                     sArmaCbo += " selected "
                                                 }
                                                 sArmaCbo += ">" + i + "</option>"

                                                 Response.Write(sArmaCbo)
                                             }
                                             
                                         %>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">Selecci&oacute;n:</label>
                                <div class="col-sm-4">
                                    <input type="radio" name="TipoImpresion" value="1"> hoja
                                    <input name="TipoImpresion" type="radio" value="2" checked="checked"> papeleta
                                </div>   
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">LPN:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control input-sm" id="LPN" name="LPN" value="">
                                </div>
                                <label class="col-sm-3 control-label">Bloque de impresi&oacute;n:</label>
                                <div class="col-sm-2">    
                                    <input type="text" class="form-control input-sm" id="AudU_Impreso" name="AudU_Impreso" value="">
                                </div>   
                            </div>                                
                            <div class="form-group">
                                <div class="col-sm-12">

                                <% /* HA ID: 2 INI Se agrega ordenacion de ubicaciones */ %>
                                    <label class="col-sm-2 control-label">
                                        Imprimir Ordenado por Ubicaci&oacute;n
                                    </label>
                                    <div class="col-sm-2">
                                        <input type="checkbox" id="chkUbiOrd" title="Ordenar Ubicacion">
                                    </div>
                                <% /* HA ID: 2 FIN */ %>

                                    <div class="col-sm-2"></div>
                                    <div class="col-sm-2 m-b-xs" style="text-align: left;">
                                        <button class="btn btn-primary btn-sm" type="button" id="btnAsignar"><i class="fa fa-check-square-o"></i>&nbsp;&nbsp;<span class="bold">Asignar</span></button>
                                    </div>
                                     <div class="col-sm-2 m-b-xs" style="text-align: left;">
                                        <button class="btn btn-primary btn-sm" type="button" id="btnImprimeSelec"><i class="fa fa-print"></i>&nbsp;&nbsp;<span class="bold">Impresi&oacute;n </span></button>
                                    </div>                                   
                                    <!--button class="btn btn-white" type="submit">Cancel</button col-sm-offset-2-->
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                    </div>        
                                </div>
                            </div>                                
                        </div>    
                    </div>
                    <div class="table-responsive" id="dvTablaImpresion"></div>           
                </div>
            </div>    
        </div>
    </div> 
</div>                        

<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

                  
<script type="text/javascript">
    
    var ArrsSelec = [ ]; 
    
    $(document).ready(function() {
        
        $('#btnBuscar').click(function(e){
            e.preventDefault();
            //console.log("ENTRO")
            $('#dvTablaImpresion').html(loading);
            CargarGrid();
            
        });   
        
        $('.cbo2').select2();
        

        //CargarGrid();
        $('#btnImprimeSelec').click(function(e) {
            e.preventDefault();
			
			ArrsSelec = [];
            //Selecciono los valores de los PtIDs a imrprimir seleccionados
            $('.chkPtID:checked').each(function(){
                ArrsSelec.push($(this).val());
            });
            
            Imprimir();
                        
        });
        
    });
    
    function Imprimir(){
    
        var sPtIIDs = "";
        var iCantidadAImprimir = 0;
        //Cantidad de lote a manejar -- 50
        var iTotalARecorrer = 100;
        var iTipoImpHojaPape = $("input[name='TipoImpresion']:checked").val();
        var iAud_ID = $("#Aud_ID").val();

        //Manejo de validaciones {start}
		var bolError = false;
		var arrError = [];
		
		if( iAud_ID == "" ){
			bolError = true
			arrError.push("Identificador de la Auditoria no permitido");
		}
		
		if( !(ArrsSelec.length > 0) ){
			bolError = true
			arrError.push("Seleccionar al menos una Ubicacion");
		}
		
		if( !(iTipoImpHojaPape > 0) ){
			bolError = true
			arrError.push("Seleccionar el tipo de Impresion");
		}
		
        if( bolError ){
			
			Avisa("warning", "Impresion", "Verificar formulario<br>" + arrError.join("<br>"));
			
		} else {  //Manejo de validaciones {end}
			
			 //selecion de cantidad paquete
			if(ArrsSelec.length < iTotalARecorrer){
				iCantidadAImprimir = ArrsSelec.length;
			} else {
				iCantidadAImprimir = iTotalARecorrer;
			}
	
			//console.log("TipoHojaOPapeleta:" + iTipoImpHojaPape + " | iAud_ID: "+ iAud_ID);
			//console.log("iCantidadAImprimir",iCantidadAImprimir);
	
			//extraccion de identificadores del paqute
			var arrExt = [];
			arrExt = ArrsSelec.splice(0,iCantidadAImprimir);
			sPtIIDs = arrExt.join(",");
	
			// console.log("ArrsSelec", ArrsSelec);
			// console.log("arrExt", arrExt);        

            <% /* HA ID: 2 Agregado de Validacion */ %>
            var OrdenarUbicacion = ( ( $("#chkUbiOrd").is(":checked") ) ? 1 : 0 );
			
			var prm = "Aud_ID="+iAud_ID+"&PT_ID="+sPtIIDs+"&vez=<%=iVistaActual%>&OrdenarUbicacion="+OrdenarUbicacion
			var prp = "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=1200,height=800"
			var url = "";
			
			if (iTipoImpHojaPape == 1){
				url = "/pz/wms/Auditoria/Impresion_Papeleta_Grid.asp?" + prm;
			} else if (iTipoImpHojaPape == 2){
				url = "/pz/wms/Auditoria/Impresion_Papeleta_Veces.asp?" + prm;
			}
			/*
			console.log(prm)
			console.log(prp)
			console.log(url)
			*/
			
			window.open(url,"_blank", prp); 
			
			//console.log("ArrsSelec.length",ArrsSelec.length );
			//console.log("ArrsSelec[0]",ArrsSelec[0]);
			
			$(".chkPtID:checked").each(function(){
				if (arrExt.length > 0){
					for(var i=0; i<arrExt.length;i++){
                        //console.log("Num: " + i);
						if( $(this).val()+"" == arrExt[i]+"" ){
                            //console.log($(this).val() + " | arrExt " + arrExt[i]);
							$(this).prop("checked", false);
                            $(".chkTodos").prop("checked",false);
							arrExt.splice(arrExt.indexOf(arrExt[i]),1);
						}
					}
				}
			});
			
			if( parseInt(ArrsSelec.length) > 0){
				
				swal({
					title: "Impresiones", 
					text: "Desea continuar con la impresi&oacute;n?",
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					confirmButtonText: "Si, continuar!",
					cancelButtonText: "No, cancelar!",
					closeOnConfirm: false,
					closeOnCancel: false,
					html: true
				},
				function (isConfirm) {
					if (isConfirm) {
						Imprimir();
					} else {
						ArrsSelec = [];
						swal.close();
                        //console.log("Recargamos para que se muestren los valores del bloque de impresión!!");
                        //Al cancelar Cargamos el grid
                        //CargarGrid();
					}
					
				});
				
			}  else {
				swal.close();
				ArrsSelec = [];
                //alert("Recarga Grid!!");
                //CargarGrid();
			}
			
		}
        
    }
        
    function RecepImprimeHojaOPapeleta(a,t,p){
        var ivez = arguments[3];
        if(t == 1){
            var newWin=window.open("/pz/wms/Auditoria/Impresion_Papeleta_Grid.asp?Aud_ID="+a+"&PT_ID="+p+"&vez="+ivez);
        }

        if(t == 2){
           var newWin=window.open("/pz/wms/Auditoria/Impresion_Papeleta_Veces.asp?Aud_ID="+a+"&PT_ID="+p);
            
        }
    }    
    
    
var loading = '<div class="spiner-example">'+
				'<div class="sk-spinner sk-spinner-three-bounce">'+
					'<div class="sk-bounce1"></div>'+
					'<div class="sk-bounce2"></div>'+
					'<div class="sk-bounce3"></div>'+
				'</div>'+
			'</div>'+
			'<div>Cargando informaci&oacute;n, espere un momento...</div>'

    
    function CargarGrid() {
        
        
        //$("#dvTablaImpresion").empty();    
        
        var datos = {
                Lpp:1,
                Aud_ID:$('#Aud_ID').val(),
                AudU_AsignadoA:$('#cbAuditor').val(),
                AudU_TipoConteoCG142:$('#AudU_TipoConteoCG142').val(),
                Ubi_ID:$('#cbUbicacion').val(),
                Pt_SKU:$('#cbSku').val(),
                LPN:$('#LPN').val(),
                AudU_Impreso:$('#AudU_Impreso').val(),
                AudU_Veces:$('#cbAudUVeces').val(),
                Pt_ResultadoCG147:$('#cbEstatus').val()

                <% /* HA ID: 2 Agregado de Validacion */ %>
                , OrdenarUbicacion: ( ( $("#chkUbiOrd").is(":checked") ) ? 1 : 0 )
            }
         
        $('#dvTablaImpresion').hide('slow');
        $("#dvTablaImpresion").html(loading);
        
        $("#dvTablaImpresion").load("/pz/wms/Auditoria/Impresion_Grid.asp",datos);
        $("#dvTablaImpresion").show('slow');
        
    }
    
</script>
