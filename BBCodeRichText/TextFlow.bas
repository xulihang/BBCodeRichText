﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=3.71
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private fx As JFX
	Public texts As List
	Private lastItem As JavaObject
	Private allText As StringBuilder
	Private textInDisplay As StringBuilder
	Public TextAlignment As JavaObject
End Sub

Public Sub Initialize
	texts.Initialize
	allText.Initialize
	textInDisplay.Initialize
	TextAlignment.InitializeStatic("javafx.scene.text.TextAlignment")
End Sub

Public Sub AddText(Text As String) As TextFlow
	Dim lastItem As JavaObject
	lastItem.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	texts.Add(lastItem)
	allText.Append(Text)
	textInDisplay.Append(Text)
	Return Me
End Sub

Public Sub AddTextWithStrikethrough(text As String,realText As String) As TextFlow
	Dim lastItem As JavaObject
	lastItem.InitializeNewInstance("javafx.scene.text.Text", Array(text))
	textInDisplay.Append(text)
	texts.Add(lastItem)
	allText.Append(realText)
	lastItem.RunMethod("setStrikethrough", Array(True))
	Return Me
End Sub

Public Sub AddMonoText(text As String) As TextFlow
	allText.Append(text)
	textInDisplay.Append(text)
	Dim lastItem As JavaObject
	lastItem.InitializeNewInstance("javafx.scene.text.Text", Array(text))
	CSSUtils.SetStyleProperty(lastItem," -fx-font-family","monospace")
	texts.Add(lastItem)
	Return Me
End Sub

Public Sub getText As String
	Return allText.ToString
End Sub

Public Sub getTextInDisplay As String
	Return textInDisplay.ToString
End Sub

Public Sub SetFontWithCSS(weight As String,size As Int,familyName As String,style As String) As TextFlow
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append(style).Append(" ")
	sb.Append(weight).Append(" ")
	sb.Append(size).Append(" ")
	sb.Append($"""$&familyName&$"""$)
	'sb.Append($""Helvetica""$)
	'Log(sb.ToString)
	lastItem.RunMethod("setStyle",Array("-fx-font: "&sb.ToString))
	'lastItem.RunMethod("setStyle",Array("-fx-font-size: "&size&"px"))
	'lastItem.RunMethod("setStyle",Array("-fx-font-family: "&familyName))
	'lastItem.RunMethod("setStyle",Array("-fx-font-style: "&style))
	Return Me
End Sub

Public Sub SetStroke(rgb As String,width As Int) As TextFlow
	lastItem.RunMethod("setStyle",Array("-fx-stroke: rgb("&rgb&")"))
	lastItem.RunMethod("setStyle",Array("-fx-stroke-width: "&width))
	Return Me
End Sub

Public Sub SetItalic(bold As Boolean) As TextFlow
	Dim Font As Font=lastItem.RunMethod("getFont", Null)
	Font=fx.CreateFont(Font.FamilyName,Font.Size,bold,True)
	lastItem.RunMethod("setFont", Array(Font))
	Return Me
End Sub

Public Sub SetFont(Font As Font) As TextFlow
	lastItem.RunMethod("setFont", Array(Font))
	Return Me
End Sub

Public Sub SetColor(Color As Paint) As TextFlow
	lastItem.RunMethod("setFill", Array(Color))
	Return Me	
End Sub

Public Sub SetUnderline(Underline As Boolean) As TextFlow
	lastItem.RunMethod("setUnderline", Array(Underline))
	Return Me
End Sub

Public Sub SetStrikethrough(Strikethrough As Boolean) As TextFlow
	lastItem.RunMethod("setStrikethrough", Array(Strikethrough))
	Return Me
End Sub

Public Sub SetFauxItalic As TextFlow
	Dim item As JavaObject = lastItem
	Dim n As Node = item
	Dim TR As JavaObject
	TR.InitializeNewInstance("javafx.scene.effect.PerspectiveTransform",Null)
	Dim width As Double = n.PrefWidth
	Dim height As Double = n.PrefHeight
	Dim Bounds As B4XRect = GetLayoutBounds(item)
	width = Bounds.Width
	height = Bounds.Height
	TR.Runmethod("setUlx",Array(2.0))
	TR.Runmethod("setUly",Array(0.0))
	TR.Runmethod("setUrx",Array(width + 2))
	TR.Runmethod("setUry",Array(0.0))
	TR.Runmethod("setLrx",Array(width))
	TR.Runmethod("setLry",Array(height))
	TR.Runmethod("setLlx",Array(0.0))
	TR.Runmethod("setLly",Array(height))
	item.RunMethod("setEffect", Array(TR))
	Return Me
End Sub

Public Sub SetFauxBold(color As Paint) As TextFlow
	Dim item As JavaObject = lastItem
	item.RunMethod("setStroke",Array(color))
	item.RunMethod("setStrokeWidth",Array(0.5))
	Return Me
End Sub

Public Sub GetLayoutBounds(TextClass As JavaObject) As B4XRect
	Dim Bounds As JavaObject = TextClass.RunMethod("getLayoutBounds",Null)
	Dim R As B4XRect
	R.Initialize(Bounds.RunMethod("getMinX",Null),Bounds.RunMethod("getMinY",Null),Bounds.RunMethod("getMaxX",Null),Bounds.RunMethod("getMaxY",Null))
	Return R
End Sub

Public Sub Reset As TextFlow
	texts.Initialize
	Return Me
End Sub


Public Sub CreateTextFlowWithWidth(width As Double) As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	tf.RunMethodJO("getChildren", Null).RunMethod("addAll", Array(texts))
	tf.RunMethod("setMaxWidth",Array(width))
	Return tf
End Sub

Public Sub CreateTextFlow As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	tf.RunMethodJO("getChildren", Null).RunMethod("addAll", Array(texts))
	Return tf
End Sub

' LEFT,CENTER,RIGHT,JUSTIFY
Public Sub CreateTextFlowWithAlignmentAndWidth(alignment As String,width As Double) As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	tf.RunMethod("setTextAlignment",Array(TextAlignment.GetField(alignment)))
	tf.RunMethodJO("getChildren", Null).RunMethod("addAll", Array(texts))
	tf.RunMethod("setMaxWidth",Array(width))
	Return tf
End Sub