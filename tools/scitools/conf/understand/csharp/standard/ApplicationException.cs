namespace System
{
   public class ApplicationException : Exception
   {
      public ApplicationException();
      public ApplicationException(string message);
      public ApplicationException(string message, Exception innerException);
   }
}