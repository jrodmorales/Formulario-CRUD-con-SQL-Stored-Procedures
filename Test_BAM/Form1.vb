Public Class Form1

    Dim conexion As ConexionSQL = New ConexionSQL()
    Dim contenidoTabla As New DataSet()

    Dim tabla As New DataTable()
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

        conexion.Conectar()
        cmbAccion.SelectedIndex = 0

    End Sub

    Private Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        cmbAccion.SelectedIndex = 0
        txtDireccion.Clear()
        txtEdad.Clear()
        txtID.Clear()
        txtNombre.Clear()
        contenidoTabla.Clear()
        dgvUsuarios.DataSource = contenidoTabla.Tables("usu")
    End Sub

    Private Sub btnAccion_Click(sender As Object, e As EventArgs) Handles btnAccion.Click
        contenidoTabla.Tables.Clear()
        dgvUsuarios.DataSource = contenidoTabla.Tables("usu")
        Dim accion As String
        Dim id As Object
        Dim nombre As String
        Dim edad As Object
        Dim direccion As String

        If String.IsNullOrEmpty(cmbAccion.SelectedItem.ToString) Then
            accion = "Ver todos"
        Else
            accion = cmbAccion.SelectedItem.ToString
        End If
        If String.IsNullOrEmpty(txtID.Text) Then
            id = DBNull.Value
        Else
            id = CInt(txtID.Text)
        End If
        If String.IsNullOrEmpty(txtNombre.Text) Then
            nombre = "null"
        Else
            nombre = txtNombre.Text
        End If
        If String.IsNullOrEmpty(txtEdad.Text) Then
            edad = DBNull.Value
        Else
            edad = txtEdad.Text
        End If
        If String.IsNullOrEmpty(txtDireccion.Text) Then
            direccion = "null"
        Else
            direccion = txtDireccion.Text
        End If
        contenidoTabla = conexion.CRUD_DB(accion, id, nombre, edad, direccion)
        dgvUsuarios.DataSource = contenidoTabla.Tables("usu")

    End Sub

    Private Sub txtID_TextChanged(sender As Object, e As EventArgs) Handles txtID.TextChanged
        Dim accion As String = "Editar"
        Try
            If cmbAccion.Text Like accion And txtID.Text IsNot Nothing Then
                Dim contenidoParaTextBox As DataSet = New DataSet()
                contenidoParaTextBox = conexion.CRUD_DB("Buscar", txtID.Text, "null", DBNull.Value, "null")
                txtNombre.Text = contenidoParaTextBox.Tables(0).Rows(0)(1)
                txtEdad.Text = contenidoParaTextBox.Tables(0).Rows(0)(2)
                txtDireccion.Text = contenidoParaTextBox.Tables(0).Rows(0)(3)
                contenidoTabla.Clear()
                dgvUsuarios.DataSource = contenidoTabla.Tables("usu")
            End If

        Catch ex As Exception
            MsgBox("Por favor inserte un ID para editar a un usuario")
        End Try
    End Sub
End Class
