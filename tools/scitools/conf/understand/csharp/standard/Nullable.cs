namespace System
{
   public struct Nullable<T>
   {
      public bool HasValue { get; }
      public T Value { get; }
   }
}
