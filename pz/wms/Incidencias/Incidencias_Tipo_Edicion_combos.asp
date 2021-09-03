<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
				var Tipo_Medida = Parametro("Tipo_Medida",-1)
				var Estrellas = Parametro("Estrellas",-1)
				var MoScoW = Parametro("MoScoW",-1)
				var PrioridadABC = Parametro("PrioridadABC",-1)
				var Orden = Parametro("Orden",-1)
				var Prioridad = Parametro("Prioridad",-1)
				var Severidad = Parametro("Severidad",-1)
				var Talla = Parametro("Talla",-1)

							if(Tipo_Medida ==4){
							%>
          				  	   <label class="control-label col-md-3"><strong>Estrellas</strong></label>
 				   		 <div class="col-md-3">
                            <%
                      		    var sEventos = "class='form-control combman'"
                                ComboSeccion("InsT_EstrellasCG33", sEventos, 33, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                 		 </div>
                             <%
								}
							if(Tipo_Medida == 3){
							%>
           					 <label  class="control-label col-md-3"><strong>MoScoW</strong></label>
	            		   	<div class="col-md-3">
                            <%
                     		    var sEventos = "class='form-control combman'"
                                ComboSeccion("InsT_MoScoWCG24", sEventos, 24, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                        	 </div>
                             <%
							}
						
								if(Tipo_Medida == 2){
								%>
        		   	    <label class="control-label col-md-3"><strong>Prioridad ABC</strong></label>
                        <div class="col-md-3">
                                <select id="InsT_PrioridadABC">
                                <option value="1">A</option>
                                <option value="2">B</option>
                                <option value="3">C</option>
                 		        </select>
                         </div>
                      </div>
                   	<div class="form-group">
                      	   <label class="control-label col-md-3"><strong>Orden</strong></label>
                		<div class="col-md-3">
                    		<input class="form-control agenda" id="InsT_Orden" placeholder="" type="number" min="1" autocomplete="off" value="1" /> <br/>
                		</div>
               
                      		<%
								}
									if(Tipo_Medida == 1){
							%> 
  							<div class="form-group">
								<label  class="control-label col-md-3"><strong>Prioridad</strong></label>
                				<div class="col-md-3">
                            <%
                         		var sEventos = "class='form-control combman'"
                                ComboSeccion("InsT_PrioridadCG33", sEventos, 33, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                         	</div>
                          </div>
						  <div class="form-group">
          					  <label class="control-label col-md-3"><strong>Severidad</strong></label>
         					<div class="col-md-3">
                            <%
                         		var sEventos = "class='form-control combman'"
                                ComboSeccion("InsT_SeveridadCG32", sEventos, 32, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                        	 </div>
                            </div>
                             <%
							}
							if(Tipo_Medida == 5){
						%>
           				  	<label class="control-label col-md-3"><strong>Talla</strong></label>
         					<div class="col-md-3">
                            <%
                        		 var sEventos = "class='form-control combman'"
                                ComboSeccion("InsT_TallaCG25", sEventos, 25, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                        	 </div>
						  <%
                            }
                            %>
							
            <input type="hidden" class="form-control col-md-3 Estrellas" value=""></input>
            <input type="hidden" class="form-control col-md-3 MoScoW" value=""></input>
            <input type="hidden" class="form-control col-md-3 Prioridad_Orden" value=""></input>
            <input type="hidden" class="form-control col-md-3 Prioridad" value=""></input>
            <input type="hidden" class="form-control col-md-3 Severidad" value=""></input>
            <input type="hidden" class="form-control col-md-3 Talla" value=""></input>
		  

			<script type="application/javascript">

   $(document).ready(function(){
		<%
		if(Tipo_Medida ==4){
		%>
		$('#InsT_EstrellasCG33').val('<%=Estrellas%>')
		$('.Estrellas').val('<%=Estrellas%>')
		<%
		}
		if(Tipo_Medida ==3){
		%>
		$('#InsT_MoScoWCG24').val('<%=MoScoW%>')
		$('.MoScoW').val('"<%=MoScoW%>')
		<%
		}
		if(Tipo_Medida ==2){
		%>
		$('#InsT_PrioridadABC').val('<%=PrioridadABC%>')
		$('#InsT_Orden').val('<%=Orden%>')
		<%
		}
		if(Tipo_Medida ==5){
		%>
		$('#InsT_TallaCG25').val('<%=Talla%>')
		$('.Talla').val('<%=Talla%>')
		<%
		}
		if(Tipo_Medida ==1){
		%>
		$('#InsT_PrioridadCG33').val('<%=Prioridad%>')
		$('#InsT_SeveridadCG32').val('<%=Severidad%>')
		$('.Prioridad').val('<%=Prioridad%>')
		$('.Severidad').val('<%=Severidad%>')
		<%
		}
		%>
		
		 $('#InsT_EstrellasCG33').change(function(e) {
             e.preventDefault()
			  $('.Estrellas').val($(this).val()) 
	  	});
		
			 $('#InsT_MoScoWCG24').change(function(e) {
             e.preventDefault()
			  $('.MoScoW').val($(this).val())
	  	});
		
			 $('#InsT_TipoCG28').change(function(e) {
             e.preventDefault()
			  $('.Prioridad_Orden').val($(this).val())
	  	});
		
			 $('#InsT_PrioridadCG33').change(function(e) {
             e.preventDefault()
			  $('.Prioridad').val($(this).val()) 
	  	});
		
			 $('#InsT_SeveridadCG32').change(function(e) {
             e.preventDefault()
			  $('.Severidad').val($(this).val())
			  
	  	});
			 $('#InsT_TallaCG25').change(function(e) {
             e.preventDefault()
			  $('.Talla').val($(this).val()) 
			  
	  	});
		
   });
   
</script>	