namespace System
{
   public class InvalidCastException : SystemException
   {
      public InvalidCastException();
      public InvalidCastException(string message);
      public InvalidCastException(string message, Exception innerException);
   }
}