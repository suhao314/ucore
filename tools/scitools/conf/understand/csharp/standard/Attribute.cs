namespace System
{
   [AttributeUsageAttribute(AttributeTargets.All, Inherited = true,
      AllowMultiple = false)]
    public abstract class Attribute
   {
      protected Attribute();
   }
}