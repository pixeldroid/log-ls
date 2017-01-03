package
{
    import pixeldroid.util.Log;
    import pixeldroid.util.log.Formatter;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.Printer;


    public final class LogStatePreserver
    {
        public static function wrap(test:Function):Function
        {
            // ensure isolation of global state changes

            var f:Function = function():void
            {
                var lastFormatter:Formatter = Log.formatter;
                var lastLevel:LogLevel = Log.level;
                var lastPrinter:Printer = Log.printer;

                test();

                Log.formatter = lastFormatter;
                Log.level = lastLevel;
                Log.printer = lastPrinter;
            };

            return f;
        }
    }
}
