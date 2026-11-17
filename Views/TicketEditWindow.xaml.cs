using System.Windows;
using HelpDesk.Models;

namespace HelpDesk.Views
{
    public partial class TicketEditWindow : Window
    {
        private Ticket currentTicket;

        public TicketEditWindow(Ticket ticket)
        {
            InitializeComponent();
            currentTicket = ticket;
            LoadComboBoxes();
            FillData();
        }

        private void LoadComboBoxes()
        {
            CategoryComboBox.Items.Add("Оборудование");
            CategoryComboBox.Items.Add("Программное обеспечение");
            CategoryComboBox.Items.Add("Сеть");
            CategoryComboBox.Items.Add("Учётная запись");
            CategoryComboBox.Items.Add("Периферия");
            CategoryComboBox.Items.Add("Другое");

            PriorityComboBox.Items.Add("Низкий");
            PriorityComboBox.Items.Add("Средний");
            PriorityComboBox.Items.Add("Высокий");

            StatusComboBox.Items.Add("Новая");
            StatusComboBox.Items.Add("В работе");
            StatusComboBox.Items.Add("Выполнена");
            StatusComboBox.Items.Add("Отклонена");
        }

        private void FillData()
        {
            IdTextBox.Text = currentTicket.Id.ToString();
            DescriptionTextBox.Text = currentTicket.Description;
            CategoryComboBox.SelectedItem = currentTicket.Category;
            PriorityComboBox.SelectedItem = currentTicket.Priority;
            StatusComboBox.SelectedItem = currentTicket.Status;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(DescriptionTextBox.Text))
            {
                MessageBox.Show("Описание не может быть пустым.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // В будущем сохранение в БД
            MessageBox.Show("Изменения будут сохранены после подключения БД.", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
            DialogResult = true;
            Close();
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}
