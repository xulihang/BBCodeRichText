B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.51
@EndOfDesignText@
Sub Class_Globals
	Type TextRun(text As String,bold As Boolean,italic As Boolean,color As String)
	Private supportedBBCodes As List = Array As String("b","color","i")
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

'[b]Hello [i]world[/i][/b]! [color=#ff00ff]Red[/color] -> [Hello ,world,! ,Red]
Public Sub Parse(str As String) As List
	Dim run As TextRun
	run.Initialize
	run.text = str
	If validBBCode(str) Then
		Return ParseRun(run)
	Else
		Return Array(run)
	End If
End Sub

Private Sub ParseRun(run As TextRun) As List
	Dim runs As List
	runs.Initialize
	If run.text = "" Then
		Return runs
	End If
	Dim str As String = run.text
	Dim plainText As StringBuilder
	plainText.Initialize
	For index=0 To str.Length-1
		If CurrentChar(str,index)="[" Then
			Dim tagContent As String = TextUntil("]",str,index)
			Dim codeName As String = GetBBCodeName(tagContent)
			If codeName <> "" And tagContent.Contains("/") = False Then
				Dim text As String = plainText.ToString
				If text <> "" Then
					runs.Add(CreateRun(text,run,"",""))
				End If
				plainText.Initialize
				Dim endTag As String = "[/"&codeName&"]"
				Dim runText As String = TextUntil(endTag,str,index)
				If runText<>"" Then
				    index = index + runText.Length - 1
				    runText = CodePairStripped(runText,tagContent,endTag)				
					Dim richRun As TextRun = CreateRun(runText,run,codeName,tagContent)
					Dim innerRuns As List
					innerRuns.Initialize
					parseInnerRuns(richRun,innerRuns)
					runs.AddAll(innerRuns)
				End If
			End If
		Else
			plainText.Append(CurrentChar(str,index))
		End If
	Next
	Dim text As String = plainText.ToString
	If text <> "" Then
		runs.Add(CreateRun(text,run,"",""))
	End If
	Return runs
End Sub

Private Sub parseInnerRuns(run As TextRun,runs As List)
	Dim parsedRuns As List  = ParseRun(run)
	If parsedRuns.Size = 1 Then ' no tags
		runs.Add(parsedRuns.Get(0))
	Else
		For Each innerRun As TextRun In parsedRuns
			parseInnerRuns(innerRun,runs)
		Next
	End If
End Sub


'[b]Hello [i]world[/i][/b] -> Hello [i]world[/i]
Private Sub CodePairStripped(runText As String,tagContent As String,endTag As String) As String
	runText = runText.Replace(tagContent,"")
	runText= runText.Replace(endTag,"")
	Return runText
End Sub

'text:[color=#ff00ff]Red[/color],codeName:color,tagContent:[color=#ff00ff]
private Sub CreateRun(text As String,parentRun As TextRun,codeName As String,tagContent As String) As TextRun
	Dim run As TextRun
	run.Initialize
	run.text = text
	
	If parentRun.IsInitialized Then
		run.bold = parentRun.bold
		run.color = parentRun.color
		run.italic = parentRun.italic
	End If
	
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


private Sub validBBCode(str As String) As Boolean
	Dim count As Int = 0
	Dim matcher As Matcher = Regex.Matcher("\[/?(.*?)]",str)
	Do While matcher.Find
		Dim match As String = matcher.Group(1)
		If match.Contains("=") Then
			match = match.SubString2(0,match.IndexOf("="))
		End If
		If match.Contains("[") Or match.Contains("]") Then
			Return False
		End If
		If supportedBBCodes.IndexOf(match) <> -1 Then
			count = count + 1
		End If
	Loop
	If count > 0 Then
		If count Mod 2 = 0 Then
			Return True
		End If
	End If	
	Return False
End Sub

Sub GetBBCodeName(str As String) As String
	Dim matcher As Matcher = Regex.Matcher("\[/?(.*?)]",str)
	If matcher.Find Then
		Dim match As String = matcher.Group(1)
		If match.Contains("=") Then
			match = match.SubString2(0,match.IndexOf("="))
		End If
		If supportedBBCodes.IndexOf(match) <> -1 Then
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


