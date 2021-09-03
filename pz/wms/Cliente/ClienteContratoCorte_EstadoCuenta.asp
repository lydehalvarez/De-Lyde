<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<% //HA ID: 1 2020-07-29 Cliente Contrato: Creación de Archivo

var urlBase = "/pz/wms/Cliente/"

var rqIntCli_Id = Parametro("Cli_ID", -1)
%>
    <script type="text/javascript">
	
		var urlBase = "<%= urlBase %>";
		
		$(document).ready(function(){
			
			$("#btn_Buscar").click(function(e){
				e.preventDefault();
				ClienteContratoCorte.CargarEstadosCuenta();
				ClienteContratoCorte.LimpiarEstadoCuentaDocumentosTotal();
			})
			
			ClienteContratoCorte.CargarCortesCombo();
			ClienteContrato.CargarContratosCombo();
			
			ClienteContratoCorte.CargarEstadosCuenta();
		});
		
	</script>
    
	<script type="text/javascript" src="<%= urlBase %>js/cliente.js"></script>
    
    <script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
    
	<div class="row">
		<div class="col-sm-8">
			<div class="ibox ">
				<div class="ibox-content" style="overflow: auto;">
                    <div class="col-md-12 forum-item active">
                        <div class="col-md-col-md-offset-0 forum-icon">
                            <i class="fa fa-search"></i>
                        </div>
                        <a href="#" class="forum-item-title" style="pointer-events: none">
                            <h3>Filtros</h3>
                        </a>
                        <div class="forum-sub-title"> Seleccionar los filtros para mostrar el corte</div>
                        
                        <div class="hr-line-dashed"></div>
                        <input type="hidden" id="Clientes" value="<%= rqIntCli_Id %>">
						<div class="form-group col-md-12 row">  
                            <label class="col-form-label col-md-2">
								Contrato
                            </label>
                            <div class="col-md-4 classOrigen">
                                <select id="Contratos" class="form-control">
									
                                </select>
                            </div>
                            
                            <label class="col-form-label col-md-2">
                                Corte
                            </label>
                            <div class="col-md-4 classOrigen">
                                <select id="Cortes" class="form-control">
									
                                </select>
                            </div>
                            <div class="col-md-12 text-left">
                            	<hr />
                            </div>
                            <div class="col-md-12 text-right">
                                <button class="btn btn-success" id="btn_Buscar">
                                    Buscar <i class="fa fa-search" style="color: white;"></i>
                                </button>
                            </div>
                            
                        </div>
                        
                        <div id="divContenedorEstadoCuenta">
                        </div>
                       
					</div>
				</div>
			</div>
		</div>
        <div class="col-sm-4" id="divContenedorEstadoCuentaDocumentos">
        	
        </div>
	</div>
