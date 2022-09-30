using System.Linq;

namespace JamToolkit.Util
{
	public static class Paths
	{
		private static string Scheme = "res://";

		public static string GetDirectoryName(string path)
		{
			var parts = WithoutRes(path).Split('/');

			return Scheme + string.Join("/", parts.Take(parts.Length - 1));
		}

		// Godot uses `/` for all platforms
		public static string Combine(string a, string b) => $"{a}/{b}";

		private static string WithoutRes(string path) =>
			path.StartsWith(Scheme) ? path.Substring(Scheme.Length) : path;
	}
}
