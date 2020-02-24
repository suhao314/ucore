namespace System.Collections
{
   public interface ICollection : IEnumerable
   {
      public int Count { get; }
      public bool IsSynchronized { get; }
      public object SyncRoot { get; }
      public void CopyTo(Array array, int index);
  }
}
