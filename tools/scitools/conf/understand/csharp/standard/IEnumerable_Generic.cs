namespace System.Collections.Generic
{
   public interface IEnumerable<T> : IEnumerable
   {
      public IEnumerator<T> GetEnumerator();
   }
}
