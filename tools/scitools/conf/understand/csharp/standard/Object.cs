namespace System
{
   public class Object
   {
      public Object();
      ~Object();
      public virtual bool Equals(object obj);
      public virtual int GetHashCode();
      public Type GetType();
      public virtual string ToString();
   }
}
