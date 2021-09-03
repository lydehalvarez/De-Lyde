<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
     
	var OC_ID = Parametro("OC_ID",-1)
	var OCParD_ID = Parametro("OCParD_ID",-1) 
	
	var OCParDFecha =""
	var OCParD_Folio = ""	
	var OCParD_Descripcion = ""
	var OCParD_Sucursal = ""	
	var OCParD_Importe = 0
	var OCParD_Impuestos = 0	
	var OCParD_Total = 0
	var OCParD_Comentario = ""	
	var OCParD_UUIDtexto = ""
	var OCParD_Autorizado = 0	
	var OC_BPM_Flujo = 1	

	var sSQL = " SELECT OC_BPM_Flujo "
		sSQL += " FROM OrdenCompra  "
		sSQL += " WHERE OC_ID = " + OC_ID
		//sSQL += " AND OCPar_ID = " + OCPar_ID
	 /*	
var rsVtc = AbreTabla(sSQL,1,0)
if (!rsVtc.EOF){
	OC_BPM_Flujo = rsVtc.Fields.Item("OC_BPM_Flujo").Value
}
   
rsVtc.Close()
*/
	var sSQL = " SELECT OCParD_Fecha, OCParD_Folio, OCParD_Descripcion, OCParD_Comentario, OCParD_Autorizado "
		sSQL += " , OCParD_Sucursal, OCParD_Importe, OCParD_Impuestos, OCParD_Total, OCParD_UUIDtexto "
		sSQL += " , CONVERT(NVARCHAR(20),OCParD_Fecha,103) AS OCParDFecha "
		sSQL += " FROM OrdenCompra r, OrdenCompra_Partida_Detalle d "
		sSQL += " WHERE r.OC_ID = d.OC_ID "
        sSQL += " AND d.OC_ID = " + OC_ID
		sSQL += " AND d.OCParD_ID = " + OCParD_ID		
	 	//Response.Write(sSQL)
        //Response.End()
    var rsVtc = AbreTabla(sSQL,1,0)
    if (!rsVtc.EOF){
        OCParDFecha = rsVtc.Fields.Item("OCParDFecha").Value
        OCParD_Folio = rsVtc.Fields.Item("OCParD_Folio").Value	
        OCParD_Descripcion = rsVtc.Fields.Item("OCParD_Descripcion").Value
        OCParD_UUIDtexto = rsVtc.Fields.Item("OCParD_UUIDtexto").Value	
        OCParD_Sucursal = rsVtc.Fields.Item("OCParD_Sucursal").Value	
        OCParD_Importe = rsVtc.Fields.Item("OCParD_Importe").Value
        OCParD_Impuestos = rsVtc.Fields.Item("OCParD_Impuestos").Value		
        OCParD_Total = rsVtc.Fields.Item("OCParD_Total").Value
        OCParD_Comentario = rsVtc.Fields.Item("OCParD_Comentario").Value
        OCParD_Autorizado = rsVtc.Fields.Item("OCParD_Autorizado").Value
    }
    rsVtc.Close()


%>
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	<h4 class="modal-title">Concepto del gasto</h4><small class="font-bold"></small>
</div>
<div class="modal-body">
<div class="form-horizontal" id="frmFichaEmpViatDet" name="frmFichaEmpViatDet">

        <div class="form-group">
            <div class="col-md-12">
                <div class="row">
                    <label class="col-md-2 control-label"  >Fecha </label>  
                    <div class="col-md-3" id="dateOCParD_Fecha">
                        <div class="input-group date">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
                            <input class="form-control input-sm" id="OCParD_Fecha" 
                            placeholder="dd/mm/yyyy" type="text" 
                            data-validation-engine="validate[required]"
                            value="<%=OCParDFecha%>" readonly>
                        </div>
                    </div>
                    <label class="col-md-2 control-label">Folio </label> 
                    <div class="col-md-3">
                   <input autocomplete="off"  class="form-control" id="OCParD_Folio" 
                          data-validation-engine="validate[required]"
                          type="text" value="<%=OCParD_Folio%>">
                    </div>
                </div>
            </div>
        </div>  
        
        <div class="form-group">
            <div class="col-md-12">
                <div class="row">
                    <label class="col-md-2 control-label" >Descripci&oacute;n</label>
                    <div class="col-md-10">
                        <input autocomplete="off" class="form-control" id="OCParD_Descripcion" 
                               data-validation-engine="validate[required]"
                               type="text" value="<%=OCParD_Descripcion%>">
                    </div>
                </div>
            </div>
        </div>
        
        <div class="form-group">
            <div class="col-md-12">
                <div class="row">
                    <label class="col-md-2 control-label" >Folio fiscal UUID</label>
                    <div class="col-md-10">
                        <input autocomplete="off" class="form-control" id="OCParD_UUIDtexto" 
                               type="text" value="<%=OCParD_UUIDtexto%>">
                    </div>
                </div>
            </div>
        </div>
        
        <div class="form-group">
            <div class="col-md-12">
                <div class="row">
                    <label class="col-md-2 control-label" >Sucursal</label>
                    <div class="col-md-10">
                        <input autocomplete="off" class="form-control" id="OCParD_Sucursal" 
                               data-validation-engine="validate[required]"
                               type="text" value="<%=OCParD_Sucursal%>">
                    </div>
                </div>
            </div>
        </div>        
        

    <div class="form-group">
        <div class="col-md-12">
            <div class="row">
                <label class="col-md-offset-4 col-md-2 control-label" >Importe</label>
                <div class="col-md-4">
                      <input autocomplete="off" data-validation-engine="validate[required,min[1]]"
                            class="form-control mny" id="OCParD_Importe" 
                             type="text" value="<%=OCParD_Importe%>">
                </div>
            </div>
        </div>
    </div>
    
 
<% if(OC_BPM_Flujo > 1 && OC_BPM_Flujo < 6) { %>	
	
    <div class="form-group">
        <div class="col-md-12">
            <div class="col-md-offset-2 col-md-2">
				<input type="checkbox" class="objRdio auth" id="OCParD_Autorizado" 
					   value="<%=OCParD_Autorizado%>" 
					  <% if(OCParD_Autorizado == 1){ Response.Write(" checked ")}  %>>	
						   <label class=" control-label" > Autorizar</label>
			</div> 	
            <div class="row">
                <label class="col-md-2 control-label">Impuestos</label>
				<div class="col-md-4">
                     <input autocomplete="off" class="form-control  validate[required] mny" id="OCParD_Impuestos" 
                            type="text" value="<%=OCParD_Impuestos%>">
				</div> 
            </div>
        </div>
    </div>						   
<% } else { %>	
	
    <div class="form-group"> 
        <div class="col-md-12">
            <div class="row"> 
                <label class="col-md-offset-4 col-md-2 control-label" >Impuestos  <%=OC_BPM_Flujo%></label>
				<div class="col-md-4">
                     <input autocomplete="off" class="form-control mny" id="OCParD_Impuestos" 
                            data-validation-engine="validate[required,custom[number],min[0]]"
                            type="text" value="<%=OCParD_Impuestos%>">
				</div> 

            </div>
        </div>
    </div>
					 
<% } %>				 

    <div class="form-group">
        <div class="col-md-12">
            <div class="row">
                <label class="col-md-offset-4 col-md-2 control-label" >Total</label>
                <div class="col-md-4">
                 <input autocomplete="off" class="form-control mny" id="OCParD_Total" 
                        data-validation-engine="validate[required]"
                        type="text" value="<%=OCParD_Total%>">
                </div>
            </div>
        </div>
    </div>
    
<% if(OC_BPM_Flujo>1) { %>
        <div class="form-group">
            <div class="col-md-12">
                <div class="row">
                    <label class="col-md-2 control-label" >Comentarios</label>
                    <div class="col-md-10">
                        <input autocomplete="off" class="form-control  validate[required]" id="OCParD_Comentario" 
                               type="text" value="<%=OCParD_Comentario%>">
                    </div>
                </div>
            </div>
        </div>		   
							   
<% } %>

</div>
</div> 
<div class="modal-footer">
	<button type="button" class="btn btn-danger btnBorrar btn-sm">Borrar</button> 
	<button type="button" data-dismiss="modal" class="btn btn-info btnCerrar btn-sm">Cerrar</button> 
	<button type="button" class="btn btn-success btnGuardar btn-sm">Guardar</button>
</div>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<script type="text/javascript">    
    
	$(document).ready(function(){  
	
	   $("#frmDatos").validationEngine({
			'custom_error_messages': {
				// Custom Error Messages for Validation Types
				'required': {
					'message': "Este campo no puede estar vacio, es requerido."
				}
				,'custom[url]': {
					'message': "This validation error message will never be called"
				}
				// Custom Error Messages for IDs
				,'#OCParD_Fecha': {
					'message': "Por favor, escriba la fecha del documento"
				}					
				,'#OCParD_Importe': {
					'min': {
						'message': "Este campo debe tener un valor mayor a cero"
					}
				}
			}
		});
 
				   
		$('.input-group.date').datepicker({  
			format: 'dd/mm/yyyy',  
			todayBtn: 'linked',   
			language: 'es',  
			todayHighlight: true,  
			autoclose: true  
		}); 	
		
		$(".btnGuardar").click(function(e) {
			e.preventDefault();
            GuardarDocumento();
		}); 
		
		$(".btnBorrar").click(function(e) {
			e.preventDefault();
            BorrarDocumento();
		}); 	
	
		$(".auth").change(function(e) {
			e.preventDefault();
            Autoriza();
		}); 	
		
		
		$(".mny").change(function(e) {
			
			var monto = 0 
			if( !isNaN(parseFloat($("#OCParD_Importe").val()))) {
			   monto = parseFloat($("#OCParD_Importe").val())
			}
						 
			var imp = 0  
			if( !isNaN(parseFloat($("#OCParD_Impuestos").val()))) {
			   imp = parseFloat($("#OCParD_Impuestos").val())
			}
					  
			var Total = 0 
			if( !isNaN(parseFloat($("#OCParD_Total").val()))) {
			   Total = parseFloat($("#OCParD_Total").val())
			}

			Total = monto + imp
			Total = Total.toFixed(2)
			$("#OCParD_Total").val(Total)

		}); 
			
	 });
	 
	function BorrarDocumento(){

		$.post("/pz/fnd/OC/OrdenCompraDoc_Ajax.asp"
			  ,{ Tarea:3
				,OC_ID:<%=OC_ID%>
				,OCParD_ID:<%=OCParD_ID%>
			   }
			  , function(data){
					$("#OCParD_ID").val(-1);

					if (data == "Borrado" ) {
						sTipo = "info";  
						sMensaje = "El registro fue eliminado correctamente";

						//CargaGrid()  
					    CargaGridFacturas();
						CerrarEsteModal();                           
					  } else {
						sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
					  }
					  Avisa(sTipo,"Aviso",sMensaje);
					});  
			
	}

	
	function Autoriza(){
		
		var EstaAutorizado = 0
		if( $("#OCParD_Autorizado").is(":checked") ) {
			 EstaAutorizado = 1
		} 
		
		$.post("/pz/fnd/OC/OrdenCompraDoc_Ajax.asp"
			  ,{ Tarea:4
				,OC_ID:<%=OC_ID%>
				,OCParD_ID:<%=OCParD_ID%>
				,OCParD_Autorizado:EstaAutorizado
			   }
			  , function(data){ 

			 		if (data == "Autorizado" ) {
						sTipo = "info";  
						sMensaje = "El registro fue autorizado correctamente";                        
					  } else {
						sTipo = "warning";   
						sMensaje = "Se quito la autorizacion ";
					  }
					  Avisa(sTipo,"Aviso",sMensaje);
			
					});  
		
	}					 
						 
	function GuardarDocumento(){
       if ($('#frmDatos').validationEngine('validate')==1) {
		$.post("/pz/fnd/OC/OrdenCompraDoc_Ajax.asp"
			  ,{ Tarea:2
			    ,OC_ID:<%=OC_ID%>
				,OCParD_ID:<%=OCParD_ID%>
				,OCParD_Fecha:$("#OCParD_Fecha").val()
				,OCParD_Folio:$("#OCParD_Folio").val()				
				,OCParD_Descripcion:encodeURIComponent($("#OCParD_Descripcion").val())
				,OCParD_Sucursal:encodeURIComponent($("#OCParD_Sucursal").val())
				,OCParD_UUIDtexto:$("#OCParD_UUIDtexto").val()
<% if(OC_BPM_Flujo>1) { %>
				,OCParD_Comentario:encodeURIComponent($("#OCParD_Comentario").val())
<% } %>
				,OCParD_Importe:$("#OCParD_Importe").val()
				,OCParD_Impuestos:$("#OCParD_Impuestos").val()
				,OCParD_Total:$("#OCParD_Total").val()  
			   }
			  , function(data){

                    $("#OCParD_ID").val(data);

					if (data > -1) {
						sTipo = "info";  
						sMensaje = "El registro fue guardado correctamente";

						//CargaGrid()   
					    CargaGridFacturas();
						CerrarEsteModal();                           
					  } else {
						sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
					  }
					  Avisa(sTipo,"Aviso",sMensaje);
					});  
	}
	}
	
	function CerrarEsteModal() {
		
		$("#OCParD_ID").val(-1);
		$("#ModalConcepto").modal("hide");	
		
	}   
	
	 
</script>	
