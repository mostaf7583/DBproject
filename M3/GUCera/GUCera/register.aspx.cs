using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUCera
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Register(object sender, EventArgs e)
        {
            String connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ToString();       
            SqlConnection conn = new SqlConnection(connStr);

            String pass = password.Text;
            String email = Email.Text; 
            String name = Name.Text;
            if (GUCian.Checked == true )
            {
                SqlCommand registerGUCproc = new SqlCommand("StudentRegister2",conn);
                StudentRegister2.Parameters.Add(new SqlParameter("@password",pass));
                StudentRegister2.Parameters.Add(new SqlParameter("@GUCian", 1));
                StudentRegister2.Parameters.Add(new SqlParameter("@email", Email));

            }else
            if (NonGUCian.Checked == true)
            {
                SqlCommand registerNOnGUCianproc = new SqlCommand("StudentRegister2", conn);
                StudentRegister2.Parameters.Add(new SqlParameter("@password", pass));
                StudentRegister2.Parameters.Add(new SqlParameter("@GUCian", 0));
                StudentRegister2.Parameters.Add(new SqlParameter("@email", Email));

            }
            else
            if(Examiner.Checked == true)
            {
                SqlCommand registerExaminerproc = new SqlCommand("examinerRegister", conn);
                examinerRegister.Parameters.Add(new SqlParameter("@password", pass));
                examinerRegister.Parameters.Add(new SqlParameter("@email", Email));

            }
            else
            if (Supervisor.Checked == true)
            {
                SqlCommand registerSupervisorproc = new SqlCommand("SupervisorRegister2", conn);
                SupervisorRegister2.Parameters.Add(new SqlParameter("@password", pass));
                SupervisorRegister2.Parameters.Add(new SqlParameter("@email", Email));

            }


            SqlCommand registerproc = new SqlCommand("StudentRegister2",conn);
        }

        protected void RadioButton1_CheckedChanged(object sender, EventArgs e)
        {

        }

        protected void Supervisor_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}