using System;
using Godot;

namespace JamToolkit.Util
{
    public static class NodeExtensions
    {
        /// <summary>
        /// Get the root node
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        public static Node GetRootNode(this Node node)
        {
            var parent = node;
            while (true)
            {
                var p = parent.GetParent();
                if (p == null)
                    return parent;

                parent = p;
            }
        }

        /// <summary>
        /// Find an instance of the type T from the root node
        /// </summary>
        /// <param name="node"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static T FindSingleton<T>(this Node node) where T : Node =>
            node.GetRootNode().FindChild<T>();

        public static T LoadRelative<T>(this Node node, string path) where T : class
        {
            var basePath = Paths.GetDirectoryName(((Resource)node.GetScript()).ResourcePath);
            var resourcePath = Paths.Combine(basePath, path);
            return ResourceLoader.Load<T>(resourcePath);
        }

        public static Resource LoadRelative(this Node node, string path)
        {
            var basePath = Paths.GetDirectoryName(((Resource)node.GetScript()).ResourcePath);
            var resourcePath = Paths.Combine(basePath, path);
            return ResourceLoader.Load(resourcePath);
        }

        public static Node FindChildByName(this Node node, string name) => node.FindChild(child => child.Name == name);

        public static Node FindChild(this Node node, Predicate<Node> predicate)
        {
            for (var j = 0; j < node.GetChildCount(); j++)
            {
                var child = node.GetChild(j);
                if (predicate(child))
                {
                    return child;
                }
            }

            // couldn't find the child so search the next level deeper
            for (var j = 0; j < node.GetChildCount(); j++)
            {
	            var child = node.GetChild(j);
                var found = child.FindChild(predicate);

                if (found != null)
                {
                    return found;
                }
            }

            return null;
        }

        public static T FindChildByName<T>(this Node node, string name) where T: Node =>
            node.FindChild<T>(child => child.Name == name);

        public static T FindChild<T>(this Node node) where T : Node =>
            node.FindChild(child => child is T) as T;

        public static T FindChild<T>(this Node node, Predicate<T> predicate) where T : Node =>
            node.FindChild(child => child is T t && predicate(t)) as T;
    }
}
