using System;
using System.Collections.Generic;
using OnlineCourseList.Models;
namespace OnlineCourseList
{
    public class DoublyLinkedList
    {
        private CourseNode head;
        private CourseNode tail;
        private int count;
        private CourseNode iterator;

        // г) Властивість тільки для читання — довжина списку
        public int Length => count;
        private CourseNode GetNode(int index)
        {
            if (index < 0 || index >= count)
                throw new ArgumentOutOfRangeException(nameof(index), "Індекс поза межами списку.");

            CourseNode current;
            if (index < count / 2)
            {
                current = head;
                for (int i = 0; i < index; i++) current = current.Next;
            }
            else
            {
                current = tail;
                for (int i = count - 1; i > index; i--) current = current.Prev;
            }
            return current;
        }
        // а) Метод додавання елемента В КІНЕЦЬ списку
        public void Add(CourseProgress item)
        {
            if (item == null) throw new ArgumentNullException(nameof(item));
            CourseNode newNode = new CourseNode(item);

            if (head == null)
            {
                head = tail = newNode;
            }
            else
            {
                tail.Next = newNode;
                newNode.Prev = tail;
                tail = newNode;
            }
            count++;
        }
        // б) Метод видалення елемента з n-ї позиції списку
        public void RemoveAt(int index)
        {
            if (index < 0 || index >= count)
                throw new ArgumentOutOfRangeException(nameof(index), "Індекс поза межами списку.");

            CourseNode current = GetNode(index);

            if (current.Prev != null) current.Prev.Next = current.Next;
            else head = current.Next;

            if (current.Next != null) current.Next.Prev = current.Prev;
            else tail = current.Prev;

            count--;
        }
        // в) Індексатор для читання та зміни значення
        public CourseProgress this[int index]
        {
            get => GetNode(index).Data;
            set
            {
                if (value == null) throw new ArgumentNullException(nameof(value));
                GetNode(index).Data = value;
            }
        }
        // д) Методи ітерації списку
        public CourseProgress GetFirst()
        {
            iterator = head;
            return iterator?.Data;
        }

        public CourseProgress GetNext()
        {
            if (iterator == null) return null;
            iterator = iterator.Next;
            return iterator?.Data;
        }
        // е) Метод сортування підрахунком (Counting Sort) у порядку спадання
        public void CountingSortDescending()
        {
            if (count <= 1) return;

            int max = 100;
            List<CourseProgress>[] buckets = new List<CourseProgress>[max + 1];

            for (int i = 0; i <= max; i++)
                buckets[i] = new List<CourseProgress>();
            CourseNode current = head;
            while (current != null)
            {
                int key = (int)Math.Round(current.Data.CompletionPercentage);
                if (key < 0) key = 0;
                if (key > 100) key = 100;

                buckets[key].Add(current.Data);
                current = current.Next;
            }
            current = head;
            for (int i = max; i >= 0; i--)
            {
                foreach (var courseData in buckets[i])
                {
                    current.Data = courseData;
                    current = current.Next;
                }
            }
        }
        // ж) Пошук за критерієм: Програмування + Сертифікат + Понад 90%
        public List<CourseProgress> Search()
        {
            List<CourseProgress> result = new();
            CourseNode current = head;

            while (current != null)
            {
                if (current.Data.Subject == SubjectArea.Programming &&
                    current.Data.Certified &&
                    current.Data.CompletionPercentage > 90)
                {
                    result.Add(current.Data);
                }
                current = current.Next;
            }
            return result;
        }
        public List<CourseProgress> ToList()
        {
            List<CourseProgress> list = new();
            CourseNode current = head;
            while (current != null)
            {
                list.Add(current.Data);
                current = current.Next;
            }
            return list;
        }
    }
}
