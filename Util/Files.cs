using System;
using Godot;

namespace JamToolkit.Util
{
    public static class Files
    {
        public static IDisposable OpenSafe(this File file, string path, File.ModeFlags mode)
        {
            file.Open(path, mode);
            return Disposable.Create(file.Close);
        }

        public static string ReadAllText(string path)
        {
            var file = new File();
            using (file.OpenSafe(path, File.ModeFlags.Read))
            {
                return file.GetAsText();
            }
        }
    }
}