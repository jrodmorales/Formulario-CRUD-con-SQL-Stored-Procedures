Imports System.Data.SqlClient

Public Class ConexionSQL

    Public conexionDB As SqlConnection
    Public datosTabla As DataSet = New DataSet()

    Public Sub Conectar()
        Try
            conexionDB = New SqlConnection("server=localhost; data source=DESKTOP-RC6DH6P\SQLEXPRESS;database=DB_TEST_BAM; integrated security=SSPI")
            conexionDB.Open()
        Catch ex As Exception
            MsgBox("Error al conectar: " + ex.Message)
        End Try
    End Sub

    Public Function CRUD_DB(accion As String, ID As Object, nombre As String, edad As Object, direccion As String) As DataSet

        Dim cadena As String
        cadena = accion + "," + ID.ToString + "," + nombre + "," + edad.ToString + "," + direccion
        Dim comando As New SqlCommand
        comando.Connection = conexionDB
        comando.CommandText = "CRUD_Usuario2"

        comando.CommandType = CommandType.StoredProcedure
        comando.Parameters.AddWithValue("@cadena", cadena)

        Dim da As New SqlDataAdapter(comando)

        Try
            da.Fill(datosTabla, "usu")
        Catch ex As Exception
            MsgBox("Error: " + ex.Message)
        End Try

        If datosTabla Is Nothing Then
            MsgBox("el dataset está vacío")
        End If


        Return datosTabla

    End Function

End Class
