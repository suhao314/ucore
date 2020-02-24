namespace System.Diagnostics
{
   [AttributeUsageAttribute(AttributeTargets.Method
      | AttributeTargets.Class, AllowMultiple = true)]
   public sealed class ConditionalAttribute : Attribute
   {
      public ConditionalAttribute(string conditionString);
      public string ConditionString { get; }
   }
}
