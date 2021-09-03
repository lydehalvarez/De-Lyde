<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var TA_ID = 0
    var Folio = ""
    var Pro_ID = ""
    var sTipo= ""
    var Llaves = ""
    var Tarea = Parametro("Tarea", -1)	
    var FechaEntrega = Parametro("IR_FechaEntrega","")	
    var IDUsuario = Parametro("IDUsuario",-1) 

    var UsuarioRol = -1

    var sSQLRol = "select dbo.fn_BPM_DameRolUsuario(" + IDUsuario + ",3)"
    var rsRol = AbreTabla(sSQLRol,1,0)
	if(!rsRol.EOF){
		UsuarioRol = rsRol.Fields.Item(0).Value
	}    
    rsRol.CLose()
    

    var f = new Date();			
    var dia=f.getDate()
    var mes=f.getMonth()
   
    if(dia<10){
        //dia = dia +1
        dia = "0" + dia	
    }
    mes = mes + 1
    if(mes<10){   
        mes = "0" + mes	
    }
                
    f2 = f.getFullYear() + "-" + mes + "-" + dia           
    f =( f.getFullYear() + "-" + mes + "-" + dia  ); 
    
			
				
    if(Tarea == 1){
        var IR_Puerta = Parametro("IR_Puerta", "")	
        if(IR_Puerta=="-"){
            var condicion= ""
        } else {
            if(FechaEntrega =="-"){
                var condicion= " IR_Puerta = '"+ IR_Puerta+ "'"
            } else {
                var condicion= "IR_Puerta = '"+ IR_Puerta+ "'"
                if (FechaEntrega =="-"){
                    var condicion= " IR_Puerta= '"+ IR_Puerta+ "'"
                } else {
                    var condicion= "and IR_Puerta= '"+ IR_Puerta+ "'"
                }
            }
        }
        
        if(FechaEntrega=="-"){
            var condicion2= "  cast (IR_FechaEntrega as date) = '"+f+"' AND"
        } else {
            if(IR_Puerta=="-"){
                var condicion= ""
            } else {
                var condicion= "and IR_Puerta = '"+ IR_Puerta+ "'"
            }
            var condicion2= "cast (IR_FechaEntrega as date)  = '"+ FechaEntrega + "'"
        }
            var sSQLRece = "SELECT TOP 1 * "
                sSQLRece += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
                sSQLRece += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
                sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntrega, 113) AS IRFechaEntrega "
                sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntregaTermina, 113) AS IRFechaEntregaTermina "
                sSQLRece += "FROM Inventario_Recepcion "
                sSQLRece += " WHERE  "+condicion2+" "+condicion+""
                sSQLRece += " ORDER BY IR_FechaEntrega ASC "
	
		} else {
			
			var sSQLRece = "SELECT TOP 1 * "
                sSQLRece += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
                sSQLRece += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
                sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntrega, 113) AS IRFechaEntrega "
                sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntregaTermina, 113) AS IRFechaEntregaTermina "
                sSQLRece += "FROM Inventario_Recepcion "
                sSQLRece += " WHERE CAST(IR_FechaEntrega as DATE) = CAST(getdate() as DATE) "
                sSQLRece += " ORDER BY IR_FechaEntrega ASC "
		}
//Response.Write(sSQLRece)
	var rsRece = AbreTabla(sSQLRece,1,0)
	if(!rsRece.EOF){
		var Fol = rsRece.Fields.Item("IR_Folio").Value
		var IRFechaEntrega = rsRece.Fields.Item("IRFechaEntrega").Value
		var IRFechaEntregaTermina = rsRece.Fields.Item("IRFechaEntregaTermina").Value
		var PuertaMasProx = rsRece.Fields.Item("IR_Puerta").Value
   
 
	}	
	var sSQLRec = "SELECT COUNT(*) as Citas "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRec += " FROM Inventario_Recepcion "
		sSQLRec += " WHERE IR_EstatusCG52 = 1  "
        sSQLRec += " AND cast(IR_FechaEntrega as date)  = '"  + f2 + "'"
                
	var rsRec = AbreTabla(sSQLRec,1,0)
	
	var NumCitas = 0
	if(!rsRec.EOF){
		var Hoy =rsRec.Fields.Item("Hoy").Value
		var Maniana = rsRec.Fields.Item("Maniana").Value
		NumCitas = rsRec.Fields.Item("Citas").Value
	}	
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<style type="text/css">
    
    .opciones{
        margin-left: 20px;	
    }
 
	.Caja-Flotando {
		position: fixed;
		top: 10px;
        right: 20px;
        width: 260px;
	  }
    .Cita-Datos {
        font-size: 14px;
        font-weight: 600;
    }
 
</style>


	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
<%if((IDUsuario == 97) || (IDUsuario == 34) || (IDUsuario == 36) || (IDUsuario == 37)|| (IDUsuario == 35)) {%>
                <span class="pull-right"> <a   class="text-muted btnSupervisor"><i class="fa fa-inbox"></i>&nbsp;<strong>Supervisor </strong></a> </span>
<%}%>
                    <span class="pull-right"><a data-toggle="modal" data-target="#ModalImprimir" class="text-muted"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir</strong></a>&nbsp;|&nbsp;(<strong><%=NumCitas%></strong>) Citas | </span>
                    <h5>Citas en agenda</h5>  
                </div>
                <div style="width: auto;">
<%
		if (Tarea == 1){
			
			if(IR_Puerta=="-"){
				var condicion= ""
			} else {
				if(FechaEntrega =="-"){
				    var condicion= " IR_Puerta = '"+ IR_Puerta+ "'"
				} else {
				    var condicion= " IR_Puerta = '"+ IR_Puerta+ "'"
				}
            }
                
            if(FechaEntrega=="-"){
				var condicion2= "  cast (IR_FechaEntrega as date)  >= '"+f+"' AND "
			} else {
				if(IR_Puerta=="-"){
				    var condicion= ""
				} else {
				    var condicion= "and IR_Puerta = '"+ IR_Puerta+ "'"
				}
				var condicion2= "cast (IR_FechaEntrega as date)  = '"+ FechaEntrega + "'"
			}
                
            var sSQLRe = "SELECT * "
                sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
                sSQLRe += ", CONVERT(VARCHAR(20), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 103) AS IRFechaEntregaTermina "
                sSQLRe += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
                sSQLRe += ", CONVERT(VARCHAR(10), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 108) AS IRHoraEntregaTermina "
                sSQLRe += "FROM Inventario_Recepcion "
                sSQLRe += "  WHERE "+condicion2+" "+condicion+" AND IR_Habilitado = 1 "
                sSQLRe += " ORDER BY IR_FechaEntrega DESC "
        } else {
                var sSQLRe = "SELECT * "
                sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
                sSQLRe += ", CONVERT(VARCHAR(20), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 103) AS IRFechaEntregaTermina "
                sSQLRe += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
                sSQLRe += ", CONVERT(VARCHAR(10), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 108) AS IRHoraEntregaTermina "
                sSQLRe += "FROM Inventario_Recepcion "
                sSQLRe += "  WHERE  IR_Habilitado = 1 AND cast (IR_FechaEntrega as date)  = '"+f+"'"
                sSQLRe += " ORDER BY IR_FechaEntrega DESC "
        }
                
        var rsRe = AbreTabla(sSQLRe,1,0)
        while (!rsRe.EOF){
            var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
            var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
            var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
            var IR_EstatusCG52 = rsRe.Fields.Item("IR_EstatusCG52").Value
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
                            <table  class="table">
                                <tbody>
                                  <tr>
                                  <td nowrap="nowrap" ><dl class="small m-b-none">
                                            <dt>Folio cita</dt>
                                            <dd>
                                                <h3 style="color:<%=IR_Color%>;">
                                                    <a data-irid="<%=IR_ID%>" class="btnCita" 
                                                       style="color:<%=IR_Color%>;" ><%=IR_Folio%></a>
                                                </h3>
                                            </dd>
                                      </dl>
                                  </td>
                                  <td colspan="2" class="desc" style="width: 30%;">
                                      <div class="m-t pull-right" > 
                                            <a <%=Llaves%>
                                               title="Iniciar el proceso de recepci&oacute;n"
											   class="text-muted btnRecibir"><i class="fa fa-inbox"></i>&nbsp;<strong>Recibir</strong></a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <a  data-ocid="<%=OC_ID%>" data-cliocid="<%=CliOC_ID%>"  
                                               title="Reportar alg&uacute;n problema"
                                               data-cliid="<%=Cli_ID%>" class="text-muted btnHuella"><i class="fa fa-inbox"></i>&nbsp;<strong>Incidencias </strong></a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <a data-ocid="<%=OC_ID%>"  data-provid="<%=Prov_ID%>" 
                                               data-cliocid="<%=CliOC_ID%>"  data-cliid="<%=Cli_ID%>"  
                                               data-irid="<%=IR_ID%>"                                         title="Imprime lista de art&iacute;culos"  
                                               class="text-muted btnImprimeRecep"><i class="fa fa-print">
                                            </i>&nbsp;<strong>Imprimir</strong></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="261">
                                    <% if(Cli_ID == 2){%>	
									
                                            <img src="/Img/wms/Logo_Izzi_2.jpg" title="Izzi" style="width:inherit;"/>
                                            
                                   <% }
								      if(Cli_ID == 6) { %>
                                                <h3 style="color:Red;">
                           		  <a  style="color:Red" >Elektra</a>
                                  </h3>
								  <%  }  %>
                                    </td>
                                    <td width="82" class="desc" style="width: 30%;">
                                        <dl class="small m-b-none">
                                            <dt>Folio <%=sTipo%></dt>
                                            <dd>
                                                <h3 class="text-navy">
                                                    <a data-irid="<%=IR_ID%>" class="text-navy btnTransf" ><%=Folio%></a>
                                                </h3>
                                            </dd>
   <%                                         
            var sSQLASN = "SELECT ASN_ID, ASN_FolioCliente, ASN_FolioCita, ASN_Folio "
                sSQLASN += " FROM ASN "
                sSQLASN += " WHERE IR_ID = " + IR_ID

            var rsASN = AbreTabla(sSQLASN,1,0)
            while (!rsASN.EOF){
%>          
                <dt>ASN: <%=rsASN.Fields.Item("ASN_Folio").Value%></dt>
                <dd>
                    <h3 class="text-navy">
                        <a data-asnid="<%=rsASN.Fields.Item("ASN_ID").Value%>" class="text-navy btnTransf" ><%=rsASN.Fields.Item("ASN_FolioCliente").Value%></a>
                    </h3>
                </dd>
 <%                     
                rsASN.MoveNext() 
            }
            rsASN.Close()   
%>                                          
                                            
                                            
                                            
                                            <dt>Cortina</dt>
                                            <dd>
                                                 <spam style="font-size: 41px;">
                                                <%=IR_Puerta%> 
                                                </spam>
                                            </dd>         
                                        </dl>
                                        
                                    </td>
                                    <td width="216" >
                                          <table width="400px" border="0" style="t  ">
                                    <tbody>
                         <% if(IR_Conductor !=""){ %>               
                                      <tr>
                                        <td width="24%">
                                            Conductor
                                        </td>
                                        <td width="76%">
                                            <div class="Cita-Datos"><%=IR_Conductor%></div>
                                        </td>
                                      </tr>
                          <%  } else { %>               
                                      <tr>
                                        <td colspan="2">
                                            Introducir datos del transporte
                                        </td>
                                      </tr>
                          <%  }                
                              if(IR_Placas !=""){ %>               
                                      <tr>
                                        <td>
                                            Placas
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_Placas%></div>
                                        </td>
                                      </tr>
                          <%  }      
                              if(IR_DescripcionVehiculo !=""){ %>               
                                      <tr>
                                        <td>
                                            Veh&iacute;culo
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_DescripcionVehiculo%></div>
                                        </td>
                                      </tr> 
                          <%  }  %>                                
                                      <tr>
                                        <td colspan="2">&nbsp;</td>
                                      </tr>
                                      <tr>  
                                          <td colspan="2"><div class="Cita-Datos">Cita</div></td>
                                      </tr>
                                      <tr>
                                        <td>
                                            Inicia
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_FechaEntrega%></div>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                            Termina (Estimado)
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_FechaEntregaTermina%></div>
                                        </td>
                                      </tr>  
                                        
                                    </tbody>
                                  </table>
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
        <div class="col-md-3" > 
            <div class="ibox" id="dvFiltros">
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
                        Puerta: 
                           </h4>
                    	<select id="IR_Puerta" class="form-control agenda">
                    <option value="-">Todas</option>
 <%
					 ssql = "select * from Ubicacion_Inmueble_Posicion"
			         var rsAlm = AbreTabla(ssql,1,0)
			
					 while (!rsAlm.EOF){ 
                         var Alm_Nombre = rsAlm.Fields.Item("InmP_Nombre").Value
%>
                          <option value="<%=Alm_Nombre%>"><%=Alm_Nombre%></option>
<%	                      rsAlm.MoveNext() 
					}
                    rsAlm.Close()  
%>
						</select>
      
                 
                    <div class="m-t-sm">
                        <div class="btn-group">
                         <h4 class="font-bold text-warning">
                      Buscar Fecha:
                    </h4>
                    <div class="input-group date">
                        <input class="form-control Fecha agenda"
                        id="InputBuscarFecha" placeholder="dd/mm/aaaa" type="text" autocomplete="off"
                        value="" data-esfecha="1"> 
                        <a href="#" class="btn btn-danger btn-sm BuscarFecha"><i class="fa fa-calendar"></i>&nbsp;&nbsp;Buscar</a>
                      
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

<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">

$(document).ready(function(){

        $('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 

        $('.btnRecibir').click(function(e) {
            e.preventDefault()

            var Params = "?TA_ID=" + $(this).data("taid")
                Params += "&IR_ID=" + $(this).data("irid")
                Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&Usu_ID=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()
            
            var UsuRol = <%=UsuarioRol%>
            

            //if( UsuRol == 2 || UsuRol == 3){
			if( $("#IDUsuario").val()==97||$("#IDUsuario").val()==36||$("#IDUsuario").val()==37){
                //$("#Contenido").load("/pz/wms/BPM/BPM_Recepciones.asp" + Params)
                $("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp" + Params)
            } else {
                $("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp" + Params)
            }
        });

        $('.BuscarFecha').click(function(e) {
            e.preventDefault()

            if ($("#InputBuscarFecha").val() == ""){
                var Fecha = "-"	
            } else {
                var Fecha=$("#InputBuscarFecha").val()
            }

            if ($("#IR_Puerta").val() == ""){
                var Puerta = "-"	
            } else{
                var	Puerta=$("#IR_Puerta").val()
            }

            var Params = "?Tarea=" + 1
                Params += "&IR_FechaEntrega=" + Fecha
                Params += "&IR_Puerta=" + Puerta

            $("#Contenido").load("/pz/wms/Recepcion/Recepcion.asp" + Params)
        });

        $('.btnHuella').click(function(e) {
            e.preventDefault()

            var Params = "?CliOC_ID=" + $(this).data("cliocid")
                   Params += "&Cli_ID=" + $(this).data("cliid") 
    //		Params += "&TA_ID=" + $(this).data("taid")   
            <%/*%>    Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()<%*/%>

            $("#Contenido").load("/pz/wms/Recepcion/RecepcionIncidencias.asp" + Params)
        });    

        $('.btnSupervisor').click(function(e) {
            e.preventDefault()

            var Params = "?CliOC_ID=" + $(this).data("cliocid")
    //		Params += "&TA_ID=" + $(this).data("taid")   
            <%/*%>    Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()<%*/%>

            $("#Contenido").load("/pz/wms/Recepcion/RecepcionSupervisor.asp" + Params)
        });

        $('.btnImprimeRecep').click(function(e) {
            e.preventDefault()
            RecepImprime($(this).data("irid"),$(this).data("cliocid"), $(this).data("cliid"),3)
        });

        $('.btnImprimeConfig').click(function(e) {
            e.preventDefault()
            RecepImprimeTodos($("input[name='gpo1']:checked"). val(),$("input[name='gpo2']:checked"). val())
        });		

        $('.Fecha').datepicker({
            todayBtn: "linked", 

            dateFormat: 'dd/mm/yyyy',
            language: "es",
            todayHighlight: true,
            autoclose: true
        });

        $('#btnPruebaRapida').click(function(e) {
            e.preventDefault()
            MandaSO()
        });

//        var Renglon = 0;
//        $('#btnAddCal').click(function(e) {
//            Renglon++
//            e.preventDefault()
//            var NewTask = "<div class='external-event navy-bg'>Hola "+Renglon+".</div>"
//
//            $('#external-events').append(NewTask)
//        });
    

    });	
    
    $(document).scroll(function(e) {

		  if ($(document).scrollTop() > 200) {
			$("#dvFiltros").addClass("Caja-Flotando");
		  } else {
			$("#dvFiltros").removeClass("Caja-Flotando");
		  }
	  
	});  
    
//	var Calendar = $('#InputBuscarFecha').fullCalendar({
//            header: {
//                left: 'prev,next today',
//                center: 'title',
//                right: 'agendaWeek,month,agendaDay'
//            },
//			themeSystem: 'bootstrap3',
//			lang: 'es',
//			timeFormat: 'H(:mm)',
//			contentHeight:"auto",
//            droppable: true,
//			firstDay: 1,
//			editable: true,
//			eventLimit: true,
//			selectable: true,
//			selectHelper: true,
//            drop: function() {
//                // is the "remove after drop" checkbox checked?
//                    // if so, remove the element from the "Draggable Events" list
//                    $(this).remove();
//					//console.log($(this))
//
//            },
//			eventDrop: function(event, delta, revertFunc) {
//				console.log(event.start.format())
//				console.log(event.id)
//				console.log(event)
//				var terminar = event.end
//				if(terminar == null){
//					terminar = event._start
//				}
//
//				if (!confirm("Seguro deseas cambiar la cita a "+event.start.format()+"?")) {
//					revertFunc()
//				} else {
//					UpdateCita(event.start.format(),terminar.format(),event.id)
//				}
//			},
//			eventResize: function(info) {	
//				console.log(info.start.format())
//				console.log(info.id)
//				if (!confirm("Seguro?")) {
//					revertFunc();
//				} else {
//					UpdateCita(info.start.format(),info.end.format(),info.id)
//				}
//			},
//			select: function(start, end) {
//				$('.Robin').attr('disabled',false)
//				$('#MyBatmanModal').modal('show')  
//				$('#TitleCall').text()
//				$('#InputBuscarFecha').val(start.format('DD/MM/YYYY'))
//				
//			},
//			eventClick: function(event, jsEvent, view) {
//				$('.Robin').attr('disabled',true)
//				$('#MyBatmanModal').modal('show')  
//				
//				console.log(event)
//				var terminar = event.end
//				if(terminar == null){
//					terminar = event._start
//				}
//				$('#InputBuscarFecha').val(event.start.format('DD/MM/YYYY'))
//			
//				$('#Event_ID').val(event.id)	
//			},
//			events: {
//				url: '/pz/wms/Recepcion/RecepcionEventos.asp',
//				error: function() {
//					
//				}
//			},
//			loading: function(bool) {
//				$('#loading').toggle(bool);
//			},
//			eventRender: function(eventObj, $el) {
//			  $el.popover({
//				title: eventObj.title,
//				content: eventObj.description,
//				trigger: 'hover',
//				placement: 'top',
//				container: 'body'
//			  });
//			}
//	  });



    function Enfasis(Folio){
        var Fol = Folio.attr('id');
        $('#'+Fol).addClass('bg-warning')
        
        setTimeout(function(){
            $('#'+Fol).removeClass('bg-warning')	
        },5000)	
    }
    
    function RecepImprime(f,o,c,t){
            var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo="+t+"&IR_ID="+f+"&CliOC_ID="+o+"&Cli_ID="+c);
    }
    
    function RecepImprimeTodos(d,v){
            var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?IR_ID=-1&Dia="+d+"&Tipo="+v);
    }	

</script>