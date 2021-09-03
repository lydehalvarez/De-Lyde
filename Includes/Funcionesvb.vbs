<SCRIPT RUNAT=SERVER LANGUAGE=VBSCRIPT>	
on  error resume next
				

function Terminacion_nul(str1,str2)							

dim Largo11 
dim Largo22
dim Cadena
dim Final

	Largo11=len(str1)
	Largo22=len(str2)
	Final=int(Largo11/Largo22)

	For X = 1 to Final
		Cadena = Cadena & "</ul>"
	Next

	Terminacion_nul=Cadena

End function

function Cadena1MayorCadena2(str1,str2)							

dim Largo1 
dim Largo2

	Largo1=len(str1)
	Largo2=len(str2)

	if Largo1 > Largo2 then
		Cadena1MayorCadena2=true
	Else
		Cadena1MayorCadena2=False
	end if

End function

function DoTrim(str, side)							
dim strRet								

	strRet = str																		
	If (side = "left") Then						
		strRet = LTrim(str)						
	ElseIf (side = "right") Then						
		strRet = RTrim(str)						
	Else									
		strRet = Trim(str)						
	End If									
										
	DoTrim = strRet								
End Function							


function Remplaza(str,sbuscado,sremplazo)

	Remplaza = replace(str,sbuscado,sremplazo)
end function

function formato(str,dec )
dim Resulta

	Resulta = FormatNumber(str,dec)
	Resulta = Remplaza(Resulta,",","x")
	Resulta = Remplaza(Resulta,".",",")
	Resulta = Remplaza(Resulta,"x",".")
	formato = Resulta
	formato = FormatNumber(str,dec)
end function

</SCRIPT>