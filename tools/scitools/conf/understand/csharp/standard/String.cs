namespace System
{
   using System.Collections;
   using System.Collections.Generic;
   public sealed class String : IEnumerable<Char>, IEnumerable
   {
      public int Length { get; }
      public char this[int index] { get; }
   }
}
