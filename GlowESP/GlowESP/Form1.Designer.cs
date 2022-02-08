
namespace GlowESP
{
    partial class Form1
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.HpBasedBox = new System.Windows.Forms.Button();
            this.glowCheckBox = new System.Windows.Forms.CheckBox();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // HpBasedBox
            // 
            this.HpBasedBox.Location = new System.Drawing.Point(37, 12);
            this.HpBasedBox.Name = "HpBasedBox";
            this.HpBasedBox.Size = new System.Drawing.Size(138, 23);
            this.HpBasedBox.TabIndex = 0;
            this.HpBasedBox.Text = "Поиск процесса игры";
            this.HpBasedBox.UseVisualStyleBackColor = true;
            this.HpBasedBox.Click += new System.EventHandler(this.button1_Click);
            // 
            // glowCheckBox
            // 
            this.glowCheckBox.Location = new System.Drawing.Point(37, 57);
            this.glowCheckBox.Name = "glowCheckBox";
            this.glowCheckBox.Size = new System.Drawing.Size(104, 24);
            this.glowCheckBox.TabIndex = 2;
            this.glowCheckBox.Text = "GlowESP";
            this.glowCheckBox.UseVisualStyleBackColor = true;
            this.glowCheckBox.CheckedChanged += new System.EventHandler(this.glowCheckBox_CheckedChanged);
            // 
            // checkBox1
            // 
            this.checkBox1.Location = new System.Drawing.Point(37, 87);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(104, 24);
            this.checkBox1.TabIndex = 3;
            this.checkBox1.Text = "HP";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(208, 192);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.glowCheckBox);
            this.Controls.Add(this.HpBasedBox);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button HpBasedBox;
        private System.Windows.Forms.CheckBox glowCheckBox;
        private System.Windows.Forms.CheckBox checkBox1;
    }
}

