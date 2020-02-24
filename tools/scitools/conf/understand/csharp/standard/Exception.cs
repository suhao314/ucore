namespace System
{
   public class Exception
   {
      public Exception();
      public Exception(string message);
      public Exception(string message, Exception innerException);
      public sealed Exception InnerException { get; }
      public virtual string Message { get; }
   }
}
