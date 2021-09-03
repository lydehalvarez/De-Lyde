<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
   var TA_ID = 0
   var Folio = ""
   var Pro_ID = ""
   var sTipo= ""
   var Llaves = ""
		
	var sSQLRec = "SELECT COUNT(*) as Citas "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRec += "FROM Inventario_Recepcion "
		sSQLRec += " WHERE IR_EstatusCG62 = 1 "
		
	var rsRec = AbreTabla(sSQLRec,1,0)
	
	var NumCitas = 0
	if(!rsRec.EOF){
		var Hoy = rsRec.Fields.Item("Hoy").Value
		var Maniana = rsRec.Fields.Item("Maniana").Value
		NumCitas = rsRec.Fields.Item("Citas").Value
	}	
		
	var sSQLRece = "SELECT TOP 1 * "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntrega, 113) AS IRFechaEntrega "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntregaTermina, 113) AS IRFechaEntregaTermina "
		sSQLRece += "FROM Inventario_Recepcion "
		sSQLRece += " WHERE IR_FechaEntrega > getdate()"
		sSQLRece += " ORDER BY IR_FechaEntrega ASC "
		
	var rsRece = AbreTabla(sSQLRece,1,0)
	if(!rsRece.EOF){
		var Fol = rsRece.Fields.Item("IR_Folio").Value
		var IRFechaEntrega = rsRece.Fields.Item("IRFechaEntrega").Value
		var IRFechaEntregaTermina = rsRece.Fields.Item("IRFechaEntregaTermina").Value
		var PuertaMasProx = rsRece.Fields.Item("IR_Puerta").Value
   

	}	
	
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<style>
.opciones{
	margin-left: 20px;	
}
</style>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
                    <span class="pull-right"><a data-toggle="modal" data-target="#ModalImprimir" class="text-muted"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir</strong></a>&nbsp;|&nbsp;(<strong><%=NumCitas%></strong>) Citas</span>
                    <h5>Citas en agenda</h5>  
                </div>
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
					var sSQLRe = "SELECT * "
						sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
						sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 103) AS IRFechaEntregaTermina "
						sSQLRe += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
						sSQLRe += ", CONVERT(VARCHAR(10), IR_FechaEntregaTermina, 108) AS IRHoraEntregaTermina "
						sSQLRe += "FROM Inventario_Recepcion "
						sSQLRe += " WHERE IR_Habilitado = 1 "
						sSQLRe += " ORDER BY IR_FechaEntrega DESC "
				   var rsRe = AbreTabla(sSQLRe,1,0)
					while (!rsRe.EOF){
						var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
						var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
						var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
						var IR_EstatusCG62 = rsRe.Fields.Item("IR_EstatusCG62").Value
						var IR_Puerta = rsRe.Fields.Item("IR_Puerta").Value
						var IR_ID = rsRe.Fields.Item("IR_ID").Value
				        var TA_ID = rsRe.Fields.Item("TA_ID").Value
                        sTipo= ""
                        Folio = ""
                        if(TA_ID>0){
                            var sSQLTA = "SELECT TA_Folio, BPM_Pro_ID "
                                sSQLTA += " FROM TransferenciaAlmacen WHERE TA_ID = " + TA_ID
                            var rsTA = AbreTabla(sSQLTA,1,0)
					        if (!rsTA.EOF){
                                Folio = rsTA.Fields.Item("TA_Folio").Value
                                Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
                            }
                            rsTA.Close()
                            sTipo= "Transferencia"
                        } 
                        if(TA_ID>0){
                            var sSQLTA = "SELECT TA_Folio, BPM_Pro_ID "
                                sSQLTA += " FROM TransferenciaAlmacen WHERE TA_ID = " + TA_ID
                            var rsTA = AbreTabla(sSQLTA,1,0)
					        if (!rsTA.EOF){
                                Folio = rsTA.Fields.Item("TA_Folio").Value
                                Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
                            }
                            rsTA.Close()
                            sTipo= "Transferencia"
                        } 
				       var Cli_ID = rsRe.Fields.Item("Cli_ID").Value
					   var CliOC_ID = rsRe.Fields.Item("CliOC_ID").Value
                       if(CliOC_ID>0){
                            var sSQLTA = "SELECT CliOC_Folio, BPM_Pro_ID "
                                sSQLTA += " FROM Cliente_OrdenCompra "
                                sSQLTA += " WHERE Cli_ID = " + Cli_ID
                                sSQLTA += " AND CliOC_ID = " + CliOC_ID
                           
                            var rsTA = AbreTabla(sSQLTA,1,0)
					        if (!rsTA.EOF){
                                Folio = rsTA.Fields.Item("CliOC_Folio").Value
                                Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
                            }
                            rsTA.Close()
                            sTipo= "Cliente Orden de compra"
                        } 
				       var Prov_ID = rsRe.Fields.Item("Prov_ID").Value
					   var OC_ID = rsRe.Fields.Item("OC_ID").Value
                       if(Prov_ID>0){
                            var sSQLTA = "SELECT OC_Folio, BPM_Pro_ID "
                                sSQLTA += " FROM Proveedor_OrdenCompra "
                                sSQLTA += " WHERE Prov_ID = " + Prov_ID
                                sSQLTA += " AND OC_ID = " + OC_ID
                           
                            var rsTA = AbreTabla(sSQLTA,1,0)
					        if (!rsTA.EOF){
                                Folio = rsTA.Fields.Item("OC_Folio").Value
                                Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
                            }
                            rsTA.Close()
                            sTipo= "Proveedor Orden de compra"
                        } 
                        Llaves = "data-irid='" + IR_ID +"' data-taid='" + TA_ID +"' " 
						Llaves += " data-cliid='" + Cli_ID + "' data-cliocid='" + CliOC_ID + "' " 
						Llaves += " data-provid='" + Prov_ID + "' data-ocid='" + OC_ID + "' "
                        Llaves += " data-proid='" + Pro_ID + "' "

					    
                       var IR_DescripcionVehiculo = rsRe.Fields.Item("IR_DescripcionVehiculo").Value 
                       var IR_Conductor = rsRe.Fields.Item("IR_Conductor").Value
                       var IR_Placas = rsRe.Fields.Item("IR_Placas").Value
                       var IR_Color = rsRe.Fields.Item("IR_Color").Value
                       if(IR_Color == "") { IR_Color = "#337ab7"} 
				%>
                    <div class="ibox-content" id="<%=IR_Folio%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td width="90">
                                            <img src="/Img/wms/Logo_Izzi_2.jpg" title="Izzi" style="width:inherit;"/>
                                    </td>
                                    <td class="desc" style="width: 30%;">
                                        <dl class="small m-b-none">
                                            <dt>Folio cita</dt>
                                            <dd>
                                                <h3 style="color:<%=IR_Color%>;">
                                                    <a data-irid="<%=IR_ID%>" class="btnCita" 
                                                       style="color:<%=IR_Color%>;" ><%=IR_Folio%></a>
                                                </h3>
                                            </dd>
                                            <dt>Folio <%=sTipo%></dt>
                                            <dd>
                                                <h3 class="text-navy">
                                                    <a data-irid="<%=IR_ID%>" class="text-navy btnTransf" ><%=Folio%></a>
                                                </h3>
                                            </dd>
                                            <dt>Cortina</dt>
                                            <dd>
                                                 <spam style="font-size: 41px;">
                                                <%=IR_Puerta%> 
                                                </spam>
                                            </dd>         
                                        </dl>
                                        <div class="m-t-sm">
                                            <a <%=Llaves%>
											   class="text-muted btnRecibir"><i class="fa fa-inbox"></i>&nbsp;<strong>Recibir</strong></a>
                                            | <a  data-taid="<%=TA_ID%>" data-ocid="<%=CliOC_ID%>" class="text-muted btnHuella"><i class="fa fa-inbox"></i>&nbsp;<strong>Huella Logistica </strong></a> 
                                            <a data-irid="<%=IR_ID%>" data-folio="<%=IR_Folio%>" class="text-muted btnImprimeRecep"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir</strong></a>
                                        </div>
                                    </td>
                                    <td class="desc">
                  <% if(IR_Conductor !=""){ %>
                     Conductor
                     <h4><%=IR_Conductor%></h4>
                  <%  }  
                     if(IR_Placas !=""){ %>
                     Placas
                    <h4> <%=IR_Placas%></h4>
                  <% }  
                     if(IR_DescripcionVehiculo !=""){ %>
                    Veh&iacute;culo
                     <h4 ><%=IR_DescripcionVehiculo%></h4>
                  <%  } %>       
                                    </td>
                                    <td class="desc" style="width:25%;">

                                        <h4>Recepci&oacute;n</h4>
                                        <dl class="small m-b-none">
                                            <dt>Inicia</dt> 
                                        </dl>
                                           <%=IR_FechaEntrega%>
                                        <dl class="small m-b-none">
                                            <dt>Termina</dt> 
                                        </dl>
                                           <%=IR_FechaEntregaTermina%>
                                        <p class="small">
                                            
                                        </p>
                                        <dl class="small m-b-none">
                                            <dt>Persona que cit&oacute;</dt>
                                            <dd>Cita asiganada por sistema</dd>
                                        </dl>    
                                        <dl class="small m-b-none">
                                            <dt>Fecha de cita</dt>
                                            <dd><%=IR_FechaEntrega%></dd>
                                        </dl>    
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
					<%	
                        rsRe.MoveNext() 
                    }
                    rsRe.Close()   
                    %>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
                    <h5 class="text-danger">Cita m&aacute;s pr&oacute;xima </h5>
                </div>
                <div class="ibox-content">
                    <h4 class="font-bold text-success">
                        <a href="#<%=Fol%>" id="<%=Fol%>" onclick="javascript:Enfasis($(this))"><%=Fol%></a>
                    </h4>
                    <h4 class="font-bold text-navy">
                        <%=IRFechaEntrega%>
                    </h4>
                    <h4 class="font-bold text-warning">
                        Puerta <%=PuertaMasProx%>
                    </h4>
                    <div class="m-t-sm">
                        <div class="btn-group">
                        <a href="#" class="btn btn-danger btn-sm"><i class="fa fa-calendar"></i>&nbsp;&nbsp;Reprogramar</a>
                        <a href="#" class="btn btn-success btn-sm"><i class="fa fa-check"></i>&nbsp;&nbsp;Atender</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Ayuda</h5>
                </div>
                <div class="ibox-content text-center">
                    <h3><i class="fa fa-phone"></i> +55 12 34 56 78</h3>
                    <span class="small">
                        Gerente de recepci&oacute;n
                    </span>
                </div>
            </div>
            <div class="ibox">
                <div class="ibox-content">
                    <p class="font-bold">
                    	Disponibilidad de puertas
                    </p>
                    <hr/>
                    <div>
                        <a href="#" class="product-name"> Product 1</a>
                        <div class="small m-t-xs">
                            Many desktop publishing packages and web page editors now.
                        </div>
                        <div class="m-t text-righ">

                            <a href="#" class="btn btn-xs btn-outline btn-primary">Info <i class="fa fa-long-arrow-right"></i> </a>
                        </div>
                    </div>
                    <hr/>
                    <div>
                        <a href="#" class="product-name"> Product 2</a>
                        <div class="small m-t-xs">
                            Many desktop publishing packages and web page editors now.
                        </div>
                        <div class="m-t text-righ">

                            <a href="#" class="btn btn-xs btn-outline btn-primary">Info <i class="fa fa-long-arrow-right"></i> </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="ModalImprimir" tabindex="-1" role="dialog" aria-labelledby="ModalImprimir" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Imprimir</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-3">D&iacute;a requerido:</label>
                <div class="i-checks">
                    <label class="control-label opciones"><input type="radio" value="<%=Hoy%>" checked="checked" name="gpo1"/>&nbsp;Hoy (<%=Hoy%>)</label>
                    <label class="control-label opciones"><input type="radio" value="<%=Maniana%>" name="gpo1"/>&nbsp;Ma&ntilde;ana (<%=Maniana%>)</label>
                </div>
            </div>     
            <div class="form-group">
                <label class="control-label col-md-3">Dirigido a:</label>
                <div class="i-checks" data-radios="opciones">
                    <label class="control-label opciones"><input type="radio" value="1" checked="checked" name="gpo2"/>&nbsp;Ambos</label>
                    <label class="control-label opciones"><input type="radio" value="2" name="gpo2"/>&nbsp;Seguridad</label>
                    <label class="control-label opciones"><input type="radio" value="3" name="gpo2"/>&nbsp;Recepci&oacute;n</label>
                </div>
            </div>     
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary btnImprimeConfig">Imprimir</button>
      </div>
    </div>
  </div>
</div>

<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">

$(document).ready(function(){
		
	$('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 
		
});	

	$('.btnRecibir').click(function(e) {
		e.preventDefault()
		
		var Params = "?TA_ID=" + $(this).data("taid")
		    Params += "&IR_ID=" + $(this).data("irid")
		    Params += "&CliOC_ID=" + $(this).data("cliocid")
		    Params += "&Cli_ID=" + $(this).data("cliid") 
            Params += "&OC_ID=" + $(this).data("ocid")
		    Params += "&Prov_ID=" + $(this).data("provid") 
            Params += "&Pro_ID=" + $(this).data("proid")
	        Params += "&IDUsuario=" + $("#IDUsuario").val()
            Params += "&VI=" + $("#VentanaIndex").val()

		$("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp" + Params)
	});
	$('.btnHuella').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("ocid")
		Params += "&TA_ID=" + $(this).data("taid")   
		<%/*%>    Params += "&CliOC_ID=" + $(this).data("cliocid")
		    Params += "&Cli_ID=" + $(this).data("cliid") 
            Params += "&OC_ID=" + $(this).data("ocid")
		    Params += "&Prov_ID=" + $(this).data("provid") 
            Params += "&Pro_ID=" + $(this).data("proid")
	        Params += "&IDUsuario=" + $("#IDUsuario").val()
            Params += "&VI=" + $("#VentanaIndex").val()<%*/%>

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionHuella.asp" + Params)
	});
	$('.btnImprimeRecep').click(function(e) {
		e.preventDefault()
		RecepImprime($(this).data("irid"),3)
	});
	
	$('.btnImprimeConfig').click(function(e) {
		e.preventDefault()
		RecepImprimeTodos($("input[name='gpo1']:checked"). val(),$("input[name='gpo2']:checked"). val())
	});
		
function Enfasis(Folio){
    var Fol = Folio.attr('id');
	$('#'+Fol).addClass('bg-warning')
	setTimeout(function(){
	$('#'+Fol).removeClass('bg-warning')	
	},5000)	
}
function RecepImprime(f,t){
		var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo="+t+"&IR_ID="+f);
}
function RecepImprimeTodos(d,v){
		var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?IR_ID=-1&Dia="+d+"&Tipo="+v);
}

</script>