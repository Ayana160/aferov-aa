using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using HelpDesk.Models;

namespace HelpDesk.Views
{
    public partial class MainWindow : Window
    {
        private List<Ticket> tickets = new List<Ticket>();

        public MainWindow()
        {
            InitializeComponent();
            LoadTestData();
            LoadStatusComboBox();
            DateText.Text = DateTime.Now.ToString("dd.MM.yyyy");
            ApplyFilter();
        }

        private void LoadTestData()
        {
            tickets = new List<Ticket>
            {
                new Ticket { Id = 1, Category = "Сеть", Description = "Нет доступа к интернету в кабинете 204", Priority = "Высокий", Status = "Новая", CreatedAt = DateTime.Now.AddDays(-2) },
                new Ticket { Id = 2, Category = "Программное обеспечение", Description = "Ошибка при запуске Word", Priority = "Средний", Status = "В работе", CreatedAt = DateTime.Now.AddDays(-5) },
                new Ticket { Id = 3, Category = "Оборудование", Description = "Не работает принтер на 3 этаже", Priority = "Высокий", Status = "Новая", CreatedAt = DateTime.Now.AddDays(-1) },
                new Ticket { Id = 4, Category = "Учётная запись", Description = "Забыл пароль от учётки", Priority = "Низкий", Status = "Выполнена", CreatedAt = DateTime.Now.AddDays(-10) },
                new Ticket { Id = 5, Category = "Периферия", Description = "Не работает мышь на рабочем месте", Priority = "Средний", Status = "Отклонена", CreatedAt = DateTime.Now.AddDays(-3) },
                new Ticket { Id = 6, Category = "Сеть", Description = "Медленный интернет в актовом зале", Priority = "Средний", Status = "В работе", CreatedAt = DateTime.Now.AddDays(-4) },
                new Ticket { Id = 7, Category = "Оборудование", Description = "Замена картриджа в принтере", Priority = "Низкий", Status = "Выполнена", CreatedAt = DateTime.Now.AddDays(-7) }
            };
        }

        private void LoadStatusComboBox()
        {
            StatusComboBox.Items.Clear();
            StatusComboBox.Items.Add("Все");
            StatusComboBox.Items.Add("Новая");
            StatusComboBox.Items.Add("В работе");
            StatusComboBox.Items.Add("Выполнена");
            StatusComboBox.Items.Add("Отклонена");
            StatusComboBox.SelectedIndex = 0;
        }

        private void ApplyFilter()
        {
            string search = SearchTextBox.Text?.Trim().ToLower() ?? "";
            string status = StatusComboBox.SelectedItem?.ToString() ?? "Все";

            var filtered = tickets.AsEnumerable();

            if (!string.IsNullOrEmpty(search))
            {
                filtered = filtered.Where(t =>
                    t.Description.ToLower().Contains(search) ||
                    t.Category.ToLower().Contains(search) ||
                    t.Status.ToLower().Contains(search));
            }

            if (status != "Все")
            {
                filtered = filtered.Where(t => t.Status == status);
            }

            var result = filtered.ToList();
            TicketsDataGrid.ItemsSource = result;
            TicketCountText.Text = $"Заявок: {result.Count}";
        }

        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            ApplyFilter();
        }

        private void ResetFilterButton_Click(object sender, RoutedEventArgs e)
        {
            SearchTextBox.Text = "";
            StatusComboBox.SelectedIndex = 0;
            ApplyFilter();
        }

        private void AddTicketButton_Click(object sender, RoutedEventArgs e)
        {
            TicketCreateWindow createWindow = new TicketCreateWindow();
            if (createWindow.ShowDialog() == true)
            {
                // В будущем здесь добавление в список/БД
                MessageBox.Show("Заявка будет добавлена после подключения БД.", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
            }
        }

        private void EditTicketButton_Click(object sender, RoutedEventArgs e)
        {
            if (TicketsDataGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите заявку для редактирования.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            Ticket selected = (Ticket)TicketsDataGrid.SelectedItem;
            TicketEditWindow editWindow = new TicketEditWindow(selected);
            editWindow.ShowDialog();
        }

        private void DeleteTicketButton_Click(object sender, RoutedEventArgs e)
        {
            if (TicketsDataGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите заявку для удаления.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var result = MessageBox.Show("Вы действительно хотите удалить выбранную заявку?", "Подтверждение", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                MessageBox.Show("Удаление будет реализовано после подключения БД.", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
            }
        }

        private void LogoutButton_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Выйти из системы?", "Подтверждение", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                LoginWindow loginWindow = new LoginWindow();
                loginWindow.Show();
                this.Close();
            }
        }

        private void RefreshButton_Click(object sender, RoutedEventArgs e)
        {
            ApplyFilter();
            MessageBox.Show("Список обновлён.", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void TicketsDataGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (TicketsDataGrid.SelectedItem != null)
            {
                EditTicketButton_Click(sender, e);
            }
        }
    }
}
