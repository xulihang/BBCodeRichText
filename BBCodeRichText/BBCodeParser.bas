B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.51
@EndOfDesignText@
Sub Class_Globals
	Type TextRun(text As String,bold As Boolean,italic As Boolean,color As String)
	Type Tag(name As String,kind As Int,index As Int)
	Private supportedBBCode As List = Array As String("b","color","i")
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

'[b]Hello [i]world[/i][/b]! [color=#ff00ff]Red[/color] -> [Hello ,world,! ,Red]
Public Sub Parse(str As String) As List
	Dim runs As List
	runs.Initialize
	Dim plainText As StringBuilder
	plainText.Initialize
	For index=0 To str.Length-1
		If CurrentChar(str,index)="[" Then
			Dim tagContent As String = TextUntil("]",str,index)
			Log(tagContent)
			Dim codeName As String = GetBBCodeName(tagContent)
			If codeName <> "" And tagContent.Contains("/") = False Then
				Dim text As String = plainText.ToString
				If text <> "" Then
					runs.Add(CreateRun(text,"",""))
				End If
				plainText.Initialize
				Dim runText As String = TextUntil("[/"&codeName&"]",str,index)
				runs.Add(CreateRun(runText,codeName,tagContent))
				index = index + runText.Length - 1
			End If
		Else
			plainText.Append(CurrentChar(str,index))
		End If
	Next
	Dim text As String = plainText.ToString
	If text <> "" Then
		runs.Add(CreateRun(text,"",""))
	End If
	Return runs
End Sub

'text:[color=#ff00ff]Red[/color],codeName:color,tagContent:[color=#ff00ff]
private Sub CreateRun(text As String,codeName As String,tagContent As String) As TextRun
	Dim run As TextRun
	run.Initialize
	run.text = text
	If codeName = "b" Then
		run.bold = True
	else if codeName = "i" Then
		run.italic = True
	else if codeName = "color" Then
		run.color = ParseColor(tagContent)
	End If
	Return run
End Sub

'parse [color=#ff0000] and return the rgb value 255,0,0
private Sub ParseColor(tagContent As String) As String
	Dim hex As String
	hex = tagContent.SubString2(tagContent.IndexOf("=")+1,tagContent.Length-1)
	Dim r As Int = Bit.ParseInt(hex.SubString2(1,3), 16)
	Dim g As Int = Bit.ParseInt(hex.SubString2(3,5), 16)
	Dim b As Int = Bit.ParseInt(hex.SubString2(5,7), 16)
	Return r&","&g&","&b
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

Sub TextUntil(EndStr As String,str As String,index As Int) As String
	Dim sb As StringBuilder
	sb.Initialize
	Dim textLeft As String=str.SubString2(index,str.Length)
	If textLeft.Contains(EndStr) Then
		For i=index To str.Length - EndStr.Length
			Dim s As String=str.CharAt(i)
			If str.SubString2(i,i + EndStr.Length) = EndStr Then
				sb.Append(EndStr)
				Exit
			Else
				sb.Append(s)
			End If
		Next
	End If
	Return sb.ToString
End Sub

Sub CurrentChar(str As String,index As Int) As String
	Return str.CharAt(index)
End Sub


Sub PreviousChar(str As String,index As Int) As String
	Try
		If index>0 Then
			Return str.CharAt(index-1)
		Else
			Return ""
		End If
	Catch
		Log(LastException)
	End Try
	Return ""
End Sub

Sub NextChar(str As String,index As Int) As String
	Try
		If index <= str.Length-2 Then
			Return str.CharAt(index + 1)
		Else
			Return ""
		End If
	Catch
		Log(LastException)
	End Try
	Return ""
End Sub


