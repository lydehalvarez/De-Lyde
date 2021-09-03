<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var Pendiente = Parametro("Pendiente",-1)
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	var TA_Folio = Parametro("TA_Folio","")
	var IDUsuario = Parametro("IDUsuario",-1)
	
	
	var Transfer = "SELECT TOP 30 * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " , Alm_Numero as Nume "
		Transfer += " , Alm_Nombre as Sucursal_Destino "
		Transfer += " ,TA_TipoDeRutaCG94 as TipoTienda "
		Transfer += " ,Cat_Nombre as Tipo "
		Transfer += " FROM TransferenciaAlmacen h, almacen a, Cat_Catalogo cg "
		Transfer += " WHERE a.Alm_ID = h.TA_End_Warehouse_ID AND h.Cli_ID = 6 "
        Transfer += " AND cg.Sec_ID = 94 "
		Transfer += " AND TA_TipoDeRutaCG94 = cg.Cat_ID "
	
	if(TA_Folio != ""){
		Transfer += " AND TA_Folio LIKE '%"+TA_Folio+"%'"
		
		
	
	}else if(TA_ArchivoID > -1 && Pendiente == -1){
		Transfer += " AND TA_ArchivoID = "+TA_ArchivoID
		Transfer += " AND TA_EstatusCG51 < 4 "
	
	}else if(TA_ArchivoID > -1 && Pendiente == 1){
		Transfer += " AND TA_ArchivoID = "+TA_ArchivoID
		Transfer += " AND TA_EstatusCG51 = 4 "
	
	}
		Transfer += " ORDER BY TA_Orden ASC "
	
	
	
	 var rsTran = AbreTabla(Transfer,1,0)
	if(!rsTran.EOF){
		var TA_TipoTransferenciaCG65 = rsTran.Fields.Item("TA_TipoTransferenciaCG65").Value 
		var Tda_ID = rsTran.Fields.Item("Tda_ID").Value
		var ArmaKit = false
		if(Tda_ID == 9379){
			ArmaKit = true
		}

%>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="col-md-12"> 
        <div class="ibox">
            <div class="row">
                <div class="form-group">
                    <div class="btn-group" role="group" aria-label="Basic example">
                        <input type="button" value="Imprimir etiquetas" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnEtiquetaMasivo"/>
                        <input type="button" value="Imprimir consolidado" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnConsolidado"/>
                        <input type="button" value="Obtener series" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnSeries"/>
                        <input type="button" value="Direcciones" data-archid="<%=TA_ArchivoID%>" data-tipo="<%=TA_TipoTransferenciaCG65%>" class="btn btn-success btnDirecciones"/>
                    </div>
                    <input type="text" class="form-control Cargadoc" placeholder="Escanea el TRA para imprimir remision" />
                </div>
            </div>
        </div>
    </div>
	<div class="row">
        <div class="col-md-12">
            <div class="ibox" id="ibox2">
            	<div class="ibox-content">
                    <div class="sk-spinner sk-spinner-wave">
                        <div class="sk-rect1"></div>
                        <div class="sk-rect2"></div>
                        <div class="sk-rect3"></div>
                        <div class="sk-rect4"></div>
                        <div class="sk-rect5"></div>
                    </div>            
                    <div>
                    <%
                        var sig = 0
                        while (!rsTran.EOF){
							var Fondo = ""
							var TablaStyle = ""
							var TablaClass = "table-striped"
                            var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                            var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
							var TA_EstatusCG51 = rsTran.Fields.Item("TA_EstatusCG51").Value
							if(TA_EstatusCG51 > 2 ){
								Fondo = "bg-success"
								TablaStyle = 'style="background:darkgray;"'
								TablaClass = ""
							}
							if((TA_EstatusCG51 == 11) || (TA_EstatusCG51 == 19)){
								Fondo = "bg-danger"
							}
							
						if(TA_Folio != ""){
							Response.Write('<input type="hidden" id="Caja_TA" value="'+TA_ID+'"/>')
						}
%>
                        <div class="ibox-content <%=Fondo%>" id="<%=TA_ID%>">
                            <div class="table-responsive">
                                <table class="table shoping-cart-table">
                                    <tbody>
                                    <tr>
                                        <td class="desc" width="30%">                                    
                                            <div class="widget style1 navy-bg">
                                                 <div class="row vertical-align">
                                                    <div class="col-xs-3">
                                                        <i class="fa fa-dropbox fa-2x"></i>
                                                    </div>
                                                    <div class="col-xs-9 text-right">
                                                        <h3 class="font-bold"><%=rsTran.Fields.Item("TA_Folio").Value%></h3>
                                                    </div>
                                                </div>
                                            </div> 
                                            <div class="widget style1 lazur-bg">
                                                 <div class="row vertical-align">
                                                    <div class="col-xs-3">
                                                        <i class="fa fa-truck fa-2x"></i>
                                                    </div>
                                                    <div class="col-xs-9 text-right">
                                                        <h3 class="font-bold"><%=rsTran.Fields.Item("Tipo").Value%></h3>
                                                    </div>
                                                </div>
                                            </div> 
                                            
                                            <ul class="list-group clear-list">
                                                 <li class="list-group-item fist-item">
                                                    &nbsp;
                                                </li>
                                                <li class="list-group-item">
                                                    <label >Origen:</label>
                                                    <%=rsTran.Fields.Item("Sucursal_Origen").Value%>
                                                </li>
                                                <li class="list-group-item">
                                                    <label >Destino:</label>
                                                    <%=rsTran.Fields.Item("Nume").Value%></strong>&nbsp;<%=rsTran.Fields.Item("Sucursal_Destino").Value%>
                                                </li>
                                                <li class="list-group-item">
                                                    <label >Folio Cliente (DO):</label>
                                                    <%=rsTran.Fields.Item("TA_FolioCliente").Value%>
                                                </li>
                                                <li class="list-group-item">
                                                    <label >N&uacute;mero de remisi&oacute;n:</label>
                                                    <span id="Remision_<%=TA_ID%>"></span>
                                                </li>
                                                <li class="list-group-item">
                                                   <label >N&uacute;mero de ruta:</label>
                                                   <span id="Ruta_<%=TA_ID%>"></span>
                                                </li>
                                                 <li class="list-group-item">
                                                    &nbsp;
                                                </li>
                                            </ul>
                                             
                                            <input type="text" value="" style="display:none;width:50%" data-taid="<%=TA_ID%>" class="form-control InputStartPick sig<%=sig%>" id="InputStartPick<%=TA_ID%>"/>
                                            <p class="small" id="Mensaje<%=TA_ID%>"></p>
                                            

                                            <%if(TA_EstatusCG51 < 3){%>
                                            
                                            <div class="btn-group" role="group" aria-label="Basic example">
                                            
                                                <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;"
                                                       id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                                
                                                <input type="button" value="Cancelar pick" data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;"
                                                       id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                                
                                                <input type="button" value="Etiqueta (B)" id="btnImprimirEtiqueta"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 113px;"
                                                       class="btn btn-info btnCaja"/>
                                                <br>
                                               <input type="button" value="Env&iacute;ar datos"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 113px; margin-top: 5px;"
                                                       class="btn btn-success btnSinRuta"/>
                                            
<%/*%>											<%}else{%>
                                                <input type="button" value="Env&iacute;ar datos"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 113px; margin-top: 5px;"
                                                       data-tipotienda="<%=TipoTienda%>" class="btn btn-success btnSendData"/>
                                            
                                            <%}%>
<%*/%>                                                <input onclick="$('#Autoriza_TA').val($(this).data('taid'));$('#ModalAutorizacion').modal('show');" type="button" value="Autorizaci&oacute;n" data-taid="<%=TA_ID%>" 
                                                       style="margin-right: 5px;width: 113px; margin-top: 5px;"
                                                       class="btn btn-success btnAutoriza"/>
                                                 <br>  
                                               <input type="button" value="Salida parcial"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 113px; margin-top: 5px;" id="Parcial_<%=TA_ID%>"
                                                       class="btn btn-warning btnEnviaParcial"/>
                                                 
<!--                                                <input type="button" value="Caja Prueba ignorar"  data-taid="<%=TA_ID%>"
                                                style="margin-right: 5px;margin-top: 5px;"
                                                       class="btn btn-info btnCaja"/>
-->                                                       
                                            </div>
                                            <%}else{%>
                                            <div class="btn-group" role="group" aria-label="Basic example">
                                                <input onclick="$('#Autoriza_TA').val($(this).data('taid'));$('#ModalAutorizacion').modal('show');" type="button" value="Autorizaci&oacute;n" data-taid="<%=TA_ID%>" 
                                                       style="margin-right: 5px;width: 140px; margin-top: 5px;"
                                                       class="btn btn-info btnAutoriza"/>
                                               <br />
                                               
                                               <input type="button" value="Env&iacute;ar datos" style="display:none"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 113px; margin-top: 5px;"
                                                       class="btn btn-success btnSinRuta"/>
                                               <br />

												
                                                <input type="button" value="Etiqueta (B)" id="btnImprimirEtiqueta"  data-taid="<%=TA_ID%>"
                                                       style="margin-right: 5px;width: 140px;"
                                                       class="btn btn-info btnCaja"/>
                                                       
											</div>	
											<%}%>
                                        </td>
                                        <td class="desc" width="70%">
                                            <table  style="font-size:initial;color: black;" class="table table-hover table_<%=TA_ID%>">
                                                <thead>
                                                    <tr>  
                                                        <th>SKU</th> 
                                                        <th>Nombre</th>
                                                        <th>Solicitado</th>
                                                        <th>Pickeado</th>
                                                        <%if(ArmaKit){%>
                                                        <th width="25%">Acci&oacute;n</th>
                                                        <%}%>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var Total = 0
                                                    var TotalPickeados = 0

													if(ArmaKit){
														
														var	Data = " SELECT TA_ID,-1 TAA_ID,TAA_SKU,SUM(TAA_Cantidad) Cantidad,a.Pro_ID,SUM(TAA_CantidadPickiada) Pickeada,SUM(TAA_CantidadOriginal) Original,'' Ubicacion,Pro_Nombre Producto,Pro_EsSerializado Serializado" 
															Data += " ,(SELECT COUNT(*) FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = a.TA_ID AND Pro_ID = a.Pro_ID) Pickeados  " 
															Data += " FROM TransferenciaAlmacen_Articulos a , Producto b "
															Data += " WHERE TA_ID = " + TA_ID
															Data += " AND a.Pro_ID in (2223) "
															Data += " AND a.Pro_ID = b.Pro_ID " 
															Data += " GROUP BY TA_ID,a.Pro_ID,TAA_SKU,Pro_Nombre,Pro_EsSerializado,Pro_EsSerializado " 
															Data += " UNION " 
														    Data += " SELECT TA_ID,TAA_ID,TAA_SKU,TAA_Cantidad,a.Pro_ID,TAA_CantidadPickiada,TAA_CantidadOriginal ,[dbo].[fn_Ubica_rack_SKU] (6,8,TAA_SKU) as Ubicacion   "
															Data += " , Pro_Nombre Producto  "
															Data += " , Pro_EsSerializado  Serializado  "
															Data += " ,(SELECT COUNT(*) FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = a.TA_ID AND TAA_ID = a.TAA_ID) Pickeados "
															Data += " FROM TransferenciaAlmacen_Articulos a , Producto b "
															Data += " WHERE TA_ID = " + TA_ID
															Data += " AND a.Pro_ID not in (2223) "
															Data += " AND a.Pro_ID = b.Pro_ID " 
														
													}else{
														var Data = " SELECT * "
															Data += " ,[dbo].[fn_Ubica_rack_SKU] (6,8,TAA_SKU) as Ubicacion "
															Data += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) Producto "
															Data += " ,(SELECT Pro_EsSerializado FROM Producto WHERE Pro_ID = a.Pro_ID) Serializado "
															Data += " ,TAA_Cantidad Cantidad"
															Data += " ,(SELECT COUNT(*) FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = a.TA_ID AND TAA_ID = a.TAA_ID) Pickeados "
															Data += " FROM TransferenciaAlmacen_Articulos a "
															Data += " WHERE TA_ID = " + TA_ID
													}
                                                    
                                                    var rsArt = AbreTabla(Data,1,0)
                                                        while(!rsArt.EOF){
                                                            var TAA_SKU = rsArt.Fields.Item("TAA_SKU").Value 
                                                            var TAA_ID = rsArt.Fields.Item("TAA_ID").Value 
                                                            var Producto = rsArt.Fields.Item("Producto").Value 
                                                            var Ubicacion = rsArt.Fields.Item("Ubicacion").Value 
                                                            var TAA_Cantidad = rsArt.Fields.Item("Cantidad").Value 
                                                            var Pickeados = rsArt.Fields.Item("Pickeados").Value 
															var Serializado = rsArt.Fields.Item("Serializado").Value
															var Pro_ID = rsArt.Fields.Item("Pro_ID").Value
															var Color = ""
                                                            if(Ubicacion == ""){
                                                                Ubicacion = "Sin ubicaci&oacute;n"
                                                            }
															if(Pickeados < TAA_Cantidad){
																Color = 'style="color:#F00"'
															}
                                                            Total = Total + TAA_Cantidad
                                                            TotalPickeados = TotalPickeados + Pickeados
                                                    %>		
                                                        <tr id="Renglon_<%=TA_ID%>_<%=TAA_ID%>">
                                                            <td style="text-align: left;"><%=TAA_SKU%></td>
                                                            <td style="text-align: left;"><%=Producto%></td>
                                                            <td ><%=TAA_Cantidad%></td>
                                                            <%if(ArmaKit && Pro_ID == 2223){
																var object = '{TAA_SKU:"'+TAA_SKU+'",TA_ID:'+TA_ID+',Pro_ID:'+Pro_ID+',input:$(this)}'
																%>
                                                            	<td <%=Color%>><span id="Cont_<%=TA_ID%>_<%=TAA_SKU%>"><%=Pickeados%></span></td>
                                                            	<td>
                                                                <a class="btn btn-primary" id="btnNewKit<%=TA_ID%>_<%=Pro_ID%>" onclick='Kit.NuevoKit(<%=object%>)'><i class="fa fa-tag"></i>&nbsp;Armar kit RFID</a>
                                                                <a class="btn btn-danger" id="btnCancelKit<%=TA_ID%>_<%=Pro_ID%>" style="display:none" onclick='Kit.CancelarKit(<%=object%>)'><i class="fa fa-trash"></i>&nbsp;Cancelar kit</a>
                                                                </td>
                                                            <%}else{%>
                                                            <td <%=Color%>><span id="Cont_<%=TA_ID%>_<%=TAA_ID%>"><%=Pickeados%></span></td>
                                                            <%}%>
                                                       </tr>
                                                    <%	
                                                        Response.Flush()
                                                        rsArt.MoveNext() 
                                                    }
                                                    rsArt.Close()  

                                                    %>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                            <td style="text-align: right; color:#000">Total:</td>
                                                            <td><%=Total%></td>
                                                            <td><span id="Cont_final_<%=TA_ID%>"><%=TotalPickeados%></span></td>
                                                            <%if(ArmaKit){%>
                                                            <td>&nbsp;</td>
                                                            <%}%>
                                                        </tr>
                                                </tbody>
                                            </table>
                                            <br />
                                            <br />
                                            <table style="font-size:initial;color: black;" class="table table-hover table_<%=TA_ID%>">
                                                <thead>
                                                    <tr>  
                                                        <th width="10%">ID</th>
                                                        <th width="15%">Articulos</th>
                                                        <th width="40%">Picking by</th> 
                                                        <th width="45%">&Uacute;ltimo picking</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var DataU = " SELECT TAS_Usuario ID,COUNT(*) Articulos"
														DataU += ",(SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](TAS_Usuario)) Usuario "
														DataU += ",CONVERT(NVARCHAR(10),MAX(TAS_FechaRegistro),103) + ' - ' + CONVERT(NVARCHAR(10),MAX(TAS_FechaRegistro),108) UltimoRegistro  "
														DataU += " FROM [dbo].[TransferenciaAlmacen_Articulo_Picking] "
														DataU += " WHERE TA_ID = " + TA_ID
														DataU += " GROUP BY TAS_Usuario "
														
                                                    
                                                    var rsUsua = AbreTabla(DataU,1,0)
                                                        while(!rsUsua.EOF){
                                                            var ID = rsUsua.Fields.Item("ID").Value 
                                                            var Articulos = rsUsua.Fields.Item("Articulos").Value 
                                                            var Usuario = rsUsua.Fields.Item("Usuario").Value 
                                                            var UltimoRegistro = rsUsua.Fields.Item("UltimoRegistro").Value 
                                                    %>		
                                                        <tr>
                                                            <td style="text-align:left"><%=ID%></td>
                                                            <td style="text-align:left"><%=Articulos%></td>
                                                            <td style="text-align:left"><%=Usuario%></td>
                                                            <td style="text-align:left"><%=UltimoRegistro%>&nbsp;hrs</td>
                                                        </tr>
                                                    <%	
                                                        Response.Flush()
                                                        rsUsua.MoveNext() 
                                                    }
                                                    rsUsua.Close()  
                                                    %>
                                                </tbody>
                                            </table>
                                            <br />
                                            <table style="font-size:initial;color: black;" class="table table-hover table_<%=TA_ID%>">
                                                <thead>
                                                    <tr>  
                                                        <th width="50%">Etiqueta impresa por</th> 
                                                        <th width="50%">Etiqueta autorizada por impresa por</th> 
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var DataUImp = " SELECT ISNULL((SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](TA_DocImpresoUsu)),'N/A') UsuarioIm "+
																",ISNULL((SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion]([TA_DocImpAutUsuario])),'N/A') UsuarioAut "+
																" FROM TransferenciaAlmacen "+
																" WHERE TA_ID = "+TA_ID
														
                                                    //Response.Write(DataUImp)
                                                    var rsUsuaIm = AbreTabla(DataUImp,1,0)
														if(!rsUsuaIm.EOF){
															var Usuario = rsUsuaIm.Fields.Item("UsuarioIm").Value 
															var UsuarioAut = rsUsuaIm.Fields.Item("UsuarioAut").Value 
														%>		
															<tr>
																<td style="text-align:left"><%=Usuario%></td>
																<td style="text-align:left"><%=UsuarioAut%></td>
															</tr>
														<%	
														}else{
														%>		
															<tr>
																<td colspan="2">A&uacute;n no impreso</td>
															</tr>
														<%	
														}
                                                    %>
                                                </tbody>
                                            </table>

                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <%	
                            Response.Flush()
                            rsTran.MoveNext() 
                        }
                        rsTran.Close()   
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%	
	}else{
	
	%>
    <div class="ibox-content text-center">
        <h2><strong>Lo sentimos no se encontr&oacute; la informaci&oacute;n o no le pertenece al cliente</strong></h2>
    </div>
    <%
	}
%>

<div class="modal fade" id="ModalAutorizacion" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Autorizaci&oacute;n de supervisor</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-3"><strong>C&oacute;digo del supervisor</strong></label>
            <div class="col-md-6">
                <input type="password" class="form-control" id="Pass" value=""/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAutorizaSuper">Autorizar</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="ModalParcial" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h2 class="modal-title">Autorizaci&oacute;n de supervisor <strong>(Salida Parcial)</strong></h2>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-3"><strong>C&oacute;digo del supervisor</strong></label>
            <div class="col-md-6">
                <input type="password" class="form-control" id="PassParcial" value=""/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAutorizaEnterga">Autorizar entrega parcial</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ModalCajas" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Cantidad de cajas</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-4"><strong>Cantidad de cajas</strong></label>
            <div class="col-md-4">
                <input type="number" min="1" max="99" onkeydown="return false" class="form-control" id="NumeroCajas" value="1"/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnConfirmaCaja">Continuar</button>
      </div>
    </div>
  </div>
</div>


<input type="hidden" id="Autoriza_TA"/>
<input type="hidden" id="Caja_TA"/>
<input type="hidden" id="NumCaja_TA"/>
<script src="/Template/Inspina/js/plugins/PrintJs/print.min.js"></script>
<script src="/pz/wms/Transferencia/Transferencia_Surtido.js"></script>
<script type="application/javascript">

$('.addNoSerializado').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
	var TAA_ID = $(this).data('taaid')
	var Pro_ID = $(this).data('proid')
	var request = {
		Tarea:9,
		TA_ID:TA_ID,
		TAA_ID:TAA_ID,
		Pro_ID:Pro_ID,
		Cantidad:$("#"+TA_ID+"_"+Pro_ID+"_"+TAA_ID).val(),
		IDUsuario:$('#IDUsuario').val()
	}
	
	NoSeriarializado.Inserta(request)
	$("#"+TA_ID+"_"+Pro_ID+"_"+TAA_ID).val(0)
});

$('.btnEtiquetaMasivo').click(function(e) {
    e.preventDefault();
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetaMasiva.asp?TA_ArchivoID="+<%=TA_ArchivoID%>);
});


$('.btnAutoriza').click(function(e) {
    e.preventDefault();
	$('#Autoriza_TA').val($(this).data('taid'));
	
});

$('.btnEnviaParcial').click(function(e) {
    e.preventDefault();
	$('#Autoriza_TA').val($(this).data('taid'));
	$('#ModalParcial').modal('show');
});


$('.btnCaja').click(function(e) {
    e.preventDefault();
	$('#ModalCajas').modal('show');
	$('#Caja_TA').val($(this).data('taid'))
});
$('#ModalCajas').on('shown.bs.modal', function () {
	$('#NumeroCajas').val(1)

	$('#NumeroCajas').focus()
});

//$(document).keydown(function(event) {
//	console.log(event.which)
//	if(event.which == 66){
//		$('#ModalCajas').modal('show'); 
//	}
//});

$( "#NumeroCajas" ).keydown(function(event) {
	var Tota = parseInt($(this).val())
	console.log(event.which)
	if(Tota > 0){
		if(event.which == 38){
			Tota++
			$(this).val(Tota)
		}else if(event.which == 40){
			if(Tota != 1){
				Tota--
			$(this).val(Tota)
			}
		}
	}
	if(event.which == 32){
		$('#ModalCajas').modal('hide');
		$('#NumCaja_TA').val(Tota)
		NoSeriarializado.CantidadCaja()
	}
});

$('.addScanSKU').keydown(function(event) {
	if(event.which == 13){
		var DatoIngreso = $(this).val().substr(3,100);
		console.log(DatoIngreso);
	}
});




$('.btnConfirmaCaja').click(function(e) {
    e.preventDefault();
	$('#ModalCajas').modal('hide');
	var Tota = parseInt($('#NumeroCajas').val())
	$('#NumCaja_TA').val(Tota)
	NoSeriarializado.CantidadCaja()
});



$('.btnSinRuta').click(function(e) {
    e.preventDefault();
	$(this).prop('disabled',true)
	var TA_ID = $(this).data("taid");
	NoSeriarializado.GetDataGuia(TA_ID,$(this))
	swal({
	  title: 'Datos enviados',
	  text: "En un momento obtendremos respuesta",
	  type: "success",
	  confirmButtonClass: "btn-success",
	  confirmButtonText: "Ok" ,
	  closeOnConfirm: true,
	  html: true
	},
	function(data){
	});		

});


$('.btnAutorizaSuper').click(function(e) {
    e.preventDefault();
	var TA_ID = $('#Autoriza_TA').val();
	var request = {
		Tarea:10,
		TA_ID:TA_ID,
		Batman:$('#Pass').val(),
		IDUsuario:$('#IDUsuario').val()
	}
	NoSeriarializado.AutorizaImpresion(request)
});


$('.btnAutorizaEnterga').click(function(e) {
    e.preventDefault();
	var TA_ID = $('#Autoriza_TA').val();
	var request = {
		Tarea:12,
		TA_ID:TA_ID,
		Batman:$('#PassParcial').val()
	}
	NoSeriarializado.AutorizaSalidaParcial(request)
});



$('#Pass').on('keypress',function(e) {
	if(e.which == 13) {
		var TA_ID = $('#Autoriza_TA').val();
		var request = {
			Tarea:10,
			TA_ID:TA_ID,
			Batman:$('#Pass').val(),
			IDUsuario:$('#IDUsuario').val()
		}
	NoSeriarializado.AutorizaImpresion(request)
	}
});

$('.Cargadoc').on('keypress',function(e) {
	if(e.which == 13) {
		var Folio = $(this).val().replace("'","-");
		$(this).val("")
		NoSeriarializado.RecuperaHoja(Folio);
	}
});

var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'


var Kit = {
	NuevoKit:function(arr){
		arr.input.hide('slow')
		$('#btnCancelKit'+arr.TA_ID+'_'+arr.Pro_ID).show('slow')
		$('#btnCancelKit'+arr.TA_ID+'_'+arr.Pro_ID).css("display","block")
		var Renglon = '<tr class="bg-primary" id="tr_'+arr.TA_ID+'_'+arr.Pro_ID+'">'+
						'<td align="justify"><strong style="color:#000;">Kit <br>'+arr.TAA_SKU+'</strong></td>'+
						'<td colspan="2"><input id="RFID_'+arr.TA_ID+'_'+arr.Pro_ID+'" onkeypress="Kit.SaveRFID($(this),event,'+arr.TA_ID+','+arr.Pro_ID+')" style="color:#000;" type="text" class="form-control" placeholder="Ingresa el RFID" /></td>'+
						//'<td colspan="2"><input id="Serie_'+arr.TA_ID+'_'+arr.Pro_ID+'" style="color:#000;" disabled type="text" class="form-control" placeholder="Ingresa las series" /></td>'+
					  '</tr>'
		
		$(Renglon).insertAfter(arr.input.closest('tr'));
		setTimeout(function(){$('#RFID_'+arr.TA_ID+'_'+arr.Pro_ID).focus()},1800)
		
		
	},
	CancelarKit:function(arr){
		arr.input.hide('slow')
		$('#btnNewKit'+arr.TA_ID+'_'+arr.Pro_ID).show('slow')
		$('#tr_'+arr.TA_ID+'_'+arr.Pro_ID).hide('slow',function(){$(this).remove()})
	},
	SaveRFID:function(input,e,TA_ID,Pro_ID){
		if (e.keyCode == 13) {
			var arr = {
				TA_ID:TA_ID,
				Pro_ID:Pro_ID,
				RFID:input.val().trim().toString(),
				IDUsuario:$('#IDUsuario').val(),
				Test:false 
			}
			if(arr.RFID.substring(0,4) == "9000"){
				$.ajax({
					type: 'post',
					data: JSON.stringify(arr),
					contentType:'application/json',
					url: "https://wms.lydeapi.com/api/Transferencia/Kit/RFID",
					success: function(resp){
						console.log(resp) 
						if(resp.result == 1){
							input.prop('disabled',true);
							$('#Serie_'+arr.TA_ID+'_'+arr.Pro_ID).prop('disabled',false)
							Avisa("success","RFID asigando al kit","El RFID "+arr.RFID +" fue asigando de manera correcta")
						}else{
							Kit.Notificacion("Ups!",resp.message,"error")
							input.val("").focus()
						}
					}
				});
				console.log(arr)
			}else{
				Kit.Notificacion("RFID no permitido","El RFID no cumple con los caracteres necesarios","error")
			}
			//input.prop('disabled',true)
		}
	},
	DeleteRFID:function(){
		
	},
	Notificacion:function(Titulo,Cuerpo,Tipo){
		swal({
		title: Titulo,
		text: Cuerpo,
		type: Tipo,
		confirmButtonClass: "btn-success",
		confirmButtonText: "Ok" ,
		closeOnConfirm: true,
		html: true
		});	
	}
	
}


var NoSeriarializado ={
	ScannSKU:function(){
		
		
	},
	finishPicking:function(TA_ID){
		$.ajax({
			type: 'post',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/Surtido?TA_ID="+TA_ID,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					Avisa("success","Aviso","Remision recibida");
					//TransferenciasFunciones.GeneraRutaDedicada(TA_ID,datos.data.data.folioDocumento)
					TransferenciasFunciones.ImprimeGuia(datos.data.data.pdf,"Remision "+datos.data.data.folioDocumento[0])
				}else{
					var texto = "Comunicarse al &aacute;rea de sistemas"
					if(datos.message != null){
						texto = datos.message
					}
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal',
					  text: texto,
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		

				}
			}
			
		});
	},
	GetDataGuia:function(taid,btn){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
		Tarea:5,
		TA_ID:taid
		}
		, function(data){
			var obj = JSON.parse(data)
			NoSeriarializado.PutGuiaAG(taid,obj,btn)
		});
	},
	PutGuiaAG:function(TA_ID,obj,btn){
		var myJSON = JSON.stringify(obj);
		$.ajax({
			type: 'post',
			data: myJSON,
			contentType:'application/json',
			url: "http://198.38.94.238:8543/api/ag/GuiaDeEmbarque",
			success: function(data){
				console.log(data) 
				if(data.result == 1){
					Avisa("success","Aviso","Guia de AG recibida");
					//TransferenciasFunciones.ImprimeGuia(data.data.image,"AG")
					NoSeriarializado.finishPicking(TA_ID)
					Avisa("success","Aviso","Guia de AG generada");
				}else{
					btn.prop('disabled',false)
				}
			}
		});
	},
	Inserta:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				Avisa("success","Avisa","Datos colocados exitosamente")	
				$('#Cont_'+request.TA_ID+'_'+request.TAA_ID).html(response.Escaneados)
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	},
	AutorizaImpresion:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				Avisa("success","Avisa","Impresi&oacute;n autorizada")	
				$('#ModalAutorizacion').modal('hide');
				$('#Pass').val("")
				$('.btnSinRuta').css('display','block');
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	},
	CantidadCaja:function(){
		var request = {
			Tarea:11,
			TA_ID:$('#Caja_TA').val(),
			CantidadCaja:$('#NumCaja_TA').val()
		}
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetasTransferenciaV2.asp?TA_ID="+request.TA_ID+"&Cajas="+request.CantidadCaja+"&IDUsuario="+$('#IDUsuario').val());

				Avisa("success","Avisa","Cajas asignadas")	
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	}, 
	AutorizaSalidaParcial:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				Avisa("success","Avisa",response.message)	
				$('#ModalParcial').modal('hide');
				$('#Pass').val("")
				$('#Parcial_'+request.TA_ID).hide("slow")
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	},
	RecuperaHoja:function(Folio){
		$.ajax({
			type: 'GET',
			cache:false,
			async:true,
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/ReimprimeSG?Folio="+Folio+"&Tipo=1",
			success: function(data){
				console.log(data) 
				$(this).val("")

				if(data.data.result != -1){
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.result == 1){
						NoSeriarializado.ImprimeGuia(data.data.pdf,"Documento "+data.data.folioDocumento)
					}
				}else{
					swal({
					  title: data.message,
					  text: "Elektra no gener&oacute; correctamente el documento",
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		
				}
			}
		});
	},
	ImprimeGuia:function(guia,name) {
		printJS({
			printable: guia,
			type: 'pdf',
			base64: true
		})	
	}
}

</script>
