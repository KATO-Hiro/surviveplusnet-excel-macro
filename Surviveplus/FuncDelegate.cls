VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FuncDelegate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'------------------------------------------------------------------------
' FuncDelegate �N���X
'------------------------------------------------------------------------
'   �ړI�F      �����֐��f���Q�[�g ���i��N���X�ł��B
'   ���߁F      ���̃N���X���g�p����ɂ́AMicrosoft Script Control 1.0 �ւ̎Q�Ɛݒ肪�K�v�ł��B
'   �g�p���@�F  FuncModule �� Func ���\�b�h���g���ď��������Ďg�p���Ă��������B
'                  ���၄If Func("a,b", "a=a*10:Return a+b").Run(1,1) = 11 Then MsgBox "OK"
'   �ύX�����F  SHIN-ICHI 2010/10/9 - �V�K�쐬
'   MIT License / Copyright(C) 2010 SHIN-ICHI all rights reserverd. ( http:// surviveplus.net )
'------------------------------------------------------------------------

Private myScriptControl As New ScriptControl
Private valueOfArgs As String
Private valueOfStatements As String

Private Sub Class_Initialize()
    myScriptControl.Language = "VBScript"
End Sub

Private Sub Class_Terminate()
    Set myScriptControl = Nothing
End Sub

Public Sub SetStatement(args As String, statements As String)
    valueOfArgs = args
    valueOfStatements = statements
End Sub

'------------------------------------------------------------------------
'   �ړI�F      �����֐������s���Č��ʂ�Ԃ��܂��B
'   ���́F      ���� args - �֐��ɓn�������i���������Ɏw�肵�����j�w�肵�܂��B
'                 ���̐��Ə��Ԃ͏��������Ɏw�肵�� args �ɍ��킹�Ă��������B
'   �߂�l�F    ���s�������ʂ�Ԃ��܂��B�߂�l�̓��e�� statement �̓��e�ɂ���ĈقȂ�܂��B
'                  �Ⴆ�� statement �ŕ]������ Return ���Ă���ꍇ�� Boolean ��Ԃ��܂��B
'   ���߁F      ���̃��\�b�h���� Invoke �łȂ� Run �Ȃ̂́AInvoke �� Visual Basic 6�n �̗\���ł��邽�߂ł��B
'                 �܂��A���̃��\�b�h������̃v���p�e�B�Ƃ��Ď������Ȃ������̂́AFuncDelegate �I�u�W�F�N�g�̕ϐ��ւ̊��蓖�Ă��ʓ|�ɂȂ邽�߂ł��B
'   �g�p���@�F  ���၄If Func("a,b", "a=a*10:Return a+b").Run(1,1) = 11 Then MsgBox "OK"
'   �ύX�����F  SHIN-ICHI 2010/10/9 - �V�K�쐬
'   MIT License / Copyright(C) 2010 SHIN-ICHI all rights reserverd. ( http:// surviveplus.net )
'------------------------------------------------------------------------
Public Function Run(ParamArray args() As Variant) As Variant
    myScriptControl.Reset
    myScriptControl.Language = "VBScript"
    
    Dim s As Variant
    Dim index As Integer: index = LBound(args)
    Dim argsNamesText As String
    Dim argsValuesText As String
    Dim notObjectIsFirst As Boolean: notObjectIsFirst = True
    For Each s In Split(valueOfArgs, ",")
        Dim argName  As String: argName = Trim(s)
        If IsObject(args(index)) Then
            Call myScriptControl.AddObject(argName, args(index), True)
        Else
            argsNamesText = argsNamesText & IIf(notObjectIsFirst, "", ",") & argName
            argsValuesText = argsValuesText & IIf(notObjectIsFirst, "", ",") & IIf(TypeName(args(index)) = "String", """" & args(index) & """", args(index))
            notObjectIsFirst = False
        End If
        index = index + 1
        If UBound(args) < index Then Exit For
    Next s
    
    Dim subOrFunction As String: subOrFunction = IIf(InStr(valueOfStatements, "Return ") > 0, "Function", "Sub")
    myScriptControl.AddCode (subOrFunction & " mydelegate(" & argsNamesText & "): " & replace(valueOfStatements, "Return ", "mydelegate = ") & ":End " & subOrFunction)
    If InStr(valueOfStatements, "Return ") > 0 Then
        Run = myScriptControl.Eval("mydelegate(" & argsValuesText & ")")
    Else
        myScriptControl.ExecuteStatement ("mydelegate(" & argsValuesText & ")")
    End If
End Function

