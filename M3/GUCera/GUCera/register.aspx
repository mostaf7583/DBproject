<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="GUCera.register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            PLEASE REGISTER FIRST</div>
</body>
    Email<br />
    <asp:TextBox ID="Email" runat="server"></asp:TextBox>
    <br />
    Name<br />
    <asp:TextBox ID="Name" runat="server"></asp:TextBox>
    <br />
    Password :<br />
    <asp:TextBox ID="password" runat="server"></asp:TextBox>
    <br />
    <br />
    Enter your position :<br />
    <asp:RadioButton ID="GUCian" runat="server" OnCheckedChanged="RadioButton1_CheckedChanged" Text="GUCian" />
    <br />
    <asp:RadioButton ID="NonGUCian" runat="server" Text="NonGUCian" />
    <br />
    <asp:RadioButton ID="Supervisor" runat="server" OnCheckedChanged="Supervisor_CheckedChanged" Text="Supervisor" />
    <br />
    <asp:RadioButton ID="Examiner" runat="server" Text="Examiner" />
    <br />
    <br />
    <asp:Button ID="Button1" runat="server" onclick="Register" Text="register" style="height: 26px" />
    <br />
    </form>

</html>
