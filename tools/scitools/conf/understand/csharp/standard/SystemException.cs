namespace System
{
   public class SystemException : Exception
   {
      public SystemException();
      public SystemException(string message);
      public SystemException(string message, Exception innerException);
   }
}
