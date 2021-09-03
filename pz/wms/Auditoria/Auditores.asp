<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Aud_ID = Parametro("Aud_ID",-1)
 
var Usu_Siglas = ""
var Usu_Nombre = ""
var Usu_Email = ""
var Usu_ID = 0

var chkHabHabilitado = 0	
var chkExHabilitado = 0

%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox-content">
		<div class="row">

        <table width="100%" class="table table-striped table-bordered table-hover dataTables-example" >
          <tr>
            <td width="7%" align="center" >Es externo</td>
            <td width="7%" align="center" >Habilitado</td>
            <td width="43%" >Nombre</td>
            <td width="29%" >e-mail</td>
            </tr>
<%
 
		var sSQL = " select u.Usu_ID, ISNULL(Usu_Siglas,'') as siglas, Usu_Nombre, Usu_Email "	
		         + " ,(ISNULL((select 'checked' from Auditorias_Auditores a "
			     +                    " where a.Usu_ID = u.Usu_ID "
			     +                    "   and a.Aud_ID = " + Aud_ID 							
			     +                   "   and a.Aud_Habilitado = 1),'')) as Habilitado "
		         + " ,(ISNULL((select 'checked' from Auditorias_Auditores a "
			     +                    " where a.Usu_ID = u.Usu_ID "
			     +                    "   and a.Aud_ID = " + Aud_ID 							
			     +                   "   and a.Aud_Externo = 1),'')) as ExHabilitado "
                 + " from Usuario u "
                 + " WHERE Usu_EsAuditor = 1 "
                 + " order by Usu_Nombre "
 
		var rsCTe = AbreTabla(sSQL,1,0)
        while (!rsCTe.EOF){
            Usu_Nombre = "" + rsCTe.Fields.Item("Usu_Nombre").Value
            Usu_Email = "" + rsCTe.Fields.Item("Usu_Email").Value					
            chkHabHabilitado = rsCTe.Fields.Item("Habilitado").Value	
            chkExHabilitado = rsCTe.Fields.Item("ExHabilitado").Value	
            chkInHabilitado = ""
            Usu_ID = rsCTe.Fields.Item("Usu_ID").Value

%>
          <tr>
            <td align="center">
                <input type="checkbox" id="chkExterno" class="chExt" data-usuid="<%=Usu_ID%>" <%=chkExHabilitado%> >  
            </td>
            <td align="center">
                <input type="checkbox" id="chkSelecc" class="chHab" data-usuid="<%=Usu_ID%>" <%=chkHabHabilitado%> >
            </td>
            <td>&nbsp;<%=Usu_Nombre%></td>
            <td>&nbsp;<%=Usu_Email%></td>            
            </tr>
<%
            rsCTe.MoveNext()
        }
        rsCTe.Close() 
%>
        </table>

        </div>
    </div>
</div>

<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".chExt").click(function(event) {
			var o = $(this)
			CambiaEstatus(0, o.is(':checked'), o.data("usuid"))
        });	
    
		$(".chHab").click(function(event) {
			var o = $(this)
			CambiaEstatus(1, o.is(':checked'), o.data("usuid"))
        });	
    

	});
		
		
function CambiaEstatus(EsHab,Checado,usuid) {
		
	var ckd = (Checado==true) ? 1 : 0;
    var sTipo = "error";
	
	$.post( "/pz/wms/Auditoria/Auditoria_Ajax.asp"
		  , { Tarea:1
              ,Usu_ID:usuid
		      ,Aud_ID:$("#Aud_ID").val()
			  ,Chkdo:ckd
              ,Hab:EsHab}
          ,function(data){
		      var response = JSON.parse(data)
              
			  if(response.result == 1){
			     sTipo = "success";   
			  } 
			  Avisa(sTipo,"Aviso",response.message);	
		  }
	);
				
}
 
//-->
</script>
