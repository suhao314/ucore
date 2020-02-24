namespace System.Collections
{
   public interface IList : ICollection, IEnumerable
   {
      public bool IsFixedSize { get; }
      public bool IsReadOnly { get; }
      public object this[int index] { get; set; }
      public int Add(object value);
      public void Clear();
      public bool Contains(object value);
      public int IndexOf(object value);
      public void Insert(int index, object value);
      public void Remove(object value);
      public void RemoveAt(int index);
   }
}
