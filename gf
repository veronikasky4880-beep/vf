using System;

namespace OnlineCourseList.Models
{
    public class CourseProgress
    {
        public SubjectArea Subject { get; set; }
        public double CompletionPercentage { get; set; } // Компонент 2: Відсоток завершення (дійсне число)
        public bool Certified { get; set; }              // Компонент 3: Наявність сертифіката (bool)
        public override string ToString()
        {
            return $"{Subject,-15} | {CompletionPercentage,-12:F1} | {(Certified ? "Так" : "Ні"),-10}";
        }
    }
}
