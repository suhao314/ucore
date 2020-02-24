namespace System
{
   [AttributeUsageAttribute(AttributeTargets.Class
      | AttributeTargets.Struct
      | AttributeTargets.Enum | AttributeTargets.Interface
      | AttributeTargets.Constructor | AttributeTargets.Method
      | AttributeTargets.Property | AttributeTargets.Field
      | AttributeTargets.Event | AttributeTargets.Delegate,
      Inherited = false)]
   public sealed class ObsoleteAttribute : Attribute
   {
      public ObsoleteAttribute();
      public ObsoleteAttribute(string message);
      public ObsoleteAttribute(string message, bool error);
      public bool IsError { get; }
      public string Message { get; }
   }
}
