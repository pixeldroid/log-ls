package pixeldroid.util.log.printers
{

    import system.Console;
    import pixeldroid.util.log.Printer;

    /**
        Provides a console logger for use by `Log`.

        Log messages are sent to stdout via `system.Console`

        @see system.Console#print
    */
    class ConsolePrinter implements Printer
    {
        /** @copy pixeldroid.util.log.Printer */
        public function print(message:String):void
        {
            Console.print(message);
        }
    }
}
