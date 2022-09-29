using System;
using System.Diagnostics;

namespace JamToolkit.Util
{
	public static class Assert
	{
		[DebuggerHidden]
		public static void NotNull<T>(T value, string message = "")
		{
			if (value != null) return;

			Fail(message);
		}

		[DebuggerHidden]
		public static void True(bool value, string message = "")
		{
			if (value) return;

			Fail(message);
		}

		[DebuggerHidden]
		public static void Fail(string message = "")
		{
			if (message == "") throw new ApplicationException();

			throw new ApplicationException(message);
		}
	}
}
