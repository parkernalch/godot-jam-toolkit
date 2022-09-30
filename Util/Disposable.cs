using System;

namespace JamToolkit.Util
{
    public static class Disposable
    {
        public static IDisposable Create(Action action) => new ActionDisposable(action);

        class ActionDisposable : IDisposable
        {
            private readonly Action _action;

            public ActionDisposable(Action action)
            {
                _action = action ?? throw new ArgumentNullException(nameof(action));
            }


            public void Dispose()
            {
                _action();
            }
        }
    }
}