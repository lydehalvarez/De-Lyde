<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    //HA ID: 2  2021-JUN-04 Estatus de Tienda: Se agrega botón de acción de Redirección a Ventana de estatus de tienda.
    //HA ID: 3  2021-JUN-15 Paginación: Agregado de Indentificadores para Paginación

    var Alm_Nombre = Parametro("Alm_Nombre", "")
    var Usu_ID = Parametro("Usu_ID",-1) 
    var Cli_ID = Parametro("Cli_ID",-1) 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Ruta = Parametro("Ruta",-1) 
    var T_Ruta = Parametro("T_Ruta",-1)
    var T_Tienda = Parametro("T_Tienda",-1)
    var Tienda = Parametro("Tienda","")
    var Numero = Parametro("Numero","")
	var Tarea =  Parametro("Tarea",-1)	
    var bHayParams = false  

    //HA ID: 3 INI Variables de Paginación
    var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
    var rqIntRegistrosPagina = Parametro("RegistrosPagina", 50)
    //HA ID: 3 FIN 

    //HA ID: 3 Se agrega identificador de paginacion
    var sSQL  = "SELECT ROW_NUMBER() OVER( ORDER BY a.Alm_Nombre ASC ) AS ID "
              + ", a.*,  c.Cli_Nombre, ct.Cat_Nombre "
              + ", ISNULL((select Aer_NombreAG from Cat_Aeropuerto ap where ap.Aer_ID = a.Aer_ID ),'') as AEROPUERTO "
			  + " FROM Almacen a, Cliente c, Cat_Catalogo ct "
			  + " WHERE a.Cli_ID = c.Cli_ID "
			  + " AND ct.Sec_ID = 84 AND a.Alm_TipoCG84 = ct.Cat_ID "
                         
    if( Alm_Nombre != "" ){
        sSQL += " AND a.Alm_Nombre LIKE '%" + Alm_Nombre + "%' "
    }

    if (Aer_ID > -1) {  
        sSQL += " AND a.Aer_ID = "+ Aer_ID
//        bHayParams = true
    }   
	 if (Edo_ID > -1) {  
        sSQL += " AND a.Edo_ID = "+ Edo_ID
 //       bHayParams = true
    }   
    	 if (Cli_ID > -1) {  
        sSQL += " AND a.Cli_ID = "+ Cli_ID
        bHayParams = true
    }   
	 if (Tienda != "") {
//        bHayParams = true
        sSQL += "  AND Alm_Nombre LIKE '%"+ Tienda + "%'" 
    }   
	 if (Numero != "") {
//        bHayParams = true
        sSQL += "  AND Alm_Numero LIKE '%"+ Numero + "%'" 
    }   
    if (T_Tienda > -1) {
//        bHayParams = true
        sSQL += "  AND Alm_TipoCG84="+ T_Tienda 
    }   
 
    if (Ruta > -1) {
 //       bHayParams = true
        sSQL += " AND Alm_Ruta = "+ Ruta    
    }

  if (T_Ruta> -1) {
 //       bHayParams = true
        sSQL += " AND Alm_TipoDeRutaCG94 = "+ T_Ruta    
    }

//    if ((FechaInicio == "" && FechaFin == "")) {
//        if(!bHayParams){
//            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//            sSQL += " AND CAST(TA_FechaRegistro as date)  >= dateadd(day,-7,getdate()) "
//        }
//    } else {   
//        if(FechaInicio == "" ) {
//            if(FechaFin != "" ) {
//                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//                sSQL += " AND CAST(TA_FechaRegistro as date)  <= '" + FechaFin + "'"
//            }
//        } else {
//            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//            if(FechaFin == "" ) {
//                sSQL += " AND CAST(TA_FechaRegistro as date)  >= '" + FechaFin + "'"
//            } else {
//                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//                sSQL += " AND CAST(TA_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
//            }
//        }
//    }
      
	//sSQL += " ORDER BY Alm_Nombre"

    // HA ID: 3 Se agrega fragmento de consulta de paginado
    sSQL = "WITH TBL_Almacen "
        + "AS ( "
            + " " + sSQL + " "   
        + ") "
        + "SELECT TOP " + rqIntRegistrosPagina + " * "
        + "FROM TBL_Almacen Alm "
        + "WHERE Alm.ID > " + rqIntSiguienteRegistro + " "

    //Response.Write(sSQL)
    //Response.End()

    // HA ID: 3 INI Identificadores y label de registros
%>
<div class="ibox-title">
    <h5>Tiendas / CEDIS</h5> 
    <div class="ibox-tools">
        <label class="pull-right form-group">
            <span class="text-success" id="lblTotReg">

            </span> Registros
        </label>
    </div>       
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody id="tbReg">
        <%
        var Habilitado = "Habilitado"
        var HabilitadoCss = "label-primary"
        var rsAlmacen = AbreTabla(sSQL,1,0)
        while (!rsAlmacen.EOF){
            Habilitado = "Habilitado"
            HabilitadoCss = "label-primary"

            if(rsAlmacen.Fields.Item("Alm_Habilitado").Value == 0){
                Habilitado = "Deshabilitado"
                HabilitadoCss = "label-danger"
            }
        %>    
      <tr class="cssRegAlm">
        <td>
            <%=rsAlmacen.Fields.Item("ID").Value%>
        </td>
         <td class="project-title">
        <a><%=rsAlmacen.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Numero: <strong><%=rsAlmacen.Fields.Item("Alm_Numero").Value%></strong></small>
        </td>
        <td class="project-title">
            <a><%=rsAlmacen.Fields.Item("Alm_Nombre").Value%></a>
            <br/>
            <small>Aeropuerto: <%=rsAlmacen.Fields.Item("AEROPUERTO").Value%> </small>
        </td>
        <td class="project-title">
            <a> <%=rsAlmacen.Fields.Item("Alm_Calle").Value%></a>
            <br/><small>Responssable: <%=rsAlmacen.Fields.Item("Alm_Responsable").Value%> </small>
        </td>
        <td class="project-title">
            <a><%=rsAlmacen.Fields.Item("Alm_Ciudad").Value%></a>
            <br/> 
            <small>CP: <%=rsAlmacen.Fields.Item("Alm_CP").Value%> 
                <br/>Ruta: <%=rsAlmacen.Fields.Item("Alm_Ruta").Value%></small>
        </td>
            <td class="project-title">
                <span class="label <%=HabilitadoCss%>"><%=Habilitado%></span>
            <br/>
        </td>
        <td class="project-title">
            <a><%=rsAlmacen.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
        </td>
        <% // HA ID: 2 Se cabia texto de "Ver" por "Datos Generales"
        %>
        <td class="project-actions" width="31">
            <a class="btn btn-white btn-sm" onclick="javascript:AlmacenFunciones.CargaFicha(<%=rsAlmacen.Fields.Item("Alm_ID").Value%>);  return false">
                <i class="fa fa-folder"></i> Datos Generales
            </a>

            <% // HA ID: 2 INI Se agrega botón de acción de Estatus de tienda.
            %>
            <a class="btn btn-success btn-sm" onclick='Almacen.Estatus.Redireccionar({Alm_ID: <%= rsAlmacen("Alm_ID").Value %>});'>
                <i class="fa fa-share"></i> Ver Estatus
            </a>
            <% // HA ID: 2 FIN
            %>
        </td>
      </tr>
        <%
            Response.Flush();
            rsAlmacen.MoveNext() 
            }
        rsAlmacen.Close()   
        %>       
    </tbody>
    <tfoot>
        <tr>
            <td id="tfReg" colspan="8">

            </td>
        </tr>
    </tfoot>
  </table>