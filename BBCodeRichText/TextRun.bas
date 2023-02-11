B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private bold As Boolean = False
	Private italic As Boolean = False
	Private color As Int
	Private text As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	Dim xui As XUI
	color = xui.Color_Black
End Sub