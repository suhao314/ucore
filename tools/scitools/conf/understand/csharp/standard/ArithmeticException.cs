namespace System
{
   public class ArithmeticException : SystemException
   {
      public ArithmeticException();
      public ArithmeticException(string message);
      public ArithmeticException(string message, Exception innerException);
   }
}