<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
  var bIQ4Web = true   
  /*if(bIQ4Web){
    Response.Write("QueryString:" + Request.QueryString())   
  }*/
   
  var iPtID = Parametro("Pt_ID",-1) 
  var iUbiID = Parametro("Ubi_ID",-1)
   
  var sSKU = BuscaSoloUnDato("Pt_SKU","Pallet","Pt_ID="+Parametro("Pt_ID",-1),"S/P",0)
  var iProID = BuscaSoloUnDato("Pro_ID","Pallet","Pt_ID="+Parametro("Pt_ID",-1),-1,0) 
   
%>  
<!--div class="modal-dialog modal-lg"-->
  
    <div class="modal-header">
      <button class="close" data-dismiss="modal" type="button"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
      <h2 class="modal-title text-info"><i class="fa fa-qrcode"></i> Escanear Series</h2><small><strong><i class="fa fa-codepen text-navy"></i> LPN:</strong> <%=Parametro("PT_LPN","")%>&nbsp;<strong><i class="fa fa-map-marker text-navy"></i>&nbsp;Ubicaci&oacute;n:&nbsp;</strong><%=Parametro("Ubi_Nombre","")%></small><strong>&nbsp;<i class="fa fa-dropbox text-navy"></i>&nbsp;SKU:&nbsp;</strong><abbr title="SKU"><%=sSKU%></abbr>
      <hr class="hr-line-dashed">
      <div class="form-horizontal"> 
        <div class="form-group">
          <div class="col-sm-12">
            <label class="checkbox-inline"> 
              <input type="radio" checked="" value="1" id="opt1" name="optTipoEscaneo"> Escanear por serie 
                <input type="hidden" id="PteUbi_ID" value="<%=iUbiID%>">
                <input type="hidden" id="PtePt_ID" value="<%=iPtID%>">
                <input type="hidden" id="PtePro_ID" value="<%=iProID%>">
            </label> 
            <label class="checkbox-inline">
              <input type="radio" value="2" id="opt2" name="optTipoEscaneo"> Escanear por EPC 
            </label> 
          </div>
        </div>
        <div class="form-group">
          <label class="col-sm-1 control-label">&nbsp;</label>
          <div class="col-sm-5">
            <input type="text" class="form-control input-sm" placeholder="serie &oacute; EPC" id="txtSerie"> 
            <span class="help-block m-b-none">Escaneo de serie &oacute; EPC</span>
            <button class="btn btn-sm btn-primary btn-xs pull-right m-t-n-xs btnEscaneo" type="button" id="btnEscaneo"><strong> Escaneo</strong></button>
          </div>
        </div>
    </div>  
    </div>
    <div class="modal-body">
    <div class="table-responsive">
   
      <table class="table table-condensed table-striped" id="TablaEscaneoSerie">
        <thead>
          <tr>
            <!--th class="text-center">#</th-->
            <th class="text-left">Serie</th>
            <th class="text-left">EPC&nbsp;<small>(RFID)</small></th>
            <th class="text-left">Estatus</th>
            <th class="text-left">Mensaje</th>
            <th class="text-center">Acciones</th>
          </tr>
        </thead>
        <tbody id="first">
          <%
            var iRegistros = 0
            var sSQL = "SELECT ICIS_ID, Ubi_ID, PT_ID, ISNULL(INV_ID,-1) AS INV_ID, INV_Serie "
                sSQL += ",ISNULL(Inv_RFID,'') AS Inv_RFID, ICIS_ErrorNumero,ICIS_ErrorDescripcion "
                sSQL += "FROM Inventario_CargaInicial_Series "
                sSQL += "WHERE Ubi_ID = "+iUbiID
                sSQL += " AND PT_ID = "+iPtID
                sSQL += "UNION "
                sSQL += "SELECT -1,Ubi_ID,Pt_ID,Inv_ID,Inv_Serie "
                sSQL += ",Inv_RFID,0,'En inventario' "
                sSQL += "FROM Inventario "
                sSQL += "WHERE Ubi_ID = "+iUbiID
                sSQL += " AND Pt_ID = "+iPtID
                sSQL += " ORDER BY ICIS_ID DESC"
                var sLabel = "text-info"
                var iICISID = -1
                var iInvID = -1

                if(bIQ4Web){ Response.Write("SQL:<br>" + sSQL) }
             
                var rsInvCarIni = AbreTabla(sSQL,1,0)
                if(!rsInvCarIni.EOF){    
                  while (!rsInvCarIni.EOF){
                    iRegistros++
                    iICISID = rsInvCarIni.Fields.Item("ICIS_ID").Value
                    iInvID = rsInvCarIni.Fields.Item("Inv_ID").Value
                    sLabel = "text-warning"
                    if(iICISID == -1){
                      sLabel = "text-info"  
                    }
                       
          %> 
          <tr id="row<%=iInvID%>"> 
            <!--td class="text-center"><strong><%//=iRegistros%></strong></td-->
            <td class="text-left <%=sLabel%>"><small><strong><%=rsInvCarIni.Fields.Item("INV_Serie").Value%></strong></small></td>
            <td class="text-left"><small><%=rsInvCarIni.Fields.Item("Inv_RFID").Value%></small></td>
            <td class="text-left"><small><%=rsInvCarIni.Fields.Item("ICIS_ErrorNumero").Value%></small></td>
            <td class="text-left"><small><%=rsInvCarIni.Fields.Item("ICIS_ErrorDescripcion").Value%></small></td>
            <td class="text-center">
              <% if(iICISID > -1){ %>
              <div class="btn-group">
                <button class="btn btn-white btn-xs btnQuitar" title="Remover del listado" type="button" data-icisid="<%=iICISID%>"><i class="fa fa-times"></i></button> 
                <!--button class="btn btn-white btn-xs" data-original-title="Mark as important" data-placement="top" data-toggle="tooltip" title=""><i class="fa fa-exclamation"></i></button> 
                <button class="btn btn-white btn-xs" data-original-title="Move to trash" data-placement="top" data-toggle="tooltip" title=""><i class="fa fa-trash-o"></i></button-->
              </div>
              <% } %>
            </td>  
          </tr> <!--small m-t-xs-->
          <%
              rsInvCarIni.MoveNext() 
              } 
          rsInvCarIni.Close() 
          } else {
          %> 
          <tr>
            <td class="text-center" colspan="4">
              <a class="faq-question" href="#">No hay series escaneadas.</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-success btn-xs" data-dismiss="modal" id="btnCerrar" type="button">
        <i class="fa fa-ban"></i> Cancelar
      </button>      
      <button class="btn btn-danger btn-xs" data-dismiss="modal" id="btnCerrar" type="button">
        <i class="fa fa-times"></i> Cerrar
      </button> 
      <button type="button" class="btn btn-primary btn-xs" id="btnIntegraPallet">
          <i class="fa fa-plus"></i> Integrar series a pallet
      </button>
    </div>
  
<!--/div-->
      
<script type="text/javascript" language="javascript">

var sMensaje = ""
  
$(document).ready(function() {      

  /*function VerificaSerie(e){
    
    var tecla = (document.all) ? e.keyCode : e.which;  
      //console.log("tecla: "+tecla);
      if(tecla == 13){
        $("#btnEscaneo").trigger("click");
      }    
    
  
  }*/
  
  $("#btnEscaneo").click(function(){
    
    //if(ValidaBusqueda()){
      var iTipoBusq = $('input:radio[name=optTipoEscaneo]:checked').val();
      var stxtSerie = $("#txtSerie").val();
      var iPtID = $("#PtePt_ID").val();
      var iUbiId = $("#PteUbi_ID").val();
      var iProID = $("#PtePro_ID").val();
      console.log("Tipo Busq: " + iTipoBusq + " | Serie: "+ stxtSerie);
      console.log("Tipo Busq: " + iTipoBusq + " | Pt_ID: "+ iPtID + " | Ubi_ID: "+ iUbiId + " | Pro_ID: "+ iProID + " | Serie: "+ stxtSerie);
      //EscaneaSerie(iTipoBusq,iUbiId,iPtID,iProID,stxtSerie);
      //InsertaObjetivo(iUsuID,iTipoBusqu);
      RowInsert();
    //}
  }); 

  function RowInsert(){
    
    $('#TablaEscaneoSerie > tbody').append('<tr id="444"><td>SERIETEST</td><td>RFIDTEST</td><td>&nbsp;</td><td>ADDTEST</td><td><button class="btn btn-white btn-xs btnQuitar" title="Remover del listado" type="button" data-icisid="444"><i class="fa fa-times"></i></button></td></tr>');
    
  }
  

  
  function EscaneaSerie(ijsTipoBusq,ijsUbiID,ijsPtID,ijsProID,sjsSerie){
    
    $.post("/pz/wms/Almacen/CargaSerieEscaneo_ajax.asp"
      ,{Tarea:1,TipoBusqueda:ijsTipoBusq,Ubi_ID:ijsUbiID,Pt_ID:ijsPtID,Pro_ID:ijsProID,Inv_Serie:sjsSerie }
      ,function(data) {
        //console.log(data);
        var JSONResul = JSON.parse(data);
        /*
        console.log("{Datos} - TTmp_Resultado: " + JSONResul.Datos[0].TTmp_Resultado + " | TTmp_ErrorNumero: " + JSONResul.Datos[0].TTmp_ErrorNumero + " | TTmp_ErrorDescripcion: " + JSONResul.Datos[0].TTmp_ErrorDescripcion);
        console.log("{Error}: " + JSONResul.Error);
        console.log("{Query}: " + JSONResul.Query);
        console.log("{Resultado}: " + JSONResul.Resultado);        
        console.log("{Tarea}: " + JSONResul.Tarea);
        */
        var iICIS_ID = -1;
        var iUbi_ID = -1;
        var iPT_ID = -1;
        var iINV_ID = -1;
        var sINV_Serie = "";
        var sInv_RFID = "";
        var sRowExtra = "";
      
        var iDatoNumError = JSONResul.Datos[0].TTmp_ErrorNumero;
        var sLeyenda = JSONResul.Datos[0].TTmp_ErrorDescripcion;
        //console.log();
        if(parseInt(JSONResul.Resultado) == 1){
          //Se registro la serie 
          //[{"Resultado":1,"ErrorNumero":1,"ErrorDescripcion":"Se registro la serie","ICIS_ID":51,"Ubi_ID":2707,"PT_ID":39664,"INV_ID":962038,"INV_Serie":"863352040736127","Inv_RFID":"9000000003079847"}]
          if(iDatoNumError == 1){
            
              sMensaje = sLeyenda;
              iICIS_ID = JSONResul.Datos[0].ICIS_ID;
              iUbi_ID = JSONResul.Datos[0].Ubi_ID;
              iPT_ID = JSONResul.Datos[0].PT_ID;
              iINV_ID = JSONResul.Datos[0].INV_ID;
              sINV_Serie = JSONResul.Datos[0].INV_Serie;
              sInv_RFID = JSONResul.Datos[0].Inv_RFID;
              
              sRowExtra = '<tr>'
                sRowExtra += '<td class="text-left text-warning"><small><strong>'+sINV_Serie+'</strong></small></td>'
                sRowExtra += '<td class="text-left"><small>'+sInv_RFID+'</small></td>'
                sRowExtra += '<td class="text-left"><small>'+iDatoNumError+'</small></td>'
                sRowExtra += '<td class="text-left"><small>'+sLeyenda+'</small></td>'
                sRowExtra += '<td class="text-center">'
                  sRowExtra += '<div class="btn-group">'
                    sRowExtra += '<button class="btn btn-white btn-xs btnQuitar" title="Remover del listado" type="button">'
                      sRowExtra += '<i class="fa fa-times"></i></button>'
                  sRowExtra += '</div>'
                sRowExtra += '</td>'
              sRowExtra += '</tr>'
            
             $('#TablaEscaneoSerie > tbody:first').append(sRowExtra);
            
              /*
              $('.modal-body .table-responsive').load('/pz/wms/Almacen/CargaSeriesEscaneo.asp?Pt_ID=<%=iPtID%>&Ubi_ID=<%=iUbiID%>',function(){
                $('#GridSerieEscaneo').modal({show:true});
              });
              */
              
          }
          
          //Ya existe en el listado
          if(iDatoNumError == 2){
             sMensaje = sLeyenda;
          }          

          //No existe
          if(iDatoNumError == 3){
             sMensaje = sLeyenda;
          }  
          
          Avisa("success","Aviso",sMensaje);  
          
        } else{
          
					Avisa("error","Error",response.Error.message+ " " + response.Error.name);
          
				}
      
      
      
        /*if(parseInt(JSONResul.Resultado) == 1){
          //RecargarGridModal
          sMensaje = "Se registro la serie"
          
        }
      
        Avisa("success","Aviso",sMensaje);
        */
        //console.log(response);
        /*
        if(parseInt(response.Resultado) == 1){
					//Avisa("success","Aviso",response.Datos.message); 
					$('#OpInvMov_ID').val(response.Datos.ID);
          EnvioDatosObjetivoBusqueda(response.Datos.ID);
          CargarGridInven(response.Datos.ID);
          sMensaje = "La carga de la b&uacute;squeda se realizo correctamente"

				} else{
					Avisa("error","Error",response.Error.message+ " " + response.Error.name);
          $('#OpInvMov_ID').val(-1);
				}    
        
        Avisa("success","Aviso",sMensaje); 
      
        */
      
      }); 
         
  }  
  
  
  
  //$("#txtSerie").focus();
  document.getElementById("txtSerie").focus();
  
});
  
</script>  