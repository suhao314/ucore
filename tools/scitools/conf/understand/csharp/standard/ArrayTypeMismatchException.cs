namespace System
{
   public class ArrayTypeMismatchException : SystemException
   {
      public ArrayTypeMismatchException();
      public ArrayTypeMismatchException(string message);
      public ArrayTypeMismatchException(string message,
         Exception innerException);
   }
}