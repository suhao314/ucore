namespace System
{
   public class OutOfMemoryException : SystemException
   {
      public OutOfMemoryException();
      public OutOfMemoryException(string message);
      public OutOfMemoryException(string message, Exception innerException);
   }
}
