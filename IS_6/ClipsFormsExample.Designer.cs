using System.Windows.Forms;

namespace ClipsFormsExample
{
    partial class ClipsFormsExample
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
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
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.SplitContainer splitContainer1;
    private System.Windows.Forms.TextBox codeBox;
    private System.Windows.Forms.TextBox outputBox;
    private System.Windows.Forms.Panel panel2;
    private System.Windows.Forms.Button nextButton;
    private System.Windows.Forms.Button resetButton;
    private System.Windows.Forms.Button saveAsButton;
    private System.Windows.Forms.Button openButton;
    private System.Windows.Forms.OpenFileDialog clipsOpenFileDialog;
    private System.Windows.Forms.Button fontButton;
    private System.Windows.Forms.FontDialog fontDialog1;
    private System.Windows.Forms.SaveFileDialog clipsSaveFileDialog;
        private System.Windows.Forms.ComboBox voicesBox;
        private System.Windows.Forms.Panel panelOptions;
    }
}

