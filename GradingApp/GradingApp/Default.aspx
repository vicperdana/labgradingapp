<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GradingApp.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            height: 23px;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div>
        <table>
            <tr><td class="auto-style1"></td><td class="auto-style1"><h1 align="left"><font face = "Arial" size = "3">Mock Lab Grading</font></h1></td></tr>
            <tr><td>&nbsp;</td><td><font face = "Arial" size = "2">Your Name</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                <asp:TextBox ID="txtStudentName" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
        ControlToValidate="txtStudentName" ErrorMessage="Student Name is required"
        SetFocusOnError="True" ></asp:RequiredFieldValidator>
                </td></tr>
            <tr><td>&nbsp;</td><td><font face = "Arial" size = "2">Resource Group Name&nbsp;&nbsp; </font>&nbsp;
                <asp:TextBox ID="txtResourceGroup" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
        ControlToValidate="txtResourceGroup" ErrorMessage="Resource Group Name is required"
        SetFocusOnError="True" ></asp:RequiredFieldValidator>
                </td></tr>
            <tr><td>
                <br />
                </td><td>
                    <font face = "Arial" size = "2">Your Email</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                    <asp:TextBox ID="txtEmailTo" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
        ControlToValidate="txtEmailTo" ErrorMessage="Email is required"
        SetFocusOnError="True" ></asp:RequiredFieldValidator>

 <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
             ErrorMessage="Invalid Email" ControlToValidate="txtEmailTo"
             SetFocusOnError="True"
             ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
</asp:RegularExpressionValidator>
            </td></tr>
            <tr><td>
                &nbsp;</td><td>
                    <font face="arial" size="2">Subscription</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                    <asp:DropDownList ID="drpdownSubscription" runat="server" Height="16px" Width="107px">
                        <asp:ListItem>Vic</asp:ListItem>
                        <asp:ListItem>Tyson</asp:ListItem>
                        <asp:ListItem>Jean-Pierre</asp:ListItem>
                        <asp:ListItem>Ronald</asp:ListItem>
                    </asp:DropDownList>
            </td></tr>
            <tr><td>
                &nbsp;</td><td>
                <asp:Button ID="ExecuteCode" runat="server" Text="Grade Mock" Width="200" onclick="ExecuteCode_Click" />
            </td></tr>
                <tr><td>&nbsp;</td><td><h3><font face = "Arial" size = "3">Job Id</font></h3></td></tr>
                <tr><td>
                    &nbsp;</td><td>
                    <asp:TextBox ID="ResultBox" TextMode="MultiLine" Width="700px" Height="41px" runat="server"></asp:TextBox>
                </td></tr>
        </table>
    </div>
    <font face = "Arial" size = "1">Copyright: Digital Workplace VIC - Dimension Data</font></form>
</body>
</html>