<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../Includes/iqon.asp" -->
<%
	var bIQon4Web = false

	var iUsu_ID = Parametro("IDUsuario",-1)

	//if(bIQon4Web) { Response.Write("Usu_ID " + iUsu_ID + " IDUsuario " + Parametro("IDUsuario",-1)) }

	var sSQLUsu = ""
		sSQLUsu = " SELECT * FROM Usuario WHERE Usu_ID = ( "
		sSQLUsu += " SELECT Usu_ID FROM Seguridad_Indice WHERE IDUnica = " + iUsu_ID + " ) "

		//if(bIQon4Web) { Response.Write(sSQLUsu) }

		ParametroCargaDeSQL(sSQLUsu,0)

		var sExisteFoto = Parametro("Usu_NombreLogoArchivo","")
		
		if(bIQon4Web) { Response.Write(sExisteFoto + " Usu_RutaArchivo " + Parametro("Usu_RutaArchivo","") + " Usu_NombreLogoArchivo " + Parametro("Usu_NombreLogoArchivo","") ) }

%>


<!-- start: CSS REQUIRED FOR THIS PAGE ONLY -->
<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.css">
<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-social-buttons/social-buttons-3.css">
<!-- end: CSS REQUIRED FOR THIS PAGE ONLY -->
<!-- start: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
<script src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
<script src="/Template/ClipOne/admin/clip-one/assets/plugins/jquery.pulsate/jquery.pulsate.min.js"></script>

<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->

<!-- start: PAGE CONTENT ///*href=""*/-->
<div class="row">
    <div class="col-sm-12">
        <div class="tabbable">
            <ul class="nav nav-tabs tab-padding tab-space-3 tab-blue" id="myTab4">
                <li class="active">
                    <a data-toggle="tab" href="#panel_vista" class="btnVista">Vista Previa</a>
                </li>
                <li> 
                    <a data-toggle="tab" href="#panel_editcta" class="btnEdita">Editar Cuenta</a>
                </li>
                <li>
                    <a data-toggle="tab" href="#panel_proy" class="btnProy">Avisos / Alertas</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane in active" id="panel_vista">
                    <div class="row">
                        <div class="col-sm-5 col-md-4">
                            <div class="user-left">
                                <div class="center">
                                    <h4><%=Parametro("Usu_Usuario","")%></h4>
                                    <div class="fileupload fileupload-new" data-provides="fileupload">
                                        <div class="user-image">
                                            <div class="fileupload-new thumbnail"><img id="img150Perfil" src="/Template/ClipOne/admin/clip-one/assets/images/avatar-1-xl.jpg" alt=""> 
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                    <p>
										<a class="btn btn-skype" href="<%=Parametro("Usu_Skype")%>" target="_blank"><i class="fa fa-skype"></i></a>                                    
										<a class="btn btn-twitter" href="<%=Parametro("Usu_Twitter")%>" target="_blank"><i class="fa fa-twitter"></i></a>
										<a class="btn btn-facebook" href="<%=Parametro("Usu_FaceBook")%>" target="_blank"><i class="fa fa-facebook"></i></a>
										<a class="btn btn-google-plus" href="<%=Parametro("Usu_YouTube")%>" target="_blank"><i class="fa fa-google-plus"></i></a> 
										<a class="btn btn-linkedin" href="<%=Parametro("Usu_Linkedin")%>"  target="_blank"><i class="fa fa-linkedin-square"></i></a>
                                    </p>
                                    <hr>
                                </div>
                                <table class="table table-condensed table-hover">
                                    <thead>
                                        <tr>
                                            <th colspan="3">Informaci&oacute;n de contacto</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Correo electr&oacute;nico:</td>
                                            <td>
                                            <%=Parametro("Usu_Email","")%>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Tel&eacute;fono:</td>
                                            <td><%=Parametro("Usu_Telefono","")%></td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table class="table table-condensed table-hover">
                                    <thead>
                                        <tr>
                                            <th colspan="3">Informaci&oacute;n General</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Nombre</td>
                                            <td><%=Parametro("Usu_Nombre","")%></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Usuario</td>
                                            <td><%=Parametro("Usu_Usuario","")%></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>T&iacute;tulo</td>
                                            <td><%ComboSeccion("Usu_TituloCG8"," class='form-control'",8,Parametro("Usu_TituloCG8",-1),0,"","Cat_Nombre","Consulta")%></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Depende de</td>
                                            <td>
                                            <% 
                                            	var sCondDep = " Usu_ID = (SELECT Usu_Padre FROM Usuario WHERE "
                                            		sCondDep += " Usu_ID = ( SELECT Usu_ID FROM Seguridad_Indice WHERE "
                                            		sCondDep += " IDUnica = "+ iUsu_ID +" )) "

                                            	var sDepende = BuscaSoloUnDato("Usu_Nombre","Usuario",sCondDep,"",0)
                                            
                                                	Response.Write(sDepende)
                                            %>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Estatus</td>
                                            <td><% if (Parametro("Usu_Estatus",0) == 1) { %>
                                            	 <span class="label label-sm label-success">Activo</span>
                                                 <% } else { %>
                                                 <span class="label label-sm label-danger">Inactivo</span>
                                                 <% } %>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                                 <table class="table table-condensed table-hover">
                                    <thead>
                                        <tr>
                                            <th colspan="3">Informaci&oacute;n de control</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Grupo</td>
                                            <td><%CargaCombo("Usu_Grupo"," class='form-control'","Gru_ID","Gru_Nombre","SeguridadGrupo","","Gru_Nombre",Parametro("Usu_Grupo",-1),0,"Seleccione","Consulta")%></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Habilitado</td>
                                            <td><% if (Parametro("Usu_Habilitado",0) == 1) { %>
                                            	 <span class="label label-sm label-success">SI</span>
                                                 <% } else { %>
                                                 <span class="label label-sm label-danger">NO</span>
                                                 <% } %></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Tipo de usuario</td>
                                            <td><%ComboSeccion("Usu_TipoUsuarioCG61"," class='form-control'",61,Parametro("Usu_TipoUsuarioCG61",-1),0,"Seleccione","Cat_Nombre","Consulta")%></td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table class="table table-condensed table-hover">
                                    <thead>
                                        <tr>
                                            <th colspan="3">Informaci&oacute;n adicional</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Cumplea&ntilde;os</td>
                                            <td><%
											var sUsu_FechaNacimiento = ""
											if(!EsVacio(Parametro("Usu_FechaNacimiento",""))) { 
												sUsu_FechaNacimiento = CambiaFormatoFecha(Parametro("Usu_FechaNacimiento",""),"yyyy-mm-dd","dd/mm/yyyy")
											}
											Response.Write(sUsu_FechaNacimiento)
											%></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-sm-7 col-md-8">
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas convallis porta purus, pulvinar mattis nulla tempus ut. Curabitur quis dui orci. Ut nisi dolor, dignissim a aliquet quis, vulputate id dui. Proin ultrices ultrices ligula, dictum varius turpis faucibus non. Curabitur faucibus ultrices nunc, nec aliquet leo tempor cursus.
                            </p>
                            <div class="row">
                                <div class="col-sm-3">
                                    <button class="btn btn-icon btn-block">
                                        <i class="clip-clip"></i>
                                        Projects <span class="badge badge-info"> 4 </span>
                                    </button>
                                </div>
                                <div class="col-sm-3">
                                    <button class="btn btn-icon btn-block pulsate">
                                        <i class="clip-bubble-2"></i>
                                        Messages <span class="badge badge-info"> 23 </span>
                                    </button>
                                </div>
                                <div class="col-sm-3">
                                    <button class="btn btn-icon btn-block">
                                        <i class="clip-calendar"></i>
                                        Calendar <span class="badge badge-info"> 5 </span>
                                    </button>
                                </div>
                                <div class="col-sm-3">
                                    <button class="btn btn-icon btn-block">
                                        <i class="clip-list-3"></i>
                                        Notifications <span class="badge badge-info"> 9 </span>
                                    </button>
                                </div>
                            </div>
                            <div class="panel panel-white">
                                <div class="panel-heading">
                                    <i class="clip-menu"></i>
                                    Recent Activities
                                    <div class="panel-tools">
                                        <a class="btn btn-xs btn-link panel-collapse collapses" href="#">
                                        </a>
                                        <a class="btn btn-xs btn-link panel-config" href="#panel-config" data-toggle="modal">
                                            <i class="fa fa-wrench"></i>
                                        </a>
                                        <a class="btn btn-xs btn-link panel-refresh" href="#">
                                            <i class="fa fa-refresh"></i>
                                        </a>
                                        <a class="btn btn-xs btn-link panel-close" href="#">
                                            <i class="fa fa-times"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="panel-body panel-scroll" style="height:300px">
                                    <ul class="activities">
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <i class="clip-upload-2 circle-icon circle-green"></i>
                                                <span class="desc">You uploaded a new release.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    2 hours ago
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <img alt="image" src="/Template/ClipOne/admin/clip-one/assets/images/avatar-2.jpg">
                                                <span class="desc">Nicole Bell sent you a message.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    3 hours ago
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <i class="clip-data circle-icon circle-bricky"></i>
                                                <span class="desc">DataBase Migration.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    5 hours ago
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <i class="clip-clock circle-icon circle-teal"></i>
                                                <span class="desc">You added a new event to the calendar.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    8 hours ago
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <i class="clip-images-2 circle-icon circle-green"></i>
                                                <span class="desc">Kenneth Ross uploaded new images.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    9 hours ago
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="activity" href="javascript:void(0)">
                                                <i class="clip-image circle-icon circle-green"></i>
                                                <span class="desc">Peter Clark uploaded a new image.</span>
                                                <div class="time">
                                                    <i class="fa fa-time bigger-110"></i>
                                                    12 hours ago
                                                </div>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="panel panel-white">
                                <div class="panel-heading">
                                    <i class="clip-checkmark-2"></i>
                                    To Do
                                    <div class="panel-tools">
                                        <a class="btn btn-xs btn-link panel-collapse collapses" href="#">
                                        </a>
                                        <a class="btn btn-xs btn-link panel-config" href="#panel-config" data-toggle="modal">
                                            <i class="fa fa-wrench"></i>
                                        </a>
                                        <a class="btn btn-xs btn-link panel-refresh" href="#">
                                            <i class="fa fa-refresh"></i>
                                        </a>
                                        <a class="btn btn-xs btn-link panel-close" href="#">
                                            <i class="fa fa-times"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="panel-body panel-scroll" style="height:300px">
                                    <ul class="todo">
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc" style="opacity: 1; text-decoration: none;">Staff Meeting</span>
                                                <span class="label label-danger" style="opacity: 1;"> today</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc" style="opacity: 1; text-decoration: none;"> New frontend layout</span>
                                                <span class="label label-danger" style="opacity: 1;"> today</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> Hire developers</span>
                                                <span class="label label-warning"> tommorow</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc">Staff Meeting</span>
                                                <span class="label label-warning"> tommorow</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> New frontend layout</span>
                                                <span class="label label-success"> this week</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> Hire developers</span>
                                                <span class="label label-success"> this week</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> New frontend layout</span>
                                                <span class="label label-info"> this month</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> Hire developers</span>
                                                <span class="label label-info"> this month</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc" style="opacity: 1; text-decoration: none;">Staff Meeting</span>
                                                <span class="label label-danger" style="opacity: 1;"> today</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc" style="opacity: 1; text-decoration: none;"> New frontend layout</span>
                                                <span class="label label-danger" style="opacity: 1;"> today</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="todo-actions" href="javascript:void(0)">
                                                <i class="fa fa-square-o"></i>
                                                <span class="desc"> Hire developers</span>
                                                <span class="label label-warning"> tommorow</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="panel_editcta">
                	<div id="dvFormulario"></div>
                </div>
                <div class="tab-pane" id="panel_proy">
                    <table class="table table-striped table-bordered table-hover" id="projects">
                        <thead>
                            <tr>
                                <th class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></th>
                                <th>Project Name</th>
                                <th class="hidden-xs">Client</th>
                                <th>Proj Comp</th>
                                <th class="hidden-xs">%Comp</th>
                                <th class="hidden-xs center">Priority</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>IT Help Desk</td>
                                <td class="hidden-xs">Master Company</td>
                                <td>11 november 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 70%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="70" role="progressbar" class="progress-bar progress-bar-warning">
                                        <span class="sr-only"> 70% Complete (danger)</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-danger">Critical</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>PM New Product Dev</td>
                                <td class="hidden-xs">Brand Company</td>
                                <td>12 june 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 40%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="40" role="progressbar" class="progress-bar progress-bar-info">
                                        <span class="sr-only"> 40% Complete</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-warning">High</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>ClipTheme Web Site</td>
                                <td class="hidden-xs">Internal</td>
                                <td>11 november 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 90%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="90" role="progressbar" class="progress-bar progress-bar-success">
                                        <span class="sr-only"> 90% Complete</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-success">Normal</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>Local Ad</td>
                                <td class="hidden-xs">UI Fab</td>
                                <td>15 april 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 50%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="50" role="progressbar" class="progress-bar progress-bar-warning">
                                        <span class="sr-only"> 50% Complete</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-success">Normal</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>Design new theme</td>
                                <td class="hidden-xs">Internal</td>
                                <td>2 october 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 20%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="20" role="progressbar" class="progress-bar progress-bar-success">
                                        <span class="sr-only"> 20% Complete (warning)</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-danger">Critical</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                            <tr>
                                <td class="center">
                                <div class="checkbox-table">
                                    <label>
                                        <input type="checkbox" class="flat-grey">
                                    </label>
                                </div></td>
                                <td>IT Help Desk</td>
                                <td class="hidden-xs">Designer TM</td>
                                <td>6 december 2014</td>
                                <td class="hidden-xs">
                                <div class="progress progress-striped active progress-sm">
                                    <div style="width: 40%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="40" role="progressbar" class="progress-bar progress-bar-warning">
                                        <span class="sr-only"> 40% Complete (warning)</span>
                                    </div>
                                </div></td>
                                <td class="center hidden-xs"><span class="label label-warning">High</span></td>
                                <td class="center">
                                <div class="visible-md visible-lg hidden-sm hidden-xs">
                                    <a href="#" class="btn btn-teal tooltips" data-placement="top" data-original-title="Edit"><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-green tooltips" data-placement="top" data-original-title="Share"><i class="fa fa-share"></i></a>
                                    <a href="#" class="btn btn-bricky tooltips" data-placement="top" data-original-title="Remove"><i class="fa fa-times fa fa-white"></i></a>
                                </div>
                                <div class="visible-xs visible-sm hidden-md hidden-lg">
                                    <div class="btn-group">
                                        <a class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" href="#">
                                            <i class="fa fa-cog"></i> <span class="caret"></span>
                                        </a>
                                        <ul role="menu" class="dropdown-menu pull-right">
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-share"></i> Share
                                                </a>
                                            </li>
                                            <li role="presentation">
                                                <a role="menuitem" tabindex="-1" href="#">
                                                    <i class="fa fa-times"></i> Remove
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" name="Usu_ID" id="Usu_ID" value="<%=Parametro("Usu_ID",-1)%>">
<input type="hidden" name="Gru_ID" id="Gru_ID" value="<%=Parametro("Usu_Grupo",-1)%>">
<!-- end: PAGE CONTENT-->
<script language="javascript" type="text/javascript">

	$(".btnEdita").click(function(evento){
		//var sDatos  = "Usu_ID="+$("#IDUsuario").val();
			//alert("Usu_ID"+$("#Usu_ID").val());
			$("#dvFormulario").load("/Plugins/Permisos/UsuariosCODet.asp");	  
		
	});

	
	$( document ).ready(function() {
		
		
		$("#img150Perfil").attr("src","<%=Parametro('Usu_RutaArchivo','')%><%=Parametro('Usu_NombreLogoArchivo','')%>");
		console.log('<%=Parametro("Usu_RutaArchivo","")%><%=Parametro("Usu_NombreLogoArchivo","")%>');
	
		//CAMBIO DE TAMAÑO DE LA IMAGEN PARA QUE QUEDE DE iTamanoDeseado px DE ALTO, O QUEDE 9/10 DEL ANCHO DEL DIV
		function imageLoaded() {
		   var w = $(this).width();
		   var h = $(this).height();
		   var iFactor = 0
		   var parentW = $(this).parent().width();
		   var parentH = $(this).parent().height();
		   var iAnchoMaximo = (parentW / 9) * 10;
		   var iAnchoTmp = 0;
		   var iTamanoDeseado = 160;

		   iFactor = ((iTamanoDeseado * 100) / h);
		   iAnchoTmp = ((w * iFactor)/100)

		   //console.log(w + '-' + h + '-' + parentW + '-' + parentH + '-' + iAnchoMaximo + '-' + iAnchoTmp);

		   if(iAnchoTmp > iAnchoMaximo) {
			   //console.log("Por ancho");
			   iFactor = ((iAnchoMaximo * 100) / w);
			   $(this).css("height", ((h * iFactor)/100));
			   $(this).css("width", ((w * iFactor)/100));
		   } else if(h > iTamanoDeseado) {
			   //console.log("Por alto");
			   $(this).css("height", ((h * iFactor)/100));
			   $(this).css("width", ((w * iFactor)/100));
		   }

		}
		
		$("#img150Perfil").each(function() {
			if( this.complete ) {
				imageLoaded.call( this );
			} else {
				$(this).one("load", imageLoaded);
			}
		});
		
	});		


</script>
