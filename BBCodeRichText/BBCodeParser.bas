B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.51
@EndOfDesignText@
Sub Class_Globals
	Type TextRun(text As String,bold As Boolean,italic As Boolean,color As Int)
	Type Tag(name As String,kind As Int,index As Int)
	Private supportedBBCode As List = Array As String("b","color","i")
	Private code As String
	Private index As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

'[b]Hello [i]world[/i][/b]! [color=#ff00ff]Red[/color] -> [Hello ,world,! ,Red]
Public Sub Parse(str As String) As List
	code = str
	Dim runs As List
	runs.Initialize
	For index=0 To code.Length-1
		If CurrentChar="[" Then
			Dim tagContent As String = TextUntil("]")
			Log(tagContent)
			Dim codeName As String = GetBBCodeName(tagContent)
			If codeName <> "" And tagContent.Contains("/") = False Then
				Log(True)
				Dim run As String = TextUntil("[/"&codeName&"]")
				Log(run)
				runs.Add(run)
			End If
		End If
	Next
	Return runs
End Sub


Sub GetBBCodeName(str As String) As String
	Dim matcher As Matcher = Regex.Matcher("\[/?(.*?)]",str)
	If matcher.Find Then
		Dim match As String = matcher.Group(1)
		If match.Contains("=") Then
			match = match.SubString2(0,match.IndexOf("="))
		End If
		If supportedBBCode.IndexOf(match) <> -1 Then
			Return match
		End If
	End If
	Return ""
End Sub


Sub isSupportedBBCode(str As String) As Boolean
	Dim matcher As Matcher = Regex.Matcher("\[/?(.*?)]",str)
	If matcher.Find Then
		Dim match As String = matcher.Group(1)
		If match.Contains("=") Then
			match = match.SubString2(0,match.IndexOf("="))
		End If
		If supportedBBCode.IndexOf(match) <> -1 Then
			Log("match:"&match)
			Return True
		End If
	End If
	Return False
End Sub

Sub TextUntil(EndStr As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	Dim textLeft As String=code.SubString2(index,code.Length)
	If textLeft.Contains(EndStr) Then
		For i=index To code.Length - EndStr.Length
			Dim s As String=code.CharAt(i)
			If code.SubString2(i,i + EndStr.Length) = EndStr Then
				sb.Append(EndStr)
				Exit
			Else
				sb.Append(s)
			End If
		Next
	End If
	Return sb.ToString
End Sub

Sub CurrentChar As String
	Return code.CharAt(index)
End Sub


Sub PreviousChar As String
	Try
		If index>0 Then
			Return code.CharAt(index-1)
		Else
			Return ""
		End If
	Catch
		Log(LastException)
	End Try
	Return ""
End Sub

Sub NextChar As String
	Try
		If index <= code.Length-2 Then
			Return code.CharAt(index + 1)
		Else
			Return ""
		End If
	Catch
		Log(LastException)
	End Try
	Return ""
End Sub


