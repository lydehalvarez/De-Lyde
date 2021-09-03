<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir

   	var Cli_ID = Parametro("Cli_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
   
	var sSQLTr  = "SELECT TA_ID, TA_CodigoIdentificador, TA_End_Warehouse_ID, TA_FolioCliente, TA_Folio "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = TA_Start_Warehouse_ID ) as ALMACENORIGEN "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = TA_End_Warehouse_ID ) as Almacen_Destino "
        sSQLTr += " , (SELECT Alm_DireccionCompleta FROM Almacen a1 WHERE a1.Alm_ID = TA_End_Warehouse_ID ) as DireccionCompleta "
        sSQLTr += " , (SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = t.Cli_ID) as Cliente "
        sSQLTr += " , (SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 65 AND Cat_ID = t.[TA_TipoTransferenciaCG65]) Tipo "
        sSQLTr += " , Alm_Nombre, Alm_Responsable, Alm_RespTelefono, Alm_Clave, Alm_Calle, Alm_Colonia "
        sSQLTr += " , Alm_Delegacion, Alm_Ciudad, Alm_CP, Lot_ID, TA_Transportista, TA_Guia "
        sSQLTr += " , Alm_RequierePermiso, Alm_HorarioIngreso, Alm_TipoAcceso, TA_Start_Warehouse_ID "
        sSQLTr += " , TA_EstatusCG89,dbo.fn_CatGral_DameDato(89,TA_EstatusCG89) as ESTATUS "
        sSQLTr += " , TA_UbicacionTienda, TA_HorarioAtencion, TA_ArchivoID "
        sSQLTr += " , Alm_CiudadC, Alm_HorarioLV, Alm_HorarioSabado, Alm_Domingo "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaRegistro,103) as FECHAREGISTRO "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaElaboracion,103) as FECHAELABRACION "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaEntrega,103) as FECHAENTREGA "
        sSQLTr += " FROM TransferenciaAlmacen t, Almacen a "
        sSQLTr += " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        sSQLTr += " AND t.TA_ID = " + TA_ID

	    bHayParametros = false
	    ParametroCargaDeSQL(sSQLTr,0)  

%>
<div class="form-horizontal">
    <div id="wrapper">
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-sm-8">
                    <div class="ibox">    
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="m-b-md">
                                        <h2 class="pull-right"><%=Parametro("TA_Folio","")%><p><small><%=Parametro("TA_FolioCliente","")%></small></p></h2>
                                        <h2><%=Parametro("Alm_Clave","")%> - <%=Parametro("Alm_Nombre","")%></h2>
                                    </div>
                                </div>
                            </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Origen</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-success"><%=Parametro("ALMACENORIGEN","")%></span></div>
                                        <label class="control-label col-xs-3">Destino</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-primary"><%=Parametro("Almacen_Destino","")%></span></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Tipo de transferencia</label>
                                        <div class="form-control-static col-xs-3"><span class="label label-info"><%=Parametro("Tipo","")%></span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Fecha entrega:</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-success"><%=Parametro("FECHAENTREGA","")%></span></div>
                                        <label class="control-label col-xs-3">Fecha de elaboraci&oacute;n:</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-primary"><%=Parametro("FECHAELABRACION","")%></span></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Fecha de registro:</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-success"><%=Parametro("FECHAREGISTRO","")%></span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Transportista:</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-success"><%=Parametro("TA_Transportista","")%></span></div>
                                        <label class="control-label col-xs-3">Gu&iacute;a:</label>
                                        <div class="form-control-static col-xs-2"><span class="label label-success"><%=Parametro("TA_Guia","")%></span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Calle:</label>
                                        <div class="form-control-static  col-xs-3"><%=Parametro("Alm_Calle","")%></div>
                                        <label class="control-label col-xs-3">Colonia:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_Colonia","")%></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Delegaci&oacute;n/ Municipio:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_Delegacion","")%></div>
                                        <label class="control-label col-xs-3">Ciudad:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_Ciudad","")%></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">C&oacute;digo postal:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_CP","")%></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Responsable:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_Responsable","")%></div>
                                        <label class="control-label col-xs-3">Tel&eacute;fono:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("Alm_RespTelefono","")%></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Horario de atenci&oacute;n:</label>
                                        <div class="form-control-static col-xs-3"><%=Parametro("TA_HorarioAtencion","")%></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">Direcci&oacute;n completa:</label>
                                        <div class="form-control-static col-xs-9"><a target="_blank" href="http://maps.google.com/?q=<%=Parametro("DireccionCompleta","")%>"><%=Parametro("DireccionCompleta","")%></a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                            <%/*%><hr>      
                            <div class="row">
                                <div class="col-lg-5">
                                    <dl class="dl-horizontal">
                                        <dt>Estatus:</dt> <dd><span class="label label-primary"><%=Parametro("ESTATUS","")%></span></dd>
                                    </dl>
                                    <dl class="dl-horizontal">
                                        <dt>Tipo:</dt> <dd><span class="label label-primary"></span></dd>
                                    </dl>
                                    <!--Datos de la Orden de compra-->
                                    <dl class="dl-horizontal">
                                        <dt>Fecha entrega:</dt>
                                        <dd><%=Parametro("FECHAENTREGA","")%></dd>
                                        <dt>Fecha de elaboraci&oacute;n:</dt>
                                        <dd><%=Parametro("FECHAELABRACION","")%></dd>
                                        <dt>Fecha de registro:</dt>
                                        <dd><%=Parametro("FECHAREGISTRO","")%></dd>
                                        <dt>Transportista:</dt>
                                        <dd><%=Parametro("TA_Transportista","")%></dd>
                                         <dt>Gu&iacute;a:</dt>
                                        <dd><%=Parametro("TA_Guia","")%></dd>                                        
                                    </dl>
                                </div>
                                <!--Datos del Proveedor-->
                                <div class="col-lg-7" id="cluster_info">
                                 <dl class="dl-horizontal">
                                 <dt>Direcci&oacute;n de entrega</dt>
                                 </dl>   
                                 <dl class="dl-horizontal">
                                        <dt>Calle:</dt>
                                        <dd><%=Parametro("Alm_Calle","")%></dd>
                                        <dt>Colonia:</dt>
                                        <dd><%=Parametro("Alm_Colonia","")%></dd>
                                        <dt>Delegaci&oacute;n/Municipio:</dt>
                                        <dd><%=Parametro("Alm_Delegacion","")%></dd>
                                        <dt>Ciudad:</dt>
                                        <dd><%=Parametro("Alm_Ciudad","")%></dd>
                                        <dt>Estado:</dt>
                                        <dd></dd>
                                        <dt>C&oacute;digo postal:</dt>
                                        <dd><%=Parametro("Alm_CP","")%></dd>
                                        <dt>Responsable:</dt>
                                        <dd><%=Parametro("Alm_Responsable","")%></dd>
                                        <dt>Tel&eacute;fono:</dt>
                                        <dd><%=Parametro("Alm_RespTelefono","")%></dd>
                                        <dt>Horario de atenci&oacute;n:</dt>
                                        <dd><%=Parametro("TA_HorarioAtencion","")%></dd>
                                    </dl>   
                                </div>
                            </div>
                            <hr><%*/%>
    <%	//HA ID: 2 INI Se agregan botones de Impresión de Documentos
    %>
                            <div class="form-group pull-right">
                                <div class="tooltip-demo">
                                    <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Orden();">
                                        <i class="fa fa-print"></i>&nbsp;Orden
                                    </button>
                                
                                    <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Albaran();">
                                        <i class="fa fa-print"></i>&nbsp;Albaran
                                    </button>
                                </div>
                            </div>
    
                            <br />
                            <br />
    <%	//HA ID: 2 FIN
    %>
                            <p></p>
                            <div class="row">
                                <div id="divArticulosPickeados"></div>                                
                            </div>        
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div id="divHistLineTimeGrid"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">

    $(document).ready(function() { 
        CargaProductos();
       // CargaHistoricoLineTime();
    });
	
	var urlBase="/pz/wms/Transferencia/";
	
	var TA = {
		Imprimir: {
			  Orden: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"SalidaAlmacenDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
			, Albaran: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"AlbaranDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
		}
	}
	
	function CargaProductos(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 
		$("#divArticulosPickeados").load("/pz/wms/TA/TA_FichaPicked.asp" + sDatos);
	}    
    
    function CargaHistoricoLineTime(){
		var sDatos  = "?OV_ID="+$("#OV_ID").val(); 
		    sDatos += "&Usu_ID="+$("#IDUsuario").val();		
		//$("#divHistLineTimeGrid").load("/pz/wms/OV/OV_FichaHistoricoGrid.asp" + sDatos);        
    }
    
    
    
    
</script>    
