
using System.Windows.Forms;

namespace prod_sys
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
            this.panelQuestions = new FlowLayoutPanel();
            this.richTextBox1 = new RichTextBox();
            this.buttonForward = new Button();

            this.SuspendLayout();

            // panelQuestions
            this.panelQuestions.Location = new System.Drawing.Point(24, 24);
            this.panelQuestions.Size = new System.Drawing.Size(800, 600);
            this.panelQuestions.AutoScroll = true;

            // richTextBox1
            this.richTextBox1.Location = new System.Drawing.Point(840, 24);
            this.richTextBox1.Size = new System.Drawing.Size(800, 600);

            // buttonForward
            this.buttonForward.Location = new System.Drawing.Point(24, 640);
            this.buttonForward.Size = new System.Drawing.Size(200, 60);
            this.buttonForward.Text = "Перезапуск";
            this.buttonForward.Click += new System.EventHandler(this.buttonForward_Click);

            // Form1
            this.ClientSize = new System.Drawing.Size(1680, 720);
            this.Controls.Add(this.panelQuestions);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.buttonForward);
            this.Controls.Add(this.buttonRun);
            this.Text = "Продукционная система";
            this.ResumeLayout(false);
        }


        #endregion

        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        //private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.CheckedListBox checkedListBox2;
    }
}

