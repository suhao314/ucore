namespace System.Collections.Generic
{
   public interface IEnumerator<T> : IDisposable, IEnumerator
   { 
      public T Current { get; }
   }
}
