<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var bIQ4Web = false   

  var iCliID = Parametro("Cli_ID",-1)
  var iCliOCID = Parametro("CliOC_ID",-1)

  if(bIQ4Web){ 
      Response.Write("Base - Cli_ID: " + iCliID + " | CliOC_ID: " + iCliOCID) 
  }   
   
%>

<div id="wrapper">
	<div class="gray-bg">
		<div class="row">
			<div class="col-lg-12">
				<div class="wrapper wrapper-content animated fadeInRight">
          
          <div class="ibox float-e-margins">
              <div class="ibox-title">
                  <h5>Recepci&oacute;n</h5>
                  <div class="ibox-tools">
                    <a href="#" class="btn btn-primary btn-sm"><i class="fa fa-plus"></i>&nbsp;Nuevo</a>
                  </div>
                  <div class="ibox-content">
                    <!--div class="form-horizontal">
                        <div class="form-group">
                            <div class="col-sm-12"></div>
                        </div>                                
                    </div-->    
                  </div>
              </div>
          </div>
          <div class="faq-item">
            <div class="row"><h4>&nbsp;&nbsp;Entregas.</h4></div>  
          </div>            
          <%
            
            var sSQLOCE  = "SELECT Cli_ID, CliOC_ID, CliEnt_ID "
                sSQLOCE += ",CliEnt_Folio, CliEnt_FechaDeEntrega, CliEnt_FechaElaboracion "
                sSQLOCE += ",CliEnt_CantidadArticulos, CliEnt_CantidadProductos, CliEnt_CantidadPallet, CliEnt_UsuarioGeneroRecepcion "
                sSQLOCE += ",CliEnt_EstatusCG68, CliEnt_CitaCG69, CliEnt_AreaDestinoCG88, CliEnt_ASNCancelado, IR_ID, Lot_ID, ASN_ID "
                sSQLOCE += ",dbo.fn_CatGral_DameDato(68,CliEnt_EstatusCG68) AS ESTATUS, dbo.fn_CatGral_DameDato(69,CliEnt_CitaCG69) AS CITA "
                sSQLOCE += ",dbo.fn_CatGral_DameDato(88,CliEnt_AreaDestinoCG88) AS AREADEST "
                sSQLOCE += ",(SELECT IR.IR_Folio FROM Inventario_Recepcion IR WHERE IR.IR_ID = OCE.IR_ID) AS FOLIOCITA "
                sSQLOCE += ",CliEnt_FechaRegistro "
                sSQLOCE += "FROM Cliente_OrdenCompra_Entrega OCE "
                sSQLOCE += "WHERE OCE.Cli_ID = "+iCliID+" AND OCE.CliOC_ID = "+iCliOCID
                sSQLOCE += " ORDER BY OCE.CliEnt_FechaRegistro ASC"

                if(bIQ4Web){ 
                  Response.Write("<br>SQL_OrdenCompraEntrega: " + sSQLOCE) 
                }
                  
            var rsOCEnt = AbreTabla(sSQLOCE,1,0)
            var irow = 0
            var iCliEntID = -1
                  
          if(!rsOCEnt.EOF){    
            while (!rsOCEnt.EOF){
            irow++
            iCliEntID = rsOCEnt.Fields.Item("CliEnt_ID").Value
                
                  
          %>

					<div class="faq-item">
						<div class="row">
              <div class="col-md-1 text-center">
                <a class="faq-question font-bold"><h1 class="font-bold"><%=iCliEntID%></h1></a>
              </div>
							<div class="col-md-3 text-left">
                <!--td class="project-title"-->
                  <span class="small font-bold"><h5>Cantidad Art&iacute;culos.</h5></span><br>
                  <a href="#"><%=rsOCEnt.Fields.Item("CliEnt_CantidadArticulos").Value%></a><br>
                  <small>SKUs: <%=rsOCEnt.Fields.Item("CliEnt_CantidadProductos").Value%></small>
                  <br>
                  <small>Pallets: <%=rsOCEnt.Fields.Item("CliEnt_CantidadPallet").Value%></small>
                <!--/td-->
							</div>
							<div class="col-md-3 text-center">
								<span class="small font-bold"><h5>Estatus de entrega.</h5></span><br>
                <a href="#"><%=rsOCEnt.Fields.Item("ESTATUS").Value%></a>
							</div>
							<div class="col-md-2 text-center">
								<span class="small font-bold"><h5>Cita.</h5></span><br>
								<a href="#"><%=rsOCEnt.Fields.Item("CITA").Value%></a>
							</div>
              <div class="col-md-3 text-right">
                <div class="btn-group">
                    <!--button class="btn-white btn btn-sm"><i class="fa fa-cubes"></i> Productos</button-->
                    <a class="btn btn-white btn-sm btnMuestraProd" id="btnMuestraProd<%=iCliEntID%>" data-toggle="collapse" href="#faq<%=iCliEntID%>" data-clientid="<%=iCliEntID%>"><i class="fa fa-chevron-down"></i> Productos </a>
                    <a class="btn btn-white btn-sm btnCierraProd" id="btnCierra<%=iCliEntID%>" data-toggle="collapse" href="#faq<%=iCliEntID%>" data-clientid="<%=iCliEntID%>"><i class="fa fa-chevron-up"></i>&nbsp;Cerrar</a>
                    <!--button class="btn-white btn btn-xs">Edit</button>
                    <button class="btn-white btn btn-xs">Delete</button-->
                </div>
              </div>
						</div>
						<div class="row">
							<div class="col-lg-12">
								<div class="panel-collapse collapse" id="faq<%=iCliEntID%>">
									<div class="faq-answer">
                    <div id="divGridProductos<%=iCliEntID%>"><%=iCliEntID%></div>
										<!--p>
											It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.
										</p-->
									</div>
								</div>
							</div>
						</div>
					</div>
          <%
              rsOCEnt.MoveNext() 
              } 
          rsOCEnt.Close() 
          } else {
          %>          
          <div class="faq-item">
						<div class="row">
							<div class="col-lg-12">
								<div class="panel-collapse" id="faqextra">
									<div class="faq-answer">
										<p class="text-center">
											<a class="faq-question" href="#">No se encontraron entregas</a>
										</p>
									</div>
								</div>
							</div>
						</div>  
          </div>
          <% } %>
				</div>
			</div>
		</div>
	</div>
</div>
  
  
  
<script type="text/javascript">
  
$(document).ready(function() {
  
    
    $('.btnCierraProd').hide();
    //CargarGrid();
    $('.btnMuestraProd').click(function(e) {
        e.preventDefault();
      
        $(this).hide('slow');
      
        var iCliEntID = $(this).data('clientid');
        $('#btnCierra'+iCliEntID).show('slow');

        CargarGridProd(iCliEntID);
        
    });    
    
    $('.btnCierraProd').click(function(e) {
      
      $(this).hide('slow');
      
      e.preventDefault();
      var iCliEntID = $(this).data('clientid');
      
      //$('.btnMuestraProd').show('slow');
      $('#btnMuestraProd'+iCliEntID).show('slow');
      $('#btnCierra'+iCliEntID).hide('slow');
      
      setTimeout(function(){
        //$('#divGridProductos'+iCliEntID).remove()
        $('#divGridProductos'+iCliEntID).html("")
      },800);
      
    });    
    
    
    
});
  
  var loading = '<div class="spiner-example">'+
          '<div class="sk-spinner sk-spinner-three-bounce">'+
            '<div class="sk-bounce1"></div>'+
            '<div class="sk-bounce2"></div>'+
            '<div class="sk-bounce3"></div>'+
          '</div>'+
        '</div>'+
        '<div>Cargando informaci&oacute;n, espere un momento...</div>'
  
  
  function CargarGridProd(ijqCliEntID) {

      var datos = {
          Cli_ID:$("#Cli_ID").val(),
          CliOC_ID:$("#CliOC_ID").val(),
          CliEnt_ID:ijqCliEntID
      }

      $("#divGridProductos"+ijqCliEntID).hide("slow");
      $("#divGridProductos"+ijqCliEntID).html(loading);

      $("#divGridProductos"+ijqCliEntID).load("/pz/wms/Cliente/OrdenCompra/RecepOrdComEntProd_Grid.asp",datos);
      $("#divGridProductos"+ijqCliEntID).show("slow");

  }  
  
  
  
  
  
  
  
</script>  
  