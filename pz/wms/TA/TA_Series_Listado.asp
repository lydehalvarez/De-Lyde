<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-26 Series Listado: Creación de Archivo
// HA ID: 2 2021-AGO-03 Siniestro: Condicion de siniestro Cerrado
// HA ID: 3 2021-Ago-24 EntregaParcial: Condicion de EntregaParcial

var cxnTipo = 0

var rqIntTA_ID = Parametro("TA_ID", -1)
var rqIntTAA_ID = Parametro("TAA_ID", -1)

var Series = {
    Estatus: {
          Recibido: 0
        , Disponible: 1
        , Cuarentena: 2
        , Daniado: 3
        , Descompuesto: 4
        , Vendido: 5
        , Devuelto_a_proveedor: 10
        , Robado: 11
        , Asignados: 12
        , En_tienda: 13
        , Transfiriendose: 14
        , Siniestro_en_tienda: 15
        , Baja_de_Inventario: 16
        , Siniestro: 17
        , Pendiente_NE: 19
        , En_Devolucion: 20
    }
}
/* HA ID: 2 INI Variables de condicion */
/* HA ID: 3 Agregado de Estatus */
var Transferencia = {
		Estatus: {
			  SiniestroTotal: 18
			, SiniestroParcial: 24
            , EntregaParcial: 20
		}
	}

var arrEsSin = [
		Transferencia.Estatus.SiniestroTotal
		, Transferencia.Estatus.SiniestroParcial
	];

/* HA ID: 3 Agregado de Estatus */
var arrEsEPa = [
        Transferencia.Estatus.EntregaParcial
    ];

/*  HA ID: 2 FIN */

var sqlTASer = "EXEC SPR_Entrega_Evento "
      + "@Opcion = 1100 "
    + ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) 
    + ", @TAA_ID = " + ( (rqIntTAA_ID > -1) ? rqIntTAA_ID : "NULL" ) 
 
var rsTASer = AbreTabla(sqlTASer, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-content"  style="border-top-style: hidden">
            <table class="table table-hover">
                <tbody id="tbTASerLis" style="border-top-style: hidden">
<%
var strlabel = "";
var bolTAEsSiniestro = false;

/* HA ID: 3 Agregado varoable de Registro EntregaParcial */
var bolTAEsEntregaParcial = false;

while( !(rsTASer.EOF) ){
   
    var intInv_ID = rsTASer("Inv_ID").Value
   
    /* HA ID: 2 Agregado de condicion de cierre de sinestro */
    bolTAEsSiniestro = ( arrEsSin.indexOf( parseInt(rsTASer("TA_Est_ID").Value) ) > -1 && parseInt(rsTASer("TA_SiniestroSeleccionCerrado").Value) == 0 )
    
    /* HA ID: 3 Agregado varoable de Registro devuelto */
    bolTAEsEntregaParcial = ( arrEsEPa.indexOf( parseInt(rsTASer("TA_Est_ID").Value) ) > -1 && parseInt(rsTASer("TA_EntregaParcialSeleccionCerrado").Value) == 0 )

    switch( parseInt(rsTASer("Ser_Est_ID").Value) ){
        case Series.Estatus.Recibido: 
        case Series.Estatus.Devuelto_a_proveedor:
        case Series.Estatus.Transfiriendose: 
        case Series.Estatus.Pendiente_NE: {
            strlabel = "warning"
        } break;

        case Series.Estatus.Disponible: {
            strlabel = "primary"
        } break;

        case Series.Estatus.Cuarentena: 
        case Series.Estatus.Daniado:
        case Series.Estatus.Descompuesto:
        case Series.Estatus.Robado: 
        case Series.Estatus.Siniestro_en_tienda:
        case Series.Estatus.Baja_de_Inventario:
        case Series.Estatus.Siniestro: 
        case Series.Estatus.En_Devolucion:{
            strlabel = "danger"
        } break;
        
        case Series.Estatus.Vendido:
        case Series.Estatus.Asignados:
        case Series.Estatus.En_tienda: {
            strlabel = "success"
        } break;
    }
%>
                    <tr class="cssTASerLisReg"
                     data-ta_id='<%= rsTASer("TA_ID").Value %>'
                     data-taa_id='<%= rsTASer("TAA_ID").Value %>'
                     data-tas_id='<%= rsTASer("TAS_ID").Value %>'>

                        <td>
                            <%= rsTASer("TAS_ID").Value %>
                        </td>
                        <td class="project-title" style="width: 190px;">
                            <a>
                                <i class="fa fa-barcode" title="IMEI"></i>  
                                <span class="textCopy copyID" title="<%= intInv_ID %>"><%= rsTASer("TAS_Serie").Value %></span>
                            </a>
                            <br>
                            <a>
                                <i class="fa fa-rss" title="EPC"></i> 
                                <span class="textCopy"><%= rsTASer("Inv_EPC").Value %></span>
                            </a>
                            <br>
                            <small>
                                <i class="fa fa-clock-o" title="Fecha de registro del art&iacute;culo"></i> <%= rsTASer("TAS_FechaRegistro").Value %>
                            </small>   
<%  if( rsTASer("TAS_HayNotaEntrada").Value == 1) {  
%>
                            <br>
                            <small>
                                <i class="fa fa-sign-in" title="Tiene nota de entrada"></i> <span class="label label-info">Nota de entrada</span>
                            </small>   
<%  }  
%>
                        </td>
                        <td class="project-title">
                                <i class="fa fa-home" title="Tienda"></i> <%= rsTASer("Alm_Nombre").Value %>
                            <br>
                            <small>
                                No: <%= rsTASer("Alm_Numero").Value %>
                            </small>
                            <br>
                            <label class="label label-<%= strlabel %>" title="Estatus del art&iacute;culo">
                                <%= rsTASer("Ser_Est_Nombre").Value %>
                            </label>                               
                                
                        </td>
                        <td class="project-title">
<%  

    var sqlTASerInv = "EXEC SPR_Entrega_Evento "
            + "@Opcion = 1110 "
        + ", @Inv_ID = " + ( (intInv_ID > -1) ? intInv_ID : "NULL" ) 

    var rsTASerInv = AbreTabla(sqlTASerInv, 1, cxnTipo)
%>
                            <ul class="agile-list" style="padding-left: 0px;">
<%
    while( !(rsTASerInv.EOF) ){
%>
                                <li class="info-element">
                                    <i class="fa fa-file-text-o" title="Folio de la Transferencia"></i> <%= rsTASerInv("TA_Folio").Value %>
                                    <br>
                                    <i class="fa fa-clock-o" title="Fecha de Registro de la Transferencia"></i> <%= rsTASerInv("TA_FechaRegistro").Value %>
                                    <div class="agile-detail" >
                                        <label class="label label-success" title="Estatus de la Transferencia">
                                            <%= rsTASerInv("TA_Est_Nombre").Value %>
                                        </label>
<%      if( rsTASerInv("TAS_HayNotaEntrada").Value == 1) {  
%>
                               &nbsp;<span class="label label-info">NE</span>
<%      }  
%>        
                                    </div>
                                </li>
<%
        Response.Flush()
        rsTASerInv.MoveNext()
    }

        rsTASerInv.Close()
%>
                            </ul>           
                        </td>
                        <td class="project-status" align="center">

                            <a id="btnSinSi" title="Es Siniestro"
                                <% if( bolTAEsSiniestro ){ %> onclick="Serie.Siniestro.Guardar({Valor: 0, Objeto: this})" <% } %> 
                                <% if( rsTASer("TAS_EsSiniestro").Value == 0 ){ %> style="display: none;" <% } %>
                            >
                                <i class="fa fa-check-circle-o fa-2x text-danger"></i>
                            </a>
<%  if( bolTAEsSiniestro ){
%>
                            <a id="btnSinNo" title="NO es Siniestro"
                                onclick="Serie.Siniestro.Guardar({Valor: 1, Objeto: this})"
                                <% if( rsTASer("TAS_EsSiniestro").Value == 1 ){ %> style="display: none;" <% } %>
                            >
                                <i class="fa fa-circle-o fa-2x text-primary"></i>
                            </a>
<%  }
%>   
<%  if( bolTAEsSiniestro || rsTASer("TAS_EsSiniestro").Value == 1 ){
%>                         
                            <br>
                            <small>
                                Siniestro
                            </small>
<%  }
%>                      
                        </td>
<%  /* HA ID: 3 INI Se agrega columna de Entrega Parcial */ %>
                        
                        <td class="project-status" align="center">

                            <a id="btnEPaSi" title="No Entregado"
                                <% if( bolTAEsEntregaParcial ){ %> onclick="Serie.EntregaParcial.Guardar({Valor: 0, Objeto: this})" <% } %> 
                                <% if( rsTASer("TAS_EsEntregaParcial").Value == 0 ){ %> style="display: none;" <% } %>
                            >
                                <i class="fa fa-check-circle-o fa-2x text-warning"></i>
                            </a>
<%  if( bolTAEsEntregaParcial ){
%>
                            <a id="btnEPaNo" title="Entregado"
                                onclick="Serie.EntregaParcial.Guardar({Valor: 1, Objeto: this})"
                                <% if( rsTASer("TAS_EsEntregaParcial").Value == 1 ){ %> style="display: none;" <% } %>
                            >
                                <i class="fa fa-circle-o fa-2x text-primary"></i>
                            </a>
<%  }
%>   
<%  if( bolTAEsEntregaParcial || rsTASer("TAS_EsEntregaParcial").Value == 1 ){
%>                         
                            <br>
                            <small>
                                No Entregado
                            </small>
<%  }
%>                      
                        </td>

<%  /* HA ID: 3 FIN */ %>
                    </tr>
<%
    Response.Flush()
    rsTASer.MoveNext()
}
%>
                </tbody>
            </table>
        </div>
    </div>   
<%
rsTASer.close()
%>