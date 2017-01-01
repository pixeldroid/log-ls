package pixeldroid.util.log
{

    import system.Console;

    /**
        Provides a simple console logger for use by Log.

        Log messages are sent to stdout via system.Console:

        @see system.Console#print
    */
    class ConsolePrinter implements Printer
    {
        public function print(message:String):void
        {
            Console.print(message);
        }
    }
}
