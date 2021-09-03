<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

    var bDebug = true
    var iRegistros = 0
   
	 var Are_ID = utf8_decode(Parametro("Are_ID",-1))   
	  var Are_Nombre = utf8_decode(Parametro("Are_Nombre",""))   
// var iAgt_ID = utf8_decode(Parametro("BusAgt_ID",-1))
//
//    var sCliNombre = utf8_decode(Parametro("BusCli_Nombre",""))
//    var sCliRFC = utf8_decode(Parametro("BusCli_RFC",""))   
//    var iBusCot_EstatusCG93 = utf8_decode(Parametro("BusCot_EstatusCG93",-1))   
//   
 
var sSQL  = " SELECT * FROM Ubicacion_Area a INNER JOIN Ubicacion_Inmueble i ON a.Inm_ID=i.Inm_ID INNER JOIN Cat_Catalogo c ON"
	sSQL += " c.Cat_ID=a.Are_TipoCG88 WHERE c.Sec_ID = 88 "
         if (Are_ID != -1) {
        sSQL += " AND Are_ID = "+ Are_ID
    }   
    
    if (Are_Nombre > "") {
        sSQL += "  AND Are_Nombre LIKE '%"+ Are_Nombre +"%'"
    }   
    
   
    
    //1	En proceso     | Warning
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
   
%>
<div class="ibox-title">
    <h5><i class="fa fa fa-black-tie"></i><!--Grupo:&nbsp;Asesor:--></h5>
    <div class="ibox-tools">
        <a href="" class="btn btn-primary btn-xs"><i class="fa fa-plus"> </i>Areas</a>
    </div>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <th>Inmueble</th>
  <th>Area</th>
    <th>Descripcion</th>
      <th>Tipo de posicion</th>
      <th>Prefijo</th>
        <th>Ancho</th>
          <th>Largo</th>
              <th>Habilitado</th>
             <tbody>
        <%
        
        var rsAreas = AbreTabla(sSQL,1,0)
        while (!rsAreas.EOF){
			var Inm_Nombre = rsAreas.Fields.Item("Inm_Nombre").Value             
			var Are_ID = rsAreas.Fields.Item("Are_ID").Value
			var Are_Nombre = rsAreas.Fields.Item("Are_Nombre").Value  
			var Are_Descripcion = rsAreas.Fields.Item("Are_Descripcion").Value             
			var Are_Prefijo = rsAreas.Fields.Item("Are_Prefijo").Value             
			var Are_Ancho = rsAreas.Fields.Item("Are_Ancho").Value        
			var Are_Largo = rsAreas.Fields.Item("Are_Largo").Value             
			var Are_Habilitado = rsAreas.Fields.Item("Are_Habilitado").Value             
			var Are_TPosicion = rsAreas.Fields.Item("Cat_Nombre").Value             
			
			  if(Are_Habilitado == 1){
					Are_Habilitado = "SI"		 
			 }else{
				   Are_Habilitado = "NO"
			 }
        %>    
      <tr>
       <td class="project-title">
           <%=Inm_Nombre%>
        </td>
        <td class="project-title">
           <%=Are_Nombre%>
        </td>
        <td class="project-title">
            <br/>
            <small> <%=Are_Descripcion%></small>
        </td>
        <td class="project-title">
     	<%=Are_TPosicion%>
        </td>
         <td class="project-title">
 		 <%=Are_Prefijo%>
        </td>
        <td class="project-title">
       <%=Are_Ancho%>
        </td>
            <td class="project-title">
          <%=Are_Largo%>
        </td>
            <td class="project-title">
          <%=Are_Habilitado%>
        </td>
      </tr>
        <%
            rsAreas.MoveNext() 
            }
        rsAreas.Close()   
        %>       
    </tbody>
  </table>
</div>
<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    
    
    
    
    
    
});
    
      
            
            
   
    
</script>    
    