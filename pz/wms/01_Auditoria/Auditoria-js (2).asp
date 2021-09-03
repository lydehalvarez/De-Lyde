<!--#include file="./Grid.asp" -->
<!--#include file="./utils-js.asp" -->
<%


    function getAuditInformation()
    {
        var result = {};
        var sSQL = "SELECT";
        sSQL += " Cli_Nombre,";
        sSQL += " [dbo].[fn_CatGral_DameDato](141,Aud_EstatusCG141) AS estatus,";
        sSQL += " (SELECT Usu_Nombre FROM Usuario WHERE Usu_ID = [dbo].[fn_Usuario_DameIDUsuario](Aud_UsuarioResponsable_UID)) AS responsable,";
        sSQL += " [dbo].[fn_Usuario_DameIDUsuario](Aud_UsuarioResponsable_UID) AS responsableId,";
        sSQL += " (SELECT Usu_Nombre FROM Usuario WHERE Usu_ID = [dbo].[fn_Usuario_DameIDUsuario](Aud_AbiertaPor_UID)) AS creator,";
        sSQL += " ISNULL(CAST(ac.Aud_UltimaEntrada as NVARCHAR),'N/A') UltimaAct,";
        sSQL += " CONVERT(NVARCHAR(10),ac.Aud_FechaRegistro,103)+ ' - '+ CONVERT(NVARCHAR(10),ac.Aud_FechaRegistro,108) as FechaRegistro,";
        sSQL += " CONVERT(NVARCHAR(10),ac.Aud_FechaCongelacion,103) FechaCongelado,";
        sSQL += " [dbo].[fn_CatGral_DameDato](140,Aud_TipoCG140) AS type,";
        sSQL += " [dbo].[fn_CatGral_DameDato](143,ac.Aud_FormaConteoCG143) AS workType";
        sSQL += " FROM Auditorias_Ciclicas ac JOIN Cliente c ON ac.Cli_ID = c.Cli_ID";
        sSQL += " WHERE ac.Aud_ID =" + Aud_ID;

        var rs = AbreTabla(sSQL,1,0);
        if(!rs.EOF) {
            result.Client = rs.Fields.Item("Cli_Nombre").Value;
            result.Status = rs.Fields.Item("estatus").Value;
            result.Responsable = rs.Fields.Item("responsable").Value;
            result.ResponsableId = rs.Fields.Item("responsableId").Value;
            result.Creator = rs.Fields.Item("creator").Value;
            result.Messages = getMessagesCount();
            result.Type = rs.Fields.Item("type").Value;       
            result.WorkType = rs.Fields.Item("workType").Value; 
            result.RegisterLastUpdateDate = rs.Fields.Item("UltimaAct").Value;
            result.RegisterDate = rs.Fields.Item("FechaRegistro").Value;
            result.RegisterStartDate = rs.Fields.Item("FechaCongelado").Value;
        }

        rs.Close();
        result.Auditors = getAuditorsInfo(Aud_ID);
        result.CompletedUbicationsInfo = getCompleteUbicationsInfo();

        return result;
    }

    function getMessagesCount() {
        var result = 0;
        var sSQL = "SELECT COUNT(*) AS messagesCount FROM Auditorias_Ubicacion where Aud_ID =" + Aud_ID;
        var rs = AbreTabla(sSQL,1,0);
        if(!rs.EOF) {
            result = rs.Fields.Item("messagesCount").Value;
        }

        rs.Close();

        return result;
    }

    function getCompleteUbicationsInfo() {
        var result = {};
        var sSQL = "SELECT COUNT(*) AS Ubi_Totals, ({{ubiCompleted}}) AS Ubi_Completed  FROM Auditorias_Ubicacion au";
        sSQL += " WHERE au.Aud_ID = " + Aud_ID;
        var sqlCompletedUbications = "SELECT COUNT(*) FROM Auditorias_Ubicacion au WHERE au.Aud_ID = " + Aud_ID + " AND  au.AudU_Terminado = 1";
        sSQL = sSQL.replace("{{ubiCompleted}}", sqlCompletedUbications);
        var rs = AbreTabla(sSQL,1,0);
        if(!rs.EOF) {
            result.Totals = rs.Fields.Item("Ubi_Totals").Value;
            result.PorcentComplete = (rs.Fields.Item("Ubi_Completed").Value/(rs.Fields.Item("Ubi_Totals").Value)*100).toFixed(1);
            result.Visited = rs.Fields.Item("Ubi_Completed").Value;
        }

        rs.Close();
   
   
   //muy ingenioso tu query
   
   //para hacerlo sin sustituir texto podrias usar esto:
   
    var sSQL = "SELECT COUNT(*) AS Ubi_Totals "
             + ", (SELECT COUNT(*) FROM Auditorias_Ubicacion au WHERE au.Aud_ID = " + Aud_ID + " AND  au.AudU_Terminado = 1) AS Ubi_Completed "
             + " FROM Auditorias_Ubicacion au "
             + " WHERE au.Aud_ID = " + Aud_ID
   
   // de esta manera no tienes que jugar ocn los strings, pero siempre una subconsulta consume mucho de la base de datos ( es caro ) 
   
   
   //  la mejor forma de obtener resultados de diversos temas en un solo query es asi:
   
    //       select SUM( CASE WHEN AudU_EnProceso = 1 AND AudU_Terminado = 1 THEN 1 ELSE 0 END ) AS Terminadas
    //         , SUM( CASE WHEN AudU_EnProceso = 1 AND AudU_Terminado = 0 THEN 1 ELSE 0 END ) AS Trabajandose
    //         , SUM( CASE WHEN AudU_EnProceso = 0 AND AudU_Terminado = 0 THEN 1 ELSE 0 END ) AS SinIniciar
    //         , count(*) total 
    //       FROM Auditorias_Ubicacion au 
    //      WHERE au.Aud_ID = 1
   
   
        
        return result;
    }

%>