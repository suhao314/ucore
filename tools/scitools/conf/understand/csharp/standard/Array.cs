namespace System
{
   using System.Collections;
   public abstract class Array : IList, ICollection, IEnumerable
   {
      public int Length { get; }
      public int Rank { get; }
      public int GetLength(int dimension);
   }
}
