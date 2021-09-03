<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir
    //HA ID: 3  2020-SEP-07 Agregado de Boton de Liberacion de Recepcion
	//HA ID: 4	2021-MAR-16 Agregado de Validación de si es visible por transportista

   	var Cli_ID = Parametro("Cli_ID",6)
	var TA_ID = Parametro("TA_ID",176360)
	var Usu_ID = Parametro("IDUsuario",0)
	var EsTransportista = Parametro("EsTransportista", 1) //HA ID: 4
   
	var sSQLTr  = "SELECT TA_ID,TA_TipoDeRutaCG94, TA_CodigoIdentificador, TA_End_Warehouse_ID "
        sSQLTr += ", TA_FolioCliente, TA_Folio, Alm_Numero, Man_ID, Alm_Ruta, TA_Cancelada "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = t.TA_Start_Warehouse_ID ) as ALMACENORIGEN "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID) as Origen " 
        sSQLTr += " , Alm_Nombre as Destino, ISNULL(Alm_Estado,'') as Estado "
        sSQLTr += " , ISNULL((SELECT Alm_Numero FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID),'Sin numero') as Num_Origen "
        sSQLTr += " , ISNULL(Alm_Numero,'Sin numero') as Num_Destino "
        sSQLTr += " , (SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = t.Cli_ID) as Cliente "
        sSQLTr += " , dbo.fn_CatGral_DameDato(65,t.TA_TipoTransferenciaCG65) as Tipo, TA_TipoTransferenciaCG65 "
        sSQLTr += " , Alm_Nombre, ISNULL(Alm_Responsable,'') as Responsable, Alm_RespTelefono, Alm_Clave, Alm_Calle, Alm_Colonia"
        sSQLTr += " , ISNULL(Alm_Delegacion,'') as Delegacion, ISNULL(Alm_Ciudad,'') as Ciudad "
        sSQLTr += " , Alm_CP, Lot_ID, TA_Transportista, TA_Guia, TA_Transportista2, TA_Guia2 "
        sSQLTr += " , Alm_RequierePermiso, Alm_HorarioIngreso, Alm_TipoAcceso, TA_Start_Warehouse_ID "
        sSQLTr += " , TA_EstatusCG51,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as ESTATUS "
        sSQLTr += " , TA_UbicacionTienda, TA_HorarioAtencion, TA_ArchivoID, TA_RemisionRecibida "
        sSQLTr += " , Alm_CiudadC, Alm_HorarioLV, Alm_HorarioSabado, Alm_Domingo "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaRegistro,103) as FECHAREGISTRO "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaElaboracion,103) as FECHAELABRACION "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaEntrega,103) as FECHAENTREGA "
        sSQLTr += " , ISNULL(TA_Recibido, 0 ) AS TA_EsRecibido "
        sSQLTr += " , t.Cli_ID as CLIID "
        sSQLTr += " , t.TA_FacturaCliente, TA_ArchivoID, "
		sSQLTr += " TA_EnvioParcial, CONVERT(NVARCHAR(20),TA_EnvioParcialFecha,103) as TA_EnvioParcialFecha, "
		sSQLTr += " dbo.fn_Usuario_DameNombreUsuario( TA_EnvioParcialUsuario ) as UsuarioEP  "
        sSQLTr += " FROM TransferenciaAlmacen t, Almacen a "
        sSQLTr += " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        sSQLTr += " AND t.TA_ID = " + TA_ID
		
		
		if(TA_ID == -1){
			Response.Write("<strong>Lo sentimos hubo un error al cargar la ficha, el &aacute;rea de sistemas lo esta resolviendo.</strong><br />")
			Response.Write("TA_ID_1 = "+ TA_ID)
		}

	    bHayParametros = false
	    ParametroCargaDeSQL(sSQLTr,0)  
   
       if(Cli_ID == -1){
           Cli_ID = Parametro("CLIID",-1)
       }
	   var 	TA_Folio = Parametro("TA_Folio","")
	   
       var TA_FolioRemision = ""
       var TA_FolioRuta = ""
       var TAF_FolioEntrada = ""
       var TAF_FolioCargo = ""
       var FechaFolioEntrada = ""
       var FechaFolioCargo = ""
	   var TAF_UsuarioFolioEntrada = ""
   
		//var TA_FolioRuta = BuscaSoloUnDato("ISNULL(TA_FolioRuta,'')","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,"1",0) 
		//var TA_DeRemision = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
   
        var sSQLFolios  = "select top 1 TA_FolioRemision, ISNULL(TA_FolioRuta,-1) as Ruta "
				 + ", ISNULL(TAF_FolioEntrada,'') Entrada, ISNULL(TAF_FolioCargo,'') FolioCargo "
				 + ", ISNULL((SELECT Nombre fROM [dbo].[tuf_Usuario_Informacion](TAF_UsuarioFolioEntrada) ),'Sin registros') UsuarioNE "
                 + ", CONVERT(NVARCHAR(20),TAF_FechaFolioEntrada,103) as FechaFolioEntrada "        
                 + ", CONVERT(NVARCHAR(20),TAF_FechaFolioCargo,103) as FechaFolioCargo "
                 + " from TransferenciaAlmacen_FoliosEKT "
                 + " where TA_ID = " + TA_ID
                 + " Order by TAF_ID desc "
           
     var rsFolios = AbreTabla(sSQLFolios,1,0)
     if(!rsFolios.EOF){
        TA_FolioRemision = rsFolios.Fields.Item("TA_FolioRemision").Value
        TA_FolioRuta = rsFolios.Fields.Item("Ruta").Value
        TAF_FolioEntrada = rsFolios.Fields.Item("Entrada").Value
        TAF_FolioCargo = rsFolios.Fields.Item("FolioCargo").Value
        FechaFolioEntrada = rsFolios.Fields.Item("FechaFolioEntrada").Value
        FechaFolioCargo = rsFolios.Fields.Item("FechaFolioCargo").Value
		TAF_UsuarioFolioEntrada = rsFolios.Fields.Item("UsuarioNE").Value
     }
     rsFolios.Close()  
   
    var Transportista = Parametro("TA_Transportista","")
    var Guia = Parametro("TA_Guia","")  
           
    if (Parametro("TA_Guia2","") != ""){
        Guia = Parametro("TA_Guia2","")  
        Transportista = Parametro("TA_Transportista2","")
    }   
    var ClaseEstatus = ""
    ClaseEstatus = "plain"
    switch (parseInt(Parametro("TA_EstatusCG51",0))) {
        case 4:
             ClaseEstatus = "info"   
        break;    
        case 5:
            ClaseEstatus = "primary"
        break;     
        case 10:
            ClaseEstatus = "success"
        break;    
        case 11:
            ClaseEstatus = "warning"
        break;   
        case 16:
            ClaseEstatus = "danger"
        break;        
    }   
            
    var bolEsTransportista = ( EsTransportista == 1 )
%>

<style type="text/css">
 
.Caja-Flotando {
	position: fixed;
	right: 10px;
	top: 10px;
	width: 29%;
    overflow-y: scroll;
    height: -webkit-fill-available;
  }
 
</style>
    
<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    <div id="wrapper">
        <div class="row" id="TA_Contenido">
            <div class="col-sm-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                    <h2 class="pull-right" title="<%=Parametro("TA_ID","")%>"><span data-clipboard-text="<%=TA_Folio%>" class="textCopy"><%=TA_Folio%></span><p><small><%=Parametro("TA_FolioCliente","")%></small></p></h2>
                                    <h2><span data-clipboard-text="<%=Parametro("Alm_Numero","")%>" class="textCopy"><%=Parametro("Alm_Numero","")%></span>&nbsp;-&nbsp;<span data-clipboard-text="<%=Parametro("Alm_Nombre","")%>" class="textCopy"><%=Parametro("Alm_Nombre","")%></span></h2>
                                </div>
                            </div>
                            
                            <div class="col-lg-9">
                                <strong>Origen:&nbsp;&nbsp;</strong> <%=Parametro("Num_Origen","")%>&nbsp;-&nbsp;<%=Parametro("Origen","")%> 
                                <br>
                                <strong>Destino:</strong> <%=Parametro("Num_Destino","")%>&nbsp;-&nbsp;<%=Parametro("Destino","")%> 
                                 
                            </div>                            
                            
                            <div class="col-lg-3">
                                <div class="pull-right" style="line-height: 22px;"> Estatus: 
                                    <span class="label label-<%=ClaseEstatus%>"  ><%=Parametro("ESTATUS","")%></span>        
                                    <br> Tipo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <span class="label label-primary"><%=Parametro("Tipo","")%></span> 
                                </div>
                            </div>                            
                        </div>
                        <hr>        
                        <!-- div class="row">

                        </div  --> 
                        <div class="row">
                            <div class="col-lg-5">
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Fecha entrega:</dt>
                                    <dd><%=Parametro("FECHAENTREGA","")%></dd>
                                    <dt>Fecha de elaboraci&oacute;n:</dt>
                                    <dd><%=Parametro("FECHAELABRACION","")%></dd>
                                    <dt>Fecha de registro:</dt>
                                    <dd><%=Parametro("FECHAREGISTRO","")%></dd>
                                    <dt>Corte:</dt>
                                    <dd><%=Parametro("TA_ArchivoID","")%></dd>
<%  
    var Man_ID = Parametro("Man_ID",-1)
    if(Man_ID > 1) { 
    var sSQLMan  = "select Man_Folio, Man_Operador, Man_Vehiculo, Man_Placas, Man_Usuario "
              //   + ", Prov_ID, ISNULL((select Prov_Nombre "
              //                       + " from Proveedor pv "
              //                      + " where pv.Prov_ID = ms.Prov_ID),'Sin Definir') as Transportista "
                 + ", Aer_ID, Man_Ruta "
                 + ", dbo.fn_CatGral_DameDato(94,Man_TipoDeRutaCG94) as TIPORUTA "
                 + ", Edo_ID, ISNULL((select Edo_Nombre " 
                                    + " from Cat_Estado edo "
                                   + " where edo.Edo_ID = ms.Edo_ID),'') as estado "
                 + ", Man_Borrador, Man_PeticionEnviada "
               //  + ", CASE Man_Borrador WHEN 1 THEN 'Borrador' ELSE 'Confirmado' END as ManEstatus "
              //  + ", CASE Man_PeticionEnviada WHEN 1 THEN 'Registrado con el transportista' "
             //                             + " ELSE 'No registrado' END as ManEstatus "
                 + ", CONVERT(NVARCHAR(20),Man_FechaConfirmado,103) as FechaConfirmado "        
                 + ", CONVERT(NVARCHAR(20),Man_FechaRegistro,103) as FechaRegistro "
                 + " from Manifiesto_Salida ms "
                 + " where Man_ID = " + Man_ID
    
     var rsMan = AbreTabla(sSQLMan,1,0)
            if(!rsMan.EOF){
                var Ruta = ""
                if (Parametro("Alm_Ruta",0) > 0){
                    Ruta = "R " + Parametro("Alm_Ruta",0)
                    }
                    
%> 
                <dt>&nbsp;</dt>
                <dd>&nbsp;</dd>  
                <dt>Manifiesto de salida: </dt>
                <dd><%=rsMan.Fields.Item("Man_Folio").Value%> <br><%=rsMan.Fields.Item("FechaRegistro").Value%></dd>  
                                    
                <dt>Transportista:</dt>
                <dd data-clipboard-text="<%=Transportista%>" class="textCopy"><%=Transportista%></dd>
                <dt>Gu&iacute;a:</dt>
                <dd data-clipboard-text="<%=Guia%>" class="textCopy"><%=Guia%></dd> 
                <dt>Ruta:</dt>
                <dd data-clipboard-text="<%=Ruta%>" class="textCopy"><%=Ruta%></dd> 
                <dt>Tipo ruta:</dt>
                <dd><%=rsMan.Fields.Item("TIPORUTA").Value %></dd>                 
                <dt>Estatus:</dt>              
<% if (rsMan.Fields.Item("Man_Borrador").Value == 1 ) { %>
                <dd>En Piso</dd>
<%    } else {  %>
                <dd>Man Cerrado</dd>                           
<%       if (rsMan.Fields.Item("Man_PeticionEnviada").Value == 1 ) { %>
                <dt>Confirmado:</dt>
                <dd><%=rsMan.Fields.Item("FechaConfirmado").Value%></dd>
 <%     } 
   }
            }
         rsMan.Close()   
                
        
        
    } else {
%>   
        <dt>&nbsp;</dt>
        <dd>&nbsp;</dd>
        <dt>Transportista:</dt>
        <dd data-clipboard-text="<%=Parametro("TA_Transportista","")%>" class="textCopy"><%=Parametro("TA_Transportista","")%></dd>
        <dt>Gu&iacute;a:</dt>
        <dd data-clipboard-text="<%=Parametro("TA_Guia","")%>" class="textCopy"><%=Parametro("TA_Guia","")%></dd> 
        <!-- dt>Factura Cliente:</dt>
        <dd><% //Parametro("TA_FacturaCliente","")%></dd  -->  
<%                            
    }
	if(Cli_ID == 6){
%>
        <dt>&nbsp;</dt>
        <dd>&nbsp;</dd>
        <dt>Remisi&oacute;n:</dt>
        <dd data-clipboard-text="<%=TA_FolioRemision%>" class="textCopy"><%=TA_FolioRemision%></dd>
        <dt>Hoja de ruta/ Gu&iacute;a DHL:</dt>
        <dd data-clipboard-text="<%=TA_FolioRuta%>" class="textCopy"><%=TA_FolioRuta%></dd>
<%                            
	  if(TAF_FolioEntrada != ""){
%>                            
        <dt>Folio entrada:</dt>
        <dd data-clipboard-text="<%=TAF_FolioEntrada%>" class="textCopy"><%=TAF_FolioEntrada%></dd> 
        <dt>Fecha entrada:</dt>
        <dd data-clipboard-text="<%=FechaFolioEntrada%>" class="textCopy"><%=FechaFolioEntrada%></dd> 
        <dt>Usuario nota de entrada:</dt>
        <dd data-clipboard-text="<%=TAF_UsuarioFolioEntrada%>" class="textCopy"><%=TAF_UsuarioFolioEntrada%></dd> 
        
<%                            
      }
	  if(TAF_FolioCargo != ""){
%>                               
        <dt>Folio cargo:</dt>
        <dd data-clipboard-text="<%=TAF_FolioCargo%>" class="textCopy"><%=TAF_FolioCargo%></dd>                        
        <dt>Fecha cargo:</dt>
        <dd data-clipboard-text="<%=FechaFolioCargo%>" class="textCopy"><%=FechaFolioCargo%></dd>                                                             
<%    }                         
    }
%>        
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
                                    <dd><%=Parametro("Delegacion","")%></dd>
                                    <dt>Ciudad:</dt>
                                    <dd><%=Parametro("Ciudad","")%></dd>
                                    <dt>Estado:</dt>
                                    <dd><%=Parametro("Estado","")%></dd>
                                    <dt>C&oacute;digo postal:</dt>
                                    <dd><%=Parametro("Alm_CP","")%></dd>
									<dt>Responsable:</dt>
                                    <dd><%=Parametro("Responsable","")%></dd>
									<dt>Tel&eacute;fono:</dt>
                                    <dd><%=Parametro("Alm_RespTelefono","")%></dd>
									<dt>Horario de atenci&oacute;n:</dt>
                                    <dd><%=Parametro("Alm_HorarioLV","")%></dd>
                                    <dt>&nbsp;</dt>
              					   <dd>&nbsp;</dd> 
                                   <%
								  	 if(Parametro("TA_EnvioParcial","")==0){
									var EnvioParcial = "NO"
									}else{
									var EnvioParcial = "SI"	
									}
								   %>
									<dt>Env&iacute;o Parcial:</dt>
                                    <dd><%=EnvioParcial%></dd>
                                    <%
									if(EnvioParcial=="SI"){
									%>
                                    <dt>Envi&oacute;:</dt>
                                    <dd><%=Parametro("UsuarioEP","")%></dd>
                                    <dt>Fecha env&iacute;o:</dt>
                                    <dd><%=Parametro("TA_EnvioParcialFecha","")%></dd>
									<%
									}
									%>
                                </dl>   
                            </div>
                        </div>
<%  //HA ID: 4 INI No es transportista
	if( !(bolEsTransportista) ){
		
		if( Cli_ID == 6  && Parametro("TA_EstatusCG51",0) != 11 ) { 
		
			if( Parametro("TA_EstatusCG51",0) > 5  && Parametro("TA_RemisionRecibida",0) == 0 ) {  
%>                                
                        <div class="row">
                            <div class="col-lg-12"> 
                                <div class="pull-right">
                                    <label> <input type="checkbox" class="i-checks" id="TA_RemisionRecibida"> 
                                        La nota de remisi&oacute;n firmada ya se carg&oacute; al sistema&nbsp;&nbsp;&nbsp;
                                    </label>
                                </div>
                            </div>       
                        </div> 
<%	
			}
			
		}
%>
                        <hr>                             
<%	//HA ID: 2 INI Se agregan botones de Impresión de Documentos
    //HA ID: 3 INI Se agregan botones de Liberacion de articulos de recepcion
%>

						<br />
                    
<%	
	} //HA ID: 4 FIN Existencia de Transportista
	//HA ID: 2 FIN
	
	
	//HA ID: 4 INI No es transportista
	if( !(bolEsTransportista) ){
%>
                        <div class="row">
                               
							<div class="row m-t-sm">
                                <div class="col-lg-12">
									<div class="panel blank-panel">
										<div class="panel-heading">
											<div class="panel-options">
												<ul class="nav nav-tabs">
													<li class="active"><a href="#tab-1" data-toggle="tab">Art&iacute;culos</a></li>
													<li class=""><a href="#tab-2" data-toggle="tab">Bit&aacute;cora</a></li>
													<li class=""><a href="#tab-3" data-toggle="tab">Hist&oacute;rico</a></li>
													<li class=""><a href="#tab-4" data-toggle="tab">Rastreo</a></li>
												</ul>
											</div>
										</div>

										<div class="panel-body">
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab-1">
													<div id="divArticulos"></div>
												</div>
												
												<div class="tab-pane" id="tab-2">
													
													<div id="divComentarios"></div> 
													
												</div>
												
												<div class="tab-pane" id="tab-3">
													
													<div id="divBitacora"></div>

												</div>
												
												<div class="tab-pane" id="tab-4">
													
													<div id="divRastreo"></div>
													
												</div>
												
											</div>
										</div>

									</div>
                                </div>
                            </div>
                        </div>  
<%
	} //HA ID: 4 FIN Existencia de Transportista
%>      
                    </div>
                </div>
            </div>
            <div class="col-sm-4" id="dvHistoria">
            	
                <div id="divHistLineTimeGrid"></div>
                <div id="loading">
                    <div class="spiner-example">
                        <div class="sk-spinner sk-spinner-three-bounce">
                            <div class="sk-bounce1"></div>
                            <div class="sk-bounce2"></div>
                            <div class="sk-bounce3"></div>
                        </div>
                    </div>
                </div>
                <div id="divSeries" style="margin-bottom: 100px;"></div>

            </div>
        </div>
    </div>
 
                                    
<div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="divModalComentario" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalComentario"><%= "Comentarios" %></h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalComentario" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <input type="hidden" id="comNodo" value="" />
            <div class="modal-body">
                <div class="form-group row">
                    <label for="comTitulo" class="col-sm-2 col-form-label">Titulo</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="comTitulo" placeholder="Titulo" maxlength="50">
                    </div>
                </div>
                <div class="form-group row">
					<label for="comComentario" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea id="comComentario" class="form-control" placeholder="Comentario" maxlength="150"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalComentario">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="Comentarios.Agregar();">
					<i class="fa fa-plus"></i> Agregar
				</button>
            </div>
		</div>
	</div>
</div>  
    
    
<div class="modal fade" id="modalIncidencia" tabindex="-1" role="dialog" aria-labelledby="divModalInicdencia" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="mdlIncTitulo">Seguimiento de incidencias</h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalIncidencia" aria-label="Close">
                  <span aria-hidden="true">&times;</span> Cerrar 
                </button>
            </div>
            <input type="hidden" id="Ins_ID" value="-1" />
            <input type="hidden" id="For_ID" value="-1" />   
            <div class="modal-body" id="mdlIncBody"></div>
            <div class="modal-body" id="mdlIncBodyComentarios"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalIncidencia">
                    <i class="fa fa-times"></i> <small>Cerrar</small>
				</button>
            </div>
		</div>
	</div>
</div>  


<div class="modal fade" id="CancelaModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Cancelaci&oacute;n</h4>
      </div>
      <div class="modal-body">
          <div class="form-group">
            <label class="control-label">Motivo de cancelaci&oacute;n</label>
            <textarea class="form-control" id="TA_MotivoCancelacion" placeholder="Escribe el motivo de la cancelaci&oacute;n"></textarea>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secundary" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-success btnCancela">OK</button>
      </div>
    </div>
  </div>
</div>   

<div class="modal fade" id="ModalEvento" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Tipo de evento</h4>
      </div>
      <div class="modal-body">
          <div class="form-group">
            <div class="col-md-3">
                <label class="control-label">Evento:</label>
            </div> 
            <div class="col-md-6">
				<%CargaCombo("TA_EstatusCG51",'class="form-control"',"Cat_ID","Cat_Nombre","Cat_Catalogo","Sec_ID = 51 AND Cat_ID in (18,22)","Cat_ID","Editar",0,"Seleccion evento")%>
            </div> 
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secundary" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-success" onclick="TA.Evento();">Adelante</button>
      </div>
    </div>
  </div>
</div>        

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


<input type="hidden" id="titulo"/>
                            
<!-- iCheck -->
<script src="/Template/Inspina/js/plugins/PrintJs/print.min.js"></script>
<script src="/Template/Inspina/js/plugins/iCheck/icheck.min.js"></script>                                
<script type="text/javascript">

    var VerSeries = 0
	
	$('#loading').hide()
    
    $(document).ready(function() { 

        $('.btnAutoriza').click(function(e) {
            e.preventDefault();
            $('#Autoriza_TA').val($(this).data('taid'));
            $('#ModalAutorizacion').modal('show');
            $('#Pass').focus()
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
            TA.AutorizaImpresion(request)
        });

         $('.i-checks').iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green',
        });
        
        $('#TA_RemisionRecibida').on('ifChanged', function(event) {
            //alert('checked = ' + event.target.checked);
            //alert('value = ' + event.target.value);
            TA.ActualizaRemision();
//            $('input').iCheck('check'); — change input's state to checked
//            $('input').iCheck('uncheck'); — remove checked state
//            $('input').iCheck('toggle'); — toggle checked state
//            $('input').iCheck('disable'); — change input's state to disabled
//            $('input').iCheck('enable'); — remove disabled state
//            $('input').iCheck('indeterminate'); — change input's state to indeterminate
//            $('input').iCheck('determinate'); — remove indeterminate state
//            $('input').iCheck('update'); — apply input changes, which were done outside the plugin
//            $('input').iCheck('destroy'); — remove all traces of iCheck
        });

        if($("#Cli_ID").val() != <%=Cli_ID%>){
            $("#Cli_ID").val(<%=Cli_ID%>)
        }
        
        CargaProductos();
        CargaHistoricoLineTime();
        OrdenCompraRastreo();
        Comentarios.Cargar();
    });
	
    $(document).scroll(function(e) {

      if(VerSeries == 0) {    
          if ($(document).scrollTop() > 200) {
            $("#dvHistoria").addClass("Caja-Flotando");
          } else {
            $("#dvHistoria").removeClass("Caja-Flotando");
          }
      }
	  
	}); 
	
	$(".btnCancela").click(function(e) {
        e.preventDefault();
		TA.Cancela();
    });
    
    
    
	var urlBase="/pz/wms/Transferencia/";
	
	var TA = {
		Evento:function(){
			$.post("/pz/wms/TA/TA_Ajax.asp",{
                Tarea:19,
				TA_ID:$('#TA_ID').val(),
                TA_EstatusCG51:$('#TA_EstatusCG51').val(),
                IDUsuario:$('#IDUsuario').val()
			}, function(data){
				var response = JSON.parse(data);
				if(response.result == 1){
					Avisa("success","Aviso",response.message); 
					$('#ModalEvento').modal('hide');
				}else{
					$('#TA_EstatusCG51').focus();
					Avisa("error","Error",response.message);
				}
			});
		},
		Cancela:function(){
			$.post("/pz/wms/TA/TA_Ajax.asp",{
				TA_ID:$("#TA_ID").val(),
				IDUsuario:$("#IDUsuario").val(),
				TA_MotivoCancelacion:$('#TA_MotivoCancelacion').val().trim(),
				Tarea:17
			}, function(data){
				var response = JSON.parse(data)
				if(response.result == 1){
					Avisa("success","Aviso","Transferencia cancelada");
					$("#CancelaModal").modal('hide'); 
				}else{
					Avisa("error","Error","Ocurrio un error");
				}
			});
		},Imprimir: {
			  Orden: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"SalidaAlmacenDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
			, Albaran: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"AlbaranDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
        }
        , Recibir: function(){

            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 13
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                        $("#btnRecibido").remove();
                        CargaHistoricoLineTime();
                    } else {
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        }
        , ActualizaRemision: function(){
            
            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 14
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                    } else {
                        // $("#TA_RemisionRecibida").iCheck('toggle');
                        //$("#TA_RemisionRecibida").parent().get( 0 ).removeClass("checked")
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        },
		AutorizaImpresion:function(request){
			$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
				var response = JSON.parse(data)
				if(response.result ==1){
					Avisa("success","Avisa","Impresi&oacute;n autorizada")	
					$('#ModalAutorizacion').modal('hide');
					$('#Pass').val("")
				}else{
					Avisa("error","Error",response.message)	
				}
			});
		}
        
	}
	
	function CargaProductos(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 
		$("#divArticulos").load("/pz/wms/TA/TA_FichaPicked.asp" + sDatos);
	}    
     
    function CargaHistoricoLineTime(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
            sDatos += "&Usu_ID="+$("#IDUsuario").val();
		$("#divHistLineTimeGrid").load("/pz/wms/TA/TA_Historico.asp" + sDatos);        
    }
    
    function OrdenCompraRastreo(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divRastreo").load("/pz/wms/TA/TA_Rastreo.asp" + sDatos);     
    }
    
 
var Tra_Incidencia = {
	AbrirModal: function( Insid, forid ){   
		Tra_Incidencia.LimpiarModal();
        $("#Ins_ID").val(Insid);
		$("#For_ID").val(forid);
        Tra_Incidencia.CargaBody(Insid, forid);
         
		$('#modalIncidencia').modal('show');
		//$("#comNodo").val(Insid);   
	}    
	, LimpiarModal: function(){
		$("#Ins_ID").val(-1);
		$("#For_ID").val(-1); 
	}
	, CerrarModal: function(){
		Tra_Incidencia.LimpiarModal();
		$("#modalIncidencia").modal("hide");
	}
	, CargaBody: function(Insid, forid){
        var sDatos = "?Ins_ID=" + Insid
            sDatos += "&SegGrupo=" + $("#SegGrupo").val();
            sDatos += "&Usu_ID=" + $("#IDUsuario").val();
        //&Reporta=35&Recibe=35&Lpp=1
		$("#mdlIncBody").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + sDatos)
        
        //datos demo cambiar por los buenos
        //sDatos += "&Reporta=35&Recibe=35&InsO_ID=1&Permiso=4"
        $("#mdlIncBodyComentarios").load("pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp" + sDatos)
        //http://wms.lyde.com.mx/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID=7&Reporta=35&Recibe=35&InsO_ID=1&Permiso=4
    }
    
}
 

var Comentarios = {
	Cargar: function(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divComentarios").load("/pz/wms/TA/TA_Comentario.asp" + sDatos); 
	}
	, VisualizarModal: function( prmIntComnId ){
		Comentarios.LimpiarModal();
        $('#ComentarioBody').Empty()
        $('#ModalAutorizacion').modal('show');
        
         
		
		$("#comNodo").val(prmIntComnId);
	}

	, Agregar: function(){
		
		var intIdUsuario = $("#IDUsuario").val();
		var TA_ID = $("#TA_ID").val();
		var intComn_ID = $("#comNodo").val();
		var strTitulo = $("#comTitulo").val();
		var strComentario = $("#comComentario").val();
		
		var arrRes = [];
		var bolError = false;
		
		if( strTitulo == '' ){
			arrRes.push("Agregar el Titulo");
			bolError = true;
		}

		if( strComentario == '' ){
			arrRes.push("Agregar el Comentario");
			bolError = true;
		}
		
		if( bolError ){
			
			Avisa("warning", "Comentario", "Validar Formulario: <br>" + arrRes.join("<br>") );
			
		} else {
		
			$.ajax({
				  url: "/pz/wms/TA/TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType: "json"
				, data: {
					  Tarea: 15
					, IdUsuario: intIdUsuario
					, TA_ID: $("#TA_ID").val()
					, Comn_ID: intComn_ID
					, Titulo: strTitulo
					, Comentario: strComentario
				}
				, success: function(res){
					if( parseInt(res.Error) == 0 ){
						
						Avisa("success", "Comentario", "Se agreg&oacute; el comentario a la Transferencia");
						Comentarios.Cargar();
					} else {
						Avisa("warning", "Comentario", "NO se agreg&oacute; el comentario a la transferencia");
					}
                    Comentarios.CerrarModal();
				}
			})
		}
	}
	, LimpiarModal: function(){
		$("#comNodo").val("");
		$("#comTitulo").val("");
		$("#comComentario").val("");
	}

	, CerrarModal: function(){
		Comentarios.LimpiarModal();
		
		var bolSeAbrePorModal = parseInt($("#SeAbrePorModal").val());
 
		//if( bolSeAbrePorModal == 0 ){
			$("#modalComentario").modal("hide");
		//} else {
//			
//			$.post("/pz/wms/OV/OV_Ficha.asp"
//				, {TA_ID:$("#TA_ID").val()}
//				, function(data){
//					$("#modalBodySO").html(data);
//					$("#SeAbrePorModal").val(1);
//				}
//			);
//			
//		}
	}
}

$('.btnSendHoja').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
	TransferenciasFunciones.ReintenataHoja(TA_ID)
});

$('.btnRecuperaDoc').click(function(e) {
    e.preventDefault();
	var Folio = $(this).data('folio')
	var Tipo = $(this).data('tipo')
	var titulo = $(this).data('titulo')
	$('#titulo').val(titulo)
	TransferenciasFunciones.RecuperaHoja(Tipo,Folio)
});

var TransferenciasFunciones = {
	ImprimeGuia:function(guia,name) {
		printJS({
			printable: guia,
			type: 'pdf',
			documentTitle:"Example",
			base64: true
		})	
//		var winparams = 'dependent=yes,locationbar=no,scrollbars=yes,menubar=yes,'+
//		'resizable,screenX=50,screenY=50,width=850,height=1050';
//
//		var htmlPop = '<html><head>'
//						+'</head><body>'
//						+'<title>'+name+'</title>'
//						+'<embed width=100% height=100%'
//						+ ' type="application/pdf"'
//						+ ' src="data:application/pdf;base64,'
//						+ guia
//						+ '"></embed>'
//						+ "</body></html>"; 
//						
//		var printWindow = window.open ("", "_blank", winparams);
//		printWindow.document.write (htmlPop);
		//printWindow.print();
	},
	ReintenataHoja:function(TA_ID){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/recupera/hoja/ruta?TA_ID="+TA_ID,
			success: function(data){
				console.log(data) 
				if(data.data.result != -1){
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.data.data.folios != null){
						TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
					}
				}else{
					swal({
					  title: data.data.message,
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
	RecuperaHoja:function(Tipo,Folio){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/ReimprimeSG?Folio="+Folio+"&Tipo="+Tipo,
			success: function(data){
				console.log(data) 
				if(data.data.result != -1){
					if(data.result == 1){
						if(data.data.pdf != null){
							Avisa("success","Aviso",$('#titulo').val()+" recibida");
							TransferenciasFunciones.ImprimeGuia(data.data.pdf,"Documento "+data.data.folioDocumento)
						}else{
							TransferenciasFunciones.Alerta("Error en documento","Elektra no gener&oacute; correctamente el documento","error")
						}
					}
				}else{
					TransferenciasFunciones.Alerta(data.message,"Elektra no gener&oacute; correctamente el documento","error")
				}
			}
		});
	},
	Alerta:function(titulo,descrip,tipo){
		swal({
		  title: titulo,
		  text: descrip,
		  type: tipo,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		});		
	}
}


    
</script>    

    
