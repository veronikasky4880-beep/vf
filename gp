using System;
using OnlineCourseList.Models;
using OnlineCourseList.Serialization;
namespace OnlineCourseList
{
    internal class Program
    {
        private static DoublyLinkedList _list = new DoublyLinkedList();
        private static string _filePath = "courses.json";
        static void Main()
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            _list.Add(new CourseProgress { Subject = SubjectArea.Programming, CompletionPercentage = 95.4, Certified = true });
            _list.Add(new CourseProgress { Subject = SubjectArea.Design, CompletionPercentage = 80.0, Certified = false });
            _list.Add(new CourseProgress { Subject = SubjectArea.Programming, CompletionPercentage = 91.2, Certified = true });
            _list.Add(new CourseProgress { Subject = SubjectArea.Marketing, CompletionPercentage = 85.5, Certified = true });

            bool running = true;
            while (running)
            {
                Console.Clear();
                Console.WriteLine("=== АКТУАЛЬНИЙ СТАН СПИСКУ (ТАБЛИЦЯ) ===");
                PrintTable();

                Console.WriteLine("\n=== КОНСОЛЬНЕ МЕНЮ (Варіант 21) ===");
                Console.WriteLine("1. Додати курс в кінець списку");
                Console.WriteLine("2. Видалити курс з n-ї позиції");
                Console.WriteLine("3. Змінити значення за індексом (Індексатор)");
                Console.WriteLine("4. Пошук за критерієм (Programming, Certified, > 90%)");
                Console.WriteLine("5. Сортування за спаданням відсотка (Counting Sort)");
                Console.WriteLine("6. Серіалізація списку в JSON файл");
                Console.WriteLine("7. Десеріалізація списку з JSON файлу");
                Console.WriteLine("8. Демонстрація ітератора (GetFirst / GetNext)");
                Console.WriteLine("0. Вихід");
                Console.Write("\nОберіть дію: ");

                string choice = Console.ReadLine();
                try
                {
                    switch (choice)
                    {
                        case "1":
                            Console.WriteLine("\n--- Введення нових даних курсу ---");
                            _list.Add(ReadCourse());
                            break;
                        case "2":
                            Console.Write("\nВведіть n-позицію для видалення: ");
                            int delIdx = ReadInt();
                            _list.RemoveAt(delIdx);
                            break;
                        case "3":
                            Console.Write("\nВведіть індекс для редагування через індексатор: ");
                            int editIdx = ReadInt();
                            if (editIdx < 0 || editIdx >= _list.Length)
                                throw new ArgumentOutOfRangeException(nameof(editIdx), "Індекс поза межами списку.");

                            Console.WriteLine("Введіть нові дані:");
                            _list[editIdx] = ReadCourse();
                            break;
                        case "4":
                            Console.WriteLine("\n--- РЕЗУЛЬТАТИ ПОШУКУ ЗА КРИТЕРІЄМ ---");
                            var results = _list.Search();
                            if (results.Count == 0) Console.WriteLine("Жоден курс не відповідає критеріям.");
                            else
                            {
                                Console.WriteLine($"{"Предмет",-15} | {"Відсоток",-12} | {"Сертифікат",-10}");
                                Console.WriteLine(new string('-', 45));
                                foreach (var item in results) Console.WriteLine(item);
                            }
                            WaitForKey();
                            break;
                        case "5":
                            _list.CountingSortDescending();
                            Console.WriteLine("\nСписок відсортовано за спаданням!");
                            WaitForKey();
                            break;
                        case "6":
                            CourseListSerializer.SaveToFile(_filePath, _list.ToList());
                            Console.WriteLine($"\nДані успішно збережено у файл '{_filePath}'.");
                            WaitForKey();
                            break;
                        case "7":
                            var importedData = CourseListSerializer.LoadFromFile(_filePath);
                            _list = new DoublyLinkedList();
                            foreach (var itemData in importedData) _list.Add(itemData);
                            Console.WriteLine($"\nДані успішно відновлено з файлу '{_filePath}'!");
                            WaitForKey();
                            break;
                        case "8":
                            Console.WriteLine("\n--- ПОКРОКОВИЙ ОБХІД СПИСКУ ІТЕРАТОРОМ ---");
                            var currentCourse = _list.GetFirst();
                            int iterIdx = 0;
                            while (currentCourse != null)
                            {
                                Console.WriteLine($"Ітератор на позиції [{iterIdx++}]: {currentCourse}");
                                currentCourse = _list.GetNext();
                            }
                            WaitForKey();
                            break;
                        case "0":
                            running = false;
                            break;
                        default:
                            Console.WriteLine("\nПомилка: Невідомий пункт меню.");
                            WaitForKey();
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"\nОБРОБКА ВИКЛЮЧЕННЯ: {ex.Message}");
                    Console.ResetColor();
                    WaitForKey();
                }
            }
        }
        static void PrintTable()
        {
            Console.WriteLine(new string('-', 50));
            Console.WriteLine($"{"Індекс",-6} | {"Предмет",-15} | {"Відсоток",-12} | {"Сертифікат",-10}");
            Console.WriteLine(new string('-', 50));
            for (int i = 0; i < _list.Length; i++)
            {
                Console.WriteLine($"{i,-6} | {_list[i]}");
            }
            Console.WriteLine(new string('-', 50));
            Console.WriteLine($"Поточна довжина списку: {_list.Length}");
        }

        static int ReadInt()
        {
            int result;
            while (!int.TryParse(Console.ReadLine(), out result))
            {
                Console.Write("Помилка! Введіть ціле число: ");
            }
            return result;
        }
        static CourseProgress ReadCourse()
        {
            var subjects = Enum.GetValues(typeof(SubjectArea));
            Console.WriteLine("Оберіть предметну область:");
            for (int i = 0; i < subjects.Length; i++)
                Console.WriteLine($"  {i}. {subjects.GetValue(i)}");

            Console.Write("Введіть номер предмета: ");
            int subIdx = ReadInt();
            while (subIdx < 0 || subIdx >= subjects.Length)
            {
                Console.Write($"Оберіть число від 0 до {subjects.Length - 1}: ");
                subIdx = ReadInt();
            }

            Console.Write("Введіть відсоток завершення (0 - 100): ");
            double percent;
            while (!double.TryParse(Console.ReadLine(), out percent) || percent < 0 || percent > 100)
            {
                Console.Write("Некоректно. Введіть число від 0 до 100: ");
            }
            Console.Write("Має сертифікат? (1 — так, 0 — ні): ");
            string certInput = Console.ReadLine()?.Trim();
            while (certInput != "1" && certInput != "0")
            {
                Console.Write("Введіть 1 або 0: ");
                certInput = Console.ReadLine()?.Trim();
            }
            return new CourseProgress
            {
                Subject = (SubjectArea)subjects.GetValue(subIdx),
                CompletionPercentage = percent,
                Certified = certInput == "1"
            };
        }
        static void WaitForKey()
        {
            Console.WriteLine("\nНатисніть будь-яку клавішу...");
            Console.ReadKey();
        }
    }
}
