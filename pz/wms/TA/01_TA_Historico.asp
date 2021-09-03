<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
   var TA_ID = Parametro("TA_ID",-1)
   var Usu_ID = Parametro("Usu_ID",-1)
   var Gru_ID = Parametro("SegGrupo",1)
   
   var Cajas =  BuscaSoloUnDato("TA_CantidadCaja","TransferenciaAlmacen","TA_ID = " + TA_ID,1,0)
   var sCajas = "1 caja"
   if(Cajas<1){
       Cajas = 1 
   }
   if(Cajas>1){
       sCajas =  Cajas +" cajas"
   }
   
%>
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
          <h5><i class="fa fa-cube"></i> <%=sCajas%></h5>
        </div>
    </div>
        
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-clock-o"></i> Hist&oacute;rico</h5>
   </div>
   <div class="ibox-content">
      <table class="table table-hover no-margins">
         <thead>
            <tr>
               <th width="20%">Estatus</th>
               <th>Fecha</th>
            </tr>
         </thead>
         <tbody>
            <%
               var iRenglon = 0
               var stts = 0
               var sFecha = ""
               var sHora = ""
			   
               var sSQLHist = "SELECT TAH_ID,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) AS ESTATUS, TA_EstatusCG51 "
                            + ", CONVERT(NVARCHAR, TA_FechaRegistro,103) AS FECHA "
                            + ", CONVERT(NVARCHAR, TA_FechaRegistro,108) AS HORA "
                            + " FROM TransferenciaAlmacen_Historico "
                            + " WHERE TA_ID = " + TA_ID
                            + " ORDER BY TA_FechaRegistro ASC " 
              
                 var rsHist = AbreTabla(sSQLHist,1,0)

                 while (!rsHist.EOF){
                     iRenglon++  
                     stts = rsHist.Fields.Item("TAH_ID").Value
                     sFecha = rsHist.Fields.Item("FECHA").Value
                     sHora = rsHist.Fields.Item("HORA").Value
            %>                
            <tr>
               <td><small><strong><%Response.Write(rsHist.Fields.Item("ESTATUS").Value)%></strong></small></td>
               <td><i class="fa fa-clock-o" data-stts="<%=stts%>"  data-fecha="<%=sFecha%>"></i>&nbsp;
                   <span id="hora<%=stts%>">
                       <%= sFecha %>&nbsp;
                       <%= sHora %>
                   </span>
               </td>
             </tr>      
            <tr id="tr_fch<%=stts%>" class="tr_fechas" style="display: none">
               <td colspan="2"  id="fch<%=stts%>">
                
                
                 <div class='input-group date' style='width: 52%; float:left'> 
                     <span class='input-group-addon'><i class='fa fa-calendar'></i></span>
                    <input type='text' id="cbFch<%=stts%>" class='form-control' value='<%= sFecha %>'>
                </div>
                <div class='input-group clockpicker' data-autoclose='true' style='width: 25%; float:left'>
                    <input type='text' id="cbHra<%=stts%>" class='form-control' value='<%= sHora %>' >
                </div>
                <div class='input-group' style='float:left;padding-top: 5px;padding-left: 6px;'>
                     <button class='btn btn-primary btn-xs fchOk' type='button'
                             data-stts="<%=stts%>"><i class='fa fa-check'></i></button>
                     <button class='btn btn-danger btn-xs fchX' type='button'><i class='fa fa-times'></i></button>
                </div>
                </td>
             </tr>      
                 
            
            <%
                rsHist.MoveNext() 
                }
            rsHist.Close()   

            %>                 
         </tbody>
      </table>
             
   </div>
</div>

            <%
            var Vuelta = 0
               
            var DataU = " SELECT TAS_Usuario ID,COUNT(*) Articulos "
                DataU += " ,(SELECT Nombre FROM tuf_Usuario_Informacion(TAS_Usuario)) Usuario "
                DataU += " ,MAX(TAS_FechaRegistro) UltimoRegistro "
                DataU += " FROM TransferenciaAlmacen_Articulo_Picking "
                DataU += " WHERE TA_ID = " + TA_ID
                DataU += " GROUP BY TAS_Usuario "

            var rsUsua = AbreTabla(DataU,1,0)
                while(!rsUsua.EOF){
                    var ID = rsUsua.Fields.Item("ID").Value 
                    var Articulos = rsUsua.Fields.Item("Articulos").Value 
                    var Usuario = rsUsua.Fields.Item("Usuario").Value 
                    var UltimoRegistro = rsUsua.Fields.Item("UltimoRegistro").Value 
               
               if(Vuelta == 0) {
 %>		
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-barcode"></i> Picking</h5>
   </div>
   <div class="ibox-content">
      <table class="table table-striped table-hover">
        <thead>
            <tr>  
                <th width="10%">ID</th>
                <th width="20%">Articulos</th>
                <th width="30%">Picking by</th> 
                <th width="50%">&Uacute;ltimo picking</th>
            </tr>
        </thead>
        <tbody>
<%	
               }
%>		
                <tr>
                    <td style="text-align:left"><%=ID%></td>
                    <td style="text-align:left"><%=Articulos%></td>
                    <td style="text-align:left"><%=Usuario%></td>
                    <td style="text-align:left"><%=UltimoRegistro%></td>
                </tr>
<%	
					//Response.Flush()
					rsUsua.MoveNext() 
                    Vuelta++
				}
				rsUsua.Close()  
             if(Vuelta > 0) {  
%>             
        </tbody>
    </table>      
   </div>
</div>
    
   
<%              
    }       

    //ROG 18/03/2021  control de las incidencias
   //                 aparecen cajas de temas de incidencia, tantas como tema haya
  //                  cada caja levantara su incidencia y su contenido se manejara independiente de otros contenidos


    var Vuelta = 0
    var Llaves = ""

    var sSQLIncidencia  = "SELECT Ins_ID, Ins_Padre, Ins_Titulo, Ins_Asunto, Ins_Descripcion, InsT_Nombre,InsT_Problema_For_ID "
                        +      ", dbo.fn_CatGral_DameDato(27,i.Ins_EstatusCG27) As Estatus "
                        +      ", Convert(NVARCHAR(10),ISNULL(Ins_Tarea_FechaAtendida,Ins_FechaRegistro), 103) as FechaRegistro "
                        +  " FROM Incidencia i, Incidencia_Originacion o, Incidencia_Usuario u, Incidencia_Tipo t "
                        + " WHERE i.InsO_ID = o.InsO_ID AND o.InsO_ID = u.InsO_ID "
                        +   " AND i.InsT_ID = t.InsT_ID "
                        +   " AND i.TA_ID = " + TA_ID
                       // + " AND i.Ins_EstatusCG27 in (1,2,3) "
                        +   " AND u.InU_IDUnico = " + Usu_ID
                        +   " AND (i.Ins_Usu_Recibe = " + Usu_ID
                        +        " OR i.Ins_Usu_Reporta = " + Usu_ID 
                        +        " OR i.Ins_Usu_Escalado = " + Usu_ID 
                        +        " OR Ins_ID in (Select Ins_ID from Incidencia_Involucrados "
                                              + " where Ins_GrupoID = " + Gru_ID + ") "
                        +        " OR Ins_ID in (Select Ins_ID from Incidencia_Involucrados "
                                              + " where Ins_UsuarioID = " + Usu_ID +" ) "
                        + " ) "
                        + " ORDER BY Ins_FechaRegistro Desc "


    var rsIncidencia = AbreTabla(sSQLIncidencia,1,0)
    while(!rsIncidencia.EOF){    
       Llaves = rsIncidencia.Fields.Item("Ins_ID").Value
       Llaves += ", " + rsIncidencia.Fields.Item("InsT_Problema_For_ID").Value
        
       if(Vuelta == 0) {
 %>	
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-warning"></i> Incidencias</h5>
   </div>
   <div class="ibox-content">
      <table class="table table-striped table-hover">
        <tbody>
<%	    }    %>
                <tr data-insid="<%=rsIncidencia.Fields.Item("Ins_ID").Value %>"
                    data-forid="<%=rsIncidencia.Fields.Item("InsT_Problema_For_ID").Value %>" 
                    onclick="Tra_Incidencia.AbrirModal( <%=Llaves%> )">
                    <td style="text-align:left" title="<%=rsIncidencia.Fields.Item("Ins_Descripcion").Value %>">
                        <%=rsIncidencia.Fields.Item("Ins_Titulo").Value %>
                        <span class="pull-right" ><%=rsIncidencia.Fields.Item("FechaRegistro").Value %></span>
                        <br><strong>Tipo:</strong> <%=rsIncidencia.Fields.Item("InsT_Nombre").Value %> 
                        <br><strong>Asunto:</strong> <%=rsIncidencia.Fields.Item("Ins_Asunto").Value %> 
                        <br><strong>Estatus:</strong> <%=rsIncidencia.Fields.Item("Estatus").Value%>
                    </td>
                </tr>
<%	
					rsIncidencia.MoveNext() 
                    Vuelta++
     }
	 rsIncidencia.Close()  
       if(Vuelta > 0) {  
%>             
        </tbody>
    </table> 
   </div>
</div>    
 
<%              
    }

    var Vuelta = 0
               
    var sSQLMan  = "SELECT  CONVERT(NVARCHAR(12),Man_FechaRegistro, 103) as Fecha "
				 + ", CONVERT(NVARCHAR(12),Man_FechaRegistro, 108) as Hora "
                 + ",dbo.fn_CatGral_DameDato(48,Man_EstatusCG48) As Estatus "
				 + ", dbo.fn_Usuario_DameNombreUsuario( Man_Usuario ) as UsuarioRegistro  "
                 + ", dbo.fn_Usuario_DameNombreUsuario( Man_UsuarioValida ) as UsuarioValida  "
                 + ",  CONVERT(NVARCHAR(12),Man_FechaValidacion, 103) as FechaVal "
                 + ",  CONVERT(NVARCHAR(12),Man_FechaValidacion, 108) as HoraVal "
                 + ", dbo.fn_Usuario_DameNombreUsuario( Man_UsuarioQuita ) as UsuarioQuita, Man_UsuarioQuita  "
                 + ",  CONVERT(NVARCHAR(12),Man_UsuarioQuitaFecha, 103) as FechaQuita "
                 + ",  CONVERT(NVARCHAR(12),Man_UsuarioQuitaFecha, 108) as HoraQuita "
				 + ",CASE WHEN Man_ID  > 0 THEN (SELECT Man_Folio  FROM Manifiesto_Salida ms WHERE ms.Man_ID = mh.Man_ID) "
                      + " WHEN ManD_ID > 0 THEN (SELECT ManD_Folio FROM Manifiesto_Devolucion md "
                                              + " WHERE md.ManD_ID = mh.ManD_ID) "
	             + " END as Folio "
                 + ",CASE WHEN Man_ID  > 0 THEN 'Salida' "
                      + " WHEN ManD_ID > 0 THEN 'Devoluci&oacute;n' "
	             + " END as TipoManifiesto "
                 + " ,CASE WHEN Man_ID > 0 THEN (SELECT Prov_Siglas FROM Manifiesto_Salida ms, Proveedor p "
                                              + " WHERE ms.Man_ID = mh.Man_ID AND ms.Prov_ID = p.Prov_ID ) "
                       + " WHEN ManD_ID > 0 THEN (SELECT Prov_Siglas FROM Manifiesto_Devolucion md, Proveedor p "
		                                       + " WHERE md.ManD_ID = mh.ManD_ID AND md.Prov_ID = p.Prov_ID ) "
                 + " END as Transportista "
                 + " ,CASE WHEN Man_ID > 0 THEN (SELECT Edo_Nombre FROM Manifiesto_Salida ms, Cat_Estado e  "
                                              + " WHERE ms.Man_ID = mh.Man_ID and ms.Edo_ID = e.Edo_ID) "
                       + " WHEN ManD_ID > 0 THEN (SELECT Edo_Nombre FROM Manifiesto_Devolucion md, Cat_Estado e  "
                                              + "  WHERE md.ManD_ID = mh.ManD_ID and md.Edo_ID = e.Edo_ID) "
	             + " END as Estado "
                 + " FROM Manifiesto_Historico mh "
                 + " WHERE TA_ID = " + TA_ID

            var rsMan = AbreTabla(sSQLMan,1,0)
            while(!rsMan.EOF){           
               if(Vuelta == 0) {
 %>	
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-truck"></i> Hist&oacute;rico Manifiestos</h5>
   </div>
   <div class="ibox-content">
      <table class="table table-striped table-hover">
        <thead>
            <tr>  
            </tr>
        </thead>
        <tbody>
<%	  }    %>
                <tr>
                    <td nowrap="nowrap" style="text-align:left">
                       <h4><strong> <%=rsMan.Fields.Item("Folio").Value %> </strong></h4>
                            <br><strong>Tipo:</strong> <%=rsMan.Fields.Item("TipoManifiesto").Value %> 
                            <br><strong>Estatus:</strong> <%=rsMan.Fields.Item("Estatus").Value%>
                            <br />
							<br><strong>Transportista:</strong> <%=rsMan.Fields.Item("Transportista").Value%>
							<br><strong>Estado:</strong> <%=rsMan.Fields.Item("Estado").Value%>
                            <br />
                            <br><strong>Usuario registro:</strong><br /> <%=rsMan.Fields.Item("UsuarioRegistro").Value %> 
                           <br><strong>Fecha registro:</strong><br><%=rsMan.Fields.Item("Fecha").Value %>&nbsp;<%=rsMan.Fields.Item("Hora").Value %>
                            <%
							if(rsMan.Fields.Item("Folio").Value != "Sin Manifiesto"){
							%>
                            <br><strong>Usuario valid&oacute; salida:</strong><br /> <%=rsMan.Fields.Item("UsuarioValida").Value %> 
                            <br><strong>Fecha valid&oacute;:</strong> <br /><%=rsMan.Fields.Item("FechaVal").Value %>&nbsp;<%=rsMan.Fields.Item("HoraVal").Value %> 
                            <%
							
								if(rsMan.Fields.Item("Man_UsuarioQuita").Value>-1){
							%>
                            <br><strong>Usuario quit&oacute;:</strong> <BR /><%=rsMan.Fields.Item("UsuarioQuita").Value %> 
                            <br><strong>Fecha quit&oacute;:</strong> <BR /><%=rsMan.Fields.Item("FechaQuita").Value %>&nbsp;<%=rsMan.Fields.Item("HoraQuita").Value %>
         	
                            <%
								}
							}
							%>
                    </td>
                </tr>
<%	
					rsMan.MoveNext() 
                    Vuelta++
				}
				rsMan.Close()  
             if(Vuelta > 0) {  
%>             
        </tbody>
    </table> 
   </div>
</div>                
<%   }  
   
   var RayosX =  BuscaSoloUnDato("ISNULL((CONVERT(NVARCHAR, TA_FechaRayosX,103) + ' ' + CONVERT(NVARCHAR, TA_FechaRayosX,108)),'')","TransferenciaAlmacen","TA_ID = " + TA_ID,1,0)
   
   if(RayosX != "") {
%>
<div class="ibox float-e-margins">
    <div class="ibox-title">
      <h5><i class="fa fa-times-rectangle-o"></i> Rayos X: <%=RayosX%></h5>
    </div>
</div>
<% }  %>
    <!-- Data picker -->
   <script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
        <!-- Clock picker -->
    <script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
<script type="application/javascript">
    

            
    
    $(document).ready(function(){
        
        $('.fa-clock-o').dblclick (function(e) {
            e.preventDefault();
            var stts = $(this).data("stts")  
 
            $(".tr_fechas").hide("slow")

            //$("#cbFch" + stts).datepicker("option", "defaultDate", $(this).data("fecha"));
            $("#tr_fch" + stts).show("slow")
             
        });

        $('.fchX').click (function(e) {
            e.preventDefault();
            $(".tr_fechas").hide("slow")

        });
        
        
        $('.fchOk').click (function(e) {
            e.preventDefault();
            var stts = $(this).data("stts")
            var sFechaCambiar = $("#cbFch" + stts).val()
            var sHoraCambiar = $("#cbHra" + stts).val()
            
            $.ajax({
				  url: "/pz/wms/TA/TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType: "json"
				, data: {
					  Tarea: 18 
					, IDUsuario: $("#IDUsuario").val()
					, TA_ID: $("#TA_ID").val()
					, Hora: sHoraCambiar
					, Fecha: sFechaCambiar
                    , TAH_ID:stts
				}
				, success: function(res){
					if( parseInt(res.result) == 1 ){
                        $("#hora" + stts).html(" " + sFechaCambiar + "&nbsp;" + sHoraCambiar )
						Avisa("success", "Aviso", res.message);
					} else {
						Avisa("warning", "Aviso", res.message);
					}
                    $(".tr_fechas").hide("slow") 
				}
			})
            
            


        });
        

        $(".date").datepicker({
                todayBtn: "linked",
                format: 'dd/mm/yyyy',
                language: 'es',  
			    todayHighlight: true, 
                keyboardNavigation: false,
                forceParse: false,
                calendarWeeks: true,
                autoclose: true
            });
        
        $('.clockpicker').clockpicker();
        
    });

</script>
    
