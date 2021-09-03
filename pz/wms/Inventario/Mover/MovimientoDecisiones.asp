<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var bIQ4Web = false   
  
  var Pt_ID = Parametro("Pt_ID",-1) 
  var OpInvMov_ID = Parametro("OpInvMov_ID",-1) 
  var Ubi_ID = Parametro("Ubi_ID",-1) 

  var EsTotal = 0	
  var CantidadPallets = 0 

  var cbPt_ID = 0
  var cbPt_LPN = ""
  var cbPt_Cantidad_Actual = 0
   

  var sSQL = ""   
   
	  sSQL = "exec SPR_Inventario_Movimiento "
           + "  @Opcion = 4 "
           + ", @OpInvMovID = " + OpInvMov_ID
           + ", @PtID = " + Pt_ID                //pallet origen  5191
           + ", @UbiID = " + Ubi_ID                //donde lo quiero mandar


  if(Ubi_ID > -1){

 var rsOpciones = AbreTabla(sSQL,1,0)
   
    if(!rsOpciones.EOF){
        EsTotal = rsOpciones.Fields.Item("EsTotal").Value
        CantidadPallets = rsOpciones.Fields.Item("CantidadPallets").Value
    }
    rsOpciones.Close()
   

%>
<div class="form-group">
  <button class="btn btn-sm btn-primary pull-right m-t-n-xs btnMover" type="button" style="margin-top: -25px;"
          data-cantpall="<%=CantidadPallets%>" data-estotal="<%=EsTotal%>" data-ptid="<%=Pt_ID%>" 
          data-opinvmov="<%=OpInvMov_ID%>"  data-ubiid="<%=Ubi_ID%>" ><strong>
      <i class="fa fa-search"></i> Mover</strong>
  </button>
</div>   
<div class="form-group">
  <label class="col-sm-12 control-label text-navy">Toma de decisiones</label>
  <div class="col-sm-11 col-sm-offset-1">
<%
   if(EsTotal == 1){
%>      
    <div class="i-checks">
        <label> 
          <input type="radio" checked="" value="1" name="optDec<%=Pt_ID%>"> <i></i> Mover mismo LPN 
        </label>
      </div>
      
<% } else {  %>

    <div class="i-checks">
        <label> 
          <input type="radio" checked="" value="1" name="optDec<%=Pt_ID%>"> <i></i> Crear nuevo LPN 
        </label>
      </div>
<%
      if(CantidadPallets > 0){
%>   
    
    <div class="i-checks">
        <label> 
          <input type="radio" value="2" name="optDec<%=Pt_ID%>"> <i></i> Agregar en LPN Existente 
        </label>
      </div>
      <div class="i-checks">
        <label> 
          <div class="col-sm-12">
<%

          if(CantidadPallets == 1){   
             sSQL = "exec SPR_Inventario_Movimiento "
                  + "  @Opcion = 5 "
                  + ", @OpInvMovID = " + OpInvMov_ID
                  + ", @PtID = " + Pt_ID
                  + ", @UbiID = " + Ubi_ID

             var rsPallets = AbreTabla(sSQL,1,0) 

            if(!rsPallets.EOF){
                cbPt_ID = rsPallets.Fields.Item("Pt_ID").Value
                cbPt_LPN = rsPallets.Fields.Item("Pt_LPN").Value
                cbPt_Cantidad_Actual = rsPallets.Fields.Item("Pt_Cantidad_Actual").Value
            }
            rsPallets.Close()
              
              %> 
              <input type="hidden" id="cboLPN<%=Pt_ID%>" value="<%=cbPt_ID%>"><%=cbPt_LPN%> (<%=cbPt_Cantidad_Actual%>)
<%        } else { 
    
             sSQL = "exec SPR_Inventario_Movimiento "
                  + "  @Opcion = 5 "
                  + ", @OpInvMovID = " + OpInvMov_ID
                  + ", @PtID = " + Pt_ID
                  + ", @UbiID = " + Ubi_ID

%> 
    
            <select id="cboLPN<%=Pt_ID%>" name="cboLPN<%=Pt_ID%>" class="form-control input-sm cboSelect"> 
              <option value="-1" selected="selected">Seleccione</option>
<%          rsLPNs = AbreTabla(sSQL,1,0)
		    while(!rsLPNs.EOF){  
                cbPt_ID = rsLPNs.Fields.Item("Pt_ID").Value
                cbPt_LPN = rsLPNs.Fields.Item("Pt_LPN").Value
                cbPt_Cantidad_Actual = rsLPNs.Fields.Item("Pt_Cantidad_Actual").Value
%> 
              <option value="<%=cbPt_ID%>"><%=cbPt_LPN%> (<%=cbPt_Cantidad_Actual%>)</option>

<%           rsLPNs.MoveNext()
           }  
           rsLPNs.Close() 
%>
            </select>
<%      }      %>
              
          </div> 
        </label>
      </div>   
<%    }
    }     %>
  </div>
</div>
<br>

<%   }    %>
  
<script type="text/javascript">
 
  
    $(document).ready(function() {  
            
    
        $(".btnMover").click(function(e){
            e.preventDefault()
            var o = $(this)
            var EsTotal = o.data("estotal")
            var PtID = o.data("ptid")
            var OpInvMov_ID = o.data("opinvmov")
            var CPallts =  o.data("cantpall")
            var ubiid =   o.data("ubiid")
            var Opcion = 0
            var Pt_Seleccionado = -1
            var bPuedeMover = true
 
            if(EsTotal == 0){
                if(CPallts == 0){           //nuevo pallet
                    Pt_Seleccionado = -1
                    Opcion = 1
                } else if(CPallts == 1){    //pallet existente
                    Opcion =$("input[name='optDec" + PtID + "']:checked").val();
                    if (Opcion == 2 ){
                        Pt_Seleccionado = $("#cboLPN" + PtID).val()
                    }  
                } else if(CPallts > 1){    //palet seleccionado entre muchos
                    Opcion =$("input[name='optDec" + PtID + "']:checked").val();
                    if (Opcion == 2 ){
                        Pt_Seleccionado = $("#cboLPN" + PtID).children("option:selected").val();
                        if (Pt_Seleccionado == -1){
                             var sMensaje = "Seleccione un pallet destino"
                             Avisa("error","Error", sMensaje);
                             bPuedeMover = false
                        }
                    }
                }
            } else {
                 Pt_Seleccionado = -1
                 Opcion = 1
            }
            
            
            console.log(" OpInvMov_ID = " + OpInvMov_ID + " ,estotal = " + EsTotal + 
                        " ,Pt_ID = " + PtID + " ,Opcion selecc = " + Opcion + " ,CPallts = " + CPallts
                        + " ,pt selec = " + Pt_Seleccionado + " ,bPuedeMover = " + bPuedeMover)
            

            //bPuedeMover = false
            if(bPuedeMover){
      
                $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp"
                      ,{ Tarea:9
                        ,Movimiento:OpInvMov_ID
                        ,Usu_ID:$("#IDUsuario").val()
                        ,Es_Total:EsTotal 
                        ,PalletOrigen:PtID
                        ,CantPallets:CPallts
                        ,Dcsn:Opcion
                        ,PlltSel:Pt_Seleccionado
                        ,Ubi_ID:ubiid
                       }
                      ,function(data) {
                            var response = JSON.parse(data);

                        if(parseInt(response.Resultado) == 1){
                           sMensaje = response.Datos.message 
                            
                           var HtmlResp = '<div class="form-group">'
                                        + '<div class="col-sm-10">'
                                        + '<label class="control-label text-navy">Resultado</label>'
                                        + '<br>Se movieron ' + response.Datos.Pt_Cantidad_Actual 
                                        + ' articulos <br>Al pallet ' + response.Datos.Pt_LPN 
                                        + '<br><br><br></div><div class="col-sm-2">'
                                        + '<a class="btn btn-white btn-xs" title="LPN" '
                                        + ' onclick=\'ImprimirPapeleta(' + response.Datos.Pt_ID + ');\'> '
                                        + ' <i class="fa fa-print"></i> LPN '
                                        + ' </a>'
                                        + '</div><div class="col-sm-12">&nbsp;</div></div>'  
                            
                           $("#btnRegresar"+PtID).hide();
                           $("#btnLimpiar"+PtID).show();
                           $("#divDecisiones" + PtID).html(HtmlResp);
                         }    

                        Avisa("success","Aviso",sMensaje); 

                      }); 
            }

        });
    
    });
    
    
    
    function ImprimirPapeleta(id){
        
          var url = "/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+id;
        
          window.open(url, "Impresion Papeleta" );  
        
    }
    
  
</script>  
  
  