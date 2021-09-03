<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
  var bIQ4Web = false   

  var sSQL  = " SELECT Bod_ID, Bod_Nombre "
      sSQL += ",(SELECT A.Are_Nombre FROM Ubicacion_Area A WHERE A.Are_ID = Bodega.Are_ID) AREA "
      sSQL += ",(SELECT U.Ubi_Nombre FROM Ubicacion U WHERE U.Ubi_ID = Bodega.Ubi_ID) AS UBICACION "
      sSQL += ",Bod_Habilitada, CASE Bod_Habilitada WHEN 1 THEN 'SI' ELSE 'NO' END AS HABILITADO "
      sSQL += "FROM Bodega "
      //sSQL += "WHERE Bod_Habilitada = 1 " 
      sSQL += " ORDER BY Bod_Nombre, Bod_FechaRegistro DESC "    

      if(bIQ4Web){
         Response.Write("<br>"+sSQL)
      }     
  
   
%>
<div id="wrapper">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                <div class="ibox-title"> 
                    <h3 class="text-navy"> <i class="fa fa-list-alt"></i> Listado de bodegas</h3>
                    <div class="ibox-tools"></div>
                    <div class="ibox-content">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <div class="col-sm-6"></div>
                                    <div class="col-sm-2 m-b-xs">
                                    </div>
                                    <div class="col-sm-2 m-b-xs">
                                    </div>                                   
                                    <div class="col-sm-2 m-b-xs">
                                      <a class="btn pull-right btn-primary" href="javascript:NvoBodega(-1);"><i class="fa fa-plus"> </i>&nbsp;Nuevo&nbsp;</a>
                                    </div>        
                                </div>
                            </div>                                   
                        </div>    
                    </div>
                    <input type="hidden" name="Bod_ID" id="Bod_ID" value="-1">  
                    <div class="table-responsive" id="dvGridBodega">
                      <table class="table table-striped table-hover table-bordered" width="100%">
                        <thead>
                            <tr>
                              <th width="5%" class="text-center">Num.</th>
                              <th width="22%" class="text-left">Nombre</th>
                              <th width="19%" class="text-center">&Aacute;rea</th>
                              <th width="21%" class="text-center">Ubicaci&oacute;n</th>
                              <th width="13%" class="text-center">Habilitada</th>
                              <th width="20%" class="text-center">&nbsp;</th>
                            </tr>
                          </thead>
                          <tbody>
                          <%
                            //Response.Buffer = true
                            var Bod_ID = -1
                            var iRegistros = 0
                            var ivalHab = 1 
                            var sEtiqHab = ""
                            var rsBod = AbreTabla(sSQL,1,0)

                        if(!rsBod.EOF){
                          //Response.Flush()
                          while(!rsBod.EOF){

                              Bod_ID = rsBod.Fields.Item("Bod_ID").Value
                              ivalHab = rsBod.Fields.Item("Bod_Habilitada").Value
                              iRegistros++
                              sEtiqHab = "text-info"
                              if(ivalHab == 0){
                               sEtiqHab = "text-danger"
                              }

                        %>
                            <tr>
                              <td class="text-center"><%=iRegistros%></td>
                              <td class="text-left"><%=rsBod.Fields.Item("Bod_Nombre").Value%></td>
                              <td class="text-center"><%=rsBod.Fields.Item("AREA").Value%></td>
                              <td class="text-center"><%=rsBod.Fields.Item("UBICACION").Value%></td>
                              <td class="text-center <%=sEtiqHab%>"><small><%=rsBod.Fields.Item("HABILITADO").Value%></small></td>
                              <td class="text-right">
                                <button class="btn btn-white btn-xs btnEntrada" data-bodid='<%=Bod_ID%>'> Entrada <i class="fa fa-sign-in"></i></button>
                                <button class="btn btn-white btn-xs btnSalida" data-bodid='<%=Bod_ID%>'> Salida <i class="fa fa-sign-out"></i></button>
                                <button class="btn btn-white btn-xs" onClick="javascript:gridSelec(<%=Bod_ID%>)"> <i class="fa fa-share"></i></button>
                              </td>                                
                              <!--td valign="middle" class="text-center" nowrap>
                                
                              </td-->
                            </tr>
                        <%
                                  rsBod.MoveNext()
                              } 
                          rsBod.Close()
                        } else {
                        %>
                          <tr class="odd">
                              <td colspan="9" align="center" valign="top" class="dataTables_empty">No se encontraron bodegas.</td>
                          </tr>        
                        <%
                        }
                          %>
                          </tbody>
                      </table>                  
                    </div>
                </div>
            </div>    
        </div>
    </div> 
</div>   
<script language="javascript" type="text/javascript">

  $(document).ready(function() {


	$('.btnEntrada').click(function(e) {
     	e.preventDefault()
			var Params="?Bod_ID="+ $(this).data("bodid")
			$("#Contenido").load("/pz/wms/Bodega/Insumos_MovimientoEntrada.asp"+Params)
		 });
		$('.btnSalida').click(function(e) {
     	e.preventDefault()
			var Params="?Bod_ID="+ $(this).data("bodid")
			$("#Contenido").load("/pz/wms/Bodega/Insumos_MovimientoSalida.asp"+Params)
		 });
  });

  function gridSelec(jqiBodID) {
    $('#Bod_ID').val(jqiBodID);   
    CambiaSiguienteVentana();
  }  
  
   function NvoBodega(jqsBodID){
    $('#Bod_ID').val(jqsBodID);   
    CambiaSiguienteVentana();    
    
  } 
  
</script>   
   
