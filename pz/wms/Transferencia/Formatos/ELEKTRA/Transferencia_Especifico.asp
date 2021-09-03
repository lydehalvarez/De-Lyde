<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_Folio = Parametro("TA_Folio",-1)
	
	var Transfer = "SELECT TOP 30 * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Numero FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Nume "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,TA_TipoDeRutaCG94 as TipoTienda "
		Transfer += " ,[dbo].[fn_CatGral_DameDato](94,TA_TipoDeRutaCG94) Tipo "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE  TA_Folio LIKE '%"+TA_Folio+"%'"

     var rsTran = AbreTabla(Transfer,1,0)
	 if(!rsTran.EOF){
		 var TA_TipoTransferenciaCG65 = rsTran.Fields.Item("TA_TipoTransferenciaCG65").Value 
		 var TA_ArchivoID = rsTran.Fields.Item("TA_ArchivoID").Value 
	 }
	 
	var sSQLTotal = "SELECT * "
		sSQLTotal += " FROM ( "
		sSQLTotal += " SELECT COUNT(TA_ID) Faltantes "
		sSQLTotal += " FROM TransferenciaAlmacen "
		sSQLTotal += " WHERE TA_EstatusCG51 < 4 "
		sSQLTotal += " AND TA_ArchivoID = "+TA_ArchivoID+") as tb1, "
		sSQLTotal += " ( "
		sSQLTotal += " SELECT COUNT(TA_ID) Total "
		sSQLTotal += " FROM TransferenciaAlmacen "
		sSQLTotal += " WHERE TA_ArchivoID = "+TA_ArchivoID+") as tb2 "
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLTotal,0)  
	 
	 
%>
<div class="wrapper wrapper-content animated fadeInRight">
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
                    <div style="overflow-y: scroll; /*height:500px;*/ width: auto;">
                    <%
                        var rsTran = AbreTabla(Transfer,1,0)
                        var sig = 0
                        while (!rsTran.EOF){
                            var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                            var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
                                    
                    %>
                        <div class="ibox-content" id="<%=TA_ID%>">
                            <div class="table-responsive">
                                <table class="table shoping-cart-table">
                                    <tbody>
                                    <tr>
                                        <td class="desc" width="45%">                                    
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
                                            <p> 
                                                <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                                            </p>
                                            <p> 
                                                <span class="label label-primary">Destino <strong><%=rsTran.Fields.Item("Nume").Value%></strong>&nbsp;<%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                                            </p>
                                            <p>
                                                <span class="label label-success">Folio Cliente (DO) <%=rsTran.Fields.Item("TA_FolioCliente").Value%></span>
                                            </p>
                                            <p>
                                                <span class="label label-info">Numero de remision <span id="NumFolio_<%=TA_ID%>"></span></span>
                                            </p>
                                            <p>
                                                <span class="label label-info">Numero de ruta <span id="NumRuta_<%=TA_ID%>"></span></span>
                                            </p>
                                            <input type="text" value="" style="display:none;width:50%" data-taid="<%=TA_ID%>" class="form-control InputStartPick sig<%=sig%>" id="InputStartPick<%=TA_ID%>"/>
                                            <p class="small" id="Mensaje<%=TA_ID%>"></p>
                                            <div class="btn-group" role="group" aria-label="Basic example">
                                                <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>" id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                                <input type="button" value="Cancelar pick" data-taid="<%=TA_ID%>"  id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                                <input type="button" value="Imprimir Etiqueta"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirEtiqueta"/>
                                                <input type="button" value="Env&iacute;ar datos" data-tipotienda="<%=TipoTienda%>" data-taid="<%=TA_ID%>"  class="btn btn-success btnSendData"/>
                                                <input type="button" value="Intentar hoja de ruta" data-taid="<%=TA_ID%>"  class="btn btn-success btnSendHoja"/>
                                            </div>
                                        </td>
                                        <td class="desc" width="55%">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>  
                                                        <th>Ubicaci&oacute;n</th>
                                                        <th>SKU</th> 
                                                        <th>Nombre</th>
                                                        <th>Solicitado</th>
                                                        <th>Pickeado</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var Data = " SELECT * "
                                                        Data += " ,[dbo].[fn_Ubica_rack_SKU] (6,8,TAA_SKU) as Ubicacion "
                                                        Data += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) Producto "
                                                        Data += " ,TAA_Cantidad "
                                                        Data += " ,(SELECT COUNT(*) FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = a.TA_ID AND TAA_ID = a.TAA_ID) Pickeados "
                                                        Data += " FROM TransferenciaAlmacen_Articulos a "
                                                        Data += " WHERE TA_ID = " + TA_ID
                                                    
                                                    var Total = 0
                                                    var TotalPickeados = 0
                                                    var rsArt = AbreTabla(Data,1,0)
                                                        while(!rsArt.EOF){
                                                            var TAA_SKU = rsArt.Fields.Item("TAA_SKU").Value 
                                                            var TAA_ID = rsArt.Fields.Item("TAA_ID").Value 
                                                            var Producto = rsArt.Fields.Item("Producto").Value 
                                                            var Ubicacion = rsArt.Fields.Item("Ubicacion").Value 
                                                            var TAA_Cantidad = rsArt.Fields.Item("TAA_Cantidad").Value 
                                                            var Pickeados = rsArt.Fields.Item("Pickeados").Value 
                                                            if(Ubicacion == ""){
                                                                Ubicacion = "Sin ubicaci&oacute;n"
                                                            }
                                                            Total = Total + TAA_Cantidad
                                                            TotalPickeados = TotalPickeados + Pickeados
                                                    %>		
                                                        <tr>
                                                            <td><%=Ubicacion%></td>
                                                            <td><%=TAA_SKU%></td>
                                                            <td style="text-align: left;"><%=Producto%></td>
                                                            <td><%=TAA_Cantidad%></td>
                                                            <td><span id="Cont_<%=TA_ID%>_<%=TAA_ID%>"><%=Pickeados%></span></td>
                                                        </tr>
                                                    <%	
                                                        Response.Flush()
                                                        rsArt.MoveNext() 
                                                    }
                                                    rsArt.Close()  
                                                     
                                                    %>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td style="text-align: right; color:#000">Total</td>
                                                            <td><%=Total%></td>
                                                            <td><span id="Cont_final_<%=TA_ID%>_<%=TAA_ID%>"><%=TotalPickeados%></span></td>
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
 
<script src="/pz/wms/Transferencia/Transferencia_Surtido.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
