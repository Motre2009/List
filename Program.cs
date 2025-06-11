using Microsoft.Data.Sqlite;

namespace List;

internal class Program
{
    private const string ConnectionString = "Data Source=C:\\Project SQL\\List\\list.db";

    static void Main(string[] args)
    {
        using var connection = new SqliteConnection(ConnectionString);
        try
        {
            connection.Open();
            Console.WriteLine("Підключення встановлено.");
            ShowMenu(connection);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Помилка підключення: {ex.Message}");
        }

        Console.WriteLine("Натисніть Enter для виходу...");
        Console.ReadLine();
    }

    static void ShowMenu(SqliteConnection conn)
    {
        while (true)
        {
            Console.WriteLine("\nМеню:");
            Console.WriteLine("1 - Всі покупці");
            Console.WriteLine("2 - Email покупців");
            Console.WriteLine("3 - Розділи");
            Console.WriteLine("4 - Акційні товари");
            Console.WriteLine("5 - Міста");
            Console.WriteLine("6 - Країни");
            Console.WriteLine("7 - Покупці з міста");
            Console.WriteLine("8 - Покупці з країни");
            Console.WriteLine("9 - Акції для країни");
            Console.WriteLine("10 - Додати покупця");
            Console.WriteLine("11 - Вийти");
            Console.Write("Виберіть опцію: ");
            var input = Console.ReadLine();

            switch (input)
            {
                case "1": ShowAllBuyers(conn); break;
                case "2": ShowAllEmails(conn); break;
                case "3": ShowSections(conn); break;
                case "4": ShowPromotions(conn); break;
                case "5": ShowCities(conn); break;
                case "6": ShowCountries(conn); break;
                case "7":
                    Console.Write("Місто: ");
                    ShowBuyersByCity(conn, Console.ReadLine());
                    break;
                case "8":
                    Console.Write("Країна: ");
                    ShowBuyersByCountry(conn, Console.ReadLine());
                    break;
                case "9":
                    Console.Write("Країна: ");
                    ShowPromotionsByCountry(conn, Console.ReadLine());
                    break;
                case "10":
                    Console.Write("Ім’я: ");
                    var name = Console.ReadLine();
                    Console.Write("Дата народження (yyyy-MM-dd): ");
                    var birth = DateTime.Parse(Console.ReadLine());
                    Console.Write("Стать (M/F): ");
                    var gender = Console.ReadLine();
                    Console.Write("Email: ");
                    var email = Console.ReadLine();
                    Console.Write("ID країни: ");
                    var countryId = int.Parse(Console.ReadLine());
                    Console.Write("ID міста: ");
                    var cityId = int.Parse(Console.ReadLine());
                    InsertBuyer(conn, name, birth, gender, email, countryId, cityId);
                    break;
                case "11": return;
                default: Console.WriteLine("Невідома опція."); break;
            }
        }
    }

    static void ShowAllBuyers(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT BuyerId, FullName, BirthDate, Gender, Email FROM Buyers;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine($"{reader.GetInt32(0)} | {reader.GetString(1)} | {reader.GetString(2)} | {reader.GetString(3)} | {reader.GetString(4)}");
        }
    }

    static void ShowAllEmails(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT Email FROM Buyers;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine(reader.GetString(0));
        }
    }

    static void ShowSections(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT SectionName FROM Sections;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine(reader.GetString(0));
        }
    }

    static void ShowPromotions(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT PromoName, StartDate, EndDate FROM Promotions;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine($"{reader.GetString(0)} | {reader.GetString(1)} → {reader.GetString(2)}");
        }
    }

    static void ShowCities(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT CityName FROM Cities;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine(reader.GetString(0));
        }
    }

    static void ShowCountries(SqliteConnection conn)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT CountryName FROM Countries;";
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine(reader.GetString(0));
        }
    }

    static void ShowBuyersByCity(SqliteConnection conn, string city)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = @"
                SELECT b.FullName, b.Email
                FROM Buyers b
                JOIN Cities c ON b.CityId = c.CityId
                WHERE c.CityName = $city;";
        cmd.Parameters.AddWithValue("$city", city);
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine($"{reader.GetString(0)} | {reader.GetString(1)}");
        }
    }

    static void ShowBuyersByCountry(SqliteConnection conn, string country)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = @"
                SELECT b.FullName, b.Email
                FROM Buyers b
                JOIN Countries c ON b.CountryId = c.CountryId
                WHERE c.CountryName = $country;";
        cmd.Parameters.AddWithValue("$country", country);
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine($"{reader.GetString(0)} | {reader.GetString(1)}");
        }
    }

    static void ShowPromotionsByCountry(SqliteConnection conn, string country)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = @"
                SELECT p.PromoName, p.StartDate, p.EndDate
                FROM Promotions p
                JOIN Countries c ON p.CountryId = c.CountryId
                WHERE c.CountryName = $country;";
        cmd.Parameters.AddWithValue("$country", country);
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine($"{reader.GetString(0)} | {reader.GetString(1)} → {reader.GetString(2)}");
        }
    }

    static void InsertBuyer(SqliteConnection conn, string fullName, DateTime birth, string gender, string email, int countryId, int cityId)
    {
        var cmd = conn.CreateCommand();
        cmd.CommandText = @"
                INSERT INTO Buyers (FullName, BirthDate, Gender, Email, CountryId, CityId)
                VALUES ($name, $birth, $gender, $email, $cid, $city);";
        cmd.Parameters.AddWithValue("$name", fullName);
        cmd.Parameters.AddWithValue("$birth", birth.ToString("yyyy-MM-dd"));
        cmd.Parameters.AddWithValue("$gender", gender);
        cmd.Parameters.AddWithValue("$email", email);
        cmd.Parameters.AddWithValue("$cid", countryId);
        cmd.Parameters.AddWithValue("$city", cityId);
        var affected = cmd.ExecuteNonQuery();
        Console.WriteLine(affected > 0 ? "✔ Покупець доданий" : "⚠ Помилка вставки");
    }
}
