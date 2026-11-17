using System.Windows;

namespace HelpDesk.Views
{
    public partial class TicketCreateWindow : Window
    {
        public TicketCreateWindow()
        {
            InitializeComponent();
            LoadComboBoxes();
        }

        private void LoadComboBoxes()
        {
            CategoryComboBox.Items.Add("Оборудование");
            CategoryComboBox.Items.Add("Программное обеспечение");
            CategoryComboBox.Items.Add("Сеть");
            CategoryComboBox.Items.Add("Учётная запись");
            CategoryComboBox.Items.Add("Периферия");
            CategoryComboBox.Items.Add("Другое");
            CategoryComboBox.SelectedIndex = 0;

            PriorityComboBox.Items.Add("Низкий");
            PriorityComboBox.Items.Add("Средний");
            PriorityComboBox.Items.Add("Высокий");
            PriorityComboBox.SelectedIndex = 1;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (CategoryComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите категорию.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(DescriptionTextBox.Text))
            {
                MessageBox.Show("Введите описание заявки.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // В будущем сохранение в БД
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
