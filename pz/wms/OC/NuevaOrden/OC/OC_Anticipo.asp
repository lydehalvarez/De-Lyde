<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var Prov_ID = Parametro("Prov_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var ProT_ID = Parametro("ProT_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)	
	
 var sSQL  = " SELECT * " 
	 sSQL += " ,(CONVERT(NVARCHAR(20),OC_FechaRequerida,103)) as FechaRequerida "
	 sSQL += " FROM OrdenCompra " 
	 sSQL += " WHERE Prov_ID = " + Prov_ID
	 sSQL += " AND OC_ID = " + OC_ID
 
	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0)

	var Hoy = ""
	
	var OC_EstatusCG51 = Parametro("OC_EstatusCG51",0)
	
 var Et1 = ""
 var Et2 = ""
 var Et3 = "" 
 
 if(OC_EstatusCG51 < 3) Et1 = " active "  
 if(OC_EstatusCG51 == 5) Et2 = " active " 
 if(OC_EstatusCG51 == 3) Et3 = " active "
 
	
%>
<style type="text/css">
.btn-info {margin-left:15px;margin-right:15px;}
.btn-danger {margin-left:15px;margin-right:15px;}
.btn-outline {margin-left:15px;margin-right:15px;}

	
	
</style>    
<!--div class="ibox-content" style="overflow-y: overlay;" -->
    <div class="ibox" style="overflow-y: overlay;">
        <div class="col-md-12 forum-item active">
             <div class="ibox-title">
                <span class="pull-right"><h2>Folio <%=Parametro("OC_Folio","")%></h2></span>
                <h5>Solicitude de Anticipo
                <br /> <small><br /></small>
                </h5> 
            </div>
             <div class="ibox-title">            
                  <div class="btn-group col-md-offset-7 col-md-5" style="margin-bottom:15px" >
                    <button type="button" class="btn btn-outline btnEstatus btn-info<%=Et1%>" data-estatusid="1">Nueva</button>
                    <button type="button" class="btn btn-outline btnEstatus btn-danger<%=Et2%>" data-estatusid="5">Cancelar</button>
                    <button type="button" class="btn btn-outline btnEstatus btn-primary<%=Et3%>" data-estatusid="3">Solicitar pago</button>
                  </div>
            </div> 
 
        <div class="ibox-content">
        <div class="col-md-offset-6 col-md-6" id="areabotones" style="text-align: right;margin-bottom:15px;">
            <button type="button" class="btn btn-success" id="btnGuardar" onclick="javascript:GuardarOCAnticipo();">
            	<i class="fa fa-save"> </i> Guardar cambios&nbsp;
            </button>
        </div>         
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">                
                    	<label class="col-md-2 control-label" id="lblCom_ID">Compa&ntilde;&iacute;a</label>
                		<div class="col-md-10">
<%
	var sEventos = " class='form-control objCBO' onchange='javascript:CambioCompania()' "
	var sCondicion = ""
	CargaCombo("Com_ID",sEventos,"Com_ID","Com_RazonSocial","Compania",sCondicion,"",Parametro("Com_ID",1),0,"Seleccione una compa&ntilde;&iacute;a","Edicion") 
%><br  />
                		</div>
                	</div>
                </div> 
            </div> 
            
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">                
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblProv_ID">Proveedor</label>
                		<div class="col-md-10">
<%
	var sEventos = " class='form-control objCBO' "
	var sCondicion = ""
	CargaCombo("Prov_ID",sEventos,"Prov_ID","Prov_RazonSocial","Proveedor",sCondicion,"", Parametro("Prov_ID","") ,0,"Seleccione un proveedor","Consulta") 
%><br  />
                		</div>  
                	</div>
                </div> 
            </div> 
            
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">  <br  />              
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblCom_ID">Descripci&oacute;n</label>
                		<div class="col-md-10">
                        	<input type="text" placeholder="Escriba para que ser&aacute; el pago" class="form-control" 
                                   id="OC_Descripcion" value="<%=Parametro("OC_Descripcion","")%>" autocomplete="off" ><br />
                		</div>
                	</div>
                </div> 
            </div>   


            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">                
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblCom_ID">Condiciones de pago</label>
                		<div class="col-md-10">
                        	<input type="text" placeholder="Especifique las condiciones de pago" class="form-control" 
                                   id="OC_CondicionPago" value="<%=Parametro("OC_CondicionPago","")%>" autocomplete="off" ><br />
                		</div>
                	</div>
                </div> 
            </div>     
            
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">                
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblOC_UsuIDSolicita">Solicit&oacute;</label>
                		<div class="col-md-10">
<%
	var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioCombo()' "
	var sCondicion = " Usu_IniciaOC = 1 and Sys_ID = 70 " 
	CargaCombo("OC_UsuIDSolicita",sEventos,"Usu_ID","Usu_Nombre","Usuario",sCondicion,"", Parametro("OC_UsuIDSolicita",-1) ,0,"Seleccione un usuario","Edicion") 
%>
                		</div>
                	</div>
                </div> 
            </div>             
            
			<div class="form-group">       
                <div class="col-md-12">    
                    <div class="row">
                   		<label for="OC_FechaRequerida" class="col-md-2 control-label">Fecha requerida</label>
                        <div class="col-md-4 input-group" id="OC_FechaRequeridaCal1">
                            <input name="OC_FechaRequerida" id="OC_FechaRequerida" placeholder="dd/mm/aaaa" type="text" 
                            data-date-format="dd/mm/yyyy" data-date-viewmode="years" 
                            class="form-control date-picker" value="<%=Parametro("FechaRequerida","")%>"> 
                            <span class="input-group-addon"> <i class="fa fa-calendar"></i></span>
                        </div> 
                   		<div class="col-md-5">
                            &nbsp;
                        </div>                         
                        
                    </div>
                </div>
            </div> 

            <div class="form-group">       
                <div class="col-md-12">    
                    <div class="row">
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblOC_Total">Monto solicitado</label>
                    	<div class="col-md-4">
                        <br  />
                            <input name="OC_Total" id="OC_Total"  type="text" 
                                   class="form-control" value="<%=Parametro("OC_Total",0)%>"> <br  />
                        	
                        </div>
                        <label class="col-md-2 control-label" id="lblTg_ID">&nbsp;</label>
                        <div class="col-md-4">

&nbsp;

                        </div>
                    </div>
                </div>
            </div> 
                               
            <div class="form-group">       
                <div class="col-md-12">    
                    <div class="row">
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblLoc_ID">Localidad</label>
                    	<div class="col-md-4">
                    	
<%
	var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioCombo()' "
	var sCondicion = " Com_ID = 1 " 
	CargaCombo("Loc_ID",sEventos,"Loc_ID","Loc_Nombre","Compania_Localidad",sCondicion,"", Parametro("Loc_ID",-1) ,0,"Seleccione una tienda","Edicion") 
%>
                        	
                        </div>
                        <label class="col-md-2 control-label" id="lblTg_ID">Tipo de gasto</label>
                        <div class="col-md-4">

<%
	var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioCombo()' "
	var sCondicion = " Tg_Habilitado = 1 " 
	CargaCombo("Tg_ID",sEventos,"Tg_ID","Tg_Nombre","Cat_TipoGasto",sCondicion,"Tg_Orden",Parametro("Tg_ID",-1),0,"Seleccione un tipo de gasto","Edicion") 
%>

                        </div>
                    </div>
                </div>
            </div> 
        
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">
                        <label class="col-md-offset-0 col-md-2 control-label" id="lblDep_ID">Departamento</label>
                        <div class="col-md-4">
<%
	var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioCombo()' "
	var sCondicion = " Com_ID = 1 " 
	CargaCombo("Dep_ID",sEventos,"Dep_ID","Dep_Nombre","Compania_Departamento",sCondicion,"Dep_Orden",Parametro("Dep_ID",-1),0,"Seleccione un departamento","Edicion") 
%>

						</div>
                        <label class="col-md-offset-0 col-md-2 control-label" id="lblCC_ID">Centro de costo</label>
                        <div class="col-md-4">
<%
	var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioCombo()' "
	var sCondicion = "" 
	CargaCombo("CC_ID",sEventos,"CC_ID","CC_Nombre","CentroCosto",sCondicion,"CC_Orden",Parametro("CC_ID",-1),0,"Seleccione un centro de costo","Edicion") 
%>

                        </div>
                       
                    </div>
                </div>
            </div>
            
            
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">  <br  />              
                    	<label class="col-md-offset-0 col-md-2 control-label" id="lblOC_Comentarios">Comentarios</label>
               		  <div class="col-md-10">
                            <textarea  id="OC_Comentarios" cols="100%" rows="6"
                            placeholder="Escriba cualquier tipo de comentario sobre este anticipo"><%=Parametro("OC_Comentarios","")%></textarea>
                            <br />
                		</div>
                	</div>
                </div> 
            </div>   
          </div>
        </div>
    </div>    
<!-- /div  -->

<!-- link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" -->
<!-- Date range use moment.js same as full calendar plugin -->
<!-- script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script -->

<!-- Date range picker -->
<!-- script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script -->

<link rel="stylesheet" type="text/css" href="/Template/inspina/js/plugins/bootstrap-datepicker/css/datepicker.css"/>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>

<script type="text/javascript">

	$(document).ready(function() { 

		$("#OC_FechaRequerida").datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});   
		
		$("#OC_FechaRequeridaCal1").click(function(){
			$('#OC_FechaRequerida').data("datepicker").show();
		})

        $(".btnEstatus").click(function(e){
			e.preventDefault()
			var o = $(this)
			$(".btnEstatus").removeClass("active")
			o.addClass("active")
			
			$.post( "/pz/mms/OC/Ajax.asp" 
			   , { Tarea:3,OC_EstatusCG51:o.data("estatusid")
				   ,Prov_ID:$("#Prov_ID").val()			   
				   ,OC_ID:$("#OC_ID").val()	 		   	   
				   ,Usu_ID:$("#IDUsuario").val() }
			   , function(output) { 
					var sMensaje= "Se actualizo el estatus de la orden  de compra correctamente.";
					Avisa("success",'Actualizacion de estatus',sMensaje)	
			});	
			
		}) 

	});	
 

function CambioCompania() {

	$('#btnGuardar').hide("slow")
	
	$.post( "/pz/mms/BPM/Ajax.asp" 
	       , { Tarea:1,Com_ID:$("#Com_ID").val()}
	       , function(output) { 
				var Objeto = $('#Loc_ID');
				Objeto.empty();
				var arrP = new Array(0);
					arrP = output.split(",");   
				$.each(arrP, function(clave,valor) { 
					var sValor = String(valor);
					var arrO = new Array(0);
						arrO = sValor.split(":");
					Objeto.append($('<option></option>').val(arrO[0]).html(arrO[1]));
			 });
			 $("#Loc_ID").val(-1)
		});	
		
	$.post( "/pz/mms/BPM/Ajax.asp" 
	       , { Tarea:2,Com_ID:$("#Com_ID").val()}
	       , function(output) { 
				var Objeto = $('#Dep_ID');
				Objeto.empty();
				var arrP = new Array(0);
					arrP = output.split(",");   
				$.each(arrP, function(clave,valor) { 
					var sValor = String(valor);
					var arrO = new Array(0);
						arrO = sValor.split(":");
					Objeto.append($('<option></option>').val(arrO[0]).html(arrO[1]));
			 });
			 $("#Dep_ID").val(-1)
		});			
		
	$.post( "/pz/mms/BPM/Ajax.asp" 
	       , { Tarea:3,Com_ID:$("#Com_ID").val()}
	       , function(output) { 
				var Objeto = $('#CC_ID');
				Objeto.empty();
				var arrP = new Array(0);
					arrP = output.split(",");   
				$.each(arrP, function(clave,valor) { 
					var sValor = String(valor);
					var arrO = new Array(0);
						arrO = sValor.split(":");
					Objeto.append($('<option></option>').val(arrO[0]).html(arrO[1]));
			 });
			 $("#CC_ID").val(-1)
		});			

}


function GuardarOCAnticipo(){
 
	$.post( "/pz/mms/OC/Ajax.asp" 
	       , { Tarea:2,Com_ID:$("#Com_ID").val()
		       ,OC_Descripcion:$("#OC_Descripcion").val()
			   ,OC_CondicionPago:$("#OC_CondicionPago").val()
			   ,OC_UsuIDSolicita:$("#OC_UsuIDSolicita").val()
			   ,OC_FechaRequerida:$("#OC_FechaRequerida").val()
			   ,OC_Comentarios:$("#OC_Comentarios").val()
			   ,OC_Total:$("#OC_Total").val()			   
			   ,Loc_ID:$("#Loc_ID").val()			   
			   ,Tg_ID:$("#Tg_ID").val()		
			   ,Dep_ID:$("#Dep_ID").val()
			   ,CC_ID:$("#CC_ID").val()	
			   ,Prov_ID:$("#Prov_ID").val()			   
			   ,OC_ID:$("#OC_ID").val()	 		   	   
			   ,Usu_ID:$("#IDUsuario").val() }
	       , function(output) { 
				var sMensaje= "Se actualizo la orden  de compra correctamente.";
			    Avisa("success",'Guardar',sMensaje)	
		});		
}





</script>
