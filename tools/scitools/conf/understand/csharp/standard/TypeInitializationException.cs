namespace System
{
   public sealed class TypeInitializationException : SystemException
   {
      public TypeInitializationException(string fullTypeName,
         Exception innerException);
   }
}
