namespace HelpDesk.Services
{
    public class AuthService
    {
        // В дальнейшем здесь будет логика авторизации через базу данных
        public bool Login(string login, string password)
        {
            // Временная проверка
            return login == "admin" && password == "12345";
        }
    }
}
