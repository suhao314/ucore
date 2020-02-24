namespace System
{
   public class OverflowException : ArithmeticException
   {
      public OverflowException();
      public OverflowException(string message);
      public OverflowException(string message, Exception innerException);
   }
}
