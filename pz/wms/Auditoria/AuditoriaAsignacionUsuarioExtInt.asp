<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var bDebug = false
  var iAudID = Parametro("Aud_ID",-1)
  var iCliID = Parametro("Cli_ID",-1)
   
  if(bDebug){ Response.Write("Aud_ID: " + iAudID + " | Cli_ID: " + iCliID) }
   
  var sNomCliente = BuscaSoloUnDato("Cli_Nombre","Cliente"," Cli_ID="+iCliID,"",0) 
  //Response.Write(sNomCliente)
  var iAudHayConteoExterno = BuscaSoloUnDato("Aud_HayConteoExterno","Auditorias_Ciclicas"," Aud_ID="+iAudID,0,0)
   
   
%>
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>   
<div id="wrapper">
  <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
          <div class="ibox-title">
            <h5>Filtro(s) de b&uacute;squeda</h5>
            <div class="ibox-tools"></div>
              <div class="ibox-content">
                <div class="form-horizontal">
                  <div class="form-group">
                    <label class="col-sm-2 control-label">Auditor:</label>
                    <div class="col-sm-4">
                      <select id="cboTipoAuditor" name="cboTipoAuditor" class="form-control input-sm cbo2"> 
                        <option value="-1" selected="selected">Seleccione</option>
                        <option value="1">Auditor interno - (Lyde)</option>
                        <%if(iAudHayConteoExterno == 1){%>
                        <option value="2">Auditor externo - (<%=sNomCliente%>)</option>
                        <%} %>
                      </select>
                    </div>
                  </div>
                  <div class="form-group">
                      <div class="col-sm-12">
                          <div class="col-sm-6"></div>
                          <div class="col-sm-2 m-b-xs">
                              <button class="btn btn-sm btn-success pull-right m-t-n-xs" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                          </div>
                        <!--div class="col-sm-2 m-b-xs">
                          <button class="btn btn-primary btn-sm btn-primary pull-right m-t-n-xs" type="button" id="btnNvoAud"><i class="fa fa-plus"></i>&nbsp;&nbsp;<span class="bold">Nuevo auditor</span></button>
                        </div-->
                      </div>
                  </div>                    
                </div>    
              </div>
              <div class="table-responsive" id="dvTablaAuditores"></div>           
        </div>
      </div>    
    </div>
  </div> 
</div> 
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<script type="application/javascript">

  var sMensaje = ""
  
  $(document).ready(function() {
  
    $('.cbo2').select2();

    $('#btnBuscar').click(function(e){
      
      e.preventDefault();
      //console.log("ENTRO");
      if(ValidaBusqueda()){
        CargarGrid();
      }
      
    });      

    $('#cboTipoAuditor').change(function(e){
      
      $("#btnBuscar").trigger("click");
      
    });    
    
    
var loading = '<div class="spiner-example">'+
				'<div class="sk-spinner sk-spinner-three-bounce">'+
					'<div class="sk-bounce1"></div>'+
					'<div class="sk-bounce2"></div>'+
					'<div class="sk-bounce3"></div>'+
				'</div>'+
			'</div>'+
			'<div>Cargando informaci&oacute;n, espere un momento...</div>'

    
    function CargarGrid() {
        
        //$("#dvTablaUsuariosProv").empty();    
        
        var datos = {
            Aud_ID:$('#Aud_ID').val()
           ,TipoAuditor:$('#cboTipoAuditor').val()
           ,Cli_ID:$('#Cli_ID').val()
        }
         //console.log(datos);
        $('#dvTablaAuditores').hide('slow');
        $("#dvTablaAuditores").html(loading);
      
        if($('#cboTipoAuditor').val() == 1){
          $("#dvTablaAuditores").load("/pz/wms/Auditoria/AuditoriaAsignaUsuarioAudExtUsu_Grid.asp",datos);
      
        }
      
        if($('#cboTipoAuditor').val() == 2){
          $("#dvTablaAuditores").load("/pz/wms/Auditoria/AuditoriaAsignaUsuarioAudExtCli_Grid.asp",datos);
        }
      
        $("#dvTablaAuditores").show('slow');
        
    }
  
  });

  function ValidaBusqueda(){
    //console.log($("#cboTipoBusqueda").val());
    if($("#cboTipoAuditor").val() == -1){
      sMensaje= "Por favor seleccione un Auditor."
      Avisa("warning", "Auditoria", "" + sMensaje);
      $("#cboTipoAuditor").focus();
      return false;        
    }

      return true;

  }     
  
</script>  
  
  
  
  
  
  