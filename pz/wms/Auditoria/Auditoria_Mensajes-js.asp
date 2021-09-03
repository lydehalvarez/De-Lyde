<%
 

    function getInformation()
    {
        var results = []
        var sSQL = "SELECT AudU_AsignadoA, AudU_Comentario, AudU_FechaRegistro, Ubi_Nombre "
                 + " FROM Auditorias_Ubicacion au, Ubicacion u "
                 + " WHERE au.Aud_ID = " + Aud_ID
                 + " AND u.Ubi_ID = au.AudU_ID "
                 + " AND au.AudU_Comentario <> '' "
                                     
   
        var rs = AbreTabla(sSQL,1,0)
        var count = 0
        while(!rs.EOF){
            var result = {}
            result.Auditor = getAuditorInformation(rs.Fields.Item("AudU_AsignadoA").Value)
            result.RegisterDate = rs.Fields.Item("AudU_FechaRegistro").Value
            result.Ubication = rs.Fields.Item("Ubi_Nombre").Value
            result.Comment = rs.Fields.Item("AudU_Comentario").Value
            results[count]=result
            count++
            rs.MoveNext()
        }

        rs.Close()

        return results
    }

    function getAuditorInformation(id) {
        var result = {}
        var sSQL = "SELECT" 
        sSQL += " Usu_Nombre,"
        sSQL += " (Usu_RutaImg + Usu_Imagen) as imagePath "
        sSQL += " from Usuario where Usu_ID = " + id
        var rs = AbreTabla(sSQL,1,0)
        if(!rs.EOF){
            result.Name = rs.Fields.Item("Usu_Nombre").Value
            result.Image = rs.Fields.Item("imagePath").Value
        }

        rs.Close()

        return result
    }

%>