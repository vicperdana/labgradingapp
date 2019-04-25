using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Management.Automation;
using System.Text;
using System.Net;
using System.Collections.Specialized;
using Newtonsoft.Json;

namespace GradingApp
{
	public partial class Default : System.Web.UI.Page
	{
        
        protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void ExecuteCode_Click(object sender, EventArgs e)
		{
			// Clean the Result TextBox
			ResultBox.Text = string.Empty;

			// Initialize PowerShell engine
			var shell = PowerShell.Create();

            // Add the script to the PowerShell object
            //shell.Commands.AddScript(Input.Text);
            //shell.Commands.AddScript("D:\\home\\site\\wwwroot\\scripts\\grading.ps1");

            // Execute the script
            //var results = shell.Invoke();
            var url = "";
            if (drpdownSubscription.SelectedValue == "Vic") { 
                url = "https://s15events.azure-automation.net/webhooks?token=r7PPdtnafRDW%2fxZH%2bsHnQZCeiFHJyNb%2bEAXcYzRrE0E%3d";
            }
            if (drpdownSubscription.SelectedValue == "Tyson")
            {
                url = "https://s3events.azure-automation.net/webhooks?token=7w2IMYfVN9QWJ92yAJIKlXwS23MtJKkUQI1kNtsoGNM%3d";
            }
            if (drpdownSubscription.SelectedValue == "Ronald")
            {
                url = "https://s3events.azure-automation.net/webhooks?token=c9scnpn7ielNe40lBGxaghJn5Widx8ilLCLKCfiTwqU%3d";
            }
            if (drpdownSubscription.SelectedValue == "Jean-Pierre")
            {
                url = "https://s1events.azure-automation.net/webhooks?token=Met8pPqF0eiJL8KYT0N37SnN7fXf5ex71%2blEPzQ2QoQ%3d";
            }
        
            var results = "";
            var vm = new {
                StudentName = txtStudentName.Text,
                EmailTo = txtEmailTo.Text,
                ResourceGroup = txtResourceGroup.Text
            };

            using (var wb = new WebClient())
            {
                var data = JsonConvert.SerializeObject(vm);
                wb.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                var response = wb.UploadString(new Uri(url), "POST", data);
                //string responseInString = Encoding.UTF8.GetString(response);
                results = response;
            }


            ResultBox.Text = "Automation Job ID: " + results + "\nResult will be emailed to "+ txtEmailTo.Text;
            // display results, with BaseObject converted to string
            // Note : use |out-string for console-like output
            /*if (results.Count > 0)
			{
				// We use a string builder ton create our result text
				var builder = new StringBuilder();

				foreach (var psObject in results)
				{
					// Convert the Base Object to a string and append it to the string builder.
					// Add \r\n for line breaks
					builder.Append(psObject.BaseObject.ToString() + "\r\n");
				}

				// Encode the string in HTML (prevent security issue with 'dangerous' caracters like < >
				ResultBox.Text = Server.HtmlEncode(builder.ToString());

			}*/
        }
	}
}