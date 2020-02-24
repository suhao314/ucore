namespace System
{
   public class InvalidOperationException : SystemException
   {
      public InvalidOperationException();
      public InvalidOperationException(string message);
      public InvalidOperationException(string message,
                                       Exception innerException);
   }
}
