using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static GlowESP.Property;
using static GlowESP.ProccesManager;

namespace GlowESP
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            ProcessSearch();
        }
        private void glowCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            GLOWESP = glowCheckBox.Checked;
        }
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            Environment.Exit(0);
        }
        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            HpBased = checkBox1.Checked;
        }
    }
}
